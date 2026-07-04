const labelsJour = ["06h", "08h", "10h", "12h", "14h", "16h", "18h"];

const destinationsJour = {
    labels: ["Tamatave", "Majunga", "Antsirabe", "Fianarantsoa", "Tuléar"],
    values: [43, 25, 15, 10, 7]
};

const caJour = [300000, 500000, 800000, 1200000, 1600000, 2100000, 2500000];
const beneficeJour = [80000, 150000, 240000, 350000, 500000, 700000, 850000];

function formatAr(value) {
    return value.toLocaleString("fr-FR") + " Ar";
}

new Chart(document.getElementById("destinationChart"), {
    type: "doughnut",
    data: {
        labels: destinationsJour.labels,
        datasets: [{
            data: destinationsJour.values,
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
        labels: labelsJour,
        datasets: [{
            label: "Chiffre d'affaires brut",
            data: caJour,
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
        labels: labelsJour,
        datasets: [{
            label: "Bénéfice",
            data: beneficeJour,
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
    alert("Filtre dashboard du jour à connecter avec JSP/AJAX.");
});