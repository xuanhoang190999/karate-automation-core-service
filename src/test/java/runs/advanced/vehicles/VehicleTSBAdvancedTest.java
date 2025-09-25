package runs.advanced.vehicles;

import com.intuit.karate.junit5.Karate;

class VehicleTSBAdvancedTest {

    @Karate.Test
    Karate testVehicle() {
        return Karate.run("classpath:resources/apis/advanced/vehicles/decode-verify-tsb.feature")
                .relativeTo(getClass());
    }
}
