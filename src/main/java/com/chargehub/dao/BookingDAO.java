package com.chargehub.dao;

import com.chargehub.model.Booking;
import com.chargehub.util.DBConnection;
import java.sql.*;
import java.util.*;

/**
 * Data Access Object (DAO) for managing {@link Booking} entities.
 *
 * <p>Provides CRUD operations and queries for bookings, including
 * transactional slot management during booking creation and cancellation.</p>
 *
 * <p>All database interactions use {@link DBConnection#getConnection()} to
 * obtain connections, which are closed automatically via try-with-resources.</p>
 */
public class BookingDAO {

 /**
  * Base SQL query joining bookings with users, stations, slots, and payments.
  * Used as a foundation for all read queries in this DAO.
  */
 private String base = "SELECT b.*, u.full_name, st.station_name, " +
         "CONCAT(sl.slot_date,' ',sl.start_time,'-',sl.end_time) slot_info, " +
         "p.payment_status, p.amount " +
         "FROM bookings b " +
         "JOIN users u ON b.user_id = u.user_id " +
         "JOIN stations st ON b.station_id = st.station_id " +
         "JOIN slots sl ON b.slot_id = sl.slot_id " +
         "LEFT JOIN payments p ON b.booking_id = p.booking_id";

 /**
  * Maps a {@link ResultSet} row to a {@link Booking} object.
  *
  * @param rs the {@link ResultSet} positioned at the current row
  * @return a populated {@link Booking} instance
  * @throws SQLException if any column cannot be read from the result set
  */
 private Booking map(ResultSet rs) throws SQLException {
  Booking b = new Booking();
  b.setBookingId(rs.getInt("booking_id"));
  b.setUserId(rs.getInt("user_id"));
  b.setStationId(rs.getInt("station_id"));
  b.setSlotId(rs.getInt("slot_id"));
  b.setUserName(rs.getString("full_name"));
  b.setStationName(rs.getString("station_name"));
  b.setVehicleNumber(rs.getString("vehicle_number"));
  b.setBookingStatus(rs.getString("booking_status"));
  b.setBookingDate(rs.getTimestamp("booking_date"));
  b.setNotes(rs.getString("notes"));
  b.setSlotInfo(rs.getString("slot_info"));
  b.setPaymentStatus(rs.getString("payment_status"));
  b.setAmount(rs.getBigDecimal("amount"));
  return b;
 }

 /**
  * Retrieves all bookings from the database, ordered by booking ID descending.
  *
  * @return a {@link List} of all {@link Booking} objects; empty list if none found
  */
 public List<Booking> findAll() {
  return query(base + " ORDER BY b.booking_id DESC");
 }

 /**
  * Retrieves all bookings associated with a specific user.
  *
  * @param userId the ID of the user whose bookings are to be fetched
  * @return a {@link List} of {@link Booking} objects for the given user;
  *         empty list if no bookings exist
  */
 public List<Booking> findByUser(int userId) {
  return query(base + " WHERE b.user_id=" + userId + " ORDER BY b.booking_id DESC");
 }

 /**
  * Retrieves all bookings for stations managed by a specific manager.
  *
  * @param managerId the ID of the station manager
  * @return a {@link List} of {@link Booking} objects at stations under the given manager;
  *         empty list if no bookings found
  */
 public List<Booking> findByManager(int managerId) {
  return query(base + " WHERE st.manager_id=" + managerId + " ORDER BY b.booking_id DESC");
 }

 /**
  * Executes a raw SQL query and maps each row to a {@link Booking}.
  *
  * <p><strong>Note:</strong> This method executes the provided SQL string directly
  * without parameterization. Callers must ensure inputs are safe to prevent SQL injection.</p>
  *
  * @param sql the SQL query string to execute
  * @return a {@link List} of mapped {@link Booking} objects; empty list on error or no results
  */
 private List<Booking> query(String sql) {
  List<Booking> list = new ArrayList<>();
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
  * Finds a single booking by its unique ID.
  *
  * @param id the booking ID to search for
  * @return the matching {@link Booking}, or {@code null} if not found
  */
 public Booking findById(int id) {
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(base + " WHERE b.booking_id=?")) {
   ps.setInt(1, id);
   ResultSet rs = ps.executeQuery();
   if (rs.next()) return map(rs);
  } catch (SQLException e) {
   e.printStackTrace();
  }
  return null;
 }

