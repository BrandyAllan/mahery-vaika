const labelsSemaine = ["Lun", "Mar", "Mer", "Jeu", "Ven", "Sam", "Dim"];

const destinationsSemaine = {
    labels: ["Tamatave", "Majunga", "Antsirabe", "Fianarantsoa", "Tuléar"],
    values: [40, 26, 14, 12, 8]
};

const caSemaine = [1200000, 1500000, 1800000, 1300000, 2100000, 2500000, 2300000];
const beneficeSemaine = [350000, 420000, 500000, 390000, 700000, 850000, 760000];

function formatAr(value) {
    return value.toLocaleString("fr-FR") + " Ar";
}

new Chart(document.getElementById("destinationChart"), {
    type: "doughnut",
    data: {
        labels: destinationsSemaine.labels,
        datasets: [{
            data: destinationsSemaine.values,
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
        labels: labelsSemaine,
        datasets: [{
            label: "Chiffre d'affaires brut",
            data: caSemaine,
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
        labels: labelsSemaine,
        datasets: [{
            label: "Bénéfice",
            data: beneficeSemaine,
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
    alert("Filtre dashboard semaine à connecter avec JSP/AJAX.");
});