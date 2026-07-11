function formatAr(value) {
    return Number(value).toLocaleString("fr-FR") + " Ar";
}

let trajetChartInstance = null;
let caChartInstance = null;
let beneficeChartInstance = null;

function obtenirUrlDashboardJour() {
    if (window.dashboardJourDataUrl) {
        return window.dashboardJourDataUrl;
    }

    const segments = window.location.pathname
        .split("/")
        .filter(Boolean);

    const contextPath =
        segments.length > 0
            ? "/" + segments[0]
            : "";

    return (
        contextPath
        + "/traitement/dashboard/dashboard-jour-data.jsp"
    );
}

function chargerDonneesJour(dateJour) {
    let url = obtenirUrlDashboardJour();

    if (dateJour) {
        const params = new URLSearchParams();
        params.set("date_jour", dateJour);
        url += "?" + params.toString();
    }

    afficherChargement(true);
    masquerErreur();

    fetch(url, {
        method: "GET",
        headers: {
            "Accept": "application/json"
        },
        cache: "no-store"
    })
    .then(function (response) {
        return response.text().then(function (texte) {
            if (!response.ok) {
                throw new Error(
                    "Erreur HTTP "
                    + response.status
                    + " : "
                    + texte
                );
            }

            try {
                return JSON.parse(texte);
            } catch (e) {
                console.error(
                    "Réponse serveur non JSON :",
                    texte
                );

                throw new Error(
                    "Le serveur n'a pas retourné un JSON valide."
                );
            }
        });
    })
    .then(function (data) {
        if (data.erreur) {
            throw new Error(data.erreur);
        }

        remplirDateFiltre(data.dateCible);
        mettreAJourPeriode(data);
        afficherGraphiquesJour(data);
    })
    .catch(function (erreur) {
        console.error(
            "Erreur dashboard journalier :",
            erreur
        );

        afficherErreur(erreur.message);
    })
    .finally(function () {
        afficherChargement(false);
    });
}

function remplirDateFiltre(dateCible) {
    const champDate =
        document.querySelector(".date-jour");

    if (champDate && dateCible) {
        champDate.value = dateCible;
    }
}

function mettreAJourPeriode(data) {
    const periodeElement =
        document.getElementById("periodeDashboardJour");

    if (periodeElement) {
        periodeElement.textContent =
            "Données du "
            + formaterDateFrancaise(data.dateDebut)
            + " au "
            + formaterDateFrancaise(data.dateFin);
    }

    const titreTrajets =
        document.getElementById("titreTrajetsJour");

    if (titreTrajets) {
        titreTrajets.textContent =
            "Choix des trajets du "
            + formaterDateFrancaise(data.dateCible);
    }
}

function formaterDateFrancaise(dateTexte) {
    if (!dateTexte) {
        return "";
    }

    const morceaux = dateTexte.split("-");

    if (morceaux.length !== 3) {
        return dateTexte;
    }

    const date = new Date(
        Number(morceaux[0]),
        Number(morceaux[1]) - 1,
        Number(morceaux[2])
    );

    return date.toLocaleDateString(
        "fr-FR",
        {
            day: "2-digit",
            month: "long",
            year: "numeric"
        }
    );
}

