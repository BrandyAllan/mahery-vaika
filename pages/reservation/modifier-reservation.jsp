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
        response.sendRedirect("liste-reservation.jsp?error=invalid");
        return;
    }
    Reservation r = Reservation.getById(id);
    if (r == null) {
        response.sendRedirect("liste-reservation.jsp?error=notfound");
        return;
    }

    // Verifier les droits
    if (!isAdmin && r.getId_caissier() != user.getId_utilisateur()) {
        response.sendRedirect("liste-reservation.jsp?error=droits");
        return;
    }

    // Verifier que la reservation est confirmee
    if (!r.getStatut().equals("CONFIRMEE")) {
        response.sendRedirect("details-reservation.jsp?id=" + id + "&error=statut");
        return;
    }

    Vector<Reservation> departs = Reservation.getAllDeparts();
    String telSansPrefix = "";
    if (r.getTelephone_passager() != null && r.getTelephone_passager().startsWith("+261")) {
        telSansPrefix = r.getTelephone_passager().substring(4);
    }

    int siegeActuel = r.getNumero_siege();
    int reservationId = r.getId_reservation();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier la reservation</title>
    <link rel="stylesheet" href="../assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/bootstrap/icons/bootstrap-icons.min.css">
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
</head>
<body>
<div class="container mt-4">
    <h2>Modifier la reservation <%= r.getNumero_reservation() %></h2>
    <a href="details-reservation.jsp?id=<%= reservationId %>" class="btn btn-secondary mb-3"><i class="bi bi-arrow-left"></i> Retour</a>

    <form action="../traitement/modifier-reservation.jsp" method="post" id="formModif" novalidate>
        <input type="hidden" name="id" value="<%= reservationId %>">

        <!-- Selection du depart -->
        <div class="card mb-3">
            <div class="card-header"><i class="bi bi-bus-front"></i> Modifier le depart</div>
            <div class="card-body">
                <div class="mb-3">
                    <label for="idDepart" class="form-label">Depart *</label>
                    <select name="idDepart" id="idDepart" class="form-select" required>
                        <option value="">-- Choisir un depart --</option>
                        <% for (Reservation d : departs) { %>
                            <option value="<%= d.getId_depart() %>" 
                                    data-ville-depart="<%= d.getVille_depart() %>"
                                    data-ville-arrivee="<%= d.getVille_arrivee() %>"
                                    data-date="<%= d.getDate_depart() %>"
                                    data-heure="<%= d.getHeure_depart() %>"
                                    <%= d.getId_depart() == r.getId_depart() ? "selected" : "" %>>
                                <%= d.getVille_depart() %> → <%= d.getVille_arrivee() %> | <%= d.getDate_depart() %> a <%= d.getHeure_depart() %>
                            </option>
                        <% } %>
                    </select>
                </div>
                <div id="infoDepart" class="alert alert-info">
                    <strong>Trajet :</strong> <span id="infoTrajet"></span><br>
                    <strong>Date :</strong> <span id="infoDate"></span> a <span id="infoHeure"></span>
                </div>
            </div>
        </div>

        <!-- Informations passager -->
        <div class="card mb-3">
            <div class="card-header"><i class="bi bi-person"></i> Informations passager</div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label>Nom *</label>
                        <input type="text" name="nomPassager" class="form-control" value="<%= r.getNom_passager() %>" required>
                    </div>
                    <div class="col-md-6">
                        <label>Prenom</label>
                        <input type="text" name="prenomPassager" class="form-control" value="<%= r.getPrenom_passager() != null ? r.getPrenom_passager() : "" %>">
                    </div>
                    <div class="col-md-6">
                        <label>Telephone (+261)</label>
                        <div class="input-group">
                            <span class="input-group-text">+261</span>
                            <input type="text" name="telephonePassager" class="form-control" value="<%= telSansPrefix %>" pattern="[0-9]{9}" maxlength="9">
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Selection du siege -->
        <div class="card mb-3">
            <div class="card-header"><i class="bi bi-grid"></i> Modifier le siege</div>
            <div class="card-body">
                <input type="hidden" name="numeroSiege" id="numeroSiege" value="<%= siegeActuel %>">
                <div id="siegesContainer" class="text-center">
                    <p class="text-muted">Chargement des sieges...</p>
                </div>
                <div class="mt-3">
                    <span class="badge bg-success">Disponible</span>
                    <span class="badge bg-danger ms-2">Reserve</span>
                    <span class="badge bg-primary ms-2">Selectionne</span>
                </div>
            </div>
        </div>

        <button type="submit" class="btn btn-warning" id="btnSubmit">
            <i class="bi bi-check-circle"></i> Enregistrer les modifications
        </button>
        <a href="details-reservation.jsp?id=<%= reservationId %>" class="btn btn-secondary">Annuler</a>
    </form>
</div>

<script src="../assets/bootstrap/js/bootstrap.bundle.min.js"></script>
<script>
// Variables initialisees via les attributs data de la page
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
    fetch('../traitement/ajouter-reservation.jsp?action=sieges&idDepart=' + departId)
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
        if (parseInt(boutons[i].dataset.siege) !== siegeActuel) {
            boutons[i].classList.remove('siege-selectionne');
            boutons[i].classList.add('siege-disponible');
        }
    }
    
    if (numero !== siegeActuel) {
        btn.classList.remove('siege-disponible');
        btn.classList.add('siege-selectionne');
    }
    siegeSelectionne = numero;
    document.getElementById('numeroSiege').value = numero;
}

// Initialiser au chargement
initialiserInfosDepart();
chargerSieges(document.getElementById('idDepart').value);
</script>
</body>
</html>
