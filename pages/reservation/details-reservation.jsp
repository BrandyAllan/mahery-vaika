<%@ page import="backoffice.Reservation, backoffice.Utilisateur" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    boolean isAdmin = user.voirsiadmin().equals("Admin");

    String idParam = request.getParameter("id");
    if (idParam == null || idParam.isEmpty()) {
        response.sendRedirect("liste-reservation.jsp");
        return;
    }
    int id;
    try {
        id = Integer.parseInt(idParam);
    } catch (Exception e) {
        response.sendRedirect("liste-reservation.jsp?error=invalid");
        return;
    }
    Reservation r = Reservation.getById(id);
    if (r == null) {
        response.sendRedirect("liste-reservation.jsp?error=notfound");
        return;
    }

    // Verifier les droits : admin peut tout voir, utilisateur seulement ses propres reservations
    boolean canModify = isAdmin || r.getId_caissier() == user.getId_utilisateur();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Details reservation</title>
    <link rel="stylesheet" href="../assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/bootstrap/icons/bootstrap-icons.min.css">
</head>
<body>
<div class="container mt-4">
    <h2>Details de la reservation</h2>
    <a href="?page=reservation/liste-reservation" class="btn btn-secondary mb-3"><i class="bi bi-arrow-left"></i> Retour</a>

    <div class="card">
        <div class="card-header">
            <h5 class="mb-0">
                Reservation <strong><%= r.getNumero_reservation() %></strong>
                <span class="badge <%= r.getStatut().equals("CONFIRMEE") ? "bg-success" : "bg-danger" %> float-end">
                    <%= r.getStatut() %>
                </span>
            </h5>
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-6">
                    <p><strong><i class="bi bi-person"></i> Passager :</strong><br>
                    <%= r.getNom_passager() %> <%= r.getPrenom_passager() != null ? r.getPrenom_passager() : "" %></p>
                    <p><strong><i class="bi bi-telephone"></i> Telephone :</strong><br>
                    <%= r.getTelephone_passager() != null ? r.getTelephone_passager() : "N/A" %></p>
                    <p><strong><i class="bi bi-grid"></i> Siege :</strong><br>
                    N° <%= r.getNumero_siege() %></p>
                </div>
                <div class="col-md-6">
                    <p><strong><i class="bi bi-geo-alt"></i> Trajet :</strong><br>
                    <%= r.getVille_depart() %> → <%= r.getVille_arrivee() %></p>
                    <p><strong><i class="bi bi-calendar"></i> Date depart :</strong><br>
                    <%= r.getDate_depart() %> a <%= r.getHeure_depart() %></p>
                    <p><strong><i class="bi bi-clock"></i> Duree estimee :</strong><br>
                    <%= r.getDuree_estimee() != null ? r.getDuree_estimee() : "N/A" %></p>
                    <p><strong><i class="bi bi-currency-dollar"></i> Tarif base :</strong><br>
                    <%= String.format("%.2f", r.getTarif_base()) %> Ar</p>
                </div>
            </div>
            <hr>
            <div class="row g-3">
                <div class="col-md-6">
                    <p><strong><i class="bi bi-cash-stack"></i> Caissier :</strong><br>
                    <%= r.getNom_caissier() %></p>
                    <p><strong><i class="bi bi-calendar-check"></i> Date reservation :</strong><br>
                    <%= r.getDate_reservation() %></p>
                </div>
                <div class="col-md-6">
                    <% if (r.getStatut().equals("ANNULEE")) { %>
                        <p><strong><i class="bi bi-exclamation-triangle"></i> Motif annulation :</strong><br>
                        <%= r.getMotif_annulation() != null ? r.getMotif_annulation() : "N/A" %></p>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <div class="mt-3">
        <% if (canModify && r.getStatut().equals("CONFIRMEE")) { %>
            <a href="?page=reservation/modifier-reservation&id=<%= r.getId_reservation() %>" class="btn btn-warning">
                <i class="bi bi-pencil"></i> Modifier
            </a>
            <a href="../traitement/annuler-reservation.jsp?id=<%= r.getId_reservation() %>" 
               class="btn btn-danger"
               onclick="return confirm('Confirmer l\'annulation de la reservation <%= r.getNumero_reservation() %> ?')">
                <i class="bi bi-x-circle"></i> Annuler
            </a>
        <% } %>
        <a href="?page=reservation/liste-reservation" class="btn btn-secondary">Retour a la liste</a>
    </div>
</div>
<script src="../assets/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
