package app.dataAccess;

import app.shareds.models.TSBInfo;
import app.shareds.models.TSBCategory;
import app.shareds.utils.DbUtil;
import app.config.DbConfig;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class TsbDA {

    private final String dbUrl = DbConfig.chiltonUrl();
    private final String user = DbConfig.USER;
    private final String password = DbConfig.PASS;

    public TsbDA() {
    }

    public List<TSBInfo> getTsbInfoByAAIAList(List<String> aaiaList) throws Exception {
        List<TSBInfo> result = new ArrayList<>();
        String sql = """
                DECLARE @AAIAList VARCHAR(MAX) = ?;
                DECLARE @TempIssueDate DATETIME;
                SET @TempIssueDate = DATEADD(DAY, -30, GETDATE());

                ;WITH AAIAValues AS (
                    SELECT DISTINCT LTRIM(RTRIM([value])) AS AAIA
                    FROM STRING_SPLIT(@AAIAList, '|')
                    WHERE ISNULL([value], '') <> ''
                ),
                DistinctTsbs AS (
                    SELECT DISTINCT TSB.TSBID
                    FROM TSB WITH (NOLOCK)
                    JOIN ActiveBulletin WITH (NOLOCK) ON ActiveBulletin.BulletinId = TSB.TSBID
                    JOIN BulletinToPolkVehicle polk WITH (NOLOCK) ON polk.BulletinId = TSB.TSBID
                    JOIN AAIAValues tav ON tav.AAIA = polk.AAIA
                )
                SELECT
                    TSB.TSBID,
                    ISNULL(TSB.Description,'') AS Description,
                    TSB.FileNamePDF,
                    ISNULL(TSB.ManufacturerNumber,'') AS ManufacturerNumber,
                    ISNULL(TSB.IssueDate, @TempIssueDate) AS IssueDate,
                    TSB.TSBText,
                    TSB.CreatedDateTime,
                    TSB.UpdatedDateTime
                FROM TSB WITH (NOLOCK)
                JOIN DistinctTsbs d ON d.TsbId = TSB.TSBId;
                """;
        try (Connection conn = DbUtil.getConnection(dbUrl, user, password);
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, String.join("|", aaiaList));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TSBInfo tsb = new TSBInfo();
                    tsb.tsbId = rs.getInt("TsbId");
                    tsb.description = rs.getString("Description");
                    tsb.fileNamePDF = rs.getString("FileNamePDF");
                    tsb.manufacturerNumber = rs.getString("ManufacturerNumber");
                    tsb.issueDate = rs.getDate("IssueDate");
                    tsb.tsbText = rs.getString("TsbText");
                    tsb.createdDateTime = rs.getDate("CreatedDateTime");
                    tsb.updatedDateTime = rs.getDate("UpdatedDateTime");
                    result.add(tsb);
                }
            }
        }
        return result;
    }

    public List<TSBCategory> getTsbCategoriesByAAIAList(List<String> aaiaList) throws Exception {
        List<TSBCategory> result = new ArrayList<>();
        String sql = """
                DECLARE @AAIAList VARCHAR(MAX) = ?;
                DECLARE @TempIssueDate DATETIME;
                SET @TempIssueDate = DATEADD(DAY, -30, GETDATE());

                ;WITH AAIAValues AS (
                    SELECT DISTINCT LTRIM(RTRIM([value])) AS AAIA
                    FROM STRING_SPLIT(@AAIAList, '|')
                    WHERE ISNULL([value], '') <> ''
                ),
                DistinctTsbs AS (
                    SELECT DISTINCT TSB.TSBID
                    FROM TSB WITH (NOLOCK)
                    JOIN ActiveBulletin WITH (NOLOCK) ON ActiveBulletin.BulletinId = TSB.TSBID
                    JOIN BulletinToPolkVehicle polk WITH (NOLOCK) ON polk.BulletinId = TSB.TSBID
                    JOIN AAIAValues tav ON tav.AAIA = polk.AAIA
                )
                SELECT
                    d.TsbId,
                    c.CanOBD2CategoryId,
                    c.CanOBD2CategoryName
                FROM
                    DistinctTsbs d
                JOIN TSB_ByCanOBD2Category Tsb_c WITH (NOLOCK)
                    ON Tsb_c.TsbId = d.TsbId
                JOIN
                    CanOBD2Category c WITH (NOLOCK)
                    ON c.CanOBD2CategoryId = Tsb_c.CanOBD2CategoryId;
                """;
        try (Connection conn = DbUtil.getConnection(dbUrl, user, password);
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, String.join("|", aaiaList));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TSBCategory cat = new TSBCategory();
                    cat.tsbId = rs.getInt("TsbId");
                    cat.canOBD2CategoryId = rs.getInt("CanOBD2CategoryId");
                    cat.canOBD2CategoryName = rs.getString("CanOBD2CategoryName");
                    result.add(cat);
                }
            }
        }
        return result;
    }
}
