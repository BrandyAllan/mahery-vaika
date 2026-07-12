<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="gestion.Vehicule" %>
<%
String typeEntretien = request.getParameter("type");
%>
<%
    String idParam = request.getParameter("id");
    if (idParam == null || idParam.isEmpty()) {
        out.println("<div class='alert alert-danger'>ID du véhicule manquant.</div>");
        return;
    }
    
    int idVehicule = 0;
    Vehicule v = null;
    try {
        idVehicule = Integer.parseInt(idParam);
        v = Vehicule.getVehiculeById(idVehicule);
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Erreur lors de la récupération : " + e.getMessage() + "</div>");
        return;
    }

    if (v == null) {
        out.println("<div class='alert alert-danger'>Aucun véhicule trouvé avec l'ID " + idVehicule + "</div>");
        return;
    }
%>

<div class="container mt-4">
    <p><a href="model.jsp?page=vehicule/details-vehicule&id=<%= idVehicule %>" class="btn btn-sm btn-secondary"><i class="bi bi-arrow-left"></i> Retour à la liste</a></p>
    
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-dark text-white">
            <h4 class="mb-0">Entretien pour : <%= v.getMarque() %> <%= v.getModele() %> (<%= v.getImmatriculation() %>)</h4>
        </div>
    </div>

    <div class="card shadow-sm mb-4 d-none" id="card-entretien-general">
        <div class="card-header bg-primary text-white" id="titre-general">Enregistrer un entretien</div>
        <div class="card-body">
            <form action="model.jsp?page=vehicule/traitement-entretien" method="POST">
                <input type="hidden" name="id_vehicule" value="<%= idVehicule %>">
                <input type="hidden" name="type_entretien" id="type_general">
                
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Date Entretien :</label>
                        <input type="date" name="date_entretien" class="form-control" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Coût (Ariary) :</label>
                        <input type="number" step="0.01" name="cout" class="form-control" min="0" required>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Kilométrage au moment de l'entretien :</label>
                        <input type="number" name="kilometrage" class="form-control" min="0" value="<%= v.getKilometrageActuel() %>" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Date Prochain Entretien (Optionnel) :</label>
                        <input type="date" name="date_prochain_entretien" class="form-control">
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Remarque / Description :</label>
                    <textarea name="remarque" id="remarque_general" class="form-control" rows="3"></textarea>
                </div>

                <button type="submit" class="btn btn-success w-100">Valider l'entretien</button>
            </form>
        </div>
    </div>

    <div class="card shadow-sm mb-4 d-none" id="card-lavage">
        <div class="card-header bg-info text-white">Enregistrer un Lavage complet</div>
        <div class="card-body">
            <form action="model.jsp?page=vehicule/traitement-lavage" method="POST">
                <input type="hidden" name="id_vehicule" value="<%= idVehicule %>">
                <input type="hidden" name="type_entretien" value="LAVAGE">
                
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Date du lavage :</label>
                        <input type="date" name="date_entretien" class="form-control" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Coût (Ariary) :</label>
                        <input type="number" step="0.01" name="cout" class="form-control" min="0" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Kilométrage actuel :</label>
                        <input type="number" name="kilometrage" class="form-control" min="0" value="<%= v.getKilometrageActuel() %>" required>
                    </div>
                </div>
                <button type="submit" class="btn btn-success w-100">Valider le Lavage</button>
            </form>
        </div>
    </div>
</div>

<script>
window.onload = function(){

    let type = "<%= typeEntretien != null ? typeEntretien : "" %>";

    if(type !== ""){
        ouvrirFormulaire(type);
    }

};

function ouvrirFormulaire(type) {
    document.getElementById('card-entretien-general').classList.add('d-none');
    document.getElementById('card-lavage').classList.add('d-none');

    if (type === 'LAVAGE') {
        document.getElementById('card-lavage').classList.remove('d-none');
    } else {
        document.getElementById('card-entretien-general').classList.remove('d-none');
        document.getElementById('type_general').value = type;
        document.getElementById('titre-general').innerText = "Enregistrer un entretien : " + type;
    }
}
</script>