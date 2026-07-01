package gestion;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.Vector;
import tools.Database;

public class Chauffeur {

    private int idChauffeur;
    private String nom;
    private String prenom;
    private String telephone;
    private String numeroPermis;
    private Date dateExpirationPermis;
    private int idVehiculeHabituel;
    private boolean actif;

    private String immatriculationVehicule;
    private String marqueModeleVehicule;
    private String statutPermis;
    private int nbTrajets;

    public Chauffeur() {
    }

    public Chauffeur(int idChauffeur, String nom, String prenom, String telephone,
            String numeroPermis, Date dateExpirationPermis, int idVehiculeHabituel,
            boolean actif, String immatriculationVehicule, String marqueModeleVehicule,
            String statutPermis, int nbTrajets) {
        this.idChauffeur = idChauffeur;
        this.nom = nom;
        this.prenom = prenom;
        this.telephone = telephone;
        this.numeroPermis = numeroPermis;
        this.dateExpirationPermis = dateExpirationPermis;
        this.idVehiculeHabituel = idVehiculeHabituel;
        this.actif = actif;
        this.immatriculationVehicule = immatriculationVehicule;
        this.marqueModeleVehicule = marqueModeleVehicule;
        this.statutPermis = statutPermis;
        this.nbTrajets = nbTrajets;
    }

    public int getIdChauffeur() {
        return idChauffeur;
    }

    public void setIdChauffeur(int idChauffeur) {
        this.idChauffeur = idChauffeur;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getNumeroPermis() {
        return numeroPermis;
    }

    public void setNumeroPermis(String numeroPermis) {
        this.numeroPermis = numeroPermis;
    }

    public Date getDateExpirationPermis() {
        return dateExpirationPermis;
    }

    public void setDateExpirationPermis(Date dateExpirationPermis) {
        this.dateExpirationPermis = dateExpirationPermis;
    }

    public int getIdVehiculeHabituel() {
        return idVehiculeHabituel;
    }

    public void setIdVehiculeHabituel(int idVehiculeHabituel) {
        this.idVehiculeHabituel = idVehiculeHabituel;
    }

    public boolean isActif() {
        return actif;
    }

    public void setActif(boolean actif) {
        this.actif = actif;
    }

    public String getImmatriculationVehicule() {
        return immatriculationVehicule;
    }

    public void setImmatriculationVehicule(String immatriculationVehicule) {
        this.immatriculationVehicule = immatriculationVehicule;
    }

    public String getMarqueModeleVehicule() {
        return marqueModeleVehicule;
    }

    public void setMarqueModeleVehicule(String marqueModeleVehicule) {
        this.marqueModeleVehicule = marqueModeleVehicule;
    }

    public String getStatutPermis() {
        return statutPermis;
    }

    public void setStatutPermis(String statutPermis) {
        this.statutPermis = statutPermis;
    }

    public int getNbTrajets() {
        return nbTrajets;
    }

    public void setNbTrajets(int nbTrajets) {
        this.nbTrajets = nbTrajets;
    }

    public String getNomComplet() {
        return (prenom != null && !prenom.isEmpty()) ? prenom + " " + nom : nom;
    }

    public static Vector getTousActifs() throws Exception {
        Vector liste = new Vector();
        String sql = SELECT_BASE + "WHERE c.actif = true ORDER BY c.nom ASC";
        try (Connection conn = new Database().dbconnect();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next())
                liste.add(fromResultSet(rs));
        }
        return liste;
    }

    private static final String SELECT_BASE = "SELECT c.id_chauffeur, c.nom, c.prenom, c.telephone, c.numero_permis, " +
            "       c.date_expiration_permis, c.id_vehicule_habituel, c.actif, " +
            "       v.immatriculation, " +
            "       COALESCE(v.marque || ' ' || v.modele, '-') AS marque_modele, " +
            "       CASE " +
            "           WHEN c.date_expiration_permis IS NULL THEN 'INCONNU' " +
            "           WHEN c.date_expiration_permis < CURRENT_DATE THEN 'EXPIRE' " +
            "           WHEN c.date_expiration_permis <= CURRENT_DATE + INTERVAL '30 days' THEN 'BIENTOT_EXPIRE' " +
            "           ELSE 'VALIDE' " +
            "       END AS statut_permis " +
            "FROM chauffeur c " +
            "LEFT JOIN vehicule v ON c.id_vehicule_habituel = v.id_vehicule ";

    private static Chauffeur fromResultSet(ResultSet rs) throws Exception {
        Chauffeur c = new Chauffeur();
        c.setIdChauffeur(rs.getInt("id_chauffeur"));
        c.setNom(rs.getString("nom"));
        c.setPrenom(rs.getString("prenom"));
        c.setTelephone(rs.getString("telephone"));
        c.setNumeroPermis(rs.getString("numero_permis"));
        c.setDateExpirationPermis(rs.getDate("date_expiration_permis"));
        c.setIdVehiculeHabituel(rs.getInt("id_vehicule_habituel"));
        c.setActif(rs.getBoolean("actif"));
        c.setImmatriculationVehicule(rs.getString("immatriculation"));
        c.setMarqueModeleVehicule(rs.getString("marque_modele"));
        c.setStatutPermis(rs.getString("statut_permis"));
        return c;
    }

