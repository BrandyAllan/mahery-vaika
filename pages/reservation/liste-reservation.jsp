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
 
<div class="d-flex justify-content-between align-items-center mb-4">
    <h2 class="fw-bold mb-0">
        <i class="bi bi-calendar2-check text-primary"></i> Liste des Réservations
        <small class="fs-6 text-muted ms-2">(<%= total %> résultat<%= total > 1 ? "s" : "" %>)</small>
    </h2>

    <div class="d-flex gap-2">
        <a href="model.jsp?page=reservation/ajout-reservation" class="btn btn-primary btn-sm">
            <i class="bi bi-plus-lg"></i> Nouvelle Réservation
        </a>
        <a href="model.jsp?page=reservation/gestion-reservation" class="btn btn-outline-secondary btn-sm">
            <i class="bi bi-arrow-left"></i> Retour
        </a>
    </div>
</div>

<div class="card border-0 shadow-sm mb-4">
    <div class="card-body">
        <form action="model.jsp" method="get" class="row g-3 align-items-end">
            <input type="hidden" name="page" value="reservation/liste-reservation">

            <div class="col-md-3">
                <label class="form-label fw-semibold">Numéro réservation</label>
                <input type="text" name="numero" class="form-control form-control-sm"
                       value="<%= numero != null ? numero : "" %>" placeholder="RES...">
            </div>

            <div class="col-md-3">
                <label class="form-label fw-semibold">Nom passager</label>
                <input type="text" name="nomPassager" class="form-control form-control-sm"
                       value="<%= nomPassager != null ? nomPassager : "" %>">
            </div>

            <div class="col-md-3">
                <label class="form-label fw-semibold">Trajet</label>
                <select name="trajet" class="form-select form-select-sm">
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
                <label class="form-label fw-semibold">Statut</label>
                <select name="statut" class="form-select form-select-sm">
                    <option value="">Tous</option>
                    <option value="CONFIRMEE" <%= "CONFIRMEE".equals(statutParam) ? "selected" : "" %>>Confirmée</option>
                    <option value="ANNULEE" <%= "ANNULEE".equals(statutParam) ? "selected" : "" %>>Annulée</option>
                </select>
            </div>

            <div class="col-md-3">
                <label class="form-label fw-semibold">Date début</label>
                <input type="date" name="dateDebut" class="form-control form-control-sm"
                       value="<%= dateDebut != null ? dateDebut : "" %>">
            </div>

            <div class="col-md-3">
                <label class="form-label fw-semibold">Date fin</label>
                <input type="date" name="dateFin" class="form-control form-control-sm"
                       value="<%= dateFin != null ? dateFin : "" %>">
            </div>

            <div class="col-md-3 d-flex align-items-end gap-2">
                <button type="submit" class="btn btn-primary btn-sm">
                    <i class="bi bi-search"></i> Rechercher
                </button>
            </div>

            <div class="col-md-3 d-flex align-items-end">
                <a href="model.jsp?page=reservation/liste-reservation" class="btn btn-outline-secondary btn-sm">
                    Réinitialiser
                </a>
            </div>
        </form>
    </div>
</div>

<div class="d-flex flex-wrap align-items-center gap-2 mb-3">
    <span class="text-muted small fw-semibold">Trier par date :</span>

    <a href="<%= baseUrl.replace("&tri=" + tri, "&tri=ASC") %>"
       class="btn btn-sm <%= tri.equals("ASC") ? "btn-primary" : "btn-outline-secondary" %>">
        <i class="bi bi-arrow-up-short"></i> Plus ancien
    </a>

    <a href="<%= baseUrl.replace("&tri=" + tri, "&tri=DESC") %>"
       class="btn btn-sm <%= tri.equals("DESC") ? "btn-primary" : "btn-outline-secondary" %>">
        <i class="bi bi-arrow-down-short"></i> Plus récent
    </a>
</div>

<div class="card border-0 shadow-sm mb-4">
    <div class="table-responsive">
        <table class="table table-hover table-striped align-middle mb-0">
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
                    <th class="text-end">Actions</th>
                </tr>
            </thead>

            <tbody>
                <% if (liste.isEmpty()) { %>
                    <tr>
                        <td colspan="9" class="text-center text-muted py-5">
                            <i class="bi bi-inbox d-block fs-1 mb-2"></i>
                            Aucune réservation trouvée.
                        </td>
                    </tr>
                <% } else {
                    for (Reservation r : liste) { %>
                        <tr>
                            <td class="fw-semibold text-muted"><%= r.getNumero_reservation() %></td>

                            <td>
                                <strong><%= r.getNom_passager() %></strong><br>
                                <small class="text-muted">
                                    <%= r.getPrenom_passager() != null ? r.getPrenom_passager() : "" %>
                                </small>
                            </td>

                            <td>
                                <span class="fw-semibold"><%= r.getVille_depart() %></span>
                                <i class="bi bi-arrow-right text-muted mx-1"></i>
                                <span class="fw-semibold"><%= r.getVille_arrivee() %></span><br>
                                <small class="text-muted">
                                    <i class="bi bi-clock me-1"></i><%= r.getDuree_estimee() != null ? r.getDuree_estimee() : "" %>
                                </small>
                            </td>

                            <td><%= r.getDate_depart() %></td>
                            <td><%= r.getHeure_depart() %></td>
                            <td><span class="badge bg-light text-dark border">N° <%= r.getNumero_siege() %></span></td>

                            <td>
                                <span class="badge <%= r.getStatut().equals("CONFIRMEE") ? "bg-success" : "bg-danger" %> rounded-pill px-3 py-2">
                                    <%= r.getStatut() %>
                                </span>
                            </td>

                            <td><%= r.getNom_caissier() %></td>

                            <td class="text-end">
                                <a href="model.jsp?page=reservation/details-reservation&id=<%= r.getId_reservation() %>"
                                   class="btn btn-sm btn-outline-info rounded-circle me-1" title="Détails">
                                    <i class="bi bi-eye"></i>
                                </a>

                                <% if (isAdmin || r.getId_caissier() == user.getId_utilisateur()) { %>
                                    <% if (r.getStatut().equals("CONFIRMEE")) { %>
                                        <a href="model.jsp?page=reservation/modifier-reservation&id=<%= r.getId_reservation() %>"
                                           class="btn btn-sm btn-outline-warning rounded-circle me-1" title="Modifier">
                                            <i class="bi bi-pencil"></i>
                                        </a>

                                        <a href="traitement/annuler-reservation.jsp?id=<%= r.getId_reservation() %>"
                                           class="btn btn-sm btn-outline-danger rounded-circle"
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
</div>

<% if (nbPages > 1) { %>
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
           java.util.Iterator<Integer> pagesIterator = pagesToShow.iterator();
            while (pagesIterator.hasNext()) {
                int pIter = pagesIterator.next();
                if (pIter < 1 || pIter > nbPages) pagesIterator.remove();
            }
            int previousPage = 0;
            for (int p : pagesToShow) {
               if (previousPage != 0 && p - previousPage > 1) { %>
                    <button class="join-item btn btn-disabled">...</button>
        <%     }
               previousPage = p;
        %>
            <a class="join-item btn <%= p == pageCourante ? "btn-active" : "" %>"
               href="<%= baseUrl %>&pageNum=<%= p %>"><%= p %></a>
        <%     } %>
    </div>
</nav>
<% } %>