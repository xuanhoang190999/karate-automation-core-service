package runs.advanced.sm;

import com.intuit.karate.junit5.Karate;

public class ScheduleMaintenanceTest {

    @Karate.Test
    Karate testVehicle() {
        return Karate.run("classpath:resources/apis/advanced/sm/schedule-maintenances.feature")
                .relativeTo(getClass());
    }
}
