<%@ page import="backoffice.Reservation, backoffice.Utilisateur, java.util.Vector" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) {
        response.sendRedirect("../index.jsp");
        return;
    }

    int id = 0;
    try {
        id = Integer.parseInt(request.getParameter("id"));
    } catch (Exception e) {
        response.sendRedirect("../../models/model.jsp?page=reservation?liste-reservation&error=invalid");
        return;
    }

    Reservation r = Reservation.getById(id);
    if (r == null) {
        response.sendRedirect("../../models/model.jsp?page=reservation/liste-reservation&error=notfound");
        return;
    }

    boolean isAdmin = user.voirsiadmin().equals("Admin");
    if (!isAdmin && r.getId_caissier() != user.getId_utilisateur()) {
        response.sendRedirect("../../models/model.jsp?page=reservation/liste-reservation&error=droits");
        return;
    }

    if (!"CONFIRMEE".equals(r.getStatut())) {
        response.sendRedirect("../../models/model.jsp?page=reservation/details-reservation&id=" + id + "&error=statut");
        return;
    }

    String nomPassager = request.getParameter("nomPassager");
    String prenomPassager = request.getParameter("prenomPassager");
    String telephonePassager = request.getParameter("telephonePassager");
    String numeroSiegeStr = request.getParameter("numeroSiege");
    String idDepartStr = request.getParameter("idDepart");

    if (nomPassager == null || nomPassager.trim().isEmpty()) {
        response.sendRedirect("../../models/model.jsp?page=reservation/details-reservation&id=" + id + "&error=nom");
        return;
    }

    int numeroSiege = 0;
    int idDepart = 0;
    try {
        numeroSiege = Integer.parseInt(numeroSiegeStr);
        idDepart = Integer.parseInt(idDepartStr);
    } catch (Exception e) {
        response.sendRedirect("../../models/model.jsp?page=reservation/details-reservation&id=" + id + "&error=params");
        return;
    }

    Vector<Integer> siegesReserves = Reservation.getSiegesReserves(idDepart);
    siegesReserves.removeElement(r.getNumero_siege());
    if (siegesReserves.contains(numeroSiege)) {
        response.sendRedirect("../../models/model.jsp?page=reservation/details-reservation&id=" + id + "&error=siege");
        return;
    }

    String telComplet = null;
    if (telephonePassager != null && !telephonePassager.trim().isEmpty()) {
        telComplet = "+261" + telephonePassager.trim();
    }

    r.setNom_passager(nomPassager);
    r.setPrenom_passager(prenomPassager);
    r.setTelephone_passager(telComplet);
    r.setNumero_siege(numeroSiege);
    r.setId_depart(idDepart);

    try {
        Reservation.mettreAjour(r);
        response.sendRedirect("../../models/model.jsp?page=reservation/details-reservation&id=" + id + "&success=modif");
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("../../models/model.jsp?page=reservation/details-reservation&id=" + id + "&error=db");
    }
%>
