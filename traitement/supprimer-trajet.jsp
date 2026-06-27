<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="gestion.TrajetGestion" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    if (!"ADMIN".equals(role)) {
        response.sendRedirect("../pages/liste-trajet.jsp");
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
            response.sendRedirect("../pages/liste-trajet.jsp?msg=" + action);
        } else {
            response.sendRedirect("../pages/liste-trajet.jsp?error=sql");
        }
        return;
    }

    response.sendRedirect("../pages/liste-trajet.jsp");
%>