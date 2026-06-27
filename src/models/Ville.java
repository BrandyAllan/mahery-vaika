package models;

public class Ville {
    private int idVille;
    private String nomVille;
    private String province;
    private boolean actif;

    public Ville() {
    }

    public Ville(int idVille, String nomVille, String province, boolean actif) {
        this.idVille = idVille;
        this.nomVille = nomVille;
        this.province = province;
        this.actif = actif;
    }

    public int getIdVille() {
        return idVille;
    }

    public void setIdVille(int idVille) {
        this.idVille = idVille;
    }

    public String getNomVille() {
        return nomVille;
    }

    public void setNomVille(String nomVille) {
        this.nomVille = nomVille;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public boolean isActif() {
        return actif;
    }

    public void setActif(boolean actif) {
        this.actif = actif;
    }
}
