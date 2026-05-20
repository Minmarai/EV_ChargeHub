package com.chargehub.dao;

import com.chargehub.model.Payment;
import com.chargehub.util.DBConnection;
import java.sql.*;
import java.math.BigDecimal;
import java.util.*;

/**
 * Data Access Object (DAO) for managing {@link Payment} entities.
 *
 * <p>Provides operations to create, retrieve, and update payment records
 * from the {@code payments} table, including aggregated revenue queries.</p>
 *
 * <p>Read queries join {@code payments} with {@code users}, {@code bookings},
 * and {@code stations} to enrich results with user and station context.</p>
 *
 * <p>All database connections are obtained via {@link DBConnection#getConnection()}
 * and are closed automatically using try-with-resources.</p>
 *
 * <p>Author: Denisha Tamang</p>
 */
public class PaymentDAO {

 /**
  * Base SQL query joining payments with users, bookings, and stations.
  * Used as a foundation for all read queries in this DAO.
  */
 private String base = "SELECT p.*, u.full_name, st.station_name " +
         "FROM payments p " +
         "JOIN users u ON p.user_id = u.user_id " +
         "JOIN bookings b ON p.booking_id = b.booking_id " +
         "JOIN stations st ON b.station_id = st.station_id";

 /**
  * Maps a {@link ResultSet} row to a {@link Payment} object.
  *
  * @param rs the {@link ResultSet} positioned at the current row
  * @return a fully populated {@link Payment} instance
  * @throws SQLException if any column cannot be read from the result set
  */
 private Payment map(ResultSet rs) throws SQLException {
  Payment p = new Payment();
  p.setPaymentId(rs.getInt("payment_id"));
  p.setBookingId(rs.getInt("booking_id"));
  p.setUserId(rs.getInt("user_id"));
  p.setAmount(rs.getBigDecimal("amount"));
  p.setPaymentMethod(rs.getString("payment_method"));
  p.setPaymentStatus(rs.getString("payment_status"));
  p.setTransactionReference(rs.getString("transaction_reference"));
  p.setPaymentDate(rs.getTimestamp("payment_date"));
  p.setRemarks(rs.getString("remarks"));
  p.setUserName(rs.getString("full_name"));
  p.setStationName(rs.getString("station_name"));
  return p;
 }

