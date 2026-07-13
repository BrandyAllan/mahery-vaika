<%@ page import="backoffice.Utilisateur" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");

    if (user == null) {
        response.sendRedirect("../../index.jsp");
        return;
    }

    String idParam = request.getParameter("id");

    if (idParam == null || idParam.isEmpty()) {
        response.sendRedirect("?page=utilisateur/liste-utilisateur");
        return;
    }

    int id = Integer.parseInt(idParam);
    Utilisateur u = Utilisateur.getById(id);

    if (u == null) {
        response.sendRedirect("?page=utilisateur/liste-utilisateur");
        return;
    }

    boolean isAdmin = user.voirsiadmin().equals("Admin");
%>

<%-- En-tête de page --%>
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <a href="?page=utilisateur/liste-utilisateur" class="btn btn-outline-secondary btn-sm">
    <i class="bi bi-arrow-left"></i> Retour a la liste
</a>
        <h2 class="fw-bold mb-0" style="color: #2c3e50;">
            <i class="bi bi-person-circle text-primary me-2"></i>
            <%= u.getNom() %> <%= u.getPrenom() != null ? u.getPrenom() : "" %>
            <span class="badge <%= u.isActif() ? "bg-success" : "bg-danger" %> fs-6 ms-2 rounded-pill">
                <%= u.isActif() ? "Actif" : "Inactif" %>
            </span>
        </h2>
    </div>
    <% if (isAdmin) { %>
    <div class="d-flex gap-2">
        <a href="?page=utilisateur/modifier-utilisateur&id=<%= u.getId_utilisateur() %>"
           class="btn btn-outline-primary shadow-sm">
            <i class="bi bi-pencil me-1"></i> Modifier
        </a>
        <a href="../traitement/utilisateur/desactiver-utilisateur.jsp?id=<%= u.getId_utilisateur() %>&actif=<%= !u.isActif() %>"
           class="btn <%= u.isActif() ? "btn-outline-danger" : "btn-outline-success" %> shadow-sm"
           onclick="return confirm('Confirmer la <%= u.isActif() ? "désactivation" : "réactivation" %> ?')">
            <i class="bi <%= u.isActif() ? "bi-person-x" : "bi-person-check" %>"></i>
            <%= u.isActif() ? "Désactiver" : "Réactiver" %>
        </a>
    </div>
    <% } %>
</div>

<div class="row g-4">

    <%-- Carte Identité --%>
    <div class="col-lg-6">
        <div class="card border-0 shadow-sm rounded-4 h-100">
            <div class="card-body p-4">
                <h5 class="card-title text-primary fw-bold mb-4">
                    <i class="bi bi-person-lines-fill me-2"></i>Identité
                </h5>
                <div class="row g-3">
                    <div class="col-4">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">ID</p>
                        <p class="fw-bold mb-0 text-muted">#<%= u.getId_utilisateur() %></p>
                    </div>
                    <div class="col-4">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Nom</p>
                        <p class="fw-bold mb-0"><%= u.getNom() %></p>
                    </div>
                    <div class="col-4">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Prénom</p>
                        <p class="fw-semibold mb-0"><%= u.getPrenom() != null ? u.getPrenom() : "—" %></p>
                    </div>
                    <div class="col-12"><hr class="my-2 opacity-25"></div>
                    <div class="col-6">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Téléphone</p>
                        <p class="fw-semibold mb-0">
                            <% if (u.getTelephone() != null) { %>
                                <i class="bi bi-telephone-fill text-primary me-1"></i><%= u.getTelephone() %>
                            <% } else { %><span class="text-muted">N/A</span><% } %>
                        </p>
                    </div>
                    <div class="col-6">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Email</p>
                        <p class="fw-semibold mb-0">
                            <% if (u.getEmail() != null && !u.getEmail().isEmpty()) { %>
                                <a href="mailto:<%= u.getEmail() %>" class="text-decoration-none">
                                    <i class="bi bi-envelope-fill text-info me-1"></i><%= u.getEmail() %>
                                </a>
                            <% } else { %><span class="text-muted">—</span><% } %>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- Carte Accès & Rôle --%>
    <div class="col-lg-6">
        <div class="card border-0 shadow-sm rounded-4 h-100">
            <div class="card-body p-4">
                <h5 class="card-title text-primary fw-bold mb-4">
                    <i class="bi bi-shield-lock-fill me-2"></i>Accès & Rôle
                </h5>
                <div class="row g-3">
                    <div class="col-6">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Identifiant</p>
                        <p class="fw-bold mb-0 font-monospace"><%= u.getIdentifiant() %></p>
                    </div>
                    <div class="col-6">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Rôle</p>
                        <span class="badge bg-info text-dark rounded-pill px-3 py-2 fs-6">
                            <i class="bi bi-person-badge me-1"></i><%= u.getNom_role() %>
                        </span>
                    </div>
                    <div class="col-12"><hr class="my-2 opacity-25"></div>
                    <div class="col-6">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Statut</p>
                        <span class="badge <%= u.isActif() ? "bg-success" : "bg-danger" %> rounded-pill px-3 py-2">
                            <%= u.isActif() ? "Actif" : "Inactif" %>
                        </span>
                    </div>
                    <div class="col-6">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Date de création</p>
                        <p class="fw-semibold mb-0">
                            <i class="bi bi-calendar3 me-1 text-muted"></i><%= u.getDate_creation() %>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- Carte Emploi --%>
    <div class="col-12">
        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-body p-4">
                <h5 class="card-title text-primary fw-bold mb-4">
                    <i class="bi bi-briefcase-fill me-2"></i>Historique d'emploi
                </h5>
                <div class="row g-3">
                    <div class="col-md-4">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Date d'embauche</p>
                        <p class="fw-semibold mb-0">
                            <i class="bi bi-calendar-check text-success me-1"></i><%= u.getDate_embauche() %>
                        </p>
                    </div>
                    <div class="col-md-4">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Date de retrait</p>
                        <p class="fw-semibold mb-0">
                            <% if (u.getDate_retrait() != null) { %>
                                <i class="bi bi-calendar-x text-danger me-1"></i><%= u.getDate_retrait() %>
                            <% } else { %>
                                <span class="badge bg-light text-success border">En poste</span>
                            <% } %>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>

<% if (!isAdmin) { %>
<div class="alert alert-info border-0 shadow-sm rounded-4 mt-4 d-flex align-items-center" role="alert">
    <i class="bi bi-info-circle-fill me-2 fs-5"></i>
    La modification est réservée aux administrateurs.
</div>
<% } %>