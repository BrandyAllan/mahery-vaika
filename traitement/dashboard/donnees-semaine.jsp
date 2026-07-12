<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dashboard.DashboardSemaine" %>
<%@ page import="backoffice.Utilisateur" %>
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

    Vector<String> labels = DashboardSemaine.getLabelsSemaines();
    Vector<Double> caSemaine = DashboardSemaine.getCASemaines();
    Vector<Double> beneficeSemaine = DashboardSemaine.getBeneficeSemaines();
    Vector<String> destLabels = DashboardSemaine.getDestinationsLabels();
    Vector<Double> destValues = DashboardSemaine.getDestinationsValues();

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