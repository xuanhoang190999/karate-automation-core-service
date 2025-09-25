package app.database;

import app.shareds.utils.DbUtil;

import java.sql.*;
import java.util.*;

public class BaseDA {

    public static List<Map<String, Object>> query(String dbUrl, String user, String pass, String sql) throws Exception {
        List<Map<String, Object>> result = new ArrayList<>();
        try (Connection conn = DbUtil.getConnection(dbUrl, user, pass);
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            ResultSetMetaData meta = rs.getMetaData();
            int colCount = meta.getColumnCount();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                for (int i = 1; i <= colCount; i++) {
                    row.put(meta.getColumnLabel(i), rs.getObject(i));
                }
                result.add(row);
            }
        }
        return result;
    }
}
