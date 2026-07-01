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

    Date dateDebut = null;
    Date dateFin = null;

    try {
        if (dateDebutStr != null && !dateDebutStr.isEmpty()) {
            dateDebut = Date.valueOf(dateDebutStr);
        }
    } catch (Exception e) {}

    try {
        if (dateFinStr != null && !dateFinStr.isEmpty()) {
            dateFin = Date.valueOf(dateFinStr);
        }
    } catch (Exception e) {}

    int limit = 10;
    int pageActuelle = 1;

    String pageParam = request.getParameter("pageNum");
    try {
        if (pageParam != null && !pageParam.isEmpty()) {
            pageActuelle = Integer.parseInt(pageParam);
        }
    } catch (Exception e) {
        pageActuelle = 1;
    }

    if (pageActuelle < 1) {
        pageActuelle = 1;
    }

    int offset = (pageActuelle - 1) * limit;

    List<Vehicule> listeVehicules = Vehicule.rechercherGlobalEtDate(
        rechercheGlobale, dateDebut, dateFin, limit, offset
    );

    int totalVehicules = Vehicule.compterGlobalEtDate(
        rechercheGlobale, dateDebut, dateFin
    );

    int nbPages = (int) Math.ceil((double) totalVehicules / limit);
    if (nbPages < 1) nbPages = 1;

    String baseUrl = "model.jsp?page=vehicule/liste-vehicule"
        + "&rechercheGlobale=" + (rechercheGlobale != null ? rechercheGlobale : "")
        + "&dateAssuranceDebut=" + (dateDebutStr != null ? dateDebutStr : "")
        + "&dateAssuranceFin=" + (dateFinStr != null ? dateFinStr : "");
%>

<style>
    .filter-container {
        background-color: #f8f9fa;
        padding: 20px;
        border: 1px solid #dee2e6;
        border-radius: 6px;
        margin-bottom: 20px;
    }

    .data-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 15px;
    }

    .data-table th,
    .data-table td {
        border: 1px solid #dee2e6;
        padding: 10px;
        text-align: left;
    }

    .data-table th {
        background-color: #007bff;
        color: white;
    }

    .btn-action {
        padding: 4px 8px;
        text-decoration: none;
        border-radius: 4px;
        font-size: 0.9em;
        color: white;
    }

    .btn-modifier {
        background-color: #ffc107;
        color: #212529;
    }

    .data-table tbody tr {
        cursor: pointer;
        transition: background-color 0.2s ease;
    }

    .data-table tbody tr:hover {
        background-color: #f1f3f5;
    }
</style>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2 class="fw-bold">Liste des véhicules</h2>

    <a href="model.jsp?page=vehicule/gestion-vehicule" class="btn btn-secondary">
        <i class="bi bi-arrow-left"></i> Retour
    </a>
</div>

<div class="filter-container">
    <form method="get" action="model.jsp">
        <input type="hidden" name="page" value="vehicule/liste-vehicule">
        <input type="hidden" name="pageNum" value="1">

        <div class="row g-3 align-items-end">
            <div class="col-md-5">
                <label class="form-label">
                    Recherche globale
                </label>
                <input type="text"
                       name="rechercheGlobale"
                       class="form-control"
                       placeholder="Ex: Toyota, ACTIF, 1234 TAB..."
                       value="<%= rechercheGlobale != null ? rechercheGlobale : "" %>">
            </div>

            <div class="col-md-5">
                <label class="form-label">
                    Intervalle date assurance
                </label>

                <div class="input-group">
                    <span class="input-group-text">Du</span>
                    <input type="date"
                           name="dateAssuranceDebut"
                           class="form-control"
                           value="<%= dateDebutStr != null ? dateDebutStr : "" %>">

                    <span class="input-group-text">Au</span>
                    <input type="date"
                           name="dateAssuranceFin"
                           class="form-control"
                           value="<%= dateFinStr != null ? dateFinStr : "" %>">
                </div>
            </div>

            <div class="col-md-2 d-grid">
                <button type="submit" class="btn btn-primary">
                    <i class="bi bi-search"></i> Filtrer
                </button>
            </div>
        </div>
    </form>
</div>

<div class="table-responsive">
    <table class="data-table">
        <thead>
            <tr>
                <th>Immatriculation</th>
                <th>Marque</th>
                <th>Modèle</th>
                <th>Capacité</th>
                <th>Kilométrage</th>
                <th>État</th>
                <th>Date assurance</th>
                <th>Actions</th>
            </tr>
        </thead>

        <tbody>
            <% if (listeVehicules == null || listeVehicules.isEmpty()) { %>
                <tr>
                    <td colspan="8" class="text-center text-muted">
                        Aucun véhicule trouvé.
                    </td>
                </tr>
            <% } else {
                for (Vehicule v : listeVehicules) { %>
                    <tr class="vehicule-row"
                        data-href="model.jsp?page=vehicule/details-vehicule&id=<%= v.getIdVehicule() %>">
                        <td><%= v.getImmatriculation() %></td>
                        <td><%= v.getMarque() %></td>
                        <td><%= v.getModele() %></td>
                        <td><%= v.getCapacite() %> places</td>
                        <td><%= v.getKilometrageActuel() %> km</td>

                        <td>
                            <span class="badge <%= "ACTIF".equals(v.getEtat()) ? "bg-success" : "bg-danger" %>">
                                <%= v.getEtat() %>
                            </span>
                        </td>

                        <td>
                            <%= v.getDateExpirationAssurance() != null ? v.getDateExpirationAssurance() : "N/A" %>
                        </td>

                        <td>
                            <% if (isAdmin) { %>
                                <a href="model.jsp?page=vehicule/modifier-vehicule&id=<%= v.getIdVehicule() %>"
                                   class="btn-action btn-modifier"
                                   onclick="event.stopPropagation();">
                                    Modifier
                                </a>
                            <% } %>
                        </td>
                    </tr>
            <% }} %>
        </tbody>
    </table>
</div>

<% if (nbPages > 1) { %>
    <nav class="mt-3">
        <ul class="pagination flex-wrap">
            <% for (int p = 1; p <= nbPages; p++) { %>
                <li class="page-item <%= p == pageActuelle ? "active" : "" %>">
                    <a class="page-link" href="<%= baseUrl %>&pageNum=<%= p %>">
                        <%= p %>
                    </a>
                </li>
            <% } %>
        </ul>
    </nav>
<% } %>

<script>
document.addEventListener("DOMContentLoaded", function() {
    const rows = document.querySelectorAll(".vehicule-row");

    rows.forEach(function(row) {
        row.addEventListener("click", function() {
            const url = this.getAttribute("data-href");
            if (url) {
                window.location.href = url;
            }
        });
    });
});
</script>