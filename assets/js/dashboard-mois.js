function formatAr(value) {
    return value.toLocaleString("fr-FR") + " Ar";
}

let destinationChartInstance = null;
let caChartInstance = null;
let beneficeChartInstance = null;

function chargerDonneesMois(dateDebut, dateFin) {
    let url = "../traitement/dashboard/dashboard-mois-data.jsp";
    const params = [];

    if (dateDebut) params.push("date_debut=" + encodeURIComponent(dateDebut));
    if (dateFin) params.push("date_fin=" + encodeURIComponent(dateFin));
    if (params.length > 0) url += "?" + params.join("&");

    fetch(url)
        .then(response => response.json())
        .then(data => {
            if (data.erreur) {
                console.error("Erreur dashboard mensuel :", data.erreur);
                return;
            }
            afficherGraphiquesMois(data);
        })
        .catch(error => console.error("Erreur chargement dashboard mensuel :", error));
}

function afficherGraphiquesMois(data) {
    const labelsMois = data.labels || [];
    const caMois = data.ca || [];
    const beneficeMois = data.benefice || [];
    const destinationsMois = data.destinations || { labels: [], values: [] };

    if (destinationChartInstance) destinationChartInstance.destroy();
    if (caChartInstance) caChartInstance.destroy();
    if (beneficeChartInstance) beneficeChartInstance.destroy();

    destinationChartInstance = new Chart(document.getElementById("destinationChart"), {
        type: "doughnut",
        data: {
            labels: destinationsMois.labels,
            datasets: [{
                data: destinationsMois.values,
                borderWidth: 2
            }]
        },
        options: {
            plugins: {
                legend: { position: "bottom" },
                tooltip: {
                    callbacks: {
                        label: ctx => ctx.label + " : " + ctx.raw + "%"
                    }
                }
            }
        }
    });

    caChartInstance = new Chart(document.getElementById("caChart"), {
        type: "bar",
        data: {
            labels: labelsMois,
            datasets: [{
                label: "Chiffre d'affaires brut",
                data: caMois,
                borderWidth: 1,
                borderRadius: 6
            }]
        },
        options: {
            scales: {
                y: {
                    ticks: {
                        callback: value => formatAr(value)
                    }
                }
            }
        }
    });

    beneficeChartInstance = new Chart(document.getElementById("beneficeChart"), {
        type: "line",
        data: {
            labels: labelsMois,
            datasets: [{
                label: "Bénéfice",
                data: beneficeMois,
                tension: 0.35,
                fill: true,
                borderWidth: 3
            }]
        },
        options: {
            scales: {
                y: {
                    ticks: {
                        callback: value => formatAr(value)
                    }
                }
            }
        }
    });
}

document.querySelector(".btn-filter").addEventListener("click", function () {
    const dateDebut = document.querySelector(".date-debut").value;
    const dateFin = document.querySelector(".date-fin").value;
    chargerDonneesMois(dateDebut, dateFin);
});

chargerDonneesMois(null, null);
