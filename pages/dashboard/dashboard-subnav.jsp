<div class="dashboard-subnav">
    <ul class="list-unstyled m-0">
        <li>
            <a href="model.jsp?page=dashboard/jour"
               class="dashboard-subnav-link<%= "jour".equals(dashActive) ? " active" : "" %>"
               data-bs-toggle="tooltip" data-bs-placement="right" title="Jour">
                <i class="bi bi-sun-fill"></i>
            </a>
        </li>
        <li>
            <a href="model.jsp?page=dashboard/semaine"
               class="dashboard-subnav-link<%= "semaine".equals(dashActive) ? " active" : "" %>"
               data-bs-toggle="tooltip" data-bs-placement="right" title="Semaine">
                <i class="bi bi-calendar-week-fill"></i>
            </a>
        </li>
        <li>
            <a href="model.jsp?page=dashboard/mois"
               class="dashboard-subnav-link<%= "mois".equals(dashActive) ? " active" : "" %>"
               data-bs-toggle="tooltip" data-bs-placement="right" title="Mois">
                <i class="bi bi-calendar3"></i>
            </a>
        </li>
        <li>
            <a href="model.jsp?page=dashboard/annee"
               class="dashboard-subnav-link<%= "annee".equals(dashActive) ? " active" : "" %>"
               data-bs-toggle="tooltip" data-bs-placement="right" title="Annee">
                <i class="bi bi-bar-chart-fill"></i>
            </a>
        </li>
    </ul>
</div>

<script>
    (function () {
        var triggers = [].slice.call(document.querySelectorAll('.dashboard-subnav [data-bs-toggle="tooltip"]'));
        triggers.forEach(function (el) {
            if (window.bootstrap) { new bootstrap.Tooltip(el); }
        });
    })();
</script>
