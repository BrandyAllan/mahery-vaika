package gestion;

import java.sql.*;
import java.util.List;
import java.util.Vector;
import tools.Database;
import gestion.Vehicule;
import gestion.Chauffeur;
import gestion.Trajet;

public class Depart {

    private int    id_depart;
    private int    id_trajet;
    private int    id_vehicule;
    private int    id_chauffeur;
    private Date   date_depart;
    private Time   heure_depart;
    private String statut;

    private String ville_depart;
    private String ville_arrivee;
    private String immatriculation;
    private String nom_chauffeur;
    private String prenom_chauffeur;
    private double tarif_base;
    private String duree_estimee;
    private double distance_km;
    private int    capacite_vehicule;
    private String statut_label;
    private int    nb_reservations;

    public Depart() {}
    public int getId_depart() { return id_depart; }
    public void setId_depart(int id_depart) { this.id_depart = id_depart; }

    public int getId_trajet() { return id_trajet; }
    public void setId_trajet(int id_trajet) { this.id_trajet = id_trajet; }

    public int getId_vehicule() { return id_vehicule; }
    public void setId_vehicule(int id_vehicule) { this.id_vehicule = id_vehicule; }

    public int getId_chauffeur() { return id_chauffeur; }
    public void setId_chauffeur(int id_chauffeur) { this.id_chauffeur = id_chauffeur; }

    public Date getDate_depart() { return date_depart; }
    public void setDate_depart(Date date_depart) { this.date_depart = date_depart; }

