<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dashboard.DashboardJour" %>
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
    response.setContentType("application/json; charset=UTF-8");
    response.setCharacterEncoding("UTF-8");

    Utilisateur utilisateur =
        (Utilisateur) session.getAttribute("utilisateur");

    if (utilisateur == null) {
        response.setStatus(401);
        out.print(
            "{\"erreur\":\"Utilisateur non authentifié\"}"
        );
        return;
    }

    String dateJourParam =
        request.getParameter("date_jour");

    Date dateCible;

    try {
        if (
            dateJourParam != null
            && !dateJourParam.trim().isEmpty()
        ) {
            dateCible = Date.valueOf(
                dateJourParam.trim()
            );
        } else {
            dateCible = DashboardJour.getJourActuel();
        }
    } catch (IllegalArgumentException e) {
        response.setStatus(400);
        out.print(
            "{\"erreur\":\"Format de date invalide\"}"
        );
        return;
    }

    Date dateDebut =
        DashboardJour.soustraireJours(dateCible, 4);

    List<DashboardJour.StatJour> statistiques =
        DashboardJour.getStatistiquesCinqJours(
            dateCible
        );

    List<DashboardJour.ChoixTrajet> choixTrajets =
        DashboardJour.getChoixTrajetsDuJour(
            dateCible
        );

    StringBuilder json = new StringBuilder();

    json.append("{");

    json.append("\"dateCible\":\"")
        .append(dateCible)
        .append("\",");

    json.append("\"dateDebut\":\"")
        .append(dateDebut)
        .append("\",");

    json.append("\"dateFin\":\"")
        .append(dateCible)
        .append("\",");

    json.append("\"labels\":[");

    for (int i = 0; i < statistiques.size(); i++) {
        if (i > 0) {
            json.append(",");
        }

        json.append("\"")
            .append(
                echapperJson(
                    statistiques.get(i).getLabel()
                )
            )
            .append("\"");
    }

    json.append("],");
    json.append("\"ca\":[");

    for (int i = 0; i < statistiques.size(); i++) {
        if (i > 0) {
            json.append(",");
        }

        json.append(
            statistiques
                .get(i)
                .getChiffreAffaires()
        );
    }

    json.append("],");
    json.append("\"depenses\":[");

    for (int i = 0; i < statistiques.size(); i++) {
        if (i > 0) {
            json.append(",");
        }

        json.append(
            statistiques
                .get(i)
                .getDepenses()
        );
    }

    json.append("],");
    json.append("\"benefice\":[");

    for (int i = 0; i < statistiques.size(); i++) {
        if (i > 0) {
            json.append(",");
        }

        json.append(
            statistiques
                .get(i)
                .getBenefice()
        );
    }

    json.append("],");
    json.append("\"trajets\":{");
    json.append("\"labels\":[");

    for (int i = 0; i < choixTrajets.size(); i++) {
        if (i > 0) {
            json.append(",");
        }

        json.append("\"")
            .append(
                echapperJson(
                    choixTrajets.get(i).getTrajet()
                )
            )
            .append("\"");
    }

    json.append("],");
    json.append("\"values\":[");

    for (int i = 0; i < choixTrajets.size(); i++) {
        if (i > 0) {
            json.append(",");
        }

        json.append(
            choixTrajets
                .get(i)
                .getPourcentage()
        );
    }

    json.append("],");
    json.append("\"nombres\":[");

    for (int i = 0; i < choixTrajets.size(); i++) {
        if (i > 0) {
            json.append(",");
        }

        json.append(
            choixTrajets
                .get(i)
                .getNombreReservations()
        );
    }

    json.append("]");
    json.append("}");
    json.append("}");

    out.print(json.toString());
%>