<%@ page import="backoffice.Utilisateur, gestion.Depart, java.sql.Date, java.sql.Time" %>
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

    int    idDepart    = Integer.parseInt(request.getParameter("id_depart"));
    int    idTrajet    = Integer.parseInt(request.getParameter("id_trajet"));
    int    idVehicule  = Integer.parseInt(request.getParameter("id_vehicule"));
    int    idChauffeur = Integer.parseInt(request.getParameter("id_chauffeur"));
    Date   dateDepart  = Date.valueOf(request.getParameter("date_depart"));
    Time   heureDepart = Time.valueOf(request.getParameter("heure_depart") + ":00");
    String statut      = request.getParameter("statut");

    if (Depart.vehiculeDejaOccupe(idVehicule, dateDepart, heureDepart, idDepart)) {
        response.sendRedirect("../../models/model.jsp?page=departs/modifier-depart&id=" + idDepart + "&erreur=vehicule");
        return;
    }

    if (Depart.chauffeurDejaOccupe(idChauffeur, dateDepart, heureDepart, idDepart)) {
        response.sendRedirect("../pages/modifier-depart.jsp?id=" + idDepart + "&erreur=chauffeur");
        return;
    }

    Depart d = new Depart();
    d.setId_depart(idDepart);
    d.setId_trajet(idTrajet);
    d.setId_vehicule(idVehicule);
    d.setId_chauffeur(idChauffeur);
    d.setDate_depart(dateDepart);
    d.setHeure_depart(heureDepart);
    d.setStatut(statut);

    Depart.mettreAjour(d);

    response.sendRedirect("../../models/model.jsp?page=departs/liste-depart&msg=modif_ok");
%>
