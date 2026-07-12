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
            throw new RuntimeException("Driver PostgreSQL introuvable ! Verifiez que le .jar postgresql-x.x.x.jar est bien dans WEB-INF/lib", e);
        } catch (SQLException e) {
            throw new RuntimeException("Erreur de connexion a la base de donnees : " + e.getMessage(), e);
        }
    }
}