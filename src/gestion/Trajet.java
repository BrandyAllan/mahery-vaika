package gestion;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import tools.Database;

public class Trajet {

    private int idTrajet;
    private Ville villeDepart;
    private Ville villeArrivee;
    private BigDecimal distanceKm;
    private String dureeEstimee;
    private BigDecimal tarifBase;
    private boolean actif;

    private static final int PAGE_SIZE = 5;

    private static final java.util.Set<String> ALLOWED_SORT_FIELDS =
        new java.util.HashSet<>(
            java.util.Arrays.asList(
                "depart_nom", "arrivee_nom", "tarif_base", "distance_km", "id_trajet"
            )
        );

    public Trajet() {}

    public Trajet(int idTrajet,
                  Ville villeDepart,
                  Ville villeArrivee,
                  BigDecimal distanceKm,
                  String dureeEstimee,
                  BigDecimal tarifBase,
                  boolean actif) {
        this.idTrajet     = idTrajet;
        this.villeDepart  = villeDepart;
        this.villeArrivee = villeArrivee;
        this.distanceKm   = distanceKm;
        this.dureeEstimee = dureeEstimee;
        this.tarifBase    = tarifBase;
        this.actif        = actif;
    }

    public int getIdTrajet()                        { return idTrajet; }
    public void setIdTrajet(int idTrajet)           { this.idTrajet = idTrajet; }

    public Ville getVilleDepart()                   { return villeDepart; }
    public void setVilleDepart(Ville v)             { this.villeDepart = v; }

    public Ville getVilleArrivee()                  { return villeArrivee; }
    public void setVilleArrivee(Ville v)            { this.villeArrivee = v; }

    public BigDecimal getDistanceKm()               { return distanceKm; }
    public void setDistanceKm(BigDecimal distanceKm){ this.distanceKm = distanceKm; }

    public String getDureeEstimee()                 { return dureeEstimee; }
    public void setDureeEstimee(String dureeEstimee){ this.dureeEstimee = dureeEstimee; }

    public BigDecimal getTarifBase()                { return tarifBase; }
    public void setTarifBase(BigDecimal tarifBase)  { this.tarifBase = tarifBase; }

    public boolean isActif()                        { return actif; }
    public void setActif(boolean actif)             { this.actif = actif; }

    public int getPageSize() {
        return PAGE_SIZE;
    }

    // =========================================================
    //  Méthodes de gestion des trajets
    // =========================================================

