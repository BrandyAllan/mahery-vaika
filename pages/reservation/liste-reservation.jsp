<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, java.sql.Date, backoffice.Reservation, backoffice.Utilisateur" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) {
        response.sendRedirect("../index.jsp");
        return;
    }

    boolean isAdmin = user.voirsiadmin().equals("Admin");

    String numero = request.getParameter("numero");
    String nomPassager = request.getParameter("nomPassager");
    String trajetParam = request.getParameter("trajet");
    String statutParam = request.getParameter("statut");
    String dateDebut = request.getParameter("dateDebut");
    String dateFin = request.getParameter("dateFin");

    String tri = request.getParameter("tri");
    if (tri == null || (!tri.equals("ASC") && !tri.equals("DESC"))) {
        tri = "DESC";
    }

    String pageStr = request.getParameter("pageNum");
    int pageCourante = 1;
    try {
        if (pageStr != null) pageCourante = Integer.parseInt(pageStr);
    } catch (Exception e) {}

    if (pageCourante < 1) pageCourante = 1;

    int limit = 10;
    int offset = (pageCourante - 1) * limit;

    int idTrajet = 0;
    try {
        if (trajetParam != null && !trajetParam.isEmpty()) {
            idTrajet = Integer.parseInt(trajetParam);
        }
    } catch (Exception e) {}

    String statut = (statutParam != null && !statutParam.isEmpty()) ? statutParam : "";

    java.sql.Date d1 = null, d2 = null;
    try {
        if (dateDebut != null && !dateDebut.isEmpty()) d1 = java.sql.Date.valueOf(dateDebut);
    } catch (Exception e) {}

    try {
        if (dateFin != null && !dateFin.isEmpty()) d2 = java.sql.Date.valueOf(dateFin);
    } catch (Exception e) {}

    Vector<Reservation> liste = Reservation.rechercher(
        numero, nomPassager, idTrajet, statut, d1, d2,
        user.getId_utilisateur(), isAdmin, tri, limit, offset
    );

    int total = Reservation.count(
        numero, nomPassager, idTrajet, statut, d1, d2,
        user.getId_utilisateur(), isAdmin
    );

    int nbPages = (int) Math.ceil((double) total / limit);
    if (nbPages < 1) nbPages = 1;

    Vector<Reservation> trajets = Reservation.getAllTrajets();
    String selectedTrajet = (trajetParam != null && !trajetParam.isEmpty()) ? trajetParam : "";

    String baseUrl = "model.jsp?page=reservation/liste-reservation"
        + "&numero=" + (numero != null ? numero : "")
        + "&nomPassager=" + (nomPassager != null ? nomPassager : "")
        + "&trajet=" + (trajetParam != null ? trajetParam : "")
        + "&statut=" + (statutParam != null ? statutParam : "")
        + "&dateDebut=" + (dateDebut != null ? dateDebut : "")
        + "&dateFin=" + (dateFin != null ? dateFin : "")
        + "&tri=" + tri;
