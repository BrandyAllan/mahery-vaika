<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="gestion.TrajetGestion, gestion.VilleGestion, models.Trajet, models.Ville, java.util.List" %>
<%
    String role = (String) session.getAttribute("role");
    if (!"ADMIN".equals(role)) {
        response.sendRedirect("liste-trajet.jsp");
        return;
    }

    String idStr = request.getParameter("id");
    if (idStr == null || idStr.isEmpty()) {
        response.sendRedirect("liste-trajet.jsp");
        return;
    }

    TrajetGestion trajetGestion = new TrajetGestion();
    VilleGestion villeGestion = new VilleGestion();
    
    Trajet trajet = trajetGestion.getTrajetById(Integer.parseInt(idStr));
    if (trajet == null) {
        response.sendRedirect("liste-trajet.jsp");
        return;
    }
    
    List<Ville> villes = villeGestion.getAllVilles();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier le Trajet #<%= trajet.getIdTrajet() %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../assets/css/styles-premium.css">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark" style="background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);">
        <div class="container">
            <a class="navbar-brand fw-bold" href="details-trajet.jsp?id=<%= trajet.getIdTrajet() %>"><i class="fas fa-arrow-left me-2"></i>Annuler</a>
            <span class="navbar-text text-white fw-bold">
                <i class="fas fa-bus-alt me-2"></i>Mahery Vaika
            </span>
        </div>
    </nav>

    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card premium-card border-warning">
                    <div class="card-header bg-warning text-dark d-flex align-items-center" style="border-radius: 16px 16px 0 0; padding: 20px;">
                        <h4 class="mb-0 fw-bold"><i class="fas fa-edit me-2"></i>Modification du trajet #<%= trajet.getIdTrajet() %></h4>
                    </div>
                    <div class="card-body p-4">
                        <form action="../traitement/modifier-trajet.jsp" method="POST">
                            <input type="hidden" name="id_trajet" value="<%= trajet.getIdTrajet() %>">
                            
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Ville de départ</label>
                                    <select name="id_ville_depart" id="villeDepart" class="form-select premium-input" required onchange="updateArriveeOptions()">
                                        <option value="">-- Sélectionnez une ville --</option>
                                        <% for(Ville v : villes) { 
                                            String sel = (v.getIdVille() == trajet.getVilleDepart().getIdVille()) ? "selected" : "";
                                        %>
                                            <option value="<%= v.getIdVille() %>" <%= sel %>><%= v.getNomVille() %></option>
                                        <% } %>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Ville d'arrivée</label>
                                    <select name="id_ville_arrivee" id="villeArrivee" class="form-select premium-input" required>
                                        <option value="">-- Sélectionnez d'abord le départ --</option>
                                        <% for(Ville v : villes) { 
                                            String sel = (v.getIdVille() == trajet.getVilleArrivee().getIdVille()) ? "selected" : "";
                                        %>
                                            <option value="<%= v.getIdVille() %>" <%= sel %>><%= v.getNomVille() %></option>
                                        <% } %>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="row mb-4">
                                <div class="col-md-4">
                                    <label class="form-label fw-bold">Distance (km)</label>
                                    <input type="number" step="0.01" name="distance_km" class="form-control premium-input" value="<%= trajet.getDistanceKm() != null ? trajet.getDistanceKm() : "" %>">
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label fw-bold">Durée estimée</label>
                                    <input type="text" name="duree_estimee" class="form-control premium-input" value="<%= trajet.getDureeEstimee() != null ? trajet.getDureeEstimee() : "" %>">
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label fw-bold">Tarif de base (Ar)</label>
                                    <input type="number" step="0.01" name="tarif_base" class="form-control premium-input" required value="<%= trajet.getTarifBase() %>">
                                </div>
                            </div>

                            <div class="d-flex justify-content-end mt-4">
                                <button type="submit" class="btn btn-warning fw-bold px-4 py-2" style="border-radius: 8px;"><i class="fas fa-check-circle me-2"></i>Mettre à jour</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function updateArriveeOptions() {
            var departSelect = document.getElementById("villeDepart");
            var arriveeSelect = document.getElementById("villeArrivee");
            var selectedDepart = departSelect.value;
             
            if (arriveeSelect.value === selectedDepart && selectedDepart !== "") {
                arriveeSelect.value = "";
            }

            for (var i = 0; i < arriveeSelect.options.length; i++) {
                var option = arriveeSelect.options[i];
                if (option.value === "") continue;

                if (option.value === selectedDepart) {
                    option.disabled = true;
                    option.style.display = "none";
                } else {
                    option.disabled = false;
                    option.style.display = "block";
                }
            }
        }
        
        document.addEventListener('DOMContentLoaded', updateArriveeOptions);
    </script>
</body>
</html>
