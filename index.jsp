<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Connexion - Mahery Vaika</title>

    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/icons/bootstrap-icons.min.css">

    <link rel="stylesheet" href="assets/css/login.css">
</head>

<body>

<div class="login-container">

    <div class="login-wrapper">

        <div class="logo-section">

            <img src="assets/images/logo.png" alt="Logo">

        </div>

        <div class="form-section">

            <div class="login-card">

                <%
                    String erreur = request.getParameter("erreur");
                    if(erreur != null){
                %>

                <div class="alert alert-danger">
                    Identifiant ou mot de passe incorrect.
                </div>

                <%
                    }
                %>

                <form action="traitement/traitement-login.jsp" method="post">

                    <div class="mb-3">

                        <label class="form-label">
                            <i class="bi bi-person"></i>
                            Identifiant
                        </label>

                        <input
                            type="text"
                            name="identifiant"
                            class="form-control"
                            required>

                    </div>

                    <div class="mb-3">

                        <div class="password-header">

                            <label class="form-label mb-0">
                                <i class="bi bi-lock"></i>
                                Mot de passe
                            </label>

                            <a href="#" class="forgot-password">
                                Mot de passe oublié ?
                            </a>

                        </div>

                        <div class="input-group">

                            <input
                                type="password"
                                id="password"
                                name="mot_de_passe"
                                class="form-control"
                                required>

                            <span class="input-group-text password-toggle">
                                <i class="bi bi-eye" id="togglePassword"></i>
                            </span>

                        </div>

                    </div>

                    <button type="submit" class="btn-login">
                        Connexion
                    </button>

                </form>

            </div>

            <div class="footer-login">
                © 2026 MAHERY VAIKA
            </div>

        </div>

    </div>

</div>

<script src="assets/js/login.js"></script>

</body>
</html>