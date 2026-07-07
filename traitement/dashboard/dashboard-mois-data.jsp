<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dashboard.DashboardMois" %>
<%@ page import="backoffice.Utilisateur" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.List" %>
<%!
    private String echapper(String valeur) {
        if (valeur == null) {
            return "";
        }
        return valeur.replace("\\", "\\\\").replace("\"", "\\\"");
    }
%>
<%
    Utilisateur userObj = (Utilisateur) session.getAttribute("utilisateur");
    if (userObj == null) {
        response.setStatus(401);
        out.print("{\"erreur\":\"Non authentifie\"}");
        return;
    }

    String paramDebut = request.getParameter("date_debut");
    String paramFin = request.getParameter("date_fin");

    Date dateDebut;
    Date dateFin;

    try {
        dateDebut = (paramDebut != null && !paramDebut.trim().isEmpty())
                ? Date.valueOf(paramDebut.trim())
                : DashboardMois.premierJourMoisCourant();

        dateFin = (paramFin != null && !paramFin.trim().isEmpty())
                ? Date.valueOf(paramFin.trim())
                : DashboardMois.dernierJourMoisCourant();
    } catch (IllegalArgumentException e) {
        response.setStatus(400);
        out.print("{\"erreur\":\"Format de date invalide\"}");
        return;
    }

    if (dateFin.before(dateDebut)) {
        response.setStatus(400);
        out.print("{\"erreur\":\"La date de fin doit etre apres la date de debut\"}");
        return;
    }

    List<DashboardMois.Semaine> semaines = DashboardMois.getStatsSemaine(dateDebut, dateFin);
    List<DashboardMois.Destination> destinations = DashboardMois.getStatsDestinations(dateDebut, dateFin);

    StringBuilder json = new StringBuilder();
    json.append("{");

    json.append("\"labels\":[");
    for (int i = 0; i < semaines.size(); i++) {
        if (i > 0) json.append(",");
        json.append("\"").append(echapper(semaines.get(i).getLabel())).append("\"");
    }
    json.append("],");

    json.append("\"ca\":[");
    for (int i = 0; i < semaines.size(); i++) {
        if (i > 0) json.append(",");
        json.append(semaines.get(i).getCa());
    }
    json.append("],");

    json.append("\"benefice\":[");
    for (int i = 0; i < semaines.size(); i++) {
        if (i > 0) json.append(",");
        json.append(semaines.get(i).getBenefice());
    }
    json.append("],");

    json.append("\"destinations\":{");
    json.append("\"labels\":[");
    for (int i = 0; i < destinations.size(); i++) {
        if (i > 0) json.append(",");
        json.append("\"").append(echapper(destinations.get(i).getVille())).append("\"");
    }
    json.append("],");
    json.append("\"values\":[");
    for (int i = 0; i < destinations.size(); i++) {
        if (i > 0) json.append(",");
        json.append(destinations.get(i).getPourcentage());
    }
    json.append("]");
    json.append("}");

    json.append("}");

    out.print(json.toString());
%>
