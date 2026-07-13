<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="backoffice.Utilisateur" %>
<%@ page import="gestion.Chauffeur" %>
<%
    Utilisateur userObj = (Utilisateur) session.getAttribute("utilisateur");
    if (userObj == null) {
        response.sendRedirect("../../index.jsp");
        return;
    }
    boolean isAdmin = "Admin".equalsIgnoreCase(userObj.voirsiadmin());

    int id = 0;
    try { id = Integer.parseInt(request.getParameter("id")); } catch (Exception e) {}
    Chauffeur ch = Chauffeur.getById(id);
    if (ch == null) {
        response.sendRedirect("?page=chauffeurs/liste-chauffeur");
        return;
    }

    String sp = ch.getStatutPermis();
    String spLabel = "VALIDE".equals(sp) ? "Valide"
                   : "EXPIRE".equals(sp) ? "Expiré"
                   : "BIENTOT_EXPIRE".equals(sp) ? "Bientôt expiré"
                   : "Inconnu";
    String spBadge = "VALIDE".equals(sp) ? "bg-success"
                   : "EXPIRE".equals(sp) ? "bg-danger"
                   : "BIENTOT_EXPIRE".equals(sp) ? "bg-warning text-dark"
                   : "bg-secondary";

    String succes = (String) session.getAttribute("succes");
    session.removeAttribute("succes");
%>

<%-- En-tête de page --%>
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <a href="?page=chauffeurs/liste-chauffeur"
           class="btn btn-sm btn-light text-muted border-0 shadow-sm mb-2 hover-shadow">
            <i class="bi bi-arrow-left"></i> Retour à la liste
        </a>
        <h2 class="fw-bold mb-0" style="color: #2c3e50;">
            <i class="bi bi-person-badge text-primary me-2"></i>
            <%= ch.getNomComplet() %>
            <span class="badge <%= ch.isActif() ? "bg-success" : "bg-danger" %> fs-6 ms-2 rounded-pill">
                <%= ch.isActif() ? "Actif" : "Inactif" %>
            </span>
        </h2>
    </div>
    <% if (isAdmin) { %>
    <div class="d-flex gap-2">
        <a href="?page=chauffeurs/modifier-chauffeur&id=<%= id %>"
           class="btn btn-outline-primary shadow-sm">
            <i class="bi bi-pencil me-1"></i> Modifier
        </a>
        <a href="../traitement/chauffeurs/modifier-chauffeur.jsp?id=<%= id %>&actif=<%= !ch.isActif() %>"
           class="btn <%= ch.isActif() ? "btn-outline-danger" : "btn-outline-success" %> shadow-sm"
           onclick="return confirm('Confirmer la <%= ch.isActif() ? "désactivation" : "réactivation" %> ?')">
            <i class="bi <%= ch.isActif() ? "bi-person-x" : "bi-person-check" %>"></i>
            <%= ch.isActif() ? "Désactiver" : "Réactiver" %>
        </a>
    </div>
    <% } %>
</div>

<% if (succes != null) { %>
<div class="alert alert-success border-0 shadow-sm rounded-4 d-flex align-items-center mb-4" role="alert">
    <i class="bi bi-check-circle-fill me-2 fs-5"></i><%= succes %>
</div>
<% } %>

<div class="row g-4">

    <%-- Carte Informations personnelles --%>
    <div class="col-lg-6">
        <div class="card border-0 shadow-sm rounded-4 h-100">
            <div class="card-body p-4">
                <h5 class="card-title text-primary fw-bold mb-4">
                    <i class="bi bi-person-lines-fill me-2"></i>Informations personnelles
                </h5>
                <div class="row g-3">
                    <div class="col-6">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Nom</p>
                        <p class="fw-bold mb-0"><%= ch.getNom() %></p>
                    </div>
                    <div class="col-6">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Prénom</p>
                        <p class="fw-semibold mb-0"><%= ch.getPrenom() != null ? ch.getPrenom() : "—" %></p>
                    </div>
                    <div class="col-12">
                        <hr class="my-2 opacity-25">
                    </div>
                    <div class="col-6">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Téléphone</p>
                        <p class="fw-semibold mb-0">
                            <% if (ch.getTelephone() != null) { %>
                                <i class="bi bi-telephone-fill text-primary me-1"></i><%= ch.getTelephone() %>
                            <% } else { %>
                                <span class="text-muted">—</span>
                            <% } %>
                        </p>
                    </div>
                    <div class="col-6">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Statut</p>
                        <span class="badge <%= ch.isActif() ? "bg-success" : "bg-danger" %> rounded-pill px-3 py-2">
                            <%= ch.isActif() ? "Actif" : "Inactif" %>
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- Carte Permis --%>
    <div class="col-lg-6">
        <div class="card border-0 shadow-sm rounded-4 h-100">
            <div class="card-body p-4">
                <h5 class="card-title text-primary fw-bold mb-4">
                    <i class="bi bi-card-checklist me-2"></i>Permis de conduire
                </h5>
                <div class="row g-3">
                    <div class="col-12">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">N° Permis</p>
                        <p class="fw-bold mb-0 font-monospace fs-5"><%= ch.getNumeroPermis() %></p>
                    </div>
                    <div class="col-12">
                        <hr class="my-2 opacity-25">
                    </div>
                    <div class="col-6">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Date d'expiration</p>
                        <p class="fw-semibold mb-0">
                            <%= ch.getDateExpirationPermis() != null ? ch.getDateExpirationPermis() : "—" %>
                        </p>
                    </div>
                    <div class="col-6">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Statut permis</p>
                        <span class="badge <%= spBadge %> rounded-pill px-3 py-2"><%= spLabel %></span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- Carte Véhicule affecté --%>
    <div class="col-12">
        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-body p-4">
                <h5 class="card-title text-primary fw-bold mb-4">
                    <i class="bi bi-car-front-fill me-2"></i>Véhicule habituel
                </h5>
                <% if (ch.getImmatriculationVehicule() != null) { %>
                <div class="d-flex align-items-center gap-4 flex-wrap">
                    <div>
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Immatriculation</p>
                        <span class="badge bg-light text-dark border fs-6 px-3 py-2">
                            <i class="bi bi-car-front me-1"></i><%= ch.getImmatriculationVehicule() %>
                        </span>
                    </div>
                    <div>
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Marque / Modèle</p>
                        <p class="fw-semibold mb-0 fs-5"><%= ch.getMarqueModeleVehicule() %></p>
                    </div>
                </div>
                <% } else { %>
                <div class="text-center text-muted py-3">
                    <i class="bi bi-car-front d-block fs-1 opacity-25 mb-2"></i>
                    Aucun véhicule affecté
                </div>
                <% } %>
            </div>
        </div>
    </div>

</div>

<%-- Bouton historique --%>
<div class="mt-4 d-flex justify-content-end">
    <a href="?page=chauffeurs/historique-chauffeur&id=<%= id %>"
       class="btn btn-outline-primary shadow-sm">
        <i class="bi bi-clock-history me-1"></i> Voir l'historique des trajets
    </a>
</div>
