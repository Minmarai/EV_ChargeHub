package com.chargehub.dao;

import com.chargehub.model.Slot;
import com.chargehub.util.DBConnection;
import java.sql.*;
import java.util.*;

/**
 * Data Access Object (DAO) for managing {@link Slot} entities.
 *
 * <p>Provides full CRUD operations for time slots associated with charging stations,
 * including availability filtering and manager-scoped queries.</p>
 *
 * <p>Read queries join the {@code slots} table with {@code stations} to enrich
 * results with station name context.</p>
 *
 * <p>All database connections are obtained via {@link DBConnection#getConnection()}
 * and are closed automatically using try-with-resources.</p>
 *
 * <p>Author: Imtiyaz Ansari</p>
 */
public class SlotDAO {

 /**
  * Base SQL query joining slots with their associated station.
  * Used as a foundation for all read queries in this DAO.
  */
 private String base = "SELECT sl.*, st.station_name " +
         "FROM slots sl JOIN stations st ON sl.station_id = st.station_id";

 /**
  * Maps a {@link ResultSet} row to a {@link Slot} object.
  *
  * @param rs the {@link ResultSet} positioned at the current row
  * @return a fully populated {@link Slot} instance
  * @throws SQLException if any column cannot be read from the result set
  */
 private Slot map(ResultSet rs) throws SQLException {
  Slot s = new Slot();
  s.setSlotId(rs.getInt("slot_id"));
  s.setStationId(rs.getInt("station_id"));
  s.setStationName(rs.getString("station_name"));
  s.setSlotDate(rs.getDate("slot_date"));
  s.setStartTime(rs.getTime("start_time"));
  s.setEndTime(rs.getTime("end_time"));
  s.setAvailabilityStatus(rs.getString("availability_status"));
  return s;
 }

 /**
  * Retrieves all slots across all stations, ordered by date descending
  * then by start time ascending within each date.
  *
  * @return a {@link List} of all {@link Slot} objects; empty list if none found
  */
 public List<Slot> findAll() {
  return query(base + " ORDER BY sl.slot_date DESC, sl.start_time");
 }

 /**
  * Retrieves all slots for a specific station regardless of availability status,
  * ordered by date and start time ascending.
  *
  * <p>Use {@link #findAvailableByStation(int)} instead when only bookable
  * slots are needed.</p>
  *
  * @param stationId the ID of the station whose slots are to be retrieved
  * @return a {@link List} of {@link Slot} objects for the given station;
  *         empty list if none found
  */
 public List<Slot> findByStation(int stationId) {
  return query(base + " WHERE sl.station_id=" + stationId +
          " ORDER BY sl.slot_date, sl.start_time");
 }

 /**
  * Retrieves only {@code "available"} slots for a specific station,
  * ordered by date and start time ascending.
  *
  * <p>Intended for public-facing booking flows where only bookable
  * slots should be presented to the user.</p>
  *
  * @param stationId the ID of the station whose available slots are to be retrieved
  * @return a {@link List} of available {@link Slot} objects for the given station;
  *         empty list if no available slots exist or an error occurs
  */
 public List<Slot> findAvailableByStation(int stationId) {
  return query(base + " WHERE sl.station_id=" + stationId +
          " AND LOWER(TRIM(sl.availability_status))='available' AND sl.slot_date>=CURDATE() ORDER BY sl.slot_date, sl.start_time");
 }

 /**
  * Retrieves all slots belonging to stations managed by a specific manager,
  * ordered by date descending then by start time ascending.
  *
  * @param managerId the ID of the station manager
  * @return a {@link List} of {@link Slot} objects across all stations
  *         under the given manager; empty list if none found
  */
 public List<Slot> findByManager(int managerId) {
  return query(base + " WHERE st.manager_id=" + managerId +
          " ORDER BY sl.slot_date DESC, sl.start_time");
 }

