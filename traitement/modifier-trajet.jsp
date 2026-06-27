<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="gestion.TrajetGestion, models.Trajet, models.Ville, java.math.BigDecimal" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    if (!"ADMIN".equals(role)) {
        response.sendRedirect("../pages/liste-trajet.jsp");
        return;
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String idTrajet = request.getParameter("id_trajet");
        String idDepart = request.getParameter("id_ville_depart");
        String idArrivee = request.getParameter("id_ville_arrivee");
        String distance = request.getParameter("distance_km");
        String duree = request.getParameter("duree_estimee");
        String tarif = request.getParameter("tarif_base");

        if (idTrajet != null && idDepart != null && idArrivee != null && !idDepart.equals(idArrivee) && tarif != null && !tarif.isEmpty()) {
            Trajet t = new Trajet();
            t.setIdTrajet(Integer.parseInt(idTrajet));
            
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
            if (gestion.modifierTrajet(t)) {
                response.sendRedirect("../pages/details-trajet.jsp?id=" + idTrajet);
                return;
            } else {
                response.sendRedirect("../pages/modifier-trajet.jsp?id=" + idTrajet + "&error=sql");
                return;
            }
        } else {
            response.sendRedirect("../pages/modifier-trajet.jsp?id=" + idTrajet + "&error=invalid_data");
            return;
        }
    }
    
    response.sendRedirect("../pages/liste-trajet.jsp");
%>
