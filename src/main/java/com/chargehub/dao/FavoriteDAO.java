package com.chargehub.dao;

import com.chargehub.model.Station;
import com.chargehub.util.DBConnection;
import java.sql.*;
import java.util.*;

/**
 * Data Access Object (DAO) for managing a user's favourite charging stations.
 *
 * <p>Provides operations to add, remove, and retrieve favourite stations
 * from the {@code favorites} table, which maintains a many-to-many
 * relationship between users and stations.</p>
 *
 * <p>All database connections are obtained via {@link DBConnection#getConnection()}
 * and are closed automatically using try-with-resources.</p>
 *
 * <p>The {@code favorites} table is expected to have at least the following columns:</p>
 * <ul>
 *   <li>{@code user_id} — foreign key referencing the {@code users} table</li>
 *   <li>{@code station_id} — foreign key referencing the {@code stations} table</li>
 * </ul>
 *
 * <p>The combination of {@code (user_id, station_id)} acts as a composite unique key,
 * enforced at the database level. This DAO leverages {@code INSERT IGNORE} to
 * handle duplicate attempts gracefully without throwing errors.</p>
 *
 * <p>Author: Rijam Shrestha</p>
 *
 * <p>Typical usage flow:</p>
 * <ol>
 *   <li>User favourites a station → {@link #add(int, int)}</li>
 *   <li>User views their favourites → {@link #findByUser(int)}</li>
 *   <li>Check which stations are already favourited → {@link #findStationIdsByUser(int)}</li>
 *   <li>User removes a favourite → {@link #remove(int, int)}</li>
 *   <li>Show favourite count on profile → {@link #countByUser(int)}</li>
 * </ol>
 *
 * @see Station
 */
public class FavoriteDAO {

