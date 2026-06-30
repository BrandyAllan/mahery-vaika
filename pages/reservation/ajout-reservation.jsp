<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, backoffice.Reservation, backoffice.Utilisateur" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) {
        response.sendRedirect("../index.jsp");
        return;
    }

    Vector<Reservation> departs = Reservation.getAllDeparts();
%>

<style>
    .siege-btn { width: 40px; height: 40px; margin: 2px; }
    .siege-disponible { background-color: #198754; color: white; border: none; }
    .siege-reserve { background-color: #dc3545; color: white; border: none; cursor: not-allowed; }
    .siege-selectionne { background-color: #0d6efd; color: white; border: none; }
    .bus-layout {
        display: inline-block;
        background-color: #333;
        padding: 15px;
        border-radius: 10px;
    }
    .bus-row {
        display: flex;
        justify-content: center;
        margin-bottom: 5px;
    }
    .bus-aisle {
        width: 30px;
        margin: 0 5px;
    }
    .bus-front {
        background-color: #666;
        color: white;
        text-align: center;
        padding: 5px;
        border-radius: 5px 5px 0 0;
        margin-bottom: 10px;
        font-weight: bold;
    }
</style>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold">Ajouter une réservation</h2>

        <a href="model.jsp?page=reservation/gestion-reservation" class="btn btn-secondary">
            <i class="bi bi-arrow-left"></i> Retour
        </a>
    </div>

    <form action="traitement/ajouter-reservation.jsp" method="post" id="formAjout" novalidate>
        <div class="card mb-3">
            <div class="card-header">
                <i class="bi bi-bus-front"></i> Sélectionner un départ
            </div>

            <div class="card-body">
                <div class="mb-3">
                    <label for="idDepart" class="form-label">Départ *</label>

                    <select name="idDepart" id="idDepart" class="form-select" required>
                        <option value="">-- Choisir un départ --</option>

                        <% for (Reservation d : departs) { %>
                            <option value="<%= d.getId_depart() %>"
                                    data-trajet="<%= d.getId_trajet() %>"
                                    data-date="<%= d.getDate_depart() %>"
                                    data-heure="<%= d.getHeure_depart() %>"
                                    data-ville-depart="<%= d.getVille_depart() %>"
                                    data-ville-arrivee="<%= d.getVille_arrivee() %>">
                                <%= d.getVille_depart() %> → <%= d.getVille_arrivee() %> |
                                <%= d.getDate_depart() %> à <%= d.getHeure_depart() %>
                            </option>
                        <% } %>
                    </select>
                </div>

                <div id="infoDepart" class="alert alert-info d-none">
                    <strong>Trajet :</strong> <span id="infoTrajet"></span><br>
                    <strong>Date :</strong> <span id="infoDate"></span> à <span id="infoHeure"></span>
                </div>
            </div>
        </div>

        <div class="card mb-3">
            <div class="card-header">
                <i class="bi bi-person"></i> Informations passager
            </div>

            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Nom *</label>
                        <input type="text" name="nomPassager" class="form-control" required>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Prénom</label>
                        <input type="text" name="prenomPassager" class="form-control">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Téléphone (+261)</label>
                        <div class="input-group">
                            <span class="input-group-text">+261</span>
                            <input type="text" name="telephonePassager" class="form-control"
                                   placeholder="321234567" pattern="[0-9]{9}" maxlength="9">
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card mb-3">
            <div class="card-header">
                <i class="bi bi-grid"></i> Sélectionner un siège
            </div>

            <div class="card-body">
                <input type="hidden" name="numeroSiege" id="numeroSiege" value="">

                <div id="siegesContainer" class="text-center">
                    <p class="text-muted">Veuillez d'abord sélectionner un départ.</p>
                </div>

                <div class="mt-3">
                    <span class="badge bg-success">Disponible</span>
                    <span class="badge bg-danger ms-2">Réservé</span>
                    <span class="badge bg-primary ms-2">Sélectionné</span>
                </div>
            </div>
        </div>

        <button type="submit" class="btn btn-primary" id="btnSubmit" disabled>
            <i class="bi bi-check-circle"></i> Confirmer la réservation
        </button>

        <a href="model.jsp?page=reservation/gestion-reservation" class="btn btn-secondary">
            Annuler
        </a>
    </form>


<script>
let capaciteMax = 0;
let siegeSelectionne = null;

document.getElementById('idDepart').addEventListener('change', function() {
    const departId = this.value;
    const infoDepart = document.getElementById('infoDepart');

    if (!departId) {
        infoDepart.classList.add('d-none');
        document.getElementById('siegesContainer').innerHTML =
            '<p class="text-muted">Veuillez d\\'abord sélectionner un départ.</p>';
        document.getElementById('btnSubmit').disabled = true;
        return;
    }

    const option = this.options[this.selectedIndex];

    document.getElementById('infoTrajet').textContent =
        option.dataset.villeDepart + ' → ' + option.dataset.villeArrivee;

    document.getElementById('infoDate').textContent = option.dataset.date;
    document.getElementById('infoHeure').textContent = option.dataset.heure;

    infoDepart.classList.remove('d-none');

    chargerSieges(departId);
});

function chargerSieges(departId) {
    fetch('traitement/ajouter-reservation.jsp?action=sieges&idDepart=' + departId)
        .then(response => {
            if (!response.ok) {
                throw new Error('HTTP ' + response.status);
            }
            return response.json();
        })
        .then(data => {
            capaciteMax = data.capacite;
            const siegesReserves = data.siegesReserves;

            if (capaciteMax <= 0) {
                document.getElementById('siegesContainer').innerHTML =
                    '<p class="text-danger">Capacité du véhicule inconnue.</p>';
                return;
            }

            const nbSiegesParRang = 4;
            const nbRangees = Math.ceil(capaciteMax / nbSiegesParRang);

            let html = '<div class="bus-layout">';
            html += '<div class="bus-front">Minibus</div>';

            for (let r = 0; r < nbRangees; r++) {
                html += '<div class="bus-row">';

                for (let c = 0; c < 2; c++) {
                    const siegeNum = r * nbSiegesParRang + c + 1;
                    if (siegeNum <= capaciteMax) {
                        const estReserve = siegesReserves.includes(siegeNum);
                        const classe = estReserve ? 'siege-reserve' : 'siege-disponible';

                        html += '<button type="button" class="btn ' + classe + ' siege-btn" ' +
                                'data-siege="' + siegeNum + '" ' + (estReserve ? 'disabled' : '') +
                                ' onclick="selectionnerSiege(' + siegeNum + ', this)">' +
                                siegeNum + '</button>';
                    }
                }

                html += '<div class="bus-aisle"></div>';

                for (let c = 2; c < 4; c++) {
                    const siegeNum = r * nbSiegesParRang + c + 1;
                    if (siegeNum <= capaciteMax) {
                        const estReserve = siegesReserves.includes(siegeNum);
                        const classe = estReserve ? 'siege-reserve' : 'siege-disponible';

                        html += '<button type="button" class="btn ' + classe + ' siege-btn" ' +
                                'data-siege="' + siegeNum + '" ' + (estReserve ? 'disabled' : '') +
                                ' onclick="selectionnerSiege(' + siegeNum + ', this)">' +
                                siegeNum + '</button>';
                    }
                }

                html += '</div>';
            }

            html += '</div>';

            document.getElementById('siegesContainer').innerHTML = html;
            siegeSelectionne = null;
            document.getElementById('numeroSiege').value = '';
            document.getElementById('btnSubmit').disabled = true;
        })
        .catch(err => {
            document.getElementById('siegesContainer').innerHTML =
                '<p class="text-danger">Erreur lors du chargement des sièges : ' + err.message + '</p>';
        });
}

function selectionnerSiege(numero, btn) {
    document.querySelectorAll('.siege-selectionne').forEach(function(b) {
        b.classList.remove('siege-selectionne');
        b.classList.add('siege-disponible');
    });

    btn.classList.remove('siege-disponible');
    btn.classList.add('siege-selectionne');

    siegeSelectionne = numero;
    document.getElementById('numeroSiege').value = numero;
    document.getElementById('btnSubmit').disabled = false;
}

document.getElementById('formAjout').addEventListener('submit', function(e) {
    if (!siegeSelectionne) {
        e.preventDefault();
        alert('Veuillez sélectionner un siège.');
    }
});
</script>