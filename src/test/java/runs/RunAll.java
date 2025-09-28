package runs;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.junit.jupiter.api.Test;

import app.shareds.utils.Helper;
import java.util.List;

import java.util.ArrayList;
import static org.junit.jupiter.api.Assertions.assertEquals;

class RunAll {

    @Test
    void testAll() {
        List<String> dlcLocationFeatures = Helper.ReadFile("src/test/java/runs/dlcLocations/features.json");
        List<String> dtcLibraryErrorCodeFeatures = Helper
                .ReadFile("src/test/java/runs/dtcs/features.json");
        List<String> fixFeatures = Helper.ReadFile("src/test/java/runs/fixes/features.json");
        List<String> recallFeatures = Helper.ReadFile("src/test/java/runs/recalls/features.json");
        List<String> tsbsFeatures = Helper.ReadFile("src/test/java/runs/tsbs/features.json");
        List<String> wftcFeatures = Helper.ReadFile("src/test/java/runs/wftc/features.json");
        List<String> vehicleFeatures = Helper.ReadFile("src/test/java/runs/vehicles/features.json");
        List<String> advancedFeatures = Helper.ReadFile("src/test/java/runs/advanced/features.json");

        List<String> features = new ArrayList<>();

        features.addAll(dlcLocationFeatures);
        features.addAll(dtcLibraryErrorCodeFeatures);
        features.addAll(fixFeatures);
        features.addAll(recallFeatures);
        features.addAll(tsbsFeatures);
        features.addAll(wftcFeatures);
        features.addAll(vehicleFeatures);
        features.addAll(advancedFeatures);

        Results results = Runner.path(features.toArray(new String[0]))
                .parallel(1);

        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
}
