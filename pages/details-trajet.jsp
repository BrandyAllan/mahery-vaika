<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="gestion.TrajetGestion, models.Trajet" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    boolean isAdmin = "ADMIN".equals(role);
    
    String idStr = request.getParameter("id");
    if (idStr == null || idStr.isEmpty()) {
        response.sendRedirect("liste-trajet.jsp");
        return;
    }

    TrajetGestion trajetGestion = new TrajetGestion();
    Trajet trajet = trajetGestion.getTrajetById(Integer.parseInt(idStr));
    
    if (trajet == null) {
        response.sendRedirect("liste-trajet.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détails du Trajet #<%= trajet.getIdTrajet() %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../assets/css/styles-premium.css">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark" style="background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);">
        <div class="container">
            <a class="navbar-brand fw-bold" href="liste-trajet.jsp"><i class="fas fa-arrow-left me-2"></i>Retour à la liste</a>
        </div>
    </nav>

    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card premium-card">
                    <div class="card-header premium-card-header d-flex justify-content-between align-items-center">
                        <h4 class="mb-0"><i class="fas fa-info-circle me-2"></i>Détails du Trajet #<%= trajet.getIdTrajet() %></h4>
                        <% if (trajet.isActif()) { %>
                            <span class="badge bg-success">ACTIF</span>
                        <% } else { %>
                            <span class="badge bg-secondary">INACTIF</span>
                        <% } %>
                    </div>
                    <div class="card-body p-5">
                        
                        <div class="row mb-5 text-center">
                            <div class="col-5">
                                <h5 class="text-muted text-uppercase mb-2">Départ</h5>
                                <h3 class="fw-bold text-danger"><i class="fas fa-map-marker-alt me-2"></i><%= trajet.getVilleDepart().getNomVille() %></h3>
                            </div>
                            <div class="col-2 d-flex align-items-center justify-content-center">
                                <i class="fas fa-long-arrow-alt-right fa-3x text-muted"></i>
                            </div>
                            <div class="col-5">
                                <h5 class="text-muted text-uppercase mb-2">Arrivée</h5>
                                <h3 class="fw-bold text-success"><i class="fas fa-flag-checkered me-2"></i><%= trajet.getVilleArrivee().getNomVille() %></h3>
                            </div>
                        </div>

                        <hr class="text-muted mb-4">

                        <div class="row text-center mb-4">
                            <div class="col-md-4 mb-3">
                                <div class="p-3 border rounded shadow-sm">
                                    <i class="fas fa-road fa-2x text-primary mb-2"></i>
                                    <h6 class="text-muted text-uppercase">Distance</h6>
                                    <h5 class="fw-bold"><%= trajet.getDistanceKm() != null ? trajet.getDistanceKm() : "Non spécifiée" %> km</h5>
                                </div>
                            </div>
                            <div class="col-md-4 mb-3">
                                <div class="p-3 border rounded shadow-sm">
                                    <i class="far fa-clock fa-2x text-info mb-2"></i>
                                    <h6 class="text-muted text-uppercase">Durée Estimée</h6>
                                    <h5 class="fw-bold"><%= trajet.getDureeEstimee() != null ? trajet.getDureeEstimee() : "Non spécifiée" %></h5>
                                </div>
                            </div>
                            <div class="col-md-4 mb-3">
                                <div class="p-3 border rounded shadow-sm bg-light">
                                    <i class="fas fa-money-bill-wave fa-2x text-success mb-2"></i>
                                    <h6 class="text-muted text-uppercase">Tarif Base</h6>
                                    <h5 class="fw-bold text-success"><%= trajet.getTarifBase() %> Ar</h5>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex justify-content-center mt-5 gap-3">
                            <a href="modifier-trajet.jsp?id=<%= trajet.getIdTrajet() %>" class="btn btn-warning <%= !isAdmin ? "disabled" : "" %>">
                                <i class="fas fa-edit me-2"></i>Modifier
                            </a>
                            <% if (trajet.isActif() && isAdmin) { %>
                                <a href="../traitement/supprimer-trajet.jsp?id=<%= trajet.getIdTrajet() %>" class="btn btn-danger"
                                   onclick="return confirm('Désactiver ce trajet ?');">
                                    <i class="fas fa-ban me-2"></i>Désactiver
                                </a>
                            <% } %>
                        </div>
                        
                        <% if (!isAdmin) { %>
                            <div class="alert alert-info mt-4 text-center">
                                <i class="fas fa-info-circle me-2"></i>Seul un administrateur peut modifier ou désactiver un trajet.
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
