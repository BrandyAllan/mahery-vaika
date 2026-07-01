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
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Trajets - Mahery Vaika</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../assets/css/styles-premium.css">
    <style>
        .sort-link { color: inherit; text-decoration: none; }
        .sort-link:hover { color: #3498db; }
        .sort-icon { font-size: 0.75rem; margin-left: 4px; color: #3498db; }
        .pagination .page-link { border-radius: 8px; margin: 0 2px; }
        .pagination .page-item.active .page-link {
            background: linear-gradient(135deg, #2c3e50, #3498db);
            border-color: transparent;
        }
        .msg-banner { border-radius: 12px; }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark" style="background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);">
        <div class="container">
            <a class="navbar-brand fw-bold" href="?page=trajet/gestion-trajet"><i class="fas fa-arrow-left me-2"></i>Retour</a>
            <span class="navbar-text text-white fw-bold">
                <i class="fas fa-bus-alt me-2"></i>Mahery Vaika
            </span>
        </div>
    </nav>

    <div class="container mt-5">

        <%-- Messages de succès / erreur --%>
        <% String msg = request.getParameter("msg"); String err = request.getParameter("error"); %>
        <% if ("success".equals(msg)) { %>
            <div class="alert alert-success msg-banner d-flex align-items-center mb-4" role="alert">
                <i class="fas fa-check-circle me-2 fa-lg"></i> Trajet ajouté avec succès.
            </div>
        <% } else if ("desactive".equals(msg)) { %>
            <div class="alert alert-warning msg-banner d-flex align-items-center mb-4" role="alert">
                <i class="fas fa-ban me-2 fa-lg"></i> Trajet désactivé avec succès.
            </div>
        <% } else if ("supprime".equals(msg)) { %>
            <div class="alert alert-warning msg-banner d-flex align-items-center mb-4" role="alert">
                <i class="fas fa-trash me-2 fa-lg"></i> Trajet supprimé avec succès.
            </div>
        <% } else if ("sql".equals(err)) { %>
            <div class="alert alert-danger msg-banner d-flex align-items-center mb-4" role="alert">
                <i class="fas fa-exclamation-triangle me-2 fa-lg"></i> Une erreur est survenue. Veuillez réessayer.
            </div>
        <% } %>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="fw-bold" style="color: #2c3e50;">
                <i class="fas fa-route me-2 text-primary"></i>Liste des Trajets
                <small class="fs-6 text-muted ms-2">(<%= totalItems %> résultat<%= totalItems > 1 ? "s" : "" %>)</small>
            </h2>
            <% if (isAdmin) { %>
                <a href="?page=trajet/ajout-trajet" class="btn btn-premium"><i class="fas fa-plus me-2"></i>Nouveau Trajet</a>
            <% } %>
        </div>

        <%-- Formulaire de recherche --%>
        <div class="search-container mb-4">
            <form id="searchForm" action="model.jsp" method="GET">
                <input type="hidden" name="page" value="trajet/liste-trajet">
                <input type="hidden" name="sortField" value="<%= sortField %>">
                <input type="hidden" name="sortOrder" value="<%= sortOrder %>">
                <div class="row g-3 mb-3">
                    <div class="col-md-3">
                        <label class="form-label text-muted fw-semibold"><i class="fas fa-map-marker-alt me-1 text-danger"></i>Ville de départ</label>
                        <select name="searchDepart" id="searchDepart" class="form-select premium-input" onchange="updateArriveeSearch()">
                            <option value="">Toutes</option>
                            <% for (Ville v : villes) {
                                String sel = (searchDepart != null && searchDepart.equals(String.valueOf(v.getIdVille()))) ? "selected" : "";
                            %>
                                <option value="<%= v.getIdVille() %>" <%= sel %>><%= v.getNomVille() %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label text-muted fw-semibold"><i class="fas fa-flag-checkered me-1 text-success"></i>Ville d'arrivée</label>
                        <select name="searchArrivee" id="searchArrivee" class="form-select premium-input">
                            <option value="">Toutes</option>
                            <% for (Ville v : villes) {
                                String sel = (searchArrivee != null && searchArrivee.equals(String.valueOf(v.getIdVille()))) ? "selected" : "";
                            %>
                                <option value="<%= v.getIdVille() %>" <%= sel %>><%= v.getNomVille() %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label text-muted fw-semibold"><i class="fas fa-money-bill-wave me-1 text-success"></i>Tarif Max (Ar)</label>
                        <input type="number" name="searchTarif" class="form-control premium-input"
                               value="<%= searchTarif != null ? searchTarif : "" %>" placeholder="Ex: 50000">
                    </div>
                    <div class="col-md-2">
                        <label class="form-label text-muted fw-semibold"><i class="fas fa-toggle-on me-1 text-info"></i>Statut</label>
                        <select name="searchStatut" class="form-select premium-input">
                            <option value="">Tous</option>
                            <option value="true"  <%= "true".equals(searchStatut)  ? "selected" : "" %>>Actif</option>
                            <option value="false" <%= "false".equals(searchStatut) ? "selected" : "" %>>Inactif</option>
                        </select>
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <button type="submit" class="btn btn-premium w-100">
                            <i class="fas fa-search me-2"></i>Filtrer
                        </button>
                    </div>
                </div>
                <div class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label text-muted fw-semibold"><i class="far fa-calendar-alt me-1 text-primary"></i>Date départ (min)</label>
                        <input type="date" name="dateDebut" class="form-control premium-input"
                               value="<%= dateDebut != null ? dateDebut : "" %>">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label text-muted fw-semibold"><i class="far fa-calendar-alt me-1 text-warning"></i>Date départ (max)</label>
                        <input type="date" name="dateFin" class="form-control premium-input"
                               value="<%= dateFin != null ? dateFin : "" %>">
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <a href="?page=trajet/liste-trajet" class="btn btn-outline-secondary w-100">
                            <i class="fas fa-times me-2"></i>Réinitialiser
                        </a>
                    </div>
                </div>
            </form>
        </div>

        <%-- Tri explicite --%>
        <div class="mb-3 d-flex gap-2 align-items-center">
            <span class="text-muted fw-bold small"><i class="fas fa-sort-alpha-down me-1"></i>Trier par Départ :</span>
            <a href="model.jsp?page=trajet/liste-trajet&searchDepart=<%= searchDepart != null ? searchDepart : "" %>&searchArrivee=<%= searchArrivee != null ? searchArrivee : "" %>&searchTarif=<%= searchTarif != null ? searchTarif : "" %>&searchStatut=<%= searchStatut != null ? searchStatut : "" %>&dateDebut=<%= dateDebut != null ? dateDebut : "" %>&dateFin=<%= dateFin != null ? dateFin : "" %>&sortField=depart_nom&sortOrder=ASC&page=1"
               class="btn btn-sm <%= "depart_nom".equals(sortField) && "ASC".equals(sortOrder) ? "btn-primary" : "btn-outline-secondary" %>">A → Z</a>
            <a href="model.jsp?page=trajet/liste-trajet&searchDepart=<%= searchDepart != null ? searchDepart : "" %>&searchArrivee=<%= searchArrivee != null ? searchArrivee : "" %>&searchTarif=<%= searchTarif != null ? searchTarif : "" %>&searchStatut=<%= searchStatut != null ? searchStatut : "" %>&dateDebut=<%= dateDebut != null ? dateDebut : "" %>&dateFin=<%= dateFin != null ? dateFin : "" %>&sortField=depart_nom&sortOrder=DESC&page=1"
               class="btn btn-sm <%= "depart_nom".equals(sortField) && "DESC".equals(sortOrder) ? "btn-primary" : "btn-outline-secondary" %>">Z → A</a>
        </div>

        <%-- Tableau --%>
        <div class="table-responsive">
            <table class="table premium-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>
                            <a href="model.jsp?page=trajet/liste-trajet&searchDepart=<%= searchDepart != null ? searchDepart : "" %>&searchArrivee=<%= searchArrivee != null ? searchArrivee : "" %>&searchTarif=<%= searchTarif != null ? searchTarif : "" %>&searchStatut=<%= searchStatut != null ? searchStatut : "" %>&dateDebut=<%= dateDebut != null ? dateDebut : "" %>&dateFin=<%= dateFin != null ? dateFin : "" %>&sortField=depart_nom&sortOrder=<%= "depart_nom".equals(sortField) && "ASC".equals(sortOrder) ? "DESC" : "ASC" %>&page=1"
                               class="sort-link">
                                Départ
                                <% if ("depart_nom".equals(sortField)) { %>
                                    <i class="fas fa-sort-<%= "ASC".equals(sortOrder) ? "up" : "down" %> sort-icon"></i>
                                <% } else { %>
                                    <i class="fas fa-sort sort-icon opacity-50"></i>
                                <% } %>
                            </a>
                        </th>
                        <th>
                            <a href="model.jsp?page=trajet/liste-trajet&searchDepart=<%= searchDepart != null ? searchDepart : "" %>&searchArrivee=<%= searchArrivee != null ? searchArrivee : "" %>&searchTarif=<%= searchTarif != null ? searchTarif : "" %>&searchStatut=<%= searchStatut != null ? searchStatut : "" %>&dateDebut=<%= dateDebut != null ? dateDebut : "" %>&dateFin=<%= dateFin != null ? dateFin : "" %>&sortField=arrivee_nom&sortOrder=<%= "arrivee_nom".equals(sortField) && "ASC".equals(sortOrder) ? "DESC" : "ASC" %>&page=1"
                               class="sort-link">
                                Arrivée
                                <% if ("arrivee_nom".equals(sortField)) { %>
                                    <i class="fas fa-sort-<%= "ASC".equals(sortOrder) ? "up" : "down" %> sort-icon"></i>
                                <% } else { %>
                                    <i class="fas fa-sort sort-icon opacity-50"></i>
                                <% } %>
                            </a>
                        </th>
                        <th>Distance (km)</th>
                        <th>Durée</th>
                        <th>
                            <a href="model.jsp?page=trajet/liste-trajet&searchDepart=<%= searchDepart != null ? searchDepart : "" %>&searchArrivee=<%= searchArrivee != null ? searchArrivee : "" %>&searchTarif=<%= searchTarif != null ? searchTarif : "" %>&searchStatut=<%= searchStatut != null ? searchStatut : "" %>&dateDebut=<%= dateDebut != null ? dateDebut : "" %>&dateFin=<%= dateFin != null ? dateFin : "" %>&sortField=tarif_base&sortOrder=<%= "tarif_base".equals(sortField) && "ASC".equals(sortOrder) ? "DESC" : "ASC" %>&page=1"
                               class="sort-link">
                                Tarif (Ar)
                                <% if ("tarif_base".equals(sortField)) { %>
                                    <i class="fas fa-sort-<%= "ASC".equals(sortOrder) ? "up" : "down" %> sort-icon"></i>
                                <% } else { %>
                                    <i class="fas fa-sort sort-icon opacity-50"></i>
                                <% } %>
                            </a>
                        </th>
                        <th>Statut</th>
                        <th class="text-end">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (trajetsTrouves.isEmpty()) { %>
                        <tr>
                            <td colspan="8" class="text-center py-5 text-muted">
                                <i class="fas fa-inbox fa-3x mb-3 d-block opacity-30"></i>
                                Aucun trajet trouvé.
                            </td>
                        </tr>
                    <% } else { %>
                        <% for (Trajet t : trajetsTrouves) { %>
                        <tr>
                            <td class="fw-bold text-muted">#<%= t.getIdTrajet() %></td>
                            <td class="fw-bold"><i class="fas fa-map-marker-alt text-danger me-2"></i><%= t.getVilleDepart().getNomVille() %></td>
                            <td class="fw-bold"><i class="fas fa-flag-checkered text-success me-2"></i><%= t.getVilleArrivee().getNomVille() %></td>
                            <td><%= t.getDistanceKm() != null ? t.getDistanceKm() : "-" %></td>
                            <td><i class="far fa-clock text-info me-1"></i><%= t.getDureeEstimee() != null ? t.getDureeEstimee() : "-" %></td>
                            <td class="fw-bold text-primary"><%= t.getTarifBase() %> Ar</td>
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
                                    <i class="fas fa-eye"></i>
                                </a>
                                <% if (isAdmin) { %>
                                    <a href="?page=trajet/modifier-trajet&id=<%= t.getIdTrajet() %>"
                                       class="btn btn-sm btn-outline-warning rounded-circle me-1" title="Modifier">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                     <a href="../traitement/trajet/supprimer-trajet.jsp?id=<%= t.getIdTrajet() %>&action=desactiver"
                                       class="btn btn-sm btn-outline-secondary rounded-circle me-1" title="Désactiver"
                                     onclick="return confirm('Désactiver ce trajet ?');">
                                      <i class="fas fa-ban"></i>
                                     </a>
                                       <a href="../traitement/trajet/supprimer-trajet.jsp?id=<%= t.getIdTrajet() %>&action=supprimer"
                                         class="btn btn-sm btn-outline-danger rounded-circle" title="Supprimer"
                                         onclick="return confirm('Supprimer définitivement ?');">
                                          <i class="fas fa-trash"></i>
                                      </a>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    <% } %>
                </tbody>
            </table>
        </div>

        <%-- Pagination --%>
        <% if (totalPages > 1) { %>
        <div class="d-flex justify-content-between align-items-center mt-4">
            <small class="text-muted">
                Page <strong><%= currentPage %></strong> sur <strong><%= totalPages %></strong>
                &mdash; <%= totalItems %> résultat<%= totalItems > 1 ? "s" : "" %>
            </small>
            <nav>
                <ul class="pagination mb-0">
                    <%-- Précédent --%>
                    <li class="page-item <%= currentPage <= 1 ? "disabled" : "" %>">
                        <a class="page-link" href="<%= baseQuery %>page=<%= currentPage - 1 %>">
                            <i class="fas fa-chevron-left"></i>
                        </a>
                    </li>

                    <%-- Numéros de pages --%>
                    <% for (int p = 1; p <= totalPages; p++) {
                        if (p == 1 || p == totalPages || (p >= currentPage - 2 && p <= currentPage + 2)) { %>
                            <li class="page-item <%= p == currentPage ? "active" : "" %>">
                                <a class="page-link" href="<%= baseQuery %>page=<%= p %>"><%= p %></a>
                            </li>
                    <%      } else if (p == currentPage - 3 || p == currentPage + 3) { %>
                            <li class="page-item disabled"><span class="page-link">…</span></li>
                    <%      }
                       } %>

                    <%-- Suivant --%>
                    <li class="page-item <%= currentPage >= totalPages ? "disabled" : "" %>">
                        <a class="page-link" href="<%= baseQuery %>page=<%= currentPage + 1 %>">
                            <i class="fas fa-chevron-right"></i>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
        <% } %>

    </div><%-- /container --%>

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
</body>
</html>