    public Time getHeure_depart() { return heure_depart; }
    public void setHeure_depart(Time heure_depart) { this.heure_depart = heure_depart; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    public String getVille_depart() { return ville_depart; }
    public void setVille_depart(String v) { this.ville_depart = v; }

    public String getVille_arrivee() { return ville_arrivee; }
    public void setVille_arrivee(String v) { this.ville_arrivee = v; }

    public String getImmatriculation() { return immatriculation; }
    public void setImmatriculation(String v) { this.immatriculation = v; }

    public String getNom_chauffeur() { return nom_chauffeur; }
    public void setNom_chauffeur(String v) { this.nom_chauffeur = v; }

    public String getPrenom_chauffeur() { return prenom_chauffeur; }
    public void setPrenom_chauffeur(String v) { this.prenom_chauffeur = v; }

    public double getTarif_base() { return tarif_base; }
    public void setTarif_base(double v) { this.tarif_base = v; }

    public String getDuree_estimee() { return duree_estimee; }
    public void setDuree_estimee(String v) { this.duree_estimee = v; }

    public double getDistance_km() { return distance_km; }
    public void setDistance_km(double v) { this.distance_km = v; }

    public int getCapacite_vehicule() { return capacite_vehicule; }
    public void setCapacite_vehicule(int v) { this.capacite_vehicule = v; }

    public String getStatut_label() { return statut_label; }
    public void setStatut_label(String v) { this.statut_label = v; }

    public int getNb_reservations() { return nb_reservations; }
    public void setNb_reservations(int v) { this.nb_reservations = v; }

    private static Depart fromResultSet(ResultSet rs) throws SQLException {
        Depart d = new Depart();
        d.setId_depart(rs.getInt("id_depart"));
        d.setId_trajet(rs.getInt("id_trajet"));
        d.setId_vehicule(rs.getInt("id_vehicule"));
        d.setId_chauffeur(rs.getInt("id_chauffeur"));
        d.setDate_depart(rs.getDate("date_depart"));
        d.setHeure_depart(rs.getTime("heure_depart"));
        d.setStatut(rs.getString("statut"));
        try { d.setVille_depart(rs.getString("ville_depart")); }    catch (SQLException e) {}
        try { d.setVille_arrivee(rs.getString("ville_arrivee")); }  catch (SQLException e) {}
        try { d.setImmatriculation(rs.getString("immatriculation")); } catch (SQLException e) {}
        try { d.setNom_chauffeur(rs.getString("nom_chauffeur")); }   catch (SQLException e) {}
        try { d.setPrenom_chauffeur(rs.getString("prenom_chauffeur")); } catch (SQLException e) {}
        try { d.setTarif_base(rs.getDouble("tarif_base")); }        catch (SQLException e) {}
        try { d.setDuree_estimee(rs.getString("duree_estimee")); }   catch (SQLException e) {}
        try { d.setDistance_km(rs.getDouble("distance_km")); }      catch (SQLException e) {}
        try { d.setCapacite_vehicule(rs.getInt("capacite")); }      catch (SQLException e) {}
        return d;
    }
  
// recherche filtre
    public static Vector<Depart> rechercher(
            int idTrajet, int idVehicule, int idChauffeur,
            Date d1, Date d2, String statut,
            String tri, int lim, int off) throws Exception {

        Vector<Depart> resultat = new Vector<>();
        Vector<Object> params   = new Vector<>();

        StringBuilder sql = new StringBuilder(
            "SELECT dp.*, " +
            "  vd.nom_ville AS ville_depart, " +
            "  va.nom_ville AS ville_arrivee, " +
            "  v.immatriculation, v.capacite, " +
            "  c.nom AS nom_chauffeur, c.prenom AS prenom_chauffeur, " +
            "  t.tarif_base, t.duree_estimee, t.distance_km " +
            "FROM depart dp " +
            "JOIN trajet t    ON dp.id_trajet    = t.id_trajet " +
            "JOIN ville vd    ON t.id_ville_depart  = vd.id_ville " +
            "JOIN ville va    ON t.id_ville_arrivee = va.id_ville " +
            "JOIN vehicule v  ON dp.id_vehicule   = v.id_vehicule " +
            "JOIN chauffeur c ON dp.id_chauffeur  = c.id_chauffeur " +
            "WHERE 1=1 "
        );

        if (idTrajet > 0)    { sql.append("AND dp.id_trajet = ? ");    params.add(idTrajet); }
        if (idVehicule > 0)  { sql.append("AND dp.id_vehicule = ? ");  params.add(idVehicule); }
        if (idChauffeur > 0) { sql.append("AND dp.id_chauffeur = ? "); params.add(idChauffeur); }
        if (statut != null && !statut.isEmpty()) {
            sql.append("AND dp.statut = ? ");
            params.add(statut);
        }
        if (d1 != null && d2 != null) {
            sql.append("AND dp.date_depart BETWEEN ? AND ? ");
            params.add(d1); params.add(d2);
        }

        sql.append("ORDER BY dp.date_depart ")
           .append("DESC".equalsIgnoreCase(tri) ? "DESC" : "ASC")
           .append(", dp.heure_depart ASC LIMIT ? OFFSET ?");
        params.add(lim); params.add(off);

        try (Connection c = new Database().dbconnect();
             PreparedStatement ps = c.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) resultat.add(fromResultSet(rs));
        }
        return resultat;
    }

    public static int count(
            int idTrajet, int idVehicule, int idChauffeur,
            Date d1, Date d2, String statut) throws Exception {

        Vector<Object> params = new Vector<>();
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM depart dp WHERE 1=1 "
        );

        if (idTrajet > 0)    { sql.append("AND dp.id_trajet = ? ");    params.add(idTrajet); }
        if (idVehicule > 0)  { sql.append("AND dp.id_vehicule = ? ");  params.add(idVehicule); }
        if (idChauffeur > 0) { sql.append("AND dp.id_chauffeur = ? "); params.add(idChauffeur); }
        if (statut != null && !statut.isEmpty()) {
            sql.append("AND dp.statut = ? "); params.add(statut);
        }
        if (d1 != null && d2 != null) {
            sql.append("AND dp.date_depart BETWEEN ? AND ? ");
            params.add(d1); params.add(d2);
        }

