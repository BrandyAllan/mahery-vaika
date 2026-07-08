package dashboard;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;
import java.util.Calendar;
import tools.Database;

public class DashboardSemaine {

    public static Vector<String> getLabelsJours(Date dateDebut, Date dateFin) throws Exception {
        Vector<String> labels = new Vector<>();
        String[] jours = {"Lun", "Mar", "Mer", "Jeu", "Ven", "Sam", "Dim"};
        
        Calendar cal = Calendar.getInstance();
        cal.setTime(dateDebut);
        
        for (int i = 0; i < 7; i++) {
            labels.add(jours[cal.get(Calendar.DAY_OF_WEEK) - 1]);
            cal.add(Calendar.DAY_OF_MONTH, 1);
            if (cal.getTime().after(dateFin)) break;
        }
        
        return labels;
    }

    public static Vector<Double> getCASemaine(Date dateDebut, Date dateFin) throws Exception {
        Vector<Double> ca = new Vector<>();
        
        Calendar cal = Calendar.getInstance();
        cal.setTime(dateDebut);
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        
        while (!cal.getTime().after(dateFin)) {
            Date jourDebut = new Date(cal.getTimeInMillis());
            cal.add(Calendar.DAY_OF_MONTH, 1);
            Date jourFin = new Date(cal.getTimeInMillis());
            
            double total = getChiffreAffaires(jourDebut, jourFin);
            ca.add(total);
        }
        
        return ca;
    }

    public static Vector<Double> getBeneficeSemaine(Date dateDebut, Date dateFin) throws Exception {
        Vector<Double> benefice = new Vector<>();
        
        Calendar cal = Calendar.getInstance();
        cal.setTime(dateDebut);
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        
        while (!cal.getTime().after(dateFin)) {
            Date jourDebut = new Date(cal.getTimeInMillis());
            cal.add(Calendar.DAY_OF_MONTH, 1);
            Date jourFin = new Date(cal.getTimeInMillis());
            
            double ca = getChiffreAffaires(jourDebut, jourFin);
            double depenses = getDepenses(jourDebut, jourFin);
            benefice.add(ca - depenses);
        }
        
        return benefice;
    }

    public static Vector<String> getDestinationsLabels(Date dateDebut, Date dateFin) throws Exception {
        Vector<String> labels = new Vector<>();
        
        String sql = """
            SELECT va.nom_ville 
            FROM reservation r
            JOIN depart d ON r.id_depart = d.id_depart
            JOIN trajet t ON d.id_trajet = t.id_trajet
            JOIN ville va ON t.id_ville_arrivee = va.id_ville
            WHERE d.date_depart BETWEEN ? AND ?
            AND r.statut != 'ANNULEE'
            GROUP BY va.nom_ville
            ORDER BY COUNT(*) DESC
            LIMIT 5
            """;
        
        try (Connection c = Database.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setDate(1, dateDebut);
            ps.setDate(2, dateFin);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                labels.add(rs.getString("nom_ville"));
            }
        }
        
        return labels;
    }

    public static Vector<Double> getDestinationsValues(Date dateDebut, Date dateFin) throws Exception {
        Vector<Double> values = new Vector<>();
        
        String sql = """
            SELECT COUNT(*) as nombre
            FROM reservation r
            JOIN depart d ON r.id_depart = d.id_depart
            JOIN trajet t ON d.id_trajet = t.id_trajet
            JOIN ville va ON t.id_ville_arrivee = va.id_ville
            WHERE d.date_depart BETWEEN ? AND ?
            AND r.statut != 'ANNULEE'
            GROUP BY va.nom_ville
            ORDER BY nombre DESC
            LIMIT 5
            """;
        
        Vector<Integer> nombres = new Vector<>();
        int total = 0;
        
        try (Connection c = Database.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setDate(1, dateDebut);
            ps.setDate(2, dateFin);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int nombre = rs.getInt("nombre");
                nombres.add(nombre);
                total += nombre;
            }
        }
        
        for (int nombre : nombres) {
            double pourcentage = (total > 0) ? Math.round((nombre * 10000.0) / total) / 100.0 : 0;
            values.add(pourcentage);
        }
        
        return values;
    }

    private static double getChiffreAffaires(Date debut, Date fin) throws Exception {
        String sql = """
            SELECT COALESCE(SUM(p.montant), 0)
            FROM paiement p
            JOIN reservation r ON p.id_reservation = r.id_reservation
            JOIN depart d ON r.id_depart = d.id_depart
            WHERE d.date_depart >= ? AND d.date_depart < ?
            AND p.statut = 'PAYE'
            """;
        
        try (Connection c = Database.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setDate(1, debut);
            ps.setDate(2, fin);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
        }
        return 0;
    }

    private static double getDepenses(Date debut, Date fin) throws Exception {
        String sql = """
            SELECT COALESCE(SUM(montant), 0)
            FROM depense
            WHERE date_depense >= ? AND date_depense < ?
            """;
        
        try (Connection c = Database.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setDate(1, debut);
            ps.setDate(2, fin);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
        }
        return 0;
    }
}