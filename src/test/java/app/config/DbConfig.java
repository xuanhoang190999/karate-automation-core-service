package app.config;

public class DbConfig {
    public static final String DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    public static final String USER = "innova";
    public static final String PASS = "Innova123";
    public static final String BASE = "jdbc:sqlserver://172.30.2.117;encrypt=true;trustServerCertificate=true";

    private static final String InnovaDB = "Innova";
    private static final String ChiltonDB = "ChiltonContentDelivery_Bulletins";

    public static String innovaUrl() {
        return BASE + ";databaseName=" + InnovaDB;
    }

    public static String chiltonUrl() {
        return BASE + ";databaseName=" + ChiltonDB;
    }
}
