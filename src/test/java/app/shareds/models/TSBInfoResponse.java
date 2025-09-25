package app.shareds.models;

import java.util.List;

public class TSBInfoResponse {
    public int tsbId;
    public String description;
    public String fileNamePDF;
    public String pdfFileUrl;
    public String manufacturerNumber;
    public String issueDateString;
    public String tsbText;
    public String createdDateString;
    public String updatedDateString;
    public List<TSBCategoryInfoResponse> tsbCategories;
}