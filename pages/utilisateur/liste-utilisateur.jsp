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
    <h2 class="fw-bold mb-0">
        <i class="bi bi-people text-primary"></i> Liste des Utilisateurs
        <small class="fs-6 text-muted ms-2">(<%= total %> résultat<%= total > 1 ? "s" : "" %>)</small>
    </h2>

    <div class="d-flex gap-2">
        <a href="model.jsp?page=utilisateur/ajout-utilisateur" class="btn btn-primary btn-sm">
            <i class="bi bi-plus-lg"></i> Ajouter un utilisateur
        </a>
        <a href="model.jsp?page=utilisateur/gestion-utilisateur" class="btn btn-outline-secondary btn-sm">
            <i class="bi bi-arrow-left"></i> Retour
        </a>
    </div>
</div>

<div class="card border-0 shadow-sm mb-4">
    <div class="card-body">
        <form action="model.jsp" method="get" class="row g-3 align-items-end">
            <input type="hidden" name="page" value="utilisateur/liste-utilisateur">

            <div class="col-md-3">
                <label class="form-label fw-semibold">Nom</label>
                <input type="text" name="nom" class="form-control form-control-sm" value="<%= nom != null ? nom : "" %>">
            </div>

            <div class="col-md-2">
                <label class="form-label fw-semibold">Rôle</label>
                <select name="role" class="form-select form-select-sm">
                    <option value="">Tous</option>

                    <% for (Utilisateur r : roles) { %>
                        <option value="<%= r.getId_role() %>"
                            <%= selectedRole.equals(String.valueOf(r.getId_role())) ? "selected" : "" %>>
                            <%= r.getNom_role() %>
                        </option>
                    <% } %>
                </select>
            </div>

            <div class="col-md-2">
                <label class="form-label fw-semibold">Statut</label>
                <select name="statut" class="form-select form-select-sm">
                    <option value="">Tous</option>
                    <option value="true" <%= "true".equals(statutParam) ? "selected" : "" %>>Actif</option>
                    <option value="false" <%= "false".equals(statutParam) ? "selected" : "" %>>Inactif</option>
                </select>
            </div>

            <div class="col-md-2">
                <label class="form-label fw-semibold">Date début</label>
                <input type="date" name="dateDebut" class="form-control form-control-sm" value="<%= dateDebut != null ? dateDebut : "" %>">
            </div>

            <div class="col-md-2">
                <label class="form-label fw-semibold">Date fin</label>
                <input type="date" name="dateFin" class="form-control form-control-sm" value="<%= dateFin != null ? dateFin : "" %>">
            </div>

            <div class="col-md-1 d-flex align-items-end">
                <button type="submit" class="btn btn-primary btn-sm w-100">
                    <i class="bi bi-search"></i>
                </button>
            </div>
        </form>
    </div>
</div>

<div class="d-flex flex-wrap align-items-center gap-2 mb-3">
    <span class="text-muted small fw-semibold">Trier par nom :</span>

    <a href="<%= baseUrl.replace("&tri=" + tri, "&tri=ASC") %>"
       class="btn btn-sm <%= tri.equals("ASC") ? "btn-primary" : "btn-outline-secondary" %>">
        A → Z
    </a>

    <a href="<%= baseUrl.replace("&tri=" + tri, "&tri=DESC") %>"
       class="btn btn-sm <%= tri.equals("DESC") ? "btn-primary" : "btn-outline-secondary" %>">
        Z → A
    </a>

    <a href="model.jsp?page=utilisateur/liste-utilisateur" class="btn btn-sm btn-outline-danger ms-auto">
        Réinitialiser
    </a>
</div>

<div class="card border-0 shadow-sm mb-4">
    <div class="table-responsive">
        <table class="table table-hover table-striped align-middle mb-0">
            <thead class="table-light">
                <tr>
                    <th>ID</th>
                    <th>Nom</th>
                    <th>Prénom</th>
                    <th>Rôle</th>
                    <th>Email</th>
                    <th>Statut</th>
                    <% if (isAdmin) { %>
                        <th class="text-end">Actions</th>
                    <% } %>
                </tr>
            </thead>

            <tbody>
                <% if (liste.isEmpty()) { %>
                    <tr>
                        <td colspan="<%= isAdmin ? 7 : 6 %>" class="text-center text-muted py-5">
                            <i class="bi bi-inbox d-block fs-1 mb-2"></i>
                            Aucun utilisateur trouvé.
                        </td>
                    </tr>
                <% } else {
                    for (Utilisateur u : liste) { %>
                        <tr>
                            <td class="fw-semibold text-muted">#<%= u.getId_utilisateur() %></td>
                            <td class="fw-bold"><%= u.getNom() %></td>
                            <td><%= u.getPrenom() != null ? u.getPrenom() : "" %></td>
                            <td>
                                <span class="badge bg-info text-dark rounded-pill px-3 py-1"><%= u.getNom_role() %></span>
                            </td>
                            <td><a href="mailto:<%= u.getEmail() != null ? u.getEmail() : "" %>" class="text-decoration-none"><%= u.getEmail() != null ? u.getEmail() : "" %></a></td>

                            <td>
                                <span class="badge <%= u.isActif() ? "bg-success" : "bg-danger" %> rounded-pill px-3 py-2">
                                    <%= u.isActif() ? "Actif" : "Inactif" %>
                                </span>
                            </td>

                            <% if (isAdmin) { %>
                                <td class="text-end">
                                    <div class="d-flex justify-content-end gap-1">
                                        <a href="?page=utilisateur/details-utilisateur&id=<%= u.getId_utilisateur() %>"
                                           class="btn btn-sm btn-outline-info rounded-circle" title="Détails">
                                            <i class="bi bi-eye"></i>
                                        </a>

                                        <a href="?page=utilisateur/modifier-utilisateur&id=<%= u.getId_utilisateur() %>"
                                           class="btn btn-sm btn-outline-warning rounded-circle" title="Modifier">
                                            <i class="bi bi-pencil"></i>
                                        </a>

                                        <a href="../traitement/utilisateur/desactiver-utilisateur.jsp?id=<%= u.getId_utilisateur() %>&actif=<%= !u.isActif() %>"
                                           class="btn btn-sm <%= u.isActif() ? "btn-outline-danger" : "btn-outline-success" %> rounded-circle"
                                           title="<%= u.isActif() ? "Désactiver" : "Réactiver" %>"
                                           onclick="return confirm('Confirmer la <%= u.isActif() ? "désactivation" : "réactivation" %> ?')">
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
</div>

<% if (nbPages > 1) { %>
    <nav>
        <ul class="pagination pagination-sm">
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