<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="gestion.Vehicule" %>
<%@ page import="backoffice.Utilisateur" %>
<%@ page import="java.sql.Date" %>
<%
    Utilisateur userObj = (Utilisateur) session.getAttribute("utilisateur");
    if (userObj == null || !"Admin".equalsIgnoreCase(userObj.voirsiadmin())) {
        response.sendRedirect("model.jsp?page=vehicule/liste-vehicule");
        return;
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            int idVehicule = Integer.parseInt(request.getParameter("id_vehicule"));
            String nouvelEtat = request.getParameter("etat");
            Date nouvelleDate = Date.valueOf(request.getParameter("dateAssurance"));
            
            Vehicule.modifierVehicule(idVehicule, nouvelEtat, nouvelleDate);
            response.sendRedirect("model.jsp?page=vehicule/liste-vehicule");
            return;
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("model.jsp?page=vehicule/modifier-vehicule&id=" + request.getParameter("id_vehicule"));
            return;
        }
    }

    String idParam = request.getParameter("id");
    if (idParam == null || idParam.isEmpty()) {
        response.sendRedirect("model.jsp?page=vehicule/liste-vehicule");
        return;
    }

    int id = Integer.parseInt(idParam);
    Vehicule v = Vehicule.getVehiculeById(id); 

    if (v == null) {
        response.sendRedirect("model.jsp?page=vehicule/liste-vehicule");
        return;
    }
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <a href="?page=vehicule/liste-vehicule" class="btn btn-sm btn-light text-muted border-0 shadow-sm mb-2 hover-shadow">
            <i class="bi bi-arrow-left"></i> Retour à la liste
        </a>
        <h2 class="fw-bold mb-0" style="color: #2c3e50;">
            <i class="bi bi-pencil-square text-warning me-2"></i> Mise à jour du véhicule #<%= v.getIdVehicule() %>
        </h2>
    </div>
</div>

<div class="row justify-content-center">
    <div class="col-md-8">
        <form action="../traitement/vehicule/modifier-vehicule.jsp" method="POST">
            <input type="hidden" name="id_vehicule" value="<%= v.getIdVehicule() %>">

            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-body p-5">
                    <h5 class="card-title text-primary fw-bold mb-4"><i class="bi bi-car-front-fill me-2"></i>Informations du véhicule</h5>
                    
                    <div class="row g-4 mb-4">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Immatriculation <span class="text-muted fst-italic">(non modifiable)</span></label>
                            <input type="text" class="form-control form-control-lg bg-light border-0 text-muted" value="<%= v.getImmatriculation() %>" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Désignation <span class="text-muted fst-italic">(non modifiable)</span></label>
                            <input type="text" class="form-control form-control-lg bg-light border-0 text-muted" value="<%= v.getMarque() + " " + v.getModele() %>" readonly>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-body p-5">
                    <h5 class="card-title text-warning fw-bold mb-4"><i class="bi bi-wrench-adjustable me-2"></i>Paramètres à modifier</h5>
                    
                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">État actuel du véhicule <span class="text-danger">*</span></label>
                            <select name="etat" class="form-select form-select-lg bg-light border-0" required>
                                <option value="ACTIF" <%= "ACTIF".equals(v.getEtat()) ? "selected" : "" %>>ACTIF</option>
                                <option value="EN PANNE" <%= "EN PANNE".equals(v.getEtat()) ? "selected" : "" %>>EN PANNE</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary">Date Expiration Assurance <span class="text-danger">*</span></label>
                            <input type="date" name="dateAssurance" class="form-control form-control-lg bg-light border-0" value="<%= v.getDateExpirationAssurance() %>" required>
                        </div>
                    </div>
                </div>
            </div>

            <div class="d-flex justify-content-between mt-4">
                <a href="?page=vehicule/liste-vehicule" class="btn btn-light btn-lg px-4 text-secondary shadow-sm hover-shadow">Annuler</a>
                <button type="submit" class="btn btn-warning btn-lg px-4 shadow-sm hover-shadow"><i class="bi bi-check-lg me-2"></i>Enregistrer les modifications</button>
            </div>
        </form>
    </div>
</div>