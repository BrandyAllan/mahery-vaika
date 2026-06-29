<%-- Ajoute ce bloc juste après la vérification de session initiale si tu regroupes le traitement --%>
<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            int idVehicule = Integer.parseInt(request.getParameter("id_vehicule"));
            String nouvelEtat = request.getParameter("etat");
            Date nouvelleDate = Date.valueOf(request.getParameter("dateAssurance"));

            boolean modifie = Vehicule.modifierEtatEtAssurance(idVehicule, nouvelEtat, nouvelleDate);

            if (modifie) {
                response.sendRedirect("liste-vehicule.jsp?success=modification");
                return;
            } else {
                out.print("<script>alert('Erreur lors de la mise à jour.');</script>");
            }
        } catch(Exception e) {
            out.print("<script>alert('Erreur : " + e.getMessage() + "');</script>");
        }
    }
%>