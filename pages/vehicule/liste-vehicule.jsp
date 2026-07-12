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

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2 class="fw-bold mb-0">
        <i class="bi bi-car-front text-primary"></i> Liste des Véhicules
        <small class="fs-6 text-muted ms-2">(<%= totalVehicules %> résultat<%= totalVehicules > 1 ? "s" : "" %>)</small>
    </h2>

    <div class="d-flex gap-2">
        <a href="model.jsp?page=vehicule/gestion-vehicule" class="btn btn-outline-secondary btn-sm">
            <i class="bi bi-arrow-left"></i> Retour
        </a>
    </div>
</div>

<div class="card border-0 shadow-sm mb-4">
    <div class="card-body">
        <form method="get" action="model.jsp" class="row g-3 align-items-end">
            <input type="hidden" name="page" value="vehicule/liste-vehicule">
            <input type="hidden" name="pageNum" value="1">

            <div class="col-md-5">
                <label class="form-label fw-semibold">
                    Recherche globale
                </label>
                <input type="text"
                       name="rechercheGlobale"
                       class="form-control form-control-sm"
                       placeholder="Ex: Toyota, ACTIF, 1234 TAB..."
                       value="<%= rechercheGlobale != null ? rechercheGlobale : "" %>">
            </div>

            <div class="col-md-5">
                <label class="form-label fw-semibold">
                    Intervalle date assurance
                </label>

                <div class="input-group input-group-sm">
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

            <div class="col-md-2 d-flex align-items-end gap-2">
                <button type="submit" class="btn btn-primary btn-sm w-100">
                    <i class="bi bi-search"></i> Filtrer
                </button>
            </div>
        </form>
    </div>
</div>

<div class="card border-0 shadow-sm mb-4">
    <div class="table-responsive">
        <table class="table table-hover table-striped align-middle mb-0">
            <thead class="table-light">
                <tr>
                    <th>Immatriculation</th>
                    <th>Marque</th>
                    <th>Modèle</th>
                    <th>Capacité</th>
                    <th>Kilométrage</th>
                    <th>État</th>
                    <th>Date assurance</th>
                    <% if (isAdmin) { %><th class="text-end">Actions</th><% } %>
                </tr>
            </thead>

            <tbody>
                <% if (listeVehicules == null || listeVehicules.isEmpty()) { %>
                    <tr>
                        <td colspan="<%= isAdmin ? 8 : 7 %>" class="text-center text-muted py-5">
                            <i class="bi bi-inbox d-block fs-1 mb-2"></i>
                            Aucun véhicule trouvé.
                        </td>
                    </tr>
                <% } else {
                    for (Vehicule v : listeVehicules) { %>
                        <tr class="vehicule-row" style="cursor:pointer;"
                            data-href="?page=vehicule/details-vehicule&id=<%= v.getIdVehicule() %>">
                            <td>
                                <span class="badge bg-light text-dark border"><%= v.getImmatriculation() %></span>
                            </td>
                            <td class="fw-semibold"><%= v.getMarque() %></td>
                            <td><%= v.getModele() %></td>
                            <td><%= v.getCapacite() %> places</td>
                            <td><%= v.getKilometrageActuel() %> km</td>

                            <td>
                                <span class="badge <%= "ACTIF".equals(v.getEtat()) ? "bg-success" : "bg-danger" %> rounded-pill px-3 py-2">
                                    <%= v.getEtat() %>
                                </span>
                            </td>

                            <td>
                                <%= v.getDateExpirationAssurance() != null ? v.getDateExpirationAssurance() : "N/A" %>
                            </td>

                            <% if (isAdmin) { %>
                            <td class="text-end" onclick="event.stopPropagation();">
                                <a href="model.jsp?page=vehicule/modifier-vehicule&id=<%= v.getIdVehicule() %>"
                                   class="btn btn-sm btn-outline-warning rounded-circle" title="Modifier">
                                    <i class="bi bi-pencil"></i>
                                </a>
                            </td>
                            <% } %>
                        </tr>
                <% }} %>
            </tbody>
        </table>
    </div>
</div>

<% if (nbPages > 1) { %>
    <nav>
        <ul class="pagination pagination-sm">
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