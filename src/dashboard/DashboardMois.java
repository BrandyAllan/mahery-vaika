package dashboard;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;
import tools.Database;

public class DashboardMois {

    public static class Mois {

        private final String label;
        private final double ca;
        private final double benefice;

        public Mois(String label, double ca, double benefice) {
            this.label = label;
            this.ca = ca;
            this.benefice = benefice;
        }

        public String getLabel() {
            return label;
        }

        public double getCa() {
            return ca;
        }

        public double getBenefice() {
            return benefice;
        }
    }

    public static class Destination {

        private final String ville;
        private final int nombre;
        private final double pourcentage;

        public Destination(
            String ville,
            int nombre,
            double pourcentage
        ) {
            this.ville = ville;
            this.nombre = nombre;
            this.pourcentage = pourcentage;
        }

        public String getVille() {
            return ville;
        }

        public int getNombre() {
            return nombre;
        }

        public double getPourcentage() {
            return pourcentage;
        }
    }

    private static final int NB_MAX_DESTINATIONS = 5;

    private static void remettreHeureAZero(Calendar cal) {
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
    }

    public static Date premierJourMoisCourant() {

        Calendar cal = Calendar.getInstance();

        cal.set(Calendar.DAY_OF_MONTH, 1);
        remettreHeureAZero(cal);

        return new Date(cal.getTimeInMillis());
    }

    public static Date dernierJourMoisCourant() {

        Calendar cal = Calendar.getInstance();

        cal.set(
            Calendar.DAY_OF_MONTH,
            cal.getActualMaximum(Calendar.DAY_OF_MONTH)
        );

        remettreHeureAZero(cal);

        return new Date(cal.getTimeInMillis());
    }

    public static Date premierJourDesCinqDerniersMois() {

        Calendar cal = Calendar.getInstance();

        cal.add(Calendar.MONTH, -4);
        cal.set(Calendar.DAY_OF_MONTH, 1);

        remettreHeureAZero(cal);

        return new Date(cal.getTimeInMillis());
    }

    public static List<Mois> getStatsMois(
        Date dateDebut,
        Date dateFin
    ) {

        List<Mois> resultat = new ArrayList<>();

        if (
            dateDebut == null
            || dateFin == null
            || dateFin.before(dateDebut)
        ) {
            return resultat;
        }

        Calendar curseur = Calendar.getInstance();

        curseur.setTime(dateDebut);
        curseur.set(Calendar.DAY_OF_MONTH, 1);
        remettreHeureAZero(curseur);

        Calendar limite = Calendar.getInstance();

        limite.setTime(dateFin);
        limite.set(Calendar.DAY_OF_MONTH, 1);
        remettreHeureAZero(limite);

        SimpleDateFormat formatMois =
            new SimpleDateFormat(
                "MMMM yyyy",
                Locale.FRENCH
            );

        while (!curseur.after(limite)) {

            Calendar debutMoisCal =
                (Calendar) curseur.clone();

            debutMoisCal.set(
                Calendar.DAY_OF_MONTH,
                1
            );

            Calendar finMoisCal =
                (Calendar) curseur.clone();

            finMoisCal.set(
                Calendar.DAY_OF_MONTH,
                finMoisCal.getActualMaximum(
                    Calendar.DAY_OF_MONTH
                )
            );

            Date debutMois =
                new Date(
                    debutMoisCal.getTimeInMillis()
                );

            Date finMois =
                new Date(
                    finMoisCal.getTimeInMillis()
                );

            if (debutMois.before(dateDebut)) {
                debutMois = dateDebut;
            }

            if (finMois.after(dateFin)) {
                finMois = dateFin;
            }

            double chiffreAffaires =
                getChiffreAffaires(
                    debutMois,
                    finMois
                );

            double depenses =
                getDepenses(
                    debutMois,
                    finMois
                );

            double benefice =
                chiffreAffaires - depenses;

            String label =
                formatMois.format(
                    curseur.getTime()
                );

            if (
                label != null
                && !label.isEmpty()
            ) {
                label =
                    Character.toUpperCase(
                        label.charAt(0)
                    )
                    + label.substring(1);
            }

            resultat.add(
                new Mois(
                    label,
                    chiffreAffaires,
                    benefice
                )
            );

            curseur.add(
                Calendar.MONTH,
                1
            );
        }

        return resultat;
    }

