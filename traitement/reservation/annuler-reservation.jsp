<%@ page import="backoffice.Reservation, backoffice.Utilisateur" %>
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
        response.sendRedirect("../../models/model.jsp?page=reservation/liste-reservation.jsp?error=invalid");
        return;
    }
    Reservation r = Reservation.getById(id);
    if (r == null) {
        response.sendRedirect("../../models/model.jsp?page=reservation/liste-reservation.jsp?error=notfound");
        return;
    }

    // Verifier les droits : admin ou proprietaire de la reservation
    boolean isAdmin = user.voirsiadmin().equals("Admin");
    if (!isAdmin && r.getId_caissier() != user.getId_utilisateur()) {
        response.sendRedirect("../../models/model.jsp?page=reservation/liste-reservation.jsp?error=droits");
        return;
    }

    // Verifier que la reservation est toujours confirmee
    if (!r.getStatut().equals("CONFIRMEE")) {
        response.sendRedirect("../../models/model.jsp?page=reservation/details-reservation.jsp?id=" + id + "&error=deja_annulee");
        return;
    }

    String motif = request.getParameter("motif");
    if (motif == null || motif.trim().isEmpty()) {
        motif = "Annulation par " + user.getNom() + " " + user.getPrenom();
    }

    try {
        Reservation.annuler(id, motif.trim());
        response.sendRedirect("../../models/model.jsp?page=reservation/liste-reservation.jsp?success=annul");
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("../../models/model.jsp?page=reservation/details-reservation.jsp?id=" + id + "&erreur=db");
    }
%>
