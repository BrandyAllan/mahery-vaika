<%@ page import="backoffice.Utilisateur" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    int id = Integer.parseInt(request.getParameter("id"));
    Utilisateur u = Utilisateur.getById(id);
    if (u == null) {
        response.sendRedirect("liste-utilisateur.jsp");
        return;
    }
    boolean isAdmin = user.getId_role() == 1;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Détails utilisateur</title>
    <link rel="stylesheet" href="../assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/bootstrap/icons/bootstrap-icons.min.css">
</head>
<body>
<div class="container mt-4">
    <h2>Détails de l'utilisateur</h2>
    <a href="liste-utilisateur.jsp" class="btn btn-secondary mb-3"><i class="bi bi-arrow-left"></i> Retour</a>
    <div class="card">
        <div class="card-body">
            <p><strong>ID :</strong> <%= u.getId_utilisateur() %></p>
            <p><strong>Nom :</strong> <%= u.getNom() %></p>
            <p><strong>Prénom :</strong> <%= u.getPrenom() %></p>
            <p><strong>Téléphone :</strong> <%= u.getTelephone() %></p>
            <p><strong>Email :</strong> <%= u.getEmail() %></p>
            <p><strong>Identifiant :</strong> <%= u.getIdentifiant() %></p>
            <p><strong>Rôle :</strong> <%= u.getId_role() == 1 ? "Admin" : u.getId_role() == 2 ? "Caissier" : "Autre" %></p>
            <p><strong>Date d'embauche :</strong> <%= u.getDate_embauche() %></p>
            <p><strong>Date de retrait :</strong> <%= u.getDate_retrait() != null ? u.getDate_retrait() : "N/A" %></p>
            <p><strong>Statut :</strong> <span class="badge <%= u.isActif() ? "bg-success" : "bg-danger" %>"><%= u.isActif() ? "Actif" : "Inactif" %></span></p>
            <p><strong>Date de création :</strong> <%= u.getDate_creation() %></p>

            <div class="mt-3">
                <% if (isAdmin) { %>
                    <a href="modifier-utilisateur.jsp?id=<%= u.getId_utilisateur() %>" class="btn btn-warning"><i class="bi bi-pencil"></i> Modifier</a>
                    <a href="../traitement/desactiver-utilisateur.jsp?id=<%= u.getId_utilisateur() %>&actif=<%= !u.isActif() %>" class="btn btn-danger" onclick="return confirm('Confirmer ?')">
                        <i class="bi <%= u.isActif() ? "bi-person-x" : "bi-person-check" %>"></i> <%= u.isActif() ? "Désactiver" : "Réactiver" %>
                    </a>
                <% } else { %>
                    <button class="btn btn-warning" disabled><i class="bi bi-pencil"></i> Modifier</button>
                    <button class="btn btn-danger" disabled><i class="bi bi-person-x"></i> Désactiver</button>
                <% } %>
            </div>
        </div>
    </div>
</div>
<script src="../assets/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>