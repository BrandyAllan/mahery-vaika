<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, backoffice.Utilisateur, gestion.Trajet, gestion.Vehicule, gestion.Chauffeur" %>

<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");

    if (user == null) {
        response.sendRedirect("../index.jsp");
        return;
    }

    if ("Caissier".equals(user.voirsiadmin())) {
        response.sendRedirect("?page=departs/liste-depart");
        return;
    }

    Trajet trajetGestion = new Trajet();

    List<Trajet> lesTrajets = trajetGestion.getTrajetsActifs();
    List<Vehicule> lesVehicules = Vehicule.getVehiculesActifs();
    List<Chauffeur> lesChauffeurs = (List<Chauffeur>) Chauffeur.getTousActifs();

    String erreur = request.getParameter("erreur");
%>

<style>
    .error-message { color: #dc3545; font-size: 0.875em; display: none; margin-top: 0.25rem; }
    .is-invalid { border-color: #dc3545 !important; }
    .is-valid { border-color: #198754 !important; }
    #infoTrajet { display: none; }
</style>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <a href="?page=departs/gestion-departs" class="btn btn-sm btn-light text-muted border-0 shadow-sm mb-2 hover-shadow">
            <i class="bi bi-arrow-left"></i> Retour
        </a>
        <h2 class="fw-bold mb-0" style="color: #2c3e50;">
            <i class="bi bi-plus-circle text-primary me-2"></i> Créer un nouveau départ
        </h2>
    </div>
</div>

<div class="row justify-content-center">
    <div class="col-md-8">
        <% if ("vehicule".equals(erreur)) { %>
            <div class="alert alert-danger border-0 shadow-sm rounded-4 d-flex align-items-center mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i>
                Ce véhicule est <strong>déjà affecté</strong> à un autre départ à cette date et heure.
            </div>
        <% } else if ("chauffeur".equals(erreur)) { %>
            <div class="alert alert-danger border-0 shadow-sm rounded-4 d-flex align-items-center mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i>
                Ce chauffeur est <strong>déjà affecté</strong> à un autre départ à cette date et heure.
            </div>
        <% } %>

        <form action="../traitement/departs/ajouter-depart.jsp" method="post" id="formAjout" novalidate>
            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-body p-5">
                    <h5 class="card-title text-primary fw-bold mb-4"><i class="bi bi-map-fill me-2"></i>Trajet</h5>

                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Trajet <span class="text-danger">*</span></label>
                            <select name="id_trajet" id="selectTrajet" class="form-select form-select-lg bg-light border-0" required>
                                <option value="">-- Sélectionner un trajet --</option>
                                <% for (Trajet t : lesTrajets) { %>
                                    <option value="<%= t.getIdTrajet() %>"
                                            data-depart="<%= t.getVilleDepart() != null ? t.getVilleDepart().getNomVille() : "" %>"
                                            data-arrivee="<%= t.getVilleArrivee() != null ? t.getVilleArrivee().getNomVille() : "" %>"
                                            data-tarif="<%= t.getTarifBase() %>"
                                            data-duree="<%= t.getDureeEstimee() %>"
                                            data-distance="<%= t.getDistanceKm() %>">
                                        <%= t.getVilleDepart() != null ? t.getVilleDepart().getNomVille() : "" %> → <%= t.getVilleArrivee() != null ? t.getVilleArrivee().getNomVille() : "" %>
                                    </option>
                                <% } %>
                            </select>
                            <span class="error-message">Veuillez sélectionner un trajet.</span>
                        </div>
                        <div class="col-md-6">
                            <div id="infoTrajet" class="card border-0 bg-light rounded-4 h-100">
                                <div class="card-body p-4">
                                    <h6 class="card-title text-primary fw-bold mb-3"><i class="bi bi-info-circle-fill me-2"></i>Détails du trajet</h6>
                                    <div class="row g-2 small">
                                        <div class="col-6"><span class="text-muted">Départ :</span> <strong id="infoVilleDepart" class="text-dark">—</strong></div>
                                        <div class="col-6"><span class="text-muted">Arrivée :</span> <strong id="infoVilleArrivee" class="text-dark">—</strong></div>
                                        <div class="col-6"><span class="text-muted">Distance :</span> <strong id="infoDistance" class="text-dark">—</strong> km</div>
                                        <div class="col-6"><span class="text-muted">Durée :</span> <strong id="infoDuree" class="text-dark">—</strong></div>
                                        <div class="col-12 mt-2"><span class="text-muted">Tarif de base :</span> <strong id="infoTarif" class="text-success fs-5">—</strong> Ar</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-body p-5">
                    <h5 class="card-title text-primary fw-bold mb-4"><i class="bi bi-people-fill me-2"></i>Affectation</h5>

                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Véhicule <span class="text-danger">*</span></label>
                            <select name="id_vehicule" class="form-select form-select-lg bg-light border-0" required>
                                <option value="">-- Sélectionner un véhicule --</option>
                                <% for (Vehicule v : lesVehicules) { %>
                                    <option value="<%= v.getIdVehicule() %>">
                                        <%= v.getImmatriculation() %> (capacité : <%= v.getCapacite() %> places)
                                    </option>
                                <% } %>
                            </select>
                            <span class="error-message">Veuillez sélectionner un véhicule.</span>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Chauffeur <span class="text-danger">*</span></label>
                            <select name="id_chauffeur" class="form-select form-select-lg bg-light border-0" required>
                                <option value="">-- Sélectionner un chauffeur --</option>
                                <% for (Chauffeur c : lesChauffeurs) { %>
                                    <option value="<%= c.getIdChauffeur() %>">
                                        <%= c.getNom() %> <%= c.getPrenom() != null ? c.getPrenom() : "" %>
                                    </option>
                                <% } %>
                            </select>
                            <span class="error-message">Veuillez sélectionner un chauffeur.</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-body p-5">
                    <h5 class="card-title text-primary fw-bold mb-4"><i class="bi bi-calendar-event-fill me-2"></i>Planification</h5>

                    <div class="row g-4">
                        <div class="col-md-4">
                            <label class="form-label fw-semibold text-secondary">Date de départ <span class="text-danger">*</span></label>
                            <input type="date" name="date_depart" class="form-control form-control-lg bg-light border-0" required min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                            <span class="error-message">Veuillez saisir une date.</span>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold text-secondary">Heure de départ <span class="text-danger">*</span></label>
                            <input type="time" name="heure_depart" class="form-control form-control-lg bg-light border-0" required>
                            <span class="error-message">Veuillez saisir une heure.</span>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold text-secondary">Statut</label>
                            <select name="statut" class="form-select form-select-lg bg-light border-0">
                                <option value="PLANIFIE" selected>Planifié</option>
                                <option value="EN_COURS">En cours</option>
                                <option value="TERMINE">Terminé</option>
                                <option value="ANNULE">Annulé</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            <div class="d-flex justify-content-between mt-4">
                <a href="?page=departs/liste-depart" class="btn btn-light btn-lg px-4 text-secondary shadow-sm hover-shadow">Annuler</a>
                <button type="submit" class="btn btn-primary btn-lg px-4 shadow-sm hover-shadow">
                    <i class="bi bi-save me-2"></i>Enregistrer le départ
                </button>
            </div>
        </form>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const selectTrajet = document.getElementById("selectTrajet");
    const infoBox = document.getElementById("infoTrajet");
    const form = document.getElementById("formAjout");

    selectTrajet.addEventListener("change", function () {
        const selected = this.options[this.selectedIndex];

        if (this.value === "") {
            infoBox.style.display = "none";
            return;
        }

        document.getElementById("infoVilleDepart").textContent = selected.dataset.depart || "—";
        document.getElementById("infoVilleArrivee").textContent = selected.dataset.arrivee || "—";
        document.getElementById("infoDistance").textContent = selected.dataset.distance || "—";
        document.getElementById("infoDuree").textContent = selected.dataset.duree || "—";
        document.getElementById("infoTarif").textContent = selected.dataset.tarif || "—";

        infoBox.style.display = "block";
    });

    const inputs = form.querySelectorAll("input[required], select[required]");

    inputs.forEach(function (input) {
        input.addEventListener("blur", function () { validateField(this); });
        input.addEventListener("change", function () { validateField(this); });
    });

    function validateField(field) {
        const errorSpan = field.parentElement.querySelector(".error-message");
        const valid = field.value.trim() !== "";

        if (!valid) {
            field.classList.add("is-invalid");
            field.classList.remove("is-valid");
            if (errorSpan) errorSpan.style.display = "block";
        } else {
            field.classList.remove("is-invalid");
            field.classList.add("is-valid");
            if (errorSpan) errorSpan.style.display = "none";
        }

        return valid;
    }

    form.addEventListener("submit", function (e) {
        let allValid = true;
        inputs.forEach(function (input) {
            if (!validateField(input)) allValid = false;
        });
        if (!allValid) {
            e.preventDefault();
            alert("Veuillez remplir tous les champs obligatoires.");
        }
    });
});
</script>
