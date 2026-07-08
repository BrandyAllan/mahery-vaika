<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dashboard.DashboardSemaine" %>
<%@ page import="backoffice.Utilisateur" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.Vector" %>
<%!
    private String echapper(String valeur) {
        if (valeur == null) return "";
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

    String paramDebut = request.getParameter("dateDebut");
    String paramFin = request.getParameter("dateFin");

    Date dateDebut;
    Date dateFin;

    try {
        dateDebut = (paramDebut != null && !paramDebut.trim().isEmpty())
                ? Date.valueOf(paramDebut.trim())
                : Date.valueOf(java.time.LocalDate.now().minusDays(6));

        dateFin = (paramFin != null && !paramFin.trim().isEmpty())
                ? Date.valueOf(paramFin.trim())
                : Date.valueOf(java.time.LocalDate.now());
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

    Vector<String> labels = DashboardSemaine.getLabelsJours(dateDebut, dateFin);
    Vector<Double> caSemaine = DashboardSemaine.getCASemaine(dateDebut, dateFin);
    Vector<Double> beneficeSemaine = DashboardSemaine.getBeneficeSemaine(dateDebut, dateFin);
    Vector<String> destLabels = DashboardSemaine.getDestinationsLabels(dateDebut, dateFin);
    Vector<Double> destValues = DashboardSemaine.getDestinationsValues(dateDebut, dateFin);

    StringBuilder json = new StringBuilder();
    json.append("{");

    json.append("\"labels\":{");
    json.append("\"semaine\":[");
    for (int i = 0; i < labels.size(); i++) {
        if (i > 0) json.append(",");
        json.append("\"").append(echapper(labels.get(i))).append("\"");
    }
    json.append("]");
    json.append("},");

    json.append("\"data\":{");
    json.append("\"caSemaine\":[");
    for (int i = 0; i < caSemaine.size(); i++) {
        if (i > 0) json.append(",");
        json.append(caSemaine.get(i));
    }
    json.append("],");
    json.append("\"beneficeSemaine\":[");
    for (int i = 0; i < beneficeSemaine.size(); i++) {
        if (i > 0) json.append(",");
        json.append(beneficeSemaine.get(i));
    }
    json.append("]");
    json.append("},");

    json.append("\"destinations\":{");
    json.append("\"labels\":[");
    for (int i = 0; i < destLabels.size(); i++) {
        if (i > 0) json.append(",");
        json.append("\"").append(echapper(destLabels.get(i))).append("\"");
    }
    json.append("],");
    json.append("\"values\":[");
    for (int i = 0; i < destValues.size(); i++) {
        if (i > 0) json.append(",");
        json.append(destValues.get(i));
    }
    json.append("]");
    json.append("}");

    json.append("}");

    out.print(json.toString());
%>