function afficherGraphiquesJour(data) {
    const labels = data.labels || [];
    const chiffresAffaires = data.ca || [];
    const benefices = data.benefice || [];

    const trajets = data.trajets || {
        labels: [],
        values: [],
        nombres: []
    };

    detruireGraphiques();

    const trajetCanvas =
        document.getElementById("destinationChart");

    const caCanvas =
        document.getElementById("caChart");

    const beneficeCanvas =
        document.getElementById("beneficeChart");

    if (
        !trajetCanvas
        || !caCanvas
        || !beneficeCanvas
    ) {
        afficherErreur(
            "Un ou plusieurs canvas du dashboard sont introuvables."
        );
        return;
    }

    trajetChartInstance = new Chart(
        trajetCanvas,
        {
            type: "doughnut",

            data: {
                labels: trajets.labels,

                datasets: [{
                    label: "Choix des trajets",
                    data: trajets.values,
                    borderWidth: 2
                }]
            },

            options: {
                responsive: true,
                maintainAspectRatio: false,

                plugins: {
                    legend: {
                        position: "bottom"
                    },

                    tooltip: {
                        callbacks: {
                            label: function (context) {
                                const index =
                                    context.dataIndex;

                                const nombre =
                                    trajets.nombres?.[index]
                                    || 0;

                                return (
                                    context.label
                                    + " : "
                                    + context.raw
                                    + "% — "
                                    + nombre
                                    + " réservation(s)"
                                );
                            }
                        }
                    }
                }
            }
        }
    );

    caChartInstance = new Chart(
        caCanvas,
        {
            type: "bar",

            data: {
                labels: labels,

                datasets: [{
                    label:
                        "Chiffre d'affaires brut",

                    data:
                        chiffresAffaires,

                    borderWidth: 1,
                    borderRadius: 6
                }]
            },

            options: {
                responsive: true,
                maintainAspectRatio: false,

                scales: {
                    y: {
                        beginAtZero: true,

                        ticks: {
                            callback:
                                function (value) {
                                    return formatAr(value);
                                }
                        }
                    }
                },

                plugins: {
                    tooltip: {
                        callbacks: {
                            label:
                                function (context) {
                                    return (
                                        "CA : "
                                        + formatAr(
                                            context.raw
                                        )
                                    );
                                }
                        }
                    }
                }
            }
        }
    );

    beneficeChartInstance = new Chart(
        beneficeCanvas,
        {
            type: "line",

            data: {
                labels: labels,

                datasets: [{
                    label: "Bénéfice",

                    data: benefices,

                    tension: 0.35,
                    fill: true,
                    borderWidth: 3
                }]
            },

            options: {
                responsive: true,
                maintainAspectRatio: false,

                scales: {
                    y: {
                        beginAtZero: true,

                        ticks: {
                            callback:
                                function (value) {
                                    return formatAr(value);
                                }
                        }
                    }
                },

                plugins: {
                    tooltip: {
                        callbacks: {
                            label:
                                function (context) {
                                    return (
                                        "Bénéfice : "
                                        + formatAr(
                                            context.raw
                                        )
                                    );
                                }
                        }
                    }
                }
            }
        }
    );
}

function detruireGraphiques() {
    if (trajetChartInstance) {
        trajetChartInstance.destroy();
        trajetChartInstance = null;
    }

    if (caChartInstance) {
        caChartInstance.destroy();
        caChartInstance = null;
    }

    if (beneficeChartInstance) {
        beneficeChartInstance.destroy();
        beneficeChartInstance = null;
    }
}

function afficherErreur(message) {
    const zoneErreur =
        document.getElementById(
            "dashboardJourErreur"
        );

    if (zoneErreur) {
        zoneErreur.textContent =
            "Impossible de charger le dashboard : "
            + message;

        zoneErreur.classList.remove("d-none");
    } else {
        alert(
            "Impossible de charger le dashboard : "
            + message
        );
    }
}

function masquerErreur() {
    const zoneErreur =
        document.getElementById(
            "dashboardJourErreur"
        );

    if (zoneErreur) {
        zoneErreur.textContent = "";
        zoneErreur.classList.add("d-none");
    }
}

function afficherChargement(enChargement) {
    const bouton =
        document.querySelector(".btn-filter-jour");

    if (!bouton) {
        return;
    }

    if (enChargement) {
        bouton.disabled = true;
        bouton.dataset.texteOriginal =
            bouton.innerHTML;

        bouton.innerHTML =
            "Chargement...";
    } else {
        bouton.disabled = false;

        bouton.innerHTML =
            bouton.dataset.texteOriginal
            || "Filtrer";
    }
}

function initialiserDashboardJour() {
    const bouton =
        document.querySelector(
            ".btn-filter-jour"
        );

    if (bouton) {
        bouton.addEventListener(
            "click",
            function () {
                const champDate =
                    document.querySelector(
                        ".date-jour"
                    );

                const dateJour =
                    champDate
                        ? champDate.value
                        : "";

                if (!dateJour) {
                    alert(
                        "Veuillez sélectionner une date."
                    );
                    return;
                }

                chargerDonneesJour(dateJour);
            }
        );
    }

    chargerDonneesJour(null);
}

if (document.readyState === "loading") {
    document.addEventListener(
        "DOMContentLoaded",
        initialiserDashboardJour
    );
} else {
    initialiserDashboardJour();
}