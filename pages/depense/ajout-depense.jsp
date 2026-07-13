<%@ page import="backoffice.Utilisateur, backoffice.Depense, java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) {
        response.sendRedirect("../../index.jsp");
        return;
    }
    String role = user.voirsiadmin();
    if (!role.equals("Admin") && !role.equals("Superviseur")) {
        response.sendRedirect("?page=depense/depense");
        return;
    }

    String erreur = request.getParameter("erreur");

    Vector<Object[]> vehicules = Depense.getVehiculesActifs();
    Vector<Object[]> utilisateurs = Depense.getUtilisateursActifs();
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <a href="?page=depense/depense" class="btn btn-sm btn-light text-muted border-0 shadow-sm mb-2 hover-shadow">
            <i class="bi bi-arrow-left"></i> Retour à la liste
        </a>
        <h2 class="fw-bold mb-0" style="color: #2c3e50;">
            <i class="bi bi-plus-circle text-primary me-2"></i> Créer une nouvelle dépense
        </h2>
    </div>
</div>

<div class="row justify-content-center">
    <div class="col-md-8">
        <% if ("montant".equals(erreur)) { %>
            <div class="alert alert-danger border-0 shadow-sm rounded-4 d-flex align-items-center mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i>Montant invalide.
            </div>
        <% } else if ("negatif".equals(erreur)) { %>
            <div class="alert alert-danger border-0 shadow-sm rounded-4 d-flex align-items-center mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i>Le montant ne peut pas être négatif.
            </div>
        <% } %>

        <form action="../traitement/depense/ajouter-depense.jsp" method="post" id="formDepense">
            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-body p-5">
                    <h5 class="card-title text-primary fw-bold mb-4"><i class="bi bi-receipt-cutoff me-2"></i>Informations de la dépense</h5>

                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Type de dépense <span class="text-danger">*</span></label>
                            <input type="text" name="type_depense" class="form-control form-control-lg bg-light border-0" required placeholder="Ex: Carburant, Réparation...">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Date <span class="text-danger">*</span></label>
                            <input type="date" name="date_depense" class="form-control form-control-lg bg-light border-0" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold text-secondary">Description</label>
                            <input type="text" name="description" class="form-control form-control-lg bg-light border-0" placeholder="Détails supplémentaires...">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Montant <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <input type="number" step="10" min="0" name="montant" class="form-control form-control-lg bg-light border-0" required placeholder="0">
                                <span class="input-group-text bg-light border-0 text-secondary">Ar</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-body p-5">
                    <h5 class="card-title text-primary fw-bold mb-4"><i class="bi bi-link-45deg me-2"></i>Associations (optionnel)</h5>

                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Véhicule</label>
                            <select name="id_vehicule" class="form-select form-select-lg bg-light border-0">
                                <option value="">-- Aucun --</option>
                                <% for (Object[] v : vehicules) { %>
                                    <option value="<%= v[0] %>">
                                        <%= v[1] %> - <%= v[2] %> <%= v[3] %>
                                    </option>
                                <% } %>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Utilisateur</label>
                            <select name="id_utilisateur" class="form-select form-select-lg bg-light border-0">
                                <option value="">-- Aucun --</option>
                                <% for (Object[] u : utilisateurs) { %>
                                    <option value="<%= u[0] %>">
                                        <%= u[1] %> <%= u[2] %>
                                    </option>
                                <% } %>
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            <div class="d-flex justify-content-between mt-4">
                <a href="?page=depense/depense" class="btn btn-light btn-lg px-4 text-secondary shadow-sm hover-shadow">Annuler</a>
                <button type="submit" class="btn btn-primary btn-lg px-4 shadow-sm hover-shadow">
                    <i class="bi bi-save me-2"></i>Enregistrer la dépense
                </button>
            </div>
        </form>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('formDepense');
    const montantInput = document.querySelector('input[name="montant"]');

    form.addEventListener('submit', function(e) {
        const valeur = parseFloat(montantInput.value);

        if (montantInput.value.trim() === '' || isNaN(valeur)) {
            e.preventDefault();
            alert('Veuillez saisir un montant valide.');
            montantInput.focus();
            return;
        }

        if (valeur < 0) {
            e.preventDefault();
            alert('Le montant ne peut pas être négatif.');
            montantInput.focus();
        }
    });
});
</script>
