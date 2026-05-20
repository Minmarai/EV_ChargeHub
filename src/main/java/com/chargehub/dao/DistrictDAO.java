package com.chargehub.dao;

import com.chargehub.model.District;
import com.chargehub.util.DBConnection;
import java.sql.*;
import java.util.*;

/**
 * Data Access Object (DAO) for retrieving {@link District} entities.
 *
 * <p>Provides read operations against the {@code districts} table.
 * Database connections are obtained via {@link DBConnection#getConnection()}
 * and closed automatically using try-with-resources.</p>
 *
 * <p>The {@code districts} table is expected to have at least the following columns:</p>
 * <ul>
 *   <li>{@code district_id} — auto-incremented primary key</li>
 *   <li>{@code district_name} — human-readable name of the district</li>
 * </ul>
 *
 * <p>This DAO is read-only by design. No insert, update, or delete
 * operations are exposed, as districts are treated as reference/lookup data.</p>
 *
 * <p>Author: Kirti Dahal, IIC Java Hackerzz</p>
 *
 * @see District
 */
public class DistrictDAO {

 /**
  * Retrieves all districts from the database, ordered alphabetically by district name.
  *
  * <p>Each row is mapped to a {@link District} object populated with
  * {@code district_id} and {@code district_name}. This method returns
  * every district regardless of whether any active stations exist within it.</p>
  *
  * <p>Use {@link #findWithStations()} instead if only districts that have
  * at least one active charging station are needed.</p>
  *
  * @return a {@link List} of all {@link District} objects in ascending name order;
  *         returns an empty list if no records exist or an error occurs
  * @see #findWithStations()
  */
 public List<District> findAll() {
  List<District> list = new ArrayList<>();
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(
               "SELECT * FROM districts ORDER BY district_name")) {
   ResultSet rs = ps.executeQuery();
   while (rs.next()) {
    District d = new District();
    d.setDistrictId(rs.getInt("district_id"));
    d.setDistrictName(rs.getString("district_name"));
    list.add(d);
   }
  } catch (SQLException e) {
   e.printStackTrace();
  }
  return list;
 }

 /**
  * Retrieves only districts that contain at least one active charging station.
  *
  * <p>Performs an inner join between {@code districts} and {@code stations},
  * filtering to stations with a {@code status} of {@code "active"}.
  * The {@code DISTINCT} clause ensures each district appears only once
  * even if it has multiple active stations.</p>
  *
  * <p>Results are ordered alphabetically by {@code district_name}.
  * This method is intended for use in search or filter UI components
  * where showing empty districts would be misleading to the user.</p>
  *
  * <p>Use {@link #findAll()} instead if all districts are needed
  * regardless of station availability.</p>
  *
  * @return a {@link List} of {@link District} objects that have at least one
  *         active station, sorted by name in ascending order;
  *         returns an empty list if no qualifying districts exist or an error occurs
  * @see #findAll()
  */
 public List<District> findWithStations() {
  List<District> list = new ArrayList<>();
  String sql = "SELECT DISTINCT d.district_id, d.district_name " +
          "FROM districts d JOIN stations s ON s.district_id = d.district_id " +
          "WHERE s.status = 'active' " +
          "ORDER BY d.district_name";
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement(sql)) {
   ResultSet rs = ps.executeQuery();
   while (rs.next()) {
    District d = new District();
    d.setDistrictId(rs.getInt("district_id"));
    d.setDistrictName(rs.getString("district_name"));
    list.add(d);
   }
  } catch (SQLException e) {
   e.printStackTrace();
  }
  return list;
 }

 /**
  * Returns the total number of districts in the {@code districts} table.
  *
  * <p>Executes a {@code COUNT(*)} query with no filters, so the result
  * reflects all districts regardless of whether they have active stations.</p>
  *
  * <p>Typically used for administrative dashboard statistics.</p>
  *
  * @return the total district count as an {@code int};
  *         returns {@code 0} if the table is empty or a {@link SQLException} occurs
  */
 public int count() {
  try (Connection c = DBConnection.getConnection();
       PreparedStatement ps = c.prepareStatement("SELECT COUNT(*) FROM districts")) {
   ResultSet rs = ps.executeQuery();
   if (rs.next()) return rs.getInt(1);
  } catch (SQLException e) {
   e.printStackTrace();
  }
  return 0;
 }
}
