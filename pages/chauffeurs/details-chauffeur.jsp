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
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Détails Chauffeur — <%= ch.getNomComplet() %></title>
    <link rel="stylesheet" href="../../assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="../../assets/bootstrap/icons/bootstrap-icons.min.css">
</head>
<body class="bg-light">
<div class="container mt-4" style="max-width: 800px;">

    <a href="?page=chauffeurs/liste-chauffeur" class="btn btn-sm btn-secondary mb-3">
        <i class="bi bi-arrow-left"></i> Retour à la liste
    </a>

    <% if (succes != null) { %>
    <div class="alert alert-success"><%= succes %></div>
    <% } %>

    <div class="card shadow-sm mb-4">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h4 class="mb-0">
                <i class="bi bi-person-badge me-2"></i><%= ch.getNomComplet() %>
                <span class="badge <%= ch.isActif() ? "bg-success" : "bg-danger" %> ms-2 fs-6">
                    <%= ch.isActif() ? "Actif" : "Inactif" %>
                </span>
            </h4>
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-6">
                    <p class="mb-1 text-muted small">Nom</p>
                    <p class="fw-semibold"><%= ch.getNom() %></p>
                </div>
                <div class="col-md-6">
                    <p class="mb-1 text-muted small">Prénom</p>
                    <p class="fw-semibold"><%= ch.getPrenom() != null ? ch.getPrenom() : "-" %></p>
                </div>
                <div class="col-md-6">
                    <p class="mb-1 text-muted small">Téléphone</p>
                    <p class="fw-semibold"><%= ch.getTelephone() != null ? ch.getTelephone() : "-" %></p>
                </div>
                <div class="col-md-6">
                    <p class="mb-1 text-muted small">N° Permis</p>
                    <p class="fw-semibold"><%= ch.getNumeroPermis() %></p>
                </div>
                <div class="col-md-6">
                    <p class="mb-1 text-muted small">Date d'expiration du permis</p>
                    <p class="fw-semibold">
                        <%= ch.getDateExpirationPermis() != null ? ch.getDateExpirationPermis() : "-" %>
                        <span class="badge <%= spBadge %> ms-1"><%= spLabel %></span>
                    </p>
                </div>
                <div class="col-md-6">
                    <p class="mb-1 text-muted small">Véhicule habituel</p>
                    <p class="fw-semibold">
                        <% if (ch.getImmatriculationVehicule() != null) { %>
                            <i class="bi bi-car-front me-1"></i>
                            <%= ch.getImmatriculationVehicule() %> — <%= ch.getMarqueModeleVehicule() %>
                        <% } else { %>
                            <span class="text-muted">Aucun</span>
                        <% } %>
                    </p>
                </div>
            </div>
        </div>
        <div class="card-footer d-flex gap-2">
            <% if (isAdmin) { %>
            <a href="modifier-chauffeur.jsp?id=<%= id %>" class="btn" style="background-color: #0127ff; color: #e0e0e0;">
                <i class="bi bi-pencil"></i> Modifier
            </a>
            <a href="../../traitement/chauffeurs/modifier-chauffeur.jsp?id=<%= id %>&actif=<%= !ch.isActif() %>"
               class="btn <%= ch.isActif() ? "btn-danger" : "btn-success" %>"
               onclick="return confirm('Confirmer la <%= ch.isActif() ? "désactivation" : "réactivation" %> ?')">
                <i class="bi <%= ch.isActif() ? "bi-person-x" : "bi-person-check" %>"></i>
                <%= ch.isActif() ? "Désactiver" : "Réactiver" %>
            </a>
            <% } else { %>
            <button class="btn btn-warning" disabled title="Réservé aux administrateurs">
                <i class="bi bi-pencil"></i> Modifier
            </button>
            <button class="btn btn-danger" disabled title="Réservé aux administrateurs">
                <i class="bi bi-person-x"></i> Désactiver
            </button>
            <% } %>
            <a href="?page=chauffeurs/historique-chauffeur&id=<%= id %>" class="btn btn-outline-primary ms-auto">
                <i class="bi bi-clock-history"></i> Voir l'historique des trajets
            </a>
        </div>
    </div>

</div>
<script src="../../assets/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
