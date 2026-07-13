let capaciteMax = 0;
let siegesSelectionnes = [];
let tarifUnitaire = 0;

const panes = document.querySelectorAll('.wizard-step-pane');
const stepsLi = document.querySelectorAll('.wizard-steps li');

function afficherEtape(numero) {
    panes.forEach(p => p.classList.toggle('active', p.dataset.pane === String(numero)));
    stepsLi.forEach(li => {
        const s = parseInt(li.dataset.step, 10);
        li.classList.remove('active', 'done');
        if (s === numero) li.classList.add('active');
        else if (s < numero) li.classList.add('done');
    });
    if (numero === 4) construireRecap();
}

document.querySelectorAll('.btn-suivant').forEach(btn => {
    btn.addEventListener('click', function() {
        const next = parseInt(this.dataset.next, 10);
        if (next === 2 && !document.getElementById('idDepart').value) {
            alert('Veuillez sélectionner un départ.');
            return;
        }
        if (next === 3 && !document.getElementById('nomPassager').value.trim()) {
            alert('Veuillez saisir le nom du passager.');
            return;
        }
        if (next === 4 && siegesSelectionnes.length === 0) {
            alert('Veuillez sélectionner au moins un siège.');
            return;
        }
        afficherEtape(next);
    });
});

document.querySelectorAll('.btn-precedent').forEach(btn => {
    btn.addEventListener('click', function() {
        afficherEtape(parseInt(this.dataset.prev, 10));
    });
});

document.getElementById('idDepart').addEventListener('change', function() {
    const departId = this.value;
    const infoDepart = document.getElementById('infoDepart');

    if (!departId) {
        infoDepart.classList.add('d-none');
        document.getElementById('siegesContainer').innerHTML =
            '<p class="text-muted">Veuillez d\'abord sélectionner un départ.</p>';
        return;
    }

    const option = this.options[this.selectedIndex];

    document.getElementById('infoTrajet').textContent =
        option.dataset.villeDepart + ' → ' + option.dataset.villeArrivee;

    document.getElementById('infoDate').textContent = option.dataset.date;
    document.getElementById('infoHeure').textContent = option.dataset.heure;
    tarifUnitaire = parseFloat(option.dataset.tarif) || 0;
    document.getElementById('infoTarif').textContent = tarifUnitaire.toLocaleString('fr-FR');

    infoDepart.classList.remove('d-none');

    siegesSelectionnes = [];
    chargerSieges(departId);
});

function chargerSieges(departId) {
    fetch('../traitement/reservation/ajouter-reservation.jsp?action=sieges&idDepart=' + departId)
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
                    html += rendreSiege(r, c, nbSiegesParRang, capaciteMax, siegesReserves);
                }

                html += '<div class="bus-aisle"></div>';

                for (let c = 2; c < 4; c++) {
                    html += rendreSiege(r, c, nbSiegesParRang, capaciteMax, siegesReserves);
                }

                html += '</div>';
            }

            html += '</div>';

            document.getElementById('siegesContainer').innerHTML = html;
        })
        .catch(err => {
            document.getElementById('siegesContainer').innerHTML =
                '<p class="text-danger">Erreur lors du chargement des sièges : ' + err.message + '</p>';
        });
}

function rendreSiege(r, c, nbSiegesParRang, capaciteMax, siegesReserves) {
    const siegeNum = r * nbSiegesParRang + c + 1;
    if (siegeNum > capaciteMax) return '';

    const estReserve = siegesReserves.includes(siegeNum);
    const classe = estReserve ? 'siege-reserve' : 'siege-disponible';

    return '<button type="button" class="btn ' + classe + ' siege-btn" ' +
        'data-siege="' + siegeNum + '" ' +
        ' onclick="toggleSiege(' + siegeNum + ', this)">' +
        siegeNum + '</button>';
}

function toggleSiege(numero, btn) {
    const index = siegesSelectionnes.indexOf(numero);

    if (index >= 0) {
        siegesSelectionnes.splice(index, 1);
        btn.classList.remove('siege-selectionne');
        btn.classList.add('siege-disponible');
    } else {
        siegesSelectionnes.push(numero);
        btn.classList.remove('siege-disponible');
        btn.classList.add('siege-selectionne');
    }

    siegesSelectionnes.sort((a, b) => a - b);

    const badge = document.getElementById('siegesChoisis');
    if (siegesSelectionnes.length === 0) {
        badge.textContent = 'aucune';
        badge.classList.add('text-muted');
    } else {
        badge.classList.remove('text-muted');
        badge.innerHTML = siegesSelectionnes.map(n =>
            '<span class="badge bg-primary siege-choisi-badge me-1">N°' + n + '</span>').join('');
    }

    document.getElementById('siegesInput').value = siegesSelectionnes.join(',');
}

function construireRecap() {
    const optionDepart = document.getElementById('idDepart').options[document.getElementById('idDepart').selectedIndex];
    const nom = document.getElementById('nomPassager').value.trim();
    const prenom = document.querySelector('input[name="prenomPassager"]').value.trim();

    document.getElementById('recapTrajet').textContent =
        optionDepart.dataset.villeDepart + ' → ' + optionDepart.dataset.villeArrivee;
    document.getElementById('recapDate').textContent = optionDepart.dataset.date;
    document.getElementById('recapHeure').textContent = optionDepart.dataset.heure;
    document.getElementById('recapPassager').textContent = nom + (prenom ? ' ' + prenom : '');
    document.getElementById('recapSieges').textContent = siegesSelectionnes.map(n => 'N°' + n).join(', ');
    document.getElementById('recapNbSieges').textContent = siegesSelectionnes.length;

    let tbody = '';
    let total = 0;
    siegesSelectionnes.forEach(n => {
        tbody += '<tr><td>Siège N°' + n + '</td><td class="text-end">' +
            tarifUnitaire.toLocaleString('fr-FR') + ' Ar</td></tr>';
        total += tarifUnitaire;
    });
    document.getElementById('recapTableBody').innerHTML = tbody;
    document.getElementById('recapTotal').textContent = total.toLocaleString('fr-FR');
    document.getElementById('montantAffiche').value = total.toFixed(2);
}

document.getElementById('formAjout').addEventListener('submit', function(e) {
    if (siegesSelectionnes.length === 0) {
        e.preventDefault();
        alert('Veuillez sélectionner au moins un siège.');
        return;
    }
    document.getElementById('siegesInput').value = siegesSelectionnes.join(',');
    document.getElementById('montantInput').value = document.getElementById('montantAffiche').value;
});
