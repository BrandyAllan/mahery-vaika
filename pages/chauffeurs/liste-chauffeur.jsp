<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="backoffice.Utilisateur" %>
<%@ page import="gestion.Chauffeur" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.Vector" %>
<%
    Utilisateur userObj = (Utilisateur) session.getAttribute("utilisateur");
    if (userObj == null) {
        response.sendRedirect("../../index.jsp");
        return;
    }
    boolean isAdmin = "Admin".equalsIgnoreCase(userObj.voirsiadmin());

    String nom          = request.getParameter("nom");
    String vehicule     = request.getParameter("vehicule");
    String statutParam  = request.getParameter("statut");
    String statutPermis = request.getParameter("statutPermis");
    String dateDebutStr = request.getParameter("datePermisDebut");
    String dateFinStr   = request.getParameter("datePermisFin");

    Boolean statut = null;
    if (statutParam != null && !statutParam.isEmpty()) statut = Boolean.parseBoolean(statutParam);

    Date datePermisDebut = null;
    Date datePermisFin   = null;
    try { if (dateDebutStr != null && !dateDebutStr.isEmpty()) datePermisDebut = Date.valueOf(dateDebutStr); } catch (Exception e) {}
    try { if (dateFinStr   != null && !dateFinStr.isEmpty())   datePermisFin   = Date.valueOf(dateFinStr);   } catch (Exception e) {}

    int limit = 10;
    int pageCourante = 1;
    try { pageCourante = Integer.parseInt(request.getParameter("pageNum")); } catch (Exception e) {}
    int offset = (pageCourante - 1) * limit;

    Vector listeChauffeurs = Chauffeur.rechercher(nom, vehicule, statut, statutPermis, datePermisDebut, datePermisFin, limit, offset);
    int total    = Chauffeur.count(nom, vehicule, statut, statutPermis, datePermisDebut, datePermisFin);
    int nbPages  = (int) Math.ceil((double) total / limit);
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Liste des Chauffeurs</title>
    <link rel="stylesheet" href="../../assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="../../assets/bootstrap/icons/bootstrap-icons.min.css">
    <style>
        .table tbody tr { cursor: pointer; }
        .badge-VALIDE         { background-color: #000000; }
        .badge-EXPIRE         { background-color: #000000; }
        .badge-BIENTOT_EXPIRE { background-color: #000000; color: #ffffff; }
        .badge-INCONNU        { background-color: #6c757d; }
    </style>
</head>
<body class="bg-light">
<div class="container mt-4">

    <a href="?page=chauffeurs/gestion-chauffeur" class="btn btn-sm btn-secondary mb-3">
        <i class="bi bi-arrow-left"></i> Retour
    </a>
    <h2 class="mb-3"><i class="bi bi-person-badge"></i> Liste des Chauffeurs</h2>

    <div class="card shadow-sm mb-4">
        <div class="card-body">
            <form method="GET">
                <input type="hidden" name="page" value="chauffeurs/liste-chauffeur">
                <input type="hidden" name="pageNum" value="1">
                <div class="row g-3 align-items-end">
                    <div class="col-md-3">
                        <label class="form-label">Nom / Prenom</label>
                        <input type="text" name="nom" class="form-control" placeholder="Recherche..." value="<%= nom != null ? nom : "" %>">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Vehicule</label>
                        <input type="text" name="vehicule" class="form-control" placeholder="Immatriculation, marque..." value="<%= vehicule != null ? vehicule : "" %>">
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Statut</label>
                        <select name="statut" class="form-select">
                            <option value="">Tous</option>
                            <option value="true"  <%= "true".equals(statutParam)  ? "selected" : "" %>>Actif</option>
                            <option value="false" <%= "false".equals(statutParam) ? "selected" : "" %>>Inactif</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Permis</label>
                        <select name="statutPermis" class="form-select">
                            <option value="">Tous</option>
                            <option value="VALIDE"         <%= "VALIDE".equals(statutPermis)         ? "selected" : "" %>>Valide</option>
                            <option value="BIENTOT_EXPIRE" <%= "BIENTOT_EXPIRE".equals(statutPermis) ? "selected" : "" %>>Bientot expire</option>
                            <option value="EXPIRE"         <%= "EXPIRE".equals(statutPermis)         ? "selected" : "" %>>Expire</option>
                        </select>
                    </div>
                    <div class="col-md-2 d-grid">
                        <button type="submit" class="btn btn-primary"><i class="bi bi-search"></i> Filtrer</button>
                    </div>
                </div>
                <div class="row g-3 mt-1 align-items-end">
                    <div class="col-md-3">
                        <label class="form-label">Expiration permis — Du</label>
                        <input type="date" name="datePermisDebut" class="form-control" value="<%= dateDebutStr != null ? dateDebutStr : "" %>">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Au</label>
                        <input type="date" name="datePermisFin" class="form-control" value="<%= dateFinStr != null ? dateFinStr : "" %>">
                    </div>
                    <div class="col-md-2 d-grid">
                        <a href="?page=chauffeurs/liste-chauffeur" class="btn btn-outline-secondary">Reinitialiser</a>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <p class="text-muted"><%= total %> chauffeur(s) trouve(s)</p>

    <div class="card shadow-sm">
        <div class="card-body p-0">
            <table class="table table-bordered table-hover mb-0">
                <thead class="table-primary">
                    <tr>
                        <th>Nom complet</th>
                        <th>Telephone</th>
                        <th>N° Permis</th>
                        <th>Exp. Permis</th>
                        <th>Statut Permis</th>
                        <th>Vehicule habituel</th>
                        <th>Statut</th>
                        <% if (isAdmin) { %><th>Actions</th><% } %>
                    </tr>
                </thead>
                <tbody>
                    <%
                    if (listeChauffeurs.isEmpty()) {
                    %>
                        <tr><td colspan="<%= isAdmin ? 8 : 7 %>" class="text-center text-muted py-3">Aucun chauffeur trouve.</td></tr>
                    <%
                    } else {
                        for (int i = 0; i < listeChauffeurs.size(); i++) {
                            Chauffeur ch = (Chauffeur) listeChauffeurs.get(i);
                    %>
                        <tr onclick="window.location='?page=chauffeurs/details-chauffeur&id=<%= ch.getIdChauffeur() %>'" style="cursor:pointer;">
                            <td><%= ch.getNomComplet() %></td>
                            <td><%= ch.getTelephone() != null ? ch.getTelephone() : "-" %></td>
                            <td><%= ch.getNumeroPermis() %></td>
                            <td><%= ch.getDateExpirationPermis() != null ? ch.getDateExpirationPermis() : "-" %></td>
                            <td>
                                <%
                                    String sp = ch.getStatutPermis();
                                    String spLabel = "VALIDE".equals(sp) ? "Valide"
                                                   : "EXPIRE".equals(sp) ? "Expire"
                                                   : "BIENTOT_EXPIRE".equals(sp) ? "Bientot expire"
                                                   : "Inconnu";
                                %>
                                <span class="badge badge-<%= sp %>"><%= spLabel %></span>
                            </td>
                            <td>
                                <% if (ch.getImmatriculationVehicule() != null) { %>
                                    <%= ch.getImmatriculationVehicule() %> <small class="text-muted">(<%= ch.getMarqueModeleVehicule() %>)</small>
                                <% } else { %>
                                    <span class="text-muted">-</span>
                                <% } %>
                            </td>
                            <td>
                                <span class="badge <%= ch.isActif() ? "bg-success" : "bg-danger" %>">
                                    <%= ch.isActif() ? "Actif" : "Inactif" %>
                                </span>
                            </td>
                            <% if (isAdmin) { %>
                            <td onclick="event.stopPropagation();">
                                <a href="modifier-chauffeur.jsp?id=<%= ch.getIdChauffeur() %>" class="btn btn-sm" title="Modifier" style="background-color: #4907ff; color: #ffffff;">
                                    <i class="bi bi-pencil"></i>
                                </a>
                                <a href="../../traitement/chauffeurs/modifier-chauffeur.jsp?id=<%= ch.getIdChauffeur() %>&actif=<%= !ch.isActif() %>"
                                   class="btn btn-sm <%= ch.isActif() ? "btn-danger" : "btn-success" %>"
                                   onclick="return confirm('Confirmer la <%= ch.isActif() ? "desactivation" : "reactivation" %> ?')"
                                   title="<%= ch.isActif() ? "Desactiver" : "Reactivater" %>">
                                    <i class="bi <%= ch.isActif() ? "bi-person-x" : "bi-person-check" %>"></i>
                                </a>
                            </td>
                            <% } %>
                        </tr>
                    <%
                        }
                    }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <% if (nbPages > 1) { %>
    <nav class="mt-3">
        <ul class="pagination justify-content-center">
            <% for (int p = 1; p <= nbPages; p++) { %>
            <li class="page-item <%= p == pageCourante ? "active" : "" %>">
                <a class="page-link" href="?page=chauffeurs/liste-chauffeur&pageNum=<%= p %>&nom=<%= nom != null ? nom : "" %>&vehicule=<%= vehicule != null ? vehicule : "" %>&statut=<%= statutParam != null ? statutParam : "" %>&statutPermis=<%= statutPermis != null ? statutPermis : "" %>&datePermisDebut=<%= dateDebutStr != null ? dateDebutStr : "" %>&datePermisFin=<%= dateFinStr != null ? dateFinStr : "" %>">
                    <%= p %>
                </a>
            </li>
            <% } %>
        </ul>
    </nav>
    <% } %>

</div>
<script src="../../assets/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>