package com.chargehub.dao;

import com.chargehub.util.DBConnection;
import java.sql.*;
import java.util.*;

/**
 * Data Access Object (DAO) for managing contact messages submitted via the contact form.
 *
 * <p>Provides operations to insert, retrieve, update, and delete records
 * from the {@code contact_messages} table.</p>
 *
 * <p>All database connections are obtained via {@link DBConnection#getConnection()}
 * and are closed automatically using try-with-resources.</p>
 *
 * <p>The {@code contact_messages} table is expected to have at least the following columns:</p>
 * <ul>
 *   <li>{@code message_id} — auto-incremented primary key</li>
 *   <li>{@code name} — full name of the sender</li>
 *   <li>{@code email} — email address of the sender</li>
 *   <li>{@code subject} — subject line of the message</li>
 *   <li>{@code message} — body content of the message</li>
 *   <li>{@code status} — read/unread state; defaults to {@code "unread"} on insert</li>
 * </ul>
 *
 * <p>Typical usage flow:</p>
 * <ol>
 *   <li>A visitor submits the contact form → {@link #add(String, String, String, String)}</li>
 *   <li>An admin lists all messages → {@link #findAll()}</li>
 *   <li>Admin reads a message → {@link #markRead(int)}</li>
 *   <li>Admin removes a message → {@link #delete(int)}</li>
 * </ol>
 *
 * <p>Author: Rijam Shrestha</p>
 */
public class ContactDAO {

 /**
  * Inserts a new contact message into the {@code contact_messages} table.
  *
  * <p>The message is stored with a default status of {@code "unread"}
  * as defined by the database schema. No validation is performed on the
  * input values — callers are responsible for sanitizing fields before
  * passing them to this method.</p>
  *
  * @param name    the full name of the person submitting the message;
  *                must not be {@code null} or empty
  * @param email   the email address of the sender used for reply purposes;
  *                must not be {@code null} or empty
  * @param subject the subject line summarizing the message topic;
  *                must not be {@code null} or empty
  * @param message the full body content of the contact message;
  *                must not be {@code null} or empty
  * @return {@code true} if the record was successfully inserted; {@code false} otherwise
  */
 public boolean add(String name, String email, String subject, String message) {
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(
               "INSERT INTO contact_messages(name, email, subject, message) VALUES(?, ?, ?, ?)")) {
   ps.setString(1, name);
   ps.setString(2, email);
   ps.setString(3, subject);
   ps.setString(4, message);
   return ps.executeUpdate() > 0;
  } catch (SQLException e) {
   e.printStackTrace();
   return false;
  }
 }

 /**
  * Retrieves all contact messages from the database, ordered by message ID descending.
  *
  * <p>Each message is represented as a {@link Map} where keys are column names
  * (as returned by {@link java.sql.ResultSetMetaData#getColumnLabel(int)})
  * and values are the corresponding column data as {@link Object} instances.</p>
  *
  * <p>Typical keys present in each map include:</p>
  * <ul>
  *   <li>{@code message_id} — the unique identifier of the message ({@link Integer})</li>
  *   <li>{@code name} — the sender's full name ({@link String})</li>
  *   <li>{@code email} — the sender's email address ({@link String})</li>
  *   <li>{@code subject} — the message subject ({@link String})</li>
  *   <li>{@code message} — the message body ({@link String})</li>
  *   <li>{@code status} — current read state, either {@code "read"} or {@code "unread"} ({@link String})</li>
  * </ul>
  *
  * <p>The use of {@link Map} allows this method to remain flexible to schema changes
  * without requiring a dedicated model class for contact messages.</p>
  *
  * @return a {@link List} of {@link Map} objects representing all contact messages,
  *         sorted newest-first by {@code message_id};
  *         returns an empty list if no records exist or a {@link SQLException} occurs
  * @see #markRead(int)
  * @see #delete(int)
  */
 public List<Map<String, Object>> findAll() {
  List<Map<String, Object>> list = new ArrayList<>();
  String sql = "SELECT * FROM contact_messages ORDER BY message_id DESC";
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(sql)) {
   ResultSet rs = ps.executeQuery();
   ResultSetMetaData md = rs.getMetaData();
   while (rs.next()) {
    Map<String, Object> row = new HashMap<>();
    for (int i = 1; i <= md.getColumnCount(); i++)
     row.put(md.getColumnLabel(i), rs.getObject(i));
    list.add(row);
   }
  } catch (SQLException e) {
   e.printStackTrace();
  }
  return list;
 }

 /**
  * Marks a contact message as {@code "read"} by updating its {@code status} field.
  *
  * <p>This is a non-destructive status update intended for use when an admin
  * opens or acknowledges a message. The message record remains in the database
  * and can still be retrieved via {@link #findAll()}.</p>
  *
  * <p>If no message exists with the given {@code id}, the update affects zero
  * rows and {@code false} is returned without throwing an exception.</p>
  *
  * @param id the unique ID of the contact message to mark as read;
  *           must correspond to an existing {@code message_id} in the table
  * @return {@code true} if the update affected at least one row; {@code false} otherwise
  * @see #delete(int)
  */
 public boolean markRead(int id) {
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(
               "UPDATE contact_messages SET status='read' WHERE message_id=?")) {
   ps.setInt(1, id);
   return ps.executeUpdate() > 0;
  } catch (SQLException e) {
   e.printStackTrace();
   return false;
  }
 }

 /**
  * Permanently deletes a contact message from the {@code contact_messages} table.
  *
  * <p><strong>Warning:</strong> This operation is irreversible and removes the record
  * entirely from the database. If the intent is only to acknowledge a message without
  * removing it, use {@link #markRead(int)} instead.</p>
  *
  * <p>If no message exists with the given {@code id}, the delete affects zero rows
  * and {@code false} is returned without throwing an exception.</p>
  *
  * @param id the unique ID of the contact message to permanently delete;
  *           must correspond to an existing {@code message_id} in the table
  * @return {@code true} if the deletion was successful and at least one row was removed;
  *         {@code false} if no record was found with the given ID or if an error occurs
  * @see #markRead(int)
  */
 public boolean delete(int id) {
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(
               "DELETE FROM contact_messages WHERE message_id=?")) {
   ps.setInt(1, id);
   return ps.executeUpdate() > 0;
  } catch (SQLException e) {
   e.printStackTrace();
   return false;
  }
 }
}
