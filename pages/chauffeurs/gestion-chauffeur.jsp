```
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="backoffice.Utilisateur" %>
<%
    Utilisateur userObj = (Utilisateur) session.getAttribute("utilisateur");
    if (userObj == null) {
        response.sendRedirect("../../index.jsp");
        return;
    }
    boolean isAdmin = "Admin".equalsIgnoreCase(userObj.voirsiadmin());
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Chauffeurs</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/bootstrap/icons/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<div class="container mt-5">
    <h2 class="mb-4"><i class="bi bi-person-badge"></i> Gestion des Chauffeurs</h2>

    <div class="row">
        <div class="col-md-6 mb-4">
            <div class="card h-100 shadow-sm">
                <div class="card-body">
                    <h5 class="card-title"><i class="bi bi-list-ul"></i> Liste des chauffeurs</h5>
                    <a href="?page=chauffeurs/liste-chauffeur" class="btn btn-primary">voir la liste</a>
                </div>
            </div>
        </div>

        <div class="col-md-6 mb-4">
            <% if (isAdmin) { %>
            <div class="card h-100 shadow-sm">
                <div class="card-body">
                    <h5 class="card-title"><i class="bi bi-person-plus"></i> Ajouter un chauffeur</h5>
                    <a href="?page=chauffeurs/ajout-chauffeur" class="btn btn-success">Ajouter un chauffeur</a>
                </div>
            </div>
            <% } else { %>
            <div class="card h-100 shadow-sm bg-light text-muted" style="opacity: 0.6;">
                <div class="card-body">
                    <h5 class="card-title"><i class="bi bi-person-plus"></i> Ajouter un chauffeur</h5>
                    <p class="card-text text-danger mb-3">(Reserve aux administrateurs)</p>
                    <button class="btn btn-secondary" disabled>Ajouter un chauffeur</button>
                </div>
            </div>
            <% } %>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
```