<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("utilisateur") != null) {
        response.sendRedirect("pages/gestion-utilisateur.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - Mahery Vaika</title>
    <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/bootstrap/icons/bootstrap-icons.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .card {
            border-radius: 1rem;
            box-shadow: 0 1rem 3rem rgba(0,0,0,.3);
        }
        .card-body {
            padding: 2rem;
        }
        .form-control {
            border-radius: 2rem;
        }
        .btn-primary {
            border-radius: 2rem;
            padding: 0.6rem 2rem;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-4">
            <div class="card">
                <div class="card-body">
                    <h3 class="text-center mb-4"><i class="bi bi-person-circle"></i> Connexion</h3>
                    <%
                        String erreur = request.getParameter("erreur");
                        if (erreur != null) {
                    %>
                        <div class="alert alert-danger text-center" role="alert">
                            <i class="bi bi-exclamation-triangle"></i> Identifiant ou mot de passe incorrect.
                        </div>
                    <%
                        }
                    %>
                    <form action="traitement/traitement-login.jsp" method="post">
                        <div class="mb-3">
                            <label for="identifiant" class="form-label">Identifiant</label>
                            <input type="text" class="form-control" id="identifiant" name="identifiant" required autofocus>
                        </div>
                        <div class="mb-3">
                            <label for="mot_de_passe" class="form-label">Mot de passe</label>
                            <input type="password" class="form-control" id="mot_de_passe" name="mot_de_passe" required>
                        </div>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary">Se connecter</button>
                        </div>
                    </form>
                    <p class="text-center text-muted mt-3 small">
                        <i class="bi bi-info-circle"></i> Contactez l'administrateur pour vos accès.
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="assets/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>