        try (Connection c = new Database().dbconnect();
             PreparedStatement ps = c.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    public static Depart getById(int id) throws Exception {
        String sql =
            "SELECT dp.*, " +
            "  vd.nom_ville AS ville_depart, " +
            "  va.nom_ville AS ville_arrivee, " +
            "  v.immatriculation, v.capacite, " +
            "  c.nom AS nom_chauffeur, c.prenom AS prenom_chauffeur, " +
            "  t.tarif_base, t.duree_estimee, t.distance_km " +
            "FROM depart dp " +
            "JOIN trajet t    ON dp.id_trajet    = t.id_trajet " +
            "JOIN ville vd    ON t.id_ville_depart  = vd.id_ville " +
            "JOIN ville va    ON t.id_ville_arrivee = va.id_ville " +
            "JOIN vehicule v  ON dp.id_vehicule   = v.id_vehicule " +
            "JOIN chauffeur c ON dp.id_chauffeur  = c.id_chauffeur " +
            "WHERE dp.id_depart = ?";

        try (Connection c = new Database().dbconnect();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return fromResultSet(rs);
        }
        return null;
    }

    public static List<Trajet> getTousLesTrajets() throws Exception {
        Trajet t = new Trajet();
        return t.rechercherTrajets(null, null, null, null);
    }

    public static Vector getTousLesVehicules() throws Exception {
        return Chauffeur.getVehiculesDispo();
    }

    public static Vector<Depart> getTousLesChauffeurs() throws Exception {
        Vector<Depart> liste = new Vector<>();
        String sql =
            "SELECT id_chauffeur, nom, prenom " +
            "FROM chauffeur WHERE actif = true " +
            "ORDER BY nom ASC";
        try (Connection c = new Database().dbconnect();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Depart d = new Depart();
                d.setId_chauffeur(rs.getInt("id_chauffeur"));
                d.setNom_chauffeur(rs.getString("nom"));
                d.setPrenom_chauffeur(rs.getString("prenom"));
                liste.add(d);
            }
        }
        return liste;
    }

  
    public static boolean vehiculeDejaOccupe(int idVehicule, Date date, Time heure, int excludeId) throws Exception {
        String sql =
            "SELECT COUNT(*) FROM depart " +
            "WHERE id_vehicule = ? AND date_depart = ? " +
            "AND heure_depart = ? AND id_depart != ?";
        try (Connection c = new Database().dbconnect();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idVehicule);
            ps.setDate(2, date);
            ps.setTime(3, heure);
            ps.setInt(4, excludeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        }
        return false;
    }

  
    public static boolean chauffeurDejaOccupe(int idChauffeur, Date date, Time heure, int excludeId) throws Exception {
        String sql =
            "SELECT COUNT(*) FROM depart " +
            "WHERE id_chauffeur = ? AND date_depart = ? " +
            "AND heure_depart = ? AND id_depart != ?";
        try (Connection c = new Database().dbconnect();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idChauffeur);
            ps.setDate(2, date);
            ps.setTime(3, heure);
            ps.setInt(4, excludeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        }
        return false;
    }


    public static void ajouter(Depart d) throws Exception {
        String sql =
            "INSERT INTO depart (id_trajet, id_vehicule, id_chauffeur, " +
            "date_depart, heure_depart, statut) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection c = new Database().dbconnect();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, d.getId_trajet());
            ps.setInt(2, d.getId_vehicule());
            ps.setInt(3, d.getId_chauffeur());
            ps.setDate(4, d.getDate_depart());
            ps.setTime(5, d.getHeure_depart());
            ps.setString(6, d.getStatut() != null ? d.getStatut() : "PLANIFIE");
            ps.executeUpdate();
        }
    }

  
    public static void mettreAjour(Depart d) throws Exception {
        String sql =
            "UPDATE depart SET id_trajet=?, id_vehicule=?, id_chauffeur=?, " +
            "date_depart=?, heure_depart=?, statut=? WHERE id_depart=?";
        try (Connection c = new Database().dbconnect();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, d.getId_trajet());
            ps.setInt(2, d.getId_vehicule());
            ps.setInt(3, d.getId_chauffeur());
            ps.setDate(4, d.getDate_depart());
            ps.setTime(5, d.getHeure_depart());
            ps.setString(6, d.getStatut());
            ps.setInt(7, d.getId_depart());
            ps.executeUpdate();
        }
    }


    public static void supprimer(int id) throws Exception {
        String sql = "DELETE FROM depart WHERE id_depart = ?";
        try (Connection c = new Database().dbconnect();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
}