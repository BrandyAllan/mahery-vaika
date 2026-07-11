function formatAr(value) {
    return Number(value).toLocaleString("fr-FR") + " Ar";
}

let destinationChartInstance = null;
let caChartInstance = null;
let beneficeChartInstance = null;

function chargerDonneesMois(dateDebut, dateFin) {

    let url =
        "../traitement/dashboard/dashboard-mois-data.jsp";

    const params =
        new URLSearchParams();

    if (dateDebut) {
        params.set(
            "date_debut",
            dateDebut
        );
    }

    if (dateFin) {
        params.set(
            "date_fin",
            dateFin
        );
    }

    if (params.toString() !== "") {
        url += "?" + params.toString();
    }

    fetch(url, {
        method: "GET",
        headers: {
            "Accept": "application/json"
        },
        cache: "no-store"
    })
    .then(function (response) {

        if (!response.ok) {

            throw new Error(
                "Erreur HTTP "
                + response.status
            );
        }

        return response.text();
    })
    .then(function (texte) {

        try {
            return JSON.parse(texte);
        } catch (erreur) {

            console.error(
                "Réponse reçue à la place du JSON :",
                texte
            );

            throw new Error(
                "La réponse du serveur n'est pas un JSON valide."
            );
        }
    })
    .then(function (data) {

        if (data.erreur) {
            throw new Error(data.erreur);
        }

        remplirFiltresParDefaut(data);
        afficherGraphiquesMois(data);
    })
    .catch(function (erreur) {

        console.error(
            "Erreur dashboard mensuel :",
            erreur
        );

        afficherErreurDashboard(
            erreur.message
        );
    });
}

function remplirFiltresParDefaut(data) {

    const champDateDebut =
        document.querySelector(
            ".date-debut"
        );

    const champDateFin =
        document.querySelector(
            ".date-fin"
        );

    if (
        champDateDebut
        && !champDateDebut.value
    ) {
        champDateDebut.value =
            data.dateDebut || "";
    }

    if (
        champDateFin
        && !champDateFin.value
    ) {
        champDateFin.value =
            data.dateFin || "";
    }
}

function afficherErreurDashboard(message) {

    const zoneErreur =
        document.getElementById(
            "dashboardMoisErreur"
        );

    if (zoneErreur) {

        zoneErreur.textContent =
            message;

        zoneErreur.classList.remove(
            "d-none"
        );

    } else {

        alert(
            "Impossible de charger le dashboard mensuel : "
            + message
        );
    }
}

function masquerErreurDashboard() {

    const zoneErreur =
        document.getElementById(
            "dashboardMoisErreur"
        );

    if (zoneErreur) {

        zoneErreur.classList.add(
            "d-none"
        );

        zoneErreur.textContent = "";
    }
}

function afficherGraphiquesMois(data) {

    masquerErreurDashboard();

    const labelsMois =
        data.labels || [];

    const caMois =
        data.ca || [];

    const beneficeMois =
        data.benefice || [];

    const destinationsMois =
        data.destinations || {
            labels: [],
            values: [],
            nombres: []
        };

    detruireAnciensGraphiques();

    const destinationCanvas =
        document.getElementById(
            "destinationChart"
        );

    const caCanvas =
        document.getElementById(
            "caChart"
        );

    const beneficeCanvas =
        document.getElementById(
            "beneficeChart"
        );

    if (
        !destinationCanvas
        || !caCanvas
        || !beneficeCanvas
    ) {

        afficherErreurDashboard(
            "Un ou plusieurs éléments canvas sont introuvables."
        );

        return;
    }

    destinationChartInstance =
        new Chart(
            destinationCanvas,
            {
                type: "doughnut",

                data: {
                    labels:
                        destinationsMois.labels,

                    datasets: [{
                        label:
                            "Choix des destinations",

                        data:
                            destinationsMois.values,

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
                                label:
                                    function (context) {

                                        const index =
                                            context.dataIndex;

                                        const nombre =
                                            destinationsMois
                                                .nombres?.[index]
                                            || 0;

                                        return (
                                            context.label
                                            + " : "
                                            + context.raw
                                            + "% ("
                                            + nombre
                                            + " réservation(s))"
                                        );
                                    }
                            }
                        },

                        title: {
                            display: true,

                            text:
                                "Destinations du mois actuel"
                        }
                    }
                }
            }
        );

    caChartInstance =
        new Chart(
            caCanvas,
            {
                type: "bar",

                data: {
                    labels:
                        labelsMois,

                    datasets: [{
                        label:
                            "Chiffre d'affaires brut",

                        data:
                            caMois,

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
                                        return formatAr(
                                            value
                                        );
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

    beneficeChartInstance =
        new Chart(
            beneficeCanvas,
            {
                type: "line",

                data: {
                    labels:
                        labelsMois,

                    datasets: [{
                        label: "Bénéfice",

                        data:
                            beneficeMois,

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
                                        return formatAr(
                                            value
                                        );
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

function detruireAnciensGraphiques() {

    if (destinationChartInstance) {

        destinationChartInstance.destroy();
        destinationChartInstance = null;
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

document.addEventListener(
    "DOMContentLoaded",
    function () {

        const boutonFiltrer =
            document.querySelector(
                ".btn-filter"
            );

        if (boutonFiltrer) {

            boutonFiltrer.addEventListener(
                "click",
                function () {

                    const champDebut =
                        document.querySelector(
                            ".date-debut"
                        );

                    const champFin =
                        document.querySelector(
                            ".date-fin"
                        );

                    const dateDebut =
                        champDebut
                        ? champDebut.value
                        : "";

                    const dateFin =
                        champFin
                        ? champFin.value
                        : "";

                    if (
                        !dateDebut
                        || !dateFin
                    ) {

                        alert(
                            "Veuillez sélectionner une date de début et une date de fin."
                        );

                        return;
                    }

                    if (
                        dateDebut > dateFin
                    ) {

                        alert(
                            "La date de début doit être antérieure ou égale à la date de fin."
                        );

                        return;
                    }

                    chargerDonneesMois(
                        dateDebut,
                        dateFin
                    );
                }
            );
        }

        chargerDonneesMois(
            null,
            null
        );
    }
);