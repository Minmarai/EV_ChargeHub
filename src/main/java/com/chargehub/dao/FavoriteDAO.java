package com.chargehub.dao;

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
 */
public class FavoriteDAO {

 /**
  * Adds a charging station to a user's favourites.
  *
  * <p>Uses {@code INSERT IGNORE} to silently skip the operation if the
  * user-station pair already exists, preventing duplicate favourite entries
  * without throwing an error.</p>
  *
  * @param userId    the ID of the user adding the favourite
  * @param stationId the ID of the station to be favourited
  * @return {@code true} if the record was newly inserted; {@code false} if it
  *         already existed or an error occurred
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
  * @param userId    the ID of the user removing the favourite
  * @param stationId the ID of the station to be removed from favourites
  * @return {@code true} if the record was successfully deleted; {@code false} if
  *         no matching record was found or an error occurred
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
  * <p>Each {@link Station} is populated with the following fields:
  * {@code station_id}, {@code station_name}, {@code district_name},
  * {@code address}, {@code charger_type}, {@code total_ports},
  * and {@code status}.</p>
  *
  * <p>The query joins {@code favorites} with {@code stations}, {@code districts},
  * and optionally {@code users} (for manager name via a {@code LEFT JOIN}).</p>
  *
  * @param userId the ID of the user whose favourite stations are to be retrieved
  * @return a {@link List} of {@link Station} objects representing the user's favourites;
  *         returns an empty list if none exist or an error occurs
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
  * @param userId the ID of the user whose favourite count is to be retrieved
  * @return the number of favourite stations for the user, or {@code 0} if
  *         none exist or an error occurs
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
}