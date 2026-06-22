package tools;

import java.sql.Connection;
import java.sql.DriverManager;

public class Database {
    private static final String URL = "jdbc:postgresql://localhost:5432/mahery_vaika";
    private static final String USER = "postgres";
    private static final String PASSWORD = "POSTGRES"; 

    public Connection dbconnect() throws Exception {
        Class.forName("org.postgresql.Driver");
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}