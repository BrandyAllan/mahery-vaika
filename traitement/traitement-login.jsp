<%@ page import="backoffice.Utilisateur" %>
<%
    String identifiant = request.getParameter("identifiant");
    String motDePasse = request.getParameter("mot_de_passe");

    if (identifiant == null || motDePasse == null || identifiant.trim().isEmpty() || motDePasse.trim().isEmpty()) {
        response.sendRedirect("../index.jsp?erreur=1");
        return;
    }

    Utilisateur utilisateur = Utilisateur.authentifier(identifiant.trim(), motDePasse.trim());

    if (utilisateur != null) {
        session.setAttribute("utilisateur", utilisateur);
        response.sendRedirect("../models/model.jsp");
    } else {
        response.sendRedirect("../index.jsp?erreur=1");
    }
%>