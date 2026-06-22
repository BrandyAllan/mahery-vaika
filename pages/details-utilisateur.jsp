<%@ page import="backoffice.Utilisateur" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    String idParam = request.getParameter("id");
    if (idParam == null || idParam.isEmpty()) {
        response.sendRedirect("liste-utilisateur.jsp");
        return;
    }
    int id = Integer.parseInt(idParam);
    Utilisateur u = Utilisateur.getById(id);
    if (u == null) {
        response.sendRedirect("liste-utilisateur.jsp");
        return;
    }
    boolean isAdmin = user.voirsiadmin().equals("Admin");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Details utilisateur</title>
    <link rel="stylesheet" href="../assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/bootstrap/icons/bootstrap-icons.min.css">
</head>
<body>
<div class="container mt-4">
    <h2>Details de l'utilisateur</h2>
    <a href="liste-utilisateur.jsp" class="btn btn-secondary mb-3"><i class="bi bi-arrow-left"></i> Retour</a>
    <div class="card">
        <div class="card-body">
            <p><strong>ID :</strong> <%= u.getId_utilisateur() %></p>
            <p><strong>Nom :</strong> <%= u.getNom() %></p>
            <p><strong>Prenom :</strong> <%= u.getPrenom() %></p>
            <p><strong>Telephone :</strong> <%= u.getTelephone() != null ? u.getTelephone() : "N/A" %></p>
            <p><strong>Email :</strong> <%= u.getEmail() %></p>
            <p><strong>Identifiant :</strong> <%= u.getIdentifiant() %></p>
            <p><strong>Role :</strong> <%= u.getNom_role() %></p>
            <p><strong>Date d'embauche :</strong> <%= u.getDate_embauche() %></p>
            <p><strong>Date de retrait :</strong> <%= u.getDate_retrait() != null ? u.getDate_retrait() : "N/A" %></p>
            <p><strong>Statut :</strong> <span class="badge <%= u.isActif() ? "bg-success" : "bg-danger" %>"><%= u.isActif() ? "Actif" : "Inactif" %></span></p>
            <p><strong>Date de creation :</strong> <%= u.getDate_creation() %></p>

            <div class="mt-3">
                <% if (isAdmin) { %>
                    <a href="modifier-utilisateur.jsp?id=<%= u.getId_utilisateur() %>" class="btn btn-warning"><i class="bi bi-pencil"></i> Modifier</a>
                    <a href="../traitement/desactiver-utilisateur.jsp?id=<%= u.getId_utilisateur() %>&actif=<%= !u.isActif() %>" class="btn btn-danger" onclick="return confirm('Confirmer ?')">
                        <i class="bi <%= u.isActif() ? "bi-person-x" : "bi-person-check" %>"></i> <%= u.isActif() ? "Desactiver" : "Reactiver" %>
                    </a>
                <% } else { %>
                    <button class="btn btn-warning" disabled><i class="bi bi-pencil"></i> Modifier</button>
                    <button class="btn btn-danger" disabled><i class="bi bi-person-x"></i> Desactiver</button>
                <% } %>
            </div>
        </div>
    </div>
</div>
<script src="../assets/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>