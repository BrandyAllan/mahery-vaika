<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="backoffice.Utilisateur" %>
<%@ page import="gestion.Chauffeur" %>
<%@ page import="java.sql.Date" %>
<%
    Utilisateur userObj = (Utilisateur) session.getAttribute("utilisateur");
    if (userObj == null) {
        response.sendRedirect("../../index.jsp");
        return;
    }
    if (!"Admin".equalsIgnoreCase(userObj.voirsiadmin())) {
        response.sendRedirect("../../models/model.jsp?page=chauffeurs/liste-chauffeur");
        return;
    }

    String actifParam = request.getParameter("actif");
    String idParam = request.getParameter("id");

    if (actifParam != null && idParam != null) {
        try {
            int id = Integer.parseInt(idParam);
            boolean actif = Boolean.parseBoolean(actifParam);
            Chauffeur.basculerActif(id, actif);
            session.setAttribute("succes", actif ? "Chauffeur réactivé avec succès." : "Chauffeur désactivé avec succès.");
            response.sendRedirect("../../models/model.jsp?page=chauffeurs/liste-chauffeur");
            return;
        } catch (Exception e) {
            session.setAttribute("erreur", "Erreur lors du changement de statut : " + e.getMessage());
            response.sendRedirect("../../models/model.jsp?page=chauffeurs/liste-chauffeur");
            return;
        }
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String idStr        = request.getParameter("id");
        String nom          = request.getParameter("nom");
        String prenom       = request.getParameter("prenom");
        String telephone    = request.getParameter("telephone");
        String numeroPermis = request.getParameter("numeroPermis");
        String datePermStr  = request.getParameter("dateExpirationPermis");
        String vehiculeStr  = request.getParameter("idVehiculeHabituel");

        if (idStr == null || nom == null || nom.trim().isEmpty() || numeroPermis == null || numeroPermis.trim().isEmpty()) {
            session.setAttribute("erreur", "Le nom et le numéro de permis sont obligatoires.");
            response.sendRedirect("../../models/model.jsp?page=chauffeurs/modifier-chauffeur&id=" + idStr);
            return;
        }

        try {
            Chauffeur c = Chauffeur.getById(Integer.parseInt(idStr));
            if (c == null) {
                response.sendRedirect("../../models/model.jsp?page=chauffeurs/liste-chauffeur");
                return;
            }

            c.setNom(nom.trim());
            c.setPrenom(prenom != null ? prenom.trim() : null);
            c.setTelephone(telephone != null ? telephone.trim() : null);
            c.setNumeroPermis(numeroPermis.trim());
            if (datePermStr != null && !datePermStr.isEmpty()) {
                c.setDateExpirationPermis(Date.valueOf(datePermStr));
            } else {
                c.setDateExpirationPermis(null);
            }
            if (vehiculeStr != null && !vehiculeStr.isEmpty()) {
                c.setIdVehiculeHabituel(Integer.parseInt(vehiculeStr));
            } else {
                c.setIdVehiculeHabituel(0);
            }

            Chauffeur.modifier(c);
            session.setAttribute("succes", "Chauffeur modifié avec succès.");
            response.sendRedirect("../../models/model.jsp?page=chauffeurs/details-chauffeur&id=" + idStr);
            return;
        } catch (Exception e) {
            session.setAttribute("erreur", "Erreur lors de la modification : " + e.getMessage());
            response.sendRedirect("../../models/model.jsp?page=chauffeurs/modifier-chauffeur&id=" + idStr);
            return;
        }
    }

    response.sendRedirect("../../models/model.jsp?page=chauffeurs/liste-chauffeur");
%>