    private static double getChiffreAffaires(
        Date dateDebut,
        Date dateFin
    ) {

        double total = 0;

        String sql =
            "SELECT COALESCE(SUM(p.montant), 0) AS total " +
            "FROM paiement p " +
            "JOIN reservation r " +
            "ON p.id_reservation = r.id_reservation " +
            "JOIN depart d " +
            "ON r.id_depart = d.id_depart " +
            "WHERE d.date_depart BETWEEN ? AND ? " +
            "AND p.statut = 'PAYE' " +
            "AND r.statut <> 'ANNULEE'";

        try (Connection connexion = new Database().dbconnect()) {

            if (connexion == null) {
                return 0;
            }

            try (
                PreparedStatement ps =
                    connexion.prepareStatement(sql)
            ) {

                ps.setDate(1, dateDebut);
                ps.setDate(2, dateFin);

                try (
                    ResultSet rs =
                        ps.executeQuery()
                ) {

                    if (rs.next()) {
                        total =
                            rs.getDouble("total");
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return total;
    }

    private static double getDepenses(
        Date dateDebut,
        Date dateFin
    ) {

        double total = 0;

        String sql =
            "SELECT COALESCE(SUM(montant), 0) AS total " +
            "FROM depense " +
            "WHERE date_depense BETWEEN ? AND ?";

        try (
            Connection connexion =
                new Database().dbconnect()
        ) {

            if (connexion == null) {
                return 0;
            }

            try (
                PreparedStatement ps =
                    connexion.prepareStatement(sql)
            ) {

                ps.setDate(1, dateDebut);
                ps.setDate(2, dateFin);

                try (
                    ResultSet rs =
                        ps.executeQuery()
                ) {

                    if (rs.next()) {
                        total =
                            rs.getDouble("total");
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return total;
    }

    public static List<Destination> getStatsDestinations(
        Date dateDebut,
        Date dateFin
    ) {

        List<Destination> resultat =
            new ArrayList<>();

        if (
            dateDebut == null
            || dateFin == null
            || dateFin.before(dateDebut)
        ) {
            return resultat;
        }

        String sql =
            "SELECT " +
            "va.nom_ville AS destination, " +
            "COUNT(*) AS nombre " +

            "FROM reservation r " +

            "JOIN depart d " +
            "ON r.id_depart = d.id_depart " +

            "JOIN trajet t " +
            "ON d.id_trajet = t.id_trajet " +

            "JOIN ville va " +
            "ON t.id_ville_arrivee = va.id_ville " +

            "WHERE d.date_depart BETWEEN ? AND ? " +
            "AND r.statut <> 'ANNULEE' " +

            "GROUP BY va.id_ville, va.nom_ville " +
            "ORDER BY nombre DESC " +
            "LIMIT ?";

        List<String> villes =
            new ArrayList<>();

        List<Integer> nombres =
            new ArrayList<>();

        int totalReservations = 0;

        try (
            Connection connexion =
                new Database().dbconnect()
        ) {

            if (connexion == null) {
                return resultat;
            }

            try (
                PreparedStatement ps =
                    connexion.prepareStatement(sql)
            ) {

                ps.setDate(1, dateDebut);
                ps.setDate(2, dateFin);
                ps.setInt(
                    3,
                    NB_MAX_DESTINATIONS
                );

                try (
                    ResultSet rs =
                        ps.executeQuery()
                ) {

                    while (rs.next()) {

                        String ville =
                            rs.getString(
                                "destination"
                            );

                        int nombre =
                            rs.getInt(
                                "nombre"
                            );

                        villes.add(ville);
                        nombres.add(nombre);

                        totalReservations += nombre;
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            return resultat;
        }

        for (
            int i = 0;
            i < villes.size();
            i++
        ) {

            double pourcentage = 0;

            if (totalReservations > 0) {

                pourcentage =
                    Math.round(
                        nombres.get(i)
                        * 10000.0
                        / totalReservations
                    ) / 100.0;
            }

            resultat.add(
                new Destination(
                    villes.get(i),
                    nombres.get(i),
                    pourcentage
                )
            );
        }

        return resultat;
    }
}