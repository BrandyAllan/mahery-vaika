<%@ page import="backoffice.Reservation, backoffice.Paiement, backoffice.Utilisateur, java.sql.Date, java.util.Vector" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) {
        response.sendRedirect("../../index.jsp");
        return;
    }

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

    String nomPassager = request.getParameter("nomPassager");
    String prenomPassager = request.getParameter("prenomPassager");
    String telephonePassager = request.getParameter("telephonePassager");
    String siegesStr = request.getParameter("sieges");
    String modePaiement = request.getParameter("modePaiement");
    String montantStr = request.getParameter("montant");

    int idDepart;
    try {
        idDepart = Integer.parseInt(request.getParameter("idDepart"));
    } catch (Exception e) {
        response.sendRedirect("../../models/model.jsp?page=reservation/ajout-reservation&erreur=params");
        return;
    }

    if (nomPassager == null || nomPassager.trim().isEmpty()) {
        response.sendRedirect("../../models/model.jsp?page=reservation/ajout-reservation&erreur=nom");
        return;
    }

    Vector<Integer> siegesChoisis = new Vector<>();
    if (siegesStr != null && !siegesStr.trim().isEmpty()) {
        for (String s : siegesStr.split(",")) {
            try {
                if (!s.trim().isEmpty()) {
                    siegesChoisis.add(Integer.parseInt(s.trim()));
                }
            } catch (Exception e) {
            }
        }
    }

    if (siegesChoisis.isEmpty()) {
        response.sendRedirect("../../models/model.jsp?page=reservation/ajout-reservation&erreur=sieges");
        return;
    }

    Reservation departInfo = null;
    Vector<Integer> siegesDejaReserves;
    try {
        for (Reservation d : Reservation.getAllDeparts()) {
            if (d.getId_depart() == idDepart) {
                departInfo = d;
                break;
            }
        }

        siegesDejaReserves = Reservation.getSiegesReserves(idDepart);
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("../../models/model.jsp?page=reservation/ajout-reservation&erreur=db");
        return;
    }

    if (departInfo == null) {
        response.sendRedirect("../../models/model.jsp?page=reservation/ajout-reservation&erreur=depart");
        return;
    }

    for (Integer numSiege : siegesChoisis) {
        if (siegesDejaReserves.contains(numSiege)) {
            response.sendRedirect("../../models/model.jsp?page=reservation/ajout-reservation&erreur=siege_pris");
            return;
        }
    }

    String telComplet = null;
    if (telephonePassager != null && !telephonePassager.trim().isEmpty()) {
        telComplet = "+261" + telephonePassager.trim();
    }

    double montantTotal;
    try {
        montantTotal = Double.parseDouble(montantStr);
    } catch (Exception e) {
        montantTotal = departInfo.getTarif_base() * siegesChoisis.size();
    }
    if (montantTotal < 0) {
        montantTotal = departInfo.getTarif_base() * siegesChoisis.size();
    }

    if (modePaiement == null || modePaiement.trim().isEmpty()) {
        modePaiement = "Especes";
    }

    int nbSieges = siegesChoisis.size();
    double montantParSiege = Math.round((montantTotal / nbSieges) * 100.0) / 100.0;

    Vector<Integer> idsReservationCreees = new Vector<>();

    try {
        double montantCumule = 0;
        for (int i = 0; i < nbSieges; i++) {
            int numeroSiege = siegesChoisis.get(i);

            String numeroReservation = Reservation.genererNumeroReservation();

            Reservation r = new Reservation();
            r.setNumero_reservation(numeroReservation);
            r.setId_depart(idDepart);
            r.setNom_passager(nomPassager);
            r.setPrenom_passager(prenomPassager);
            r.setTelephone_passager(telComplet);
            r.setNumero_siege(numeroSiege);
            r.setStatut("CONFIRMEE");
            r.setId_caissier(user.getId_utilisateur());

            int idReservation = Reservation.ajouter(r);
            idsReservationCreees.add(idReservation);

            double montantCeSiege;
            if (i == nbSieges - 1) {
                montantCeSiege = Math.round((montantTotal - montantCumule) * 100.0) / 100.0;
            } else {
                montantCeSiege = montantParSiege;
                montantCumule += montantCeSiege;
            }

            Paiement p = new Paiement();
            p.setId_reservation(idReservation);
            p.setMontant(montantCeSiege);
            p.setMode_paiement(modePaiement);
            p.setStatut("PAYE");
            Paiement.ajouter(p);
        }

        StringBuilder idsCsv = new StringBuilder();
        for (int i = 0; i < idsReservationCreees.size(); i++) {
            if (i > 0) idsCsv.append(",");
            idsCsv.append(idsReservationCreees.get(i));
        }

        response.sendRedirect("../../models/model.jsp?page=reservation/facture&ids=" + idsCsv);
    } catch (Exception e) {
        e.printStackTrace();
        String msgDebug = java.net.URLEncoder.encode(e.getClass().getSimpleName() + " : " + e.getMessage(), "UTF-8");
        response.sendRedirect("../../models/model.jsp?page=reservation/ajout-reservation&erreur=db&debug=" + msgDebug);
    }
%>
