let labelsSemaine = ["Lun", "Mar", "Mer", "Jeu", "Ven", "Sam", "Dim"];
let destinationsSemaine = {
    labels: ["Tamatave", "Majunga", "Antsirabe", "Fianarantsoa", "Tuléar"],
    values: [40, 26, 14, 12, 8]
};
let caSemaine = [1200000, 1500000, 1800000, 1300000, 2100000, 2500000, 2300000];
let beneficeSemaine = [350000, 420000, 500000, 390000, 700000, 850000, 760000];

// Références aux graphiques pour mise à jour dynamique
let chartDestination = null;
let chartCA = null;
let chartBenefice = null;

function formatAr(value) {
    return value.toLocaleString("fr-FR") + " Ar";
}

/**
 * Récupère les données de réservations par semaine depuis le serveur
 * @param {string} dateDebut - Date de début au format YYYY-MM-DD (optionnel)
 * @param {string} dateFin - Date de fin au format YYYY-MM-DD (optionnel)
 */
async function chargerDonneesSemaine(dateDebut = null, dateFin = null) {
    try {
        let url = "../traitement/dashboard/donnees-semaine.jsp";
        
        if (dateDebut && dateFin) {
            url += "?dateDebut=" + dateDebut + "&dateFin=" + dateFin;
        }

        const response = await fetch(url);
        
        if (!response.ok) {
            throw new Error("Erreur lors de la récupération des données");
        }

        const donnees = await response.json();

        // Mettre à jour les données globales
        labelsSemaine = donnees.labels.semaine;
        caSemaine = donnees.data.caSemaine;
        beneficeSemaine = donnees.data.beneficeSemaine;
        destinationsSemaine = donnees.destinations;

        // Mettre à jour les graphiques
        mettreAJourGraphiques();

    } catch (erreur) {
        console.error("Erreur:", erreur);
        alert("Erreur lors du chargement des données: " + erreur.message);
    }
}

/**
 * Recrée tous les graphiques avec les données actuelles
 */
function mettreAJourGraphiques() {
    // Détruire les anciens graphiques s'ils existent
    if (chartDestination) chartDestination.destroy();
    if (chartCA) chartCA.destroy();
    if (chartBenefice) chartBenefice.destroy();

    // Graphique Destinations
    chartDestination = new Chart(document.getElementById("destinationChart"), {
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

    // Graphique CA
    chartCA = new Chart(document.getElementById("caChart"), {
        type: "bar",
        data: {
            labels: labelsSemaine,
            datasets: [{
                label: "Chiffre d'affaires brut",
                data: caSemaine,
                borderWidth: 1,
                borderRadius: 6,
                backgroundColor: 'rgba(75, 192, 192, 0.6)',
                borderColor: 'rgba(75, 192, 192, 1)'
            }]
        },
        options: {
            responsive: true,
            scales: {
                y: {
                    ticks: {
                        callback: value => formatAr(value)
                    }
                }
            }
        }
    });

    // Graphique Bénéfice
    chartBenefice = new Chart(document.getElementById("beneficeChart"), {
        type: "line",
        data: {
            labels: labelsSemaine,
            datasets: [{
                label: "Bénéfice",
                data: beneficeSemaine,
                tension: 0.35,
                fill: true,
                borderWidth: 3,
                backgroundColor: 'rgba(153, 102, 255, 0.1)',
                borderColor: 'rgba(153, 102, 255, 1)'
            }]
        },
        options: {
            responsive: true,
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

// Initialiser les graphiques au chargement
document.addEventListener("DOMContentLoaded", function() {
    mettreAJourGraphiques();

    // Bouton filtrer
    const btnFilter = document.querySelector(".btn-filter");
    if (btnFilter) {
        btnFilter.addEventListener("click", function () {
            const dateDebut = document.querySelector(".date-debut").value;
            const dateFin = document.querySelector(".date-fin").value;

            if (!dateDebut || !dateFin) {
                alert("Veuillez sélectionner les deux dates");
                return;
            }

            // Valider que la date de début est avant la date de fin
            if (new Date(dateDebut) > new Date(dateFin)) {
                alert("La date de début doit être avant la date de fin");
                return;
            }

            // Charger les données pour la période sélectionnée
            chargerDonneesSemaine(dateDebut, dateFin);
        });
    }
});