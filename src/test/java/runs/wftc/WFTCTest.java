package runs.wftc;

import com.intuit.karate.junit5.Karate;
import app.shareds.utils.Helper;
import java.util.List;

class WFTCTest {

    @Karate.Test
    Karate testWftc() {
        List<String> features = Helper.ReadFile("src/test/java/runs/wftc/features.json");
        return Karate.run(features.toArray(new String[0])).relativeTo(getClass());
    }
}
