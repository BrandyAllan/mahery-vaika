<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, backoffice.Utilisateur, gestion.Depart, gestion.Trajet, gestion.Vehicule, gestion.Chauffeur" %>

<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    if (user.voirsiadmin().equals("Caissier")) {
        response.sendRedirect("?page=departs/liste-depart");
        return;
    }

    String idStr = request.getParameter("id");
    if (idStr == null || idStr.isEmpty()) {
        response.sendRedirect("?page=departs/liste-depart");
        return;
    }

    int id = 0;
    try { id = Integer.parseInt(idStr); } catch (Exception e) {}
    if (id == 0) {
        response.sendRedirect("?page=departs/liste-depart");
        return;
    }

    Depart d = Depart.getById(id);
    if (d == null) {
        response.sendRedirect("?page=departs/liste-depart&msg=not_found");
        return;
    }

    Trajet trajetGestion = new Trajet();
    List<Trajet>    lesTrajets    = trajetGestion.getTrajetsActifs();
    List<Vehicule>  lesVehicules  = Vehicule.getVehiculesActifs();
    List<Chauffeur> lesChauffeurs = (List<Chauffeur>) Chauffeur.getTousActifs();

    String erreur = request.getParameter("erreur");
%>

<style>
    .error-message { color: red; font-size: 0.9em; display: none; }
    .is-invalid    { border-color: red; }
    .is-valid      { border-color: green; }
    #infoTrajet    { display: none; }
</style>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <a href="?page=departs/liste-depart" class="btn btn-sm btn-light text-muted border-0 shadow-sm mb-2 hover-shadow">
            <i class="bi bi-arrow-left"></i> Retour à la liste
        </a>
        <h2 class="fw-bold mb-0" style="color: #2c3e50;">
            <i class="bi bi-pencil-square text-primary me-2"></i> Modifier le départ #<%= d.getId_depart() %>
        </h2>
    </div>
</div>

<% if ("vehicule".equals(erreur)) { %>
    <div class="alert alert-danger border-0 shadow-sm"><i class="bi bi-exclamation-triangle-fill me-2"></i>Ce véhicule est <strong>déjà affecté</strong> à un autre départ à cette date et heure.</div>
<% } else if ("chauffeur".equals(erreur)) { %>
    <div class="alert alert-danger border-0 shadow-sm"><i class="bi bi-exclamation-triangle-fill me-2"></i>Ce chauffeur est <strong>déjà affecté</strong> à un autre départ à cette date et heure.</div>
<% } else if ("general".equals(erreur)) { %>
    <div class="alert alert-danger border-0 shadow-sm"><i class="bi bi-exclamation-triangle-fill me-2"></i>Une erreur est survenue lors de la modification.</div>
<% } %>

