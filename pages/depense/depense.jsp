<%@ page import="java.util.*, java.sql.Date, backoffice.Depense, backoffice.Utilisateur" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) {
        response.sendRedirect("../../index.jsp");
        return;
    }
    String role = user.voirsiadmin();
    if (!role.equals("Admin") && !role.equals("Superviseur")) {
        response.sendRedirect("../utilisateur/gestion-utilisateur.jsp");
        return;
    }

    String recherche = request.getParameter("recherche");
    String tri = request.getParameter("tri");
    if (tri == null || (!tri.equals("ASC") && !tri.equals("DESC"))) tri = "DESC";
    String dateDebut = request.getParameter("dateDebut");
    String dateFin = request.getParameter("dateFin");
    String pageStr = request.getParameter("pageNum");
    int pageCourante = (pageStr == null) ? 1 : Integer.parseInt(pageStr);
    int limit = 10;
    int offset = (pageCourante - 1) * limit;

    Date d1 = null, d2 = null;
    if (dateDebut != null && !dateDebut.isEmpty()) d1 = Date.valueOf(dateDebut);
    if (dateFin != null && !dateFin.isEmpty()) d2 = Date.valueOf(dateFin);

    Vector<Depense> liste = Depense.rechercher(recherche, tri, d1, d2, limit, offset);
    int total = Depense.count(recherche, d1, d2);
    int nbPages = (int) Math.ceil((double) total / limit);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des depenses</title>
    <link rel="stylesheet" href="../../assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="../../assets/icons/bootstrap-icons.min.css">
</head>
<body>
<div class="container mt-4">
    <h2>Gestion des depenses</h2>
    <div class="d-flex flex-wrap gap-2 mb-3">
        <a href="?page=depense/ajout-depense" class="btn btn-primary"><i class="bi bi-plus-circle"></i> Nouvelle depense</a>
        <a href="?page=dashboard/dashoard" class="btn btn-secondary"><i class="bi bi-arrow-left"></i> Retour</a>
    </div>

    <form method="get" class="row g-3 mb-4">
        <input type="hidden" name="page" value="depense/depense">

        <div class="col-12 col-md-4">
            <label>Recherche </label>
            <input type="text" name="recherche" class="form-control" value="<%= recherche != null ? recherche : "" %>">
        </div>
        <div class="col-6 col-md-2">
            <label>Date debut</label>
            <input type="date" name="dateDebut" class="form-control" value="<%= dateDebut != null ? dateDebut : "" %>">
        </div>
        <div class="col-6 col-md-2">
            <label>Date fin</label>
            <input type="date" name="dateFin" class="form-control" value="<%= dateFin != null ? dateFin : "" %>">
        </div>
        <div class="col-6 col-md-2">
            <label>Tri</label>
            <select name="tri" class="form-select">
                <option value="ASC" <%= tri.equals("ASC") ? "selected" : "" %>>Date croissante</option>
                <option value="DESC" <%= tri.equals("DESC") ? "selected" : "" %>>Date decroissante</option>
            </select>
        </div>
        <div class="col-6 col-md-2 d-flex align-items-end">
            <button type="submit" class="btn btn-primary w-100"><i class="bi bi-search"></i></button>
        </div>
    </form>

    <div class="table-responsive">
        <table class="table table-bordered table-hover">
            <thead class="table-light">
                <tr>
                    <th>ID</th>
                    <th>Type</th>
                    <th>Description</th>
                    <th>Montant (Ariary)</th>
                    <th>Date</th>
                    <th>Vehicule</th>
                    <th>Utilisateur</th>
                </tr>
            </thead>
            <tbody>
                <% if (liste.isEmpty()) { %>
                    <tr><td colspan="7" class="text-center">Aucune depense trouvee.</td></tr>
                <% } else {
                    for (Depense d : liste) { %>
                    <tr>
                        <td><%= d.getId_depense() %></td>
                        <td><%= d.getType_depense() %></td>
                        <td><%= d.getDescription() != null ? d.getDescription() : "" %></td>
                        <td><%= Depense.formatMontant(d.getMontant()) %></td>
                        <td><%= d.getDate_depense() %></td>
                        <td><%= d.getId_vehicule() != null ? d.getId_vehicule() : "N/A" %></td>
                        <td><%= d.getId_utilisateur() != null ? d.getId_utilisateur() : "N/A" %></td>
                    </tr>
                <% }} %>
            </tbody>
        </table>
    </div>

    <nav>
        <ul class="pagination flex-wrap">
            <% for (int p = 1; p <= nbPages; p++) { %>
                <li class="page-item <%= p == pageCourante ? "active" : "" %>">
                    <a class="page-link" href="?pageNum=<%= p %>&recherche=<%= recherche != null ? recherche : "" %>&tri=<%= tri %>&dateDebut=<%= dateDebut != null ? dateDebut : "" %>&dateFin=<%= dateFin != null ? dateFin : "" %>">
                        <%= p %>
                    </a>
                </li>
            <% } %>
        </ul>
    </nav>
</div>
<script src="../../assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>