--- TSY AZO OVAINA

CREATE DATABASE mahery_vaika;

CREATE TABLE role (
    id_role SERIAL PRIMARY KEY,
    nom_role VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE utilisateur (
    id_utilisateur SERIAL PRIMARY KEY,

    id_role INT NOT NULL REFERENCES role(id_role),

    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100),

    telephone VARCHAR(30),
    email VARCHAR(150),

    identifiant VARCHAR(100) NOT NULL UNIQUE,
    mot_de_passe VARCHAR(255) NOT NULL,

    date_embauche DATE NOT NULL,
    date_retrait DATE,

    actif BOOLEAN DEFAULT TRUE,

    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE vehicule (
    id_vehicule SERIAL PRIMARY KEY,

    immatriculation VARCHAR(50) NOT NULL UNIQUE,

    marque VARCHAR(100) NOT NULL,
    modele VARCHAR(100) NOT NULL,

    capacite INT NOT NULL,

    kilometrage_actuel INT DEFAULT 0,

    etat VARCHAR(30) DEFAULT 'ACTIF',

    date_expiration_assurance DATE
);

CREATE TABLE chauffeur (
    id_chauffeur SERIAL PRIMARY KEY,

    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100),

    telephone VARCHAR(30),

    numero_permis VARCHAR(100) NOT NULL UNIQUE,

    date_expiration_permis DATE,

    id_vehicule_habituel INT REFERENCES vehicule(id_vehicule),

    actif BOOLEAN DEFAULT TRUE
);

CREATE TABLE ville (
    id_ville SERIAL PRIMARY KEY,

    nom_ville VARCHAR(100) NOT NULL UNIQUE,

    province VARCHAR(100),

    actif BOOLEAN DEFAULT TRUE
);

CREATE TABLE trajet (
    id_trajet SERIAL PRIMARY KEY,

    id_ville_depart INT NOT NULL REFERENCES ville(id_ville),

    id_ville_arrivee INT NOT NULL REFERENCES ville(id_ville),

    distance_km NUMERIC(10,2),

    duree_estimee VARCHAR(50),

    tarif_base NUMERIC(12,2) NOT NULL,

    actif BOOLEAN DEFAULT TRUE,

    CONSTRAINT ville_differente
    CHECK (id_ville_depart <> id_ville_arrivee)
);

CREATE TABLE depart (
    id_depart SERIAL PRIMARY KEY,

    id_trajet INT NOT NULL REFERENCES trajet(id_trajet),

    id_vehicule INT NOT NULL REFERENCES vehicule(id_vehicule),

    id_chauffeur INT NOT NULL REFERENCES chauffeur(id_chauffeur),

    date_depart DATE NOT NULL,

    heure_depart TIME NOT NULL,

    statut VARCHAR(30) DEFAULT 'PLANIFIE'
);

CREATE TABLE reservation (
    id_reservation SERIAL PRIMARY KEY,

    numero_reservation VARCHAR(50) UNIQUE NOT NULL,

    id_depart INT NOT NULL REFERENCES depart(id_depart),

    nom_passager VARCHAR(100) NOT NULL,
    prenom_passager VARCHAR(100),

    telephone_passager VARCHAR(30),

    numero_siege INT NOT NULL,

    statut VARCHAR(30) DEFAULT 'CONFIRMEE',

    motif_annulation TEXT,

    date_reservation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    id_caissier INT REFERENCES utilisateur(id_utilisateur),

    UNIQUE(id_depart, numero_siege)
);

