<%@ page import="gestion.*, java.sql.Date" %>

<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            int idVehicule = Integer.parseInt(request.getParameter("id_vehicule"));
            String nouvelEtat = request.getParameter("etat");
            Date nouvelleDate = Date.valueOf(request.getParameter("dateAssurance"));

            boolean modifie = Vehicule.modifierEtatEtAssurance(idVehicule, nouvelEtat, nouvelleDate);

            if (modifie) {
                response.sendRedirect("../../models/model.jsp?page=vehicule/liste-vehicule&success=modification");
                return;
            } else {
                out.print("<script>alert('Erreur lors de la mise à jour.');</script>");
            }
        } catch(Exception e) {
            out.print("<script>alert('Erreur : " + e.getMessage() + "');</script>");
        }
    }
%>