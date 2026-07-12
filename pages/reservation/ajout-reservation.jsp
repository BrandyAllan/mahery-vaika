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
    String debug = request.getParameter("debug");
%>

<link rel="stylesheet" href="../assets/css/reservation.css">

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <a href="?page=reservation/liste-reservation" class="btn btn-sm btn-light text-muted border-0 shadow-sm mb-2 hover-shadow">
            <i class="bi bi-arrow-left"></i> Retour à la liste
        </a>
        <h2 class="fw-bold mb-0" style="color: #2c3e50;">
            <i class="bi bi-plus-circle text-primary me-2"></i> Ajouter une réservation
        </h2>
    </div>
</div>

<% if ("params".equals(erreur)) { %>
<div class="alert alert-danger border-0 shadow-sm"><i class="bi bi-exclamation-triangle-fill me-2"></i>Paramètres invalides. Merci de recommencer.</div>
<% } else if ("nom".equals(erreur)) { %>
<div class="alert alert-danger border-0 shadow-sm"><i class="bi bi-exclamation-triangle-fill me-2"></i>Le nom du passager est obligatoire.</div>
<% } else if ("depart".equals(erreur)) { %>
<div class="alert alert-danger border-0 shadow-sm"><i class="bi bi-exclamation-triangle-fill me-2"></i>Le départ sélectionné est introuvable.</div>
<% } else if ("sieges".equals(erreur)) { %>
<div class="alert alert-danger border-0 shadow-sm"><i class="bi bi-exclamation-triangle-fill me-2"></i>Merci de sélectionner au moins un siège.</div>
<% } else if ("siege_pris".equals(erreur)) { %>
<div class="alert alert-danger border-0 shadow-sm"><i class="bi bi-exclamation-triangle-fill me-2"></i>Un ou plusieurs sièges choisis viennent d'être réservés par quelqu'un d'autre. Merci de recommencer la sélection.</div>
<% } else if ("db".equals(erreur)) { %>
<div class="alert alert-danger border-0 shadow-sm"><i class="bi bi-exclamation-triangle-fill me-2"></i>Une erreur est survenue lors de l'enregistrement. Merci de réessayer.
<% if (debug != null && !debug.trim().isEmpty()) { %>
    <br><small class="text-muted">Détail technique : <%= debug %></small>
<% } %>
</div>
<% } %>

