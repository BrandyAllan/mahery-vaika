<%@ page import="backoffice.Utilisateur" %>

<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");

    if (user == null) {
        response.sendRedirect("../../index.jsp");
        return;
    }

    boolean isAdmin = user.voirsiadmin().equals("Admin");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des utilisateurs</title>
    <link rel="stylesheet" href="../../assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="../../assets/icons/bootstrap-icons.min.css">
</head>
<body>
<div class="container mt-4 mt-md-5">
    <h2 class="mb-4">Gestion des utilisateurs</h2>

    <div class="row g-3">
        <div class="col-12 col-md-6">
            <div class="card h-100">
                <div class="card-body">
                    <h5 class="card-title">
                        <i class="bi bi-list-ul"></i> Liste des utilisateurs
                    </h5>
                    <p class="card-text">Voir tous les utilisateurs enregistres.</p>
                    <a href="?page=utilisateur/liste-utilisateur" class="btn btn-primary">Acceder a la liste</a>
                </div>
            </div>
        </div>

        <% if (isAdmin) { %>
        <div class="col-12 col-md-6">
            <div class="card h-100">
                <div class="card-body">
                    <h5 class="card-title">
                        <i class="bi bi-person-plus"></i> Ajouter un utilisateur
                    </h5>
                    <p class="card-text">Creer un nouvel utilisateur.</p>
                    <a href="?page=utilisateur/ajout-utilisateur" class="btn btn-success">Ajouter</a>
                </div>
            </div>
        </div>
        <% } %>
    </div>
</div>
<script src="../../assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>