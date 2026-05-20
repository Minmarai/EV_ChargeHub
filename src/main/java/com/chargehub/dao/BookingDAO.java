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
 *
 * <p>Author: Kirti Dahal</p>
 */
public class BookingDAO {

 /**
  * Base SQL query joining bookings with users, stations, slots, and payments.
  *
  * <p>Fetches all relevant booking details in a single query by joining:</p>
  * <ul>
  *   <li>{@code users} — for the booking user's name and phone</li>
  *   <li>{@code stations} — for the station name</li>
  *   <li>{@code users} (aliased as {@code sm}) — for the station manager's name</li>
  *   <li>{@code slots} — for slot date and time range info</li>
  *   <li>{@code payments} — for payment status and amount</li>
  * </ul>
  *
  * <p>Used as a foundation for all read queries in this DAO by appending
  * {@code WHERE}, {@code ORDER BY}, or other clauses as needed.</p>
  */
 private String base = "SELECT b.*, u.full_name, u.phone, st.station_name, sm.full_name AS manager_name, " +
         "CONCAT(sl.slot_date,' ',sl.start_time,'-',sl.end_time) slot_info, " +
         "p.payment_status, p.amount " +
         "FROM bookings b " +
         "LEFT JOIN users u ON b.user_id = u.user_id " +
         "LEFT JOIN stations st ON b.station_id = st.station_id " +
         "LEFT JOIN users sm ON st.manager_id = sm.user_id " +
         "LEFT JOIN slots sl ON b.slot_id = sl.slot_id " +
         "LEFT JOIN payments p ON b.booking_id = p.booking_id";

 /**
  * Maps a {@link ResultSet} row to a {@link Booking} object.
  *
  * <p>Reads all expected columns from the current row of the given
  * {@link ResultSet} and populates a new {@link Booking} instance.
  * This method does not advance the cursor — the caller is responsible
  * for calling {@link ResultSet#next()} beforehand.</p>
  *
  * @param rs the {@link ResultSet} positioned at the current row
  * @return a fully populated {@link Booking} instance
  * @throws SQLException if any column cannot be read from the result set,
  *                      or if the result set is closed or not positioned on a valid row
  */
 private Booking map(ResultSet rs) throws SQLException {
  Booking b = new Booking();
  b.setBookingId(rs.getInt("booking_id"));
  b.setUserId(rs.getInt("user_id"));
  b.setStationId(rs.getInt("station_id"));
  b.setSlotId(rs.getInt("slot_id"));
  b.setUserName(rs.getString("full_name"));
  b.setUserPhone(rs.getString("phone"));
  b.setStationName(rs.getString("station_name"));
  b.setManagerName(rs.getString("manager_name"));
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
  * <p>Returns the most recently created bookings first. Delegates to
  * {@link #query(String)} internally.</p>
  *
  * @return a {@link List} of all {@link Booking} objects; empty list if none found
  */
 public List<Booking> findAll() {
  return query(base + " ORDER BY b.booking_id DESC");
 }

 /**
  * Retrieves all bookings associated with a specific user.
  *
  * <p>Results are ordered by booking ID descending so the most recent
  * bookings appear first. Delegates to {@link #query(String)} internally.</p>
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
  * <p>Filters bookings by matching the {@code manager_id} on the associated
  * station record. Results are ordered by booking ID descending.</p>
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
  * <p>Opens a connection, prepares and executes the given SQL string, and
  * collects each row into a list via {@link #map(ResultSet)}. The connection
  * is closed automatically via try-with-resources.</p>
  *
  * <p><strong>Warning:</strong> This method executes the provided SQL string
  * directly without parameterization. Callers must ensure that all inputs
  * embedded in the SQL are safe to prevent SQL injection vulnerabilities.</p>
  *
  * @param sql the complete SQL query string to execute; must be a valid
  *            {@code SELECT} statement compatible with {@link #base}
  * @return a {@link List} of mapped {@link Booking} objects;
  *         returns an empty list on error or when no rows match
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
  * <p>Uses a parameterized query to safely look up the booking record,
  * joined with all related tables via {@link #base}.</p>
  *
  * @param id the booking ID to search for
  * @return the matching {@link Booking} fully populated with user, station,
  *         slot, and payment details; or {@code null} if not found
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
  * <p>This is a convenience wrapper around {@link #createAndReturnId(Booking)}
  * that returns a simple boolean success indicator instead of the generated ID.</p>
  *
  * <p>The booking is created with an initial status of {@code "pending"}.</p>
  *
  * @param b the {@link Booking} object containing user ID, station ID, slot ID,
  *          vehicle number, and optional notes
  * @return {@code true} if the booking was successfully created; {@code false} otherwise
  * @see #createAndReturnId(Booking)
  */
 public boolean create(Booking b) {
  return createAndReturnId(b) != null;
 }

 /**
  * Creates a new booking, marks the associated slot as {@code "booked"},
  * and returns the auto-generated booking ID.
  *
  * <p>This operation is fully transactional — the booking insertion and
  * the slot status update are committed atomically. If either statement
  * fails, the transaction is rolled back and {@code null} is returned.</p>
  *
  * <p>The booking record is inserted with an initial {@code booking_status}
  * of {@code "pending"}. The associated slot's {@code availability_status}
  * is updated to {@code "booked"} in the same transaction.</p>
  *
  * <p>Use {@link #create(Booking)} instead if the generated ID is not needed.</p>
  *
  * @param b the {@link Booking} object containing:
  *          <ul>
  *            <li>{@code userId} — the ID of the user making the booking</li>
  *            <li>{@code stationId} — the ID of the charging station</li>
  *            <li>{@code slotId} — the ID of the time slot to reserve</li>
  *            <li>{@code vehicleNumber} — the vehicle's registration number</li>
  *            <li>{@code notes} — optional booking notes (may be {@code null})</li>
  *          </ul>
  * @return the auto-generated {@code booking_id} if the operation succeeds;
  *         {@code null} if the insert fails or a {@link SQLException} is thrown
  */
 public Integer createAndReturnId(Booking b) {
  String sql = "INSERT INTO bookings(user_id, station_id, slot_id, vehicle_number, booking_status, notes) " +
          "VALUES(?, ?, ?, ?, ?, ?)";
  try (Connection c = DBConnection.getConnection()) {
   c.setAutoCommit(false);
   try (PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        PreparedStatement ps2 = c.prepareStatement(
                "UPDATE slots SET availability_status='booked' WHERE slot_id=?")) {
    ps.setInt(1, b.getUserId());
    ps.setInt(2, b.getStationId());
    ps.setInt(3, b.getSlotId());
    ps.setString(4, b.getVehicleNumber());
    ps.setString(5, "pending");
    ps.setString(6, b.getNotes());
    boolean ok = ps.executeUpdate() > 0;
    Integer bookingId = null;
    if (ok) {
     ResultSet keys = ps.getGeneratedKeys();
     if (keys.next()) bookingId = keys.getInt(1);
    }
    ps2.setInt(1, b.getSlotId());
    ps2.executeUpdate();
    c.commit();
    return ok ? bookingId : null;
   } catch (SQLException e) {
    c.rollback();
    throw e;
   }
  } catch (SQLException e) {
   e.printStackTrace();
   return null;
  }
 }

 /**
  * Synchronizes booking statuses to {@code "completed"} for a specific manager's stations,
  * based on confirmed payment records.
  *
  * <p>Updates all bookings that meet the following criteria:</p>
  * <ul>
  *   <li>The booking's station is managed by the given {@code managerId}</li>
  *   <li>The associated payment has a status of {@code "paid"}</li>
  *   <li>The booking's current status is still {@code "pending"}</li>
  * </ul>
  *
  * <p>This method is intended to be called when a manager views their dashboard
  * or booking list, ensuring stale {@code "pending"} statuses are corrected
  * before data is displayed.</p>
  *
  * @param managerId the ID of the station manager whose bookings should be synchronized
  */
 public void syncCompletedFromPayments(int managerId) {
  String sql = "UPDATE bookings b " +
          "INNER JOIN stations st ON b.station_id = st.station_id " +
          "INNER JOIN payments p ON b.booking_id = p.booking_id " +
          "SET b.booking_status = 'completed' " +
          "WHERE st.manager_id = ? AND p.payment_status = 'paid' AND b.booking_status = 'pending'";
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(sql)) {
   ps.setInt(1, managerId);
   ps.executeUpdate();
  } catch (SQLException e) {
   e.printStackTrace();
  }
 }

 /**
  * Synchronizes booking statuses to {@code "completed"} for a specific user,
  * based on confirmed payment records.
  *
  * <p>Updates all bookings that meet the following criteria:</p>
  * <ul>
  *   <li>The booking belongs to the given {@code userId}</li>
  *   <li>The associated payment has a status of {@code "paid"}</li>
  *   <li>The booking's current status is still {@code "pending"}</li>
  * </ul>
  *
  * <p>This method is intended to be called when a user views their booking history,
  * ensuring their booking statuses reflect the latest payment state before
  * results are returned.</p>
  *
  * @param userId the ID of the user whose bookings should be synchronized
  */
 public void syncUserBookings(int userId) {
  String sql = "UPDATE bookings b " +
          "INNER JOIN payments p ON b.booking_id = p.booking_id " +
          "SET b.booking_status = 'completed' " +
          "WHERE b.user_id = ? AND p.payment_status = 'paid' AND b.booking_status = 'pending'";
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(sql)) {
   ps.setInt(1, userId);
   ps.executeUpdate();
  } catch (SQLException e) {
   e.printStackTrace();
  }
 }

