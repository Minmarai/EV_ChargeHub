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
 */
public class DistrictDAO {

 /**
  * Retrieves all districts from the database, ordered alphabetically by district name.
  *
  * <p>Each row is mapped to a {@link District} object populated with
  * {@code district_id} and {@code district_name}.</p>
  *
  * @return a {@link List} of all {@link District} objects in ascending name order;
  *         returns an empty list if no records exist or an error occurs
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
}