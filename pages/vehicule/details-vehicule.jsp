<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="gestion.Vehicule" %>
<%@ page import="backoffice.Utilisateur" %>
<%
    Utilisateur userObj = (Utilisateur) session.getAttribute("utilisateur");
    if (userObj == null) { 
        response.sendRedirect("login.jsp"); 
        return; 
    }
    
    String userRole = userObj.voirsiadmin();
    boolean isAdmin = "Admin".equalsIgnoreCase(userRole);

    String idStr = request.getParameter("id");
    if (idStr == null || idStr.isEmpty()) {
        response.sendRedirect("liste-vehicule.jsp");
        return;
    }

    int id = Integer.parseInt(idStr);
    Vehicule v = Vehicule.getVehiculeById(id);

    if (v == null) { 
        response.sendRedirect("liste-vehicule.jsp"); 
        return; 
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Fiche Véhicule : <%= v.getImmatriculation() %></title>
   
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .details-box { background-color: #f8f9fa; padding: 20px; border: 1px solid #dee2e6; border-radius: 6px; margin-top: 15px; max-width: 600px; }
        .info-row { padding: 10px 0; border-bottom: 1px solid #e9ecef; display: flex; justify-content: space-between; }
        .info-row:last-child { border-bottom: none; }
        .info-label { font-weight: bold; color: #495057; }
        .actions-area { margin-top: 20px; }
    </style>
</head>
<body>

    <h2>Détails Importants du Véhicule</h2>
    <p><a href="?page=vehicule/liste-vehicule" class="btn btn-sm btn-secondary">← Retour à la liste du parc</a></p>

    <div class="details-box">
        <div class="info-row">
            <span class="info-label">Numéro d'Immatriculation :</span>
            <span class="info-value"><strong><%= v.getImmatriculation() %></strong></span>
        </div>
        <div class="info-row">
            <span class="info-label">Constructeur / Modèle :</span>
            <span class="info-value"><%= v.getMarque() %> <%= v.getModele() %></span>
        </div>
        <div class="info-row">
            <span class="info-label">Capacité d'accueil :</span>
            <span class="info-value"><%= v.getCapacite() %> Personnes</span>
        </div>
        <div class="info-row">
            <span class="info-label">Kilométrage Compteur :</span>
            <span class="info-value"><%= v.getKilometrageActuel() %> km</span>
        </div>
        <div class="info-row">
            <span class="info-label">Statut Opérationnel :</span>
            <span class="info-value" style="font-weight: bold; color: <%= "ACTIF".equals(v.getEtat()) ? "green" : "red" %>;">
                <%= v.getEtat() %>
            </span>
        </div>
        <div class="info-row">
            <span class="info-label">Date Limite d'Assurance :</span>
            <span class="info-value"><%= v.getDateExpirationAssurance() != null ? v.getDateExpirationAssurance() : "N/A" %></span>
        </div>

        <div class="actions-area">
            <% if (isAdmin) { %>
                <a href="?page=vehicule/modifier-vehicule&id=<%= v.getIdVehicule() %>" class="btn btn-primary">Modifier la fiche</a>
                <a href="?page=vehicule/entretien-vehicule&id=<%= v.getIdVehicule() %>" class="btn btn-dark flex-grow-1 fw-bold py-2" style="background-color: #000066;">
                <i class="bi bi-tools"></i> Entretien
                </a>
                <% } else { %>
                <button class="btn btn-secondary" disabled>Modification (Réservé Admin)</button>


            <% } %>
        </div>
    </div>

</body>
</html>