<%@ page import="java.util.*, java.sql.Date, backoffice.Reservation, backoffice.Utilisateur" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    boolean isAdmin = user.voirsiadmin().equals("Admin");

    // Parametres de recherche
    String numero = request.getParameter("numero");
    String nomPassager = request.getParameter("nomPassager");
    String trajetParam = request.getParameter("trajet");
    String statutParam = request.getParameter("statut");
    String dateDebut = request.getParameter("dateDebut");
    String dateFin = request.getParameter("dateFin");
    String tri = request.getParameter("tri");
    if (tri == null || (!tri.equals("ASC") && !tri.equals("DESC"))) tri = "DESC";
    String pageStr = request.getParameter("page");
    int pageCourante = 1;
    try { if (pageStr != null) pageCourante = Integer.parseInt(pageStr); } catch (Exception e) {}
    if (pageCourante < 1) pageCourante = 1;
    int limit = 10;
    int offset = (pageCourante - 1) * limit;

    int idTrajet = 0;
    try { idTrajet = Integer.parseInt(trajetParam); } catch (Exception e) {}
    String statut = (statutParam != null && !statutParam.isEmpty()) ? statutParam : "";
    java.sql.Date d1 = null, d2 = null;
    try { if (dateDebut != null && !dateDebut.isEmpty()) d1 = java.sql.Date.valueOf(dateDebut); } catch (Exception e) {}
    try { if (dateFin != null && !dateFin.isEmpty()) d2 = java.sql.Date.valueOf(dateFin); } catch (Exception e) {}

    Vector<Reservation> liste = Reservation.rechercher(numero, nomPassager, idTrajet, statut, d1, d2,
            user.getId_utilisateur(), isAdmin, tri, limit, offset);
    int total = Reservation.count(numero, nomPassager, idTrajet, statut, d1, d2,
            user.getId_utilisateur(), isAdmin);
    int nbPages = (int) Math.ceil((double) total / limit);

    Vector<Reservation> trajets = Reservation.getAllTrajets();
    String selectedTrajet = (trajetParam != null && !trajetParam.isEmpty()) ? trajetParam : "";
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des reservations</title>
    <link rel="stylesheet" href="../assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/bootstrap/icons/bootstrap-icons.min.css">