CREATE TABLE paiement (
    id_paiement SERIAL PRIMARY KEY,

    id_reservation INT NOT NULL REFERENCES reservation(id_reservation),

    montant NUMERIC(12,2) NOT NULL,

    mode_paiement VARCHAR(50) NOT NULL,

    statut VARCHAR(30) DEFAULT 'PAYE',

    date_paiement TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE depense (
    id_depense SERIAL PRIMARY KEY,

    type_depense VARCHAR(100) NOT NULL,

    description TEXT,

    montant NUMERIC(12,2) NOT NULL,

    date_depense DATE NOT NULL,

    id_vehicule INT REFERENCES vehicule(id_vehicule),

    id_utilisateur INT REFERENCES utilisateur(id_utilisateur)
);

CREATE TABLE entretien (
    id_entretien SERIAL PRIMARY KEY,

    id_vehicule INT NOT NULL REFERENCES vehicule(id_vehicule),

    date_entretien DATE NOT NULL,

    type_entretien VARCHAR(100),

    cout NUMERIC(12,2),

    kilometrage INT,

    date_prochain_entretien DATE,

    remarque TEXT
);

INSERT INTO role (nom_role) VALUES
('Admin'),
('Caissier'),
('Superviseur');

INSERT INTO utilisateur
(id_role, nom, prenom, telephone, email, identifiant, mot_de_passe, date_embauche, actif)
VALUES
(1, 'Rakoto', 'Jean', '0341234567', 'admin@maheryvaika.mg', 'admin', 'admin123', '2024-01-10', TRUE),
(2, 'Rabe', 'Mialy', '0324567890', 'mialy@maheryvaika.mg', 'mialy', 'mialy123', '2024-03-15', TRUE),
(2, 'Andry', 'Tiana', '0339876543', 'tiana@maheryvaika.mg', 'tiana', 'tiana123', '2024-06-01', TRUE),
(3, 'Randria', 'Hery', '0349988776', 'hery@maheryvaika.mg', 'hery', 'hery123', '2024-02-20', TRUE);

INSERT INTO vehicule
(immatriculation, marque, modele, capacite, kilometrage_actuel, etat, date_expiration_assurance)
VALUES
('1234 TAB', 'Mercedes-Benz', 'Sprinter', 22, 85000, 'ACTIF', '2026-03-15'),
('5678 TBA', 'Toyota', 'Coaster', 30, 120000, 'ACTIF', '2026-05-20'),
('9012 TAC', 'Hyundai', 'County', 28, 98000, 'ACTIF', '2026-02-10'),
('3456 TAD', 'Nissan', 'Civilian', 25, 110000, 'MAINTENANCE', '2025-12-30');

INSERT INTO chauffeur
(nom, prenom, telephone, numero_permis, date_expiration_permis, id_vehicule_habituel, actif)
VALUES
('Rasoa', 'Michel', '0341112233', 'P-001-MG', '2027-01-12', 1, TRUE),
('Rakotomalala', 'Fetra', '0332223344', 'P-002-MG', '2026-11-05', 2, TRUE),
('Andrianina', 'Tojo', '0323334455', 'P-003-MG', '2026-08-18', 3, TRUE),
('Raveloson', 'Nary', '0344445566', 'P-004-MG', '2025-10-01', 4, TRUE);

INSERT INTO ville
(nom_ville, province, actif)
VALUES
('Antananarivo', 'Analamanga', TRUE),
('Toamasina', 'Atsinanana', TRUE),
('Antsirabe', 'Vakinankaratra', TRUE),
('Fianarantsoa', 'Haute Matsiatra', TRUE),
('Mahajanga', 'Boeny', TRUE),
('Toliara', 'Atsimo-Andrefana', TRUE),
('Morondava', 'Menabe', TRUE),
('Sambava', 'Sava', TRUE);

INSERT INTO trajet
(id_ville_depart, id_ville_arrivee, distance_km, duree_estimee, tarif_base, actif)
VALUES
(1, 2, 360.00, '8h', 45000, TRUE),
(1, 3, 170.00, '4h', 25000, TRUE),
(1, 4, 410.00, '9h', 50000, TRUE),
(1, 5, 560.00, '11h', 65000, TRUE),
(3, 4, 240.00, '5h', 30000, TRUE),
(1, 7, 700.00, '14h', 80000, TRUE),
(2, 1, 360.00, '8h', 45000, TRUE),
(4, 1, 410.00, '9h', 50000, TRUE);

INSERT INTO depart
(id_trajet, id_vehicule, id_chauffeur, date_depart, heure_depart, statut)
VALUES
(1, 1, 1, '2026-07-05', '07:00', 'PLANIFIE'),
(2, 2, 2, '2026-07-05', '08:30', 'PLANIFIE'),
(3, 3, 3, '2026-07-06', '06:30', 'PLANIFIE'),
(4, 1, 1, '2026-07-06', '18:00', 'PLANIFIE'),
(5, 2, 2, '2026-07-07', '09:00', 'PLANIFIE'),
(7, 3, 3, '2026-07-08', '07:00', 'PLANIFIE');

INSERT INTO reservation
(numero_reservation, id_depart, nom_passager, prenom_passager, telephone_passager, numero_siege, statut, id_caissier)
VALUES
('RES-20260701-001', 1, 'Rakoto', 'Lova', '+261341112233', 1, 'CONFIRMEE', 2),
('RES-20260701-002', 1, 'Rabe', 'Miora', '+261322223344', 2, 'CONFIRMEE', 2),
('RES-20260701-003', 1, 'Andry', 'Kanto', '+261333334455', 3, 'CONFIRMEE', 3),
('RES-20260701-004', 2, 'Rasolofoniaina', 'Haja', '+261344445566', 5, 'CONFIRMEE', 2),
('RES-20260701-005', 2, 'Randrianarivelo', 'Nina', '+261325556677', 6, 'ANNULEE', 3),
('RES-20260701-006', 3, 'Ravelo', 'Sitraka', '+261336667788', 10, 'CONFIRMEE', 2),
('RES-20260701-007', 4, 'Rakotobe', 'Faly', '+261347778899', 8, 'CONFIRMEE', 3),
('RES-20260701-008', 5, 'Rajaonarison', 'Mamy', '+261328889900', 12, 'CONFIRMEE', 2);

INSERT INTO paiement
(id_reservation, montant, mode_paiement, statut)
VALUES
(1, 45000, 'ESPECES', 'PAYE'),
(2, 45000, 'MVOLA', 'PAYE'),
(3, 45000, 'ORANGE_MONEY', 'PAYE'),
(4, 25000, 'ESPECES', 'PAYE'),
(6, 50000, 'MVOLA', 'PAYE'),
(7, 65000, 'ESPECES', 'PAYE'),
(8, 30000, 'ORANGE_MONEY', 'PAYE');

INSERT INTO depense
(type_depense, description, montant, date_depense, id_utilisateur)
VALUES
('Carburant', 'Gasoil pour Antananarivo - Toamasina', 320000, '2026-07-04', 4),
('Péage', 'Frais de route RN2', 45000, '2026-07-05', 2),
('Entretien', 'Vidange Mercedes Sprinter', 180000, '2026-06-28', 4),
('Nettoyage', 'Nettoyage intérieur véhicule', 30000, '2026-07-01', 3);

INSERT INTO entretien
(id_vehicule, date_entretien, type_entretien, cout, kilometrage, date_prochain_entretien, remarque)
VALUES
(1, '2026-06-28', 'Vidange', 180000, 85000, '2026-09-28', 'Huile moteur et filtres remplacés'),
(2, '2026-06-20', 'Contrôle freins', 120000, 120000, '2026-08-20', 'Plaquettes vérifiées'),
(4, '2026-06-25', 'Réparation moteur', 450000, 110000, '2026-07-15', 'Véhicule en maintenance');