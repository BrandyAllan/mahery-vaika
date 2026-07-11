<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, backoffice.Reservation, backoffice.Utilisateur" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) {
        response.sendRedirect("../index.jsp");
        return;
    }

    Vector<Reservation> departs = Reservation.getAllDeparts();

    String erreur = request.getParameter("erreur");
%>

<link rel="stylesheet" href="../assets/css/reservation.css">

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2 class="fw-bold">Ajouter une réservation</h2>

    <a href="?page=reservation/liste-reservation" class="btn btn-secondary">
        <i class="bi bi-arrow-left"></i> Retour
    </a>
</div>

<% if ("params".equals(erreur)) { %>
    <div class="alert alert-danger">Paramètres invalides. Merci de recommencer.</div>
<% } else if ("nom".equals(erreur)) { %>
    <div class="alert alert-danger">Le nom du passager est obligatoire.</div>
<% } else if ("depart".equals(erreur)) { %>
    <div class="alert alert-danger">Le départ sélectionné est introuvable.</div>
<% } else if ("sieges".equals(erreur)) { %>
    <div class="alert alert-danger">Merci de sélectionner au moins un siège.</div>
<% } else if ("siege_pris".equals(erreur)) { %>
    <div class="alert alert-danger">Un ou plusieurs sièges choisis viennent d'être réservés par quelqu'un d'autre. Merci de recommencer la sélection.</div>
<% } else if ("db".equals(erreur)) { %>
    <div class="alert alert-danger">
        Une erreur est survenue lors de l'enregistrement. Merci de réessayer.
        <% String debug = request.getParameter("debug");
           if (debug != null && !debug.isEmpty()) { %>
            <br><small class="text-muted">Détail technique (à retirer en prod) : <%= debug %></small>
        <% } %>
    </div>
<% } %>

<ul class="wizard-steps">
    <li class="active" data-step="1"><span class="num">1</span><br>Départ</li>
    <li data-step="2"><span class="num">2</span><br>Passager</li>
    <li data-step="3"><span class="num">3</span><br>Sièges</li>
    <li data-step="4"><span class="num">4</span><br>Paiement</li>
</ul>

