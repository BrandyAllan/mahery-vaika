<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.Date" %>
<%@ page import="gestion.Vehicule" %>
<%@ page import="backoffice.Utilisateur" %>
<%
    Utilisateur userObj = (Utilisateur) session.getAttribute("utilisateur");
    if (userObj == null) {
        response.sendRedirect("../index.jsp");
        return; 
    }
    
    String userRole = userObj.voirsiadmin();
    boolean isAdmin = "Admin".equalsIgnoreCase(userRole);

    String rechercheGlobale = request.getParameter("rechercheGlobale");
    String dateDebutStr = request.getParameter("dateAssuranceDebut");
    String dateFinStr = request.getParameter("dateAssuranceFin");

    Date dateDebut = (dateDebutStr != null && !dateDebutStr.isEmpty()) ? Date.valueOf(dateDebutStr) : null;
    Date dateFin = (dateFinStr != null && !dateFinStr.isEmpty()) ? Date.valueOf(dateFinStr) : null;

    int limit = 10;
    int pageActuelle = 1;
    String pageParam = request.getParameter("page");
    if (pageParam != null && !pageParam.isEmpty()) {
        pageActuelle = Integer.parseInt(pageParam);
    }
    int offset = (pageActuelle - 1) * limit;

    List<Vehicule> listeVehicules = Vehicule.rechercherGlobalEtDate(rechercheGlobale, dateDebut, dateFin, limit, offset);
    int totalVehicules = Vehicule.compterGlobalEtDate(rechercheGlobale, dateDebut, dateFin);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Liste des Véhicules</title>
    <link rel="stylesheet" href="../assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/bootstrap/icons/bootstrap-icons.min.css">
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .filter-container { background-color: #f8f9fa; padding: 20px; border: 1px solid #dee2e6; border-radius: 6px; margin-bottom: 20px; }
        .data-table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        .data-table th, .data-table td { border: 1px solid #dee2e6; padding: 10px; text-align: left; }
        .data-table th { background-color: #007bff; color: white; }
        .btn-action { padding: 4px 8px; text-decoration: none; border-radius: 4px; font-size: 0.9em; color: white; }
        .btn-modifier { background-color: #ffc107; color: #212529; }
        .data-table tbody tr {
    cursor: pointer;
    transition: background-color 0.2s ease;
    }
    .data-table tbody tr:hover {
        background-color: #f1f3f5;
    }
    </style>
</head>
<body>

    <p><a href="gestion-vehicule.jsp" class="btn btn-sm btn-secondary">← Tableau de bord</a></p>

    <div class="filter-container">
        <form method="GET" action="liste-vehicule.jsp">
            <input type="hidden" name="page" value="1">
            <div class="row g-3 align-items-end">
                
                <div class="col-md-5">
                    <label class="form-label">1. Recherche globale (Immatriculation, Marque, Modèle, État) :</label>
                    <input type="text" name="rechercheGlobale" class="form-control" placeholder="Ex: Toyota, Actif, 1234 TAB..." value="<%= (rechercheGlobale != null) ? rechercheGlobale : "" %>">
                </div>

                <div class="col-md-5">
                    <label class="form-label">2. Trier par Intervalle Date Assurance :</label>
                    <div class="input-group">
                        <span class="input-group-text">Du</span>
                        <input type="date" name="dateAssuranceDebut" class="form-control" value="<%= (dateDebutStr != null) ? dateDebutStr : "" %>">
                        <span class="input-group-text">Au</span>
                        <input type="date" name="dateAssuranceFin" class="form-control" value="<%= (dateFinStr != null) ? dateFinStr : "" %>">
                    </div>
                </div>

                <div class="col-md-2 d-grid">
                    <button type="submit" class="btn btn-primary"><i class="bi bi-search"></i> Filtrer</button>
                </div>

            </div>
        </form>
    </div>

    <table class="data-table">
        <thead>
            <tr>
                <th>Immatriculation</th>
                <th>Marque</th>
                <th>Modèle</th>
                <th>Capacité</th>
                <th>Kilométrage</th>
                <th>État</th>
                <th>Date Assurance</th>
                <th>Actions</th>
            </tr>
        </thead>
        <script>
    document.addEventListener("DOMContentLoaded", function() {
        const rows = document.querySelectorAll(".vehicule-row");
        rows.forEach(row => {
            row.addEventListener("click", function() {
                const url = this.getAttribute("data-href");
                if (url) {
                    window.location.href = url;
                }
            });
        });
    });
</script>

      <tbody>
    <% if (listeVehicules == null || listeVehicules.isEmpty()) { %>
        <tr>
            <td colspan="8" style="text-align: center; color: gray;">Aucun véhicule trouvé.</td>
        </tr>
    <% } else { for (Vehicule v : listeVehicules) { %>
        <tr class="vehicule-row" data-href="details-vehicule.jsp?id=<%= v.getIdVehicule() %>">
            <td><%= v.getImmatriculation() %></td>
            <td><%= v.getMarque() %></td>
            <td><%= v.getModele() %></td>
            <td><%= v.getCapacite() %> places</td>
            <td><%= v.getKilometrageActuel() %> km</td>
            <td><span class="badge <%= "ACTIF".equals(v.getEtat()) ? "bg-success" : "bg-danger" %>"><%= v.getEtat() %></span></td>
            <td><%= v.getDateExpirationAssurance() != null ? v.getDateExpirationAssurance() : "N/A" %></td>
            <td>
                <% if (isAdmin) { %>
                    <a href="modifier-vehicule.jsp?id=<%= v.getIdVehicule() %>" class="btn-action btn-modifier" onclick="event.stopPropagation();">Modifier</a>
                <% } %>
            </td>
        </tr>
    <% } } %>
</tbody>
    </table>

</body>
</html>