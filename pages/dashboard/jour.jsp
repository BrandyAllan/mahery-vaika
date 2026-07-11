<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String dashActive = "jour"; %>

<div class="dashboard-graph-page">
    <%@ include file="dashboard-subnav.jsp" %>

    <div class="dashboard-header">
        <h1>Dashboard du jour</h1>
        <p>Statistiques du jour actuel.</p>
    </div>

    <%@ include file="bloc-graphique.jsp" %>
</div>

<script src="../assets/js/dashboard-jour.js"></script>