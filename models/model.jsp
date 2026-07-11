<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="backoffice.Utilisateur" %>

<%
    String pageContent = request.getParameter("page");

    if (pageContent == null || pageContent.trim().equals("")) {
        pageContent = "dashboard/jour";
    }

    String fileToInclude = "../pages/" + pageContent + ".jsp";

    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    boolean isAdmin = user.voirsiadmin().equals("Admin");

    // Détermine la section active du menu selon la page affichée
    String activeSection = pageContent.contains("/") ? pageContent.substring(0, pageContent.indexOf("/")) : pageContent;
%>

<!doctype html>
<html lang="en" data-bs-theme="auto">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="description" content="" />
    <meta
      name="author"
      content="Mark Otto, Jacob Thornton, and Bootstrap contributors"
    />
    <meta name="generator" content="Astro v5.13.2" />
    <title>Mahery Vaika</title>
    <link
      rel="canonical"
      href="https://getbootstrap.com/docs/5.3/examples/sidebars/"
    />
    <script src="../assets/js/color-modes.js"></script>
    <link href="../assets/css/bootstrap.min.css" rel="stylesheet" />
    <link href="../assets/icons/bootstrap-icons.min.css" rel="stylesheet" />
    <meta name="theme-color" content="#712cf9" />
    <link href="../assets/css/sidebars.css" rel="stylesheet" />
    <link rel="stylesheet" href="../assets/css/dashboard-graph.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
      .bd-placeholder-img {
        font-size: 1.125rem;
        text-anchor: middle;
        -webkit-user-select: none;
        -moz-user-select: none;
        user-select: none;
      }
      @media (min-width: 768px) {
        .bd-placeholder-img-lg {
          font-size: 3.5rem;
        }
      }
      .b-example-divider {
        width: 100%;
        height: 3rem;
        background-color: #0000001a;
        border: solid rgba(0, 0, 0, 0.15);
        border-width: 1px 0;
        box-shadow:
          inset 0 0.5em 1.5em #0000001a,
          inset 0 0.125em 0.5em #00000026;
      }
      .b-example-vr {
        flex-shrink: 0;
        width: 1.5rem;
        height: 100vh;
      }
      .bi {
        vertical-align: -0.125em;
        fill: currentColor;
      }
      .nav-scroller {
        position: relative;
        z-index: 2;
        height: 2.75rem;
        overflow-y: hidden;
      }
      .nav-scroller .nav {
        display: flex;
        flex-wrap: nowrap;
        padding-bottom: 1rem;
        margin-top: -1px;
        overflow-x: auto;
        text-align: center;
        white-space: nowrap;
        -webkit-overflow-scrolling: touch;
      }
      .btn-bd-primary {
        --bd-violet-bg: #712cf9;
        --bd-violet-rgb: 112.520718, 44.062154, 249.437846;
        --bs-btn-font-weight: 600;
        --bs-btn-color: var(--bs-white);
        --bs-btn-bg: var(--bd-violet-bg);
        --bs-btn-border-color: var(--bd-violet-bg);
        --bs-btn-hover-color: var(--bs-white);
        --bs-btn-hover-bg: #6528e0;
        --bs-btn-hover-border-color: #6528e0;
        --bs-btn-focus-shadow-rgb: var(--bd-violet-rgb);
        --bs-btn-active-color: var(--bs-btn-hover-color);
        --bs-btn-active-bg: #5a23c8;
        --bs-btn-active-border-color: #5a23c8;
      }
      .bd-mode-toggle {
        z-index: 1500;
      }
      .bd-mode-toggle .bi {
        width: 1em;
        height: 1em;
      }
      .bd-mode-toggle .dropdown-menu .active .bi {
        display: block !important;
      }
    </style>
  </head>
  <body>
    <div class="mobile-topbar align-items-center justify-content-between px-3 py-2 border-bottom bg-body">
      <button class="btn btn-outline-secondary"
              type="button"
              data-bs-toggle="offcanvas"
              data-bs-target="#mobileSidebar"
              aria-controls="mobileSidebar">
        <i class="bi bi-list fs-4"></i>
      </button>
      <img src="../assets/images/logo-fond-sombre.png" alt="Logo" width="50" class="bi pe-none me-2" aria-hidden="true">
      <span class="fs-5 mahery-vaika">Mahery Vaika</span>
    </div>
    <div class="offcanvas offcanvas-start sidebar-flat" tabindex="-1" id="mobileSidebar">
      <div class="offcanvas-header d-flex align-items-center justify-content-between">
          <button type="button"
                  class="btn-close btn-close-white ms-auto"
                  data-bs-dismiss="offcanvas">
          </button>
      </div>

      <div class="offcanvas-body d-flex flex-column p-0">
        <div class="sidebar-logo text-center py-3">
          <img src="../assets/images/logo-fond-sombre.png" alt="Logo" width="90">
        </div>

        <ul class="nav-flat list-unstyled flex-grow-1 px-3 mb-0">
          <% if(isAdmin) { %>
          <li>
            <a href="?page=dashboard/jour" class="nav-link-flat<%= "dashboard".equals(activeSection) ? " active" : "" %>">
              <i class="bi bi-grid-1x2-fill"></i><span>Dashboard</span>
            </a>
          </li>
          <% } %>
          <li>
            <a href="?page=reservation/liste-reservation" class="nav-link-flat<%= "reservation".equals(activeSection) ? " active" : "" %>">
              <i class="bi bi-calendar2-check-fill"></i><span>Réservations</span>
            </a>
          </li>
          <li>
            <a href="?page=departs/gestion-departs" class="nav-link-flat<%= "departs".equals(activeSection) ? " active" : "" %>">
              <i class="bi bi-signpost-split-fill"></i><span>Départs</span>
            </a>
          </li>
          <li>
            <a href="?page=trajet/gestion-trajet" class="nav-link-flat<%= "trajet".equals(activeSection) ? " active" : "" %>">
              <i class="bi bi-signpost-2-fill"></i><span>Trajets</span>
            </a>
          </li>
          <li>
            <a href="?page=vehicule/gestion-vehicule" class="nav-link-flat<%= "vehicule".equals(activeSection) ? " active" : "" %>">
              <i class="bi bi-bus-front-fill"></i><span>Véhicules</span>
            </a>
          </li>
          <li>
            <a href="?page=chauffeurs/gestion-chauffeur" class="nav-link-flat<%= "chauffeurs".equals(activeSection) ? " active" : "" %>">
              <i class="bi bi-person-vcard-fill"></i><span>Chauffeurs</span>
            </a>
          </li>
          <% if(isAdmin) { %>
          <li>
            <a href="?page=depense/depense" class="nav-link-flat<%= "depense".equals(activeSection) ? " active" : "" %>">
              <i class="bi bi-wallet2"></i><span>Finances</span>
            </a>
          </li>
          <li>
            <a href="?page=utilisateur/liste-utilisateur" class="nav-link-flat<%= "utilisateur".equals(activeSection) ? " active" : "" %>">
              <i class="bi bi-people-fill"></i><span>Utilisateurs</span>
            </a>
          </li>
          <% } %>
        </ul>

        <div class="px-3 mb-2">
          <a href="?page=reservation/ajout-reservation" class="btn btn-brand sidebar-cta w-100">
            <i class="bi bi-plus-lg"></i> Nouvelle Réservation
          </a>
        </div>

        <div class="sidebar-footer d-flex align-items-center justify-content-between px-3 py-3">
          <a href="?page=utilisateur/details-utilisateur&id=<%= user.getId_utilisateur() %>" class="d-flex align-items-center text-decoration-none sidebar-user">
            <i class="bi bi-person-circle"></i>
            <span class="lh-sm">
              <span class="d-block sidebar-user-name"><%= user.getPrenom() %></span>
              <span class="d-block sidebar-user-role"><%= user.getNom_role() %></span>
            </span>
          </a>
          <a href="../traitement/traitement-logout.jsp" class="sidebar-logout" title="Déconnexion">
            <i class="bi bi-box-arrow-right"></i>
          </a>
        </div>
      </div>
    </div>
    <main class="d-flex app-layout">
      <div class="flex-shrink-0 sidebar-desktop sidebar-flat d-flex flex-column">
        <div class="sidebar-logo text-center py-4">
          <a href="?page=dashboard/jour">
            <img src="../assets/images/logo-fond-sombre.png" alt="Logo" width="90">
          </a>
        </div>

        <ul class="nav-flat list-unstyled flex-grow-1 px-3 mb-0">
          <% if(isAdmin) { %>
          <li>
            <a href="?page=dashboard/jour" class="nav-link-flat<%= "dashboard".equals(activeSection) ? " active" : "" %>">
              <i class="bi bi-grid-1x2-fill"></i><span>Dashboard</span>
            </a>
          </li>
          <% } %>
          <li>
            <a href="?page=reservation/liste-reservation" class="nav-link-flat<%= "reservation".equals(activeSection) ? " active" : "" %>">
              <i class="bi bi-calendar2-check-fill"></i><span>Réservations</span>
            </a>
          </li>
          <li>
            <a href="?page=departs/gestion-departs" class="nav-link-flat<%= "departs".equals(activeSection) ? " active" : "" %>">
              <i class="bi bi-signpost-split-fill"></i><span>Départs</span>
            </a>
          </li>
          <li>
            <a href="?page=trajet/gestion-trajet" class="nav-link-flat<%= "trajet".equals(activeSection) ? " active" : "" %>">
              <i class="bi bi-signpost-2-fill"></i><span>Trajets</span>
            </a>
          </li>
          <li>
            <a href="?page=vehicule/gestion-vehicule" class="nav-link-flat<%= "vehicule".equals(activeSection) ? " active" : "" %>">
              <i class="bi bi-bus-front-fill"></i><span>Véhicules</span>
            </a>
          </li>
          <li>
            <a href="?page=chauffeurs/gestion-chauffeur" class="nav-link-flat<%= "chauffeurs".equals(activeSection) ? " active" : "" %>">
              <i class="bi bi-person-vcard-fill"></i><span>Chauffeurs</span>
            </a>
          </li>
          <% if(isAdmin) { %>
          <li>
            <a href="?page=depense/depense" class="nav-link-flat<%= "depense".equals(activeSection) ? " active" : "" %>">
              <i class="bi bi-wallet2"></i><span>Finances</span>
            </a>
          </li>
          <li>
            <a href="?page=utilisateur/liste-utilisateur" class="nav-link-flat<%= "utilisateur".equals(activeSection) ? " active" : "" %>">
              <i class="bi bi-people-fill"></i><span>Utilisateurs</span>
            </a>
          </li>
          <% } %>
        </ul>

        <div class="px-3 mb-2">
          <a href="?page=reservation/ajout-reservation" class="btn btn-brand sidebar-cta w-100">
            <i class="bi bi-plus-lg"></i> Nouvelle Réservation
          </a>
        </div>

        <div class="sidebar-footer d-flex align-items-center justify-content-between px-3 py-3">
          <a href="?page=utilisateur/details-utilisateur&id=<%= user.getId_utilisateur() %>" class="d-flex align-items-center text-decoration-none sidebar-user">
            <i class="bi bi-person-circle"></i>
            <span class="lh-sm">
              <span class="d-block sidebar-user-name"><%= user.getPrenom() %></span>
              <span class="d-block sidebar-user-role"><%= user.getNom_role() %></span>
            </span>
          </a>
          <a href="../traitement/traitement-logout.jsp" class="sidebar-logout" title="Déconnexion">
            <i class="bi bi-box-arrow-right"></i>
          </a>
        </div>
      </div>
      <div class="flex-grow-1 p-4 content-area">
        <jsp:include page="<%= fileToInclude %>" />
      </div>
    </main>
    <script
      src="../assets/js/bootstrap.bundle.min.js"
      class="astro-vvvwv3sm"
    ></script>
    <script src="../assets/js/sidebars.js" class="astro-vvvwv3sm"></script>
  </body>
</html>