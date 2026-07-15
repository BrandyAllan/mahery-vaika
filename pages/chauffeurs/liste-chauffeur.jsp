<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="backoffice.Utilisateur" %>
<%@ page import="gestion.Chauffeur" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.Vector" %>
<%
    Utilisateur userObj = (Utilisateur) session.getAttribute("utilisateur");
    if (userObj == null) {
        response.sendRedirect("../../index.jsp");
        return;
    }
    boolean isAdmin = "Admin".equalsIgnoreCase(userObj.voirsiadmin());

    String nom          = request.getParameter("nom");
    String vehicule     = request.getParameter("vehicule");
    String statutParam  = request.getParameter("statut");
    String statutPermis = request.getParameter("statutPermis");
    String dateDebutStr = request.getParameter("datePermisDebut");
    String dateFinStr   = request.getParameter("datePermisFin");

    Boolean statut = null;
    if (statutParam != null && !statutParam.isEmpty()) statut = Boolean.parseBoolean(statutParam);

    Date datePermisDebut = null;
    Date datePermisFin   = null;
    try { if (dateDebutStr != null && !dateDebutStr.isEmpty()) datePermisDebut = Date.valueOf(dateDebutStr); } catch (Exception e) {}
    try { if (dateFinStr   != null && !dateFinStr.isEmpty())   datePermisFin   = Date.valueOf(dateFinStr);   } catch (Exception e) {}

    int limit = 10;
    int pageCourante = 1;
    try { pageCourante = Integer.parseInt(request.getParameter("pageNum")); } catch (Exception e) {}
    int offset = (pageCourante - 1) * limit;

    Vector listeChauffeurs = Chauffeur.rechercher(nom, vehicule, statut, statutPermis, datePermisDebut, datePermisFin, limit, offset);
    int total    = Chauffeur.count(nom, vehicule, statut, statutPermis, datePermisDebut, datePermisFin);
    int nbPages  = (int) Math.ceil((double) total / limit);
%>
<div class="d-flex justify-content-between align-items-center mb-4">
    <h2 class="fw-bold mb-0">
        <i class="bi bi-person-badge text-primary"></i> Liste des Chauffeurs
        <small class="fs-6 text-muted ms-2">(<%= total %> résultat<%= total > 1 ? "s" : "" %>)</small>
    </h2>

    <div class="d-flex gap-2">
        <a href="?page=chauffeurs/gestion-chauffeur" class="btn btn-outline-secondary btn-sm">
            <i class="bi bi-arrow-left"></i> Retour
        </a>
    </div>
</div>

<div class="card border-0 shadow-sm mb-4">
    <div class="card-body">
        <form method="GET" class="row g-3 align-items-end">
            <input type="hidden" name="page" value="chauffeurs/liste-chauffeur">
            <input type="hidden" name="pageNum" value="1">

            <div class="col-md-3">
                <label class="form-label fw-semibold">Nom / Prénom</label>
                <input type="text" name="nom" class="form-control form-control-sm" placeholder="Recherche..." value="<%= nom != null ? nom : "" %>">
            </div>

            <div class="col-md-3">
                <label class="form-label fw-semibold">Véhicule</label>
                <input type="text" name="vehicule" class="form-control form-control-sm" placeholder="Immatriculation, marque..." value="<%= vehicule != null ? vehicule : "" %>">
            </div>

            <div class="col-md-2">
                <label class="form-label fw-semibold">Statut</label>
                <select name="statut" class="form-select form-select-sm">
                    <option value="">Tous</option>
                    <option value="true"  <%= "true".equals(statutParam)  ? "selected" : "" %>>Actif</option>
                    <option value="false" <%= "false".equals(statutParam) ? "selected" : "" %>>Inactif</option>
                </select>
            </div>

            <div class="col-md-2">
                <label class="form-label fw-semibold">Permis</label>
                <select name="statutPermis" class="form-select form-select-sm">
                    <option value="">Tous</option>
                    <option value="VALIDE"         <%= "VALIDE".equals(statutPermis)         ? "selected" : "" %>>Valide</option>
                    <option value="BIENTOT_EXPIRE" <%= "BIENTOT_EXPIRE".equals(statutPermis) ? "selected" : "" %>>Bientôt expire</option>
                    <option value="EXPIRE"         <%= "EXPIRE".equals(statutPermis)         ? "selected" : "" %>>Expiré</option>
                </select>
            </div>

            <div class="col-md-2 d-flex align-items-end gap-2">
                <button type="submit" class="btn btn-primary btn-sm w-100">
                    <i class="bi bi-search"></i> Filtrer
                </button>
            </div>

            <div class="col-md-3">
                <label class="form-label fw-semibold">Expiration permis — Du</label>
                <input type="date" name="datePermisDebut" class="form-control form-control-sm" value="<%= dateDebutStr != null ? dateDebutStr : "" %>">
            </div>

            <div class="col-md-3">
                <label class="form-label fw-semibold">Au</label>
                <input type="date" name="datePermisFin" class="form-control form-control-sm" value="<%= dateFinStr != null ? dateFinStr : "" %>">
            </div>

            <div class="col-md-2 d-flex align-items-end">
                <a href="?page=chauffeurs/liste-chauffeur" class="btn btn-outline-secondary btn-sm w-100">
                    Réinitialiser
                </a>
            </div>
        </form>
    </div>
</div>

