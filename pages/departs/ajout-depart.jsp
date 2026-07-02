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

    Trajet trajetGestion = new Trajet();
    List<Trajet>   lesTrajets    = trajetGestion.getTrajetsActifs();
    List<Vehicule> lesVehicules  = Vehicule.getVehiculesActifs();
    List<Chauffeur> lesChauffeurs = (List<Chauffeur>) Chauffeur.getTousActifs();

    String erreur = request.getParameter("erreur");
%>


 <meta charset="UTF-8">
    <style>
        .error-message { color: red; font-size: 0.9em; display: none; }
        .is-invalid    { border-color: red; }
        .is-valid      { border-color: green; }
        #infoTrajet    { display: none; }
    </style>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2><i class="bi bi-plus-circle"></i> Ajouter un départ</h2>
        <a href="?page=departs/liste-depart" class="btn btn-secondary btn-sm">
            <i class="bi bi-arrow-left"></i> Retour
        </a>
    </div>

  
    <% if ("vehicule".equals(erreur)) { %>
        <div class="alert alert-danger">
            <i class="bi bi-exclamation-triangle"></i>
            Ce véhicule est <strong>déjà affecté</strong> à un autre départ à cette date et heure.
        </div>
    <% } else if ("chauffeur".equals(erreur)) { %>
        <div class="alert alert-danger">
            <i class="bi bi-exclamation-triangle"></i>
            Ce chauffeur est <strong>déjà affecté</strong> à un autre départ à cette date et heure.
        </div>
    <% } %>

    <form action="../traitement/departs/ajouter-depart.jsp" method="post"
          class="row g-3" id="formAjout" novalidate>

        
        <div class="col-md-6">
            <label class="form-label fw-semibold">Trajet <span class="text-danger">*</span></label>
            <select name="id_trajet" id="selectTrajet" class="form-select" required>
                <option value="">-- Sélectionner un trajet --</option>
                <% for (Trajet t : lesTrajets) { %>
                    <option value="<%= t.getIdTrajet() %>"
                            data-depart="<%= t.getVilleDepart().getNomVille() %>"
                            data-arrivee="<%= t.getVilleArrivee().getNomVille() %>"
                            data-tarif="<%= t.getTarifBase() %>"
                            data-duree="<%= t.getDureeEstimee() %>"
                            data-distance="<%= t.getDistanceKm() %>">
                        <%= t.getVilleDepart().getNomVille() %> → <%= t.getVilleArrivee().getNomVille() %>
                    </option>
                <% } %>
            </select>
            <span class="error-message">Veuillez sélectionner un trajet.</span>
        </div>

       
        <div class="col-md-6">
            <div id="infoTrajet" class="card border-primary h-100">
                <div class="card-body py-2">
                    <h6 class="card-title text-primary mb-2">
                        <i class="bi bi-info-circle"></i> Détails du trajet
                    </h6>
                    <div class="row g-1 small">
                        <div class="col-6">
                            <span class="text-muted">Départ :</span>
                            <strong id="infoVilleDepart">—</strong>
                        </div>
                        <div class="col-6">
                            <span class="text-muted">Arrivée :</span>
                            <strong id="infoVilleArrivee">—</strong>
                        </div>
                        <div class="col-6">
                            <span class="text-muted">Distance :</span>
                            <strong id="infoDistance">—</strong> km
                        </div>
                        <div class="col-6">
                            <span class="text-muted">Durée :</span>
                            <strong id="infoDuree">—</strong>
                        </div>
                        <div class="col-12">
                            <span class="text-muted">Tarif de base :</span>
                            <strong id="infoTarif" class="text-success">—</strong> Ar
                        </div>
                    </div>
                </div>
            </div>
        </div>

       
        <div class="col-md-6">
            <label class="form-label fw-semibold">Véhicule <span class="text-danger">*</span></label>
            <select name="id_vehicule" class="form-select" required>
                <option value="">-- Sélectionner un véhicule --</option>
                <% for (Vehicule v : lesVehicules) { %>
                    <option value="<%= v.getIdVehicule() %>">
                        <%= v.getImmatriculation() %>
                        (capacité : <%= v.getCapacite() %> places)
                    </option>
                <% } %>
            </select>
            <span class="error-message">Veuillez sélectionner un véhicule.</span>
        </div>

       
        <div class="col-md-6">
            <label class="form-label fw-semibold">Chauffeur <span class="text-danger">*</span></label>
            <select name="id_chauffeur" class="form-select" required>
                <option value="">-- Sélectionner un chauffeur --</option>
                <% for (Chauffeur c : lesChauffeurs) { %>
                    <option value="<%= c.getIdChauffeur() %>">
                        <%= c.getNom() %> <%= c.getPrenom() %>
                    </option>
                <% } %>
            </select>
            <span class="error-message">Veuillez sélectionner un chauffeur.</span>
        </div>

      
        <div class="col-md-4">
            <label class="form-label fw-semibold">Date de départ <span class="text-danger">*</span></label>
            <input type="date" name="date_depart" class="form-control" required
                   min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
            <span class="error-message">Veuillez saisir une date.</span>
        </div>

        <!-- heure -->
        <div class="col-md-4">
            <label class="form-label fw-semibold">Heure de départ <span class="text-danger">*</span></label>
            <input type="time" name="heure_depart" class="form-control" required>
            <span class="error-message">Veuillez saisir une heure.</span>
        </div>

       
        <div class="col-md-4">
            <label class="form-label fw-semibold">Statut</label>
            <select name="statut" class="form-select">
                <option value="PLANIFIE" selected>Planifié</option>
                <option value="EN_COURS">En cours</option>
                <option value="TERMINE">Terminé</option>
                <option value="ANNULE">Annulé</option>
            </select>
        </div>

       
        <div class="col-12 d-flex gap-2 mt-2">
            <button type="submit" class="btn btn-success">
                <i class="bi bi-check-lg"></i> Enregistrer le départ
            </button>
            <a href="?page=departs/liste-depart" class="btn btn-outline-secondary">
                <i class="bi bi-x-lg"></i> Annuler
            </a>
        </div>

    </form>
</div>

<script>

document.getElementById('selectTrajet').addEventListener('change', function () {
    const selected = this.options[this.selectedIndex];
    const infoBox  = document.getElementById('infoTrajet');

    if (this.value === '') {
        infoBox.style.display = 'none';
        return;
    }

    document.getElementById('infoVilleDepart').textContent  = selected.dataset.depart   || '—';
    document.getElementById('infoVilleArrivee').textContent = selected.dataset.arrivee  || '—';
    document.getElementById('infoDistance').textContent     = selected.dataset.distance || '—';
    document.getElementById('infoDuree').textContent        = selected.dataset.duree    || '—';
    document.getElementById('infoTarif').textContent        = selected.dataset.tarif    || '—';

    infoBox.style.display = 'block';
});

// validation cote client
document.addEventListener('DOMContentLoaded', function () {
    const form   = document.getElementById('formAjout');
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


