package tools;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Database {

    private String url = "jdbc:postgresql://localhost:5432/mahery_vaika";
    private String user = "postgres";
    private String password = "root";

    public Connection dbconnect() {
        Connection c = null;

        try {
            Class.forName("org.postgresql.Driver");
            c = DriverManager.getConnection(url, user, password);

        } catch (ClassNotFoundException e) {
            System.out.println("⚠️ Driver PostgreSQL introuvable !");
        } catch (SQLException e) {
            System.out.println("⚠️ Erreur SQL : " + e.getMessage());
        }

        return c;
    }
}
