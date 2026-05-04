package com.chargehub.dao;

import com.chargehub.model.Station;
import com.chargehub.util.DBConnection;
import java.math.BigDecimal;
import java.sql.*;
import java.util.*;

/**
 * Data Access Object (DAO) for managing {@link Station} entities.
 *
 * <p>Provides full CRUD operations for charging stations, including
 * filtered search, manager assignment, and aggregated count queries.</p>
 *
 * <p>Read queries join the {@code stations} table with {@code districts}
 * and optionally {@code users} (via a {@code LEFT JOIN}) to enrich results
 * with district name and manager name context.</p>
 *
 * <p>All database connections are obtained via {@link DBConnection#getConnection()}
 * and are closed automatically using try-with-resources.</p>
 */
public class StationDAO {

    /**
     * Base SQL query joining stations with districts and optionally with users for manager name.
     * The {@code LEFT JOIN} on users ensures stations without an assigned manager are
     * still returned. Used as a foundation for all read queries in this DAO.
     */
    private String base = "SELECT s.*, d.district_name, u.full_name manager_name " +
            "FROM stations s " +
            "JOIN districts d ON s.district_id = d.district_id " +
            "LEFT JOIN users u ON s.manager_id = u.user_id";

    /**
     * Maps a {@link ResultSet} row to a fully populated {@link Station} object.
     *
     * @param rs the {@link ResultSet} positioned at the current row
     * @return a {@link Station} instance with all fields populated
     * @throws SQLException if any column cannot be read from the result set
     */
    private Station map(ResultSet rs) throws SQLException {
        Station s = new Station();
        s.setStationId(rs.getInt("station_id"));
        s.setStationName(rs.getString("station_name"));
        s.setDistrictId(rs.getInt("district_id"));
        s.setManagerId(rs.getInt("manager_id"));
        s.setDistrictName(rs.getString("district_name"));
        s.setManagerName(rs.getString("manager_name"));
        s.setAddress(rs.getString("address"));
        s.setContactNumber(rs.getString("contact_number"));
        s.setChargerType(rs.getString("charger_type"));
        s.setTotalPorts(rs.getInt("total_ports"));
        s.setOpeningTime(rs.getTime("opening_time"));
        s.setClosingTime(rs.getTime("closing_time"));
        s.setPricePerHour(rs.getBigDecimal("price_per_hour"));
        s.setStatus(rs.getString("status"));
        return s;
    }

    /**
     * Retrieves all stations from the database, ordered by station ID descending.
     *
     * @return a {@link List} of all {@link Station} objects; empty list if none found
     */
    public List<Station> findAll() {
        return query(base + " ORDER BY s.station_id DESC");
    }

    /**
     * Retrieves all stations assigned to a specific manager,
     * ordered by station ID descending.
     *
     * @param managerId the ID of the manager whose stations are to be retrieved
     * @return a {@link List} of {@link Station} objects managed by the given manager;
     *         empty list if none found
     */
    public List<Station> findByManager(int managerId) {
        return query(base + " WHERE s.manager_id=" + managerId + " ORDER BY s.station_id DESC");
    }

