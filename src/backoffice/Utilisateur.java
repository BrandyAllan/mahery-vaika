package backoffice;
import java.sql.*;
import java.util.ArrayList;
import tools.Database;


package backoffice;

import java.sql.Date;
import java.sql.Timestamp;

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
}