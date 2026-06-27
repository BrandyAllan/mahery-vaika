<%@ page import="java.util.*, java.sql.Date, backoffice.Utilisateur, backoffice.Depart" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    boolean isCaissier = user.voirsiadmin().equals("Caissier");

    String trajetParam   = request.getParameter("id_trajet");
    String vehiculeParam = request.getParameter("id_vehicule");
    String chauffeurParam= request.getParameter("id_chauffeur");
    String dateDebut     = request.getParameter("dateDebut");
    String dateFin       = request.getParameter("dateFin");
    String statutParam   = request.getParameter("statut");
    String tri           = request.getParameter("tri");
    if (tri == null || (!tri.equals("ASC") && !tri.equals("DESC"))) tri = "ASC";

    String pageStr = request.getParameter("page");
    int pageCourante = (pageStr == null) ? 1 : Integer.parseInt(pageStr);
    int limit  = 5;
    int offset = (pageCourante - 1) * limit;

    int idTrajet    = 0;
    int idVehicule  = 0;
    int idChauffeur = 0;
    try { idTrajet    = Integer.parseInt(trajetParam);   } catch (Exception e) {}
    try { idVehicule  = Integer.parseInt(vehiculeParam); } catch (Exception e) {}
    try { idChauffeur = Integer.parseInt(chauffeurParam);} catch (Exception e) {}

    java.sql.Date d1 = null, d2 = null;
    try { if (dateDebut != null && !dateDebut.isEmpty()) d1 = java.sql.Date.valueOf(dateDebut); } catch (Exception e) {}
    try { if (dateFin   != null && !dateFin.isEmpty())   d2 = java.sql.Date.valueOf(dateFin);   } catch (Exception e) {}

    Vector<Depart> liste = Depart.rechercher(idTrajet, idVehicule, idChauffeur, d1, d2, statutParam, tri, limit, offset);
    int total   = Depart.count(idTrajet, idVehicule, idChauffeur, d1, d2, statutParam);
    int nbPages = (int) Math.ceil((double) total / limit);

    Vector<Depart> tousLesTrajets   = Depart.getTousLesTrajets();
    Vector<Depart> tousLesVehicules = Depart.getTousLesVehicules();
    Vector<Depart> tousLesChauffeurs= Depart.getTousLesChauffeurs();

    String msg = request.getParameter("msg");
%>



<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des départs - Mahery Vaika</title>
    <link rel="stylesheet" href="../assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/bootstrap/icons/bootstrap-icons.min.css">
