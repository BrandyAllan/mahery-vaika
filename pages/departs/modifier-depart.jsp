<%@ page import="java.util.*, backoffice.Utilisateur, gestion.Depart" %>
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

    int id = 0;
    try { id = Integer.parseInt(request.getParameter("id")); } catch (Exception e) {}
    if (id == 0) {
        response.sendRedirect("?page=departs/liste-depart");
        return;
    }

    Depart d = Depart.getById(id);
    if (d == null) {
        response.sendRedirect("?page=departs/liste-depart");
        return;
    }

    Vector<Depart> lesTrajets    = Depart.getTousLesTrajets();
    Vector<Depart> lesVehicules  = Depart.getTousLesVehicules();
    Vector<Depart> lesChauffeurs = Depart.getTousLesChauffeurs();

   
    String erreur = request.getParameter("erreur");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier un départ - Mahery Vaika</title>
    <link rel="stylesheet" href="../assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/bootstrap/icons/bootstrap-icons.min.css">
    <style>
        .error-message { color: red; font-size: 0.9em; display: none; }
        .is-invalid    { border-color: red; }
        .is-valid      { border-color: green; }
    </style>
</head>
<body>
<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2><i class="bi bi-pencil-square"></i> Modifier le départ #<%= d.getId_depart() %></h2>
        <a href="?page=departs/liste-depart" class="btn btn-secondary btn-sm">
            <i class="bi bi-arrow-left"></i> Retour
        </a>
    </div>

    <!--message d'erreur-->
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

    <form action="../traitement/departs/modifier-depart.jsp" method="post"
          class="row g-3" id="formModif" novalidate>

        <input type="hidden" name="id_depart" value="<%= d.getId_depart() %>">

        <!-- liste deroulante -->
        <div class="col-md-6">
            <label class="form-label fw-semibold">Trajet <span class="text-danger">*</span></label>
            <select name="id_trajet" id="selectTrajet" class="form-select" required>
                <option value="">-- Sélectionner un trajet --</option>
                <% for (Depart t : lesTrajets) {
                    boolean selected = (t.getId_trajet() == d.getId_trajet());
                %>
                    <option value="<%= t.getId_trajet() %>"
                            data-depart="<%= t.getVille_depart() %>"
                            data-arrivee="<%= t.getVille_arrivee() %>"
                            data-tarif="<%= t.getTarif_base() %>"
                            data-duree="<%= t.getDuree_estimee() %>"
                            data-distance="<%= t.getDistance_km() %>"
                            <%= selected ? "selected" : "" %>>
                        <%= t.getVille_depart() %> → <%= t.getVille_arrivee() %>
                    </option>
                <% } %>
            </select>
            <span class="error-message">Veuillez sélectionner un trajet.</span>
        </div>

        <!-- carte trajet -->
        <div class="col-md-6">
            <div id="infoTrajet" class="card border-primary h-100">
                <div class="card-body py-2">
                    <h6 class="card-title text-primary mb-2">
                        <i class="bi bi-info-circle"></i> Détails du trajet
                    </h6>
                    <div class="row g-1 small">
                        <div class="col-6">
                            <span class="text-muted">Départ :</span>
                            <strong id="infoVilleDepart"><%= d.getVille_depart() %></strong>
                        </div>
                        <div class="col-6">
                            <span class="text-muted">Arrivée :</span>
                            <strong id="infoVilleArrivee"><%= d.getVille_arrivee() %></strong>
                        </div>
                        <div class="col-6">
                            <span class="text-muted">Distance :</span>
                            <strong id="infoDistance"><%= d.getDistance_km() %></strong> km
                        </div>
                        <div class="col-6">
                            <span class="text-muted">Durée :</span>
                            <strong id="infoDuree"><%= d.getDuree_estimee() %></strong>
                        </div>
                        <div class="col-12">
                            <span class="text-muted">Tarif de base :</span>
                            <strong id="infoTarif" class="text-success"><%= d.getTarif_base() %></strong> Ar
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- vehicule -->
        <div class="col-md-6">
            <label class="form-label fw-semibold">Véhicule <span class="text-danger">*</span></label>
            <select name="id_vehicule" class="form-select" required>
                <option value="">-- Sélectionner un véhicule --</option>
                <% for (Depart v : lesVehicules) { %>
                    <option value="<%= v.getId_vehicule() %>"
                        <%= v.getId_vehicule() == d.getId_vehicule() ? "selected" : "" %>>
                        <%= v.getImmatriculation() %>
                        (capacité : <%= v.getCapacite_vehicule() %> places)
                    </option>
                <% } %>
            </select>
            <span class="error-message">Veuillez sélectionner un véhicule.</span>
        </div>

        <!-- chauffeur -->
        <div class="col-md-6">
            <label class="form-label fw-semibold">Chauffeur <span class="text-danger">*</span></label>
            <select name="id_chauffeur" class="form-select" required>
                <option value="">-- Sélectionner un chauffeur --</option>
                <% for (Depart c : lesChauffeurs) { %>
                    <option value="<%= c.getId_chauffeur() %>"
                        <%= c.getId_chauffeur() == d.getId_chauffeur() ? "selected" : "" %>>
                        <%= c.getNom_chauffeur() %> <%= c.getPrenom_chauffeur() %>
                    </option>
                <% } %>
            </select>
            <span class="error-message">Veuillez sélectionner un chauffeur.</span>
        </div>

        <!-- date -->
        <div class="col-md-4">
            <label class="form-label fw-semibold">Date de départ <span class="text-danger">*</span></label>
            <input type="date" name="date_depart" class="form-control" required
                   value="<%= d.getDate_depart() %>">
            <span class="error-message">Veuillez saisir une date.</span>
        </div>

        <!-- heure -->
        <div class="col-md-4">
            <label class="form-label fw-semibold">Heure de départ <span class="text-danger">*</span></label>
            <input type="time" name="heure_depart" class="form-control" required
                   value="<%= d.getHeure_depart() != null ? d.getHeure_depart().toString().substring(0, 5) : "" %>">
            <span class="error-message">Veuillez saisir une heure.</span>
        </div>

        <!-- statut -->
        <div class="col-md-4">
            <label class="form-label fw-semibold">Statut</label>
            <select name="statut" class="form-select">
                <option value="PLANIFIE" <%= "PLANIFIE".equals(d.getStatut()) ? "selected" : "" %>>Planifié</option>
                <option value="EN_COURS" <%= "EN_COURS".equals(d.getStatut()) ? "selected" : "" %>>En cours</option>
                <option value="TERMINE"  <%= "TERMINE".equals(d.getStatut())  ? "selected" : "" %>>Terminé</option>
                <option value="ANNULE"   <%= "ANNULE".equals(d.getStatut())   ? "selected" : "" %>>Annulé</option>
            </select>
        </div>


        <div class="col-12 d-flex gap-2 mt-2">
            <button type="submit" class="btn btn-primary">
                <i class="bi bi-check-lg"></i> Enregistrer les modifications
            </button>
            <a href="?page=departs/liste-depart" class="btn btn-outline-secondary">
                <i class="bi bi-x-lg"></i> Annuler
            </a>
        </div>

    </form>
</div>

<script>

//liste deroulante
document.getElementById('selectTrajet').addEventListener('change', function () {
    const selected = this.options[this.selectedIndex];
    if (this.value === '') return;

    document.getElementById('infoVilleDepart').textContent  = selected.dataset.depart   || '—';
    document.getElementById('infoVilleArrivee').textContent = selected.dataset.arrivee  || '—';
    document.getElementById('infoDistance').textContent     = selected.dataset.distance || '—';
    document.getElementById('infoDuree').textContent        = selected.dataset.duree    || '—';
    document.getElementById('infoTarif').textContent        = selected.dataset.tarif    || '—';
});


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

<script src="../assets/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>

