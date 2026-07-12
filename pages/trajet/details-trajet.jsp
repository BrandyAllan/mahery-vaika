<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="gestion.Trajet" %>
<%@ page import="backoffice.Utilisateur" %>
<%
    Utilisateur userObj = (Utilisateur) session.getAttribute("utilisateur");
    if (userObj == null) {
        response.sendRedirect("../../index.jsp");
        return;
    }
    boolean isAdmin = "Admin".equalsIgnoreCase(userObj.voirsiadmin());

    String idStr = request.getParameter("id");
    if (idStr == null || idStr.isEmpty()) {
%>
<div class="alert alert-warning border-0 shadow-sm rounded-4 d-flex align-items-center" role="alert">
    <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i> Identifiant du trajet manquant.
</div>
<%
        return;
    }

    Trajet trajetGestion = new Trajet();
    Trajet trajet = trajetGestion.getTrajetById(Integer.parseInt(idStr));

    if (trajet == null) {
%>
<div class="alert alert-danger border-0 shadow-sm rounded-4 d-flex align-items-center" role="alert">
    <i class="bi bi-exclamation-circle-fill me-2 fs-5"></i> Le trajet #<%= idStr %> n'existe pas.
</div>
<%
        return;
    }
%>

<%-- En-tête de page --%>
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <a href="?page=trajet/liste-trajet"
           class="btn btn-sm btn-light text-muted border-0 shadow-sm mb-2 hover-shadow">
            <i class="bi bi-arrow-left"></i> Retour à la liste
        </a>
        <h2 class="fw-bold mb-0" style="color: #2c3e50;">
            <i class="bi bi-signpost-2-fill text-primary me-2"></i>
            Trajet #<%= trajet.getIdTrajet() %>
            <% if (trajet.isActif()) { %>
                <span class="badge bg-success fs-6 ms-2 rounded-pill">Actif</span>
            <% } else { %>
                <span class="badge bg-secondary fs-6 ms-2 rounded-pill">Inactif</span>
            <% } %>
        </h2>
    </div>
    <% if (isAdmin) { %>
    <div class="d-flex gap-2">
        <a href="?page=trajet/modifier-trajet&id=<%= trajet.getIdTrajet() %>"
           class="btn btn-outline-primary shadow-sm">
            <i class="bi bi-pencil me-1"></i> Modifier
        </a>
        <% if (trajet.isActif()) { %>
        <a href="../traitement/trajet/supprimer-trajet.jsp?id=<%= trajet.getIdTrajet() %>&action=desactiver"
           class="btn btn-outline-danger shadow-sm"
           onclick="return confirm('Désactiver ce trajet ?');">
            <i class="bi bi-ban me-1"></i> Désactiver
        </a>
        <% } %>
    </div>
    <% } %>
</div>

<%-- Route --%>
<div class="card border-0 shadow-sm rounded-4 mb-4">
    <div class="card-body p-4">
        <h5 class="card-title text-primary fw-bold mb-4">
            <i class="bi bi-map-fill me-2"></i>Itinéraire
        </h5>
        <div class="row align-items-center text-center">
            <div class="col-5">
                <p class="text-muted small fw-semibold text-uppercase mb-1" style="font-size:.72rem;">Départ</p>
                <h3 class="fw-bold text-danger mb-0">
                    <i class="bi bi-geo-alt-fill me-1"></i><%= trajet.getVilleDepart().getNomVille() %>
                </h3>
            </div>
            <div class="col-2 d-flex align-items-center justify-content-center">
                <i class="bi bi-arrow-right fs-2 text-muted"></i>
            </div>
            <div class="col-5">
                <p class="text-muted small fw-semibold text-uppercase mb-1" style="font-size:.72rem;">Arrivée</p>
                <h3 class="fw-bold text-success mb-0">
                    <i class="bi bi-flag-fill me-1"></i><%= trajet.getVilleArrivee().getNomVille() %>
                </h3>
            </div>
        </div>
    </div>
</div>

<%-- Statistiques --%>
<div class="row g-4 mb-4">
    <div class="col-md-4">
        <div class="card border-0 shadow-sm rounded-4 text-center h-100">
            <div class="card-body p-4">
                <i class="bi bi-signpost-2 fs-2 text-primary mb-2 d-block"></i>
                <p class="text-muted small fw-semibold text-uppercase mb-1" style="font-size:.72rem;">Distance</p>
                <h4 class="fw-bold mb-0">
                    <%= trajet.getDistanceKm() != null ? trajet.getDistanceKm() : "—" %>
                    <span class="text-muted fw-normal fs-6">km</span>
                </h4>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card border-0 shadow-sm rounded-4 text-center h-100">
            <div class="card-body p-4">
                <i class="bi bi-clock fs-2 text-info mb-2 d-block"></i>
                <p class="text-muted small fw-semibold text-uppercase mb-1" style="font-size:.72rem;">Durée estimée</p>
                <h4 class="fw-bold mb-0">
                    <%= trajet.getDureeEstimee() != null ? trajet.getDureeEstimee() : "—" %>
                </h4>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card border-0 shadow-sm rounded-4 text-center h-100">
            <div class="card-body p-4">
                <i class="bi bi-cash-coin fs-2 text-success mb-2 d-block"></i>
                <p class="text-muted small fw-semibold text-uppercase mb-1" style="font-size:.72rem;">Tarif de base</p>
                <h4 class="fw-bold text-success mb-0">
                    <%= trajet.getTarifBase() %> <span class="text-muted fw-normal fs-6">Ar</span>
                </h4>
            </div>
        </div>
    </div>
</div>

<% if (!isAdmin) { %>
<div class="alert alert-info border-0 shadow-sm rounded-4 d-flex align-items-center" role="alert">
    <i class="bi bi-info-circle-fill me-2 fs-5"></i>
    Seul un administrateur peut modifier ou désactiver un trajet.
</div>
<% } %>