 /**
  * Updates the status of an existing booking.
  *
  * <p>Directly sets the {@code booking_status} column for the given booking ID.
  * No validation is performed on the status value — callers should pass only
  * recognized status strings.</p>
  *
  * <p>Common status values include:</p>
  * <ul>
  *   <li>{@code "pending"} — booking created but not yet confirmed</li>
  *   <li>{@code "confirmed"} — booking acknowledged by the station manager</li>
  *   <li>{@code "completed"} — booking fulfilled and payment received</li>
  *   <li>{@code "cancelled"} — booking cancelled by the user or manager</li>
  * </ul>
  *
  * @param id     the ID of the booking to update
  * @param status the new booking status string to apply
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
  * <p>This operation is fully transactional — the booking status update and the
  * slot availability restoration are committed atomically. If either statement
  * fails, the entire transaction is rolled back.</p>
  *
  * <p>The method first fetches the booking via {@link #findById(int)} to retrieve
  * the associated {@code slotId} before updating both records. If the booking
  * cannot be found, only the status update is attempted and the slot is left unchanged.</p>
  *
  * @param bookingId the ID of the booking to cancel
  * @return {@code true} if the booking status was successfully updated to
  *         {@code "cancelled"}; {@code false} if the update failed or an error occurred
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
  * <p>Executes a {@code COUNT(*)} query against the {@code bookings} table
  * with no filters applied.</p>
  *
  * @return the total booking count as an {@code int};
  *         returns {@code 0} if an error occurs or the table is empty
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
  * <p>Joins the {@code bookings} table with {@code stations} and filters
  * by the given {@code managerId} to count only bookings at that manager's stations.</p>
  *
  * @param managerId the ID of the station manager
  * @return the booking count for the manager's stations as an {@code int};
  *         returns {@code 0} if an error occurs or no bookings are found
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