 /**
  * Creates a new booking and marks the associated slot as {@code "booked"}.
  *
  * <p>This operation is transactional — both the booking insertion and slot
  * status update are committed together, or rolled back on failure.</p>
  *
  * <p>The booking is created with an initial status of {@code "pending"}.</p>
  *
  * @param b the {@link Booking} object containing user ID, station ID, slot ID,
  *          vehicle number, and optional notes
  * @return {@code true} if the booking was successfully created; {@code false} otherwise
  */
 public boolean create(Booking b) {
  String sql = "INSERT INTO bookings(user_id, station_id, slot_id, vehicle_number, booking_status, notes) " +
          "VALUES(?, ?, ?, ?, ?, ?)";
  try (Connection c = DBConnection.getConnection()) {
   c.setAutoCommit(false);
   try (PreparedStatement ps = c.prepareStatement(sql);
        PreparedStatement ps2 = c.prepareStatement(
                "UPDATE slots SET availability_status='booked' WHERE slot_id=?")) {
    ps.setInt(1, b.getUserId());
    ps.setInt(2, b.getStationId());
    ps.setInt(3, b.getSlotId());
    ps.setString(4, b.getVehicleNumber());
    ps.setString(5, "pending");
    ps.setString(6, b.getNotes());
    boolean ok = ps.executeUpdate() > 0;
    ps2.setInt(1, b.getSlotId());
    ps2.executeUpdate();
    c.commit();
    return ok;
   } catch (SQLException e) {
    c.rollback();
    throw e;
   }
  } catch (SQLException e) {
   e.printStackTrace();
   return false;
  }
 }

 /**
  * Updates the status of an existing booking.
  *
  * <p>Common status values include {@code "pending"}, {@code "confirmed"},
  * {@code "completed"}, and {@code "cancelled"}.</p>
  *
  * @param id     the ID of the booking to update
  * @param status the new booking status string
  * @return {@code true} if the update affected at least one row; {@code false} otherwise
  */
 public boolean updateStatus(int id, String status) {
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(
               "UPDATE bookings SET booking_status=? WHERE booking_id=?")) {
   ps.setString(1, status);
   ps.setInt(2, id);
   return ps.executeUpdate() > 0;
  } catch (SQLException e) {
   e.printStackTrace();
   return false;
  }
 }

 /**
  * Cancels a booking and releases the associated slot back to {@code "available"}.
  *
  * <p>This operation is transactional — the booking status update and slot
  * availability restoration are committed together, or rolled back on failure.</p>
  *
  * @param bookingId the ID of the booking to cancel
  * @return {@code true} if the booking was successfully cancelled; {@code false} otherwise
  */
 public boolean cancel(int bookingId) {
  try (Connection c = DBConnection.getConnection()) {
   c.setAutoCommit(false);
   Booking b = findById(bookingId);
   try (PreparedStatement ps = c.prepareStatement(
           "UPDATE bookings SET booking_status='cancelled' WHERE booking_id=?");
        PreparedStatement ps2 = c.prepareStatement(
                "UPDATE slots SET availability_status='available' WHERE slot_id=?")) {
    ps.setInt(1, bookingId);
    boolean ok = ps.executeUpdate() > 0;
    if (b != null) {
     ps2.setInt(1, b.getSlotId());
     ps2.executeUpdate();
    }
    c.commit();
    return ok;
   } catch (SQLException e) {
    c.rollback();
    throw e;
   }
  } catch (SQLException e) {
   e.printStackTrace();
   return false;
  }
 }

 /**
  * Returns the total number of bookings across all users and stations.
  *
  * @return the total booking count, or {@code 0} if an error occurs
  */
 public int count() {
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement("SELECT COUNT(*) FROM bookings")) {
   ResultSet rs = ps.executeQuery();
   if (rs.next()) return rs.getInt(1);
  } catch (SQLException e) {
   e.printStackTrace();
  }
  return 0;
 }

 /**
  * Returns the total number of bookings for all stations managed by a specific manager.
  *
  * @param managerId the ID of the station manager
  * @return the booking count for the manager's stations, or {@code 0} if an error occurs
  */
 public int countByManager(int managerId) {
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(
               "SELECT COUNT(*) FROM bookings b " +
                       "JOIN stations s ON b.station_id = s.station_id " +
                       "WHERE s.manager_id=?")) {
   ps.setInt(1, managerId);
   ResultSet rs = ps.executeQuery();
   if (rs.next()) return rs.getInt(1);
  } catch (SQLException e) {
   e.printStackTrace();
  }
  return 0;
 }
}