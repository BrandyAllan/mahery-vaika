<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="backoffice.Utilisateur" %>
<%
    Utilisateur userObj = (Utilisateur) session.getAttribute("utilisateur");

    if (userObj == null) {
        response.sendRedirect("../index.jsp"); 
        return; 
    }
    
    String userRole = userObj.voirsiadmin(); 
    boolean isAdmin = "Admin".equalsIgnoreCase(userRole);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Véhicules</title>
  
</head>
<body class="bg-light">

    <div class="container mt-5">
        <h2 class="mb-4"><i class="bi bi-car-front"></i> Gestion des Véhicules</h2>
        
        <div class="row">
            <div class="col-md-6 mb-4">
                <div class="card h-100 shadow-sm">
                    <div class="card-body">
                        <h4 class="card-title"><i class="bi bi-list-ul"></i> Liste des Véhicules</h4>
                        <p class="card-text text-muted">Consulter, rechercher et voir les détails des véhicules disponibles.</p>
                        <a href="?page=vehicule/liste-vehicule" class="btn btn-primary">Accéder à la liste</a>
                    </div>
                </div>
            </div>

            <div class="col-md-6 mb-4">
                <% if (isAdmin) { %>
                    <div class="card h-100 shadow-sm">
                        <div class="card-body">
                            <h4 class="card-title"><i class="bi bi-plus-circle"></i> Ajouter un Véhicule</h4>
                            <p class="card-text text-muted">Enregistrer un nouveau véhicule dans la base de données.</p>
                            <a href="?page=vehicule/ajout-vehicule" class="btn btn-success">Ajouter un véhicule</a>
                        </div>
                    </div>
                <% } else { %>
                    <div class="card h-100 shadow-sm bg-light text-muted" style="opacity: 0.6;">
                        <div class="card-body">
                            <h4 class="card-title"><i class="bi bi-plus-circle"></i> Ajouter un Véhicule</h4>
                            <p class="card-text text-danger mb-3">(Réservé aux administrateurs)</p>
                            <button class="btn btn-secondary" disabled>Ajouter un véhicule</button>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}"></script>
</body>
</html>