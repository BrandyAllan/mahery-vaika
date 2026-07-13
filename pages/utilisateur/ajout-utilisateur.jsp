<%@ page import="java.util.*, backoffice.Utilisateur" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");

    if (user == null || !user.voirsiadmin().equals("Admin")) {
        response.sendRedirect("model.jsp?page=utilisateur/liste-utilisateur");
        return;
    }

    Vector<Utilisateur> roles = Utilisateur.getAllRoles();
%>

<style>
    .error-message { color: #dc3545; font-size: 0.875em; display: none; margin-top: 0.25rem; }
    .is-invalid { border-color: #dc3545 !important; }
    .is-valid { border-color: #198754 !important; }
</style>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <a href="?page=utilisateur/gestion-utilisateur" class="btn btn-sm btn-light text-muted border-0 shadow-sm mb-2 hover-shadow">
            <i class="bi bi-arrow-left"></i> Retour 
        </a>
        <h2 class="fw-bold mb-0" style="color: #2c3e50;">
            <i class="bi bi-person-plus-fill text-primary me-2"></i> Ajouter un utilisateur
        </h2>
    </div>
</div>

<div class="row justify-content-center">
    <div class="col-md-10">
        <form action="../traitement/utilisateur/ajouter-utilisateur.jsp" method="post" id="formAjout" novalidate>
            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-body p-5">
                    <h5 class="card-title text-primary fw-bold mb-4"><i class="bi bi-person-lines-fill me-2"></i>Informations personnelles</h5>
                    
                    <div class="row g-4 mb-4">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Nom <span class="text-danger">*</span></label>
                            <input type="text" name="nom" class="form-control form-control-lg bg-light border-0" required>
                            <span class="error-message">Ce champ est obligatoire.</span>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Prénom</label>
                            <input type="text" name="prenom" class="form-control form-control-lg bg-light border-0">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Téléphone (+261) <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-0 text-secondary">+261</span>
                                <input type="text" name="telephone" class="form-control form-control-lg bg-light border-0" placeholder="32 1234567" pattern="[0-9]{9}" maxlength="9" required>
                            </div>
                            <span class="error-message">9 chiffres : indicatif (32/33/34/37/38) + 7 chiffres.</span>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Email <span class="text-danger">*</span></label>
                            <input type="email" name="email" class="form-control form-control-lg bg-light border-0" required>
                            <span class="error-message">Email invalide ou déjà utilisé.</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-body p-5">
                    <h5 class="card-title text-primary fw-bold mb-4"><i class="bi bi-shield-lock-fill me-2"></i>Authentification et rôle</h5>
                    
                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Identifiant <span class="text-danger">*</span></label>
                            <input type="text" name="identifiant" class="form-control form-control-lg bg-light border-0" required>
                            <span class="error-message">Ce champ est obligatoire.</span>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Mot de passe <span class="text-danger">*</span></label>
                            <input type="password" name="mot_de_passe" class="form-control form-control-lg bg-light border-0" required minlength="8" placeholder="8 caractères min">
                            <span class="error-message">Au moins 8 caractères.</span>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Rôle <span class="text-danger">*</span></label>
                            <select name="role" class="form-select form-select-lg bg-light border-0" required>
                                <%
                                    for (Utilisateur r : roles) {
                                %>
                                    <option value="<%= r.getId_role() %>">
                                        <%= r.getNom_role() %>
                                    </option>
                                <% } %>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Date d'embauche <span class="text-danger">*</span></label>
                            <input type="date" name="date_embauche" class="form-control form-control-lg bg-light border-0" required>
                            <span class="error-message">Ce champ est obligatoire.</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="d-flex justify-content-between mt-4">
                <a href="?page=utilisateur/liste-utilisateur" class="btn btn-light btn-lg px-4 text-secondary shadow-sm hover-shadow">Annuler</a>
                <button type="submit" class="btn btn-primary btn-lg px-4 shadow-sm hover-shadow"><i class="bi bi-person-plus-fill me-2"></i>Créer l'utilisateur</button>
            </div>
        </form>
    </div>
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
                message = 'Email doit contenir un point après le @.';
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
                message = 'Au moins 8 caractères.';
            }
        }

        if (!valid) {
            field.classList.add('is-invalid');
            field.classList.remove('is-valid');
            if (errorSpan) {
                errorSpan.textContent = message;
                errorSpan.style.display = 'block';
            }
        } else {
            field.classList.remove('is-invalid');
            field.classList.add('is-valid');
            if (errorSpan) {
                errorSpan.style.display = 'none';
            }
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