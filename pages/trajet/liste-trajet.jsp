<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="gestion.Trajet, gestion.Ville, java.util.List" %>
<%@ page import="backoffice.Utilisateur" %>
<%
    Utilisateur userObj = (Utilisateur) session.getAttribute("utilisateur");
    if (userObj == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    boolean isAdmin = "Admin".equalsIgnoreCase(userObj.voirsiadmin());

    // ---- Paramètres de recherche ----
    String searchDepart  = request.getParameter("searchDepart");
    String searchArrivee = request.getParameter("searchArrivee");
    String searchTarif   = request.getParameter("searchTarif");
    String searchStatut  = request.getParameter("searchStatut");
    String dateDebut     = request.getParameter("dateDebut");
    String dateFin       = request.getParameter("dateFin");

    // ---- Paramètres de tri ----
    String sortField = request.getParameter("sortField");
    String sortOrder = request.getParameter("sortOrder");
    if (sortField == null || sortField.isEmpty()) sortField = "id_trajet";
    if (sortOrder == null || sortOrder.isEmpty()) sortOrder = "DESC";

    // ---- Paramètre de page ----
    int currentPage = 1;
    String pageParam = request.getParameter("page");
    if (pageParam != null && !pageParam.isEmpty()) {
        try { currentPage = Integer.parseInt(pageParam); } catch (NumberFormatException e) { currentPage = 1; }
    }
    if (currentPage < 1) currentPage = 1;

    Trajet trajetGestion = new Trajet();
    Ville  villeGestion  = new Ville();

    List<Ville>  villes  = villeGestion.getAllVilles();
    List<Trajet> trajetsTrouves = trajetGestion.rechercherTrajets(
            searchDepart, searchArrivee, searchTarif, searchStatut,
            dateDebut, dateFin, sortField, sortOrder, currentPage);

    int totalItems = trajetGestion.countTrajets(
            searchDepart, searchArrivee, searchTarif, searchStatut, dateDebut, dateFin);
    int pageSize   = trajetGestion.getPageSize();
    int totalPages = (int) Math.ceil((double) totalItems / pageSize);
    if (totalPages < 1) totalPages = 1;
    if (currentPage > totalPages) currentPage = totalPages;

   
    String baseQuery = "?page=trajet/liste-trajet&" +
        (searchDepart  != null && !searchDepart.isEmpty()  ? "searchDepart="  + searchDepart  + "&" : "") +
        (searchArrivee != null && !searchArrivee.isEmpty() ? "searchArrivee=" + searchArrivee + "&" : "") +
        (searchTarif   != null && !searchTarif.isEmpty()   ? "searchTarif="   + searchTarif   + "&" : "") +
        (searchStatut  != null && !searchStatut.isEmpty()  ? "searchStatut="  + searchStatut  + "&" : "") +
        (dateDebut     != null && !dateDebut.isEmpty()     ? "dateDebut="     + dateDebut     + "&" : "") +
        (dateFin       != null && !dateFin.isEmpty()       ? "dateFin="       + dateFin       + "&" : "") +
        "sortField=" + sortField + "&sortOrder=" + sortOrder + "&";
%>
<div class="d-flex justify-content-between align-items-center mb-4">
    <h2 class="fw-bold mb-0">
        <i class="bi bi-signpost-2 text-primary"></i> Liste des Trajets
        <small class="fs-6 text-muted ms-2">(<%= totalItems %> résultat<%= totalItems > 1 ? "s" : "" %>)</small>
    </h2>
    <div class="d-flex gap-2">
        <% if (isAdmin) { %>
            <a href="?page=trajet/ajout-trajet" class="btn btn-primary btn-sm">
                <i class="bi bi-plus-lg"></i> Nouveau Trajet
            </a>
        <% } %>
        <a href="?page=trajet/gestion-trajet" class="btn btn-outline-secondary btn-sm">
            <i class="bi bi-arrow-left"></i> Retour
        </a>
    </div>
</div>

<% String msg = request.getParameter("msg"); String err = request.getParameter("error"); %>
<% if ("success".equals(msg)) { %>
    <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm" role="alert">
        <i class="bi bi-check-circle me-2"></i> Trajet ajouté avec succès.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
<% } else if ("desactive".equals(msg)) { %>
    <div class="alert alert-warning alert-dismissible fade show border-0 shadow-sm" role="alert">
        <i class="bi bi-ban me-2"></i> Trajet désactivé avec succès.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
<% } else if ("supprime".equals(msg)) { %>
    <div class="alert alert-warning alert-dismissible fade show border-0 shadow-sm" role="alert">
        <i class="bi bi-trash me-2"></i> Trajet supprimé avec succès.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
<% } else if ("sql".equals(err)) { %>
    <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm" role="alert">
        <i class="bi bi-exclamation-triangle me-2"></i> Une erreur est survenue. Veuillez réessayer.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
<% } %>

<div class="card border-0 shadow-sm mb-4">
    <div class="card-body">
        <form id="searchForm" action="model.jsp" method="GET" class="row g-3 align-items-end">
            <input type="hidden" name="page" value="trajet/liste-trajet">
            <input type="hidden" name="sortField" value="<%= sortField %>">
            <input type="hidden" name="sortOrder" value="<%= sortOrder %>">

            <div class="col-md-3">
                <label class="form-label fw-semibold">Ville de départ</label>
                <select name="searchDepart" id="searchDepart" class="form-select form-select-sm" onchange="updateArriveeSearch()">
                    <option value="">Toutes</option>
                    <% for (Ville v : villes) {
                        String sel = (searchDepart != null && searchDepart.equals(String.valueOf(v.getIdVille()))) ? "selected" : "";
                    %>
                        <option value="<%= v.getIdVille() %>" <%= sel %>><%= v.getNomVille() %></option>
                    <% } %>
                </select>
            </div>
            <div class="col-md-3">
                <label class="form-label fw-semibold">Ville d'arrivée</label>
                <select name="searchArrivee" id="searchArrivee" class="form-select form-select-sm">
                    <option value="">Toutes</option>
                    <% for (Ville v : villes) {
                        String sel = (searchArrivee != null && searchArrivee.equals(String.valueOf(v.getIdVille()))) ? "selected" : "";
                    %>
                        <option value="<%= v.getIdVille() %>" <%= sel %>><%= v.getNomVille() %></option>
                    <% } %>
                </select>
            </div>
            <div class="col-md-2">
                <label class="form-label fw-semibold">Tarif Max (Ar)</label>
                <input type="number" name="searchTarif" class="form-control form-control-sm"
                       value="<%= searchTarif != null ? searchTarif : "" %>" placeholder="Ex: 50000">
            </div>
            <div class="col-md-2">
                <label class="form-label fw-semibold">Statut</label>
                <select name="searchStatut" class="form-select form-select-sm">
                    <option value="">Tous</option>
                    <option value="true"  <%= "true".equals(searchStatut)  ? "selected" : "" %>>Actif</option>
                    <option value="false" <%= "false".equals(searchStatut) ? "selected" : "" %>>Inactif</option>
                </select>
            </div>
            <div class="col-md-2 d-flex align-items-end gap-2">
                <button type="submit" class="btn btn-primary btn-sm">
                    <i class="bi bi-search"></i> Filtrer
                </button>
            </div>

            <div class="col-md-3">
                <label class="form-label fw-semibold">Date départ (min)</label>
                <input type="date" name="dateDebut" class="form-control form-control-sm"
                       value="<%= dateDebut != null ? dateDebut : "" %>">
            </div>
            <div class="col-md-3">
                <label class="form-label fw-semibold">Date départ (max)</label>
                <input type="date" name="dateFin" class="form-control form-control-sm"
                       value="<%= dateFin != null ? dateFin : "" %>">
            </div>
            <div class="col-md-2 d-flex align-items-end">
                <a href="?page=trajet/liste-trajet" class="btn btn-outline-secondary btn-sm">
                    Réinitialiser
                </a>
            </div>
        </form>
    </div>
</div>

<div class="d-flex flex-wrap align-items-center gap-2 mb-3">
    <span class="text-muted small fw-semibold">Trier par Départ :</span>
    <a href="model.jsp?page=trajet/liste-trajet&searchDepart=<%= searchDepart != null ? searchDepart : "" %>&searchArrivee=<%= searchArrivee != null ? searchArrivee : "" %>&searchTarif=<%= searchTarif != null ? searchTarif : "" %>&searchStatut=<%= searchStatut != null ? searchStatut : "" %>&dateDebut=<%= dateDebut != null ? dateDebut : "" %>&dateFin=<%= dateFin != null ? dateFin : "" %>&sortField=depart_nom&sortOrder=ASC&page=1"
       class="btn btn-sm <%= "depart_nom".equals(sortField) && "ASC".equals(sortOrder) ? "btn-primary" : "btn-outline-secondary" %>">A → Z</a>
    <a href="model.jsp?page=trajet/liste-trajet&searchDepart=<%= searchDepart != null ? searchDepart : "" %>&searchArrivee=<%= searchArrivee != null ? searchArrivee : "" %>&searchTarif=<%= searchTarif != null ? searchTarif : "" %>&searchStatut=<%= searchStatut != null ? searchStatut : "" %>&dateDebut=<%= dateDebut != null ? dateDebut : "" %>&dateFin=<%= dateFin != null ? dateFin : "" %>&sortField=depart_nom&sortOrder=DESC&page=1"
       class="btn btn-sm <%= "depart_nom".equals(sortField) && "DESC".equals(sortOrder) ? "btn-primary" : "btn-outline-secondary" %>">Z → A</a>
</div>

<div class="card border-0 shadow-sm mb-4">
    <div class="table-responsive">
        <table class="table table-hover table-striped align-middle mb-0">
            <thead class="table-light">
                <tr>
                    <th>#</th>
                    <th>Départ</th>
                    <th>Arrivée</th>
                    <th>Distance</th>
                    <th>Durée</th>
                    <th>Tarif (Ar)</th>
                    <th>Statut</th>
                    <th class="text-end">Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (trajetsTrouves.isEmpty()) { %>
                    <tr>
                        <td colspan="8" class="text-center py-5 text-muted">
                            <i class="bi bi-inbox d-block fs-1 mb-2"></i>
                            Aucun trajet trouvé.
                        </td>
                    </tr>
                <% } else { %>
                    <% for (Trajet t : trajetsTrouves) { %>
                    <tr>
                        <td class="fw-semibold text-muted">#<%= t.getIdTrajet() %></td>
                        <td><span class="fw-semibold"><%= t.getVilleDepart().getNomVille() %></span></td>
                        <td><span class="fw-semibold"><%= t.getVilleArrivee().getNomVille() %></span></td>
                        <td><%= t.getDistanceKm() != null ? t.getDistanceKm() : "-" %></td>
                        <td><%= t.getDureeEstimee() != null ? t.getDureeEstimee() : "-" %></td>
                        <td class="fw-bold"><%= t.getTarifBase() %> Ar</td>
                        <td>
                            <% if (t.isActif()) { %>
                                <span class="badge bg-success rounded-pill px-3 py-2">Actif</span>
                            <% } else { %>
                                <span class="badge bg-secondary rounded-pill px-3 py-2">Inactif</span>
                            <% } %>
                        </td>
                        <td class="text-end">
                            <a href="?page=trajet/details-trajet&id=<%= t.getIdTrajet() %>"
                               class="btn btn-sm btn-outline-info rounded-circle me-1" title="Détails">
                                <i class="bi bi-eye"></i>
                            </a>
                            <% if (isAdmin) { %>
                                <a href="?page=trajet/modifier-trajet&id=<%= t.getIdTrajet() %>"
                                   class="btn btn-sm btn-outline-warning rounded-circle me-1" title="Modifier">
                                    <i class="bi bi-pencil"></i>
                                </a>
                                <a href="../traitement/trajet/supprimer-trajet.jsp?id=<%= t.getIdTrajet() %>&action=desactiver"
                                   class="btn btn-sm btn-outline-secondary rounded-circle me-1" title="Désactiver"
                                   onclick="return confirm('Désactiver ce trajet ?');">
                                    <i class="bi bi-ban"></i>
                                </a>
                                <a href="../traitement/trajet/supprimer-trajet.jsp?id=<%= t.getIdTrajet() %>&action=supprimer"
                                   class="btn btn-sm btn-outline-danger rounded-circle" title="Supprimer"
                                   onclick="return confirm('Supprimer définitivement ?');">
                                    <i class="bi bi-trash"></i>
                                </a>
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<% if (totalPages > 1) { %>
<nav>
    <ul class="pagination pagination-sm">
        <% for (int p = 1; p <= totalPages; p++) {
            if (p == 1 || p == totalPages || (p >= currentPage - 2 && p <= currentPage + 2)) { %>
                <li class="page-item <%= p == currentPage ? "active" : "" %>">
                    <a class="page-link" href="<%= baseQuery %>page=<%= p %>"><%= p %></a>
                </li>
        <%      } else if (p == currentPage - 3 || p == currentPage + 3) { %>
                <li class="page-item disabled"><span class="page-link">…</span></li>
        <%      }
           } %>
    </ul>
</nav>
<% } %>

<script>
    function updateArriveeSearch() {
        var departSel  = document.getElementById("searchDepart");
        var arriveeSel = document.getElementById("searchArrivee");
        var selectedDepart = departSel.value;

        if (arriveeSel.value !== "" && arriveeSel.value === selectedDepart) {
            arriveeSel.value = "";
        }

        for (var i = 0; i < arriveeSel.options.length; i++) {
            var opt = arriveeSel.options[i];
            if (opt.value === "") continue;

            if (selectedDepart !== "" && opt.value === selectedDepart) {
                opt.disabled = true;
                opt.style.display = "none";
            } else {
                opt.disabled = false;
                opt.style.display = "";
            }
        }
    }

    document.addEventListener("DOMContentLoaded", function () {
        updateArriveeSearch();
    });
</script>
