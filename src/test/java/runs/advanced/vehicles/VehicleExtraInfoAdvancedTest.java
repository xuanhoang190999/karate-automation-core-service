package runs.advanced.vehicles;

import com.intuit.karate.junit5.Karate;

public class VehicleExtraInfoAdvancedTest {

    @Karate.Test
    Karate testVehicle() {
        return Karate.run("classpath:resources/apis/advanced/vehicles/extra-info.feature")
                .relativeTo(getClass());
    }
}
