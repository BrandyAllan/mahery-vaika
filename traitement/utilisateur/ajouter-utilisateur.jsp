<%@ page import="backoffice.Utilisateur, java.sql.Date" %>

<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");

    if (user == null || !user.voirsiadmin().equals("Admin")) {
        response.sendRedirect("../../models/model.jsp?page=utilisateur/gestion-utilisateur");
        return;
    }

    String nom = request.getParameter("nom");
    String prenom = request.getParameter("prenom");
    String telephone = request.getParameter("telephone");
    String email = request.getParameter("email");
    String identifiant = request.getParameter("identifiant");
    String mot_de_passe = request.getParameter("mot_de_passe");
    int role = Integer.parseInt(request.getParameter("role"));
    Date date_embauche = Date.valueOf(request.getParameter("date_embauche"));

    if (Utilisateur.emailExiste(email, 0)) {
        response.sendRedirect("../../models/model.jsp?page=utilisateur/ajout-utilisateur&erreur=email");
        return;
    }

    String telComplet = null;

    if (telephone != null && !telephone.trim().isEmpty()) {
        telComplet = "+261" + telephone.trim();
    }

    Utilisateur u = new Utilisateur();
    u.setNom(nom);
    u.setPrenom(prenom);
    u.setTelephone(telComplet);
    u.setEmail(email);
    u.setIdentifiant(identifiant);
    u.setMot_de_passe(mot_de_passe);
    u.setId_role(role);
    u.setDate_embauche(date_embauche);
    u.setDate_retrait(null);
    u.setActif(true);

    Utilisateur.ajouter(u);
    response.sendRedirect("../../models/model.jsp?page=utilisateur/liste-utilisateur&success=ajout");
%>