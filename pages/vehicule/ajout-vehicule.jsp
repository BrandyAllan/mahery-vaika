<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="backoffice.Utilisateur" %>
<%
    Utilisateur userObj = (Utilisateur) session.getAttribute("utilisateur");
    if (userObj == null || !"Admin".equalsIgnoreCase(userObj.voirsiadmin())) {
        response.sendRedirect("model.jsp?page=vehicule/liste-vehicule");
        return;
    }
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <a href="?page=vehicule/liste-vehicule" class="btn btn-sm btn-light text-muted border-0 shadow-sm mb-2 hover-shadow">
            <i class="bi bi-arrow-left"></i> Retour à la liste
        </a>
        <h2 class="fw-bold mb-0" style="color: #2c3e50;">
            <i class="bi bi-plus-circle text-primary me-2"></i> Enregistrer un nouveau véhicule
        </h2>
    </div>
</div>

<div class="row justify-content-center">
    <div class="col-md-8">
        <form action="../traitement/vehicule/ajouter-vehicule.jsp" method="POST">
            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-body p-5">
                    <h5 class="card-title text-primary fw-bold mb-4"><i class="bi bi-car-front-fill me-2"></i>Informations générales</h5>
                    
                    <div class="row g-4 mb-4">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Immatriculation <span class="text-danger">*</span></label>
                            <input type="text" name="immatriculation" class="form-control form-control-lg bg-light border-0" required placeholder="Ex: 1234 TAB">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Marque <span class="text-danger">*</span></label>
                            <select name="marque" id="marque" class="form-select form-select-lg bg-light border-0" required>
                                <option value="">-- Sélectionner une marque --</option>
                                <option value="toyota">Toyota</option>
                                <option value="Mercedes">Mercedes</option>
                                <option value="Mazda">Mazda</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-body p-5">
                    <h5 class="card-title text-primary fw-bold mb-4"><i class="bi bi-clipboard-data-fill me-2"></i>Détails techniques et administratifs</h5>
                    
                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Modèle (Écrire manuellement) <span class="text-danger">*</span></label>
                            <input type="text" name="modele" class="form-control form-control-lg bg-light border-0" required placeholder="Ex: Hilux, Sprinter, CX-5...">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Capacité (Nombre de places) <span class="text-danger">*</span></label>
                            <input type="number" name="capacite" class="form-control form-control-lg bg-light border-0" min="1" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Kilométrage initial</label>
                            <input type="number" name="kilometrage" class="form-control form-control-lg bg-light border-0" value="0" min="0">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Date Expiration Assurance <span class="text-danger">*</span></label>
                            <input type="date" name="dateAssurance" class="form-control form-control-lg bg-light border-0" required>
                        </div>
                    </div>
                </div>
            </div>

            <div class="d-flex justify-content-between mt-4">
                <a href="?page=vehicule/liste-vehicule" class="btn btn-light btn-lg px-4 text-secondary shadow-sm hover-shadow">Annuler</a>
                <button type="submit" class="btn btn-primary btn-lg px-4 shadow-sm hover-shadow"><i class="bi bi-check-circle me-2"></i>Enregistrer le véhicule</button>
            </div>
        </form>
    </div>
</div>