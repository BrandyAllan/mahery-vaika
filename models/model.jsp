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
    <svg xmlns="http://www.w3.org/2000/svg" class="d-none">
      <symbol id="check2" viewBox="0 0 16 16">
        <path
          d="M13.854 3.646a.5.5 0 0 1 0 .708l-7 7a.5.5 0 0 1-.708 0l-3.5-3.5a.5.5 0 1 1 .708-.708L6.5 10.293l6.646-6.647a.5.5 0 0 1 .708 0z"
        ></path>
      </symbol>
      <symbol id="circle-half" viewBox="0 0 16 16">
        <path
          d="M8 15A7 7 0 1 0 8 1v14zm0 1A8 8 0 1 1 8 0a8 8 0 0 1 0 16z"
        ></path>
      </symbol>
      <symbol id="moon-stars-fill" viewBox="0 0 16 16">
        <path
          d="M6 .278a.768.768 0 0 1 .08.858 7.208 7.208 0 0 0-.878 3.46c0 4.021 3.278 7.277 7.318 7.277.527 0 1.04-.055 1.533-.16a.787.787 0 0 1 .81.316.733.733 0 0 1-.031.893A8.349 8.349 0 0 1 8.344 16C3.734 16 0 12.286 0 7.71 0 4.266 2.114 1.312 5.124.06A.752.752 0 0 1 6 .278z"
        ></path>
        <path
          d="M10.794 3.148a.217.217 0 0 1 .412 0l.387 1.162c.173.518.579.924 1.097 1.097l1.162.387a.217.217 0 0 1 0 .412l-1.162.387a1.734 1.734 0 0 0-1.097 1.097l-.387 1.162a.217.217 0 0 1-.412 0l-.387-1.162A1.734 1.734 0 0 0 9.31 6.593l-1.162-.387a.217.217 0 0 1 0-.412l1.162-.387a1.734 1.734 0 0 0 1.097-1.097l.387-1.162zM13.863.099a.145.145 0 0 1 .274 0l.258.774c.115.346.386.617.732.732l.774.258a.145.145 0 0 1 0 .274l-.774.258a1.156 1.156 0 0 0-.732.732l-.258.774a.145.145 0 0 1-.274 0l-.258-.774a1.156 1.156 0 0 0-.732-.732l-.774-.258a.145.145 0 0 1 0-.274l.774-.258c.346-.115.617-.386.732-.732L13.863.1z"
        ></path>
      </symbol>
      <symbol id="sun-fill" viewBox="0 0 16 16">
        <path
          d="M8 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM8 0a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-1 0v-2A.5.5 0 0 1 8 0zm0 13a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-1 0v-2A.5.5 0 0 1 8 13zm8-5a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1 0-1h2a.5.5 0 0 1 .5.5zM3 8a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1 0-1h2A.5.5 0 0 1 3 8zm10.657-5.657a.5.5 0 0 1 0 .707l-1.414 1.415a.5.5 0 1 1-.707-.708l1.414-1.414a.5.5 0 0 1 .707 0zm-9.193 9.193a.5.5 0 0 1 0 .707L3.05 13.657a.5.5 0 0 1-.707-.707l1.414-1.414a.5.5 0 0 1 .707 0zm9.193 2.121a.5.5 0 0 1-.707 0l-1.414-1.414a.5.5 0 0 1 .707-.707l1.414 1.414a.5.5 0 0 1 0 .707zM4.464 4.465a.5.5 0 0 1-.707 0L2.343 3.05a.5.5 0 1 1 .707-.707l1.414 1.414a.5.5 0 0 1 0 .708z"
        ></path>
      </symbol>
    </svg>
    <div
      class="dropdown position-fixed bottom-0 end-0 mb-3 me-3 bd-mode-toggle"
    >
      <button
        class="btn btn-bd-primary py-2 dropdown-toggle d-flex align-items-center"
        id="bd-theme"
        type="button"
        aria-expanded="false"
        data-bs-toggle="dropdown"
        aria-label="Toggle theme (auto)"
      >
        <svg class="bi my-1 theme-icon-active" aria-hidden="true">
          <use href="#circle-half"></use>
        </svg>
        <span class="visually-hidden" id="bd-theme-text">Toggle theme</span>
      </button>
      <ul
        class="dropdown-menu dropdown-menu-end shadow"
        aria-labelledby="bd-theme-text"
      >
        <li>
          <button
            type="button"
            class="dropdown-item d-flex align-items-center"
            data-bs-theme-value="light"
            aria-pressed="false"
          >
            <svg class="bi me-2 opacity-50" aria-hidden="true">
              <use href="#sun-fill"></use>
            </svg>
            Light
            <svg class="bi ms-auto d-none" aria-hidden="true">
              <use href="#check2"></use>
            </svg>
          </button>
        </li>
        <li>
          <button
            type="button"
            class="dropdown-item d-flex align-items-center"
            data-bs-theme-value="dark"
            aria-pressed="false"
          >
            <svg class="bi me-2 opacity-50" aria-hidden="true">
              <use href="#moon-stars-fill"></use>
            </svg>
            Dark
            <svg class="bi ms-auto d-none" aria-hidden="true">
              <use href="#check2"></use>
            </svg>
          </button>
        </li>
        <li>
          <button
            type="button"
            class="dropdown-item d-flex align-items-center active"
            data-bs-theme-value="auto"
            aria-pressed="true"
          >
            <svg class="bi me-2 opacity-50" aria-hidden="true">
              <use href="#circle-half"></use>
            </svg>
            Auto
            <svg class="bi ms-auto d-none" aria-hidden="true">
              <use href="#check2"></use>
            </svg>
          </button>
        </li>
      </ul>
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