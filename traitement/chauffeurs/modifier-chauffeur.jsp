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
        response.sendRedirect("gestion-chauffeur.jsp");
        return;
    }

    int id = 0;
    try { id = Integer.parseInt(request.getParameter("id")); } catch (Exception e) {}
    Chauffeur ch = Chauffeur.getById(id);
    if (ch == null) {
        response.sendRedirect("liste-chauffeur.jsp");
        return;
    }

    Vector vehicules = Chauffeur.getVehiculesDispo();
    String erreur = (String) session.getAttribute("erreur");
    String succes = (String) session.getAttribute("succes");
    session.removeAttribute("erreur");
    session.removeAttribute("succes");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Modifier un Chauffeur</title>
    <link rel="stylesheet" href="../../assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="../../assets/bootstrap/icons/bootstrap-icons.min.css">
</head>
<body class="bg-light">
<div class="container mt-4" style="max-width: 700px;">

    <a href="details-chauffeur.jsp?id=<%= id %>" class="btn btn-sm btn-secondary mb-3">
        <i class="bi bi-arrow-left"></i> Retour aux details
    </a>
    <h2 class="mb-4"><i class="bi bi-pencil"></i> Modifier le Chauffeur</h2>

    <% if (erreur != null) { %>
    <div class="alert alert-danger"><%= erreur %></div>
    <% } %>
    <% if (succes != null) { %>
    <div class="alert alert-success"><%= succes %></div>
    <% } %>

    <div class="card shadow-sm">
        <div class="card-body">
            <form method="POST" action="traitement/modifier-chauffeur.jsp">
                <input type="hidden" name="id" value="<%= ch.getIdChauffeur() %>">

                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Nom <span class="text-danger">*</span></label>
                        <input type="text" name="nom" class="form-control" required value="<%= ch.getNom() %>">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Prenom</label>
                        <input type="text" name="prenom" class="form-control" value="<%= ch.getPrenom() != null ? ch.getPrenom() : "" %>">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Telephone</label>
                        <input type="text" name="telephone" class="form-control" value="<%= ch.getTelephone() != null ? ch.getTelephone() : "" %>">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">N° Permis <span class="text-danger">*</span></label>
                        <input type="text" name="numeroPermis" class="form-control" required value="<%= ch.getNumeroPermis() %>">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Date d'expiration du permis</label>
                        <input type="date" name="dateExpirationPermis" class="form-control"
                               value="<%= ch.getDateExpirationPermis() != null ? ch.getDateExpirationPermis().toString() : "" %>">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Vehicule habituel</label>
                        <select name="idVehiculeHabituel" class="form-select">
                            <option value="">— Aucun —</option>
                            <%
                            for (int i = 0; i < vehicules.size(); i++) {
                                Vehicule v = (Vehicule) vehicules.get(i);
                                boolean selected = v.getIdVehicule() == ch.getIdVehiculeHabituel();
                            %>
                            <option value="<%= v.getIdVehicule() %>" <%= selected ? "selected" : "" %>>
                                <%= v.getImmatriculation() %> — <%= v.getMarque() %> <%= v.getModele() %>
                            </option>
                            <% } %>
                        </select>
                    </div>
                </div>

                <div class="mt-4">
                    <button type="submit" class="btn btn-warning">
                        <i class="bi bi-save"></i> Enregistrer les modifications
                    </button>
                    <a href="details-chauffeur.jsp?id=<%= id %>" class="btn btn-outline-secondary ms-2">Annuler</a>
                </div>

            </form>
        </div>
    </div>
</div>
<script src="../../assets/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>