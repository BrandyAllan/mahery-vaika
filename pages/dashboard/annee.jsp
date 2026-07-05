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

    <div class="card border-0 shadow-sm mt-4">
        <div class="card-header bg-body-tertiary d-flex align-items-center justify-content-between">
            <h3 class="h6 mb-0 text-body-emphasis">Historique annuel</h3>
            <span class="badge text-bg-secondary"><%= historique.size() %> année(s)</span>
        </div>

        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover table-striped align-middle mb-0">
                    <thead>
                        <tr>
                            <th class="ps-4">Année</th>
                            <th>Destination phare</th>
                            <th>Chiffre d'affaires</th>
                            <th>Bénéfice</th>
                            <th class="pe-4">Réservations</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (DashboardAnnuel da : historique) {
                            boolean positif = da.getBenefice() >= 0;
                        %>
                            <tr>
                                <td class="ps-4 fw-semibold"><%= da.getAnnee() %></td>
                                <td>
                                    <%= da.getDestinationTop() %>
                                    <span class="badge text-bg-primary ms-1"><%= String.format("%.1f", da.getDestinationPourcentage()) %>%</span>
                                </td>
                                <td><%= String.format("%,.0f Ar", da.getChiffreAffaires()) %></td>
                                <td class="<%= positif ? "text-success" : "text-danger" %> fw-semibold">
                                    <%= String.format("%,.0f Ar", da.getBenefice()) %>
                                </td>
                                <td class="pe-4"><%= da.getNombreReservations() %></td>
                            </tr>
                        <% } %>

                        <% if (historique.isEmpty()) { %>
                            <tr>
                                <td colspan="5" class="text-center text-muted py-4">Aucune donnée disponible.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script src="../assets/js/dashboard-annee.js"></script>