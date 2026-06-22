<%@ page import="backoffice.Utilisateur" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null || user.getId_role() != 1) {
        response.sendRedirect("gestion-utilisateur.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ajouter un utilisateur</title>
    <link rel="stylesheet" href="../assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/bootstrap/icons/bootstrap-icons.min.css">
</head>
<body>
<div class="container mt-4">
    <h2>Ajouter un utilisateur</h2>
    <a href="gestion-utilisateur.jsp" class="btn btn-secondary mb-3"><i class="bi bi-arrow-left"></i> Retour</a>
    <form action="../traitement/ajouter-utilisateur.jsp" method="post" class="row g-3">
        <div class="col-md-6">
            <label>Nom *</label>
            <input type="text" name="nom" class="form-control" required>
        </div>
        <div class="col-md-6">
            <label>Prenom</label>
            <input type="text" name="prenom" class="form-control">
        </div>
        <div class="col-md-6">
            <label>Telephone</label>
            <input type="text" name="telephone" class="form-control">
        </div>
        <div class="col-md-6">
            <label>Email *</label>
            <input type="email" name="email" class="form-control" required>
        </div>
        <div class="col-md-6">
            <label>Identifiant *</label>
            <input type="text" name="identifiant" class="form-control" required>
        </div>
        <div class="col-md-6">
            <label>Mot de passe *</label>
            <input type="password" name="mot_de_passe" class="form-control" required>
        </div>
        <div class="col-md-6">
            <label>Role *</label>
            <select name="role" class="form-select" required>
                <option value="1">Admin</option>
                <option value="2">Caissier</option>
                <option value="3">Autre</option>
            </select>
        </div>
        <div class="col-md-6">
            <label>Date d'embauche *</label>
            <input type="date" name="date_embauche" class="form-control" required>
        </div>
        <div class="col-12">
            <button type="submit" class="btn btn-primary">Ajouter</button>
            <a href="gestion-utilisateur.jsp" class="btn btn-secondary">Annuler</a>
        </div>
    </form>
</div>
<script src="../assets/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>