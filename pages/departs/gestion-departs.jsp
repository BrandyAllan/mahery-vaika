<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="backoffice.Utilisateur" %>
<%
    Utilisateur userObj = (Utilisateur) session.getAttribute("utilisateur");

    if (userObj == null) {
        response.sendRedirect("../index.jsp");
        return;
    }

    String userRole = userObj.voirsiadmin();
    boolean isAdmin = !"Caissier".equalsIgnoreCase(userRole);
%>

<div class="container mt-5">
    <h2 class="mb-4"><i class="bi bi-send"></i> Gestion des Départs</h2>

    <div class="row">

        <!-- card liste -->
        <div class="col-md-6 mb-4">
            <div class="card h-100 shadow-sm">
                <div class="card-body">
                    <h4 class="card-title">
                        <i class="bi bi-list-ul"></i> Liste des départs
                    </h4>
                    <p class="card-text text-muted">
                        Consulter, rechercher et voir les détails des départs planifiés.
                    </p>
                    <a href="?page=departs/liste-depart" class="btn btn-primary">
                        Accéder à la liste
                    </a>
                </div>
            </div>
        </div>

        <!-- card miajoute -->
        <div class="col-md-6 mb-4">
            <% if (isAdmin) { %>
                <div class="card h-100 shadow-sm">
                    <div class="card-body">
                        <h4 class="card-title">
                            <i class="bi bi-plus-circle"></i> Ajouter un départ
                        </h4>
                        <p class="card-text text-muted">
                            Planifier un nouveau départ en affectant un trajet, un véhicule et un chauffeur.
                        </p>
                        <a href="?page=departs/ajout-depart" class="btn btn-success">
                            Ajouter un départ
                        </a>
                    </div>
                </div>
            <% } else { %>
                <div class="card h-100 shadow-sm bg-light text-muted" style="opacity: 0.6;">
                    <div class="card-body">
                        <h4 class="card-title">
                            <i class="bi bi-plus-circle"></i> Ajouter un départ
                        </h4>
                        <p class="card-text text-danger mb-3">
                            (Réservé aux administrateurs)
                        </p>
                        <button class="btn btn-secondary" disabled>
                            Ajouter un départ
                        </button>
                    </div>
                </div>
            <% } %>
        </div>

    </div>
</div>
