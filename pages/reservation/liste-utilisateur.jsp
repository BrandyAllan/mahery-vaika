<%@ page import="java.util.*, java.sql.Date, backoffice.Utilisateur" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    boolean isAdmin = user.voirsiadmin().equals("Admin");

    String nom = request.getParameter("nom");
    String roleParam = request.getParameter("role");
    String statutParam = request.getParameter("statut");
    String dateDebut = request.getParameter("dateDebut");
    String dateFin = request.getParameter("dateFin");
    String tri = request.getParameter("tri");
    if (tri == null || (!tri.equals("ASC") && !tri.equals("DESC"))) tri = "ASC";
    String pageStr = request.getParameter("page");
    int pageCourante = (pageStr == null) ? 1 : Integer.parseInt(pageStr);
    int limit = 5;
    int offset = (pageCourante - 1) * limit;

    int idRole = 0;
    try { idRole = Integer.parseInt(roleParam); } catch (Exception e) {}
    Boolean statut = null;
    if (statutParam != null && !statutParam.isEmpty()) statut = Boolean.parseBoolean(statutParam);
    java.sql.Date d1 = null, d2 = null;
    try { if (dateDebut != null && !dateDebut.isEmpty()) d1 = java.sql.Date.valueOf(dateDebut); } catch (Exception e) {}
    try { if (dateFin != null && !dateFin.isEmpty()) d2 = java.sql.Date.valueOf(dateFin); } catch (Exception e) {}

    Vector<Utilisateur> liste = Utilisateur.rechercher(nom, idRole, statut, d1, d2, tri, limit, offset);
    int total = Utilisateur.count(nom, idRole, statut, d1, d2);
    int nbPages = (int) Math.ceil((double) total / limit);

    String selectedRole = (roleParam != null && !roleParam.isEmpty()) ? roleParam : "";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Liste des utilisateurs</title>
    <link rel="stylesheet" href="../assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/bootstrap/icons/bootstrap-icons.min.css">
</head>
<body>
<div class="container mt-4">
    <h2>Liste des utilisateurs</h2>
    <a href="gestion-utilisateur.jsp" class="btn btn-secondary mb-3"><i class="bi bi-arrow-left"></i> Retour</a>

    <form method="get" class="row g-3 mb-4">
        <div class="col-md-3">
            <label>Nom</label>
            <input type="text" name="nom" class="form-control" value="<%= nom != null ? nom : "" %>">
        </div>
        <div class="col-md-2">
            <label>Role</label>
            <select name="role" class="form-select">
                <option value="">Tous</option>
                <%
                    Vector<Utilisateur> roles = Utilisateur.getAllRoles();
                    for (Utilisateur r : roles) {
                %>
                    <option value="<%= r.getId_role() %>" <%= selectedRole.equals(String.valueOf(r.getId_role())) ? "selected" : "" %>>
                        <%= r.getNom_role() %>
                    </option>
                <% } %>
            </select>
        </div>
        <div class="col-md-2">
            <label>Statut</label>
            <select name="statut" class="form-select">
                <option value="">Tous</option>
                <option value="true" <%= "true".equals(statutParam) ? "selected" : "" %>>Actif</option>
                <option value="false" <%= "false".equals(statutParam) ? "selected" : "" %>>Inactif</option>
            </select>
        </div>
        <div class="col-md-2">
            <label>Date debut</label>
            <input type="date" name="dateDebut" class="form-control" value="<%= dateDebut != null ? dateDebut : "" %>">
        </div>
        <div class="col-md-2">
            <label>Date fin</label>
            <input type="date" name="dateFin" class="form-control" value="<%= dateFin != null ? dateFin : "" %>">
        </div>
        <div class="col-md-1 d-flex align-items-end">
            <button type="submit" class="btn btn-primary w-100"><i class="bi bi-search"></i></button>
        </div>
    </form>

    <div class="mb-3">
        <span>Trier par nom : </span>
        <a href="?tri=ASC&nom=<%= nom != null ? nom : "" %>&role=<%= roleParam != null ? roleParam : "" %>&statut=<%= statutParam != null ? statutParam : "" %>&dateDebut=<%= dateDebut != null ? dateDebut : "" %>&dateFin=<%= dateFin != null ? dateFin : "" %>" class="btn btn-sm <%= tri.equals("ASC") ? "btn-primary" : "btn-outline-secondary" %>">A → Z</a>
        <a href="?tri=DESC&nom=<%= nom != null ? nom : "" %>&role=<%= roleParam != null ? roleParam : "" %>&statut=<%= statutParam != null ? statutParam : "" %>&dateDebut=<%= dateDebut != null ? dateDebut : "" %>&dateFin=<%= dateFin != null ? dateFin : "" %>" class="btn btn-sm <%= tri.equals("DESC") ? "btn-primary" : "btn-outline-secondary" %>">Z → A</a>
    </div>

    <table class="table table-bordered table-hover">
        <thead class="table-light">
            <tr>
                <th>ID</th><th>Nom</th><th>Prenom</th><th>Role</th><th>Email</th><th>Statut</th>
                <% if (isAdmin) { %><th>Actions</th><% } %>
            </tr>
        </thead>
        <tbody>
            <% if (liste.isEmpty()) { %>
                <tr><td colspan="7" class="text-center">Aucun utilisateur trouve.</td></tr>
            <% } else {
                for (Utilisateur u : liste) { %>
                <tr>
                    <td><%= u.getId_utilisateur() %></td>
                    <td><%= u.getNom() %></td>
                    <td><%= u.getPrenom() %></td>
                    <td><%= u.getNom_role() %></td>
                    <td><%= u.getEmail() %></td>
                    <td><span class="badge <%= u.isActif() ? "bg-success" : "bg-danger" %>"><%= u.isActif() ? "Actif" : "Inactif" %></span></td>
                    <% if (isAdmin) { %>
                    <td>
                        <a href="details-utilisateur.jsp?id=<%= u.getId_utilisateur() %>" class="btn btn-sm btn-info"><i class="bi bi-eye"></i></a>
                        <a href="modifier-utilisateur.jsp?id=<%= u.getId_utilisateur() %>" class="btn btn-sm btn-warning"><i class="bi bi-pencil"></i></a>
                        <a href="../traitement/desactiver-utilisateur.jsp?id=<%= u.getId_utilisateur() %>&actif=<%= !u.isActif() %>" class="btn btn-sm btn-danger" onclick="return confirm('Confirmer la desactivation/reactivation ?')">
                            <i class="bi <%= u.isActif() ? "bi-person-x" : "bi-person-check" %>"></i>
                        </a>
                    </td>
                    <% } %>
                </tr>
            <% }} %>
        </tbody>
    </table>

    <nav>
        <ul class="pagination">
            <% for (int p = 1; p <= nbPages; p++) { %>
                <li class="page-item <%= p == pageCourante ? "active" : "" %>">
                    <a class="page-link" href="?page=<%= p %>&tri=<%= tri %>&nom=<%= nom != null ? nom : "" %>&role=<%= roleParam != null ? roleParam : "" %>&statut=<%= statutParam != null ? statutParam : "" %>&dateDebut=<%= dateDebut != null ? dateDebut : "" %>&dateFin=<%= dateFin != null ? dateFin : "" %>">
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