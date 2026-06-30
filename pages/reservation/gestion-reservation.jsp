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
    <title>Gestion des reservations</title>
    <link rel="stylesheet" href="../assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/bootstrap/icons/bootstrap-icons.min.css">
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4"><i class="bi bi-ticket-perforated"></i> Gestion des reservations</h2>
    <div class="row g-3">
        <div class="col-md-6">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title"><i class="bi bi-list-ul"></i> Liste des reservations</h5>
                    <p class="card-text">Consulter et rechercher les reservations.</p>
                    <a href="liste-reservation.jsp" class="btn btn-primary">Voir la liste</a>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title"><i class="bi bi-plus-circle"></i> Nouvelle reservation</h5>
                    <p class="card-text">Creer une reservation pour un passager.</p>
                    <a href="ajout-reservation.jsp" class="btn btn-success">Ajouter</a>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="../assets/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
