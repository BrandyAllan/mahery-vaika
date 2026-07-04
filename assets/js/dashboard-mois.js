const labelsMois = ["S1", "S2", "S3", "S4"];

const destinationsMois = {
    labels: ["Tamatave", "Majunga", "Antsirabe", "Fianarantsoa", "Tuléar"],
    values: [38, 28, 16, 11, 7]
};

const caMois = [8200000, 9500000, 11200000, 10800000];
const beneficeMois = [2400000, 2900000, 3500000, 3200000];

function formatAr(value) {
    return value.toLocaleString("fr-FR") + " Ar";
}

new Chart(document.getElementById("destinationChart"), {
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

new Chart(document.getElementById("caChart"), {
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

new Chart(document.getElementById("beneficeChart"), {
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

document.querySelector(".btn-filter").addEventListener("click", function () {
    alert("Filtre dashboard mensuel à connecter avec JSP/AJAX.");
});