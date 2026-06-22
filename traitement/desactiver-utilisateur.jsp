<%@ page import="backoffice.Utilisateur, java.sql.Date" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null || !user.voirsiadmin().equals("Admin")) {
        response.sendRedirect("../pages/gestion-utilisateur.jsp");
        return;
    }

    int id = Integer.parseInt(request.getParameter("id"));
    boolean actif = Boolean.parseBoolean(request.getParameter("actif"));

    Utilisateur u = Utilisateur.getById(id);
    if (u == null) {
        response.sendRedirect("../pages/liste-utilisateur.jsp?error=notfound");
        return;
    }

    u.setActif(actif);
    if (!actif) {
        u.setDate_retrait(new Date(System.currentTimeMillis()));
    } else {
        u.setDate_retrait(null);
    }

    Utilisateur.mettreAjour(u);
    response.sendRedirect("../pages/liste-utilisateur.jsp?success=desact");
%>