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
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ajouter une depense</title>
    <link rel="stylesheet" href="../../assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="../../assets/icons/bootstrap-icons.min.css">
</head>
<body>
<div class="container mt-4">
    <h2>Ajouter une depense</h2>
    <a href="depense.jsp" class="btn btn-secondary mb-3"><i class="bi bi-arrow-left"></i> Retour</a>

    <% if ("montant".equals(erreur)) { %>
        <div class="alert alert-danger">Montant invalide.</div>
    <% } else if ("negatif".equals(erreur)) { %>
        <div class="alert alert-danger">Le montant ne peut pas être negatif.</div>
    <% } %>

    <form action="../../traitement/depense/ajouter-depense.jsp" method="post" class="row g-3" id="formDepense">
        <div class="col-12 col-md-6">
            <label>Type *</label>
            <input type="text" name="type_depense" class="form-control" required>
        </div>
        <div class="col-12 col-md-6">
            <label>Description</label>
            <input type="text" name="description" class="form-control">
        </div>
        <div class="col-12 col-md-6">
            <label>Montant *</label>
            <input type="number" step="10" min="0" name="montant" class="form-control" required>
        </div>
        <div class="col-12 col-md-6">
            <label>Date *</label>
            <input type="date" name="date_depense" class="form-control" required>
        </div>

        <div class="col-12 col-md-6">
            <label>Vehicule (optionnel)</label>
            <select name="id_vehicule" class="form-select">
                <option value="">Aucun</option>
                <% for (Object[] v : vehicules) { %>
                    <option value="<%= v[0] %>">
                        <%= v[1] %> - <%= v[2] %> <%= v[3] %>
                    </option>
                <% } %>
            </select>
        </div>

        <div class="col-12 col-md-6">
            <label>Utilisateur (optionnel)</label>
            <select name="id_utilisateur" class="form-select">
                <option value="">Aucun</option>
                <% for (Object[] u : utilisateurs) { %>
                    <option value="<%= u[0] %>">
                        <%= u[1] %> <%= u[2] %>
                    </option>
                <% } %>
            </select>
        </div>

        <div class="col-12">
            <button type="submit" class="btn btn-primary">Ajouter</button>
            <a href="depense.jsp" class="btn btn-secondary">Annuler</a>
        </div>
    </form>
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
            alert('Le montant ne peut pas être negatif.');
            montantInput.focus();
            return;
        }
    });
});
</script>

<script src="../../assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>