 /**
  * Adds a charging station to a user's favourites.
  *
  * <p>Uses {@code INSERT IGNORE} to silently skip the operation if the
  * user-station pair already exists, preventing duplicate favourite entries
  * without throwing an error. This makes the method safe to call even
  * when the favourite state is uncertain.</p>
  *
  * <p>To check whether a station is already favourited before calling this
  * method, use {@link #findStationIdsByUser(int)}.</p>
  *
  * @param userId    the ID of the user adding the favourite;
  *                  must correspond to an existing record in the {@code users} table
  * @param stationId the ID of the station to be favourited;
  *                  must correspond to an existing record in the {@code stations} table
  * @return {@code true} if a new record was inserted (station was not previously favourited);
  *         {@code false} if the pair already existed (insert was ignored) or an error occurred
  * @see #remove(int, int)
  * @see #findStationIdsByUser(int)
  */
 public boolean add(int userId, int stationId) {
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(
               "INSERT IGNORE INTO favorites(user_id, station_id) VALUES(?, ?)")) {
   ps.setInt(1, userId);
   ps.setInt(2, stationId);
   return ps.executeUpdate() > 0;
  } catch (SQLException e) {
   e.printStackTrace();
   return false;
  }
 }

 /**
  * Removes a charging station from a user's favourites.
  *
  * <p>Deletes the record matching the given {@code (userId, stationId)} pair
  * from the {@code favorites} table. If no such record exists, the operation
  * affects zero rows and {@code false} is returned without throwing an exception.</p>
  *
  * <p>To verify whether a station is currently favourited before calling this
  * method, use {@link #findStationIdsByUser(int)}.</p>
  *
  * @param userId    the ID of the user removing the favourite;
  *                  must correspond to an existing record in the {@code users} table
  * @param stationId the ID of the station to be removed from favourites;
  *                  must correspond to an existing record in the {@code stations} table
  * @return {@code true} if the record was successfully deleted;
  *         {@code false} if no matching record was found or an error occurred
  * @see #add(int, int)
  * @see #findStationIdsByUser(int)
  */
 public boolean remove(int userId, int stationId) {
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(
               "DELETE FROM favorites WHERE user_id=? AND station_id=?")) {
   ps.setInt(1, userId);
   ps.setInt(2, stationId);
   return ps.executeUpdate() > 0;
  } catch (SQLException e) {
   e.printStackTrace();
   return false;
  }
 }

 /**
  * Retrieves all favourite stations for a given user, enriched with district
  * and manager information.
  *
  * <p>Joins the following tables to assemble each {@link Station} object:</p>
  * <ul>
  *   <li>{@code favorites} — filtered by the given {@code userId}</li>
  *   <li>{@code stations} — provides core station fields</li>
  *   <li>{@code districts} — provides the human-readable {@code district_name}</li>
  *   <li>{@code users} (via {@code LEFT JOIN}) — provides the manager's
  *       {@code full_name}; may be {@code null} if no manager is assigned</li>
  * </ul>
  *
  * <p>Each returned {@link Station} is populated with the following fields:
  * {@code station_id}, {@code station_name}, {@code district_name},
  * {@code address}, {@code charger_type}, {@code total_ports},
  * and {@code status}.</p>
  *
  * <p>The result is not ordered — callers should sort the list as needed
  * for display purposes.</p>
  *
  * @param userId the ID of the user whose favourite stations are to be retrieved;
  *               must correspond to an existing record in the {@code users} table
  * @return a {@link List} of {@link Station} objects representing the user's favourites;
  *         returns an empty list if the user has no favourites or an error occurs
  * @see #findStationIdsByUser(int)
  * @see #countByUser(int)
  */
 public List<Station> findByUser(int userId) {
  List<Station> list = new ArrayList<>();
  String sql = "SELECT s.*, d.district_name, u.full_name manager_name " +
          "FROM favorites f " +
          "JOIN stations s ON f.station_id = s.station_id " +
          "JOIN districts d ON s.district_id = d.district_id " +
          "LEFT JOIN users u ON s.manager_id = u.user_id " +
          "WHERE f.user_id=?";
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(sql)) {
   ps.setInt(1, userId);
   ResultSet rs = ps.executeQuery();
   while (rs.next()) {
    Station s = new Station();
    s.setStationId(rs.getInt("station_id"));
    s.setStationName(rs.getString("station_name"));
    s.setDistrictName(rs.getString("district_name"));
    s.setAddress(rs.getString("address"));
    s.setChargerType(rs.getString("charger_type"));
    s.setTotalPorts(rs.getInt("total_ports"));
    s.setStatus(rs.getString("status"));
    list.add(s);
   }
  } catch (SQLException e) {
   e.printStackTrace();
  }
  return list;
 }

 /**
  * Returns the total number of favourite stations saved by a specific user.
  *
  * <p>Executes a {@code COUNT(*)} query filtered by {@code user_id}, so the
  * result reflects only that user's favourites. Typically used to display
  * a favourite count badge or statistic on a user's profile or dashboard.</p>
  *
  * <p>To retrieve the full list of favourited stations rather than just the count,
  * use {@link #findByUser(int)} instead.</p>
  *
  * @param userId the ID of the user whose favourite count is to be retrieved;
  *               must correspond to an existing record in the {@code users} table
  * @return the number of favourite stations saved by the user as an {@code int};
  *         returns {@code 0} if the user has no favourites or a {@link SQLException} occurs
  * @see #findByUser(int)
  */
 public int countByUser(int userId) {
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(
               "SELECT COUNT(*) FROM favorites WHERE user_id=?")) {
   ps.setInt(1, userId);
   ResultSet rs = ps.executeQuery();
   if (rs.next()) return rs.getInt(1);
  } catch (SQLException e) {
   e.printStackTrace();
  }
  return 0;
 }

 /**
  * Retrieves the set of station IDs currently favourited by a specific user.
  *
  * <p>Returns only the {@code station_id} values from the {@code favorites} table,
  * without joining any additional tables. This makes it a lightweight alternative
  * to {@link #findByUser(int)} when full {@link Station} details are not needed.</p>
  *
  * <p>The primary use case is rendering favourite toggle buttons (e.g. heart icons)
  * in a station list — by checking whether each station's ID is present in the
  * returned set, the UI can mark which stations are already favourited without
  * issuing a separate query per station.</p>
  *
  * <p>A {@link HashSet} is used internally to ensure O(1) lookup performance
  * when checking membership via {@link Set#contains(Object)}.</p>
  *
  * @param userId the ID of the user whose favourited station IDs are to be retrieved;
  *               must correspond to an existing record in the {@code users} table
  * @return a {@link Set} of {@link Integer} station IDs favourited by the user;
  *         returns an empty set if the user has no favourites or a {@link SQLException} occurs
  * @see #findByUser(int)
  * @see #add(int, int)
  * @see #remove(int, int)
  */
 public Set<Integer> findStationIdsByUser(int userId) {
  Set<Integer> ids = new HashSet<>();
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(
               "SELECT station_id FROM favorites WHERE user_id=?")) {
   ps.setInt(1, userId);
   ResultSet rs = ps.executeQuery();
   while (rs.next()) ids.add(rs.getInt("station_id"));
  } catch (SQLException e) {
   e.printStackTrace();
  }
  return ids;
 }
}
