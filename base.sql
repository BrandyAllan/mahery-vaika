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