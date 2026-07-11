<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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

    if (tri == null || (!tri.equals("ASC") && !tri.equals("DESC"))) {
        tri = "ASC";
    }

    String pageStr = request.getParameter("pageNum");
    int pageCourante = 1;

    try {
        if (pageStr != null && !pageStr.isEmpty()) {
            pageCourante = Integer.parseInt(pageStr);
        }
    } catch (Exception e) {
        pageCourante = 1;
    }

    if (pageCourante < 1) {
        pageCourante = 1;
    }

    int limit = 5;
    int offset = (pageCourante - 1) * limit;

    int idRole = 0;

    try {
        if (roleParam != null && !roleParam.isEmpty()) {
            idRole = Integer.parseInt(roleParam);
        }
    } catch (Exception e) {
        idRole = 0;
    }

    Boolean statut = null;

    if (statutParam != null && !statutParam.isEmpty()) {
        statut = Boolean.parseBoolean(statutParam);
    }

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

    Vector<Utilisateur> liste = Utilisateur.rechercher(nom, idRole, statut, d1, d2, tri, limit, offset);
    int total = Utilisateur.count(nom, idRole, statut, d1, d2);
    int nbPages = (int) Math.ceil((double) total / limit);

    if (nbPages < 1) {
        nbPages = 1;
    }

    Vector<Utilisateur> roles = Utilisateur.getAllRoles();
    String selectedRole = (roleParam != null && !roleParam.isEmpty()) ? roleParam : "";

    String baseUrl = "model.jsp?page=utilisateur/liste-utilisateur"
        + "&nom=" + (nom != null ? nom : "")
        + "&role=" + (roleParam != null ? roleParam : "")
        + "&statut=" + (statutParam != null ? statutParam : "")
        + "&dateDebut=" + (dateDebut != null ? dateDebut : "")
        + "&dateFin=" + (dateFin != null ? dateFin : "")
        + "&tri=" + tri;
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2 class="fw-bold">Liste des utilisateurs</h2>

    <div class="d-flex gap-2">
        <a href="model.jsp?page=utilisateur/ajout-utilisateur" class="btn btn-brand">
            <i class="bi bi-plus-lg"></i> Ajouter un utilisateur
        </a>
        <a href="model.jsp?page=utilisateur/gestion-utilisateur" class="btn btn-secondary">
            <i class="bi bi-arrow-left"></i> Retour
        </a>
    </div>
</div>

<form action="model.jsp" method="get" class="row g-3 mb-4 p-3 border rounded bg-light">
    <input type="hidden" name="page" value="utilisateur/liste-utilisateur">

    <div class="col-12 col-sm-6 col-md-3">
        <label class="form-label">Nom</label>
        <input type="text" name="nom" class="form-control" value="<%= nom != null ? nom : "" %>">
    </div>

    <div class="col-12 col-sm-6 col-md-2">
        <label class="form-label">Rôle</label>
        <select name="role" class="form-select">
            <option value="">Tous</option>

            <% for (Utilisateur r : roles) { %>
                <option value="<%= r.getId_role() %>"
                    <%= selectedRole.equals(String.valueOf(r.getId_role())) ? "selected" : "" %>>
                    <%= r.getNom_role() %>
                </option>
            <% } %>
        </select>
    </div>

    <div class="col-12 col-sm-6 col-md-2">
        <label class="form-label">Statut</label>
        <select name="statut" class="form-select">
            <option value="">Tous</option>
            <option value="true" <%= "true".equals(statutParam) ? "selected" : "" %>>Actif</option>
            <option value="false" <%= "false".equals(statutParam) ? "selected" : "" %>>Inactif</option>
        </select>
    </div>

    <div class="col-12 col-sm-6 col-md-2">
        <label class="form-label">Date début</label>
        <input type="date" name="dateDebut" class="form-control" value="<%= dateDebut != null ? dateDebut : "" %>">
    </div>

    <div class="col-12 col-sm-6 col-md-2">
        <label class="form-label">Date fin</label>
        <input type="date" name="dateFin" class="form-control" value="<%= dateFin != null ? dateFin : "" %>">
    </div>

    <div class="col-12 col-md-1 d-flex align-items-end">
        <button type="submit" class="btn btn-primary w-100">
            <i class="bi bi-search"></i>
        </button>
    </div>
</form>

<div class="mb-3">
    <span>Trier par nom : </span>

    <a href="<%= baseUrl.replace("&tri=" + tri, "&tri=ASC") %>"
       class="btn btn-sm <%= tri.equals("ASC") ? "btn-primary" : "btn-outline-secondary" %>">
        A → Z
    </a>

    <a href="<%= baseUrl.replace("&tri=" + tri, "&tri=DESC") %>"
       class="btn btn-sm <%= tri.equals("DESC") ? "btn-primary" : "btn-outline-secondary" %>">
        Z → A
    </a>

    <a href="model.jsp?page=utilisateur/liste-utilisateur" class="btn btn-sm btn-outline-danger">
        Réinitialiser
    </a>
</div>

<div class="table-responsive">
    <table class="table table-bordered table-hover align-middle">
        <thead class="table-light">
            <tr>
                <th>ID</th>
                <th>Nom</th>
                <th>Prénom</th>
                <th>Rôle</th>
                <th>Email</th>
                <th>Statut</th>
                <% if (isAdmin) { %>
                    <th>Actions</th>
                <% } %>
            </tr>
        </thead>

        <tbody>
            <% if (liste.isEmpty()) { %>
                <tr>
                    <td colspan="<%= isAdmin ? 7 : 6 %>" class="text-center py-4">
                        Aucun utilisateur trouvé.
                    </td>
                </tr>
            <% } else {
                for (Utilisateur u : liste) { %>
                    <tr>
                        <td><%= u.getId_utilisateur() %></td>
                        <td><%= u.getNom() %></td>
                        <td><%= u.getPrenom() != null ? u.getPrenom() : "" %></td>
                        <td><%= u.getNom_role() %></td>
                        <td><%= u.getEmail() != null ? u.getEmail() : "" %></td>

                        <td>
                            <span class="badge <%= u.isActif() ? "bg-success" : "bg-danger" %>">
                                <%= u.isActif() ? "Actif" : "Inactif" %>
                            </span>
                        </td>

                        <% if (isAdmin) { %>
                            <td>
                                <div class="d-flex flex-wrap gap-1">
                                    <a href="?page=utilisateur/details-utilisateur&id=<%= u.getId_utilisateur() %>"
                                       class="btn btn-sm btn-info">
                                        <i class="bi bi-eye"></i>
                                    </a>

                                    <a href="?page=utilisateur/modifier-utilisateur&id=<%= u.getId_utilisateur() %>"
                                       class="btn btn-sm btn-warning">
                                        <i class="bi bi-pencil"></i>
                                    </a>

                                    <a href="../traitement/utilisateur/desactiver-utilisateur.jsp?id=<%= u.getId_utilisateur() %>&actif=<%= !u.isActif() %>"
                                       class="btn btn-sm btn-danger"
                                       onclick="return confirm('Confirmer la désactivation/réactivation ?')">
                                        <i class="bi <%= u.isActif() ? "bi-person-x" : "bi-person-check" %>"></i>
                                    </a>
                                </div>
                            </td>
                        <% } %>
                    </tr>
            <% }} %>
        </tbody>
    </table>
</div>

<% if (nbPages > 1) { %>
    <nav>
        <ul class="pagination flex-wrap">
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