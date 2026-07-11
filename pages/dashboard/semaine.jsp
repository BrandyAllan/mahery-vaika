<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String dashActive = "semaine"; %>

<div class="dashboard-graph-page">
    <%@ include file="dashboard-subnav.jsp" %>

    <div class="dashboard-header">
        <h1>Dashboard semaine</h1>
        <p>Statistiques hebdomadaires.</p>
    </div>

    <%@ include file="bloc-graphique.jsp" %>
</div>

<script src="../assets/js/dashboard-semaine.js"></script>