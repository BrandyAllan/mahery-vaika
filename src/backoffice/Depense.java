package backoffice;

import java.sql.*;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Locale;
import java.util.Vector;
import tools.Database;

public class Depense {

    private int id_depense;
    private String type_depense;
    private String description;
    private double montant;
    private Date date_depense;
    private Integer id_vehicule;
    private Integer id_utilisateur;

    public Depense() {}

    public int getId_depense() {
        return id_depense;
    }

    public void setId_depense(int id_depense) {
        this.id_depense = id_depense;
    }

    public String getType_depense() {
        return type_depense;
    }

    public void setType_depense(String type_depense) {
        this.type_depense = type_depense;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public Date getDate_depense() {
        return date_depense;
    }

    public void setDate_depense(Date date_depense) {
        this.date_depense = date_depense;
    }

    public Integer getId_vehicule() {
        return id_vehicule;
    }

    public void setId_vehicule(Integer id_vehicule) {
        this.id_vehicule = id_vehicule;
    }

    public Integer getId_utilisateur() {
        return id_utilisateur;
    }

    public void setId_utilisateur(Integer id_utilisateur) {
        this.id_utilisateur = id_utilisateur;
    }

    

    public static void ajouter(Depense d) throws Exception {

        String sql = "INSERT INTO depense (type_depense, description, montant, date_depense, id_vehicule, id_utilisateur) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection c = new Database().dbconnect();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, d.getType_depense());
            ps.setString(2, d.getDescription());
            ps.setDouble(3, d.getMontant());
            ps.setDate(4, d.getDate_depense());

            if (d.getId_vehicule() != null) {
                ps.setInt(5, d.getId_vehicule());
            } else {
                ps.setNull(5, Types.INTEGER);
            }

            if (d.getId_utilisateur() != null) {
                ps.setInt(6, d.getId_utilisateur());
            } else {
                ps.setNull(6, Types.INTEGER);
            }

            ps.executeUpdate();
        }
    }

    

    public static Vector<Depense> rechercher(String recherche, String tri, Date d1, Date d2, int lim, int off) throws Exception {

        Vector<Depense> resultat = new Vector<>();
        Vector<Object> parametres = new Vector<>();

        StringBuilder sql = new StringBuilder("SELECT * FROM depense WHERE 1=1 ");

        if (recherche != null && !recherche.isEmpty()) {
            sql.append(" AND (type_depense ILIKE ? OR description ILIKE ?) ");
            parametres.add("%" + recherche + "%");
            parametres.add("%" + recherche + "%");
        }

        if (d1 != null && d2 != null) {
            sql.append(" AND date_depense BETWEEN ? AND ? ");
            parametres.add(d1);
            parametres.add(d2);
        }

        sql.append(" ORDER BY date_depense ").append(tri.equalsIgnoreCase("DESC") ? "DESC" : "ASC");
        sql.append(" LIMIT ? OFFSET ? ");
        parametres.add(lim);
        parametres.add(off);

        try (Connection c = new Database().dbconnect();
             PreparedStatement ps = c.prepareStatement(sql.toString())) {

            for (int i = 0; i < parametres.size(); i++) {
                ps.setObject(i + 1, parametres.get(i));
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Depense d = new Depense();

                d.setId_depense(rs.getInt("id_depense"));
                d.setType_depense(rs.getString("type_depense"));
                d.setDescription(rs.getString("description"));
                d.setMontant(rs.getDouble("montant"));
                d.setDate_depense(rs.getDate("date_depense"));
                d.setId_vehicule((Integer) rs.getObject("id_vehicule"));
                d.setId_utilisateur((Integer) rs.getObject("id_utilisateur"));

                resultat.add(d);
            }
        }

        return resultat;
    }

    

    public static int count(String recherche, Date d1, Date d2) throws Exception {

        Vector<Object> parametres = new Vector<>();

        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM depense WHERE 1=1 ");

        if (recherche != null && !recherche.isEmpty()) {
            sql.append(" AND (type_depense ILIKE ? OR description ILIKE ?) ");
            parametres.add("%" + recherche + "%");
            parametres.add("%" + recherche + "%");
        }

        if (d1 != null && d2 != null) {
            sql.append(" AND date_depense BETWEEN ? AND ? ");
            parametres.add(d1);
            parametres.add(d2);
        }

        try (Connection c = new Database().dbconnect();
             PreparedStatement ps = c.prepareStatement(sql.toString())) {

            for (int i = 0; i < parametres.size(); i++) {
                ps.setObject(i + 1, parametres.get(i));
            }

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        }

        return 0;
    }

    
    public static Depense getById(int id) throws Exception {

        String sql = "SELECT * FROM depense WHERE id_depense = ?";

        try (Connection c = new Database().dbconnect();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Depense d = new Depense();

                d.setId_depense(rs.getInt("id_depense"));
                d.setType_depense(rs.getString("type_depense"));
                d.setDescription(rs.getString("description"));
                d.setMontant(rs.getDouble("montant"));
                d.setDate_depense(rs.getDate("date_depense"));
                d.setId_vehicule((Integer) rs.getObject("id_vehicule"));
                d.setId_utilisateur((Integer) rs.getObject("id_utilisateur"));

                return d;
            }
        }

        return null;
    }
    public static String formatMontant(double montant) {
    DecimalFormatSymbols symbols = new DecimalFormatSymbols(Locale.FRANCE);
    symbols.setGroupingSeparator(' ');
    symbols.setDecimalSeparator(',');
    DecimalFormat df = new DecimalFormat("#,###.00", symbols);
    return df.format(montant);
    
    }
    public static Vector<Object[]> getVehiculesActifs() throws Exception {
    Vector<Object[]> liste = new Vector<>();
    String sql = "SELECT id_vehicule, immatriculation, marque, modele FROM vehicule WHERE etat = 'ACTIF' ORDER BY immatriculation";
    try (Connection c = new Database().dbconnect();
         PreparedStatement ps = c.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            Object[] v = new Object[4];
            v[0] = rs.getInt("id_vehicule");
            v[1] = rs.getString("immatriculation");
            v[2] = rs.getString("marque");
            v[3] = rs.getString("modele");
            liste.add(v);
        }
    }
    return liste;
    }
    public static Vector<Object[]> getUtilisateursActifs() throws Exception {
    Vector<Object[]> liste = new Vector<>();
    String sql = "SELECT id_utilisateur, nom, prenom FROM utilisateur WHERE actif = true ORDER BY nom";
    try (Connection c = new Database().dbconnect();
         PreparedStatement ps = c.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            Object[] u = new Object[3];
            u[0] = rs.getInt("id_utilisateur");
            u[1] = rs.getString("nom");
            u[2] = rs.getString("prenom");
            liste.add(u);
        }
    }
    return liste;
    }

}
