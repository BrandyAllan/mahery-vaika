<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dashboard.DashboardMois" %>
<%@ page import="backoffice.Utilisateur" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.List" %>

<%!
    private String echapperJson(String valeur) {

        if (valeur == null) {
            return "";
        }

        return valeur
            .replace("\\", "\\\\")
            .replace("\"", "\\\"")
            .replace("\n", "\\n")
            .replace("\r", "\\r")
            .replace("\t", "\\t");
    }
%>

<%
    response.setContentType(
        "application/json; charset=UTF-8"
    );

    response.setCharacterEncoding("UTF-8");

    Utilisateur utilisateur =
        (Utilisateur) session.getAttribute(
            "utilisateur"
        );

    if (utilisateur == null) {

        response.setStatus(401);

        out.print(
            "{\"erreur\":\"Utilisateur non authentifié\"}"
        );

        return;
    }

    String dateDebutParam = request.getParameter("date_debut");

    String dateFinParam = request.getParameter("date_fin");

    Date dateDebutStats;
    Date dateFinStats;

    try {

        if (dateDebutParam != null && !dateDebutParam.trim().isEmpty()) {

            dateDebutStats = Date.valueOf(dateDebutParam.trim());

        } else {

            dateDebutStats = DashboardMois.premierJourDesCinqDerniersMois();
        }

        if (dateFinParam != null && !dateFinParam.trim().isEmpty()) {

            dateFinStats =Date.valueOf(dateFinParam.trim());

        } else {

            dateFinStats = DashboardMois.dernierJourMoisCourant();
        }

    } catch (IllegalArgumentException e) {

        response.setStatus(400);

        out.print(
            "{\"erreur\":\"Format de date invalide\"}"
        );

        return;
    }

    if (dateFinStats.before(dateDebutStats)) {

        response.setStatus(400);

        out.print(
            "{\"erreur\":\"La date de fin doit être supérieure ou égale à la date de début\"}"
        );

        return;
    }

    List<DashboardMois.Mois> statistiquesMois =
        DashboardMois.getStatsMois(
            dateDebutStats,
            dateFinStats
        );
    Date dateDebutDestinations =
        DashboardMois
            .premierJourMoisCourant();

    Date dateFinDestinations =
        DashboardMois
            .dernierJourMoisCourant();

    List<DashboardMois.Destination> destinations =
        DashboardMois.getStatsDestinations(
            dateDebutDestinations,
            dateFinDestinations
        );

    StringBuilder json =
        new StringBuilder();

    json.append("{");
    json.append("\"dateDebut\":\"")
        .append(dateDebutStats)
        .append("\",");

    json.append("\"dateFin\":\"")
        .append(dateFinStats)
        .append("\",");

    json.append("\"dateDebutDestinations\":\"")
        .append(dateDebutDestinations)
        .append("\",");

    json.append("\"dateFinDestinations\":\"")
        .append(dateFinDestinations)
        .append("\",");

    json.append("\"labels\":[");

    for (
        int i = 0;
        i < statistiquesMois.size();
        i++
    ) {

        if (i > 0) {
            json.append(",");
        }

        json.append("\"")
            .append(
                echapperJson(
                    statistiquesMois
                        .get(i)
                        .getLabel()
                )
            )
            .append("\"");
    }

    json.append("],");
    json.append("\"ca\":[");

    for (
        int i = 0;
        i < statistiquesMois.size();
        i++
    ) {

        if (i > 0) {
            json.append(",");
        }

        json.append(
            statistiquesMois
                .get(i)
                .getCa()
        );
    }

    json.append("],");
    json.append("\"benefice\":[");

    for (
        int i = 0;
        i < statistiquesMois.size();
        i++
    ) {

        if (i > 0) {
            json.append(",");
        }

        json.append(
            statistiquesMois
                .get(i)
                .getBenefice()
        );
    }

    json.append("],");
    json.append("\"destinations\":{");
    json.append("\"labels\":[");

    for (
        int i = 0;
        i < destinations.size();
        i++
    ) {

        if (i > 0) {
            json.append(",");
        }

        json.append("\"")
            .append(
                echapperJson(
                    destinations
                        .get(i)
                        .getVille()
                )
            )
            .append("\"");
    }

    json.append("],");
    json.append("\"values\":[");

    for (
        int i = 0;
        i < destinations.size();
        i++
    ) {

        if (i > 0) {
            json.append(",");
        }

        json.append(
            destinations
                .get(i)
                .getPourcentage()
        );
    }

    json.append("],");
    json.append("\"nombres\":[");

    for (
        int i = 0;
        i < destinations.size();
        i++
    ) {

        if (i > 0) {
            json.append(",");
        }

        json.append(
            destinations
                .get(i)
                .getNombre()
        );
    }

    json.append("]");

    json.append("}");

    json.append("}");

    out.print(
        json.toString()
    );
%>