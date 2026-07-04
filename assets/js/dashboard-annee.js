const labelsAnnee = ["Jan", "Fév", "Mar", "Avr", "Mai", "Juin", "Juil", "Août", "Sep", "Oct", "Nov", "Déc"];

const destinationsAnnee = {
    labels: ["Tamatave", "Majunga", "Antsirabe", "Fianarantsoa", "Tuléar"],
    values: [41, 22, 18, 12, 7]
};

const caAnnee = [32000000, 35000000, 37000000, 39000000, 42000000, 45000000, 47000000, 49000000, 51000000, 53000000, 56000000, 60000000];
const beneficeAnnee = [9000000, 10200000, 11000000, 11800000, 13000000, 14200000, 15000000, 15800000, 16400000, 17100000, 18500000, 20000000];

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