%>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold">Liste des réservations</h2>

        <div class="d-flex gap-2">
            <a href="model.jsp?page=reservation/ajout-reservation" class="btn btn-brand">
                <i class="bi bi-plus-lg"></i> Nouvelle Réservation
            </a>
            <a href="model.jsp?page=reservation/gestion-reservation" class="btn btn-secondary">
                <i class="bi bi-arrow-left"></i> Retour
            </a>
        </div>
    </div>

    <form action="model.jsp" method="get" class="row g-3 mb-4 p-3 border rounded bg-light">
        <input type="hidden" name="page" value="reservation/liste-reservation">

        <div class="col-md-3">
            <label class="form-label">Numéro réservation</label>
            <input type="text" name="numero" class="form-control"
                   value="<%= numero != null ? numero : "" %>" placeholder="RES...">
        </div>

        <div class="col-md-3">
            <label class="form-label">Nom passager</label>
            <input type="text" name="nomPassager" class="form-control"
                   value="<%= nomPassager != null ? nomPassager : "" %>">
        </div>

        <div class="col-md-3">
            <label class="form-label">Trajet</label>
            <select name="trajet" class="form-select">
                <option value="">Tous</option>
                <% for (Reservation t : trajets) { %>
                    <option value="<%= t.getId_trajet() %>"
                        <%= selectedTrajet.equals(String.valueOf(t.getId_trajet())) ? "selected" : "" %>>
                        <%= t.getVille_depart() %> → <%= t.getVille_arrivee() %>
                    </option>
                <% } %>
            </select>
        </div>

        <div class="col-md-3">
            <label class="form-label">Statut</label>
            <select name="statut" class="form-select">
                <option value="">Tous</option>
                <option value="CONFIRMEE" <%= "CONFIRMEE".equals(statutParam) ? "selected" : "" %>>Confirmée</option>
                <option value="ANNULEE" <%= "ANNULEE".equals(statutParam) ? "selected" : "" %>>Annulée</option>
            </select>
        </div>

        <div class="col-md-3">
            <label class="form-label">Date début</label>
            <input type="date" name="dateDebut" class="form-control"
                   value="<%= dateDebut != null ? dateDebut : "" %>">
        </div>

        <div class="col-md-3">
            <label class="form-label">Date fin</label>
            <input type="date" name="dateFin" class="form-control"
                   value="<%= dateFin != null ? dateFin : "" %>">
        </div>

        <div class="col-md-3 d-flex align-items-end">
            <button type="submit" class="btn btn-primary w-100">
                <i class="bi bi-search"></i> Rechercher
            </button>
        </div>

        <div class="col-md-3 d-flex align-items-end">
            <a href="model.jsp?page=reservation/liste-reservation" class="btn btn-outline-secondary w-100">
                Réinitialiser
            </a>
        </div>
    </form>

    <div class="mb-3">
        <span>Trier par date : </span>

        <a href="<%= baseUrl.replace("&tri=" + tri, "&tri=ASC") %>"
           class="btn btn-sm <%= tri.equals("ASC") ? "btn-primary" : "btn-outline-secondary" %>">
            <i class="bi bi-arrow-up-short"></i> Plus ancien
        </a>

        <a href="<%= baseUrl.replace("&tri=" + tri, "&tri=DESC") %>"
           class="btn btn-sm <%= tri.equals("DESC") ? "btn-primary" : "btn-outline-secondary" %>">
            <i class="bi bi-arrow-down-short"></i> Plus récent
        </a>
    </div>

    <div class="table-responsive">
        <table class="table table-bordered table-hover align-middle">
            <thead class="table-light">
                <tr>
                    <th>N° réservation</th>
                    <th>Passager</th>
                    <th>Trajet</th>
                    <th>Date départ</th>
                    <th>Heure</th>
                    <th>Siège</th>
                    <th>Statut</th>
                    <th>Caissier</th>
                    <th>Actions</th>
                </tr>
            </thead>

            <tbody>
                <% if (liste.isEmpty()) { %>
                    <tr>
                        <td colspan="9" class="text-center py-4">Aucune réservation trouvée.</td>
                    </tr>
                <% } else {
                    for (Reservation r : liste) { %>
                        <tr>
                            <td><%= r.getNumero_reservation() %></td>

                            <td>
                                <strong><%= r.getNom_passager() %></strong><br>
                                <small class="text-muted">
                                    <%= r.getPrenom_passager() != null ? r.getPrenom_passager() : "" %>
                                </small>
                            </td>

                            <td>
                                <%= r.getVille_depart() %> → <%= r.getVille_arrivee() %><br>
                                <small class="text-muted">
                                    <%= r.getDuree_estimee() != null ? r.getDuree_estimee() : "" %>
                                </small>
                            </td>

                            <td><%= r.getDate_depart() %></td>
                            <td><%= r.getHeure_depart() %></td>
                            <td><%= r.getNumero_siege() %></td>

                            <td>
                                <span class="badge <%= r.getStatut().equals("CONFIRMEE") ? "bg-success" : "bg-danger" %>">
                                    <%= r.getStatut() %>
                                </span>
                            </td>

                            <td><%= r.getNom_caissier() %></td>

                            <td>
                                <a href="model.jsp?page=reservation/details-reservation&id=<%= r.getId_reservation() %>"
                                   class="btn btn-sm btn-info" title="Détails">
                                    <i class="bi bi-eye"></i>
                                </a>

                                <% if (isAdmin || r.getId_caissier() == user.getId_utilisateur()) { %>
                                    <% if (r.getStatut().equals("CONFIRMEE")) { %>
                                        <a href="model.jsp?page=reservation/modifier-reservation&id=<%= r.getId_reservation() %>"
                                           class="btn btn-sm btn-warning" title="Modifier">
                                            <i class="bi bi-pencil"></i>
                                        </a>

                                        <a href="../traitement/reservation/annuler-reservation.jsp?id=<%= r.getId_reservation() %>"
                                           class="btn btn-sm btn-danger"
                                           title="Annuler"
                                           onclick="return confirm('Confirmer l\'annulation de la réservation <%= r.getNumero_reservation() %> ?')">
                                            <i class="bi bi-x-circle"></i>
                                        </a>
                                    <% } %>
                                <% } %>
                            </td>
                        </tr>
                <% }} %>
            </tbody>
        </table>
    </div>

    <% if (nbPages > 1) { %>
        <nav>
            <ul class="pagination">
                <% for (int p = 1; p <= nbPages; p++) { %>
                    <li class="page-item <%= p == pageCourante ? "active" : "" %>">
                        <a class="page-link" href="<%= baseUrl %>&pageNum=<%= p %>">
                            <%= p %>
                        </a>
                    </li>
                <% } %>
            </ul>
        </nav>
    <% } %>
</div>