<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.sql.Types" %>
<%@ page import="tools.Database" %>
<%
    try {
        int idVehicule = Integer.parseInt(request.getParameter("id_vehicule"));
        String typeEntretien = request.getParameter("type_entretien");
        Date dateEntretien = Date.valueOf(request.getParameter("date_entretien"));
        double cout = Double.parseDouble(request.getParameter("cout"));
        int kilometrage = Integer.parseInt(request.getParameter("kilometrage"));
        
        String nextDateStr = request.getParameter("date_prochain_entretien");
        Date dateProchain = (nextDateStr != null && !nextDateStr.isEmpty()) ? Date.valueOf(nextDateStr) : null;
        
        String remarque = request.getParameter("remarque");

        String sql = "INSERT INTO entretien (id_vehicule, date_entretien, type_entretien, cout, kilometrage, date_prochain_entretien, remarque) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = Database.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idVehicule);
            ps.setDate(2, dateEntretien);
            ps.setString(3, typeEntretien);
            ps.setDouble(4, cout);
            ps.setInt(5, kilometrage);
            
            if (dateProchain != null) {
                ps.setDate(6, dateProchain);
            } else {
                ps.setNull(6, Types.DATE);
            }
            
            ps.setString(7, remarque);
            ps.executeUpdate();
        }
        
        response.sendRedirect("model.jsp?page=vehicule/entretien-vehicule&id=" + idVehicule);
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("model.jsp?page=vehicule/liste-vehicule");
    }
%>