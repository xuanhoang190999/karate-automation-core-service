package runs.fixes;

import com.intuit.karate.junit5.Karate;
import app.shareds.utils.Helper;
import java.util.List;

class FixTest {

    @Karate.Test
    Karate testFixes() {
        List<String> features = Helper.ReadFile("src/test/java/runs/fixes/features.json");
        return Karate.run(features.toArray(new String[0])).relativeTo(getClass());
    }
}
