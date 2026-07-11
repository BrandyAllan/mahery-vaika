package backoffice;

import java.sql.*;
import java.util.Vector;
import tools.Database;

public class Reservation {
    private int id_reservation;
    private String numero_reservation;
    private int id_depart;
    private int id_trajet;
    private String nom_passager;
    private String prenom_passager;
    private String telephone_passager;
    private int numero_siege;
    private String statut;
    private String motif_annulation;
    private Timestamp date_reservation;
    private int id_caissier;
    private String nom_caissier;

    private String ville_depart;
    private String ville_arrivee;
    private Date date_depart;
    private Time heure_depart;
    private String duree_estimee;
    private double tarif_base;

    public Reservation() {
    }

    public int getId_reservation() {
        return id_reservation;
    }

    public String getNumero_reservation() {
        return numero_reservation;
    }

    public int getId_depart() {
        return id_depart;
    }

    public int getId_trajet() {
        return id_trajet;
    }

    public String getNom_passager() {
        return nom_passager;
    }

    public String getPrenom_passager() {
        return prenom_passager;
    }

    public String getTelephone_passager() {
        return telephone_passager;
    }

    public int getNumero_siege() {
        return numero_siege;
    }

    public String getStatut() {
        return statut;
    }

    public String getMotif_annulation() {
        return motif_annulation;
    }

    public Timestamp getDate_reservation() {
        return date_reservation;
    }

    public int getId_caissier() {
        return id_caissier;
    }

    public String getNom_caissier() {
        return nom_caissier;
    }

    public String getVille_depart() {
        return ville_depart;
    }

    public String getVille_arrivee() {
        return ville_arrivee;
    }

    public Date getDate_depart() {
        return date_depart;
    }

    public Time getHeure_depart() {
        return heure_depart;
    }

    public String getDuree_estimee() {
        return duree_estimee;
    }

    public double getTarif_base() {
        return tarif_base;
    }

    public void setId_reservation(int id_reservation) {
        this.id_reservation = id_reservation;
    }

    public void setNumero_reservation(String numero_reservation) {
        this.numero_reservation = numero_reservation;
    }

    public void setId_depart(int id_depart) {
        this.id_depart = id_depart;
    }

    public void setId_trajet(int id_trajet) {
        this.id_trajet = id_trajet;
    }

    public void setNom_passager(String nom_passager) {
        this.nom_passager = nom_passager;
    }

    public void setPrenom_passager(String prenom_passager) {
        this.prenom_passager = prenom_passager;
    }

    public void setTelephone_passager(String telephone_passager) {
        this.telephone_passager = telephone_passager;
    }

