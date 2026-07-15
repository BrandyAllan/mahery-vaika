<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, backoffice.Utilisateur, gestion.Depart, gestion.Trajet, gestion.Vehicule, gestion.Chauffeur" %>

<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) {
        response.sendRedirect("../index.jsp");
        return;
    }

    boolean isCaissier = "Caissier".equals(user.voirsiadmin());

    String trajetParam    = request.getParameter("id_trajet");
    String vehiculeParam  = request.getParameter("id_vehicule");
    String chauffeurParam = request.getParameter("id_chauffeur");
    String dateDebut      = request.getParameter("dateDebut");
    String dateFin        = request.getParameter("dateFin");
    String statutParam    = request.getParameter("statut");
    String tri            = request.getParameter("tri");

    if (tri == null || (!tri.equals("ASC") && !tri.equals("DESC"))) {
        tri = "ASC";
    }

    int pageCourante = 1;
    try {
        String pageStr = request.getParameter("pageNum");
        if (pageStr != null && !pageStr.isEmpty()) {
            pageCourante = Integer.parseInt(pageStr);
        }
    } catch (Exception e) {
        pageCourante = 1;
    }

    int limit = 5;
    int offset = (pageCourante - 1) * limit;

    int idTrajet = 0;
    int idVehicule = 0;
    int idChauffeur = 0;

    try { idTrajet = Integer.parseInt(trajetParam); } catch (Exception e) {}
    try { idVehicule = Integer.parseInt(vehiculeParam); } catch (Exception e) {}
    try { idChauffeur = Integer.parseInt(chauffeurParam); } catch (Exception e) {}

    java.sql.Date d1 = null;
    java.sql.Date d2 = null;

    try {
        if (dateDebut != null && !dateDebut.isEmpty()) {
            d1 = java.sql.Date.valueOf(dateDebut);
        }
    } catch (Exception e) {}

    try {
        if (dateFin != null && !dateFin.isEmpty()) {
            d2 = java.sql.Date.valueOf(dateFin);
        }
    } catch (Exception e) {}

    Vector<Depart> liste = Depart.rechercher(
        idTrajet,
        idVehicule,
        idChauffeur,
        d1,
        d2,
        statutParam,
        tri,
        limit,
        offset
    );

    int total = Depart.count(
        idTrajet,
        idVehicule,
        idChauffeur,
        d1,
        d2,
        statutParam
    );

    int nbPages = (int) Math.ceil((double) total / limit);

    Trajet trajetGestion = new Trajet();
    List<Trajet> tousLesTrajets = trajetGestion.getTrajetsActifs();
    List<Vehicule> tousLesVehicules = Vehicule.getVehiculesActifs();
    List<Chauffeur> tousLesChauffeurs;
    try {
        tousLesChauffeurs = (List<Chauffeur>) Chauffeur.getTousActifs();
    } catch (Exception e) {
        tousLesChauffeurs = new java.util.ArrayList<>();
    }

    String msg = request.getParameter("msg");
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2 class="fw-bold mb-0">
        <i class="bi bi-send text-primary"></i> Liste des départs
        <small class="fs-6 text-muted ms-2">(<%= total %> résultat<%= total > 1 ? "s" : "" %>)</small>
    </h2>
    <a href="?page=departs/gestion-departs" class="btn btn-outline-secondary btn-sm">
        <i class="bi bi-arrow-left"></i> Retour
    </a>
</div>

<% if ("ajout_ok".equals(msg)) { %>
    <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm">
        <i class="bi bi-check-circle"></i>
        Depart ajoute avec succès.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
<% } else if ("modif_ok".equals(msg)) { %>
    <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm">
        <i class="bi bi-check-circle"></i>
        Depart modifie avec succès.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
<% } else if ("supp_ok".equals(msg)) { %>
    <div class="alert alert-warning alert-dismissible fade show msg-banner">
        <i class="bi bi-trash"></i>
        Depart supprime.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
<% } else if ("not_found".equals(msg)) { %>
    <div class="alert alert-danger alert-dismissible fade show msg-banner">
        <i class="bi bi-exclamation-triangle"></i>
        Depart introuvable ou suppression impossible.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
<% } %>

