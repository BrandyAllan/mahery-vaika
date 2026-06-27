<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="gestion.Vehicule" %>
<%@ page import="backoffice.Utilisateur" %>
<%@ page import="java.sql.Date" %>
<%
    Utilisateur userObj = (Utilisateur) session.getAttribute("utilisateur");
    if (userObj == null || !"Admin".equalsIgnoreCase(userObj.voirsiadmin())) {
        response.sendRedirect("liste-vehicule.jsp");
        return;
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            int idVehicule = Integer.parseInt(request.getParameter("id_vehicule"));
            String nouvelEtat = request.getParameter("etat");
            Date nouvelleDate = Date.valueOf(request.getParameter("dateAssurance"));
            
            Vehicule.modifierVehicule(idVehicule, nouvelEtat, nouvelleDate);
            response.sendRedirect("liste-vehicule.jsp");
            return;
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("modifier-vehicule.jsp?id=" + request.getParameter("id_vehicule"));
            return;
        }
    }

    String idParam = request.getParameter("id");
    if (idParam == null || idParam.isEmpty()) {
        response.sendRedirect("liste-vehicule.jsp");
        return;
    }

    int id = Integer.parseInt(idParam);
    Vehicule v = Vehicule.getVehiculeById(id); 

    if (v == null) {
        response.sendRedirect("liste-vehicule.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Modifier le Véhicule</title>
    <link rel="stylesheet" href="../assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/bootstrap/icons/bootstrap-icons.min.css">
</head>
<body class="bg-light">

    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <p><a href="liste-vehicule.jsp" class="btn btn-sm btn-secondary mb-3"><i class="bi bi-arrow-left"></i> Retour à la liste</a></p>
                
                <div class="card shadow-sm">
                    <div class="card-header bg-warning text-dark">
                        <h4 class="mb-0"><i class="bi bi-pencil-square"></i> Mise à jour du Véhicule</h4>
                    </div>
                    <div class="card-body p-4">
                        
                        <form action="modifier-vehicule.jsp" method="POST">
                            <input type="hidden" name="id_vehicule" value="<%= v.getIdVehicule() %>">

                            <div class="mb-3">
                                <label class="form-label text-muted">Immatriculation (Non modifiable) :</label>
                                <input type="text" class="form-control bg-light" value="<%= v.getImmatriculation() %>" readonly>
                            </div>

                            <div class="mb-3">
                                <label class="form-label text-muted">Désignation (Non modifiable) :</label>
                                <input type="text" class="form-control bg-light" value="<%= v.getMarque() + " " + v.getModele() %>" readonly>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-bold">État actuel du véhicule :</label>
                                <select name="etat" class="form-select" required>
                                    <option value="ACTIF" <%= "ACTIF".equals(v.getEtat()) ? "selected" : "" %>>ACTIF</option>
                                    <option value="EN PANNE" <%= "EN PANNE".equals(v.getEtat()) ? "selected" : "" %>>EN PANNE</option>
                                </select>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-bold">Date Expiration Assurance :</label>
                                <input type="date" name="dateAssurance" class="form-control" value="<%= v.getDateExpirationAssurance() %>" required>
                            </div>
                            
                            <div class="d-grid">
                                <button type="submit" class="btn btn-warning text-dark fw-bold"><i class="bi bi-check-lg"></i> Enregistrer les modifications</button>
                            </div>
                        </form>

                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>