<ul class="wizard-steps mb-4">
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
        <div class="card border-0 shadow-sm rounded-4 mb-4">
            <div class="card-body p-5">
                <h5 class="card-title text-primary fw-bold mb-4"><i class="bi bi-bus-front-fill me-2"></i>Sélectionner un départ</h5>
                
                <div class="mb-4">
                    <label for="idDepart" class="form-label fw-semibold text-secondary">Départ <span class="text-danger">*</span></label>
                    <select name="idDepart" id="idDepart" class="form-select form-select-lg bg-light border-0">
                        <option value="">-- Choisir un départ --</option>
                        <% for (Reservation d : departs) { %>
                        <option value="<%= d.getId_depart() %>"
                            data-trajet="<%= d.getId_trajet() %>"
                            data-date="<%= d.getDate_depart() %>"
                            data-heure="<%= d.getHeure_depart() %>"
                            data-ville-depart="<%= d.getVille_depart() %>"
                            data-ville-arrivee="<%= d.getVille_arrivee() %>"
                            data-tarif="<%= d.getTarif_base() %>">
                            <%= d.getVille_depart() %> → <%= d.getVille_arrivee() %> | <%= d.getDate_depart() %> à <%= d.getHeure_depart() %>
                        </option>
                        <% } %>
                    </select>
                </div>

                <div id="infoDepart" class="alert alert-info border-0 rounded-4 d-none p-4">
                    <div class="row g-2">
                        <div class="col-md-4"><strong>Trajet :</strong> <br><span id="infoTrajet" class="fs-5">—</span></div>
                        <div class="col-md-4"><strong>Date :</strong> <br><span id="infoDate" class="fs-5">—</span> à <span id="infoHeure" class="fs-5">—</span></div>
                        <div class="col-md-4"><strong>Tarif :</strong> <br><span id="infoTarif" class="fs-5 text-success fw-bold">—</span> Ar / place</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="text-end">
            <button type="button" class="btn btn-primary btn-lg px-4 shadow-sm hover-shadow btn-suivant" data-next="2">
                Suivant <i class="bi bi-arrow-right ms-2"></i>
            </button>
        </div>
    </div>

    <!-- ETAPE 2 : PASSAGER -->
    <div class="wizard-step-pane" data-pane="2">
        <div class="card border-0 shadow-sm rounded-4 mb-4">
            <div class="card-body p-5">
                <h5 class="card-title text-primary fw-bold mb-4"><i class="bi bi-person-fill me-2"></i>Informations passager</h5>
                
                <div class="row g-4">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold text-secondary">Nom <span class="text-danger">*</span></label>
                        <input type="text" name="nomPassager" id="nomPassager" class="form-control form-control-lg bg-light border-0">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold text-secondary">Prénom</label>
                        <input type="text" name="prenomPassager" class="form-control form-control-lg bg-light border-0">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold text-secondary">Téléphone (+261)</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-0 text-secondary">+261</span>
                            <input type="text" name="telephonePassager" class="form-control form-control-lg bg-light border-0" placeholder="321234567" pattern="[0-9]{9}" maxlength="9">
                        </div>
                    </div>
                </div>
                <div class="form-text text-muted mt-3">
                    <i class="bi bi-info-circle me-1"></i> Ces informations seront utilisées pour toutes les places réservées dans ce groupe.
                </div>
            </div>
        </div>
        <div class="d-flex justify-content-between">
            <button type="button" class="btn btn-light btn-lg px-4 text-secondary shadow-sm hover-shadow btn-precedent" data-prev="1">
                <i class="bi bi-arrow-left me-2"></i> Précédent
            </button>
            <button type="button" class="btn btn-primary btn-lg px-4 shadow-sm hover-shadow btn-suivant" data-next="3">
                Suivant <i class="bi bi-arrow-right ms-2"></i>
            </button>
        </div>
    </div>

    <!-- ETAPE 3 : SIEGES -->
    <div class="wizard-step-pane" data-pane="3">
        <div class="card border-0 shadow-sm rounded-4 mb-4">
            <div class="card-body p-5">
                <h5 class="card-title text-primary fw-bold mb-4"><i class="bi bi-grid-3x3-gap-fill me-2"></i>Sélectionner un ou plusieurs sièges</h5>
                
                <div id="siegesContainer" class="text-center p-4 bg-light rounded-4 mb-4">
                    <p class="text-muted mb-0">Chargement des sièges...</p>
                </div>
                <div class="alert alert-light border text-center">
                    <strong class="text-secondary">Places choisies :</strong> <span id="siegesChoisis" class="fs-5 text-primary fw-bold ms-2">aucune</span>
                </div>
            </div>
        </div>
        <div class="d-flex justify-content-between">
            <button type="button" class="btn btn-light btn-lg px-4 text-secondary shadow-sm hover-shadow btn-precedent" data-prev="2">
                <i class="bi bi-arrow-left me-2"></i> Précédent
            </button>
            <button type="button" class="btn btn-primary btn-lg px-4 shadow-sm hover-shadow btn-suivant" data-next="4">
                Suivant <i class="bi bi-arrow-right ms-2"></i>
            </button>
        </div>
    </div>

    <!-- ETAPE 4 : PAIEMENT -->
    <div class="wizard-step-pane" data-pane="4">
        <div class="card border-0 shadow-sm rounded-4 mb-4">
            <div class="card-body p-5">
                <h5 class="card-title text-primary fw-bold mb-4"><i class="bi bi-receipt me-2"></i>Récapitulatif</h5>
                <div class="row g-4 mb-4">
                    <div class="col-md-6"><span class="text-muted d-block mb-1">Trajet</span> <span id="recapTrajet" class="fw-bold text-dark">—</span></div>
                    <div class="col-md-6"><span class="text-muted d-block mb-1">Date</span> <span id="recapDate" class="fw-bold text-dark">—</span> à <span id="recapHeure" class="fw-bold text-dark">—</span></div>
                    <div class="col-md-6"><span class="text-muted d-block mb-1">Passager</span> <span id="recapPassager" class="fw-bold text-dark">—</span></div>
                    <div class="col-md-6"><span class="text-muted d-block mb-1">Sièges</span> <span id="recapSieges" class="fw-bold text-primary">—</span></div>
                </div>
                <div class="table-responsive bg-light rounded-4 p-3">
                    <table class="table table-borderless mb-0">
                        <thead><tr class="text-secondary border-bottom"><th class="pb-2">Siège</th><th class="text-end pb-2">Prix</th></tr></thead>
                        <tbody id="recapTableBody"></tbody>
                        <tfoot>
                            <tr class="border-top">
                                <td class="pt-3 fw-bold text-dark">Total (<span id="recapNbSieges" class="text-primary">0</span> place(s))</td>
                                <td class="pt-3 text-end fw-bold text-success fs-5"><span id="recapTotal">0</span> Ar</td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>

        <div class="card border-0 shadow-sm rounded-4 mb-4">
            <div class="card-body p-5">
                <h5 class="card-title text-primary fw-bold mb-4"><i class="bi bi-credit-card-fill me-2"></i>Paiement</h5>
                <div class="row g-4">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold text-secondary">Mode de paiement <span class="text-danger">*</span></label>
                        <select name="modePaiement" id="modePaiement" class="form-select form-select-lg bg-light border-0">
                            <option value="Especes">Espèces</option>
                            <option value="Mobile Money">Mobile Money</option>
                            <option value="Carte bancaire">Carte bancaire</option>
                            <option value="Virement">Virement</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold text-secondary">Montant à payer (Ar) <span class="text-danger">*</span></label>
                        <input type="number" step="0.01" min="0" class="form-control form-control-lg bg-light border-0" id="montantAffiche">
                        <div class="form-text text-muted mt-2"><i class="bi bi-info-circle me-1"></i>Pré-rempli selon le tarif, modifiable si besoin.</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="d-flex justify-content-between mt-5">
            <button type="button" class="btn btn-light btn-lg px-4 text-secondary shadow-sm hover-shadow btn-precedent" data-prev="3">
                <i class="bi bi-arrow-left me-2"></i> Précédent
            </button>
            <button type="submit" class="btn btn-success btn-lg px-4 shadow-sm hover-shadow" id="btnSubmit">
                <i class="bi bi-check-lg me-2"></i> Confirmer et payer
            </button>
        </div>
    </div>
</form>

<script src="../assets/js/reservation-ajout.js"></script>
