package gestion;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import models.Ville;
import tools.Database;

public class VilleGestion {

    public List<Ville> getAllVilles() {
        List<Ville> villes = new ArrayList<>();
        Database db = new Database();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = db.dbconnect();
            if (conn != null) {
                stmt = conn.createStatement();
                rs = stmt.executeQuery("SELECT * FROM ville WHERE actif = true ORDER BY nom_ville");

                while (rs.next()) {
                    Ville v = new Ville();
                    v.setIdVille(rs.getInt("id_ville"));
                    v.setNomVille(rs.getString("nom_ville"));
                    v.setProvince(rs.getString("province"));
                    v.setActif(rs.getBoolean("actif"));
                    villes.add(v);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (stmt != null) stmt.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
        return villes;
    }
}
