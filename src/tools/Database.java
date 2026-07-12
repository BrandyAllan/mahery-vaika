package tools;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Database {

    private static final String URL  = "jdbc:postgresql://localhost:5432/mahery_vaika";
    private static final String USER = "postgres";
    private static final String PASS = " ";

    public Connection dbconnect() {
        return getConnection();
    }

    public static Connection getConnection() {
        try {
            Class.forName("org.postgresql.Driver");
            return DriverManager.getConnection(URL, USER, PASS);
        } catch (ClassNotFoundException e) {
            System.out.println("Driver PostgreSQL introuvable !");
        } catch (SQLException e) {
            System.out.println("Erreur SQL : " + e.getMessage());
        }
        return null;
    }
}