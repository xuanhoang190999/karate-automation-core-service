package runs.dlcLocations;

import com.intuit.karate.junit5.Karate;
import app.shareds.utils.Helper;
import java.util.List;

class DLCLocationTest {

    @Karate.Test
    Karate testDlcLocations() {
        List<String> features = Helper.ReadFile("src/test/java/runs/dlc-locations/features.json");
        return Karate.run(features.toArray(new String[0])).relativeTo(getClass());
    }
}
