const labelsAnnee = window.labelsAnneesReelles || [];

const destinationsAnnee = window.destinationsReelles || { labels: [], values: [] };
const caAnnee = window.caReelParAnnee || [];
const beneficeAnnee = window.beneficeReelParAnnee || [];

function formatAr(value) {
    return value.toLocaleString("fr-FR") + " Ar";
}

new Chart(document.getElementById("destinationChart"), {
    type: "doughnut",
    data: {
        labels: destinationsAnnee.labels,
        datasets: [{
            data: destinationsAnnee.values,
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

new Chart(document.getElementById("caChart"), {
    type: "bar",
    data: {
        labels: labelsAnnee,
        datasets: [{
            label: "Chiffre d'affaires brut",
            data: caAnnee,
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

new Chart(document.getElementById("beneficeChart"), {
    type: "line",
    data: {
        labels: labelsAnnee,
        datasets: [{
            label: "Bénéfice",
            data: beneficeAnnee,
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

document.querySelector(".btn-filter").addEventListener("click", function () {
    alert("Filtre dashboard annuel à connecter avec JSP/AJAX.");
});