<div class="card border-0 shadow-sm rounded-4">
    <div class="card-body p-5">
        <form action="../traitement/departs/modifier-depart.jsp" method="post" class="row g-4" id="formModif" novalidate>
            <input type="hidden" name="id_depart" value="<%= d.getId_depart() %>">

            <div class="col-md-6">
                <label class="form-label fw-semibold text-secondary">Trajet <span class="text-danger">*</span></label>
                <select name="id_trajet" id="selectTrajet" class="form-select form-select-lg bg-light border-0" required>
                    <option value="">-- Sélectionner un trajet --</option>
                    <% for (Trajet t : lesTrajets) { %>
                        <option value="<%= t.getIdTrajet() %>"
                                data-depart="<%= t.getVilleDepart().getNomVille() %>"
                                data-arrivee="<%= t.getVilleArrivee().getNomVille() %>"
                                data-tarif="<%= t.getTarifBase() %>"
                                data-duree="<%= t.getDureeEstimee() %>"
                                data-distance="<%= t.getDistanceKm() %>"
                                <%= t.getIdTrajet() == d.getId_trajet() ? "selected" : "" %>>
                            <%= t.getVilleDepart().getNomVille() %> → <%= t.getVilleArrivee().getNomVille() %>
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

            <div class="col-md-6">
                <label class="form-label fw-semibold text-secondary">Véhicule <span class="text-danger">*</span></label>
                <select name="id_vehicule" class="form-select form-select-lg bg-light border-0" required>
                    <option value="">-- Sélectionner un véhicule --</option>
                    <% for (Vehicule v : lesVehicules) { %>
                        <option value="<%= v.getIdVehicule() %>" <%= v.getIdVehicule() == d.getId_vehicule() ? "selected" : "" %>>
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
                        <option value="<%= c.getIdChauffeur() %>" <%= c.getIdChauffeur() == d.getId_chauffeur() ? "selected" : "" %>>
                            <%= c.getNom() %> <%= c.getPrenom() %>
                        </option>
                    <% } %>
                </select>
                <span class="error-message">Veuillez sélectionner un chauffeur.</span>
            </div>

            <div class="col-md-4">
                <label class="form-label fw-semibold text-secondary">Date de départ <span class="text-danger">*</span></label>
                <input type="date" name="date_depart" class="form-control form-control-lg bg-light border-0" required value="<%= d.getDate_depart() %>">
                <span class="error-message">Veuillez saisir une date.</span>
            </div>

            <div class="col-md-4">
                <label class="form-label fw-semibold text-secondary">Heure de départ <span class="text-danger">*</span></label>
                <input type="time" name="heure_depart" class="form-control form-control-lg bg-light border-0" required value="<%= d.getHeure_depart() != null ? d.getHeure_depart().toString().substring(0, 5) : "" %>">
                <span class="error-message">Veuillez saisir une heure.</span>
            </div>

            <div class="col-md-4">
                <label class="form-label fw-semibold text-secondary">Statut</label>
                <select name="statut" class="form-select form-select-lg bg-light border-0">
                    <option value="PLANIFIE"  <%= "PLANIFIE".equals(d.getStatut())  ? "selected" : "" %>>Planifié</option>
                    <option value="EN_COURS"  <%= "EN_COURS".equals(d.getStatut())  ? "selected" : "" %>>En cours</option>
                    <option value="TERMINE"   <%= "TERMINE".equals(d.getStatut())   ? "selected" : "" %>>Terminé</option>
                    <option value="ANNULE"    <%= "ANNULE".equals(d.getStatut())    ? "selected" : "" %>>Annulé</option>
                </select>
            </div>

            <div class="col-12 mt-5 d-flex gap-3">
                <button type="submit" class="btn btn-primary btn-lg px-4 shadow-sm hover-shadow">
                    <i class="bi bi-check-lg me-2"></i> Enregistrer les modifications
                </button>
                <a href="?page=departs/liste-depart" class="btn btn-light btn-lg px-4 text-secondary shadow-sm hover-shadow">Annuler</a>
            </div>
        </form>
    </div>
</div>

<script>
// Afficher l'info trajet au chargement si deja selectionne
window.addEventListener('DOMContentLoaded', function () {
    const sel = document.getElementById('selectTrajet');
    if (sel.value) updateInfoTrajet(sel.options[sel.selectedIndex]);

    sel.addEventListener('change', function () {
        updateInfoTrajet(this.options[this.selectedIndex]);
    });
});

function updateInfoTrajet(opt) {
    const infoBox = document.getElementById('infoTrajet');
    if (!opt || !opt.value) {
        infoBox.style.display = 'none';
        return;
    }
    document.getElementById('infoVilleDepart').textContent  = opt.dataset.depart   || '—';
    document.getElementById('infoVilleArrivee').textContent = opt.dataset.arrivee  || '—';
    document.getElementById('infoDistance').textContent     = opt.dataset.distance || '—';
    document.getElementById('infoDuree').textContent        = opt.dataset.duree    || '—';
    document.getElementById('infoTarif').textContent        = opt.dataset.tarif    || '—';
    infoBox.style.display = 'block';
}

// Validation côte client
document.addEventListener('DOMContentLoaded', function () {
    const form   = document.getElementById('formModif');
    const inputs = form.querySelectorAll('input[required], select[required]');

    inputs.forEach(input => {
        input.addEventListener('blur',   function () { validateField(this); });
        input.addEventListener('change', function () {
            if (this.classList.contains('is-invalid')) validateField(this);
        });
    });

    function validateField(field) {
        const errorSpan = field.parentElement.querySelector('.error-message');
        const valid     = field.value.trim() !== '';
        if (!valid) {
            field.classList.add('is-invalid');
            field.classList.remove('is-valid');
            if (errorSpan) errorSpan.style.display = 'block';
        } else {
            field.classList.remove('is-invalid');
            field.classList.add('is-valid');
            if (errorSpan) errorSpan.style.display = 'none';
        }
        return valid;
    }

    form.addEventListener('submit', function (e) {
        let allValid = true;
        inputs.forEach(input => { if (!validateField(input)) allValid = false; });
        if (!allValid) {
            e.preventDefault();
            alert('Veuillez remplir tous les champs obligatoires.');
        }
    });
});
</script>