<form action="../traitement/reservation/ajouter-reservation.jsp" method="post" id="formAjout" novalidate>

    <input type="hidden" name="sieges" id="siegesInput" value="">
    <input type="hidden" name="montant" id="montantInput" value="">

    <!-- ETAPE 1 : DEPART -->
    <div class="wizard-step-pane active" data-pane="1">
        <div class="card mb-3">
            <div class="card-header">
                <i class="bi bi-bus-front"></i> Sélectionner un départ
            </div>

            <div class="card-body">
                <div class="mb-3">
                    <label for="idDepart" class="form-label">Départ *</label>

                    <select name="idDepart" id="idDepart" class="form-select">
                        <option value="">-- Choisir un départ --</option>

                        <% for (Reservation d : departs) { %>
                            <option value="<%= d.getId_depart() %>"
                                    data-trajet="<%= d.getId_trajet() %>"
                                    data-date="<%= d.getDate_depart() %>"
                                    data-heure="<%= d.getHeure_depart() %>"
                                    data-ville-depart="<%= d.getVille_depart() %>"
                                    data-ville-arrivee="<%= d.getVille_arrivee() %>"
                                    data-tarif="<%= d.getTarif_base() %>">
                                <%= d.getVille_depart() %> → <%= d.getVille_arrivee() %> |
                                <%= d.getDate_depart() %> à <%= d.getHeure_depart() %>
                            </option>
                        <% } %>
                    </select>
                </div>

                <div id="infoDepart" class="alert alert-info d-none">
                    <strong>Trajet :</strong> <span id="infoTrajet"></span><br>
                    <strong>Date :</strong> <span id="infoDate"></span> à <span id="infoHeure"></span><br>
                    <strong>Tarif :</strong> <span id="infoTarif"></span> Ar / place
                </div>
            </div>
        </div>

        <div class="text-end">
            <button type="button" class="btn btn-primary btn-suivant" data-next="2">
                Suivant <i class="bi bi-arrow-right"></i>
            </button>
        </div>
    </div>

    <!-- ETAPE 2 : PASSAGER -->
    <div class="wizard-step-pane" data-pane="2">
        <div class="card mb-3">
            <div class="card-header">
                <i class="bi bi-person"></i> Informations passager
            </div>

            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Nom *</label>
                        <input type="text" name="nomPassager" id="nomPassager" class="form-control">
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

        <div class="d-flex justify-content-between">
            <button type="button" class="btn btn-secondary btn-precedent" data-prev="1">
                <i class="bi bi-arrow-left"></i> Précédent
            </button>
            <button type="button" class="btn btn-primary btn-suivant" data-next="3">
                Suivant <i class="bi bi-arrow-right"></i>
            </button>
        </div>
    </div>

    <!-- ETAPE 3 : SIEGES -->
    <div class="wizard-step-pane" data-pane="3">
        <div class="card mb-3">
            <div class="card-header">
                <i class="bi bi-grid"></i> Sélectionner un ou plusieurs sièges
            </div>

            <div class="card-body">
                <div id="siegesContainer" class="text-center">
                    <p class="text-muted">Chargement des sièges...</p>
                </div>


                <div class="mt-3">
                    <strong>Places choisies :</strong>
                    <span id="siegesChoisis" class="ms-2 text-muted">aucune</span>
                </div>
            </div>
        </div>

        <div class="d-flex justify-content-between">
            <button type="button" class="btn btn-secondary btn-precedent" data-prev="2">
                <i class="bi bi-arrow-left"></i> Précédent
            </button>
            <button type="button" class="btn btn-primary btn-suivant" data-next="4">
                Suivant <i class="bi bi-arrow-right"></i>
            </button>
        </div>
    </div>

     <!-- ETAPE 4 : PAIEMENT -->
    <div class="wizard-step-pane" data-pane="4">
        <div class="card mb-3">
            <div class="card-header">
                <i class="bi bi-receipt"></i> Récapitulatif
            </div>
            <div class="card-body">
                <div class="row g-2">
                    <div class="col-md-6"><strong>Trajet :</strong> <span id="recapTrajet">-</span></div>
                    <div class="col-md-6"><strong>Date :</strong> <span id="recapDate">-</span> à <span id="recapHeure">-</span></div>
                    <div class="col-md-6"><strong>Passager :</strong> <span id="recapPassager">-</span></div>
                    <div class="col-md-6"><strong>Sièges :</strong> <span id="recapSieges">-</span></div>
                </div>
                <hr>
                <div class="table-responsive">
                    <table class="table table-sm">
                        <thead><tr><th>Siège</th><th class="text-end">Prix</th></tr></thead>
                        <tbody id="recapTableBody"></tbody>
                        <tfoot>
                            <tr class="fw-bold">
                                <td>Total (<span id="recapNbSieges">0</span> place(s))</td>
                                <td class="text-end"><span id="recapTotal">0</span> Ar</td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>

        <div class="card mb-3">
            <div class="card-header">
                <i class="bi bi-credit-card"></i> Paiement
            </div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Mode de paiement *</label>
                        <select name="modePaiement" id="modePaiement" class="form-select">
                            <option value="Especes">Espèces</option>
                            <option value="Mobile Money">Mobile Money</option>
                            <option value="Carte bancaire">Carte bancaire</option>
                            <option value="Virement">Virement</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Montant à payer (Ar) *</label>
                        <input type="number" step="0.01" min="0" class="form-control" id="montantAffiche">
                    </div>
                </div>
            </div>
        </div>

        <div class="d-flex justify-content-between">
            <button type="button" class="btn btn-secondary btn-precedent" data-prev="3">
                <i class="bi bi-arrow-left"></i> Précédent
            </button>
            <button type="submit" class="btn btn-success" id="btnSubmit">
                <i class="bi bi-check-circle"></i> Confirmer et payer
            </button>
        </div>
    </div>
</form>

<script src="../assets/js/reservation-ajout.js"></script>
<script src="../assets/js/payment-cards.js"></script>
