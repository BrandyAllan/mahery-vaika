package dashboard;

import java.sql.*;
import java.util.Vector;
import tools.Database;

public class DashboardAnnuel {

    private int annee;
    private String destinationTop;
    private double destinationPourcentage;
    private double chiffreAffaires;
    private double benefice;
    private int nombreReservations;

    public DashboardAnnuel() {}

    public int getAnnee() { return annee; }
    public String getDestinationTop() { return destinationTop; }
    public double getDestinationPourcentage() { return destinationPourcentage; }
    public double getChiffreAffaires() { return chiffreAffaires; }
    public double getBenefice() { return benefice; }
    public int getNombreReservations() { return nombreReservations; }

    public void setAnnee(int annee) { this.annee = annee; }
    public void setDestinationTop(String destinationTop) { this.destinationTop = destinationTop; }
    public void setDestinationPourcentage(double destinationPourcentage) { this.destinationPourcentage = destinationPourcentage; }
    public void setChiffreAffaires(double chiffreAffaires) { this.chiffreAffaires = chiffreAffaires; }
    public void setBenefice(double benefice) { this.benefice = benefice; }
    public void setNombreReservations(int nombreReservations) { this.nombreReservations = nombreReservations; }

    
    public static Vector<DashboardAnnuel> getHistorique() throws Exception {
        Vector<DashboardAnnuel> historique = new Vector<>();

        String sql =
            "SELECT EXTRACT(YEAR FROM d.date_depart)::INT AS annee, " +
            "COUNT(r.id_reservation) AS nb_reservations, " +
            "COALESCE(SUM(p.montant), 0) AS chiffre_affaires " +
            "FROM depart d " +
            "JOIN reservation r ON r.id_depart = d.id_depart AND r.statut != 'ANNULEE' " +
            "LEFT JOIN paiement p ON p.id_reservation = r.id_reservation AND p.statut = 'PAYE' " +
            "GROUP BY annee " +
            "ORDER BY annee DESC";

        try (Connection c = new Database().dbconnect();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                DashboardAnnuel da = new DashboardAnnuel();
                int annee = rs.getInt("annee");

                da.setAnnee(annee);
                da.setNombreReservations(rs.getInt("nb_reservations"));
                da.setChiffreAffaires(rs.getDouble("chiffre_affaires"));
                da.setBenefice(da.getChiffreAffaires() - getDepensesAnnee(c, annee));

                String[] dest = getDestinationTop(c, annee);
                da.setDestinationTop(dest[0]);
                da.setDestinationPourcentage(Double.parseDouble(dest[1]));

                historique.add(da);
            }
        }
        return historique;
    }

    private static double getDepensesAnnee(Connection c, int annee) throws Exception {
        String sql = "SELECT COALESCE(SUM(montant), 0) FROM depense WHERE EXTRACT(YEAR FROM date_depense) = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, annee);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        }
        return 0;
    }

    private static String[] getDestinationTop(Connection c, int annee) throws Exception {
        int total = 0;
        String sqlTotal =
            "SELECT COUNT(*) FROM reservation r " +
            "JOIN depart d ON r.id_depart = d.id_depart " +
            "WHERE r.statut != 'ANNULEE' AND EXTRACT(YEAR FROM d.date_depart) = ?";
        try (PreparedStatement ps = c.prepareStatement(sqlTotal)) {
            ps.setInt(1, annee);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) total = rs.getInt(1);
        }

        String sqlTop =
            "SELECT va.nom_ville AS destination, COUNT(*) AS nb " +
            "FROM reservation r " +
            "JOIN depart d ON r.id_depart = d.id_depart " +
            "JOIN trajet t ON d.id_trajet = t.id_trajet " +
            "JOIN ville va ON t.id_ville_arrivee = va.id_ville " +
            "WHERE r.statut != 'ANNULEE' AND EXTRACT(YEAR FROM d.date_depart) = ? " +
            "GROUP BY va.nom_ville " +
            "ORDER BY nb DESC " +
            "LIMIT 1";
        try (PreparedStatement ps = c.prepareStatement(sqlTop)) {
            ps.setInt(1, annee);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                double pourcentage = total > 0 ? (rs.getInt("nb") * 100.0 / total) : 0;
                return new String[]{ rs.getString("destination"), String.valueOf(pourcentage) };
            }
        }
        return new String[]{ "-", "0" };
    }

    public static Vector<Object[]> getTopDestinations(int annee, int limite) throws Exception {
        Vector<Object[]> resultat = new Vector<>();

        try (Connection c = new Database().dbconnect()) {
            int total = 0;
            String sqlTotal =
                "SELECT COUNT(*) FROM reservation r JOIN depart d ON r.id_depart = d.id_depart " +
                "WHERE r.statut != 'ANNULEE' AND EXTRACT(YEAR FROM d.date_depart) = ?";
            try (PreparedStatement ps = c.prepareStatement(sqlTotal)) {
                ps.setInt(1, annee);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) total = rs.getInt(1);
            }

            String sql =
                "SELECT va.nom_ville AS destination, COUNT(*) AS nb " +
                "FROM reservation r " +
                "JOIN depart d ON r.id_depart = d.id_depart " +
                "JOIN trajet t ON d.id_trajet = t.id_trajet " +
                "JOIN ville va ON t.id_ville_arrivee = va.id_ville " +
                "WHERE r.statut != 'ANNULEE' AND EXTRACT(YEAR FROM d.date_depart) = ? " +
                "GROUP BY va.nom_ville " +
                "ORDER BY nb DESC " +
                "LIMIT ?";
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setInt(1, annee);
                ps.setInt(2, limite);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    double pourcentage = total > 0 ? (rs.getInt("nb") * 100.0 / total) : 0;
                    resultat.add(new Object[]{ rs.getString("destination"), pourcentage });
                }
            }
        }
        return resultat;
    }

}