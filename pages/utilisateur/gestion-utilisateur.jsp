<%@ page import="backoffice.Utilisateur" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");

    if (user == null) {
        response.sendRedirect("../../index.jsp");
        return;
    }

    boolean isAdmin = user.voirsiadmin().equals("Admin");
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2 class="fw-bold mb-0" style="color: #2c3e50;">
        <i class="bi bi-people text-primary me-2"></i> Gestion des Utilisateurs
    </h2>
</div>
<p class="text-muted mb-4">Sélectionnez une action ci-dessous</p>

<div class="row g-4">
    <!-- Carte Liste -->
    <div class="col-md-6">
        <a href="?page=utilisateur/liste-utilisateur" class="text-decoration-none text-dark">
            <div class="card border-0 shadow-sm h-100" style="transition: transform 0.2s, box-shadow 0.2s;" onmouseover="this.style.transform='translateY(-5px)'; this.classList.add('shadow');" onmouseout="this.style.transform='translateY(0)'; this.classList.remove('shadow');">
                <div class="card-body text-center p-5">
                    <div class="mb-3">
                        <i class="bi bi-list-ul display-4 text-primary"></i>
                    </div>
                    <h3 class="card-title fw-bold">Liste des utilisateurs</h3>
                    <p class="card-text text-muted">Voir tous les utilisateurs enregistrés dans le système.</p>
                </div>
            </div>
        </a>
    </div>

    <!-- Carte Ajouter -->
    <div class="col-md-6">
        <a href="?page=utilisateur/ajout-utilisateur" class="text-decoration-none text-dark <%= !isAdmin ? "disabled" : "" %>" <%= !isAdmin ? "onclick='return false;'" : "" %>>
            <div class="card border-0 shadow-sm h-100" style="<%= !isAdmin ? "opacity: 0.6;" : "transition: transform 0.2s, box-shadow 0.2s;" %>" <%= isAdmin ? "onmouseover=\"this.style.transform='translateY(-5px)'; this.classList.add('shadow');\" onmouseout=\"this.style.transform='translateY(0)'; this.classList.remove('shadow');\"" : "" %>>
                <div class="card-body text-center p-5">
                    <div class="mb-3">
                        <i class="bi bi-person-plus display-4 text-success"></i>
                    </div>
                    <h3 class="card-title fw-bold">Ajouter un utilisateur</h3>
                    <p class="card-text text-muted">Créer un nouvel utilisateur (Réservé aux administrateurs).</p>
                    <% if (!isAdmin) { %>
                        <span class="badge bg-danger mt-2"><i class="bi bi-lock me-1"></i> Accès restreint</span>
                    <% } %>
                </div>
            </div>
        </a>
    </div>
</div>