<div class="card border-0 shadow-sm mb-4">
    <div class="card-body">

        <form method="get" class="row g-3 align-items-end">

            <input type="hidden" name="page" value="departs/liste-depart">
            <input type="hidden" name="pageNum" value="1">

            <div class="col-md-3">
                <label class="form-label fw-semibold">Trajet</label>

                <select name="id_trajet" class="form-select form-select-sm">
                    <option value="">Tous les trajets</option>

                    <% for (Trajet t : tousLesTrajets) { %>
                        <option value="<%= t.getIdTrajet() %>"
                            <%= t.getIdTrajet() == idTrajet ? "selected" : "" %>>

                            <%= t.getVilleDepart() != null ? t.getVilleDepart().getNomVille() : "" %>
                            →
                            <%= t.getVilleArrivee() != null ? t.getVilleArrivee().getNomVille() : "" %>

                        </option>
                    <% } %>
                </select>
            </div>

            <div class="col-md-2">
                <label class="form-label fw-semibold">Vehicule</label>

                <select name="id_vehicule" class="form-select form-select-sm">
                    <option value="">Tous</option>

                    <% for (Vehicule v : tousLesVehicules) { %>
                        <option value="<%= v.getIdVehicule() %>"
                            <%= v.getIdVehicule() == idVehicule ? "selected" : "" %>>
                            <%= v.getImmatriculation() %>
                        </option>
                    <% } %>
                </select>
            </div>

            <div class="col-md-2">
                <label class="form-label fw-semibold">Chauffeur</label>

                <select name="id_chauffeur" class="form-select form-select-sm">
                    <option value="">Tous</option>

                    <% for (Chauffeur c : tousLesChauffeurs) { %>
                        <option value="<%= c.getIdChauffeur() %>"
                            <%= c.getIdChauffeur() == idChauffeur ? "selected" : "" %>>
                            <%= c.getNom() %>
                            <%= c.getPrenom() != null ? c.getPrenom() : "" %>
                        </option>
                    <% } %>
                </select>
            </div>

            <div class="col-md-2">
                <label class="form-label fw-semibold">Statut</label>

                <select name="statut" class="form-select form-select-sm">
                    <option value="">Tous</option>
                    <option value="PLANIFIE" <%= "PLANIFIE".equals(statutParam) ? "selected" : "" %>>Planifie</option>
                    <option value="EN_COURS" <%= "EN_COURS".equals(statutParam) ? "selected" : "" %>>En cours</option>
                    <option value="TERMINE" <%= "TERMINE".equals(statutParam) ? "selected" : "" %>>Termine</option>
                    <option value="ANNULE" <%= "ANNULE".equals(statutParam) ? "selected" : "" %>>Annule</option>
                </select>
            </div>

            <div class="col-md-2">
                <label class="form-label fw-semibold">Date debut</label>

                <input
                    type="date"
                    name="dateDebut"
                    class="form-control form-control-sm"
                    value="<%= dateDebut != null ? dateDebut : "" %>">
            </div>

            <div class="col-md-2">
                <label class="form-label fw-semibold">Date fin</label>

                <input
                    type="date"
                    name="dateFin"
                    class="form-control form-control-sm"
                    value="<%= dateFin != null ? dateFin : "" %>">
            </div>

            <div class="col-md-2 d-flex align-items-end gap-2">
                <button type="submit" class="btn btn-primary btn-sm">
                    <i class="bi bi-search"></i>
                    Rechercher
                </button>

                <a href="?page=departs/liste-depart" class="btn btn-outline-secondary btn-sm">
                    Reinitialiser
                </a>
            </div>

        </form>

    </div>
</div>

<div class="d-flex flex-wrap align-items-center gap-2 mb-3">

    <span class="text-muted small fw-semibold">Trier par date :</span>

    <a href="?page=departs/liste-depart&tri=ASC&pageNum=1&id_trajet=<%= trajetParam != null ? trajetParam : "" %>&id_vehicule=<%= vehiculeParam != null ? vehiculeParam : "" %>&id_chauffeur=<%= chauffeurParam != null ? chauffeurParam : "" %>&statut=<%= statutParam != null ? statutParam : "" %>&dateDebut=<%= dateDebut != null ? dateDebut : "" %>&dateFin=<%= dateFin != null ? dateFin : "" %>"
       class="btn btn-sm <%= tri.equals("ASC") ? "btn-primary" : "btn-outline-secondary" %>">
        A → Z
    </a>

    <a href="?page=departs/liste-depart&tri=DESC&pageNum=1&id_trajet=<%= trajetParam != null ? trajetParam : "" %>&id_vehicule=<%= vehiculeParam != null ? vehiculeParam : "" %>&id_chauffeur=<%= chauffeurParam != null ? chauffeurParam : "" %>&statut=<%= statutParam != null ? statutParam : "" %>&dateDebut=<%= dateDebut != null ? dateDebut : "" %>&dateFin=<%= dateFin != null ? dateFin : "" %>"
       class="btn btn-sm <%= tri.equals("DESC") ? "btn-primary" : "btn-outline-secondary" %>">
        Z → A
    </a>

    <span class="text-muted small ms-auto">
        Total :
        <strong><%= total %></strong>
        depart(s) trouve(s)
    </span>

