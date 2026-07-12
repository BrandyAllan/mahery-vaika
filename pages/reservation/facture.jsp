<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, backoffice.Reservation, backoffice.Paiement, backoffice.Utilisateur" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) {
        response.sendRedirect("../index.jsp");
        return;
    }

    String idsParam = request.getParameter("ids");
    Vector<Integer> ids = new Vector<>();
    if (idsParam != null && !idsParam.trim().isEmpty()) {
        for (String s : idsParam.split(",")) {
            try {
                if (!s.trim().isEmpty()) ids.add(Integer.parseInt(s.trim()));
            } catch (Exception e) { /* ignore */ }
        }
    }

    if (ids.isEmpty()) {
        response.sendRedirect("?page=reservation/liste-reservation");
        return;
    }

    Vector<Reservation> reservations = new Vector<>();
    for (Integer id : ids) {
        Reservation r = Reservation.getById(id);
        if (r != null) reservations.add(r);
    }

    if (reservations.isEmpty()) {
        response.sendRedirect("?page=reservation/liste-reservation&error=notfound");
        return;
    }

    Vector<Paiement> paiements = Paiement.getByReservationIds(ids);

    Map<Integer, Paiement> paiementParReservation = new HashMap<>();
    for (Paiement p : paiements) {
        paiementParReservation.put(p.getId_reservation(), p);
    }

    Reservation premiere = reservations.get(0);

    double totalPaye = 0;
    for (Paiement p : paiements) totalPaye += p.getMontant();

    String numeroFacture = "FACT-" +
        new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date()) + "-" +
        String.format("%04d", premiere.getId_reservation());
%>
<link rel="stylesheet" href="../assets/css/facture.css">

<div class="d-flex justify-content-between align-items-center mb-4 no-print">
    <h2 class="fw-bold"><i class="bi bi-receipt-cutoff"></i> Facture</h2>
    <div>
        <button type="button" class="btn btn-outline-secondary" onclick="window.print()">
            <i class="bi bi-printer"></i> Imprimer
        </button>
        <button type="button" class="btn btn-success" id="btnExportPdf" data-filename="<%= numeroFacture %>.pdf">
            <i class="bi bi-file-earmark-pdf"></i> Exporter en PDF
        </button>
        <a href="?page=reservation/ajout-reservation" class="btn btn-primary">
            <i class="bi bi-plus-circle"></i> Nouvelle réservation
        </a>
        <a href="?page=reservation/liste-reservation" class="btn btn-secondary">
            <i class="bi bi-list-ul"></i> Liste des réservations
        </a>
    </div>
</div>

<div id="factureContent" class="facture-box">
    <div class="facture-entete">
        <div>
            <img src="../assets/images/logo.png" alt="Mahery Vaika" height="55">
            <h4 class="mt-2 mb-0">Mahery Vaika</h4>
            <div class="text-muted small">Transport de voyageurs</div>
        </div>
        <div class="text-end">
            <h4 class="mb-1">FACTURE</h4>
            <div><strong>N° :</strong> <%= numeroFacture %></div>
            <div><strong>Date :</strong> <%= premiere.getDate_reservation() %></div>
            <span class="badge bg-success facture-badge-paye mt-2"><i class="bi bi-check-circle"></i> PAYÉE</span>
        </div>
    </div>

    <div class="row g-3 mb-3">
        <div class="col-md-6">
            <h6 class="text-muted">PASSAGER</h6>
            <div><%= premiere.getNom_passager() %> <%= premiere.getPrenom_passager() != null ? premiere.getPrenom_passager() : "" %></div>
            <div><%= premiere.getTelephone_passager() != null ? premiere.getTelephone_passager() : "N/A" %></div>
        </div>
        <div class="col-md-6">
            <h6 class="text-muted">TRAJET</h6>
            <div><%= premiere.getVille_depart() %> → <%= premiere.getVille_arrivee() %></div>
            <div>Départ le <%= premiere.getDate_depart() %> à <%= premiere.getHeure_depart() %></div>
        </div>
    </div>

    <table class="table table-bordered">
        <thead class="table-light">
            <tr>
                <th>N° réservation</th>
                <th>Siège</th>
                <th>Mode de paiement</th>
                <th class="text-end">Montant payé</th>
            </tr>
        </thead>
        <tbody>
            <% for (Reservation r : reservations) {
                Paiement p = paiementParReservation.get(r.getId_reservation());
            %>
            <tr>
                <td><%= r.getNumero_reservation() %></td>
                <td>N° <%= r.getNumero_siege() %></td>
                <td><%= p != null ? p.getMode_paiement() : "N/A" %></td>
                <td class="text-end"><%= p != null ? String.format("%,.2f", p.getMontant()) : "0.00" %> Ar</td>
            </tr>
            <% } %>
        </tbody>
        <tfoot>
            <tr class="fw-bold table-light">
                <td colspan="3" class="text-end">TOTAL (<%= reservations.size() %> place(s))</td>
                <td class="text-end"><%= String.format("%,.2f", totalPaye) %> Ar</td>
            </tr>
        </tfoot>
    </table>

    <div class="text-muted small mt-3">
        Émise par <%= user.getNom() %> — Merci d'avoir voyagé avec Mahery Vaika.
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
<script src="../assets/js/facture.js"></script>
