<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="backoffice.Utilisateur" %>
<%@ page import="gestion.Chauffeur" %>
<%@ page import="gestion.Vehicule" %>
<%@ page import="java.util.Vector" %>
<%
    Utilisateur userObj = (Utilisateur) session.getAttribute("utilisateur");
    if (userObj == null) {
        response.sendRedirect("../../index.jsp");
        return;
    }
    if (!"Admin".equalsIgnoreCase(userObj.voirsiadmin())) {
        response.sendRedirect("?page=chauffeurs/gestion-chauffeur");
        return;
    }

    Vector vehicules = Chauffeur.getVehiculesDispo();
    String erreur  = (String) session.getAttribute("erreur");
    String succes  = (String) session.getAttribute("succes");
    session.removeAttribute("erreur");
    session.removeAttribute("succes");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Ajouter un Chauffeur</title>
    <link rel="stylesheet" href="../../assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="../../assets/bootstrap/icons/bootstrap-icons.min.css">
</head>
<body class="bg-light">
<div class="container mt-4" style="max-width: 700px;">

    <a href="?page=chauffeurs/liste-chauffeur" class="btn btn-sm btn-secondary mb-3">
        <i class="bi bi-arrow-left"></i> Retour a la liste
    </a>
    <h2 class="mb-4"><i class="bi bi-person-plus"></i> Ajouter un Chauffeur</h2>

    <% if (erreur != null) { %>
    <div class="alert alert-danger"><%= erreur %></div>
    <% } %>
    <% if (succes != null) { %>
    <div class="alert alert-success"><%= succes %></div>
    <% } %>

    <div class="card shadow-sm">
        <div class="card-body">
            <form method="POST" action="../../traitement/chauffeurs/ajouter-chauffeur.jsp">

                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Nom <span class="text-danger">*</span></label>
                        <input type="text" name="nom" class="form-control" required placeholder="Nom">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Prenom</label>
                        <input type="text" name="prenom" class="form-control" placeholder="Prenom">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Telephone</label>
                        <input type="text" name="telephone" class="form-control" placeholder="+261 34 ...">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">N° Permis <span class="text-danger">*</span></label>
                        <input type="text" name="numeroPermis" class="form-control" required placeholder="Numero de permis">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Date d'expiration du permis</label>
                        <input type="date" name="dateExpirationPermis" class="form-control">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Vehicule habituel</label>
                        <select name="idVehiculeHabituel" class="form-select">
                            <option value="">— Aucun —</option>
                            <%
                            for (int i = 0; i < vehicules.size(); i++) {
                                Vehicule v = (Vehicule) vehicules.get(i);
                            %>
                            <option value="<%= v.getIdVehicule() %>">
                                <%= v.getImmatriculation() %> — <%= v.getMarque() %> <%= v.getModele() %>
                            </option>
                            <% } %>
                        </select>
                    </div>
                </div>

                <div class="mt-4">
                    <button type="submit" class="btn btn-success">
                        <i class="bi bi-check-lg"></i> Enregistrer
                    </button>
                    <a href="?page=chauffeurs/liste-chauffeur" class="btn btn-outline-secondary ms-2">Annuler</a>
                </div>

            </form>
        </div>
    </div>
</div>
<script src="../../assets/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>