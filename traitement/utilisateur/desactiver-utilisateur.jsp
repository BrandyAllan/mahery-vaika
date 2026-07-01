<%@ page import="backoffice.Utilisateur, java.sql.Date" %>

<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");

    if (user == null || !user.voirsiadmin().equals("Admin")) {
        response.sendRedirect("../../models/model.jsp?page=utilisateur/gestion-utilisateur");
        return;
    }

    int id = Integer.parseInt(request.getParameter("id"));
    boolean actif = Boolean.parseBoolean(request.getParameter("actif"));

    Utilisateur u = Utilisateur.getById(id);

    if (u == null) {
        response.sendRedirect("../../models/model.jsp?page=utilisateur/liste-utilisateur&error=notfound");
        return;
    }

    u.setActif(actif);

    if (!actif) {
        u.setDate_retrait(new Date(System.currentTimeMillis()));
    } else {
        u.setDate_retrait(null);
    }

    Utilisateur.mettreAjour(u);
    response.sendRedirect("../../models/model.jsp?page=utilisateur/liste-utilisateur&success=desact");
%>