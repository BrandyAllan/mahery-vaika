<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="backoffice.Utilisateur" %>
<%@ page import="gestion.Chauffeur" %>
<%@ page import="gestion.Vehicule" %>
<%@ page import="java.util.Vector" %>
<%
    Utilisateur userObj = (Utilisateur) session.getAttribute("utilisateur");
    if (userObj == null) {
        response.sendRedirect("../../index.jsp");
        return;
    }
    if (!"Admin".equalsIgnoreCase(userObj.voirsiadmin())) {
        response.sendRedirect("?page=chauffeurs/gestion-chauffeur");
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
        <a href="?page=chauffeurs/liste-chauffeur" class="btn btn-sm btn-light text-muted border-0 shadow-sm mb-2 hover-shadow">
            <i class="bi bi-arrow-left"></i> Retour à la liste
        </a>
        <h2 class="fw-bold mb-0" style="color: #2c3e50;">
            <i class="bi bi-person-plus text-primary me-2"></i> Ajouter un Chauffeur
        </h2>
    </div>
</div>

<% if (erreur != null) { %>
<div class="alert alert-danger border-0 shadow-sm"><i class="bi bi-exclamation-triangle-fill me-2"></i><%= erreur %></div>
<% } %>
<% if (succes != null) { %>
<div class="alert alert-success border-0 shadow-sm"><i class="bi bi-check-circle-fill me-2"></i><%= succes %></div>
<% } %>

<div class="card border-0 shadow-sm rounded-4">
    <div class="card-body p-5">
        <form method="POST" action="../../traitement/chauffeurs/ajouter-chauffeur.jsp">
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

            <div class="mt-5 d-flex gap-3">
                <button type="submit" class="btn btn-success btn-lg px-4 shadow-sm hover-shadow">
                    <i class="bi bi-check-lg me-2"></i> Enregistrer le chauffeur
                </button>
                <a href="?page=chauffeurs/liste-chauffeur" class="btn btn-light btn-lg px-4 text-secondary shadow-sm hover-shadow">Annuler</a>
            </div>
        </form>
    </div>
</div>