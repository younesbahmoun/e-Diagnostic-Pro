package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

// public class DatabaseConnection {

//     private static final String URL = "jdbc:postgresql://localhost:5432/tele_expertise";

//     private static final String USER = "postgres";
//     private static final String PASSWORD = "yns1234";

//     public static Connection getConnection() throws SQLException {
//         return DriverManager.getConnection(URL, USER, PASSWORD);
//     }
// }


public class DatabaseConnection {

    private static final String URL =
            "jdbc:postgresql://localhost:5432/tele_expertise";

    private static final String USER = "postgres";
    private static final String PASSWORD = "yns1234";

    static {
        try {
            Class.forName("org.postgresql.Driver");
            System.out.println("PostgreSQL Driver loaded!");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("PostgreSQL Driver not found", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}