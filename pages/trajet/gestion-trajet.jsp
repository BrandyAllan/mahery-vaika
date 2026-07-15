<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="backoffice.Utilisateur" %>
<%
    // Vérification de l'utilisateur connecté
    Utilisateur userObj = (Utilisateur) session.getAttribute("utilisateur");
    if (userObj == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    boolean isAdmin = !"Caissier".equalsIgnoreCase(userObj.voirsiadmin());
    String nomUtilisateur = userObj.getNom() + " " + userObj.getPrenom();
    String userRole = userObj.voirsiadmin();
%>
<div class="d-flex justify-content-between align-items-center mb-4">
    <h2 class="fw-bold mb-0" style="color: #2c3e50;">
        <i class="bi bi-map text-primary me-2"></i> Gestion des Trajets
    </h2>
</div>
<p class="text-muted mb-4">Sélectionnez une action ci-dessous</p>

<style>
    /* Avoid inline empty rulesets by using classes for conditional styling */
    .card-hover { transition: transform 0.2s, box-shadow 0.2s; }
    .disabled-card { opacity: 0.6; cursor: not-allowed; }
</style>

<div class="row g-4">
    <!-- Carte Liste -->
    <div class="col-md-6">
        <a href="?page=trajet/liste-trajet" class="text-decoration-none text-dark">
            <div class="card border-0 shadow-sm h-100" style="transition: transform 0.2s, box-shadow 0.2s;" onmouseover="this.style.transform='translateY(-5px)'; this.classList.add('shadow');" onmouseout="this.style.transform='translateY(0)'; this.classList.remove('shadow');">
                <div class="card-body text-center p-5">
                    <div class="mb-3">
                        <i class="bi bi-list-ul display-4 text-primary"></i>
                    </div>
                    <h3 class="card-title fw-bold">Liste des trajets</h3>
                    <p class="card-text text-muted">Consultez, recherchez et gérez les trajets existants dans le système.</p>
                </div>
            </div>
        </a>
    </div>

    <!-- Carte Ajouter -->
   
<div class="col-md-6">
    <a href="<%= isAdmin ? "?page=trajet/ajout-trajet" : "#" %>"
       class="text-decoration-none text-dark">

        <div class="card border-0 shadow-sm h-100 <%= !isAdmin ? "disabled-card" : "card-hover" %>">

            <div class="card-body text-center p-5">
                <div class="mb-3">
                    <i class="bi bi-plus-circle display-4 text-success"></i>
                </div>

                <h3 class="card-title fw-bold">Ajouter un trajet</h3>

                <p class="card-text text-muted">
                    Créez un nouveau trajet (Réservé aux administrateurs).
                </p>

                <% if (!isAdmin) { %>
                    <span class="badge bg-danger mt-2">
                        <i class="bi bi-lock me-1"></i>
                        Accès restreint
                    </span>
                <% } %>

            </div>
        </div>
    </a>
</div>