<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="backoffice.Utilisateur" %>
<%@ page import="gestion.Chauffeur" %>
<%@ page import="java.sql.Date" %>
<%
    Utilisateur userObj = (Utilisateur) session.getAttribute("utilisateur");
    if (userObj == null) { response.sendRedirect("../../../index.jsp"); return; }
    if (!"Admin".equalsIgnoreCase(userObj.voirsiadmin())) { response.sendRedirect("../gestion-chauffeur.jsp"); return; }

    String nom          = request.getParameter("nom");
    String prenom       = request.getParameter("prenom");
    String telephone    = request.getParameter("telephone");
    String numeroPermis = request.getParameter("numeroPermis");
    String datePermStr  = request.getParameter("dateExpirationPermis");
    String vehiculeStr  = request.getParameter("idVehiculeHabituel");

    if (nom == null || nom.trim().isEmpty() || numeroPermis == null || numeroPermis.trim().isEmpty()) {
        session.setAttribute("erreur", "Le nom et le numero de permis sont obligatoires.");
        response.sendRedirect("../ajout-chauffeur.jsp");
        return;
    }

    try {
        Chauffeur c = new Chauffeur();
        c.setNom(nom.trim());
        c.setPrenom(prenom != null ? prenom.trim() : null);
        c.setTelephone(telephone != null ? telephone.trim() : null);
        c.setNumeroPermis(numeroPermis.trim());
        if (datePermStr != null && !datePermStr.isEmpty()) c.setDateExpirationPermis(Date.valueOf(datePermStr));
        if (vehiculeStr != null && !vehiculeStr.isEmpty()) c.setIdVehiculeHabituel(Integer.parseInt(vehiculeStr));
        c.setActif(true);

        Chauffeur.ajouter(c);
        session.setAttribute("succes", "Chauffeur ajoute avec succes.");
        response.sendRedirect("../liste-chauffeur.jsp");
    } catch (Exception e) {
        session.setAttribute("erreur", "Erreur lors de l'ajout : " + e.getMessage());
        response.sendRedirect("../ajout-chauffeur.jsp");
    }
%>