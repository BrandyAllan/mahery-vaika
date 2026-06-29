<%@ page import="backoffice.Utilisateur, gestion.Depart" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) {
        response.sendRedirect("../index.jsp");
        return;
    }

    String idParam = request.getParameter("id");
    if (idParam == null || idParam.isEmpty()) {
        response.sendRedirect("liste-depart.jsp");
        return;
    }

    int id = 0;
    try { id = Integer.parseInt(idParam); } catch (Exception e) {}
    if (id == 0) {
        response.sendRedirect("liste-depart.jsp");
        return;
    }

    Depart d = Depart.getById(id);
    if (d == null) {
        response.sendRedirect("liste-depart.jsp");
        return;
    }

    boolean isCaissier = user.voirsiadmin().equals("Caissier");

    String badgeClass = "bg-secondary";
    String statut = d.getStatut();
    if ("PLANIFIE".equals(statut))  badgeClass = "bg-primary";
    if ("EN_COURS".equals(statut))  badgeClass = "bg-warning text-dark";
    if ("TERMINE".equals(statut))   badgeClass = "bg-success";
    if ("ANNULE".equals(statut))    badgeClass = "bg-danger";
%>




<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détails du départ #<%= d.getId_depart() %> - Mahery Vaika</title>
    <link rel="stylesheet" href="../assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/bootstrap/icons/bootstrap-icons.min.css">
</head>
<body>
<div class="container mt-4">

    
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>
            <i class="bi bi-send"></i>
            Départ #<%= d.getId_depart() %>
            <span class="badge <%= badgeClass %> fs-6 ms-2"><%= statut %></span>
        </h2>
        <a href="liste-depart.jsp" class="btn btn-secondary btn-sm">
            <i class="bi bi-arrow-left"></i> Retour à la liste
        </a>
    </div>

    <div class="card shadow-sm">
        <div class="card-body">

            <!-- section trajet -->
            <h5 class="text-primary border-bottom pb-2 mb-3">
                <i class="bi bi-signpost-2"></i> Trajet
            </h5>
            <div class="row mb-4">
                <div class="col-md-5 text-center">
                    <p class="text-muted small mb-1">VILLE DE DÉPART</p>
                    <h4 class="fw-bold text-danger">
                        <i class="bi bi-geo-alt-fill"></i> <%= d.getVille_depart() %>
                    </h4>
                </div>
                <div class="col-md-2 d-flex align-items-center justify-content-center">
                    <i class="bi bi-arrow-right fs-2 text-muted"></i>
                </div>
                <div class="col-md-5 text-center">
                    <p class="text-muted small mb-1">VILLE D'ARRIVÉE</p>
                    <h4 class="fw-bold text-success">
                        <i class="bi bi-flag-fill"></i> <%= d.getVille_arrivee() %>
                    </h4>
                </div>
            </div>

            <!-- Infos du trajet -->
            <div class="row g-3 mb-4">
                <div class="col-md-4">
                    <div class="p-3 border rounded text-center">
                        <i class="bi bi-speedometer2 fs-4 text-primary"></i>
                        <p class="text-muted small mb-1 mt-1">DISTANCE</p>
                        <strong><%= d.getDistance_km() %> km</strong>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="p-3 border rounded text-center">
                        <i class="bi bi-clock fs-4 text-info"></i>
                        <p class="text-muted small mb-1 mt-1">DURÉE ESTIMÉE</p>
                        <strong><%= d.getDuree_estimee() != null ? d.getDuree_estimee() : "N/A" %></strong>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="p-3 border rounded text-center bg-light">
                        <i class="bi bi-cash-coin fs-4 text-success"></i>
                        <p class="text-muted small mb-1 mt-1">TARIF DE BASE</p>
                        <strong class="text-success"><%= d.getTarif_base() %> Ar</strong>
                    </div>
                </div>
            </div>

            <!-- section date sy heure -->
            <h5 class="text-primary border-bottom pb-2 mb-3">
                <i class="bi bi-calendar-event"></i> Horaire
            </h5>
            <div class="row mb-4">
                <div class="col-md-6">
                    <p class="mb-1 text-muted">Date de départ</p>
                    <p class="fw-semibold fs-5">
                        <i class="bi bi-calendar3"></i> <%= d.getDate_depart() %>
                    </p>
                </div>
                <div class="col-md-6">
                    <p class="mb-1 text-muted">Heure de départ</p>
                    <p class="fw-semibold fs-5">
                        <i class="bi bi-alarm"></i>
                        <%= d.getHeure_depart() != null ? d.getHeure_depart().toString().substring(0, 5) : "N/A" %>
                    </p>
                </div>
            </div>

            <!-- section voiture sy chauffeur -->
            <h5 class="text-primary border-bottom pb-2 mb-3">
                <i class="bi bi-truck"></i> Affectations
            </h5>
            <div class="row mb-4">
                <div class="col-md-6">
                    <div class="p-3 border rounded">
                        <p class="text-muted small mb-1">VÉHICULE</p>
                        <p class="fw-semibold mb-1">
                            <i class="bi bi-car-front"></i> <%= d.getImmatriculation() %>
                        </p>
                        <p class="text-muted small mb-0">
                            <i class="bi bi-people"></i>
                            Capacité : <%= d.getCapacite_vehicule() %> places
                        </p>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="p-3 border rounded">
                        <p class="text-muted small mb-1">CHAUFFEUR</p>
                        <p class="fw-semibold mb-1">
                            <i class="bi bi-person-badge"></i>
                            <%= d.getNom_chauffeur() %> <%= d.getPrenom_chauffeur() %>
                        </p>
                    </div>
                </div>
            </div>

            <!-- bouton d'action -->
            <div class="d-flex gap-2 mt-3">
                <% if (!isCaissier) { %>
                    <a href="modifier-depart.jsp?id=<%= d.getId_depart() %>"
                       class="btn btn-warning">
                        <i class="bi bi-pencil"></i> Modifier
                    </a>
                    <a href="../traitement/supprimer-depart.jsp?id=<%= d.getId_depart() %>"
                       class="btn btn-danger"
                       onclick="return confirm('Confirmer la suppression de ce départ ?')">
                        <i class="bi bi-trash"></i> Supprimer
                    </a>
                <% } else { %>
                    <button class="btn btn-warning" disabled>
                        <i class="bi bi-pencil"></i> Modifier
                    </button>
                    <button class="btn btn-danger" disabled>
                        <i class="bi bi-trash"></i> Supprimer
                    </button>
                    <small class="text-muted align-self-center ms-2">
                        <i class="bi bi-info-circle"></i>
                        Le caissier ne peut pas modifier ni supprimer un départ.
                    </small>
                <% } %>
            </div>

        </div>
    </div>

</div>
<script src="../assets/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
