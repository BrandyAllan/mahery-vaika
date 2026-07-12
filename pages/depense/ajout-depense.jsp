<%@ page import="backoffice.Utilisateur, backoffice.Depense, java.util.*" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) {
        response.sendRedirect("../../index.jsp");
        return;
    }
    String role = user.voirsiadmin();
    if (!role.equals("Admin") && !role.equals("Superviseur")) {
        response.sendRedirect("depense.jsp");
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
            <i class="bi bi-plus-circle text-primary me-2"></i> Ajouter une dépense
        </h2>
    </div>
</div>

<% if ("montant".equals(erreur)) { %>
    <div class="alert alert-danger border-0 shadow-sm"><i class="bi bi-exclamation-triangle-fill me-2"></i>Montant invalide.</div>
<% } else if ("negatif".equals(erreur)) { %>
    <div class="alert alert-danger border-0 shadow-sm"><i class="bi bi-exclamation-triangle-fill me-2"></i>Le montant ne peut pas être négatif.</div>
<% } %>

<div class="card border-0 shadow-sm rounded-4">
    <div class="card-body p-5">
        <form action="../traitement/depense/ajouter-depense.jsp" method="post" class="row g-4" id="formDepense">
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
            
            <div class="col-md-4">
                <label class="form-label fw-semibold text-secondary">Montant <span class="text-danger">*</span></label>
                <div class="input-group">
                    <input type="number" step="10" min="0" name="montant" class="form-control form-control-lg bg-light border-0" required placeholder="0">
                    <span class="input-group-text bg-light border-0 text-secondary">Ar</span>
                </div>
            </div>

            <div class="col-md-4">
                <label class="form-label fw-semibold text-secondary">Véhicule (optionnel)</label>
                <select name="id_vehicule" class="form-select form-select-lg bg-light border-0">
                    <option value="">-- Aucun --</option>
                    <% for (Object[] v : vehicules) { %>
                        <option value="<%= v[0] %>">
                            <%= v[1] %> - <%= v[2] %> <%= v[3] %>
                        </option>
                    <% } %>
                </select>
            </div>

            <div class="col-md-4">
                <label class="form-label fw-semibold text-secondary">Utilisateur (optionnel)</label>
                <select name="id_utilisateur" class="form-select form-select-lg bg-light border-0">
                    <option value="">-- Aucun --</option>
                    <% for (Object[] u : utilisateurs) { %>
                        <option value="<%= u[0] %>">
                            <%= u[1] %> <%= u[2] %>
                        </option>
                    <% } %>
                </select>
            </div>

            <div class="col-12 mt-5 d-flex gap-3">
                <button type="submit" class="btn btn-success btn-lg px-4 shadow-sm hover-shadow">
                    <i class="bi bi-check-lg me-2"></i> Ajouter la dépense
                </button>
                <a href="?page=depense/depense" class="btn btn-light btn-lg px-4 text-secondary shadow-sm hover-shadow">Annuler</a>
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
            return;
        }
    });
});
</script>