</head>
<body>
<div class="container mt-4">
    <h2>Liste des reservations</h2>
    <a href="gestion-reservation.jsp" class="btn btn-secondary mb-3"><i class="bi bi-arrow-left"></i> Retour</a>

    <!-- Formulaire de recherche multicritere -->
    <form method="get" class="row g-3 mb-4 p-3 border rounded bg-light">
        <div class="col-md-3">
            <label>Numero reservation</label>
            <input type="text" name="numero" class="form-control" value="<%= numero != null ? numero : "" %>" placeholder="RES...">
        </div>
        <div class="col-md-3">
            <label>Nom passager</label>
            <input type="text" name="nomPassager" class="form-control" value="<%= nomPassager != null ? nomPassager : "" %>">
        </div>
        <div class="col-md-3">
            <label>Trajet</label>
            <select name="trajet" class="form-select">
                <option value="">Tous</option>
                <% for (Reservation t : trajets) { %>
                    <option value="<%= t.getId_trajet() %>" <%= selectedTrajet.equals(String.valueOf(t.getId_trajet())) ? "selected" : "" %>>
                        <%= t.getVille_depart() %> → <%= t.getVille_arrivee() %>
                    </option>
                <% } %>
            </select>
        </div>
        <div class="col-md-3">
            <label>Statut</label>
            <select name="statut" class="form-select">
                <option value="">Tous</option>
                <option value="CONFIRMEE" <%= "CONFIRMEE".equals(statutParam) ? "selected" : "" %>>Confirmee</option>
                <option value="ANNULEE" <%= "ANNULEE".equals(statutParam) ? "selected" : "" %>>Annulee</option>
            </select>
        </div>
        <div class="col-md-3">
            <label>Date debut</label>
            <input type="date" name="dateDebut" class="form-control" value="<%= dateDebut != null ? dateDebut : "" %>">
        </div>
        <div class="col-md-3">
            <label>Date fin</label>
            <input type="date" name="dateFin" class="form-control" value="<%= dateFin != null ? dateFin : "" %>">
        </div>
        <div class="col-md-3 d-flex align-items-end">
            <button type="submit" class="btn btn-primary w-100"><i class="bi bi-search"></i> Rechercher</button>
        </div>
        <div class="col-md-3 d-flex align-items-end">
            <a href="liste-reservation.jsp" class="btn btn-outline-secondary w-100">Reinitialiser</a>
        </div>
    </form>

    <!-- Tri -->
    <div class="mb-3">
        <span>Trier par date : </span>
        <a href="?tri=ASC&numero=<%= numero != null ? numero : "" %>&nomPassager=<%= nomPassager != null ? nomPassager : "" %>&trajet=<%= trajetParam != null ? trajetParam : "" %>&statut=<%= statutParam != null ? statutParam : "" %>&dateDebut=<%= dateDebut != null ? dateDebut : "" %>&dateFin=<%= dateFin != null ? dateFin : "" %>" 
           class="btn btn-sm <%= tri.equals("ASC") ? "btn-primary" : "btn-outline-secondary" %>">
           <i class="bi bi-arrow-up-short"></i> Plus ancien
        </a>
        <a href="?tri=DESC&numero=<%= numero != null ? numero : "" %>&nomPassager=<%= nomPassager != null ? nomPassager : "" %>&trajet=<%= trajetParam != null ? trajetParam : "" %>&statut=<%= statutParam != null ? statutParam : "" %>&dateDebut=<%= dateDebut != null ? dateDebut : "" %>&dateFin=<%= dateFin != null ? dateFin : "" %>" 
           class="btn btn-sm <%= tri.equals("DESC") ? "btn-primary" : "btn-outline-secondary" %>">
           <i class="bi bi-arrow-down-short"></i> Plus recent
        </a>
    </div>

    <!-- Tableau des reservations -->
    <div class="table-responsive">
        <table class="table table-bordered table-hover align-middle">
            <thead class="table-light">
                <tr>
                    <th>N.Reservation</th>
                    <th>Passager</th>
                    <th>Trajet</th>
                    <th>Date depart</th>
                    <th>Heure</th>
                    <th>Siege</th>
                    <th>Statut</th>
                    <th>Caissier</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (liste.isEmpty()) { %>
                    <tr><td colspan="9" class="text-center">Aucune reservation trouvee.</td></tr>
                <% } else {
                    for (Reservation r : liste) { %>
                    <tr>
                        <td><%= r.getNumero_reservation() %></td>
                        <td>
                            <strong><%= r.getNom_passager() %></strong><br>
                            <small class="text-muted"><%= r.getPrenom_passager() != null ? r.getPrenom_passager() : "" %></small>
                        </td>
                        <td>
                            <%= r.getVille_depart() %> → <%= r.getVille_arrivee() %><br>
                            <small class="text-muted"><%= r.getDuree_estimee() != null ? r.getDuree_estimee() : "" %></small>
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
                            <a href="details-reservation.jsp?id=<%= r.getId_reservation() %>" class="btn btn-sm btn-info" title="Details">
                                <i class="bi bi-eye"></i>
                            </a>
                            <% if (isAdmin || r.getId_caissier() == user.getId_utilisateur()) { %>
                                <% if (r.getStatut().equals("CONFIRMEE")) { %>
                                    <a href="modifier-reservation.jsp?id=<%= r.getId_reservation() %>" class="btn btn-sm btn-warning" title="Modifier">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <a href="../traitement/annuler-reservation.jsp?id=<%= r.getId_reservation() %>" 
                                       class="btn btn-sm btn-danger" title="Annuler"
                                       onclick="return confirm('Confirmer l\'annulation de la reservation <%= r.getNumero_reservation() %> ?')">
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

    <!-- Pagination -->
    <nav>
        <ul class="pagination">
            <% for (int p = 1; p <= nbPages; p++) { %>
                <li class="page-item <%= p == pageCourante ? "active" : "" %>">
                    <a class="page-link" href="?page=<%= p %>&tri=<%= tri %>&numero=<%= numero != null ? numero : "" %>&nomPassager=<%= nomPassager != null ? nomPassager : "" %>&trajet=<%= trajetParam != null ? trajetParam : "" %>&statut=<%= statutParam != null ? statutParam : "" %>&dateDebut=<%= dateDebut != null ? dateDebut : "" %>&dateFin=<%= dateFin != null ? dateFin : "" %>">
                        <%= p %>
                    </a>
                </li>
            <% } %>
        </ul>
    </nav>
</div>
<script src="../assets/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
