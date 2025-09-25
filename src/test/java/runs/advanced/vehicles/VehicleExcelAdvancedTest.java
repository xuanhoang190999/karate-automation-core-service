package runs.advanced.vehicles;

import com.intuit.karate.junit5.Karate;

class VehicleExcelAdvancedTest {

    @Karate.Test
    Karate testVehicle() {
        return Karate.run("classpath:resources/apis/advanced/vehicles/decode-excel.feature")
                .relativeTo(getClass());
    }
}
