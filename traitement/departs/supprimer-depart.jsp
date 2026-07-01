<%@ page import="backoffice.Utilisateur, gestion.Depart" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    if (user.voirsiadmin().equals("Caissier")) {
        response.sendRedirect("../../models/model.jsp?page=departs/liste-depart");
        return;
    }

    String idParam = request.getParameter("id");
    if (idParam == null || idParam.isEmpty()) {
        response.sendRedirect("../../models/model.jsp?page=departs/liste-depart");
        return;
    }

    int id = 0;
    try { id = Integer.parseInt(idParam); } catch (Exception e) {}
    if (id == 0) {
        response.sendRedirect("../../models/model.jsp?page=departs/liste-depart");
        return;
    }

    Depart d = Depart.getById(id);
    if (d == null) {
        response.sendRedirect("../../models/model.jsp?page=departs/liste-depart&msg=not_found");
        return;
    }

    if (!Depart.supprimer(id)) {
        response.sendRedirect("../../models/model.jsp?page=departs/liste-depart&msg=not_found");
        return;
    }

    response.sendRedirect("../../models/model.jsp?page=departs/liste-depart&msg=supp_ok");
%>