    public List<Trajet> rechercherTrajets(String searchDepart, String searchArrivee,
            String searchTarif, String searchStatut,
            String dateDebut, String dateFin,
            String sortField, String sortOrder,
            int page) {

        List<Trajet> trajets = new ArrayList<>();
        Database db = new Database();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = db.dbconnect();
            if (conn != null) {
                StringBuilder sql = buildBaseQuery(
                    searchDepart, searchArrivee, searchTarif, searchStatut, dateDebut, dateFin
                );

                String safeSortField = ALLOWED_SORT_FIELDS.contains(sortField) ? sortField : "id_trajet";
                String safeSortOrder = "ASC".equalsIgnoreCase(sortOrder) ? "ASC" : "DESC";
                sql.append(" ORDER BY ").append(safeSortField).append(" ").append(safeSortOrder);

                int offset = (page - 1) * PAGE_SIZE;
                sql.append(" LIMIT ? OFFSET ?");

                pstmt = conn.prepareStatement(sql.toString());
                int idx = setQueryParams(pstmt, searchDepart, searchArrivee,
                        searchTarif, searchStatut, dateDebut, dateFin, 1);
                pstmt.setInt(idx++, PAGE_SIZE);
                pstmt.setInt(idx, offset);

                rs = pstmt.executeQuery();
                while (rs.next()) {
                    trajets.add(mapResultSetToTrajet(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        return trajets;
    }

    public int countTrajets(String searchDepart, String searchArrivee,
            String searchTarif, String searchStatut,
            String dateDebut, String dateFin) {

        int count = 0;
        Database db = new Database();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = db.dbconnect();
            if (conn != null) {
                StringBuilder countSql = new StringBuilder(
                    "SELECT COUNT(DISTINCT t.id_trajet) FROM trajet t " +
                    "JOIN ville v1 ON t.id_ville_depart = v1.id_ville " +
                    "JOIN ville v2 ON t.id_ville_arrivee = v2.id_ville " +
                    "WHERE 1=1"
                );
                appendFilters(countSql, searchDepart, searchArrivee, searchTarif, searchStatut, dateDebut, dateFin);

                if ((dateDebut != null && !dateDebut.isEmpty()) || (dateFin != null && !dateFin.isEmpty())) {
                    countSql.append(" AND EXISTS (SELECT 1 FROM depart d WHERE d.id_trajet = t.id_trajet");
                    if (dateDebut != null && !dateDebut.isEmpty()) {
                        countSql.append(" AND d.date_depart >= ?");
                    }
                    if (dateFin != null && !dateFin.isEmpty()) {
                        countSql.append(" AND d.date_depart <= ?");
                    }
                    countSql.append(")");
                }

                pstmt = conn.prepareStatement(countSql.toString());
                setQueryParams(pstmt, searchDepart, searchArrivee,
                        searchTarif, searchStatut, dateDebut, dateFin, 1);

                rs = pstmt.executeQuery();
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        return count;
    }

    public List<Trajet> rechercherTrajets(String searchDepart, String searchArrivee,
            String searchTarif, String searchStatut) {
        return rechercherTrajets(searchDepart, searchArrivee, searchTarif, searchStatut,
                null, null, "id_trajet", "DESC", 1);
    }

    private StringBuilder buildBaseQuery(String searchDepart, String searchArrivee,
            String searchTarif, String searchStatut,
            String dateDebut, String dateFin) {

        StringBuilder sql = new StringBuilder(
            "SELECT t.*, v1.nom_ville AS depart_nom, v2.nom_ville AS arrivee_nom " +
            "FROM trajet t " +
            "JOIN ville v1 ON t.id_ville_depart = v1.id_ville " +
            "JOIN ville v2 ON t.id_ville_arrivee = v2.id_ville " +
            "WHERE 1=1"
        );
        appendFilters(sql, searchDepart, searchArrivee, searchTarif, searchStatut, dateDebut, dateFin);
        return sql;
    }

    private void appendFilters(StringBuilder sql,
            String searchDepart, String searchArrivee,
            String searchTarif, String searchStatut,
            String dateDebut, String dateFin) {

        if (searchDepart != null && !searchDepart.isEmpty()) {
            sql.append(" AND t.id_ville_depart = ?");
        }
        if (searchArrivee != null && !searchArrivee.isEmpty()) {
            sql.append(" AND t.id_ville_arrivee = ?");
        }
        if (searchTarif != null && !searchTarif.isEmpty()) {
            sql.append(" AND t.tarif_base <= ?");
        }
        if (searchStatut != null && !searchStatut.isEmpty()) {
            sql.append(" AND t.actif = ?");
        }
        if ((dateDebut != null && !dateDebut.isEmpty()) || (dateFin != null && !dateFin.isEmpty())) {
            sql.append(" AND EXISTS (SELECT 1 FROM depart d WHERE d.id_trajet = t.id_trajet");
            if (dateDebut != null && !dateDebut.isEmpty()) {
                sql.append(" AND d.date_depart >= ?");
            }
            if (dateFin != null && !dateFin.isEmpty()) {
                sql.append(" AND d.date_depart <= ?");
            }
            sql.append(")");
        }
    }

    private int setQueryParams(PreparedStatement pstmt,
            String searchDepart, String searchArrivee,
            String searchTarif, String searchStatut,
            String dateDebut, String dateFin,
            int startIdx) throws Exception {

        int idx = startIdx;
        if (searchDepart != null && !searchDepart.isEmpty()) {
            pstmt.setInt(idx++, Integer.parseInt(searchDepart));
        }
        if (searchArrivee != null && !searchArrivee.isEmpty()) {
            pstmt.setInt(idx++, Integer.parseInt(searchArrivee));
        }
        if (searchTarif != null && !searchTarif.isEmpty()) {
            pstmt.setBigDecimal(idx++, new BigDecimal(searchTarif));
        }
        if (searchStatut != null && !searchStatut.isEmpty()) {
            pstmt.setBoolean(idx++, Boolean.parseBoolean(searchStatut));
        }
        if ((dateDebut != null && !dateDebut.isEmpty()) || (dateFin != null && !dateFin.isEmpty())) {
            if (dateDebut != null && !dateDebut.isEmpty()) {
                pstmt.setDate(idx++, java.sql.Date.valueOf(dateDebut));
            }
            if (dateFin != null && !dateFin.isEmpty()) {
                pstmt.setDate(idx++, java.sql.Date.valueOf(dateFin));
            }
        }
        return idx;
    }

    public Trajet getTrajetById(int id) {
        Trajet trajet = null;
        Database db = new Database();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = db.dbconnect();
            if (conn != null) {
                String sql =
                    "SELECT t.*, v1.nom_ville AS depart_nom, v2.nom_ville AS arrivee_nom " +
                    "FROM trajet t " +
                    "JOIN ville v1 ON t.id_ville_depart = v1.id_ville " +
                    "JOIN ville v2 ON t.id_ville_arrivee = v2.id_ville " +
                    "WHERE t.id_trajet = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, id);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    trajet = mapResultSetToTrajet(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        return trajet;
    }

    public boolean ajouterTrajet(Trajet t) {
        Database db = new Database();
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;

        try {
            conn = db.dbconnect();
            if (conn != null) {
                String sql =
                    "INSERT INTO trajet " +
                    "(id_ville_depart, id_ville_arrivee, distance_km, duree_estimee, tarif_base, actif) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, t.getVilleDepart().getIdVille());
                pstmt.setInt(2, t.getVilleArrivee().getIdVille());

                if (t.getDistanceKm() != null) {
                    pstmt.setBigDecimal(3, t.getDistanceKm());
                } else {
                    pstmt.setNull(3, Types.NUMERIC);
                }

                pstmt.setString(4, t.getDureeEstimee());
                pstmt.setBigDecimal(5, t.getTarifBase());
                pstmt.setBoolean(6, true);

                pstmt.executeUpdate();
                success = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }
        return success;
    }

    public boolean modifierTrajet(Trajet t) {
        Database db = new Database();
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;

        try {
            conn = db.dbconnect();
            if (conn != null) {
                String sql =
                    "UPDATE trajet SET " +
                    "id_ville_depart = ?, id_ville_arrivee = ?, " +
                    "distance_km = ?, duree_estimee = ?, tarif_base = ? " +
                    "WHERE id_trajet = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, t.getVilleDepart().getIdVille());
                pstmt.setInt(2, t.getVilleArrivee().getIdVille());

                if (t.getDistanceKm() != null) {
                    pstmt.setBigDecimal(3, t.getDistanceKm());
                } else {
                    pstmt.setNull(3, Types.NUMERIC);
                }

                pstmt.setString(4, t.getDureeEstimee());
                pstmt.setBigDecimal(5, t.getTarifBase());
                pstmt.setInt(6, t.getIdTrajet());

                pstmt.executeUpdate();
                success = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }
        return success;
    }

    public boolean desactiverTrajet(int id) {
        Database db = new Database();
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;

        try {
            conn = db.dbconnect();
            if (conn != null) {
                String sql = "UPDATE trajet SET actif = false WHERE id_trajet = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, id);
                pstmt.executeUpdate();
                success = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }
        return success;
    }

    public boolean supprimerTrajet(int id) {
        Database db = new Database();
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;

        try {
            conn = db.dbconnect();
            if (conn != null) {
                String sql = "DELETE FROM trajet WHERE id_trajet = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, id);
                pstmt.executeUpdate();
                success = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }
        return success;
    }

    // =========================================================
    //  Méthodes privées utilitaires
    // =========================================================
    private Trajet mapResultSetToTrajet(ResultSet rs) throws SQLException {
        Ville depart = new Ville();
        depart.setIdVille(rs.getInt("id_ville_depart"));
        depart.setNomVille(rs.getString("depart_nom"));

        Ville arrivee = new Ville();
        arrivee.setIdVille(rs.getInt("id_ville_arrivee"));
        arrivee.setNomVille(rs.getString("arrivee_nom"));

        Trajet t = new Trajet();
        t.setIdTrajet(rs.getInt("id_trajet"));
        t.setVilleDepart(depart);
        t.setVilleArrivee(arrivee);
        t.setDistanceKm(rs.getBigDecimal("distance_km"));
        t.setDureeEstimee(rs.getString("duree_estimee"));
        t.setTarifBase(rs.getBigDecimal("tarif_base"));
        t.setActif(rs.getBoolean("actif"));

        return t;
    }

    private void closeResources(Connection conn, PreparedStatement pstmt, ResultSet rs) {
        try { if (rs    != null) rs.close();    } catch (SQLException e) {}
        try { if (pstmt != null) pstmt.close(); } catch (SQLException e) {}
        try { if (conn  != null) conn.close();  } catch (SQLException e) {}
    }
}
