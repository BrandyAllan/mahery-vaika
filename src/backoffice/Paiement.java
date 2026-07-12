package backoffice;

import java.sql.*;
import java.util.Vector;
import tools.Database;

public class Paiement {
    private int id_paiement;
    private int id_reservation;
    private double montant;
    private String mode_paiement;
    private String statut;
    private Timestamp date_paiement;

    private String numero_reservation;
    private String nom_passager;
    private String prenom_passager;
    private int numero_siege;

    public Paiement() {
    }

    public int getId_paiement() {
        return id_paiement;
    }

    public int getId_reservation() {
        return id_reservation;
    }

    public double getMontant() {
        return montant;
    }

    public String getMode_paiement() {
        return mode_paiement;
    }

    public String getStatut() {
        return statut;
    }

    public Timestamp getDate_paiement() {
        return date_paiement;
    }

    public String getNumero_reservation() {
        return numero_reservation;
    }

    public String getNom_passager() {
        return nom_passager;
    }

    public String getPrenom_passager() {
        return prenom_passager;
    }

    public int getNumero_siege() {
        return numero_siege;
    }

    public void setId_paiement(int id_paiement) {
        this.id_paiement = id_paiement;
    }

    public void setId_reservation(int id_reservation) {
        this.id_reservation = id_reservation;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public void setMode_paiement(String mode_paiement) {
        this.mode_paiement = mode_paiement;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public void setDate_paiement(Timestamp date_paiement) {
        this.date_paiement = date_paiement;
    }

    public void setNumero_reservation(String numero_reservation) {
        this.numero_reservation = numero_reservation;
    }

    public void setNom_passager(String nom_passager) {
        this.nom_passager = nom_passager;
    }

    public void setPrenom_passager(String prenom_passager) {
        this.prenom_passager = prenom_passager;
    }

    public void setNumero_siege(int numero_siege) {
        this.numero_siege = numero_siege;
    }

    public static int ajouter(Paiement p) throws Exception {
        String sql = "INSERT INTO paiement (id_reservation, montant, mode_paiement, statut) " +
                "VALUES (?, ?, ?, ?)";
        try (Connection c = new Database().dbconnect();
                PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, p.getId_reservation());
            ps.setDouble(2, p.getMontant());
            ps.setString(3, p.getMode_paiement());
            ps.setString(4, p.getStatut());
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    int idGenere = keys.getInt(1);
                    p.setId_paiement(idGenere);
                    return idGenere;
                }
            }
        }
        return 0;
    }

    public static Vector<Paiement> getByReservationIds(Vector<Integer> idsReservation) throws Exception {
        Vector<Paiement> paiements = new Vector<>();
        if (idsReservation == null || idsReservation.isEmpty())
            return paiements;

        StringBuilder placeholders = new StringBuilder();
        for (int i = 0; i < idsReservation.size(); i++) {
            if (i > 0)
                placeholders.append(",");
            placeholders.append("?");
        }

        String sql = "SELECT p.*, r.numero_reservation, r.nom_passager, r.prenom_passager, r.numero_siege " +
                "FROM paiement p " +
                "JOIN reservation r ON p.id_reservation = r.id_reservation " +
                "WHERE p.id_reservation IN (" + placeholders + ") " +
                "ORDER BY r.numero_siege";

        try (Connection c = new Database().dbconnect();
                PreparedStatement ps = c.prepareStatement(sql)) {
            for (int i = 0; i < idsReservation.size(); i++) {
                ps.setInt(i + 1, idsReservation.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Paiement p = new Paiement();
                p.setId_paiement(rs.getInt("id_paiement"));
                p.setId_reservation(rs.getInt("id_reservation"));
                p.setMontant(rs.getDouble("montant"));
                p.setMode_paiement(rs.getString("mode_paiement"));
                p.setStatut(rs.getString("statut"));
                p.setDate_paiement(rs.getTimestamp("date_paiement"));
                p.setNumero_reservation(rs.getString("numero_reservation"));
                p.setNom_passager(rs.getString("nom_passager"));
                p.setPrenom_passager(rs.getString("prenom_passager"));
                p.setNumero_siege(rs.getInt("numero_siege"));
                paiements.add(p);
            }
        }
        return paiements;
    }
}
