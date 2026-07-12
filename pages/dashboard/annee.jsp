<%@ page import="java.util.Vector, java.util.Calendar, java.util.Locale, dashboard.DashboardAnnuel" %>

<%
    Vector<DashboardAnnuel> historique = DashboardAnnuel.getHistorique(); // deja trie par annee DESC
    int nbAnnees = historique.size();

    int anneeCible = historique.isEmpty()
        ? Calendar.getInstance().get(Calendar.YEAR)
        : historique.get(0).getAnnee();

    StringBuilder labelsJson = new StringBuilder("[");
    StringBuilder caJson = new StringBuilder("[");
    StringBuilder beneficeJson = new StringBuilder("[");
    for (int i = nbAnnees - 1; i >= 0; i--) {
        DashboardAnnuel da = historique.get(i);
        if (i != nbAnnees - 1) {
            labelsJson.append(","); caJson.append(","); beneficeJson.append(",");
        }
        labelsJson.append("\"").append(da.getAnnee()).append("\"");
        caJson.append(String.format(Locale.US, "%.2f", da.getChiffreAffaires()));
        beneficeJson.append(String.format(Locale.US, "%.2f", da.getBenefice()));
    }
    labelsJson.append("]");
    caJson.append("]");
    beneficeJson.append("]");

    Vector<Object[]> topDestinations = DashboardAnnuel.getTopDestinations(anneeCible, 5);

    StringBuilder destLabelsJson = new StringBuilder("[");
    StringBuilder destValuesJson = new StringBuilder("[");
    for (int i = 0; i < topDestinations.size(); i++) {
        if (i > 0) { destLabelsJson.append(","); destValuesJson.append(","); }
        Object[] d = topDestinations.get(i);
        destLabelsJson.append("\"").append(d[0]).append("\"");
        destValuesJson.append(String.format(Locale.US, "%.1f", (double) d[1]));
    }
    destLabelsJson.append("]");
    destValuesJson.append("]");

    String dashActive = "annee";
%>

<div class="dashboard-graph-page">
    <%@ include file="dashboard-subnav.jsp" %>

    <div class="dashboard-header">
        <h1>Dashboard annuel</h1>
        <p>Statistiques annuelles.</p>
    </div>

    <%@ include file="bloc-graphique.jsp" %>

    <div class="card border-0 shadow-sm mt-4">
        <div class="card-header bg-body-tertiary d-flex align-items-center justify-content-between">
            <h3 class="h6 mb-0 text-body-emphasis">Historique annuel</h3>
            <span class="badge text-bg-secondary"><%= historique.size() %> annee(s)</span>
        </div>

        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover table-striped align-middle mb-0">
                    <thead>
                        <tr>
                            <th class="ps-4">Annee</th>
                            <th>Destination phare</th>
                            <th>Chiffre d'affaires</th>
                            <th>Benefice</th>
                            <th class="pe-4">Reservations</th>
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
                                <td colspan="5" class="text-center text-muted py-4">Aucune donnee disponible.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
    window.labelsAnneesReelles = <%= labelsJson %>;
    window.caReelParAnnee = <%= caJson %>;
    window.beneficeReelParAnnee = <%= beneficeJson %>;
    window.destinationsReelles = { labels: <%= destLabelsJson %>, values: <%= destValuesJson %> };
</script>
<script src="../assets/js/dashboard-annee.js"></script>