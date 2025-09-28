package app.dataAccess;

import app.shareds.utils.DbUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import app.config.DbConfig;

public class PolkVehicleDA {

    private final String dbUrl = DbConfig.innovaUrl();
    private final String user = DbConfig.USER;
    private final String password = DbConfig.PASS;

    public PolkVehicleDA() {
    }

    public List<String> getListAAIAByYearMakeModelEngineAsync(int year, String make, String model, String engineType)
            throws Exception {
        List<String> aaiaList = new ArrayList<>();
        String sql = "SELECT DISTINCT AAIA FROM PolkVehicleYMME WHERE Year = ? AND Make = ? AND Model = ? AND PrimaryEngineType = ?";
        try (Connection conn = DbUtil.getConnection(dbUrl, user, password);
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, year);
            ps.setString(2, make);
            ps.setString(3, model);
            ps.setString(4, engineType);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String aaia = rs.getString("AAIA");
                    if (aaia != null && !aaia.isEmpty()) {
                        aaiaList.add(aaia);
                    }
                }
            }
        }
        return aaiaList;
    }

}
