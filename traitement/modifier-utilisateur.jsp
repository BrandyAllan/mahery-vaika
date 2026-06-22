<%@ page import="backoffice.Utilisateur, java.sql.Date" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null || !user.voirsiadmin().equals("Admin")) {
        response.sendRedirect("../pages/gestion-utilisateur.jsp");
        return;
    }

    int id = Integer.parseInt(request.getParameter("id"));
    String nom = request.getParameter("nom");
    String prenom = request.getParameter("prenom");
    String telephone = request.getParameter("telephone");
    String email = request.getParameter("email");
    String identifiant = request.getParameter("identifiant");
    String mot_de_passe = request.getParameter("mot_de_passe");
    int role = Integer.parseInt(request.getParameter("role"));
    Date date_embauche = Date.valueOf(request.getParameter("date_embauche"));
    String dateRetraitStr = request.getParameter("date_retrait");
    Date date_retrait = (dateRetraitStr != null && !dateRetraitStr.isEmpty()) ? Date.valueOf(dateRetraitStr) : null;
    boolean actif = Boolean.parseBoolean(request.getParameter("actif"));

    Utilisateur u = Utilisateur.getById(id);
    if (u == null) {
        response.sendRedirect("../pages/liste-utilisateur.jsp?error=notfound");
        return;
    }

    if (Utilisateur.emailExiste(email, id)) {
        response.sendRedirect("../pages/modifier-utilisateur.jsp?id="+id+"&erreur=email");
        return;
    }

    u.setNom(nom);
    u.setPrenom(prenom);
    if (telephone != null && !telephone.trim().isEmpty()) {
        u.setTelephone("+261" + telephone.trim());
    } else {
        u.setTelephone(null);
    }
    u.setEmail(email);
    u.setIdentifiant(identifiant);
    if (mot_de_passe != null && !mot_de_passe.trim().isEmpty()) {
        u.setMot_de_passe(mot_de_passe);
    }
    u.setId_role(role);
    u.setDate_embauche(date_embauche);
    u.setDate_retrait(date_retrait);
    u.setActif(actif);

    Utilisateur.mettreAjour(u);
    response.sendRedirect("../pages/liste-utilisateur.jsp?success=modif");
%>