 /**
  * Executes a raw SQL query and maps each resulting row to a {@link Slot}.
  *
  * <p><strong>Note:</strong> This method executes the provided SQL string directly
  * without parameterization. Callers must ensure the SQL is safe to prevent
  * SQL injection vulnerabilities.</p>
  *
  * @param sql the SQL query string to execute
  * @return a {@link List} of mapped {@link Slot} objects; empty list on error or no results
  */
 private List<Slot> query(String sql) {
  List<Slot> list = new ArrayList<>();
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
  * Finds a single slot by its unique ID.
  *
  * @param id the slot ID to search for
  * @return the matching {@link Slot}, or {@code null} if not found
  */
 public Slot findById(int id) {
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(base + " WHERE sl.slot_id=?")) {
   ps.setInt(1, id);
   ResultSet rs = ps.executeQuery();
   if (rs.next()) return map(rs);
  } catch (SQLException e) {
   e.printStackTrace();
  }
  return null;
 }

 /**
  * Inserts a new slot record into the {@code slots} table.
  *
  * <p>The {@link Slot} object must have {@code stationId}, {@code slotDate},
  * {@code startTime}, {@code endTime}, and {@code availabilityStatus} set
  * before calling this method. The {@code slotId} field is ignored as it
  * is auto-generated by the database.</p>
  *
  * @param s the {@link Slot} object containing the data to insert
  * @return {@code true} if the slot was successfully inserted; {@code false} otherwise
  */
 public boolean save(Slot s) {
  String sql = "INSERT INTO slots(station_id, slot_date, start_time, end_time, availability_status) " +
          "VALUES(?, ?, ?, ?, ?)";
  return saveUpdate(sql, s, false);
 }

 /**
  * Updates an existing slot record in the {@code slots} table.
  *
  * <p>The {@link Slot} object must have a valid {@code slotId} set in addition
  * to all other fields ({@code stationId}, {@code slotDate}, {@code startTime},
  * {@code endTime}, {@code availabilityStatus}), as the ID is used in the
  * {@code WHERE} clause to identify the record.</p>
  *
  * @param s the {@link Slot} object containing updated field values and a valid slot ID
  * @return {@code true} if the update affected at least one row; {@code false} otherwise
  */
 public boolean update(Slot s) {
  String sql = "UPDATE slots SET station_id=?, slot_date=?, start_time=?, end_time=?, " +
          "availability_status=? WHERE slot_id=?";
  return saveUpdate(sql, s, true);
 }

