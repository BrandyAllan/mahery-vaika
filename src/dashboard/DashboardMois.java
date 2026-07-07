package dashboard;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import tools.Database;

public class DashboardMois {

    public static class Semaine {
        private String label;
        private double ca;
        private double benefice;

        public Semaine(String label, double ca, double benefice) {
            this.label = label;
            this.ca = ca;
            this.benefice = benefice;
        }

        public String getLabel()    { return label; }
        public double getCa()       { return ca; }
        public double getBenefice() { return benefice; }
    }

    public static class Destination {
        private String ville;
        private int nombre;
        private double pourcentage;

        public Destination(String ville, int nombre, double pourcentage) {
            this.ville = ville;
            this.nombre = nombre;
            this.pourcentage = pourcentage;
        }

        public String getVille()        { return ville; }
        public int getNombre()          { return nombre; }
        public double getPourcentage()  { return pourcentage; }
    }

    private static final int NB_MAX_DESTINATIONS = 5;

    public static Date premierJourMoisCourant() {
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.DAY_OF_MONTH, 1);
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        return new Date(cal.getTimeInMillis());
    }

    public static Date dernierJourMoisCourant() {
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        return new Date(cal.getTimeInMillis());
    }

    public static List<Semaine> getStatsSemaine(Date dateDebut, Date dateFin) {
        List<Semaine> resultat = new ArrayList<>();

        if (dateDebut == null || dateFin == null || dateFin.before(dateDebut)) {
            return resultat;
        }

        Calendar curseur = Calendar.getInstance();
        curseur.setTime(dateDebut);
        curseur.set(Calendar.HOUR_OF_DAY, 0);
        curseur.set(Calendar.MINUTE, 0);
        curseur.set(Calendar.SECOND, 0);
        curseur.set(Calendar.MILLISECOND, 0);

        Calendar fin = Calendar.getInstance();
        fin.setTime(dateFin);
        fin.set(Calendar.HOUR_OF_DAY, 0);
        fin.set(Calendar.MINUTE, 0);
        fin.set(Calendar.SECOND, 0);
        fin.set(Calendar.MILLISECOND, 0);

        int numeroSemaine = 1;

        while (!curseur.after(fin)) {
            Date debutSemaine = new Date(curseur.getTimeInMillis());

            Calendar finSemaineCal = (Calendar) curseur.clone();
            finSemaineCal.add(Calendar.DAY_OF_MONTH, 6);
            if (finSemaineCal.after(fin)) {
                finSemaineCal = (Calendar) fin.clone();
            }
            Date finSemaine = new Date(finSemaineCal.getTimeInMillis());

            double ca = getChiffreAffaires(debutSemaine, finSemaine);
            double depenses = getDepenses(debutSemaine, finSemaine);

            resultat.add(new Semaine("S" + numeroSemaine, ca, ca - depenses));

            curseur.add(Calendar.DAY_OF_MONTH, 7);
            numeroSemaine++;
        }

        return resultat;
    }

    private static double getChiffreAffaires(Date debut, Date fin) {
        double total = 0;
        String sql =
            "SELECT COALESCE(SUM(p.montant), 0) AS total " +
            "FROM paiement p " +
            "JOIN reservation r ON p.id_reservation = r.id_reservation " +
            "JOIN depart d ON r.id_depart = d.id_depart " +
            "WHERE d.date_depart BETWEEN ? AND ? " +
            "AND p.statut = 'PAYE'";

        try (Connection c = new Database().dbconnect()) {
            if (c == null) {
                return 0;
            }
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setDate(1, debut);
                ps.setDate(2, fin);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        total = rs.getDouble("total");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }

    private static double getDepenses(Date debut, Date fin) {
        double total = 0;
        String sql =
            "SELECT COALESCE(SUM(montant), 0) AS total " +
            "FROM depense " +
            "WHERE date_depense BETWEEN ? AND ?";

        try (Connection c = new Database().dbconnect()) {
            if (c == null) {
                return 0;
            }
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setDate(1, debut);
                ps.setDate(2, fin);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        total = rs.getDouble("total");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }

    public static List<Destination> getStatsDestinations(Date dateDebut, Date dateFin) {
        List<Destination> resultat = new ArrayList<>();

        if (dateDebut == null || dateFin == null || dateFin.before(dateDebut)) {
            return resultat;
        }

        String sql =
            "SELECT va.nom_ville AS destination, COUNT(*) AS nombre " +
            "FROM reservation r " +
            "JOIN depart d ON r.id_depart = d.id_depart " +
            "JOIN trajet t ON d.id_trajet = t.id_trajet " +
            "JOIN ville va ON t.id_ville_arrivee = va.id_ville " +
            "WHERE d.date_depart BETWEEN ? AND ? " +
            "AND r.statut != 'ANNULEE' " +
            "GROUP BY va.nom_ville " +
            "ORDER BY nombre DESC " +
            "LIMIT " + NB_MAX_DESTINATIONS;

        List<String> villes = new ArrayList<>();
        List<Integer> nombres = new ArrayList<>();
        int total = 0;

        try (Connection c = new Database().dbconnect()) {
            if (c == null) {
                return resultat;
            }
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setDate(1, dateDebut);
                ps.setDate(2, dateFin);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        String ville = rs.getString("destination");
                        int nombre = rs.getInt("nombre");
                        villes.add(ville);
                        nombres.add(nombre);
                        total += nombre;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return resultat;
        }

        for (int i = 0; i < villes.size(); i++) {
            double pourcentage = (total > 0) ? Math.round((nombres.get(i) * 10000.0) / total) / 100.0 : 0;
            resultat.add(new Destination(villes.get(i), nombres.get(i), pourcentage));
        }

        return resultat;
    }
}
