<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="gestion.VilleGestion, models.Ville, java.util.List" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    boolean isAdmin = "ADMIN".equals(role);

    if (!isAdmin) {
        response.sendRedirect("gestion-trajet.jsp");
        return;
    }

    VilleGestion villeGestion = new VilleGestion();
    List<Ville> villes = villeGestion.getAllVilles();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ajouter un Trajet</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../../assets/css/styles-premium.css">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark" style="background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);">
        <div class="container">
            <a class="navbar-brand fw-bold" href="gestion-trajet.jsp"><i class="fas fa-arrow-left me-2"></i>Retour</a>
            <span class="navbar-text text-white fw-bold">
                <i class="fas fa-bus-alt me-2"></i>Mahery Vaika
            </span>
        </div>
    </nav>

    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card premium-card">
                    <div class="card-header premium-card-header">
                        <h4 class="mb-0"><i class="fas fa-route me-2"></i>Créer un nouveau trajet</h4>
                    </div>
                    <div class="card-body p-4">
                        <%
                            String errAjout = request.getParameter("error");
                        %>
                        <% if ("sql".equals(errAjout)) { %>
                            <div class="alert alert-danger d-flex align-items-center mb-3" role="alert">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                Une erreur de base de données est survenue. Veuillez réessayer.
                            </div>
                        <% } else if ("invalid_data".equals(errAjout)) { %>
                            <div class="alert alert-warning d-flex align-items-center mb-3" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>
                                Données invalides : les villes doivent être différentes et le tarif est obligatoire.
                            </div>
                        <% } %>
                        <form action="../../traitement/trajet/ajouter-trajet.jsp" method="POST">
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Ville de départ</label>
                                    <select name="id_ville_depart" id="villeDepart" class="form-select premium-input" required onchange="updateArriveeOptions()">
                                        <option value="">-- Sélectionnez une ville --</option>
                                        <% for(Ville v : villes) { %>
                                            <option value="<%= v.getIdVille() %>"><%= v.getNomVille() %></option>
                                        <% } %>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Ville d'arrivée</label>
                                    <select name="id_ville_arrivee" id="villeArrivee" class="form-select premium-input" required>
                                        <option value="">-- Sélectionnez d'abord le départ --</option>
                                        <% for(Ville v : villes) { %>
                                            <option value="<%= v.getIdVille() %>"><%= v.getNomVille() %></option>
                                        <% } %>
                                    </select>
                                    <div class="form-text text-muted"><i class="fas fa-info-circle me-1"></i>L'arrivée doit être différente du départ.</div>
                                </div>
                            </div>
                            
                            <div class="row mb-4">
                                <div class="col-md-4">
                                    <label class="form-label fw-bold">Distance (km)</label>
                                    <input type="number" step="0.01" name="distance_km" class="form-control premium-input" placeholder="Ex: 350.5">
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label fw-bold">Durée estimée</label>
                                    <input type="text" name="duree_estimee" class="form-control premium-input" placeholder="Ex: 8h 30min">
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label fw-bold">Tarif de base (Ar)</label>
                                    <input type="number" step="0.01" name="tarif_base" class="form-control premium-input" required placeholder="Ex: 60000">
                                </div>
                            </div>

                            <div class="d-flex justify-content-end mt-4">
                                <button type="reset" class="btn btn-outline-premium me-2">Réinitialiser</button>
                                <button type="submit" class="btn btn-premium"><i class="fas fa-save me-2"></i>Enregistrer le trajet</button>
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
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
