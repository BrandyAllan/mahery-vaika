<%@ page import="backoffice.Reservation, backoffice.Utilisateur, java.sql.Date, java.util.Vector" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) {
        response.sendRedirect("../index.jsp");
        return;
    }

    // Requete AJAX pour recuperer les sieges disponibles
    String action = request.getParameter("action");
    if ("sieges".equals(action)) {
        String idDepartStr = request.getParameter("idDepart");
        int idDepart = 0;
        int capacite = 0;
        java.util.Vector<Integer> siegesReserves = new java.util.Vector<>();
        
        try {
            if (idDepartStr != null && !idDepartStr.isEmpty()) {
                idDepart = Integer.parseInt(idDepartStr);
                siegesReserves = Reservation.getSiegesReserves(idDepart);
                capacite = Reservation.getCapaciteVehicule(idDepart);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        out.print("{");
        out.print("\"capacite\": " + (capacite > 0 ? capacite : 0) + ",");
        out.print("\"siegesReserves\": [");
        for (int i = 0; i < siegesReserves.size(); i++) {
            if (i > 0) out.print(",");
            out.print(siegesReserves.get(i));
        }
        out.print("]");
        out.print("}");
        return;
    }

    // Traitement du formulaire d'ajout
    String nomPassager = request.getParameter("nomPassager");
    String prenomPassager = request.getParameter("prenomPassager");
    String telephonePassager = request.getParameter("telephonePassager");

    int idDepart;
    int numeroSiege;
    try {
        idDepart = Integer.parseInt(request.getParameter("idDepart"));
        numeroSiege = Integer.parseInt(request.getParameter("numeroSiege"));
    } catch (Exception e) {
        response.sendRedirect("../pages/ajout-reservation.jsp?erreur=params");
        return;
    }

    if (nomPassager == null || nomPassager.trim().isEmpty()) {
        response.sendRedirect("../pages/ajout-reservation.jsp?erreur=nom");
        return;
    }

    // Verifier que le depart existe et est planifie
    Reservation departInfo = null;
    for (Reservation d : Reservation.getAllDeparts()) {
        if (d.getId_depart() == idDepart) {
            departInfo = d;
            break;
        }
    }
    if (departInfo == null) {
        response.sendRedirect("../pages/ajout-reservation.jsp?erreur=depart");
        return;
    }

    // Verifier que le siege n'est pas deja reserve
    Vector<Integer> siegesReserves = Reservation.getSiegesReserves(idDepart);
    if (siegesReserves.contains(numeroSiege)) {
        response.sendRedirect("../pages/ajout-reservation.jsp?erreur=siege");
        return;
    }

    // Formater le telephone avec +261 si present
    String telComplet = null;
    if (telephonePassager != null && !telephonePassager.trim().isEmpty()) {
        telComplet = "+261" + telephonePassager.trim();
    }

    // Generer le numero de reservation
    String numeroReservation = Reservation.genererNumeroReservation();

    // Creer la reservation
    Reservation r = new Reservation();
    r.setNumero_reservation(numeroReservation);
    r.setId_depart(idDepart);
    r.setNom_passager(nomPassager);
    r.setPrenom_passager(prenomPassager);
    r.setTelephone_passager(telComplet);
    r.setNumero_siege(numeroSiege);
    r.setStatut("CONFIRMEE");
    r.setId_caissier(user.getId_utilisateur());

    try {
        Reservation.ajouter(r);
        response.sendRedirect("../pages/liste-reservation.jsp?success=ajout");
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("../pages/ajout-reservation.jsp?erreur=db");
    }
%>
