<%@ page import="java.util.*, backoffice.Utilisateur" %>

<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");

    if (user == null || !user.voirsiadmin().equals("Admin")) {
        response.sendRedirect("gestion-utilisateur.jsp");
        return;
    }

    Vector<Utilisateur> roles = Utilisateur.getAllRoles();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ajouter un utilisateur</title>
    <link rel="stylesheet" href="../../assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="../../assets/icons/bootstrap-icons.min.css">
    <style>
        .error-message { color: red; font-size: 0.9em; display: none; }
        .is-invalid { border-color: red; }
        .is-valid { border-color: green; }
    </style>
</head>
<body>
<div class="container mt-4">
    <h2>Ajouter un utilisateur</h2>

    <div class="mb-3">
        <a href="?page=utilisateur/liste-utilisateur" class="btn btn-secondary">
            <i class="bi bi-arrow-left"></i> Retour
        </a>
    </div>

    <form action="../../traitement/utilisateur/ajouter-utilisateur.jsp" method="post" class="row g-3" id="formAjout" novalidate>
        <div class="col-12 col-md-6">
            <label>Nom *</label>
            <input type="text" name="nom" class="form-control" required>
            <span class="error-message">Ce champ est obligatoire.</span>
        </div>

        <div class="col-12 col-md-6">
            <label>Prenom</label>
            <input type="text" name="prenom" class="form-control">
        </div>

        <div class="col-12 col-md-6">
            <label>Telephone (+261)</label>
            <div class="input-group">
                <span class="input-group-text">+261</span>
                <input type="text" name="telephone" class="form-control" placeholder="32 1234567" pattern="[0-9]{9}" maxlength="9" required>
            </div>
            <span class="error-message">9 chiffres : indicatif (32/33/34/37/38) + 7 chiffres.</span>
        </div>

        <div class="col-12 col-md-6">
            <label>Email *</label>
            <input type="email" name="email" class="form-control" required>
            <span class="error-message">Email invalide ou deja utilise.</span>
        </div>

        <div class="col-12 col-md-6">
            <label>Identifiant *</label>
            <input type="text" name="identifiant" class="form-control" required>
            <span class="error-message">Ce champ est obligatoire.</span>
        </div>

        <div class="col-12 col-md-6">
            <label>Mot de passe * (8 caracteres min)</label>
            <input type="password" name="mot_de_passe" class="form-control" required minlength="8">
            <span class="error-message">Au moins 8 caracteres.</span>
        </div>

        <div class="col-12 col-md-6">
            <label>Role *</label>
            <select name="role" class="form-select" required>
                <%
                    for (Utilisateur r : roles) {
                %>
                    <option value="<%= r.getId_role() %>">
                        <%= r.getNom_role() %>
                    </option>
                <% } %>
            </select>
        </div>

        <div class="col-12 col-md-6">
            <label>Date d'embauche *</label>
            <input type="date" name="date_embauche" class="form-control" required>
            <span class="error-message">Ce champ est obligatoire.</span>
        </div>

        <div class="col-12">
            <button type="submit" class="btn btn-primary">Ajouter</button>
            <a href="gestion-utilisateur.jsp" class="btn btn-secondary">Annuler</a>
        </div>
    </form>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('formAjout');
    const inputs = form.querySelectorAll('input, select');

    inputs.forEach(input => {
        input.addEventListener('blur', function() {
            validateField(this);
        });
        input.addEventListener('input', function() {
            if (this.classList.contains('is-invalid')) {
                validateField(this);
            }
        });
    });

    function validateField(field) {
        const errorSpan = field.parentElement.querySelector('.error-message');
        let valid = true;
        let message = '';

        if (field.hasAttribute('required') && !field.value.trim()) {
            valid = false;
            message = 'Ce champ est obligatoire.';
        } else if (field.type === 'email' && field.value.trim()) {
            const email = field.value.trim();
            const atIndex = email.indexOf('@');
            if (atIndex === -1) {
                valid = false;
                message = 'Email doit contenir @.';
            } else if (!email.includes('.', atIndex)) {
                valid = false;
                message = 'Email doit contenir un point apres le @.';
            }
        } else if (field.name === 'telephone' && field.value.trim()) {
            const tel = field.value.trim();
            if (!tel.match(/^[0-9]{9}$/)) {
                valid = false;
                message = '9 chiffres attendus.';
            } else {
                const indicatif = tel.substring(0, 2);
                if (!['32', '33', '34', '37', '38'].includes(indicatif)) {
                    valid = false;
                    message = 'Indicatif invalide (32,33,34,37,38)';
                }
            }
        } else if (field.type === 'password' && field.value.trim()) {
            if (field.value.length < 8) {
                valid = false;
                message = 'Au moins 8 caracteres.';
            }
        }

        if (!valid) {
            field.classList.add('is-invalid');
            field.classList.remove('is-valid');
            errorSpan.textContent = message;
            errorSpan.style.display = 'block';
        } else {
            field.classList.remove('is-invalid');
            field.classList.add('is-valid');
            errorSpan.style.display = 'none';
        }

        return valid;
    }

    form.addEventListener('submit', function(e) {
        let allValid = true;

        inputs.forEach(input => {
            if (!validateField(input)) {
                allValid = false;
            }
        });

        if (!allValid) {
            e.preventDefault();
            alert('Veuillez corriger les erreurs dans le formulaire.');
        }
    });
});
</script>

<script src="../../assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>