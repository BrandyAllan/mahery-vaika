<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="gestion.Vehicule" %>
<%@ page import="backoffice.Utilisateur" %>
<%@ page import="java.sql.Date" %>
<%
    Utilisateur userObj = (Utilisateur) session.getAttribute("utilisateur");
    
    if (userObj == null || !"Admin".equalsIgnoreCase(userObj.voirsiadmin())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return; 
    }

    try {
        String immatriculation = request.getParameter("immatriculation");
        String marque = request.getParameter("marque");
        String modele = request.getParameter("modele"); 
        int capacite = Integer.parseInt(request.getParameter("capacite"));
        int kilometrage = Integer.parseInt(request.getParameter("kilometrage"));
        Date dateAssurance = Date.valueOf(request.getParameter("dateAssurance"));

        boolean insere = Vehicule.ajouterVehicule(immatriculation, marque, modele, capacite, kilometrage, dateAssurance);

        if (insere) {
            response.sendRedirect(request.getContextPath() + "/pages/liste-vehicule.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/pages/ajout-vehicule.jsp?erreur=echec_insertion");
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect(request.getContextPath() + "/pages/ajout-vehicule.jsp?erreur=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
    }
%>
