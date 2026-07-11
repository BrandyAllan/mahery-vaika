<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String dashActive = "mois"; %>

<div class="dashboard-graph-page">
    <%@ include file="dashboard-subnav.jsp" %>

    <div class="dashboard-header">
        <h1>Dashboard mensuel</h1>
        <p>Statistiques du mois.</p>
    </div>

    <%@ include file="bloc-graphique.jsp" %>
</div>

<script src="../assets/js/dashboard-mois.js"></script>