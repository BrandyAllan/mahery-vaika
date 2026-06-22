package backoffice;

import java.sql.*;
import java.util.ArrayList;
import tools.Database;

public class Utilisateur {
    private int id_utilisateur;
    private int id_role;
    private String nom;
    private String prenom;
    private String telephone;
    private String email;
    private String identifiant;
    private String mot_de_passe;
    private Date date_embauche;
    private Date date_retrait;
    private boolean actif;
    private Timestamp date_creation;

    public Utilisateur() {}

    public int getId_utilisateur() { return id_utilisateur; }
    public void setId_utilisateur(int id_utilisateur) { this.id_utilisateur = id_utilisateur; }
    public int getId_role() { return id_role; }
    public void setId_role(int id_role) { this.id_role = id_role; }
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }
    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getIdentifiant() { return identifiant; }
    public void setIdentifiant(String identifiant) { this.identifiant = identifiant; }
    public String getMot_de_passe() { return mot_de_passe; }
    public void setMot_de_passe(String mot_de_passe) { this.mot_de_passe = mot_de_passe; }
    public Date getDate_embauche() { return date_embauche; }
    public void setDate_embauche(Date date_embauche) { this.date_embauche = date_embauche; }
    public Date getDate_retrait() { return date_retrait; }
    public void setDate_retrait(Date date_retrait) { this.date_retrait = date_retrait; }
    public boolean isActif() { return actif; }
    public void setActif(boolean actif) { this.actif = actif; }
    public Timestamp getDate_creation() { return date_creation; }
    public void setDate_creation(Timestamp date_creation) { this.date_creation = date_creation; }

    public static ArrayList<Utilisateur> rechercher(String nom, int idRole, Boolean statut, Date d1, Date d2, String tri, int lim, int off) throws Exception {
        ArrayList<Utilisateur> l = new ArrayList<>();
        ArrayList<Object> p = new ArrayList<>();
        StringBuilder s = new StringBuilder("SELECT * FROM utilisateur WHERE 1=1 ");
        if (nom != null && !nom.isEmpty()) { s.append(" AND nom ILIKE ? "); p.add("%" + nom + "%"); }
        if (idRole > 0) { s.append(" AND id_role = ? "); p.add(idRole); }
        if (statut != null) { s.append(" AND actif = ? "); p.add(statut); }
        if (d1 != null && d2 != null) { s.append(" AND date_embauche BETWEEN ? AND ? "); p.add(d1); p.add(d2); }
        s.append(" ORDER BY nom ").append(tri.equalsIgnoreCase("DESC") ? "DESC" : "ASC");
        s.append(" LIMIT ? OFFSET ? "); p.add(lim); p.add(off);
        try (Connection c = new Database().dbconnect(); PreparedStatement ps = c.prepareStatement(s.toString())) {
            for (int i = 0; i < p.size(); i++) ps.setObject(i + 1, p.get(i));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Utilisateur u = new Utilisateur();
                u.setId_utilisateur(rs.getInt("id_utilisateur"));
                u.setId_role(rs.getInt("id_role"));
                u.setNom(rs.getString("nom"));
                u.setPrenom(rs.getString("prenom"));
                u.setTelephone(rs.getString("telephone"));
                u.setEmail(rs.getString("email"));
                u.setIdentifiant(rs.getString("identifiant"));
                u.setMot_de_passe(rs.getString("mot_de_passe"));
                u.setDate_embauche(rs.getDate("date_embauche"));
                u.setDate_retrait(rs.getDate("date_retrait"));
                u.setActif(rs.getBoolean("actif"));
                u.setDate_creation(rs.getTimestamp("date_creation"));
                l.add(u);
            }
        }
        return l;
    }

    public static int count(String nom, int idRole, Boolean statut, Date d1, Date d2) throws Exception {
        ArrayList<Object> p = new ArrayList<>();
        StringBuilder s = new StringBuilder("SELECT COUNT(*) FROM utilisateur WHERE 1=1 ");
        if (nom != null && !nom.isEmpty()) { s.append(" AND nom ILIKE ? "); p.add("%" + nom + "%"); }
        if (idRole > 0) { s.append(" AND id_role = ? "); p.add(idRole); }
        if (statut != null) { s.append(" AND actif = ? "); p.add(statut); }
        if (d1 != null && d2 != null) { s.append(" AND date_embauche BETWEEN ? AND ? "); p.add(d1); p.add(d2); }
        try (Connection c = new Database().dbconnect(); PreparedStatement ps = c.prepareStatement(s.toString())) {
            for (int i = 0; i < p.size(); i++) ps.setObject(i + 1, p.get(i));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    public static Utilisateur getById(int id) throws Exception {
        String sql = "SELECT * FROM utilisateur WHERE id_utilisateur = ?";
        try (Connection c = new Database().dbconnect(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Utilisateur u = new Utilisateur();
                u.setId_utilisateur(rs.getInt("id_utilisateur"));
                u.setId_role(rs.getInt("id_role"));
                u.setNom(rs.getString("nom"));
                u.setPrenom(rs.getString("prenom"));
                u.setTelephone(rs.getString("telephone"));
                u.setEmail(rs.getString("email"));
                u.setIdentifiant(rs.getString("identifiant"));
                u.setMot_de_passe(rs.getString("mot_de_passe"));
                u.setDate_embauche(rs.getDate("date_embauche"));
                u.setDate_retrait(rs.getDate("date_retrait"));
                u.setActif(rs.getBoolean("actif"));
                u.setDate_creation(rs.getTimestamp("date_creation"));
                return u;
            }
        }
        return null;
    }

    public static void ajouter(Utilisateur u) throws Exception {
        String sql = "INSERT INTO utilisateur (id_role, nom, prenom, telephone, email, identifiant, mot_de_passe, date_embauche, date_retrait, actif) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection c = new Database().dbconnect(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, u.getId_role());
            ps.setString(2, u.getNom());
            ps.setString(3, u.getPrenom());
            ps.setString(4, u.getTelephone());
            ps.setString(5, u.getEmail());
            ps.setString(6, u.getIdentifiant());
            ps.setString(7, u.getMot_de_passe());
            ps.setDate(8, u.getDate_embauche());
            ps.setDate(9, u.getDate_retrait());
            ps.setBoolean(10, u.isActif());
            ps.executeUpdate();
        }
    }

    public static void mettreAjour(Utilisateur u) throws Exception {
        String sql = "UPDATE utilisateur SET id_role=?, nom=?, prenom=?, telephone=?, email=?, identifiant=?, mot_de_passe=?, date_embauche=?, date_retrait=?, actif=? WHERE id_utilisateur=?";
        try (Connection c = new Database().dbconnect(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, u.getId_role());
            ps.setString(2, u.getNom());
            ps.setString(3, u.getPrenom());
            ps.setString(4, u.getTelephone());
            ps.setString(5, u.getEmail());
            ps.setString(6, u.getIdentifiant());
            ps.setString(7, u.getMot_de_passe());
            ps.setDate(8, u.getDate_embauche());
            ps.setDate(9, u.getDate_retrait());
            ps.setBoolean(10, u.isActif());
            ps.setInt(11, u.getId_utilisateur());
            ps.executeUpdate();
        }
    }
}