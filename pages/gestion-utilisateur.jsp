<%@ page import="backoffice.Utilisateur" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) {
        response.sendRedirect("../index.jsp");
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
    <link rel="stylesheet" href="../assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/bootstrap/icons/bootstrap-icons.min.css">
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4">Gestion des utilisateurs</h2>
    <div class="row">
        <div class="col-md-6">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title"><i class="bi bi-list-ul"></i> Liste des utilisateurs</h5>
                    <p class="card-text">Voir tous les utilisateurs enregistres.</p>
                    <a href="liste-utilisateur.jsp" class="btn btn-primary">Acceder a la liste</a>
                </div>
            </div>
        </div>
        <% if (isAdmin) { %>
        <div class="col-md-6">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title"><i class="bi bi-person-plus"></i> Ajouter un utilisateur</h5>
                    <p class="card-text">Creer un nouvel utilisateur.</p>
                    <a href="ajout-utilisateur.jsp" class="btn btn-success">Ajouter</a>
                </div>
            </div>
        </div>
        <% } %>

        <div class="col-md-6 mt-4">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title"><i class="bi bi-list-ul"></i> Gerer les voitures</h5>
                    <p class="card-text">Voir toutes les options de gestion des voitures.</p>
                    <a href="gestion-vehicule.jsp" class="btn btn-primary">Acceder a la gestion</a>
                </div>
            </div>
        </div>

    </div>
</div>
<script src="../assets/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>