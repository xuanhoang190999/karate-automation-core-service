package app.services;

import app.dataAccess.PolkVehicleDA;
import app.dataAccess.TsbDA;
import app.shareds.models.*;

import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

public class TSBService {

    private final PolkVehicleDA polkDA;
    private final TsbDA tsbDA;
    private final SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy");
    private final String tsbRootUrl;

    public TSBService(PolkVehicleDA polkDA, TsbDA tsbDA, String tsbRootUrl) {
        this.polkDA = polkDA;
        this.tsbDA = tsbDA;
        this.tsbRootUrl = tsbRootUrl;
    }

    public List<TSBInfoResponse> getTSBsForVehicleByYMME(int year, String make, String model, String engineType)
            throws Exception {
        List<String> polkVehicles = polkDA.getListAAIAByYearMakeModelEngineAsync(year, make, model, engineType);
        List<String> polkAAIA = polkVehicles.stream()
                .filter(v -> v != null && !v.isEmpty())
                .collect(Collectors.toList());

        System.out.println("[DEBUG] polkAAIA: " + polkAAIA);

        if (polkAAIA.isEmpty())
            return Collections.emptyList();

        List<TSBInfo> tsbResults = tsbDA.getTsbInfoByAAIAList(polkAAIA);
        System.out.println("[DEBUG] tsbResults: " + tsbResults.size());

        List<TSBCategory> tsbCategories = tsbDA.getTsbCategoriesByAAIAList(polkAAIA);
        System.out.println("[DEBUG] tsbCategories: " + tsbCategories.size());

        List<TSBInfoResponse> response = new ArrayList<>();

        for (TSBInfo item : tsbResults) {
            TSBInfoResponse res = new TSBInfoResponse();
            res.tsbId = item.tsbId;
            res.description = Optional.ofNullable(item.description).orElse("");
            res.fileNamePDF = Optional.ofNullable(item.fileNamePDF).orElse("");
            res.pdfFileUrl = (item.fileNamePDF != null && !item.fileNamePDF.isEmpty())
                    ? buildPdfUrl(tsbRootUrl, item.tsbId, item.fileNamePDF)
                    : "";
            res.manufacturerNumber = Optional.ofNullable(item.manufacturerNumber).orElse("");
            res.issueDateString = df.format(item.issueDate);
            res.tsbText = Optional.ofNullable(item.tsbText).orElse("");
            res.createdDateString = df.format(item.createdDateTime);
            res.updatedDateString = df.format(item.updatedDateTime);

            List<TSBCategory> catForItem = tsbCategories.stream()
                    .filter(c -> c.tsbId == item.tsbId)
                    .collect(Collectors.toList());

            List<TSBCategoryInfoResponse> catResp = new ArrayList<>();
            for (TSBCategory c : catForItem) {
                TSBCategoryInfoResponse catInfo = new TSBCategoryInfoResponse();
                catInfo.id = c.canOBD2CategoryId;
                catInfo.description = c.canOBD2CategoryName;
                catInfo.tsbCount = 1; // (int) catForItem.stream().distinct().count();
                catResp.add(catInfo);
            }

            res.tsbCategories = catResp;
            response.add(res);
        }

        return response;
    }

    private String buildPdfUrl(String rootUrl, int tsbId, String fileName) {
        return String.format("%s/%d/%s", rootUrl, tsbId, fileName);
    }
}