    public void setNumero_siege(int numero_siege) {
        this.numero_siege = numero_siege;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public void setMotif_annulation(String motif_annulation) {
        this.motif_annulation = motif_annulation;
    }

    public void setDate_reservation(Timestamp date_reservation) {
        this.date_reservation = date_reservation;
    }

    public void setId_caissier(int id_caissier) {
        this.id_caissier = id_caissier;
    }

    public void setNom_caissier(String nom_caissier) {
        this.nom_caissier = nom_caissier;
    }

    public void setVille_depart(String ville_depart) {
        this.ville_depart = ville_depart;
    }

    public void setVille_arrivee(String ville_arrivee) {
        this.ville_arrivee = ville_arrivee;
    }

    public void setDate_depart(Date date_depart) {
        this.date_depart = date_depart;
    }

    public void setHeure_depart(Time heure_depart) {
        this.heure_depart = heure_depart;
    }

    public void setDuree_estimee(String duree_estimee) {
        this.duree_estimee = duree_estimee;
    }

    public void setTarif_base(double tarif_base) {
        this.tarif_base = tarif_base;
    }

    public static Vector<Reservation> rechercher(String numero, String nomPassager, int idTrajet,
            String statut, Date dateDebut, Date dateFin,
            int idCaissier, boolean isAdmin,
            String tri, int limit, int offset) throws Exception {
        Vector<Reservation> resultat = new Vector<>();
        Vector<Object> parametres = new Vector<>();
        StringBuilder sql = new StringBuilder(
                "SELECT r.*, d.id_trajet, d.date_depart, d.heure_depart, " +
                        "vd.nom_ville as ville_depart, va.nom_ville as ville_arrivee, " +
                        "t.duree_estimee, t.tarif_base, " +
                        "u.nom as nom_caissier " +
                        "FROM reservation r " +
                        "JOIN depart d ON r.id_depart = d.id_depart " +
                        "JOIN trajet t ON d.id_trajet = t.id_trajet " +
                        "JOIN ville vd ON t.id_ville_depart = vd.id_ville " +
                        "JOIN ville va ON t.id_ville_arrivee = va.id_ville " +
                        "JOIN utilisateur u ON r.id_caissier = u.id_utilisateur " +
                        "WHERE 1=1 ");

        if (!isAdmin) {
            sql.append(" AND r.id_caissier = ? ");
            parametres.add(idCaissier);
        }
        if (numero != null && !numero.isEmpty()) {
            sql.append(" AND r.numero_reservation ILIKE ? ");
            parametres.add("%" + numero + "%");
        }
        if (nomPassager != null && !nomPassager.isEmpty()) {
            sql.append(" AND (r.nom_passager ILIKE ? OR r.prenom_passager ILIKE ?) ");
            parametres.add("%" + nomPassager + "%");
            parametres.add("%" + nomPassager + "%");
        }
        if (idTrajet > 0) {
            sql.append(" AND d.id_trajet = ? ");
            parametres.add(idTrajet);
        }
        if (statut != null && !statut.isEmpty()) {
            sql.append(" AND r.statut = ? ");
            parametres.add(statut);
        }
        if (dateDebut != null && dateFin != null) {
            sql.append(" AND r.date_reservation BETWEEN ? AND ? ");
            parametres.add(new Timestamp(dateDebut.getTime()));
            parametres.add(new Timestamp(dateFin.getTime() + 86400000));
        }

        sql.append(" ORDER BY r.date_reservation ").append(tri.equalsIgnoreCase("DESC") ? "DESC" : "ASC");
        sql.append(" LIMIT ? OFFSET ? ");
        parametres.add(limit);
        parametres.add(offset);

        try (Connection c = new Database().dbconnect();
                PreparedStatement ps = c.prepareStatement(sql.toString())) {
            for (int i = 0; i < parametres.size(); i++)
                ps.setObject(i + 1, parametres.get(i));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Reservation r = new Reservation();
                r.setId_reservation(rs.getInt("id_reservation"));
                r.setNumero_reservation(rs.getString("numero_reservation"));
                r.setId_depart(rs.getInt("id_depart"));
                r.setId_trajet(rs.getInt("id_trajet"));
                r.setNom_passager(rs.getString("nom_passager"));
                r.setPrenom_passager(rs.getString("prenom_passager"));
                r.setTelephone_passager(rs.getString("telephone_passager"));
                r.setNumero_siege(rs.getInt("numero_siege"));
                r.setStatut(rs.getString("statut"));
                r.setMotif_annulation(rs.getString("motif_annulation"));
                r.setDate_reservation(rs.getTimestamp("date_reservation"));
                r.setId_caissier(rs.getInt("id_caissier"));
                r.setNom_caissier(rs.getString("nom_caissier"));
                r.setVille_depart(rs.getString("ville_depart"));
                r.setVille_arrivee(rs.getString("ville_arrivee"));
                r.setDate_depart(rs.getDate("date_depart"));
                r.setHeure_depart(rs.getTime("heure_depart"));
                r.setDuree_estimee(rs.getString("duree_estimee"));
                r.setTarif_base(rs.getDouble("tarif_base"));
                resultat.add(r);
            }
        }
        return resultat;
    }

    public static int count(String numero, String nomPassager, int idTrajet,
            String statut, Date dateDebut, Date dateFin,
            int idCaissier, boolean isAdmin) throws Exception {
        Vector<Object> parametres = new Vector<>();
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM reservation r " +
                        "JOIN depart d ON r.id_depart = d.id_depart " +
                        "JOIN trajet t ON d.id_trajet = t.id_trajet " +
                        "WHERE 1=1 ");

