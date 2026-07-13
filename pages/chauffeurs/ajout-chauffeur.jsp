<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="backoffice.Utilisateur" %>
<%@ page import="gestion.Chauffeur" %>
<%@ page import="gestion.Vehicule" %>
<%@ page import="java.util.Vector" %>
<%
    Utilisateur userObj = (Utilisateur) session.getAttribute("utilisateur");
    if (userObj == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    if (!"Admin".equalsIgnoreCase(userObj.voirsiadmin())) {
%>
    <div class="container mt-5">
        <div class="alert alert-danger text-center border-0 shadow-sm rounded-4">
            <i class="bi bi-lock-fill me-2"></i> Accès refusé. Vous devez être administrateur pour ajouter un chauffeur.
        </div>
    </div>
<%
        return;
    }

    Vector vehicules = Chauffeur.getVehiculesDispo();
    String erreur  = (String) session.getAttribute("erreur");
    String succes  = (String) session.getAttribute("succes");
    session.removeAttribute("erreur");
    session.removeAttribute("succes");
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <a href="?page=chauffeurs/gestion-chauffeur" class="btn btn-sm btn-light text-muted border-0 shadow-sm mb-2 hover-shadow">
            <i class="bi bi-arrow-left"></i> Retour
        </a>
        <h2 class="fw-bold mb-0" style="color: #2c3e50;">
            <i class="bi bi-plus-circle text-primary me-2"></i> Créer un nouveau chauffeur
        </h2>
    </div>
</div>

<div class="row justify-content-center">
    <div class="col-md-8">
        <% if (erreur != null) { %>
            <div class="alert alert-danger border-0 shadow-sm rounded-4 d-flex align-items-center mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i><%= erreur %>
            </div>
        <% } %>
        <% if (succes != null) { %>
            <div class="alert alert-success border-0 shadow-sm rounded-4 d-flex align-items-center mb-4" role="alert">
                <i class="bi bi-check-circle-fill me-2 fs-5"></i><%= succes %>
            </div>
        <% } %>

        <form method="POST" action="../traitement/chauffeurs/ajouter-chauffeur.jsp">
            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-body p-5">
                    <h5 class="card-title text-primary fw-bold mb-4"><i class="bi bi-person-lines-fill me-2"></i>Informations personnelles</h5>

                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Nom <span class="text-danger">*</span></label>
                            <input type="text" name="nom" class="form-control form-control-lg bg-light border-0" required placeholder="Ex: RAKOTO">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Prénom</label>
                            <input type="text" name="prenom" class="form-control form-control-lg bg-light border-0" placeholder="Ex: Jean">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Téléphone</label>
                            <input type="text" name="telephone" class="form-control form-control-lg bg-light border-0" placeholder="Ex: +261 34 00 000 00">
                        </div>
                    </div>
                </div>
            </div>

            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-body p-5">
                    <h5 class="card-title text-primary fw-bold mb-4"><i class="bi bi-card-checklist me-2"></i>Permis et affectation</h5>

                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">N° Permis <span class="text-danger">*</span></label>
                            <input type="text" name="numeroPermis" class="form-control form-control-lg bg-light border-0" required placeholder="Numéro de permis">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Date d'expiration du permis</label>
                            <input type="date" name="dateExpirationPermis" class="form-control form-control-lg bg-light border-0">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Véhicule habituel</label>
                            <select name="idVehiculeHabituel" class="form-select form-select-lg bg-light border-0">
                                <option value="">— Aucun —</option>
                                <%
                                for (int i = 0; i < vehicules.size(); i++) {
                                    Vehicule v = (Vehicule) vehicules.get(i);
                                %>
                                <option value="<%= v.getIdVehicule() %>">
                                    <%= v.getImmatriculation() %> — <%= v.getMarque() %> <%= v.getModele() %>
                                </option>
                                <% } %>
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            <div class="d-flex justify-content-between mt-4">
                <a href="?page=chauffeurs/liste-chauffeur" class="btn btn-light btn-lg px-4 text-secondary shadow-sm hover-shadow">Annuler</a>
                <button type="submit" class="btn btn-primary btn-lg px-4 shadow-sm hover-shadow">
                    <i class="bi bi-save me-2"></i>Enregistrer le chauffeur
                </button>
            </div>
        </form>
    </div>
</div>
