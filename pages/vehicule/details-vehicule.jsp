<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="gestion.Vehicule" %>
<%@ page import="backoffice.Utilisateur" %>
<%
    Utilisateur userObj = (Utilisateur) session.getAttribute("utilisateur");
    if (userObj == null) {
        response.sendRedirect("../../index.jsp");
        return;
    }

    String userRole = userObj.voirsiadmin();
    boolean isAdmin = "Admin".equalsIgnoreCase(userRole);

    String idStr = request.getParameter("id");
    if (idStr == null || idStr.isEmpty()) {
        response.sendRedirect("?page=vehicule/liste-vehicule");
        return;
    }

    int id = Integer.parseInt(idStr);
    Vehicule v = Vehicule.getVehiculeById(id);

    if (v == null) {
        response.sendRedirect("?page=vehicule/liste-vehicule");
        return;
    }
%>

<%-- En-tête de page --%>
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <a href="?page=vehicule/liste-vehicule"
           class="btn btn-sm btn-light text-muted border-0 shadow-sm mb-2 hover-shadow">
            <i class="bi bi-arrow-left"></i> Retour à la liste
        </a>
        <h2 class="fw-bold mb-0" style="color: #2c3e50;">
            <i class="bi bi-car-front-fill text-primary me-2"></i>
            <%= v.getImmatriculation() %>
            <span class="badge <%= "ACTIF".equals(v.getEtat()) ? "bg-success" : "bg-danger" %> fs-6 ms-2 rounded-pill">
                <%= v.getEtat() %>
            </span>
        </h2>
    </div>
    <% if (isAdmin) { %>
    <a href="?page=vehicule/modifier-vehicule&id=<%= v.getIdVehicule() %>"
       class="btn btn-outline-primary shadow-sm">
        <i class="bi bi-pencil me-1"></i> Modifier la fiche
    </a>
    <% } %>
</div>

<%-- Entretiens rapides --%>
<div class="card border-0 shadow-sm rounded-4 mb-4">
    <div class="card-body p-4">
        <h5 class="card-title text-primary fw-bold mb-4">
            <i class="bi bi-tools me-2"></i>Actions d'entretien
        </h5>
        <div class="d-flex gap-3 flex-wrap">
            <a href="model.jsp?page=vehicule/entretien-vehicule&id=<%= v.getIdVehicule() %>&type=VIDANGE"
               class="btn btn-primary px-4 shadow-sm hover-shadow">
                <i class="bi bi-droplet-half me-2"></i>Vidange
            </a>
            <a href="model.jsp?page=vehicule/entretien-vehicule&id=<%= v.getIdVehicule() %>&type=PNEU"
               class="btn btn-outline-secondary px-4 shadow-sm hover-shadow">
                <i class="bi bi-disc me-2"></i>Pneu
            </a>
            <a href="model.jsp?page=vehicule/entretien-vehicule&id=<%= v.getIdVehicule() %>&type=LAVAGE"
               class="btn btn-outline-info px-4 shadow-sm hover-shadow">
                <i class="bi bi-moisture me-2"></i>Lavage
            </a>
            <a href="model.jsp?page=vehicule/entretien-vehicule&id=<%= v.getIdVehicule() %>&type=AUTRES"
               class="btn btn-outline-warning px-4 shadow-sm hover-shadow">
                <i class="bi bi-gear me-2"></i>Autres
            </a>
        </div>
    </div>
</div>

<div class="row g-4">

    <%-- Identification --%>
    <div class="col-lg-6">
        <div class="card border-0 shadow-sm rounded-4 h-100">
            <div class="card-body p-4">
                <h5 class="card-title text-primary fw-bold mb-4">
                    <i class="bi bi-info-circle-fill me-2"></i>Identification
                </h5>
                <div class="row g-3">
                    <div class="col-12">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Immatriculation</p>
                        <span class="badge bg-light text-dark border fs-5 px-3 py-2 font-monospace">
                            <%= v.getImmatriculation() %>
                        </span>
                    </div>
                    <div class="col-12"><hr class="my-2 opacity-25"></div>
                    <div class="col-6">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Constructeur</p>
                        <p class="fw-bold mb-0"><%= v.getMarque() %></p>
                    </div>
                    <div class="col-6">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Modèle</p>
                        <p class="fw-semibold mb-0"><%= v.getModele() %></p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- État opérationnel --%>
    <div class="col-lg-6">
        <div class="card border-0 shadow-sm rounded-4 h-100">
            <div class="card-body p-4">
                <h5 class="card-title text-primary fw-bold mb-4">
                    <i class="bi bi-speedometer2 me-2"></i>État opérationnel
                </h5>
                <div class="row g-3">
                    <div class="col-6">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Capacité</p>
                        <p class="fw-bold mb-0 fs-5">
                            <i class="bi bi-people-fill text-primary me-1"></i>
                            <%= v.getCapacite() %> <span class="text-muted fw-normal fs-6">places</span>
                        </p>
                    </div>
                    <div class="col-6">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Kilométrage compteur</p>
                        <p class="fw-bold mb-0 fs-5">
                            <i class="bi bi-speedometer2 text-info me-1"></i>
                            <%= v.getKilometrageActuel() %> <span class="text-muted fw-normal fs-6">km</span>
                        </p>
                    </div>
                    <div class="col-12"><hr class="my-2 opacity-25"></div>
                    <div class="col-6">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Statut</p>
                        <span class="badge <%= "ACTIF".equals(v.getEtat()) ? "bg-success" : "bg-danger" %> rounded-pill px-3 py-2">
                            <%= v.getEtat() %>
                        </span>
                    </div>
                    <div class="col-6">
                        <p class="mb-1 text-muted small fw-semibold text-uppercase" style="font-size:.72rem;">Date limite assurance</p>
                        <p class="fw-semibold mb-0">
                            <i class="bi bi-shield-check text-warning me-1"></i>
                            <%= v.getDateExpirationAssurance() != null ? v.getDateExpirationAssurance() : "N/A" %>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>

<% if (!isAdmin) { %>
<div class="alert alert-info border-0 shadow-sm rounded-4 mt-4 d-flex align-items-center" role="alert">
    <i class="bi bi-info-circle-fill me-2 fs-5"></i>
    La modification est réservée aux administrateurs.
</div>
<% } %>