        if (!isAdmin) {
            sql.append(" AND r.id_caissier = ? ");
            parametres.add(idCaissier);
        }
        if (numero != null && !numero.isEmpty()) {
            sql.append(" AND r.numero_reservation ILIKE ? ");
            parametres.add("%" + numero + "%");
        }
        if (nomPassager != null && !nomPassager.isEmpty()) {
            sql.append(" AND (r.nom_passager ILIKE ? OR r.prenom_passager ILIKE ?) ");
            parametres.add("%" + nomPassager + "%");
            parametres.add("%" + nomPassager + "%");
        }
        if (idTrajet > 0) {
            sql.append(" AND d.id_trajet = ? ");
            parametres.add(idTrajet);
        }
        if (statut != null && !statut.isEmpty()) {
            sql.append(" AND r.statut = ? ");
            parametres.add(statut);
        }
        if (dateDebut != null && dateFin != null) {
            sql.append(" AND r.date_reservation BETWEEN ? AND ? ");
            parametres.add(new Timestamp(dateDebut.getTime()));
            parametres.add(new Timestamp(dateFin.getTime() + 86400000));
        }

        try (Connection c = new Database().dbconnect();
                PreparedStatement ps = c.prepareStatement(sql.toString())) {
            for (int i = 0; i < parametres.size(); i++)
                ps.setObject(i + 1, parametres.get(i));
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getInt(1);
        }
        return 0;
    }

    public static Reservation getById(int id) throws Exception {
        String sql = "SELECT r.*, d.id_trajet, d.date_depart, d.heure_depart, " +
                "vd.nom_ville as ville_depart, va.nom_ville as ville_arrivee, " +
                "t.duree_estimee, t.tarif_base, " +
                "u.nom as nom_caissier " +
                "FROM reservation r " +
                "JOIN depart d ON r.id_depart = d.id_depart " +
                "JOIN trajet t ON d.id_trajet = t.id_trajet " +
                "JOIN ville vd ON t.id_ville_depart = vd.id_ville " +
                "JOIN ville va ON t.id_ville_arrivee = va.id_ville " +
                "JOIN utilisateur u ON r.id_caissier = u.id_utilisateur " +
                "WHERE r.id_reservation = ?";

        try (Connection c = new Database().dbconnect();
                PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Reservation r = new Reservation();
                r.setId_reservation(rs.getInt("id_reservation"));
                r.setNumero_reservation(rs.getString("numero_reservation"));
                r.setId_depart(rs.getInt("id_depart"));
                r.setId_trajet(rs.getInt("id_trajet"));
                r.setNom_passager(rs.getString("nom_passager"));
                r.setPrenom_passager(rs.getString("prenom_passager"));
                r.setTelephone_passager(rs.getString("telephone_passager"));
                r.setNumero_siege(rs.getInt("numero_siege"));
                r.setStatut(rs.getString("statut"));
                r.setMotif_annulation(rs.getString("motif_annulation"));
                r.setDate_reservation(rs.getTimestamp("date_reservation"));
                r.setId_caissier(rs.getInt("id_caissier"));
                r.setNom_caissier(rs.getString("nom_caissier"));
                r.setVille_depart(rs.getString("ville_depart"));
                r.setVille_arrivee(rs.getString("ville_arrivee"));
                r.setDate_depart(rs.getDate("date_depart"));
                r.setHeure_depart(rs.getTime("heure_depart"));
                r.setDuree_estimee(rs.getString("duree_estimee"));
                r.setTarif_base(rs.getDouble("tarif_base"));
                return r;
            }
        }
        return null;
    }

    public static Vector<Reservation> getAllTrajets() throws Exception {
        Vector<Reservation> trajets = new Vector<>();
        String sql = "SELECT t.id_trajet, vd.nom_ville as ville_depart, va.nom_ville as ville_arrivee, " +
                "t.duree_estimee, t.tarif_base, t.distance_km " +
                "FROM trajet t " +
                "JOIN ville vd ON t.id_ville_depart = vd.id_ville " +
                "JOIN ville va ON t.id_ville_arrivee = va.id_ville " +
                "WHERE t.actif = true " +
                "ORDER BY vd.nom_ville, va.nom_ville";

        try (Connection c = new Database().dbconnect();
                PreparedStatement ps = c.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Reservation t = new Reservation();
                t.setId_trajet(rs.getInt("id_trajet"));
                t.setVille_depart(rs.getString("ville_depart"));
                t.setVille_arrivee(rs.getString("ville_arrivee"));
                t.setDuree_estimee(rs.getString("duree_estimee"));
                t.setTarif_base(rs.getDouble("tarif_base"));
                trajets.add(t);
            }
        }
        return trajets;
    }

    public static Vector<Integer> getSiegesReserves(int idDepart) throws Exception {
        Vector<Integer> sieges = new Vector<>();
        String sql = "SELECT numero_siege FROM reservation WHERE id_depart = ? AND statut != 'ANNULEE'";
        try (Connection c = new Database().dbconnect();
                PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idDepart);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                sieges.add(rs.getInt("numero_siege"));
            }
        }
        return sieges;
    }

    public static int getCapaciteVehicule(int idDepart) throws Exception {
        String sql = "SELECT v.capacite FROM depart d " +
                "JOIN vehicule v ON d.id_vehicule = v.id_vehicule " +
                "WHERE d.id_depart = ?";
        try (Connection c = new Database().dbconnect();
                PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idDepart);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getInt("capacite");
        }
        return 0;
    }

    public static String genererNumeroReservation() throws Exception {
        String prefix = "RES";
        String datePart = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
        String sql = "SELECT COUNT(*) FROM reservation WHERE DATE(date_reservation) = CURRENT_DATE";
        int countToday = 0;
        try (Connection c = new Database().dbconnect();
                PreparedStatement ps = c.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                countToday = rs.getInt(1);
        }
        return prefix + datePart + String.format("%04d", countToday + 1);
    }

    public static int ajouter(Reservation r) throws Exception {
        String sql = "INSERT INTO reservation (numero_reservation, id_depart, nom_passager, prenom_passager, " +
                "telephone_passager, numero_siege, statut, id_caissier) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection c = new Database().dbconnect();
                PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, r.getNumero_reservation());
            ps.setInt(2, r.getId_depart());
            ps.setString(3, r.getNom_passager());
            ps.setString(4, r.getPrenom_passager());
            ps.setString(5, r.getTelephone_passager());
            ps.setInt(6, r.getNumero_siege());
            ps.setString(7, r.getStatut());
            ps.setInt(8, r.getId_caissier());
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    int idGenere = keys.getInt(1);
                    r.setId_reservation(idGenere);
                    return idGenere;
                }
            }
        }
        return 0;
    }

    public static void annuler(int idReservation, String motif) throws Exception {
        String sql = "UPDATE reservation SET statut = 'ANNULEE', motif_annulation = ? WHERE id_reservation = ?";
        try (Connection c = new Database().dbconnect();
                PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, motif);
            ps.setInt(2, idReservation);
            ps.executeUpdate();
        }
    }

    public static void mettreAjour(Reservation r) throws Exception {
        String sql = "UPDATE reservation SET nom_passager = ?, prenom_passager = ?, telephone_passager = ?, " +
                "numero_siege = ?, id_depart = ? WHERE id_reservation = ?";
        try (Connection c = new Database().dbconnect();
                PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, r.getNom_passager());
            ps.setString(2, r.getPrenom_passager());
            ps.setString(3, r.getTelephone_passager());
            ps.setInt(4, r.getNumero_siege());
            ps.setInt(5, r.getId_depart());
            ps.setInt(6, r.getId_reservation());
            ps.executeUpdate();
        }
    }

    public static Vector<Reservation> getAllDeparts() throws Exception {
        Vector<Reservation> departs = new Vector<>();
        String sql = "SELECT d.id_depart, d.date_depart, d.heure_depart, d.statut as statut_depart, " +
                "vd.nom_ville as ville_depart, va.nom_ville as ville_arrivee, " +
                "t.id_trajet, t.tarif_base, v.capacite, v.immatriculation " +
                "FROM depart d " +
                "JOIN trajet t ON d.id_trajet = t.id_trajet " +
                "JOIN vehicule v ON d.id_vehicule = v.id_vehicule " +
                "JOIN ville vd ON t.id_ville_depart = vd.id_ville " +
                "JOIN ville va ON t.id_ville_arrivee = va.id_ville " +
                "WHERE d.statut = 'PLANIFIE' " +
                "ORDER BY d.date_depart, d.heure_depart";

        try (Connection c = new Database().dbconnect();
                PreparedStatement ps = c.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Reservation d = new Reservation();
                d.setId_depart(rs.getInt("id_depart"));
                d.setId_trajet(rs.getInt("id_trajet"));
                d.setDate_depart(rs.getDate("date_depart"));
                d.setHeure_depart(rs.getTime("heure_depart"));
                d.setVille_depart(rs.getString("ville_depart"));
                d.setVille_arrivee(rs.getString("ville_arrivee"));
                d.setTarif_base(rs.getDouble("tarif_base"));
                d.setDuree_estimee("");
                departs.add(d);
            }
        }
        return departs;
    }
}