    public static Chauffeur getById(int id) throws Exception {
        String sql = SELECT_BASE + "WHERE c.id_chauffeur = ?";
        try (Connection conn = new Database().dbconnect();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return fromResultSet(rs);
        }
        return null;
    }

    public static Vector rechercher(String nom, String vehicule, Boolean statut,
            String statutPermis, Date datePermisDebut, Date datePermisFin,
            int limit, int offset) throws Exception {
        Vector resultat = new Vector();
        Vector parametres = new Vector();

        StringBuilder sql = new StringBuilder(SELECT_BASE + "WHERE 1=1 ");

        if (nom != null && !nom.trim().isEmpty()) {
            sql.append("AND (c.nom ILIKE ? OR c.prenom ILIKE ?) ");
            parametres.add("%" + nom.trim() + "%");
            parametres.add("%" + nom.trim() + "%");
        }
        if (vehicule != null && !vehicule.trim().isEmpty()) {
            sql.append("AND (v.immatriculation ILIKE ? OR v.marque ILIKE ? OR v.modele ILIKE ?) ");
            parametres.add("%" + vehicule.trim() + "%");
            parametres.add("%" + vehicule.trim() + "%");
            parametres.add("%" + vehicule.trim() + "%");
        }
        if (statut != null) {
            sql.append("AND c.actif = ? ");
            parametres.add(statut);
        }
        if (statutPermis != null && !statutPermis.isEmpty()) {
            switch (statutPermis) {
                case "EXPIRE":
                    sql.append("AND c.date_expiration_permis < CURRENT_DATE ");
                    break;
                case "BIENTOT_EXPIRE":
                    sql.append(
                            "AND c.date_expiration_permis >= CURRENT_DATE AND c.date_expiration_permis <= CURRENT_DATE + INTERVAL '30 days' ");
                    break;
                case "VALIDE":
                    sql.append("AND c.date_expiration_permis > CURRENT_DATE + INTERVAL '30 days' ");
                    break;
            }
        }
        if (datePermisDebut != null) {
            sql.append("AND c.date_expiration_permis >= ? ");
            parametres.add(datePermisDebut);
        }
        if (datePermisFin != null) {
            sql.append("AND c.date_expiration_permis <= ? ");
            parametres.add(datePermisFin);
        }

        sql.append("ORDER BY c.nom ASC LIMIT ? OFFSET ?");
        parametres.add(limit);
        parametres.add(offset);

        try (Connection conn = new Database().dbconnect();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < parametres.size(); i++)
                ps.setObject(i + 1, parametres.get(i));
            ResultSet rs = ps.executeQuery();
            while (rs.next())
                resultat.add(fromResultSet(rs));
        }
        return resultat;
    }

    public static int count(String nom, String vehicule, Boolean statut,
            String statutPermis, Date datePermisDebut, Date datePermisFin) throws Exception {
        Vector parametres = new Vector();
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM chauffeur c LEFT JOIN vehicule v ON c.id_vehicule_habituel = v.id_vehicule WHERE 1=1 ");

        if (nom != null && !nom.trim().isEmpty()) {
            sql.append("AND (c.nom ILIKE ? OR c.prenom ILIKE ?) ");
            parametres.add("%" + nom.trim() + "%");
            parametres.add("%" + nom.trim() + "%");
        }
        if (vehicule != null && !vehicule.trim().isEmpty()) {
            sql.append("AND (v.immatriculation ILIKE ? OR v.marque ILIKE ? OR v.modele ILIKE ?) ");
            parametres.add("%" + vehicule.trim() + "%");
            parametres.add("%" + vehicule.trim() + "%");
            parametres.add("%" + vehicule.trim() + "%");
        }
        if (statut != null) {
            sql.append("AND c.actif = ? ");
            parametres.add(statut);
        }
        if (statutPermis != null && !statutPermis.isEmpty()) {
            switch (statutPermis) {
                case "EXPIRE":
                    sql.append("AND c.date_expiration_permis < CURRENT_DATE ");
                    break;
                case "BIENTOT_EXPIRE":
                    sql.append(
                            "AND c.date_expiration_permis >= CURRENT_DATE AND c.date_expiration_permis <= CURRENT_DATE + INTERVAL '30 days' ");
                    break;
                case "VALIDE":
                    sql.append("AND c.date_expiration_permis > CURRENT_DATE + INTERVAL '30 days' ");
                    break;
            }
        }
        if (datePermisDebut != null) {
            sql.append("AND c.date_expiration_permis >= ? ");
            parametres.add(datePermisDebut);
        }
        if (datePermisFin != null) {
            sql.append("AND c.date_expiration_permis <= ? ");
            parametres.add(datePermisFin);
        }

        try (Connection conn = new Database().dbconnect();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < parametres.size(); i++)
                ps.setObject(i + 1, parametres.get(i));
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getInt(1);
        }
        return 0;
    }

    public static void ajouter(Chauffeur c) throws Exception {
        String sql = "INSERT INTO chauffeur (nom, prenom, telephone, numero_permis, date_expiration_permis, id_vehicule_habituel, actif) "
                +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = new Database().dbconnect();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getNom());
            ps.setString(2, c.getPrenom());
            ps.setString(3, c.getTelephone());
            ps.setString(4, c.getNumeroPermis());
            ps.setDate(5, c.getDateExpirationPermis());
            if (c.getIdVehiculeHabituel() > 0)
                ps.setInt(6, c.getIdVehiculeHabituel());
            else
                ps.setNull(6, java.sql.Types.INTEGER);
            ps.setBoolean(7, c.isActif());
            ps.executeUpdate();
        }
    }

    public static void modifier(Chauffeur c) throws Exception {
        String sql = "UPDATE chauffeur SET nom=?, prenom=?, telephone=?, numero_permis=?, " +
                "date_expiration_permis=?, id_vehicule_habituel=? WHERE id_chauffeur=?";
        try (Connection conn = new Database().dbconnect();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getNom());
            ps.setString(2, c.getPrenom());
            ps.setString(3, c.getTelephone());
            ps.setString(4, c.getNumeroPermis());
            ps.setDate(5, c.getDateExpirationPermis());
            if (c.getIdVehiculeHabituel() > 0)
                ps.setInt(6, c.getIdVehiculeHabituel());
            else
                ps.setNull(6, java.sql.Types.INTEGER);
            ps.setInt(7, c.getIdChauffeur());
            ps.executeUpdate();
        }
    }

    public static void basculerActif(int id, boolean actif) throws Exception {
        String sql = "UPDATE chauffeur SET actif = ? WHERE id_chauffeur = ?";
        try (Connection conn = new Database().dbconnect();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, actif);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }

    public static Vector getHistorique(int idChauffeur, int limit, int offset) throws Exception {
        Vector liste = new Vector();
        String sql = "SELECT d.id_depart, d.date_depart, d.heure_depart, d.statut, " +
                "       vd.nom_ville AS ville_depart, va.nom_ville AS ville_arrivee, " +
                "       v.immatriculation, " +
                "       CASE d.statut " +
                "           WHEN 'PLANIFIE'  THEN 'Planifie' " +
                "           WHEN 'EN_COURS'  THEN 'En cours' " +
                "           WHEN 'TERMINE'   THEN 'Termine' " +
                "           WHEN 'ANNULE'    THEN 'Annule' " +
                "           ELSE d.statut " +
                "       END AS statut_label, " +
                "       COUNT(r.id_reservation) AS nb_reservations " +
                "FROM depart d " +
                "JOIN trajet t  ON d.id_trajet   = t.id_trajet " +
                "JOIN ville  vd ON t.id_ville_depart  = vd.id_ville " +
                "JOIN ville  va ON t.id_ville_arrivee = va.id_ville " +
                "JOIN vehicule v ON d.id_vehicule = v.id_vehicule " +
                "LEFT JOIN reservation r ON r.id_depart = d.id_depart " +
                "WHERE d.id_chauffeur = ? " +
                "GROUP BY d.id_depart, d.date_depart, d.heure_depart, d.statut, " +
                "         vd.nom_ville, va.nom_ville, v.immatriculation " +
                "ORDER BY d.date_depart DESC, d.heure_depart DESC " +
                "LIMIT ? OFFSET ?";

        try (Connection conn = new Database().dbconnect();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idChauffeur);
            ps.setInt(2, limit);
            ps.setInt(3, offset);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Depart d = new Depart();
                d.setId_depart(rs.getInt("id_depart"));
                d.setDate_depart(rs.getDate("date_depart"));
                d.setHeure_depart(rs.getTime("heure_depart"));
                d.setStatut(rs.getString("statut"));
                d.setStatut_label(rs.getString("statut_label"));
                d.setVille_depart(rs.getString("ville_depart"));
                d.setVille_arrivee(rs.getString("ville_arrivee"));
                d.setImmatriculation(rs.getString("immatriculation"));
                d.setNb_reservations(rs.getInt("nb_reservations"));
                liste.add(d);
            }
        }
        return liste;
    }

    public static int countHistorique(int idChauffeur) throws Exception {
        String sql = "SELECT COUNT(*) FROM depart WHERE id_chauffeur = ?";
        try (Connection conn = new Database().dbconnect();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idChauffeur);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getInt(1);
        }
        return 0;
    }

    public static Vector getVehiculesDispo() throws Exception {
        Vector liste = new Vector();
        String sql = "SELECT id_vehicule, immatriculation, marque, modele FROM vehicule WHERE etat = 'ACTIF' ORDER BY immatriculation";
        try (Connection conn = new Database().dbconnect();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Vehicule v = new Vehicule();
                v.setIdVehicule(rs.getInt("id_vehicule"));
                v.setImmatriculation(rs.getString("immatriculation"));
                v.setMarque(rs.getString("marque"));
                v.setModele(rs.getString("modele"));
                liste.add(v);
            }
        }
        return liste;
    }
}