package app.shareds.models;

import java.util.UUID;

public class ScheduleMaintenancePlanService {
    public UUID scheduleMaintenancePlanId;
    public UUID scheduleMaintenancePlanDetailId;
    public UUID scheduleMaintenanceServiceId;
    public int mileage;
    public int mileageRepeat;
    public int nextServiceMileageInterval;
    public int kilometers;
    public int kilometersRepeat;
    public int nextServiceKilometersInterval;
    public UUID fixNameId;
    public String serviceName;
}