</head>
<body>
<div class="container mt-4">

    <!-- En-tête -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2><i class="bi bi-send"></i> Liste des départs</h2>
        <a href="gestion-depart.jsp" class="btn btn-secondary btn-sm">
            <i class="bi bi-arrow-left"></i> Retour
        </a>
    </div>

    <!-- Message succès / erreur avy am traitement -->
    <% if ("ajout_ok".equals(msg)) { %>
        <div class="alert alert-success alert-dismissible fade show">
            <i class="bi bi-check-circle"></i> Départ ajouté avec succès.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } else if ("modif_ok".equals(msg)) { %>
        <div class="alert alert-success alert-dismissible fade show">
            <i class="bi bi-check-circle"></i> Départ modifié avec succès.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } else if ("supp_ok".equals(msg)) { %>
        <div class="alert alert-warning alert-dismissible fade show">
            <i class="bi bi-trash"></i> Départ supprimé.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <!-- formulaire recherche -->
    <form method="get" class="row g-2 mb-3 p-3 bg-light rounded border">

        <!-- filtre Trajet -->
        <div class="col-md-3">
            <label class="form-label fw-semibold">Trajet</label>
            <select name="id_trajet" class="form-select form-select-sm">
                <option value="">Tous les trajets</option>
                <% for (Depart t : tousLesTrajets) { %>
                    <option value="<%= t.getId_trajet() %>"
                        <%= t.getId_trajet() == idTrajet ? "selected" : "" %>>
                        <%= t.getVille_depart() %> → <%= t.getVille_arrivee() %>
                    </option>
                <% } %>
            </select>
        </div>

        <!-- filtre Véhicule -->
        <div class="col-md-2">
            <label class="form-label fw-semibold">Véhicule</label>
            <select name="id_vehicule" class="form-select form-select-sm">
                <option value="">Tous</option>
                <% for (Depart v : tousLesVehicules) { %>
                    <option value="<%= v.getId_vehicule() %>"
                        <%= v.getId_vehicule() == idVehicule ? "selected" : "" %>>
                        <%= v.getImmatriculation() %>
                    </option>
                <% } %>
            </select>
        </div>

        <!-- filtre Chauffeur -->
        <div class="col-md-2">
            <label class="form-label fw-semibold">Chauffeur</label>
            <select name="id_chauffeur" class="form-select form-select-sm">
                <option value="">Tous</option>
                <% for (Depart c : tousLesChauffeurs) { %>
                    <option value="<%= c.getId_chauffeur() %>"
                        <%= c.getId_chauffeur() == idChauffeur ? "selected" : "" %>>
                        <%= c.getNom_chauffeur() %> <%= c.getPrenom_chauffeur() %>
                    </option>
                <% } %>
            </select>
        </div>

        <!-- filtre Statut -->
        <div class="col-md-2">
            <label class="form-label fw-semibold">Statut</label>
            <select name="statut" class="form-select form-select-sm">
                <option value="">Tous</option>
                <option value="PLANIFIE"  <%= "PLANIFIE".equals(statutParam)  ? "selected" : "" %>>Planifié</option>
                <option value="EN_COURS"  <%= "EN_COURS".equals(statutParam)  ? "selected" : "" %>>En cours</option>
                <option value="TERMINE"   <%= "TERMINE".equals(statutParam)   ? "selected" : "" %>>Terminé</option>
                <option value="ANNULE"    <%= "ANNULE".equals(statutParam)    ? "selected" : "" %>>Annulé</option>
            </select>
        </div>

        <!-- filtre Date début -->
        <div class="col-md-2">
            <label class="form-label fw-semibold">Date début</label>
            <input type="date" name="dateDebut" class="form-control form-control-sm"
                   value="<%= dateDebut != null ? dateDebut : "" %>">
        </div>

        <!-- filtre Date fin -->
        <div class="col-md-2">
            <label class="form-label fw-semibold">Date fin</label>
            <input type="date" name="dateFin" class="form-control form-control-sm"
                   value="<%= dateFin != null ? dateFin : "" %>">
        </div>

        <!--boutons Rechercher / Réinitialiser -->
        <div class="col-md-2 d-flex align-items-end gap-2">
            <button type="submit" class="btn btn-primary btn-sm">
                <i class="bi bi-search"></i> Rechercher
            </button>
            <a href="liste-depart.jsp" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-x-circle"></i>
            </a>
        </div>

    </form>

    <!-- barre de tri -->
    <div class="mb-3 d-flex align-items-center gap-2">
        <span class="text-muted small">Trier par date :</span>
        <a href="?tri=ASC&id_trajet=<%= trajetParam != null ? trajetParam : "" %>&id_vehicule=<%= vehiculeParam != null ? vehiculeParam : "" %>&id_chauffeur=<%= chauffeurParam != null ? chauffeurParam : "" %>&statut=<%= statutParam != null ? statutParam : "" %>&dateDebut=<%= dateDebut != null ? dateDebut : "" %>&dateFin=<%= dateFin != null ? dateFin : "" %>"
           class="btn btn-sm <%= tri.equals("ASC") ? "btn-primary" : "btn-outline-secondary" %>">
            A → Z
        </a>
        <a href="?tri=DESC&id_trajet=<%= trajetParam != null ? trajetParam : "" %>&id_vehicule=<%= vehiculeParam != null ? vehiculeParam : "" %>&id_chauffeur=<%= chauffeurParam != null ? chauffeurParam : "" %>&statut=<%= statutParam != null ? statutParam : "" %>&dateDebut=<%= dateDebut != null ? dateDebut : "" %>&dateFin=<%= dateFin != null ? dateFin : "" %>"
           class="btn btn-sm <%= tri.equals("DESC") ? "btn-primary" : "btn-outline-secondary" %>">
            Z → A
        </a>
        <span class="text-muted small ms-auto">
            Total : <strong><%= total %></strong> départ(s) trouvé(s)
        </span>
    </div>

    <!-- tableau depart -->
    <table class="table table-bordered table-hover align-middle">
        <thead class="table-dark">
            <tr>
                <th>#</th>
                <th>Trajet</th>
                <th>Véhicule</th>
                <th>Chauffeur</th>
                <th>Date</th>
                <th>Heure</th>
                <th>Statut</th>
                <% if (!isCaissier) { %><th>Actions</th><% } %>
            </tr>
        </thead>
        <tbody>
            <% if (liste.isEmpty()) { %>
                <tr>
                    <td colspan="<%= isCaissier ? 7 : 8 %>" class="text-center text-muted py-4">
                        <i class="bi bi-inbox"></i> Aucun départ trouvé.
                    </td>
                </tr>
            <% } else {
                for (Depart d : liste) { %>
                <tr>
                    <td><%= d.getId_depart() %></td>
                    <td>
                        <span class="fw-semibold"><%= d.getVille_depart() %></span>
                        <i class="bi bi-arrow-right text-muted"></i>
                        <span class="fw-semibold"><%= d.getVille_arrivee() %></span>
                    </td>
                    <td><%= d.getImmatriculation() %></td>
                    <td><%= d.getNom_chauffeur() %> <%= d.getPrenom_chauffeur() %></td>
                    <td><%= d.getDate_depart() %></td>
                    <td><%= d.getHeure_depart() %></td>
                    <td>
                        <%
                            String s = d.getStatut();
                            String badgeClass = "bg-secondary";
                            if ("PLANIFIE".equals(s))  badgeClass = "bg-primary";
                            if ("EN_COURS".equals(s))  badgeClass = "bg-warning text-dark";
                            if ("TERMINE".equals(s))   badgeClass = "bg-success";
                            if ("ANNULE".equals(s))    badgeClass = "bg-danger";
                        %>
                        <span class="badge <%= badgeClass %>"><%= s %></span>
                    </td>
                    <% if (!isCaissier) { %>
                    <td>
                        <!-- détails -->
                        <a href="details-depart.jsp?id=<%= d.getId_depart() %>"
                           class="btn btn-sm btn-info" title="Détails">
                            <i class="bi bi-eye"></i>
                        </a>
                        <!-- modifier -->
                        <a href="modifier-depart.jsp?id=<%= d.getId_depart() %>"
                           class="btn btn-sm btn-warning" title="Modifier">
                            <i class="bi bi-pencil"></i>
                        </a>
                        <!-- supprimer avec confirmation -->
                        <a href="../traitement/supprimer-depart.jsp?id=<%= d.getId_depart() %>"
                           class="btn btn-sm btn-danger" title="Supprimer"
                           onclick="return confirm('Confirmer la suppression de ce départ ?')">
                            <i class="bi bi-trash"></i>
                        </a>
                    </td>
                    <% } %>
                </tr>
            <% }} %>
        </tbody>
    </table>

    <!-- pagination -->
    <% if (nbPages > 1) { %>
    <nav>
        <ul class="pagination pagination-sm">
            <% for (int p = 1; p <= nbPages; p++) { %>
                <li class="page-item <%= p == pageCourante ? "active" : "" %>">
                    <a class="page-link"
                       href="?page=<%= p %>&tri=<%= tri %>&id_trajet=<%= trajetParam != null ? trajetParam : "" %>&id_vehicule=<%= vehiculeParam != null ? vehiculeParam : "" %>&id_chauffeur=<%= chauffeurParam != null ? chauffeurParam : "" %>&statut=<%= statutParam != null ? statutParam : "" %>&dateDebut=<%= dateDebut != null ? dateDebut : "" %>&dateFin=<%= dateFin != null ? dateFin : "" %>">
                        <%= p %>
                    </a>
                </li>
            <% } %>
        </ul>
    </nav>
    <% } %>

</div>
<script src="../assets/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
