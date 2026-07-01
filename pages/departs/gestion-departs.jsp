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
        <div class="row mb-4">
            <div class="col-12">
                <h1 class="fw-bold" style="color: #2c3e50;">Gestion de départs</h1>
                <p class="text-muted">Sélectionnez une action ci-dessous</p>
            </div>
        </div>

        <div class="row g-4">
            <!-- Carte Liste des trajets -->
            <div class="col-md-6">
                <a href="?page=departs/liste-depart" class="text-decoration-none text-dark">
                    <div class="card premium-card h-100">
                        <div class="card-body text-center p-5">
                            <div class="mb-3">
                                <i class="fas fa-list-ul fa-4x text-primary"></i>
                            </div>
                            <h3 class="card-title fw-bold">Liste de départs</h3>
                            <p class="card-text text-muted">Consultez, recherchez et gérez les départs existants dans le système.</p>
                        </div>
                    </div>
                </a>
            </div>

            <!-- Carte Ajouter un trajet -->
            <div class="col-md-6">
                <a href="?page=departs/ajout-depart" class="text-decoration-none text-dark <%= !isAdmin ? "disabled" : "" %>" <%= !isAdmin ? "onclick='return false;'" : "" %>>
                    <div class="card premium-card h-100 <%= !isAdmin ? "card-disabled" : "" %>">
                        <div class="card-body text-center p-5">
                            <div class="mb-3">
                                <i class="fas fa-plus-circle fa-4x text-success"></i>
                            </div>
                            <h3 class="card-title fw-bold">Ajouter un départ</h3>
                            <p class="card-text text-muted">Créez un nouveau départ (Réservé aux administrateurs).</p>
                            <% if (!isAdmin) { %>
                                <span class="badge bg-danger mt-2"><i class="fas fa-lock me-1"></i> Accès restreint</span>
                            <% } %>
                        </div>
                    </div>
                </a>
            </div>
        </div>
    </div>

