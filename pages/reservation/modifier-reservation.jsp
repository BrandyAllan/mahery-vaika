<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, backoffice.Reservation, backoffice.Utilisateur" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    boolean isAdmin = user.voirsiadmin().equals("Admin");

    String idParam = request.getParameter("id");
    int id;
    try {
        id = Integer.parseInt(idParam);
    } catch (Exception e) {
        response.sendRedirect("model.jsp?page=reservation/liste-reservation&error=invalid");
        return;
    }
    Reservation r = Reservation.getById(id);
    if (r == null) {
        response.sendRedirect("model.jsp?page=reservation/liste-reservation&error=notfound");
        return;
    }

    if (!isAdmin && r.getId_caissier() != user.getId_utilisateur()) {
        response.sendRedirect("model.jsp?page=reservation/liste-reservation&error=droits");
        return;
    }

    if (!r.getStatut().equals("CONFIRMEE")) {
        response.sendRedirect("model.jsp?page=reservation/details-reservation&id=" + id + "&error=statut");
        return;
    }

    Vector<Reservation> departs = Reservation.getAllDeparts();
    String telSansPrefix = "";
    if (r.getTelephone_passager() != null && r.getTelephone_passager().startsWith("+261")) {
        telSansPrefix = r.getTelephone_passager().substring(4);
    } else if (r.getTelephone_passager() != null) {
        telSansPrefix = r.getTelephone_passager();
    }

    int siegeActuel = r.getNumero_siege();
    int reservationId = r.getId_reservation();
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
        position: relative;
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
    <div>
        <a href="?page=reservation/details-reservation&id=<%= reservationId %>" class="btn btn-sm btn-light text-muted border-0 shadow-sm mb-2 hover-shadow">
            <i class="bi bi-arrow-left"></i> Retour aux détails
        </a>
        <h2 class="fw-bold mb-0" style="color: #2c3e50;">
            <i class="bi bi-pencil-square text-warning me-2"></i> Modifier la réservation <%= r.getNumero_reservation() %>
        </h2>
    </div>
</div>

<div class="row justify-content-center">
    <div class="col-md-10">
        <form action="../traitement/reservation/modifier-reservation.jsp" method="post" id="formModif" novalidate>
            <input type="hidden" name="id" value="<%= reservationId %>">

            <!-- Selection du depart -->
            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-body p-5">
                    <h5 class="card-title text-primary fw-bold mb-4"><i class="bi bi-bus-front-fill me-2"></i>Modifier le départ</h5>
            
            <div class="mb-4">
                <label for="idDepart" class="form-label fw-semibold text-secondary">Départ <span class="text-danger">*</span></label>
                <select name="idDepart" id="idDepart" class="form-select form-select-lg bg-light border-0" required>
                    <option value="">-- Choisir un départ --</option>
                    <% for (Reservation d : departs) { %>
                        <option value="<%= d.getId_depart() %>" 
                                data-ville-depart="<%= d.getVille_depart() %>"
                                data-ville-arrivee="<%= d.getVille_arrivee() %>"
                                data-date="<%= d.getDate_depart() %>"
                                data-heure="<%= d.getHeure_depart() %>"
                                <%= d.getId_depart() == r.getId_depart() ? "selected" : "" %>>
                            <%= d.getVille_depart() %> → <%= d.getVille_arrivee() %> | <%= d.getDate_depart() %> à <%= d.getHeure_depart() %>
                        </option>
                    <% } %>
                </select>
            </div>
            <div id="infoDepart" class="alert alert-info border-0 rounded-4">
                <strong>Trajet :</strong> <span id="infoTrajet"></span><br>
                <strong>Date :</strong> <span id="infoDate"></span> à <span id="infoHeure"></span>
            </div>
        </div>
    </div>

            <!-- Informations passager -->
            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-body p-5">
                    <h5 class="card-title text-primary fw-bold mb-4"><i class="bi bi-person-fill me-2"></i>Informations passager</h5>
            
            <div class="row g-4">
                <div class="col-md-6">
                    <label class="form-label fw-semibold text-secondary">Nom <span class="text-danger">*</span></label>
                    <input type="text" name="nomPassager" class="form-control form-control-lg bg-light border-0" value="<%= r.getNom_passager() %>" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold text-secondary">Prénom</label>
                    <input type="text" name="prenomPassager" class="form-control form-control-lg bg-light border-0" value="<%= r.getPrenom_passager() != null ? r.getPrenom_passager() : "" %>">
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold text-secondary">Téléphone (+261)</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-0 text-secondary">+261</span>
                        <input type="text" name="telephonePassager" class="form-control form-control-lg bg-light border-0" value="<%= telSansPrefix %>" pattern="[0-9]{9}" maxlength="9">
                    </div>
                </div>
            </div>
        </div>
    </div>

            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-body p-5">
                    <h5 class="card-title text-primary fw-bold mb-4"><i class="bi bi-grid-3x3-gap-fill me-2"></i>Modifier le siège</h5>
            
            <input type="hidden" name="numeroSiege" id="numeroSiege" value="<%= siegeActuel %>">
            <div id="siegesContainer" class="text-center p-4 bg-light rounded-4 mb-4">
                <p class="text-muted">Chargement des sièges...</p>
            </div>
        </div>
    </div>

            <div class="d-flex justify-content-between mt-4">
                <a href="?page=reservation/details-reservation&id=<%= reservationId %>" class="btn btn-light btn-lg px-4 text-secondary shadow-sm hover-shadow">
                    Annuler
                </a>
                <button type="submit" class="btn btn-warning btn-lg px-4 shadow-sm hover-shadow" id="btnSubmit">
                    <i class="bi bi-check-lg me-2"></i> Mettre à jour
                </button>
            </div>
        </form>
    </div>
