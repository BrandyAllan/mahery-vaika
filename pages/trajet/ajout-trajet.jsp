<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="gestion.Ville, java.util.List" %>
<%@ page import="backoffice.Utilisateur" %>
<%
    Utilisateur userObj = (Utilisateur) session.getAttribute("utilisateur");
    if (userObj == null) {
        response.sendRedirect("../index.jsp");
        return;
    }

    boolean isAdmin = "Admin".equalsIgnoreCase(userObj.voirsiadmin());

    if (!isAdmin) {
%>
    <div class="container mt-5">
        <div class="alert alert-danger text-center border-0 shadow-sm rounded-4">
            <i class="bi bi-lock-fill me-2"></i> Accès refusé. Vous devez être administrateur pour ajouter un trajet.
        </div>
    </div>
<%
        return;
    }

    Ville villeGestion = new Ville();
    List<Ville> villes = villeGestion.getAllVilles();
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <a href="?page=trajet/liste-trajet" class="btn btn-sm btn-light text-muted border-0 shadow-sm mb-2 hover-shadow">
            <i class="bi bi-arrow-left"></i> Retour à la liste
        </a>
        <h2 class="fw-bold mb-0" style="color: #2c3e50;">
            <i class="bi bi-plus-circle text-primary me-2"></i> Créer un nouveau trajet
        </h2>
    </div>
</div>

<div class="row justify-content-center">
    <div class="col-md-8">
        <%
            String errAjout = request.getParameter("error");
        %>
        <% if ("sql".equals(errAjout)) { %>
            <div class="alert alert-danger border-0 shadow-sm rounded-4 d-flex align-items-center mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i>
                Une erreur de base de données est survenue. Veuillez réessayer.
            </div>
        <% } else if ("invalid_data".equals(errAjout)) { %>
            <div class="alert alert-warning border-0 shadow-sm rounded-4 d-flex align-items-center mb-4" role="alert">
                <i class="bi bi-exclamation-circle-fill me-2 fs-5"></i>
                Données invalides : les villes doivent être différentes et le tarif est obligatoire.
            </div>
        <% } %>

        <form action="../traitement/trajet/ajouter-trajet.jsp" method="POST">
            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-body p-5">
                    <h5 class="card-title text-primary fw-bold mb-4"><i class="bi bi-map-fill me-2"></i>Itinéraire</h5>
                    
                    <div class="row g-4 mb-4">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Ville de départ <span class="text-danger">*</span></label>
                            <select name="id_ville_depart" id="villeDepart" class="form-select form-select-lg bg-light border-0" required onchange="updateArriveeOptions()">
                                <option value="">-- Sélectionnez une ville --</option>
                                <% for(Ville v : villes) { %>
                                    <option value="<%= v.getIdVille() %>"><%= v.getNomVille() %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Ville d'arrivée <span class="text-danger">*</span></label>
                            <select name="id_ville_arrivee" id="villeArrivee" class="form-select form-select-lg bg-light border-0" required>
                                <option value="">-- Sélectionnez d'abord le départ --</option>
                                <% for(Ville v : villes) { %>
                                    <option value="<%= v.getIdVille() %>"><%= v.getNomVille() %></option>
                                <% } %>
                            </select>
                            <div class="form-text text-muted mt-2"><i class="bi bi-info-circle me-1"></i>L'arrivée doit être différente du départ.</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-body p-5">
                    <h5 class="card-title text-primary fw-bold mb-4"><i class="bi bi-info-square-fill me-2"></i>Détails du trajet</h5>

                    <div class="row g-4">
                        <div class="col-md-4">
                            <label class="form-label fw-semibold text-secondary">Distance (km)</label>
                            <input type="number" step="0.01" name="distance_km" class="form-control form-control-lg bg-light border-0" placeholder="Ex: 350.5">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold text-secondary">Durée estimée</label>
                            <input type="text" name="duree_estimee" class="form-control form-control-lg bg-light border-0" placeholder="Ex: 8h 30min">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold text-secondary">Tarif de base (Ar) <span class="text-danger">*</span></label>
                            <input type="number" step="0.01" name="tarif_base" class="form-control form-control-lg bg-light border-0" required placeholder="Ex: 60000">
                        </div>
                    </div>
                </div>
            </div>

            <div class="d-flex justify-content-between mt-4">
                <button type="reset" class="btn btn-light btn-lg px-4 text-secondary shadow-sm hover-shadow">Réinitialiser</button>
                <button type="submit" class="btn btn-primary btn-lg px-4 shadow-sm hover-shadow"><i class="bi bi-save me-2"></i>Enregistrer le trajet</button>
            </div>
        </form>
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
