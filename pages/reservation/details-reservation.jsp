<%@ page import="backoffice.Reservation, backoffice.Utilisateur" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) {
        response.sendRedirect("../../index.jsp");
        return;
    }
    boolean isAdmin = user.voirsiadmin().equals("Admin");

    String idParam = request.getParameter("id");
    if (idParam == null || idParam.isEmpty()) {
        response.sendRedirect("?page=reservation/liste-reservation");
        return;
    }
    int id;
    try {
        id = Integer.parseInt(idParam);
    } catch (Exception e) {
        response.sendRedirect("?page=reservation/liste-reservation");
        return;
    }
    Reservation r = Reservation.getById(id);
    if (r == null) {
        response.sendRedirect("?page=reservation/liste-reservation");
        return;
    }

    boolean canModify = isAdmin || r.getId_caissier() == user.getId_utilisateur();
%>

<%-- En-tête de page --%>
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <a href="?page=reservation/liste-reservation"
           class="btn btn-sm btn-light text-muted border-0 shadow-sm mb-2 hover-shadow">
            <i class="bi bi-arrow-left"></i> Retour à la liste
        </a>
        <h2 class="fw-bold mb-0" style="color: #2c3e50;">
            <i class="bi bi-calendar2-check-fill text-primary me-2"></i>
            Réservation <span class="font-monospace"><%= r.getNumero_reservation() %></span>
            <span class="badge <%= r.getStatut().equals("CONFIRMEE") ? "bg-success" : "bg-danger" %> fs-6 ms-2 rounded-pill">
                <%= r.getStatut() %>
            </span>
        </h2>
    </div>
    <% if (canModify && r.getStatut().equals("CONFIRMEE")) { %>
    <div class="d-flex gap-2">
        <a href="?page=reservation/modifier-reservation&id=<%= r.getId_reservation() %>"
           class="btn btn-outline-primary shadow-sm">
            <i class="bi bi-pencil me-1"></i> Modifier
        </a>
        <a href="../traitement/annuler-reservation.jsp?id=<%= r.getId_reservation() %>"
           class="btn btn-outline-danger shadow-sm"
           onclick="return confirm('Confirmer l\'annulation de la réservation <%= r.getNumero_reservation() %> ?')">
            <i class="bi bi-x-circle me-1"></i> Annuler
        </a>
    </div>
    <% } %>
</div>

