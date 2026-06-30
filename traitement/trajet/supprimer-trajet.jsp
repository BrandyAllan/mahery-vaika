<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="gestion.TrajetGestion" %>
<%@ page import="backoffice.Utilisateur" %>
<%
    Utilisateur userObj = (Utilisateur) session.getAttribute("utilisateur");
    if (userObj == null) {
        response.sendRedirect("../../index.jsp");
        return;
    }
    boolean isAdmin = "Admin".equalsIgnoreCase(userObj.voirsiadmin());
    if (!isAdmin) {
        response.sendRedirect("../../models/model.jsp?page=trajet/liste-trajet");
        return;
    }

    String idTrajet = request.getParameter("id");
    String action   = request.getParameter("action");

    if (idTrajet != null && !idTrajet.isEmpty()) {
        TrajetGestion gestion = new TrajetGestion();
        boolean success = false;

        if ("supprimer".equals(action)) {
            success = gestion.supprimerTrajet(Integer.parseInt(idTrajet));
        } else if ("desactiver".equals(action)) {
            success = gestion.desactiverTrajet(Integer.parseInt(idTrajet));
        }

        if (success) {
            response.sendRedirect("../../models/model.jsp?page=trajet/liste-trajet&msg=" + action);
        } else {
            response.sendRedirect("../../models/model.jsp?page=trajet/liste-trajet&error=sql");
        }
        return;
    }

    response.sendRedirect("../../models/model.jsp?page=trajet/liste-trajet");
%>