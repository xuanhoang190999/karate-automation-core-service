package runs.recalls;

import com.intuit.karate.junit5.Karate;
import app.shareds.utils.Helper;
import java.util.List;

class RecallTest {

    @Karate.Test
    Karate testRecalls() {
        List<String> features = Helper.ReadFile("src/test/java/runs/recalls/features.json");
        return Karate.run(features.toArray(new String[0])).relativeTo(getClass());
    }
}
