package app.dataAccess;

import app.config.DbConfig;
import app.shareds.utils.DbUtil;
import app.shareds.models.ScheduleMaintenancePlanService;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ScheduleMaintenanceDA {

    private final String dbUrl = DbConfig.innovaUrl();
    private final String user = DbConfig.USER;
    private final String password = DbConfig.PASS;

    public ScheduleMaintenanceDA() {
    }

    public List<ScheduleMaintenancePlanService> getScheduleMaintenancePlanServicesByVehicle(
            String language,
            int year,
            String make,
            String model,
            String engineType,
            String engineVINCode,
            String transmission,
            String trimLevel) throws Exception {

        List<ScheduleMaintenancePlanService> list = new ArrayList<>();

        String sql = "EXEC usp_InnovaCoreService_ScheduleMaintenance_LoadByVehicle "
                + "@Type = ?, @Language = ?, @Year = ?, @Make = ?, @Model = ?, "
                + "@EngineType = ?, @EngineVINCode = ?, @Transmission = ?, @TrimLevel = ?";

        try (Connection conn = DbUtil.getConnection(dbUrl, user, password);
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, 0);
            ps.setString(2, language);
            ps.setInt(3, year);
            ps.setString(4, make != null ? make : "");
            ps.setString(5, model != null ? model : "");
            ps.setString(6, engineType != null ? engineType : "");
            ps.setString(7, engineVINCode != null ? engineVINCode : "");
            ps.setString(8, transmission != null ? transmission : "");
            ps.setString(9, trimLevel != null ? trimLevel : "");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ScheduleMaintenancePlanService item = new ScheduleMaintenancePlanService();
                    item.scheduleMaintenancePlanId = rs.getObject("ScheduleMaintenancePlanId", java.util.UUID.class);
                    item.scheduleMaintenancePlanDetailId = rs.getObject("scheduleMaintenancePlanDetailId",
                            java.util.UUID.class);
                    item.scheduleMaintenanceServiceId = rs.getObject("scheduleMaintenanceServiceId",
                            java.util.UUID.class);
                    item.mileage = rs.getInt("mileage");
                    item.mileageRepeat = rs.getInt("mileageRepeat");
                    item.kilometers = rs.getInt("kilometers");
                    item.kilometersRepeat = rs.getInt("kilometersRepeat");
                    item.fixNameId = rs.getObject("fixNameId", java.util.UUID.class);
                    item.serviceName = rs.getString("serviceName");

                    list.add(item);
                }
            }
        }

        return list;
    }
}
