<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String dashActive = "jour"; %>

<div class="dashboard-graph-page">
    <%@ include file="dashboard-subnav.jsp" %>

    <div class="dashboard-header">
        <h1>Dashboard journalier</h1>
        <p id="periodeDashboardJour">
            Chargement...
        </p>
    </div>

    <div id="dashboardJourErreur"
         class="alert alert-danger d-none">
    </div>

    <div class="filter-card">

        <div class="filter-group">
            <label for="dateJour">
                Choisir une date
            </label>

            <input
                type="date"
                id="dateJour"
                class="date-jour">
        </div>

        <button
            type="button"
            class="btn-filter btn-filter-jour">
            Filtrer
        </button>

    </div>

    <div class="charts-grid">

        <div class="chart-card">

            <h3 id="titreTrajetsJour">
                Choix des trajets du jour
            </h3>

            <div class="chart-canvas-wrapper">
                <canvas id="destinationChart"></canvas>
            </div>

        </div>

        <div class="chart-card">

            <h3>
                Chiffre d'affaires brut
                (5 derniers jours)
            </h3>

            <div class="chart-canvas-wrapper">
                <canvas id="caChart"></canvas>
            </div>

        </div>

        <div class="chart-card">

            <h3>
                Bénéfice
                (5 derniers jours)
            </h3>

            <div class="chart-canvas-wrapper">
                <canvas id="beneficeChart"></canvas>
            </div>

        </div>

    </div>

</div>

<script>

window.dashboardJourDataUrl = "../traitement/dashboard/dashboard-jour-data.jsp";

</script>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script src="../assets/js/dashboard-jour.js"></script>