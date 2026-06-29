<%@ page import="backoffice.Utilisateur, backoffice.Depart, java.sql.Date, java.sql.Time" %>
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

    int    idTrajet    = Integer.parseInt(request.getParameter("id_trajet"));
    int    idVehicule  = Integer.parseInt(request.getParameter("id_vehicule"));
    int    idChauffeur = Integer.parseInt(request.getParameter("id_chauffeur"));
    Date   dateDepart  = Date.valueOf(request.getParameter("date_depart"));
    Time   heureDepart = Time.valueOf(request.getParameter("heure_depart") + ":00");
    String statut      = request.getParameter("statut");

    if (Depart.vehiculeDejaOccupe(idVehicule, dateDepart, heureDepart, 0)) {
        response.sendRedirect("../pages/ajout-depart.jsp?erreur=vehicule");
        return;
    }

    if (Depart.chauffeurDejaOccupe(idChauffeur, dateDepart, heureDepart, 0)) {
        response.sendRedirect("../pages/ajout-depart.jsp?erreur=chauffeur");
        return;
    }

    Depart d = new Depart();
    d.setId_trajet(idTrajet);
    d.setId_vehicule(idVehicule);
    d.setId_chauffeur(idChauffeur);
    d.setDate_depart(dateDepart);
    d.setHeure_depart(heureDepart);
    d.setStatut(statut != null && !statut.isEmpty() ? statut : "PLANIFIE");

    Depart.ajouter(d);

    response.sendRedirect("../pages/liste-depart.jsp?msg=ajout_ok");
%>