<div class="card border-0 shadow-sm mb-4">
    <div class="table-responsive">
        <table class="table table-hover table-striped align-middle mb-0">
            <thead class="table-light">
                <tr>
                    <th>Nom complet</th>
                    <th>Téléphone</th>
                    <th>N° Permis</th>
                    <th>Exp. Permis</th>
                    <th>Statut Permis</th>
                    <th>Véhicule habituel</th>
                    <th>Statut</th>
                    <% if (isAdmin) { %><th class="text-end">Actions</th><% } %>
                </tr>
            </thead>
            <tbody>
                <%
                if (listeChauffeurs.isEmpty()) {
                %>
                    <tr>
                        <td colspan="<%= isAdmin ? 8 : 7 %>" class="text-center text-muted py-5">
                            <i class="bi bi-inbox d-block fs-1 mb-2"></i>
                            Aucun chauffeur trouvé.
                        </td>
                    </tr>
                <%
                } else {
                    for (int i = 0; i < listeChauffeurs.size(); i++) {
                        Chauffeur ch = (Chauffeur) listeChauffeurs.get(i);
                %>
                    <tr onclick="window.location='?page=chauffeurs/details-chauffeur&id=<%= ch.getIdChauffeur() %>'" style="cursor:pointer;">
                        <td class="fw-semibold"><%= ch.getNomComplet() %></td>
                        <td><%= ch.getTelephone() != null ? ch.getTelephone() : "-" %></td>
                        <td class="text-muted fw-semibold"><%= ch.getNumeroPermis() %></td>
                        <td><%= ch.getDateExpirationPermis() != null ? ch.getDateExpirationPermis() : "-" %></td>
                        <td>
                            <%
                                String sp = ch.getStatutPermis();
                                String spLabel = "VALIDE".equals(sp) ? "Valide"
                                               : "EXPIRE".equals(sp) ? "Expiré"
                                               : "BIENTOT_EXPIRE".equals(sp) ? "Bientôt expire"
                                               : "Inconnu";
                                String badgeClass = "VALIDE".equals(sp) ? "bg-success"
                                                  : "EXPIRE".equals(sp) ? "bg-danger"
                                                  : "BIENTOT_EXPIRE".equals(sp) ? "bg-warning text-dark"
                                                  : "bg-secondary";
                            %>
                            <span class="badge <%= badgeClass %> rounded-pill px-3 py-2"><%= spLabel %></span>
                        </td>
                        <td>
                            <% if (ch.getImmatriculationVehicule() != null) { %>
                                <span class="badge bg-light text-dark border"><%= ch.getImmatriculationVehicule() %></span>
                                <small class="text-muted ms-1">(<%= ch.getMarqueModeleVehicule() %>)</small>
                            <% } else { %>
                                <span class="text-muted">-</span>
                            <% } %>
                        </td>
                        <td>
                            <span class="badge <%= ch.isActif() ? "bg-success" : "bg-danger" %> rounded-pill px-3 py-2">
                                <%= ch.isActif() ? "Actif" : "Inactif" %>
                            </span>
                        </td>
                        <% if (isAdmin) { %>
                        <td class="text-end" onclick="event.stopPropagation();">
                            <a href="?page=chauffeurs/modifier-chauffeur&id=<%= ch.getIdChauffeur() %>" class="btn btn-sm btn-outline-primary rounded-circle me-1" title="Modifier">
                                <i class="bi bi-pencil"></i>
                            </a>
                            <a href="../traitement/chauffeurs/modifier-chauffeur.jsp?id=<%= ch.getIdChauffeur() %>&actif=<%= !ch.isActif() %>"
                               class="btn btn-sm <%= ch.isActif() ? "btn-outline-danger" : "btn-outline-success" %> rounded-circle"
                               onclick="return confirm('Confirmer la <%= ch.isActif() ? "désactivation" : "réactivation" %> ?')"
                               title="<%= ch.isActif() ? "Désactiver" : "Réactiver" %>">
                                <i class="bi <%= ch.isActif() ? "bi-person-x" : "bi-person-check" %>"></i>
                            </a>
                        </td>
                        <% } %>
                    </tr>
                <%
                    }
                }
                %>
            </tbody>
        </table>
    </div>
</div>

<% if (nbPages > 1) {
    String paginationBaseUrl = "?page=chauffeurs/liste-chauffeur&nom=" + (nom != null ? nom : "")
            + "&vehicule=" + (vehicule != null ? vehicule : "")
            + "&statut=" + (statutParam != null ? statutParam : "")
            + "&statutPermis=" + (statutPermis != null ? statutPermis : "")
            + "&datePermisDebut=" + (dateDebutStr != null ? dateDebutStr : "")
            + "&datePermisFin=" + (dateFinStr != null ? dateFinStr : "");
%>
<nav>
    <div class="join">
        <% java.util.TreeSet<Integer> pagesToShow = new java.util.TreeSet<>();
           pagesToShow.add(1);
           pagesToShow.add(2);
           pagesToShow.add(nbPages - 1);
           pagesToShow.add(nbPages);
           pagesToShow.add(pageCourante - 1);
           pagesToShow.add(pageCourante);
           pagesToShow.add(pageCourante + 1);
           pagesToShow.removeIf(p -> p < 1 || p > nbPages);
           int previousPage = 0;
           for (int p : pagesToShow) {
               if (previousPage != 0 && p - previousPage > 1) { %>
                    <button class="join-item btn btn-disabled">...</button>
        <%     }
               previousPage = p;
        %>
            <a class="join-item btn <%= p == pageCourante ? "btn-active" : "" %>"
               href="<%= paginationBaseUrl %>&pageNum=<%= p %>"><%= p %></a>
        <%     } %>
    </div>
</nav>
<% } %>