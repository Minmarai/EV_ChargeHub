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
 */
public class ContactDAO {

 /**
  * Inserts a new contact message into the {@code contact_messages} table.
  *
  * <p>The message is stored with a default status of {@code "unread"}
  * as defined by the database schema.</p>
  *
  * @param name    the full name of the person submitting the message
  * @param email   the email address of the sender
  * @param subject the subject line of the message
  * @param message the body content of the contact message
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
  * <p>Typical keys include: {@code message_id}, {@code name}, {@code email},
  * {@code subject}, {@code message}, {@code status}.</p>
  *
  * @return a {@link List} of {@link Map} objects representing all contact messages;
  *         returns an empty list if no records exist or an error occurs
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
  * Marks a contact message as {@code "read"} by updating its status field.
  *
  * @param id the unique ID of the contact message to mark as read
  * @return {@code true} if the update affected at least one row; {@code false} otherwise
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
  * Permanently deletes a contact message from the database.
  *
  * <p><strong>Note:</strong> This operation is irreversible.
  * Consider using {@link #markRead(int)} for soft status updates instead.</p>
  *
  * @param id the unique ID of the contact message to delete
  * @return {@code true} if the deletion was successful; {@code false} if no record
  *         was found with the given ID or if an error occurs
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