 /**
  * Shared helper for both {@link #save(Slot)} and {@link #update(Slot)} operations.
  *
  * <p>Binds the common slot fields to the prepared statement. When {@code update}
  * is {@code true}, the slot ID is additionally bound as the final parameter
  * for use in the {@code WHERE} clause.</p>
  *
  * @param sql    the SQL string to execute (INSERT or UPDATE)
  * @param s      the {@link Slot} object whose fields are to be bound
  * @param update {@code true} if this is an update operation requiring the slot ID
  *               as the final parameter; {@code false} for an insert
  * @return {@code true} if the operation affected at least one row; {@code false} otherwise
  */
 private boolean saveUpdate(String sql, Slot s, boolean update) {
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(sql)) {
   ps.setInt(1, s.getStationId());
   ps.setDate(2, s.getSlotDate());
   ps.setTime(3, s.getStartTime());
   ps.setTime(4, s.getEndTime());
   ps.setString(5, s.getAvailabilityStatus());
   if (update) ps.setInt(6, s.getSlotId());
   return ps.executeUpdate() > 0;
  } catch (SQLException e) {
   e.printStackTrace();
   return false;
  }
 }

 /**
  * Updates only the availability status of a specific slot.
  *
  * <p>Common status values include {@code "available"} and {@code "booked"}.
  * Prefer this method over {@link #update(Slot)} when only the availability
  * needs to change, to avoid unnecessary field binding.</p>
  *
  * @param slotId the ID of the slot whose availability status is to be updated
  * @param status the new availability status to apply
  * @return {@code true} if the update affected at least one row; {@code false} otherwise
  */
 public boolean updateStatus(int slotId, String status) {
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(
               "UPDATE slots SET availability_status=? WHERE slot_id=?")) {
   ps.setString(1, status);
   ps.setInt(2, slotId);
   return ps.executeUpdate() > 0;
  } catch (SQLException e) {
   e.printStackTrace();
   return false;
  }
 }

 /**
  * Permanently deletes a slot from the database.
  *
  * <p><strong>Note:</strong> This operation is irreversible. Deleting a slot
  * that is referenced by an existing booking may violate foreign key constraints
  * depending on the database schema configuration.</p>
  *
  * @param id the unique ID of the slot to delete
  * @return {@code true} if the deletion was successful; {@code false} if no record
  *         was found with the given ID or an error occurs
  */
 public boolean delete(int id) {
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(
               "DELETE FROM slots WHERE slot_id=?")) {
   ps.setInt(1, id);
   return ps.executeUpdate() > 0;
  } catch (SQLException e) {
   e.printStackTrace();
   return false;
  }
 }

 /**
  * Returns the total number of slots across all stations managed by a specific manager.
  *
  * @param managerId the ID of the station manager
  * @return the total slot count for the manager's stations, or {@code 0} if
  *         none exist or an error occurs
  */
 public int countByManager(int managerId) {
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(
               "SELECT COUNT(*) FROM slots sl " +
                       "JOIN stations st ON sl.station_id = st.station_id " +
                       "WHERE st.manager_id=?")) {
   ps.setInt(1, managerId);
   ResultSet rs = ps.executeQuery();
   if (rs.next()) return rs.getInt(1);
  } catch (SQLException e) {
   e.printStackTrace();
  }
  return 0;
 }

 /**
  * Returns the number of slots with {@code "available"} status for a specific station
  * from today onward.
  *
  * <p>Only future or current-day slots are counted ({@code slot_date >= CURDATE()}),
  * making this suitable for dashboard indicators or booking availability checks
  * where past slots are irrelevant.</p>
  *
  * <p>Complements {@link #countBookedPortsByStation(int)}, which counts slots
  * in the opposing {@code "booked"} state for the same station and date range.</p>
  *
  * @param stationId the ID of the station to count available slots for
  * @return the number of available upcoming slots for the station,
  *         or {@code 0} if none exist or an error occurs
  */
 public int countAvailablePortsByStation(int stationId) {
  String sql = "SELECT COUNT(*) FROM slots WHERE station_id = ? " +
          "AND availability_status = 'available' AND slot_date >= CURDATE()";
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(sql)) {
   ps.setInt(1, stationId);
   ResultSet rs = ps.executeQuery();
   if (rs.next()) return rs.getInt(1);
  } catch (SQLException e) {
   e.printStackTrace();
  }
  return 0;
 }

 /**
  * Returns the number of slots with {@code "booked"} status for a specific station
  * from today onward.
  *
  * <p>Only future or current-day slots are counted ({@code slot_date >= CURDATE()}),
  * making this suitable for occupancy metrics or capacity planning dashboards
  * where historical bookings are not relevant.</p>
  *
  * <p>Status comparison uses {@code LOWER(TRIM(...))} to tolerate minor
  * inconsistencies in stored values (e.g., leading/trailing whitespace or
  * mixed casing such as {@code "Booked"} or {@code " booked "}).</p>
  *
  * <p>Complements {@link #countAvailablePortsByStation(int)}, which counts slots
  * in the opposing {@code "available"} state for the same station and date range.</p>
  *
  * @param stationId the ID of the station to count booked slots for
  * @return the number of booked upcoming slots for the station,
  *         or {@code 0} if none exist or an error occurs
  */
 public int countBookedPortsByStation(int stationId) {
  String sql = "SELECT COUNT(*) FROM slots WHERE station_id = ? " +
          "AND LOWER(TRIM(availability_status)) = 'booked' AND slot_date >= CURDATE()";
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(sql)) {
   ps.setInt(1, stationId);
   ResultSet rs = ps.executeQuery();
   if (rs.next()) return rs.getInt(1);
  } catch (SQLException e) {
   e.printStackTrace();
  }
  return 0;
 }
}
