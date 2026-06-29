<%@ page import="backoffice.Utilisateur, backoffice.Depart" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    if (user.voirsiadmin().equals("Caissier")) {
        response.sendRedirect("../pages/liste-depart.jsp");
        return;
    }

    String idParam = request.getParameter("id");
    if (idParam == null || idParam.isEmpty()) {
        response.sendRedirect("../pages/liste-depart.jsp");
        return;
    }

    int id = 0;
    try { id = Integer.parseInt(idParam); } catch (Exception e) {}
    if (id == 0) {
        response.sendRedirect("../pages/liste-depart.jsp");
        return;
    }

    Depart d = Depart.getById(id);
    if (d == null) {
        response.sendRedirect("../pages/liste-depart.jsp?msg=not_found");
        return;
    }

    Depart.supprimer(id);

    response.sendRedirect("../pages/liste-depart.jsp?msg=supp_ok");
%>
