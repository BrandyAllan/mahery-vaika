<%@ page import="backoffice.Utilisateur" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null || user.getId_role() != 1) {
        response.sendRedirect("gestion-utilisateur.jsp");
        return;
    }
    int id = Integer.parseInt(request.getParameter("id"));
    Utilisateur u = Utilisateur.getById(id);
    if (u == null) {
        response.sendRedirect("liste-utilisateur.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Modifier un utilisateur</title>
    <link rel="stylesheet" href="../assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/bootstrap/icons/bootstrap-icons.min.css">
</head>
<body>
<div class="container mt-4">
    <h2>Modifier l'utilisateur</h2>
    <a href="liste-utilisateur.jsp" class="btn btn-secondary mb-3"><i class="bi bi-arrow-left"></i> Retour</a>
    <form action="../traitement/modifier-utilisateur.jsp" method="post" class="row g-3">
        <input type="hidden" name="id" value="<%= u.getId_utilisateur() %>">
        <div class="col-md-6">
            <label>Nom *</label>
            <input type="text" name="nom" class="form-control" value="<%= u.getNom() %>" required>
        </div>
        <div class="col-md-6">
            <label>Prenom</label>
            <input type="text" name="prenom" class="form-control" value="<%= u.getPrenom() %>">
        </div>
        <div class="col-md-6">
            <label>Telephone</label>
            <input type="text" name="telephone" class="form-control" value="<%= u.getTelephone() %>">
        </div>
        <div class="col-md-6">
            <label>Email *</label>
            <input type="email" name="email" class="form-control" value="<%= u.getEmail() %>" required>
        </div>
        <div class="col-md-6">
            <label>Identifiant *</label>
            <input type="text" name="identifiant" class="form-control" value="<%= u.getIdentifiant() %>" required>
        </div>
        <div class="col-md-6">
            <label>Mot de passe (laisser vide pour ne pas modifier)</label>
            <input type="password" name="mot_de_passe" class="form-control" placeholder="Nouveau mot de passe">
        </div>
        <div class="col-md-6">
            <label>Role *</label>
            <select name="role" class="form-select" required>
                <option value="1" <%= u.getId_role()==1 ? "selected" : "" %>>Admin</option>
                <option value="2" <%= u.getId_role()==2 ? "selected" : "" %>>Caissier</option>
                <option value="3" <%= u.getId_role()==3 ? "selected" : "" %>>Autre</option>
            </select>
        </div>
        <div class="col-md-6">
            <label>Date d'embauche *</label>
            <input type="date" name="date_embauche" class="form-control" value="<%= u.getDate_embauche() %>" required>
        </div>
        <div class="col-md-6">
            <label>Date de retrait</label>
            <input type="date" name="date_retrait" class="form-control" value="<%= u.getDate_retrait() != null ? u.getDate_retrait() : "" %>">
        </div>
        <div class="col-md-6">
            <label>Statut</label>
            <select name="actif" class="form-select">
                <option value="true" <%= u.isActif() ? "selected" : "" %>>Actif</option>
                <option value="false" <%= !u.isActif() ? "selected" : "" %>>Inactif</option>
            </select>
        </div>
        <div class="col-12">
            <button type="submit" class="btn btn-primary">Enregistrer</button>
            <a href="liste-utilisateur.jsp" class="btn btn-secondary">Annuler</a>
        </div>
    </form>
</div>
<script src="../assets/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>