<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="backoffice.Utilisateur" %>
<%
    Utilisateur userObj = (Utilisateur) session.getAttribute("utilisateur");
    if (userObj == null || !"Admin".equalsIgnoreCase(userObj.voirsiadmin())) {
        response.sendRedirect("liste-vehicule.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ajouter un Véhicule</title>
    
    <script>
        function chargerModelesAjout() {
            var marque = document.getElementById("marque").value;
            var modeleSelect = document.getElementById("modele");
            modeleSelect.innerHTML = '<option value="">-- Sélectionner un modèle --</option>';
            if(!marque) return;

            fetch('get-modeles.jsp?marque=' + encodeURIComponent(marque))
                .then(res => res.json())
                .then(data => {
                    data.forEach(m => {
                        var opt = document.createElement("option");
                        opt.value = m; opt.text = m;
                        modeleSelect.add(opt);
                    });
                });
        }
    </script>
</head>
<body class="bg-light">

    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <p><a href="?page=gestion-vehicule" class="btn btn-sm btn-secondary mb-3"><i class="bi bi-arrow-left"></i> Retour</a></p>
                
                <div class="card shadow-sm">
                    <div class="card-header bg-success text-white">
                        <h4 class="mb-0"><i class="bi bi-plus-circle"></i> Enregistrer un nouveau véhicule</h4>
                    </div>
                    <div class="card-body p-4">
                        
                        <form action="${pageContext.request.contextPath}?page=/traitement/vehicule/ajouter-vehicule" method="POST">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Immatriculation :</label>
                                    <input type="text" name="immatriculation" class="form-control" required placeholder="Ex: 1234 TAB">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Marque :</label>
                                    <select name="marque" id="marque" class="form-select" onchange="chargerModelesAjout()" required>
                                        <option value="">-- Sélectionner une marque --</option>
                                        <option value="toyota">Toyota</option>
                                        <option value="Mercedes">Mercedes</option>
                                        <option value="Mazda">Mazda</option>
                                    </select>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Modèle (Écrire manuellement) :</label>
                                    <input type="text" name="modele" class="form-control" required placeholder="Ex: Hilux, Sprinter, CX-5...">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Capacité (Nombre de places) :</label>
                                    <input type="number" name="capacite" class="form-control" min="1" required>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Kilométrage initial :</label>
                                    <input type="number" name="kilometrage" class="form-control" value="0" min="0">
                                </div>
                                <div class="col-md-6 mb-4">
                                    <label class="form-label">Date Expiration Assurance :</label>
                                    <input type="date" name="dateAssurance" class="form-control" required>
                                </div>
                            </div>

                            <div class="d-grid">
                                <button type="submit" class="btn btn-success"><i class="bi bi-check-circle"></i> Enregistrer le véhicule</button>
                            </div>
                        </form>

                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>