</div>

<script>
var siegeActuel = parseInt(document.getElementById('numeroSiege').value);
var siegeSelectionne = siegeActuel;

function initialiserInfosDepart() {
    var select = document.getElementById('idDepart');
    var option = select.options[select.selectedIndex];
    if (option && option.dataset.villeDepart) {
        document.getElementById('infoTrajet').textContent = option.dataset.villeDepart + ' → ' + option.dataset.villeArrivee;
        document.getElementById('infoDate').textContent = option.dataset.date;
        document.getElementById('infoHeure').textContent = option.dataset.heure;
    }
}

document.getElementById('idDepart').addEventListener('change', function() {
    var departId = this.value;
    if (!departId) {
        document.getElementById('siegesContainer').innerHTML = '<p class="text-muted">Veuillez selectionner un depart.</p>';
        return;
    }
    chargerSieges(departId);
});

function chargerSieges(departId) {
    fetch('../traitement/reservation/ajouter-reservation.jsp?action=sieges&idDepart=' + departId)
        .then(function(response) { return response.json(); })
        .then(function(data) {
            var capaciteMax = data.capacite;
            var siegesReserves = data.siegesReserves;
            
            if (capaciteMax <= 0) {
                document.getElementById('siegesContainer').innerHTML = '<p class="text-danger">Capacite du vehicule inconnue.</p>';
                return;
            }
            
            // Calculer le nombre de rangées (4 sièges par rang = 2 gauche + 2 droite)
            var nbSiegesParRang = 4;
            var nbRangees = Math.ceil(capaciteMax / nbSiegesParRang);
            
            var html = '<div class="bus-layout">';
            html += '<div class="bus-front">Minibus</div>';
            
            for (var r = 0; r < nbRangees; r++) {
                html += '<div class="bus-row">';
                // 2 sièges à gauche
                for (var c = 0; c < 2; c++) {
                    var siegeNum = r * nbSiegesParRang + c + 1;
                    if (siegeNum <= capaciteMax) {
                        var estReserve = siegesReserves.indexOf(siegeNum) !== -1;
                        var estActuel = (siegeNum === siegeActuel);
                        var classe;
                        if (estActuel) {
                            classe = 'siege-selectionne';
                        } else if (estReserve) {
                            classe = 'siege-reserve';
                        } else {
                            classe = 'siege-disponible';
                        }
                        html += '<button type="button" class="btn ' + classe + ' siege-btn" ' +
                                'data-siege="' + siegeNum + '" ' + (estReserve && !estActuel ? 'disabled' : '') +
                                ' onclick="selectionnerSiege(' + siegeNum + ', this)">' + siegeNum + '</button>';
                    }
                }
                // Corridor
                html += '<div class="bus-aisle"></div>';
                // 2 sièges à droite
                for (var c = 2; c < 4; c++) {
                    var siegeNum = r * nbSiegesParRang + c + 1;
                    if (siegeNum <= capaciteMax) {
                        var estReserve = siegesReserves.indexOf(siegeNum) !== -1;
                        var estActuel = (siegeNum === siegeActuel);
                        var classe;
                        if (estActuel) {
                            classe = 'siege-selectionne';
                        } else if (estReserve) {
                            classe = 'siege-reserve';
                        } else {
                            classe = 'siege-disponible';
                        }
                        html += '<button type="button" class="btn ' + classe + ' siege-btn" ' +
                                'data-siege="' + siegeNum + '" ' + (estReserve && !estActuel ? 'disabled' : '') +
                                ' onclick="selectionnerSiege(' + siegeNum + ', this)">' + siegeNum + '</button>';
                    }
                }
                html += '</div>';
            }
            
            html += '</div>';
            document.getElementById('siegesContainer').innerHTML = html;
        })
        .catch(function(err) {
            console.error('Erreur:', err);
            document.getElementById('siegesContainer').innerHTML = '<p class="text-danger">Erreur lors du chargement des sieges.</p>';
        });
}

function selectionnerSiege(numero, btn) {
    var boutons = document.querySelectorAll('.siege-selectionne');
    for (var i = 0; i < boutons.length; i++) {
        boutons[i].classList.remove('siege-selectionne');
        boutons[i].classList.add('siege-disponible');
    }

    btn.classList.remove('siege-disponible');
    btn.classList.add('siege-selectionne');
    siegeSelectionne = numero;
    document.getElementById('numeroSiege').value = numero;
}

// Initialiser au chargement
initialiserInfosDepart();
chargerSieges(document.getElementById('idDepart').value);
</script>
