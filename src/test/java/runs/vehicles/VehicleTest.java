package run.dtc;

import com.intuit.karate.junit5.Karate;
import utils.Helper;
import java.util.List;

class VehicleTest {

    @Karate.Test
    Karate testVehicle() {
        List<String> features = Helper.ReadFile("src/test/java/runs/vehicles/features.json");
        return Karate.run(features.toArray(new String[0])).relativeTo(getClass());
    }
}
