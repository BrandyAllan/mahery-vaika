package dashboard;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;
import java.util.Calendar;
import tools.Database;

public class DashboardSemaine {

    private static final int NB_SEMAINES = 5;

    /**
     * Retourne les labels des 5 dernières semaines (ex: "29/06 - 05/07")
     */
    public static Vector<String> getLabelsSemaines() throws Exception {
        Vector<String> labels = new Vector<>();
        Calendar cal = Calendar.getInstance();
        
        // Reculer de 5 semaines
        for (int i = NB_SEMAINES - 1; i >= 0; i--) {
            Calendar semaineCal = (Calendar) cal.clone();
            semaineCal.add(Calendar.WEEK_OF_YEAR, -i);
            
            // Trouver le lundi de cette semaine
            semaineCal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
            semaineCal.set(Calendar.HOUR_OF_DAY, 0);
            semaineCal.set(Calendar.MINUTE, 0);
            semaineCal.set(Calendar.SECOND, 0);
            
            Date debutSemaine = new Date(semaineCal.getTimeInMillis());
            
            // Trouver le dimanche
            semaineCal.add(Calendar.DAY_OF_MONTH, 6);
            Date finSemaine = new Date(semaineCal.getTimeInMillis());
            
            String label = formatDate(debutSemaine) + " - " + formatDate(finSemaine);
            labels.add(label);
        }
        
        return labels;
    }

    /**
     * Retourne le CA total pour chacune des 5 dernières semaines
     */
    public static Vector<Double> getCASemaines() throws Exception {
        Vector<Double> ca = new Vector<>();
        Calendar cal = Calendar.getInstance();
        
        for (int i = NB_SEMAINES - 1; i >= 0; i--) {
            Calendar semaineCal = (Calendar) cal.clone();
            semaineCal.add(Calendar.WEEK_OF_YEAR, -i);
            
            // Lundi
            semaineCal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
            semaineCal.set(Calendar.HOUR_OF_DAY, 0);
            semaineCal.set(Calendar.MINUTE, 0);
            semaineCal.set(Calendar.SECOND, 0);
            Date debutSemaine = new Date(semaineCal.getTimeInMillis());
            
            // Dimanche (inclure toute la journée)
            semaineCal.add(Calendar.DAY_OF_MONTH, 7);
            Date finSemaine = new Date(semaineCal.getTimeInMillis());
            
            double total = getChiffreAffaires(debutSemaine, finSemaine);
            ca.add(total);
        }
        
        return ca;
    }

    /**
     * Retourne le bénéfice total pour chacune des 5 dernières semaines
     */
    public static Vector<Double> getBeneficeSemaines() throws Exception {
        Vector<Double> benefice = new Vector<>();
        Calendar cal = Calendar.getInstance();
        
        for (int i = NB_SEMAINES - 1; i >= 0; i--) {
            Calendar semaineCal = (Calendar) cal.clone();
            semaineCal.add(Calendar.WEEK_OF_YEAR, -i);
            
            // Lundi
            semaineCal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
            semaineCal.set(Calendar.HOUR_OF_DAY, 0);
            semaineCal.set(Calendar.MINUTE, 0);
            semaineCal.set(Calendar.SECOND, 0);
            Date debutSemaine = new Date(semaineCal.getTimeInMillis());
            
            // Dimanche
            semaineCal.add(Calendar.DAY_OF_MONTH, 7);
            Date finSemaine = new Date(semaineCal.getTimeInMillis());
            
            double ca = getChiffreAffaires(debutSemaine, finSemaine);
            double depenses = getDepenses(debutSemaine, finSemaine);
            benefice.add(ca - depenses);
        }
        
        return benefice;
    }

    /**
     * Retourne les labels des destinations pour les 5 dernières semaines
     */
    public static Vector<String> getDestinationsLabels() throws Exception {
        Vector<String> labels = new Vector<>();
        
        // Calculer la date de début (5 semaines en arrière)
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.WEEK_OF_YEAR, -(NB_SEMAINES - 1));
        cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        Date dateDebut = new Date(cal.getTimeInMillis());
        
        // Date de fin (semaine actuelle, dimanche)
        cal = Calendar.getInstance();
        cal.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
        cal.set(Calendar.HOUR_OF_DAY, 23);
        cal.set(Calendar.MINUTE, 59);
        cal.set(Calendar.SECOND, 59);
        Date dateFin = new Date(cal.getTimeInMillis());
        
        String sql = 
            "SELECT va.nom_ville " + 
            "FROM reservation r " +
            "JOIN depart d ON r.id_depart = d.id_depart " +
            "JOIN trajet t ON d.id_trajet = t.id_trajet " +
            "JOIN ville va ON t.id_ville_arrivee = va.id_ville " +
            "WHERE d.date_depart BETWEEN ? AND ? " +
            "AND r.statut != 'ANNULEE' " +
            "GROUP BY va.nom_ville " +
            "ORDER BY COUNT(*) DESC " +
            "LIMIT 5 ";
        
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

    /**
     * Retourne les pourcentages des destinations pour les 5 dernières semaines
     */
    public static Vector<Double> getDestinationsValues() throws Exception {
        Vector<Double> values = new Vector<>();
        
        // Calculer la date de début (5 semaines en arrière)
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.WEEK_OF_YEAR, -(NB_SEMAINES - 1));
        cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        Date dateDebut = new Date(cal.getTimeInMillis());
        
        // Date de fin (semaine actuelle, dimanche)
        cal = Calendar.getInstance();
        cal.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
        cal.set(Calendar.HOUR_OF_DAY, 23);
        cal.set(Calendar.MINUTE, 59);
        cal.set(Calendar.SECOND, 59);
        Date dateFin = new Date(cal.getTimeInMillis());
        
        String sql = 
            "SELECT COUNT(*) as nombre " +
            "FROM reservation r " +
            "JOIN depart d ON r.id_depart = d.id_depart " +
            "JOIN trajet t ON d.id_trajet = t.id_trajet " +
            "JOIN ville va ON t.id_ville_arrivee = va.id_ville " +
            "WHERE d.date_depart BETWEEN ? AND ? " +
            "AND r.statut != 'ANNULEE' " +
            "GROUP BY va.nom_ville " +
            "ORDER BY nombre DESC " +
            "LIMIT 5 ";
        
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

    private static String formatDate(Date date) {
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM");
        return sdf.format(date);
    }

    private static double getChiffreAffaires(Date debut, Date fin) throws Exception {
        String sql = 
            "SELECT COALESCE(SUM(p.montant), 0) " +
            "FROM paiement p " +
            "JOIN reservation r ON p.id_reservation = r.id_reservation " +
            "JOIN depart d ON r.id_depart = d.id_depart " +
            "WHERE d.date_depart >= ? AND d.date_depart < ? " +
            "AND p.statut = 'PAYE' ";
        
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
        String sql = 
            "SELECT COALESCE(SUM(montant), 0) " +
            "FROM depense " +
            "WHERE date_depense >= ? AND date_depense < ? ";
        
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