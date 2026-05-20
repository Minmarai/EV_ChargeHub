package com.chargehub.dao;

import com.chargehub.util.DBConnection;
import java.sql.*;
import java.util.*;

/**
 * Data Access Object (DAO) for managing user reviews of charging stations.
 *
 * <p>Provides operations to retrieve, add, moderate, and delete records
 * from the {@code reviews} table.</p>
 *
 * <p>Results are returned as {@link List}&lt;{@link Map}&lt;{@link String}, {@link Object}&gt;&gt;
 * rather than a model class, with column names as keys and row values as {@link Object} instances.</p>
 *
 * <p>All database connections are obtained via {@link DBConnection#getConnection()}
 * and are closed automatically using try-with-resources.</p>
 *
 * <p>Author: Rijam Shrestha</p>
 */
public class ReviewDAO {

 /**
  * Retrieves all reviews across all stations, regardless of visibility status,
  * ordered by review ID descending.
  *
  * <p>Intended for administrative use where all reviews — including hidden ones —
  * must be visible for moderation purposes.</p>
  *
  * <p>Typical map keys include: {@code review_id}, {@code user_id}, {@code station_id},
  * {@code rating}, {@code comment}, {@code status}, {@code full_name},
  * {@code station_name}.</p>
  *
  * @return a {@link List} of {@link Map} objects representing all reviews;
  *         returns an empty list if none exist or an error occurs
  */
 public List<Map<String, Object>> findAll() {
  return query(
          "SELECT r.*, u.full_name, s.station_name " +
                  "FROM reviews r " +
                  "JOIN users u ON r.user_id = u.user_id " +
                  "JOIN stations s ON r.station_id = s.station_id " +
                  "ORDER BY r.review_id DESC"
  );
 }

 /**
  * Retrieves all {@code "visible"} reviews for a specific charging station,
  * ordered by review ID descending.
  *
  * <p>Only reviews with {@code status = 'visible'} are included, making this
  * method safe for public-facing display. Hidden or moderated reviews are excluded.</p>
  *
  * <p>Typical map keys include: {@code review_id}, {@code user_id}, {@code station_id},
  * {@code rating}, {@code comment}, {@code status}, {@code full_name},
  * {@code station_name}.</p>
  *
  * @param stationId the ID of the station whose visible reviews are to be retrieved
  * @return a {@link List} of {@link Map} objects representing visible reviews
  *         for the given station; returns an empty list if none exist or an error occurs
  */
 public List<Map<String, Object>> findByStation(int stationId) {
  return query(
          "SELECT r.*, u.full_name, s.station_name " +
                  "FROM reviews r " +
                  "JOIN users u ON r.user_id = u.user_id " +
                  "JOIN stations s ON r.station_id = s.station_id " +
                  "WHERE r.station_id=" + stationId + " AND r.status='visible' " +
                  "ORDER BY r.review_id DESC"
  );
 }

 /**
  * Retrieves all reviews submitted by a specific user across all stations,
  * ordered by review ID descending.
  *
  * <p>Unlike {@link #findByStation(int)}, this method returns reviews of
  * <em>all</em> statuses (e.g., {@code "visible"}, {@code "hidden"}),
  * making it suitable for user profile pages or account history views
  * where the user should see their own full review history.</p>
  *
  * <p>Typical map keys include: {@code review_id}, {@code user_id}, {@code station_id},
  * {@code rating}, {@code comment}, {@code status}, {@code full_name},
  * {@code station_name}.</p>
  *
  * @param userId the ID of the user whose reviews are to be retrieved
  * @return a {@link List} of {@link Map} objects representing all reviews by the
  *         given user; returns an empty list if none exist or an error occurs
  */
 public List<Map<String, Object>> findByUser(int userId) {
  return query(
          "SELECT r.*, u.full_name, s.station_name " +
                  "FROM reviews r " +
                  "JOIN users u ON r.user_id = u.user_id " +
                  "JOIN stations s ON r.station_id = s.station_id " +
                  "WHERE r.user_id=" + userId + " " +
                  "ORDER BY r.review_id DESC"
  );
 }

