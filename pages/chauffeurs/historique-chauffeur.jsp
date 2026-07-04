<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="backoffice.Utilisateur" %>
<%@ page import="gestion.Chauffeur" %>
<%@ page import="gestion.Depart" %>
<%@ page import="java.util.Vector" %>
<%
    Utilisateur userObj = (Utilisateur) session.getAttribute("utilisateur");
    if (userObj == null) {
        response.sendRedirect("../../index.jsp");
        return;
    }

    int id = 0;
    try { id = Integer.parseInt(request.getParameter("id")); } catch (Exception e) {}
    Chauffeur ch = Chauffeur.getById(id);
    if (ch == null) {
        response.sendRedirect("?page=chauffeurs/liste-chauffeur");
        return;
    }

    int limit = 10;
    int pageCourante = 1;
    try { pageCourante = Integer.parseInt(request.getParameter("pageNum")); } catch (Exception e) {}
    int offset = (pageCourante - 1) * limit;

    Vector historique = Chauffeur.getHistorique(id, limit, offset);
    int total   = Chauffeur.countHistorique(id);
    int nbPages = (int) Math.ceil((double) total / limit);
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Historique — <%= ch.getNomComplet() %></title>
    <link rel="stylesheet" href="../../assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="../../assets/bootstrap/icons/bootstrap-icons.min.css">
</head>
<body class="bg-light">
<div class="container mt-4">

    <a href="?page=chauffeurs/details-chauffeur&id=<%= id %>" class="btn btn-sm btn-secondary mb-3">
        <i class="bi bi-arrow-left"></i> Retour aux details
    </a>

    <h2 class="mb-1"><i class="bi bi-clock-history"></i> Historique des trajets</h2>
    <p class="text-muted mb-4">Chauffeur : <strong><%= ch.getNomComplet() %></strong> — <%= total %> trajet(s) au total</p>

    <div class="card shadow-sm">
        <div class="card-body p-0">
            <table class="table table-bordered table-hover mb-0">
                <thead class="table-primary">
                    <tr>
                        <th>Date</th>
                        <th>Heure</th>
                        <th>Depart</th>
                        <th>Arrivee</th>
                        <th>Vehicule</th>
                        <th>Statut</th>
                        <th>Reservations</th>
                    </tr>
                </thead>
                <tbody>
                <%
                if (historique.isEmpty()) {
                %>
                    <tr><td colspan="7" class="text-center text-muted py-3">Aucun trajet trouve pour ce chauffeur.</td></tr>
                <%
                } else {
                    for (int i = 0; i < historique.size(); i++) {
                        Depart t = (Depart) historique.get(i);
                        String statBadge = "PLANIFIE".equals(t.getStatut()) ? "bg-primary"
                                         : "EN_COURS".equals(t.getStatut())  ? "bg-warning text-dark"
                                         : "TERMINE".equals(t.getStatut())   ? "bg-success"
                                         : "bg-danger";
                %>
                    <tr>
                        <td><%= t.getDate_depart() %></td>
                        <td><%= t.getHeure_depart() %></td>
                        <td><%= t.getVille_depart() %></td>
                        <td><%= t.getVille_arrivee() %></td>
                        <td><%= t.getImmatriculation() %></td>
                        <td><span class="badge <%= statBadge %>"><%= t.getStatut_label() %></span></td>
                        <td class="text-center"><%= t.getNb_reservations() %></td>
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
                <a class="page-link" href="?page=chauffeurs/historique-chauffeur&id=<%= id %>&pageNum=<%= p %>"><%= p %></a>
            </li>
            <% } %>
        </ul>
    </nav>
    <% } %>

</div>
<script src="../../assets/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>