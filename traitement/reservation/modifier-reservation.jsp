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
        response.sendRedirect("../pages/liste-reservation.jsp?error=invalid");
        return;
    }

    Reservation r = Reservation.getById(id);
    if (r == null) {
        response.sendRedirect("../pages/liste-reservation.jsp?error=notfound");
        return;
    }

    // Verifier les droits : admin ou proprietaire de la reservation
    boolean isAdmin = user.voirsiadmin().equals("Admin");
    if (!isAdmin && r.getId_caissier() != user.getId_utilisateur()) {
        response.sendRedirect("../pages/liste-reservation.jsp?error=droits");
        return;
    }

    // Verifier que la reservation est toujours confirmee
    if (!"CONFIRMEE".equals(r.getStatut())) {
        response.sendRedirect("../pages/details-reservation.jsp?id=" + id + "&error=statut");
        return;
    }

    String nomPassager = request.getParameter("nomPassager");
    String prenomPassager = request.getParameter("prenomPassager");
    String telephonePassager = request.getParameter("telephonePassager");
    String numeroSiegeStr = request.getParameter("numeroSiege");
    String idDepartStr = request.getParameter("idDepart");

    if (nomPassager == null || nomPassager.trim().isEmpty()) {
        response.sendRedirect("../pages/details-reservation.jsp?id=" + id + "&erreur=nom");
        return;
    }

    int numeroSiege = 0;
    int idDepart = 0;
    try {
        numeroSiege = Integer.parseInt(numeroSiegeStr);
        idDepart = Integer.parseInt(idDepartStr);
    } catch (Exception e) {
        response.sendRedirect("../pages/details-reservation.jsp?id=" + id + "&erreur=params");
        return;
    }

    // Verifier que le siege n'est pas deja reserve par une autre reservation
    Vector<Integer> siegesReserves = Reservation.getSiegesReserves(idDepart);
    // Enlever le siege actuel de la liste des reserves (car c'est la meme reservation)
    siegesReserves.removeElement(r.getNumero_siege());
    if (siegesReserves.contains(numeroSiege)) {
        response.sendRedirect("../pages/details-reservation.jsp?id=" + id + "&erreur=siege");
        return;
    }

    // Formater le telephone
    String telComplet = null;
    if (telephonePassager != null && !telephonePassager.trim().isEmpty()) {
        telComplet = "+261" + telephonePassager.trim();
    }

    // Mettre a jour la reservation
    r.setNom_passager(nomPassager);
    r.setPrenom_passager(prenomPassager);
    r.setTelephone_passager(telComplet);
    r.setNumero_siege(numeroSiege);
    r.setId_depart(idDepart);

    try {
        Reservation.mettreAjour(r);
        response.sendRedirect("../pages/details-reservation.jsp?id=" + id + "&success=modif");
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("../pages/details-reservation.jsp?id=" + id + "&erreur=db");
    }
%>