 /**
  * Executes a raw SQL query and maps each resulting row to a {@link Map}.
  *
  * <p>Column names are derived dynamically from
  * {@link ResultSetMetaData#getColumnLabel(int)}, so the returned
  * map keys reflect the actual column labels in the query result.</p>
  *
  * <p><strong>Warning — SQL Injection Risk:</strong> Although this method uses
  * {@link PreparedStatement} internally, the SQL string is passed in fully
  * pre-assembled and is <em>not</em> parameterized at this level. Any dynamic
  * values (e.g., {@code stationId}, {@code userId}) are interpolated by callers
  * via string concatenation before being passed here. Callers such as
  * {@link #findByStation(int)} and {@link #findByUser(int)} must therefore
  * ensure their inputs are validated or sanitized to prevent SQL injection.</p>
  *
  * <p><strong>Recommended fix:</strong> Refactor callers to pass bind parameters
  * separately, and update this method to accept an {@code Object[]} varargs
  * parameter for safe value binding via {@link PreparedStatement#setObject(int, Object)}.</p>
  *
  * @param sql the fully assembled SQL query string to execute; must not contain
  *            unsanitized user-supplied values
  * @return a {@link List} of {@link Map} objects where each map represents one row,
  *         keyed by column label; returns an empty list on error or if no rows match
  */
 private List<Map<String, Object>> query(String sql) {
  List<Map<String, Object>> list = new ArrayList<>();
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
  * Inserts a new review for a charging station submitted by a user.
  *
  * <p>The review is stored with a default status of {@code "visible"} or
  * {@code "pending"} as defined by the database schema, and the review
  * date defaults to the current timestamp.</p>
  *
  * @param userId    the ID of the user submitting the review
  * @param stationId the ID of the station being reviewed
  * @param rating    the rating score given by the user (typically {@code 1} to {@code 5})
  * @param comment   the textual feedback provided by the user
  * @return {@code true} if the review was successfully inserted; {@code false} otherwise
  */
 public boolean add(int userId, int stationId, int rating, String comment) {
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(
               "INSERT INTO reviews(user_id, station_id, rating, comment) VALUES(?, ?, ?, ?)")) {
   ps.setInt(1, userId);
   ps.setInt(2, stationId);
   ps.setInt(3, rating);
   ps.setString(4, comment);
   return ps.executeUpdate() > 0;
  } catch (SQLException e) {
   e.printStackTrace();
   return false;
  }
 }

 /**
  * Updates the moderation status of a review.
  *
  * <p>Common status values include {@code "visible"} (publicly shown)
  * and {@code "hidden"} (suppressed from public display).</p>
  *
  * <p>This is the preferred method for moderation — use it instead of
  * {@link #delete(int)} when a review should be suppressed but retained
  * for audit purposes.</p>
  *
  * @param id     the unique ID of the review to update
  * @param status the new moderation status to apply
  * @return {@code true} if the update affected at least one row; {@code false} otherwise
  */
 public boolean updateStatus(int id, String status) {
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(
               "UPDATE reviews SET status=? WHERE review_id=?")) {
   ps.setString(1, status);
   ps.setInt(2, id);
   return ps.executeUpdate() > 0;
  } catch (SQLException e) {
   e.printStackTrace();
   return false;
  }
 }

 /**
  * Permanently deletes a review from the database.
  *
  * <p><strong>Note:</strong> This operation is irreversible. Consider using
  * {@link #updateStatus(int, String)} with a status of {@code "hidden"} as a
  * safer, non-destructive alternative for moderation.</p>
  *
  * @param id the unique ID of the review to delete
  * @return {@code true} if the deletion was successful; {@code false} if no record
  *         was found with the given ID or an error occurs
  */
 public boolean delete(int id) {
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(
               "DELETE FROM reviews WHERE review_id=?")) {
   ps.setInt(1, id);
   return ps.executeUpdate() > 0;
  } catch (SQLException e) {
   e.printStackTrace();
   return false;
  }
 }
}