 /**
  * Inserts a new payment record into the {@code payments} table.
  *
  * <p>The payment date is not explicitly set here and defaults to the
  * current timestamp as defined by the database schema.</p>
  *
  * <p>Common values for {@code paymentStatus} include {@code "pending"},
  * {@code "paid"}, and {@code "failed"}.</p>
  *
  * @param p the {@link Payment} object containing booking ID, user ID, amount,
  *          payment method, payment status, transaction reference, and optional remarks
  * @return {@code true} if the record was successfully inserted; {@code false} otherwise
  */
 public boolean create(Payment p) {
  String sql = "INSERT INTO payments(booking_id, user_id, amount, payment_method, " +
          "payment_status, transaction_reference, remarks) VALUES(?, ?, ?, ?, ?, ?, ?)";
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(sql)) {
   ps.setInt(1, p.getBookingId());
   ps.setInt(2, p.getUserId());
   ps.setBigDecimal(3, p.getAmount());
   ps.setString(4, p.getPaymentMethod());
   ps.setString(5, p.getPaymentStatus());
   ps.setString(6, p.getTransactionReference());
   ps.setString(7, p.getRemarks());
   return ps.executeUpdate() > 0;
  } catch (SQLException e) {
   e.printStackTrace();
   return false;
  }
 }

 /**
  * Retrieves all payment records from the database, ordered by payment ID descending.
  *
  * @return a {@link List} of all {@link Payment} objects; empty list if none found
  */
 public List<Payment> findAll() {
  return query(base + " ORDER BY p.payment_id DESC");
 }

 /**
  * Retrieves all payments made by a specific user.
  *
  * @param userId the ID of the user whose payments are to be fetched
  * @return a {@link List} of {@link Payment} objects for the given user;
  *         empty list if no payments exist
  */
 public List<Payment> findByUser(int userId) {
  return query(base + " WHERE p.user_id=" + userId + " ORDER BY p.payment_id DESC");
 }

 public List<String> findStatusesByUser(int userId) {
  List<String> list = new ArrayList<>();
  String sql = "SELECT DISTINCT LOWER(TRIM(payment_status)) payment_status FROM payments " +
          "WHERE user_id=? AND payment_status IS NOT NULL AND TRIM(payment_status)<>'' " +
          "ORDER BY CASE LOWER(TRIM(payment_status)) " +
          "WHEN 'paid' THEN 1 WHEN 'pending' THEN 2 WHEN 'failed' THEN 3 WHEN 'refunded' THEN 4 ELSE 5 END, " +
          "LOWER(TRIM(payment_status))";
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(sql)) {
   ps.setInt(1, userId);
   ResultSet rs = ps.executeQuery();
   while (rs.next()) list.add(rs.getString("payment_status"));
  } catch (SQLException e) {
   e.printStackTrace();
  }
  return list;
 }

 /**
  * Retrieves all payments for bookings at stations managed by a specific manager.
  *
  * @param managerId the ID of the station manager
  * @return a {@link List} of {@link Payment} objects for the manager's stations;
  *         empty list if no payments found
  */
 public List<Payment> findByManager(int managerId) {
  return query(base + " WHERE st.manager_id=" + managerId + " ORDER BY p.payment_id DESC");
 }

 /**
  * Executes a raw SQL query and maps each resulting row to a {@link Payment}.
  *
  * <p><strong>Note:</strong> This method executes the provided SQL string directly
  * without parameterization. Callers must ensure the SQL is safe to prevent
  * SQL injection vulnerabilities.</p>
  *
  * @param sql the SQL query string to execute
  * @return a {@link List} of mapped {@link Payment} objects; empty list on error or no results
  */
 private List<Payment> query(String sql) {
  List<Payment> list = new ArrayList<>();
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(sql)) {
   ResultSet rs = ps.executeQuery();
   while (rs.next()) list.add(map(rs));
  } catch (SQLException e) {
   e.printStackTrace();
  }
  return list;
 }

 /**
  * Finds a single payment record by its unique ID.
  *
  * @param id the payment ID to search for
  * @return the matching {@link Payment}, or {@code null} if not found
  */
 public Payment findById(int id) {
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(base + " WHERE p.payment_id=?")) {
   ps.setInt(1, id);
   ResultSet rs = ps.executeQuery();
   if (rs.next()) return map(rs);
  } catch (SQLException e) {
   e.printStackTrace();
  }
  return null;
 }

 /**
  * Updates the status of an existing payment record.
  *
  * <p>Common status values include {@code "pending"}, {@code "paid"},
  * and {@code "failed"}.</p>
  *
  * @param id     the ID of the payment to update
  * @param status the new payment status string to apply
  * @return {@code true} if the update affected at least one row; {@code false} otherwise
  */
 public boolean updateStatus(int id, String status) {
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(
               "UPDATE payments SET payment_status=? WHERE payment_id=?")) {
   ps.setString(1, status);
   ps.setInt(2, id);
   return ps.executeUpdate() > 0;
  } catch (SQLException e) {
   e.printStackTrace();
   return false;
  }
 }

 /**
  * Calculates the total amount collected from all payments with a status of {@code "paid"}.
  *
  * <p>Uses {@code COALESCE(SUM(amount), 0)} in the query to ensure {@link BigDecimal#ZERO}
  * is returned when no paid payments exist, rather than {@code null}.</p>
  *
  * @return the total paid amount as a {@link BigDecimal}; returns {@link BigDecimal#ZERO}
  *         if no paid payments exist or an error occurs
  */
 public BigDecimal totalPaid() {
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(
               "SELECT COALESCE(SUM(amount), 0) FROM payments WHERE payment_status='paid'")) {
   ResultSet rs = ps.executeQuery();
   if (rs.next()) return rs.getBigDecimal(1);
  } catch (SQLException e) {
   e.printStackTrace();
  }
  return BigDecimal.ZERO;
 }
}
