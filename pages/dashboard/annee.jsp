<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Vector, dashboard.DashboardAnnuel" %>

<%
    Vector<DashboardAnnuel> historique = DashboardAnnuel.getHistorique();
%>

<div class="dashboard-graph-page">
    <div class="dashboard-header">
        <h1>Dashboard annuel</h1>
        <p>Statistiques annuelles.</p>
    </div>

    <%@ include file="bloc-graphique.jsp" %>

    <table class="table table-hover align-middle mb-0 dashboard-table">
        <thead>
            <tr>
                <th>Année</th>
                <th>Destination phare</th>
                <th>Chiffre d'affaires</th>
                <th>Bénéfice</th>
                <th>Nombre de réservations</th>
            </tr>
        </thead>
        <tbody>
            <% for (DashboardAnnuel da : historique) { %>
                <tr>
                    <td><%= da.getAnnee() %></td>
                    <td><%= da.getDestinationTop() %> (<%= String.format("%.1f", da.getDestinationPourcentage()) %>%)</td>
                    <td><%= String.format("%,.0f Ar", da.getChiffreAffaires()) %></td>
                    <td><%= String.format("%,.0f Ar", da.getBenefice()) %></td>
                    <td><%= da.getNombreReservations() %></td>
                </tr>
            <% } %>

            <% if (historique.isEmpty()) { %>
                <tr>
                    <td colspan="5" class="text-center">Aucune donnée disponible.</td>
                </tr>
            <% } %>
        </tbody>
    </table>
</div>

<script src="../assets/js/dashboard-annee.js"></script>