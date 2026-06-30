<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="backoffice.Utilisateur" %>
<%
    // Vérification de l'utilisateur connecté
    Utilisateur userObj = (Utilisateur) session.getAttribute("utilisateur");
    if (userObj == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    boolean isAdmin = "Admin".equalsIgnoreCase(userObj.voirsiadmin());
    String nomUtilisateur = userObj.getNom() + " " + userObj.getPrenom();
    String userRole = userObj.voirsiadmin();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Trajets</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Custom Premium CSS -->
    <link rel="stylesheet" href="../assets/css/styles-premium.css">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark" style="background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);">
        <div class="container">
            <a class="navbar-brand fw-bold" href="model.jsp"><i class="fas fa-bus-alt me-2"></i>Mahery Vaika</a>
            <div class="ms-auto d-flex align-items-center gap-3">
                <span class="text-white-50 small">
                    <i class="fas fa-user-circle me-1"></i>
                    <%= nomUtilisateur %>
                    <span class="badge bg-light text-dark ms-1"><%= userRole %></span>
                </span>
                <a href="../traitement/traitement-logout.jsp" class="btn btn-sm btn-outline-light">
                    <i class="fas fa-sign-out-alt me-1"></i>Déconnexion
                </a>
            </div>
        </div>
    </nav>

    <div class="container mt-5">
        <div class="row mb-4">
            <div class="col-12">
                <h1 class="fw-bold" style="color: #2c3e50;">Gestion des Trajets</h1>
                <p class="text-muted">Sélectionnez une action ci-dessous</p>
            </div>
        </div>

        <div class="row g-4">
            <!-- Carte Liste des trajets -->
            <div class="col-md-6">
                <a href="?page=trajet/liste-trajet" class="text-decoration-none text-dark">
                    <div class="card premium-card h-100">
                        <div class="card-body text-center p-5">
                            <div class="mb-3">
                                <i class="fas fa-list-ul fa-4x text-primary"></i>
                            </div>
                            <h3 class="card-title fw-bold">Liste des trajets</h3>
                            <p class="card-text text-muted">Consultez, recherchez et gérez les trajets existants dans le système.</p>
                        </div>
                    </div>
                </a>
            </div>

            <!-- Carte Ajouter un trajet -->
            <div class="col-md-6">
                <a href="?page=trajet/ajout-trajet" class="text-decoration-none text-dark <%= !isAdmin ? "disabled" : "" %>" <%= !isAdmin ? "onclick='return false;'" : "" %>>
                    <div class="card premium-card h-100 <%= !isAdmin ? "card-disabled" : "" %>">
                        <div class="card-body text-center p-5">
                            <div class="mb-3">
                                <i class="fas fa-plus-circle fa-4x text-success"></i>
                            </div>
                            <h3 class="card-title fw-bold">Ajouter un trajet</h3>
                            <p class="card-text text-muted">Créez un nouveau trajet (Réservé aux administrateurs).</p>
                            <% if (!isAdmin) { %>
                                <span class="badge bg-danger mt-2"><i class="fas fa-lock me-1"></i> Accès restreint</span>
                            <% } %>
                        </div>
                    </div>
                </a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
