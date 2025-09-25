package runs.dtcs;

import com.intuit.karate.junit5.Karate;
import app.shareds.utils.Helper;
import java.util.List;

class DTCLibraryErrorCodeTest {

    @Karate.Test
    Karate testDTCLibraryErrorCodes() {
        List<String> features = Helper.ReadFile("src/test/java/runs/dtc-library-error-code/features.json");
        return Karate.run(features.toArray(new String[0])).relativeTo(getClass());
    }
}
