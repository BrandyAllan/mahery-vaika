<%@ page import="backoffice.Depense, backoffice.Utilisateur, java.sql.Date" %>

<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");

    if (user == null) {
        response.sendRedirect("../../index.jsp");
        return;
    }

    String role = user.voirsiadmin();

    if (!role.equals("Admin") && !role.equals("Superviseur")) {
        response.sendRedirect("../../pages/depense/depense.jsp");
        return;
    }

    String type_depense = request.getParameter("type_depense");
    String description = request.getParameter("description");
    String montantStr = request.getParameter("montant");
    String date_depense = request.getParameter("date_depense");
    String idVehiculeStr = request.getParameter("id_vehicule");
    String idUtilisateurStr = request.getParameter("id_utilisateur");

    
    double montant = 0;

    try {
        montant = Double.parseDouble(montantStr);
    } catch (NumberFormatException e) {
        response.sendRedirect("../../pages/depense/ajout-depense.jsp?erreur=montant");
        return;
    }

    if (montant < 0) {
        response.sendRedirect("../../pages/depense/ajout-depense.jsp?erreur=negatif");
        return;
    }

    Depense d = new Depense();
    d.setType_depense(type_depense);
    d.setDescription(description);
    d.setMontant(montant);
    d.setDate_depense(Date.valueOf(date_depense));

    if (idVehiculeStr != null && !idVehiculeStr.isEmpty()) {
        d.setId_vehicule(Integer.parseInt(idVehiculeStr));
    }

    if (idUtilisateurStr != null && !idUtilisateurStr.isEmpty()) {
        d.setId_utilisateur(Integer.parseInt(idUtilisateurStr));
    }

    Depense.ajouter(d);
    response.sendRedirect("../../pages/depense/depense.jsp?success=ajout");
%>