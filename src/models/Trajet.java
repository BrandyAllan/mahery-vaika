package models;

import java.math.BigDecimal;

public class Trajet {
    private int idTrajet;
    private Ville villeDepart;
    private Ville villeArrivee;
    private BigDecimal distanceKm;
    private String dureeEstimee;
    private BigDecimal tarifBase;
    private boolean actif;

    public Trajet() {
    }

    public Trajet(int idTrajet, Ville villeDepart, Ville villeArrivee, BigDecimal distanceKm, String dureeEstimee, BigDecimal tarifBase, boolean actif) {
        this.idTrajet = idTrajet;
        this.villeDepart = villeDepart;
        this.villeArrivee = villeArrivee;
        this.distanceKm = distanceKm;
        this.dureeEstimee = dureeEstimee;
        this.tarifBase = tarifBase;
        this.actif = actif;
    }

    public int getIdTrajet() {
        return idTrajet;
    }

    public void setIdTrajet(int idTrajet) {
        this.idTrajet = idTrajet;
    }

    public Ville getVilleDepart() {
        return villeDepart;
    }

    public void setVilleDepart(Ville villeDepart) {
        this.villeDepart = villeDepart;
    }

    public Ville getVilleArrivee() {
        return villeArrivee;
    }

    public void setVilleArrivee(Ville villeArrivee) {
        this.villeArrivee = villeArrivee;
    }

    public BigDecimal getDistanceKm() {
        return distanceKm;
    }

    public void setDistanceKm(BigDecimal distanceKm) {
        this.distanceKm = distanceKm;
    }

    public String getDureeEstimee() {
        return dureeEstimee;
    }

    public void setDureeEstimee(String dureeEstimee) {
        this.dureeEstimee = dureeEstimee;
    }

    public BigDecimal getTarifBase() {
        return tarifBase;
    }

    public void setTarifBase(BigDecimal tarifBase) {
        this.tarifBase = tarifBase;
    }

    public boolean isActif() {
        return actif;
    }

    public void setActif(boolean actif) {
        this.actif = actif;
    }
}
