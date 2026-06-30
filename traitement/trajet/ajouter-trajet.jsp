<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="gestion.TrajetGestion, models.Trajet, models.Ville, java.math.BigDecimal" %>
<%@ page import="backoffice.Utilisateur" %>
<%
    Utilisateur userObj = (Utilisateur) session.getAttribute("utilisateur");
    if (userObj == null) {
        response.sendRedirect("../../index.jsp");
        return;
    }
    boolean isAdmin = "Admin".equalsIgnoreCase(userObj.voirsiadmin());
    if (!isAdmin) {
        response.sendRedirect("../../models/model.jsp?page=trajet/gestion-trajet");
        return;
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String idDepart = request.getParameter("id_ville_depart");
        String idArrivee = request.getParameter("id_ville_arrivee");
        String distance = request.getParameter("distance_km");
        String duree = request.getParameter("duree_estimee");
        String tarif = request.getParameter("tarif_base");

        if (idDepart != null && idArrivee != null && !idDepart.equals(idArrivee) && tarif != null && !tarif.isEmpty()) {
            Trajet t = new Trajet();
            
            Ville depart = new Ville();
            depart.setIdVille(Integer.parseInt(idDepart));
            t.setVilleDepart(depart);
            
            Ville arrivee = new Ville();
            arrivee.setIdVille(Integer.parseInt(idArrivee));
            t.setVilleArrivee(arrivee);
            
            if (distance != null && !distance.isEmpty()) {
                t.setDistanceKm(new BigDecimal(distance));
            }
            
            t.setDureeEstimee(duree);
            t.setTarifBase(new BigDecimal(tarif));
            
            TrajetGestion gestion = new TrajetGestion();
            if (gestion.ajouterTrajet(t)) {
                response.sendRedirect("../../models/model.jsp?page=trajet/liste-trajet&msg=success");
                return;
            } else {
                response.sendRedirect("../../models/model.jsp?page=trajet/ajout-trajet&error=sql");
                return;
            }
        } else {
            response.sendRedirect("../../models/model.jsp?page=trajet/ajout-trajet&error=invalid_data");
            return;
        }
    }
    
    response.sendRedirect("../../models/model.jsp?page=trajet/ajout-trajet");
%>