<div class="row g-4">

    <%-- Carte Passager --%>
    <div class="col-lg-6">
        <div class="card border-0 shadow-sm rounded-4 h-100">
            <div class="card-body p-4">
                <h5 class="card-title text-primary fw-bold mb-4">
                    <i class="bi bi-person-fill me-2"></i>Passager
                </h5>
                <div class="row g-3">
                    <div class="col-6">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Nom</p>
                        <p class="fw-bold mb-0"><%= r.getNom_passager() %></p>
                    </div>
                    <div class="col-6">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Prénom</p>
                        <p class="fw-semibold mb-0">
                            <%= r.getPrenom_passager() != null ? r.getPrenom_passager() : "—" %>
                        </p>
                    </div>
                    <div class="col-12"><hr class="my-2 opacity-25"></div>
                    <div class="col-6">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Téléphone</p>
                        <p class="fw-semibold mb-0">
                            <% if (r.getTelephone_passager() != null) { %>
                                <i class="bi bi-telephone-fill text-primary me-1"></i><%= r.getTelephone_passager() %>
                            <% } else { %><span class="text-muted">N/A</span><% } %>
                        </p>
                    </div>
                    <div class="col-6">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Siège</p>
                        <span class="badge bg-light text-dark border fs-6 px-3 py-2">
                            <i class="bi bi-grid-fill me-1"></i>N° <%= r.getNumero_siege() %>
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- Carte Trajet --%>
    <div class="col-lg-6">
        <div class="card border-0 shadow-sm rounded-4 h-100">
            <div class="card-body p-4">
                <h5 class="card-title text-primary fw-bold mb-4">
                    <i class="bi bi-signpost-2-fill me-2"></i>Trajet
                </h5>
                <div class="row align-items-center text-center mb-3">
                    <div class="col-5">
                        <p class="text-muted small fw-semibold text-uppercase mb-1" style="font-size:.72rem;">Départ</p>
                        <h5 class="fw-bold text-danger mb-0">
                            <i class="bi bi-geo-alt-fill me-1"></i><%= r.getVille_depart() %>
                        </h5>
                    </div>
                    <div class="col-2 text-muted">
                        <i class="bi bi-arrow-right fs-4"></i>
                    </div>
                    <div class="col-5">
                        <p class="text-muted small fw-semibold text-uppercase mb-1" style="font-size:.72rem;">Arrivée</p>
                        <h5 class="fw-bold text-success mb-0">
                            <i class="bi bi-flag-fill me-1"></i><%= r.getVille_arrivee() %>
                        </h5>
                    </div>
                </div>
                <hr class="opacity-25">
                <div class="row g-3 mt-1">
                    <div class="col-6">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Date de départ</p>
                        <p class="fw-semibold mb-0">
                            <i class="bi bi-calendar3 me-1 text-primary"></i><%= r.getDate_depart() %>
                        </p>
                    </div>
                    <div class="col-6">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Heure</p>
                        <p class="fw-semibold mb-0">
                            <i class="bi bi-alarm me-1 text-info"></i><%= r.getHeure_depart() %>
                        </p>
                    </div>
                    <div class="col-6">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Durée estimée</p>
                        <p class="fw-semibold mb-0">
                            <i class="bi bi-clock me-1 text-warning"></i>
                            <%= r.getDuree_estimee() != null ? r.getDuree_estimee() : "N/A" %>
                        </p>
                    </div>
                    <div class="col-6">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Tarif de base</p>
                        <p class="fw-bold text-success mb-0 fs-5">
                            <%= String.format("%.2f", r.getTarif_base()) %> <span class="text-muted fw-normal fs-6">Ar</span>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- Carte Informations de réservation --%>
    <div class="col-lg-6">
        <div class="card border-0 shadow-sm rounded-4 h-100">
            <div class="card-body p-4">
                <h5 class="card-title text-primary fw-bold mb-4">
                    <i class="bi bi-receipt me-2"></i>Informations de réservation
                </h5>
                <div class="row g-3">
                    <div class="col-6">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">N° réservation</p>
                        <p class="fw-bold mb-0 font-monospace"><%= r.getNumero_reservation() %></p>
                    </div>
                    <div class="col-6">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Date de réservation</p>
                        <p class="fw-semibold mb-0">
                            <i class="bi bi-calendar-check me-1 text-primary"></i><%= r.getDate_reservation() %>
                        </p>
                    </div>
                    <div class="col-12"><hr class="my-2 opacity-25"></div>
                    <div class="col-6">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Caissier</p>
                        <p class="fw-semibold mb-0">
                            <i class="bi bi-person-badge me-1 text-info"></i><%= r.getNom_caissier() %>
                        </p>
                    </div>
                    <div class="col-6">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Statut</p>
                        <span class="badge <%= r.getStatut().equals("CONFIRMEE") ? "bg-success" : "bg-danger" %> rounded-pill px-3 py-2">
                            <%= r.getStatut() %>
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- Annulation (si annulée) --%>
    <% if (r.getStatut().equals("ANNULEE")) { %>
    <div class="col-lg-6">
        <div class="card border-0 border-danger shadow-sm rounded-4 h-100" style="border-left: 4px solid #dc3545 !important;">
            <div class="card-body p-4">
                <h5 class="card-title text-danger fw-bold mb-4">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>Motif d'annulation
                </h5>
                <p class="fw-semibold mb-0">
                    <%= r.getMotif_annulation() != null ? r.getMotif_annulation() : "Aucun motif renseigné" %>
                </p>
            </div>
        </div>
    </div>
    <% } %>

</div>
