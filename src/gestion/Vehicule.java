package gestion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import tools.Database;
import java.util.*;


public class Vehicule {
   
    private int idVehicule;
    private String immatriculation;
    private String marque;
    private String modele;
    private int capacite;
    private int kilometrageActuel;
    private String etat;
    private Date dateExpirationAssurance;

  
    public Vehicule() {}

  
    public int getIdVehicule() { return idVehicule; }
    public void setIdVehicule(int idVehicule) { this.idVehicule = idVehicule; }

    public String getImmatriculation() { return immatriculation; }
    public void setImmatriculation(String immatriculation) { this.immatriculation = immatriculation; }

    public String getMarque() { return marque; }
    public void setMarque(String marque) { this.marque = marque; }

    public String getModele() { return modele; }
    public void setModele(String modele) { this.modele = modele; }

    public int getCapacite() { return capacite; }
    public void setCapacite(int capacite) { this.capacite = capacite; }

    public int getKilometrageActuel() { return kilometrageActuel; }
    public void setKilometrageActuel(int kilometrageActuel) { this.kilometrageActuel = kilometrageActuel; }

    public String getEtat() { return etat; }
    public void setEtat(String etat) { this.etat = etat; }

    public Date getDateExpirationAssurance() { return dateExpirationAssurance; }
    public void setDateExpirationAssurance(Date dateExpirationAssurance) { this.dateExpirationAssurance = dateExpirationAssurance; }



    public static boolean ajouterVehicule(String immatriculation, String marque, String modele, int capacite, int kilometrage, Date dateAssurance) {
        String sql = "INSERT INTO vehicule (immatriculation, marque, modele, capacite, kilometrage_actuel, etat, date_expiration_assurance) VALUES (?, ?, ?, ?, ?, 'ACTIF', ?)";
        
        try (Connection conn = Database.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, immatriculation);
            ps.setString(2, marque);
            ps.setString(3, modele);
            ps.setInt(4, capacite);
            ps.setInt(5, kilometrage);
            ps.setDate(6, dateAssurance);
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean modifierEtatEtAssurance(int idVehicule, String nouvelEtat, Date nouvelleDate) {
        String sql = "UPDATE vehicule SET etat = ?, date_expiration_assurance = ? WHERE id_vehicule = ?";
        
        try (Connection conn = Database.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nouvelEtat);
            ps.setDate(2, nouvelleDate);
            ps.setInt(3, idVehicule);
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


  
    public static boolean supprimerVehicule(int idVehicule) {
        String sql = "DELETE FROM vehicule WHERE id_vehicule = ?";
        
        try (Connection conn = Database.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idVehicule);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }



    public static Vehicule getVehiculeById(int id) {
        String sql = "SELECT * FROM vehicule WHERE id_vehicule = ?";
        
        try (Connection conn = Database.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Vehicule v = new Vehicule();
                    v.setIdVehicule(rs.getInt("id_vehicule"));
                    v.setImmatriculation(rs.getString("immatriculation"));
                    v.setMarque(rs.getString("marque"));
                    v.setModele(rs.getString("modele"));
                    v.setCapacite(rs.getInt("capacite"));
                    v.setKilometrageActuel(rs.getInt("kilometrage_actuel"));
                    v.setEtat(rs.getString("etat"));
                    v.setDateExpirationAssurance(rs.getDate("date_expiration_assurance"));
                    return v;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


  
    public static List<Vehicule> rechercherGlobalEtDate(String global, java.sql.Date debut, java.sql.Date fin, int limit, int offset) {
    List<Vehicule> liste = new java.util.ArrayList<>();
    String sql = "SELECT * FROM vehicule WHERE 1=1";
    
    if (global != null && !global.trim().isEmpty()) {
        sql += " AND (immatriculation ILIKE ? OR marque ILIKE ? OR modele ILIKE ? OR etat ILIKE ?)";
    }
    if (debut != null) sql += " AND date_expiration_assurance >= ?";
    if (fin != null) sql += " AND date_expiration_assurance <= ?";
    sql += " LIMIT ? OFFSET ?";

    try (Connection conn = Database.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
        
        int idx = 1;
        if (global != null && !global.trim().isEmpty()) {
            String p = "%" + global.trim() + "%";
            ps.setString(idx++, p); ps.setString(idx++, p);
            ps.setString(idx++, p); ps.setString(idx++, p);
        }
        if (debut != null) ps.setDate(idx++, debut);
        if (fin != null) ps.setDate(idx++, fin);
        ps.setInt(idx++, limit);
        ps.setInt(idx++, offset);

        java.sql.ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Vehicule v = new Vehicule();
            v.setIdVehicule(rs.getInt("id_vehicule"));
            v.setImmatriculation(rs.getString("immatriculation"));
            v.setMarque(rs.getString("marque"));
            v.setModele(rs.getString("modele"));
            v.setCapacite(rs.getInt("capacite"));
            v.setKilometrageActuel(rs.getInt("kilometrage_actuel"));
            v.setEtat(rs.getString("etat"));
            v.setDateExpirationAssurance(rs.getDate("date_expiration_assurance"));
            liste.add(v);
        }
    } catch (Exception e) { e.printStackTrace(); }
    return liste;
}

    public static boolean modifierVehicule(int idVehicule, String etat, java.sql.Date dateAssurance) {
    boolean succes = false;
    String sql = "UPDATE vehicule SET etat = ?, date_expiration_assurance = ? WHERE id_vehicule = ?";
    
  
    try (Connection conn = Database.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
        
        ps.setString(1, etat);
        ps.setDate(2, dateAssurance);
        ps.setInt(3, idVehicule);
        
        int rowsAffected = ps.executeUpdate();
        if (rowsAffected > 0) {
            succes = true;
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return succes;
}


   
    public static int compterGlobalEtDate(String global, java.sql.Date debut, java.sql.Date fin) {
        int total = 0;
        String sql = "SELECT COUNT(*) FROM vehicule WHERE 1=1";
        if (global != null && !global.trim().isEmpty()) {
            sql += " AND (immatriculation ILIKE ? OR marque ILIKE ? OR modele ILIKE ? OR etat ILIKE ?)";
        }
        if (debut != null) sql += " AND date_expiration_assurance >= ?";
        if (fin != null) sql += " AND date_expiration_assurance <= ?";

        try (Connection conn = Database.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            if (global != null && !global.trim().isEmpty()) {
                String p = "%" + global.trim() + "%";
                ps.setString(idx++, p); ps.setString(idx++, p);
                ps.setString(idx++, p); ps.setString(idx++, p);
            }
            if (debut != null) ps.setDate(idx++, debut);
            if (fin != null) ps.setDate(idx++, fin);
            java.sql.ResultSet rs = ps.executeQuery();
            if (rs.next()) total = rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return total;
    }
}