    /**
     * Searches for active stations using optional filters for district and charger type.
     *
     * <p>Only stations with {@code status = 'active'} are returned. Both filter
     * parameters are optional — passing {@code null} or a blank string for
     * {@code chargerType}, or {@code null} or a value {@code <= 0} for
     * {@code districtId}, will omit that filter from the query.</p>
     *
     * <p>Unlike {@link #query(String)}, this method uses full parameterization
     * via a dynamically built {@link PreparedStatement}, making it safe against
     * SQL injection.</p>
     *
     * @param districtId  the ID of the district to filter by, or {@code null} / {@code <= 0}
     *                    to skip the district filter
     * @param chargerType the charger type to filter by (e.g. {@code "AC"}, {@code "DC"}),
     *                    or {@code null} / blank to skip the charger type filter
     * @return a {@link List} of matching active {@link Station} objects;
     *         empty list if no matches found or an error occurs
     */
    public List<Station> search(Integer districtId, String chargerType) {
        List<Station> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(base + " WHERE s.status='active'");
        if (districtId != null && districtId > 0) sql.append(" AND s.district_id=?");
        if (chargerType != null && !chargerType.isBlank()) sql.append(" AND s.charger_type=?");
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql.toString())) {
            int i = 1;
            if (districtId != null && districtId > 0) ps.setInt(i++, districtId);
            if (chargerType != null && !chargerType.isBlank()) ps.setString(i, chargerType);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Executes a raw SQL query and maps each resulting row to a {@link Station}.
     *
     * <p><strong>Note:</strong> This method executes the provided SQL string directly
     * without parameterization. Callers must ensure the SQL is safe to prevent
     * SQL injection vulnerabilities.</p>
     *
     * @param sql the SQL query string to execute
     * @return a {@link List} of mapped {@link Station} objects; empty list on error or no results
     */
    private List<Station> query(String sql) {
        List<Station> list = new ArrayList<>();
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
     * Finds a single station by its unique ID.
     *
     * @param id the station ID to search for
     * @return the matching {@link Station}, or {@code null} if not found
     */
    public Station findById(int id) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(base + " WHERE s.station_id=?")) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Inserts a new station record into the {@code stations} table.
     *
     * <p>The {@code stationId} field on the provided {@link Station} object is
     * ignored, as it is auto-generated by the database. If {@code managerId}
     * is {@code <= 0}, a SQL {@code NULL} is stored instead.</p>
     *
     * <p>If {@code pricePerHour} is {@code null}, it defaults to
     * {@link BigDecimal#ZERO} before insertion.</p>
     *
     * @param s the {@link Station} object containing all fields required for insertion
     * @return {@code true} if the station was successfully inserted; {@code false} otherwise
     */
    public boolean save(Station s) {
        String sql = "INSERT INTO stations(station_name, district_id, manager_id, address, " +
                "contact_number, charger_type, total_ports, opening_time, closing_time, " +
                "price_per_hour, status) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        return executeSaveUpdate(sql, s, false);
    }

    /**
     * Updates an existing station record in the {@code stations} table.
     *
     * <p>The {@link Station} object must have a valid {@code stationId} set,
     * as it is used in the {@code WHERE} clause to identify the record.
     * If {@code managerId} is {@code <= 0}, a SQL {@code NULL} is stored instead.
     * If {@code pricePerHour} is {@code null}, it defaults to {@link BigDecimal#ZERO}.</p>
     *
     * @param s the {@link Station} object containing updated field values and a valid station ID
     * @return {@code true} if the update affected at least one row; {@code false} otherwise
     */
    public boolean update(Station s) {
        String sql = "UPDATE stations SET station_name=?, district_id=?, manager_id=?, " +
                "address=?, contact_number=?, charger_type=?, total_ports=?, opening_time=?, " +
                "closing_time=?, price_per_hour=?, status=? WHERE station_id=?";
        return executeSaveUpdate(sql, s, true);
    }

    /**
     * Updates only the assigned manager for a specific station.
     *
     * <p>If {@code managerId} is {@code <= 0}, the manager field is set to
     * SQL {@code NULL}, effectively unassigning any current manager from the station.</p>
     *
     * <p>Prefer this method over {@link #update(Station)} when only the manager
     * assignment needs to change, to avoid binding all other station fields unnecessarily.</p>
     *
     * @param stationId the ID of the station to update
     * @param managerId the ID of the new manager to assign, or {@code <= 0} to unassign
     * @return {@code true} if the update affected at least one row; {@code false} otherwise
     */
    public boolean updateManager(int stationId, int managerId) {
        String sql = "UPDATE stations SET manager_id=? WHERE station_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            if (managerId > 0) ps.setInt(1, managerId);
            else ps.setNull(1, Types.INTEGER);
            ps.setInt(2, stationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Shared helper that binds {@link Station} fields and executes an INSERT or UPDATE statement.
     *
     * <p>Handles the {@code NULL} substitution for {@code managerId} when it is
     * {@code <= 0}, and substitutes {@link BigDecimal#ZERO} for a {@code null}
     * {@code pricePerHour}. When {@code update} is {@code true}, the station ID
     * is additionally bound as the final parameter for the {@code WHERE} clause.</p>
     *
     * @param sql    the SQL string to execute (INSERT or UPDATE)
     * @param s      the {@link Station} object whose fields are to be bound
     * @param update {@code true} if this is an update operation requiring the station ID
     *               as the final parameter; {@code false} for an insert
     * @return {@code true} if the operation affected at least one row; {@code false} otherwise
     */
    private boolean executeSaveUpdate(String sql, Station s, boolean update) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, s.getStationName());
            ps.setInt(2, s.getDistrictId());
            if (s.getManagerId() > 0) ps.setInt(3, s.getManagerId());
            else ps.setNull(3, Types.INTEGER);
            ps.setString(4, s.getAddress());
            ps.setString(5, s.getContactNumber());
            ps.setString(6, s.getChargerType());
            ps.setInt(7, s.getTotalPorts());
            ps.setTime(8, s.getOpeningTime());
            ps.setTime(9, s.getClosingTime());
            ps.setBigDecimal(10, s.getPricePerHour() == null ? BigDecimal.ZERO : s.getPricePerHour());
            ps.setString(11, s.getStatus());
            if (update) ps.setInt(12, s.getStationId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Permanently deletes a station from the database.
     *
     * <p><strong>Note:</strong> This operation is irreversible. Deleting a station
     * that is referenced by existing bookings, slots, or favourites may violate
     * foreign key constraints depending on the database schema configuration.</p>
     *
     * @param id the unique ID of the station to delete
     * @return {@code true} if the deletion was successful; {@code false} if no record
     *         was found with the given ID or an error occurs
     */
    public boolean delete(int id) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     "DELETE FROM stations WHERE station_id=?")) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Returns the total number of stations across the entire system.
     *
     * @return the total station count, or {@code 0} if an error occurs
     */
    public int count() {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT COUNT(*) FROM stations")) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}