</div>

<div class="card border-0 shadow-sm mb-4">
    <div class="table-responsive">

        <table class="table table-hover table-striped align-middle mb-0">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Trajet</th>
                    <th>Vehicule</th>
                    <th>Chauffeur</th>
                    <th>Date</th>
                    <th>Heure</th>
                    <th>Statut</th>

                    <% if (!isCaissier) { %>
                        <th>Actions</th>
                    <% } %>
                </tr>
            </thead>

            <tbody>
                <% if (liste.isEmpty()) { %>

                    <tr>
                        <td colspan="<%= isCaissier ? 7 : 8 %>" class="text-center text-muted py-5">
                            <i class="bi bi-inbox d-block fs-1 mb-2"></i>
                            Aucun depart trouve.
                        </td>
                    </tr>

                <% } else { %>

                    <% for (Depart d : liste) { %>

                        <tr>
                            <td class="fw-semibold text-muted">
                                #<%= d.getId_depart() %>
                            </td>

                            <td>
                                <span class="fw-semibold"><%= d.getVille_depart() %></span>
                                <i class="bi bi-arrow-right text-muted mx-1"></i>
                                <span class="fw-semibold"><%= d.getVille_arrivee() %></span>
                            </td>

                            <td><%= d.getImmatriculation() %></td>

                            <td>
                                <%= d.getNom_chauffeur() %>
                                <%= d.getPrenom_chauffeur() %>
                            </td>

                            <td><%= d.getDate_depart() %></td>

                            <td><%= d.getHeure_depart() %></td>

                            <td>
                                <%
                                    String s = d.getStatut();
                                    String badgeClass = "bg-secondary";

                                    if ("PLANIFIE".equals(s)) {
                                        badgeClass = "bg-primary";
                                    } else if ("EN_COURS".equals(s)) {
                                        badgeClass = "bg-warning text-dark";
                                    } else if ("TERMINE".equals(s)) {
                                        badgeClass = "bg-success";
                                    } else if ("ANNULE".equals(s)) {
                                        badgeClass = "bg-danger";
                                    }
                                %>

                                <span class="badge <%= badgeClass %> rounded-pill px-3 py-2">
                                    <%= s %>
                                </span>
                            </td>

                            <% if (!isCaissier) { %>

                                <td>
                                    <a href="?page=departs/details-depart&id=<%= d.getId_depart() %>" class="btn btn-sm btn-outline-info rounded-circle me-1" title="Détails">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                    <a href="?page=departs/modifier-depart&id=<%= d.getId_depart() %>" class="btn btn-sm btn-outline-warning rounded-circle me-1" title="Modifier">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <a href="../traitement/departs/supprimer-depart.jsp?id=<%= d.getId_depart() %>" class="btn btn-sm btn-outline-danger rounded-circle" title="Supprimer" onclick="return confirm('Confirmer la suppression de ce départ ?')">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                </td>

                            <% } %>

                        </tr>

                    <% } %>

                <% } %>
            </tbody>
        </table>

    </div>
</div>

<% if (nbPages > 1) {
    String paginationBaseUrl = "?page=departs/liste-depart&tri=" + tri
            + "&id_trajet=" + (trajetParam != null ? trajetParam : "")
            + "&id_vehicule=" + (vehiculeParam != null ? vehiculeParam : "")
            + "&id_chauffeur=" + (chauffeurParam != null ? chauffeurParam : "")
            + "&statut=" + (statutParam != null ? statutParam : "")
            + "&dateDebut=" + (dateDebut != null ? dateDebut : "")
            + "&dateFin=" + (dateFin != null ? dateFin : "");
%>

    <nav>
        <div class="join">
            <% java.util.TreeSet<Integer> pagesToShow = new java.util.TreeSet<>();
               pagesToShow.add(1);
               pagesToShow.add(2);
               pagesToShow.add(nbPages - 1);
               pagesToShow.add(nbPages);
               pagesToShow.add(pageCourante - 1);
               pagesToShow.add(pageCourante);
               pagesToShow.add(pageCourante + 1);
               pagesToShow.removeIf(p -> p < 1 || p > nbPages);
               int previousPage = 0;
               for (int p : pagesToShow) {
                   if (previousPage != 0 && p - previousPage > 1) { %>
                        <button class="join-item btn btn-disabled">...</button>
            <%     }
                   previousPage = p;
            %>
                <a class="join-item btn <%= p == pageCourante ? "btn-active" : "" %>"
                   href="<%= paginationBaseUrl %>&pageNum=<%= p %>"><%= p %></a>
            <%     } %>
        </div>
    </nav>

<% } %>