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

public class DashboardJour {

    private static final int NOMBRE_JOURS = 5;
    private static final int NB_MAX_TRAJETS = 5;

    public static class StatJour {
        private final Date date;
        private final String label;
        private final double chiffreAffaires;
        private final double depenses;
        private final double benefice;

        public StatJour(
            Date date,
            String label,
            double chiffreAffaires,
            double depenses,
            double benefice
        ) {
            this.date = date;
            this.label = label;
            this.chiffreAffaires = chiffreAffaires;
            this.depenses = depenses;
            this.benefice = benefice;
        }

        public Date getDate() {
            return date;
        }

        public String getLabel() {
            return label;
        }

        public double getChiffreAffaires() {
            return chiffreAffaires;
        }

        public double getDepenses() {
            return depenses;
        }

        public double getBenefice() {
            return benefice;
        }
    }

    public static class ChoixTrajet {
        private final String trajet;
        private final int nombreReservations;
        private final double pourcentage;

        public ChoixTrajet(
            String trajet,
            int nombreReservations,
            double pourcentage
        ) {
            this.trajet = trajet;
            this.nombreReservations = nombreReservations;
            this.pourcentage = pourcentage;
        }

        public String getTrajet() {
            return trajet;
        }

        public int getNombreReservations() {
            return nombreReservations;
        }

        public double getPourcentage() {
            return pourcentage;
        }
    }

    private static class LigneTrajet {
        private final String trajet;
        private final int nombre;

        public LigneTrajet(String trajet, int nombre) {
            this.trajet = trajet;
            this.nombre = nombre;
        }
    }

    public static Date getJourActuel() {
        return new Date(System.currentTimeMillis());
    }

    public static Date soustraireJours(Date date, int nombreJours) {
        Calendar calendrier = Calendar.getInstance();
        calendrier.setTime(date);
        calendrier.add(Calendar.DAY_OF_MONTH, -nombreJours);

        return new Date(calendrier.getTimeInMillis());
    }

    public static List<StatJour> getStatistiquesCinqJours(Date dateCible) {
        List<StatJour> resultat = new ArrayList<>();

        if (dateCible == null) {
            dateCible = getJourActuel();
        }

        Date premierJour = soustraireJours(
            dateCible,
            NOMBRE_JOURS - 1
        );

        Calendar curseur = Calendar.getInstance();
        curseur.setTime(premierJour);

        SimpleDateFormat formatLabel =
            new SimpleDateFormat("dd MMM", Locale.FRENCH);

        for (int i = 0; i < NOMBRE_JOURS; i++) {
            Date dateJour = new Date(curseur.getTimeInMillis());

            double chiffreAffaires =
                getChiffreAffairesDuJour(dateJour);

            double depenses =
                getDepensesDuJour(dateJour);

            double benefice =
                chiffreAffaires - depenses;

            String label = formatLabel.format(dateJour);

            resultat.add(
                new StatJour(
                    dateJour,
                    label,
                    chiffreAffaires,
                    depenses,
                    benefice
                )
            );

            curseur.add(Calendar.DAY_OF_MONTH, 1);
        }

        return resultat;
    }

    private static double getChiffreAffairesDuJour(Date dateJour) {
        double total = 0;

        String sql =
            "SELECT COALESCE(SUM(p.montant), 0) AS total " +
            "FROM paiement p " +
            "JOIN reservation r " +
            "ON r.id_reservation = p.id_reservation " +
            "JOIN depart d " +
            "ON d.id_depart = r.id_depart " +
            "WHERE d.date_depart = ? " +
            "AND p.statut = 'PAYE' " +
            "AND r.statut <> 'ANNULEE'";

        try (
            Connection connexion = new Database().dbconnect()
        ) {
            if (connexion == null) {
                return 0;
            }

            try (
                PreparedStatement ps =
                    connexion.prepareStatement(sql)
            ) {
                ps.setDate(1, dateJour);

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

    private static double getDepensesDuJour(Date dateJour) {
        double total = 0;

        String sql =
            "SELECT COALESCE(SUM(montant), 0) AS total " +
            "FROM depense " +
            "WHERE date_depense = ?";

        try (
            Connection connexion = new Database().dbconnect()
        ) {
            if (connexion == null) {
                return 0;
            }

            try (
                PreparedStatement ps =
                    connexion.prepareStatement(sql)
            ) {
                ps.setDate(1, dateJour);

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

    public static List<ChoixTrajet> getChoixTrajetsDuJour(
        Date dateJour
    ) {
        List<ChoixTrajet> resultat = new ArrayList<>();
        List<LigneTrajet> lignes = new ArrayList<>();

        if (dateJour == null) {
            dateJour = getJourActuel();
        }

        String sql =
            "SELECT " +
            "vd.nom_ville || ' → ' || va.nom_ville AS trajet, " +
            "COUNT(r.id_reservation) AS nombre " +
            "FROM reservation r " +
            "JOIN depart d " +
            "ON d.id_depart = r.id_depart " +
            "JOIN trajet t " +
            "ON t.id_trajet = d.id_trajet " +
            "JOIN ville vd " +
            "ON vd.id_ville = t.id_ville_depart " +
            "JOIN ville va " +
            "ON va.id_ville = t.id_ville_arrivee " +
            "WHERE d.date_depart = ? " +
            "AND r.statut <> 'ANNULEE' " +
            "GROUP BY " +
            "t.id_trajet, " +
            "vd.nom_ville, " +
            "va.nom_ville " +
            "ORDER BY nombre DESC, trajet ASC";

        int totalReservations = 0;

        try (
            Connection connexion = new Database().dbconnect()
        ) {
            if (connexion == null) {
                return resultat;
            }

            try (
                PreparedStatement ps =
                    connexion.prepareStatement(sql)
            ) {
                ps.setDate(1, dateJour);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        String trajet = rs.getString("trajet");
                        int nombre = rs.getInt("nombre");

                        lignes.add(
                            new LigneTrajet(trajet, nombre)
                        );

                        totalReservations += nombre;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return resultat;
        }

        if (totalReservations == 0) {
            return resultat;
        }

        int nombreTrajetsDirects =
            Math.min(NB_MAX_TRAJETS, lignes.size());

        for (int i = 0; i < nombreTrajetsDirects; i++) {
            LigneTrajet ligne = lignes.get(i);

            double pourcentage = arrondirPourcentage(
                ligne.nombre,
                totalReservations
            );

            resultat.add(
                new ChoixTrajet(
                    ligne.trajet,
                    ligne.nombre,
                    pourcentage
                )
            );
        }

        if (lignes.size() > NB_MAX_TRAJETS) {
            int totalAutres = 0;

            for (
                int i = NB_MAX_TRAJETS;
                i < lignes.size();
                i++
            ) {
                totalAutres += lignes.get(i).nombre;
            }

            resultat.add(
                new ChoixTrajet(
                    "Autres trajets",
                    totalAutres,
                    arrondirPourcentage(
                        totalAutres,
                        totalReservations
                    )
                )
            );
        }

        return resultat;
    }

    private static double arrondirPourcentage(
        int nombre,
        int total
    ) {
        if (total <= 0) {
            return 0;
        }

        return Math.round(
            nombre * 10000.0 / total
        ) / 100.0;
    }
}