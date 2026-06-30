package gestion;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import tools.Database;

public class Ville {
    private int idVille;
    private String nomVille;
    private String province;
    private boolean actif;

    public Ville() {}

    public Ville(int idVille, String nomVille, String province, boolean actif) {
        this.idVille   = idVille;
        this.nomVille  = nomVille;
        this.province  = province;
        this.actif     = actif;
    }

    public int getIdVille()                { return idVille;  }
    public void setIdVille(int idVille)    { this.idVille = idVille; }

    public String getNomVille()                    { return nomVille;  }
    public void setNomVille(String nomVille)       { this.nomVille = nomVille; }

    public String getProvince()                    { return province;  }
    public void setProvince(String province)       { this.province = province; }

    public boolean isActif()               { return actif;  }
    public void setActif(boolean actif)    { this.actif = actif; }

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
                rs = stmt.executeQuery(
                    "SELECT * FROM ville WHERE actif = true ORDER BY nom_ville"
                );
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
            try { if (rs   != null) rs.close();   } catch (SQLException e) {}
            try { if (stmt != null) stmt.close();  } catch (SQLException e) {}
            try { if (conn != null) conn.close();  } catch (SQLException e) {}
        }
        return villes;
    }

    public Ville getVilleById(int id) {
        Ville ville = null;
        Database db = new Database();
        Connection conn = null;
        java.sql.PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = db.dbconnect();
            if (conn != null) {
                pstmt = conn.prepareStatement("SELECT * FROM ville WHERE id_ville = ?");
                pstmt.setInt(1, id);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    ville = new Ville();
                    ville.setIdVille(rs.getInt("id_ville"));
                    ville.setNomVille(rs.getString("nom_ville"));
                    ville.setProvince(rs.getString("province"));
                    ville.setActif(rs.getBoolean("actif"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
        return ville;
    }
}
