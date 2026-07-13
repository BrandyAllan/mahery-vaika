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

BEGIN;

-- ============================================================
-- 1. SUPPRESSION DES DONNÉES
-- Les rôles et les utilisateurs sont conservés.
-- ============================================================

DELETE FROM paiement;
DELETE FROM reservation;
DELETE FROM entretien;
DELETE FROM depense;
DELETE FROM depart;
DELETE FROM chauffeur;
DELETE FROM trajet;
DELETE FROM ville;
DELETE FROM vehicule;

-- Réinitialisation des séquences
SELECT setval(pg_get_serial_sequence('paiement', 'id_paiement'), 1, false);
SELECT setval(pg_get_serial_sequence('reservation', 'id_reservation'), 1, false);
SELECT setval(pg_get_serial_sequence('entretien', 'id_entretien'), 1, false);
SELECT setval(pg_get_serial_sequence('depense', 'id_depense'), 1, false);
SELECT setval(pg_get_serial_sequence('depart', 'id_depart'), 1, false);
SELECT setval(pg_get_serial_sequence('chauffeur', 'id_chauffeur'), 1, false);
SELECT setval(pg_get_serial_sequence('trajet', 'id_trajet'), 1, false);
SELECT setval(pg_get_serial_sequence('ville', 'id_ville'), 1, false);
SELECT setval(pg_get_serial_sequence('vehicule', 'id_vehicule'), 1, false);

-- ============================================================
-- 2. VILLES
-- ============================================================

INSERT INTO ville (nom_ville, province, actif)
VALUES
('Antananarivo', 'Analamanga', TRUE),
('Toamasina', 'Atsinanana', TRUE),
('Antsirabe', 'Vakinankaratra', TRUE),
('Fianarantsoa', 'Haute Matsiatra', TRUE),
('Mahajanga', 'Boeny', TRUE),
('Toliara', 'Atsimo-Andrefana', TRUE),
('Morondava', 'Menabe', TRUE),
('Sambava', 'Sava', TRUE);

-- ============================================================
-- 3. VÉHICULES
-- ============================================================

INSERT INTO vehicule (
    immatriculation,
    marque,
    modele,
    capacite,
    kilometrage_actuel,
    etat,
    date_expiration_assurance
)
VALUES
('1234 TAB', 'Mercedes-Benz', 'Sprinter', 22, 142500, 'ACTIF', '2027-03-15'),
('5678 TBA', 'Toyota', 'Coaster', 30, 184000, 'ACTIF', '2027-05-20'),
('9012 TAC', 'Hyundai', 'County', 28, 159800, 'ACTIF', '2027-02-10'),
('3456 TAD', 'Nissan', 'Civilian', 25, 171300, 'ACTIF', '2026-12-30');

-- ============================================================
-- 4. CHAUFFEURS
-- ============================================================

INSERT INTO chauffeur (
    nom,
    prenom,
    telephone,
    numero_permis,
    date_expiration_permis,
    id_vehicule_habituel,
    actif
)
VALUES
('Rasoa', 'Michel', '0341112233', 'P-001-MG', '2027-01-12', 1, TRUE),
('Rakotomalala', 'Fetra', '0332223344', 'P-002-MG', '2027-11-05', 2, TRUE),
('Andrianina', 'Tojo', '0323334455', 'P-003-MG', '2027-08-18', 3, TRUE),
('Raveloson', 'Nary', '0344445566', 'P-004-MG', '2027-10-01', 4, TRUE);

-- ============================================================
-- 5. TRAJETS
-- ============================================================

INSERT INTO trajet (
    id_ville_depart,
    id_ville_arrivee,
    distance_km,
    duree_estimee,
    tarif_base,
    actif
)
VALUES
(1, 2, 360.00, '8h', 45000, TRUE),
(1, 3, 170.00, '4h', 25000, TRUE),
(1, 4, 410.00, '9h', 50000, TRUE),
(1, 5, 560.00, '11h', 65000, TRUE),
(1, 6, 930.00, '18h', 90000, TRUE),
(1, 7, 700.00, '14h', 80000, TRUE),
(2, 1, 360.00, '8h', 45000, TRUE),
(4, 1, 410.00, '9h', 50000, TRUE),
(5, 1, 560.00, '11h', 65000, TRUE),
(3, 1, 170.00, '4h', 25000, TRUE);

-- ============================================================
-- 6. DÉPARTS
-- Trois départs par jour du 01/05/2025 au 15/07/2026.
-- ============================================================

WITH jours AS (
    SELECT
        date_jour::date AS date_depart,
        ROW_NUMBER() OVER (ORDER BY date_jour)::int AS numero_jour
    FROM generate_series(
        '2025-05-01'::date,
        '2026-07-15'::date,
        interval '1 day'
    ) AS date_jour
),
creneaux AS (
    SELECT *
    FROM (
        VALUES
            (0, '06:30'::time),
            (1, '09:00'::time),
            (2, '18:00'::time)
    ) AS c(numero_creneau, heure_depart)
)
INSERT INTO depart (
    id_trajet,
    id_vehicule,
    id_chauffeur,
    date_depart,
    heure_depart,
    statut
)
SELECT
    ((j.numero_jour + c.numero_creneau - 1) % 10) + 1,
    c.numero_creneau + 1,
    c.numero_creneau + 1,
    j.date_depart,
    c.heure_depart,
    CASE
        WHEN j.date_depart < '2026-07-11' THEN 'TERMINE'
        WHEN j.date_depart = '2026-07-11'
             AND c.numero_creneau = 0 THEN 'EN_COURS'
        ELSE 'PLANIFIE'
    END
FROM jours j
CROSS JOIN creneaux c
ORDER BY j.date_depart, c.heure_depart;

-- ============================================================
-- 7. RÉSERVATIONS
-- Occupation variable selon le véhicule, la saison et le jour.
-- ============================================================

WITH caissiers AS (
    SELECT ARRAY_AGG(u.id_utilisateur ORDER BY u.id_utilisateur) AS ids
    FROM utilisateur u
    JOIN role r ON r.id_role = u.id_role
    WHERE LOWER(r.nom_role) = 'caissier'
      AND u.actif = TRUE
),
depart_occupation AS (
    SELECT
        d.id_depart,
        d.date_depart,
        v.capacite,
        LEAST(
            v.capacite,
            GREATEST(
                7,
                9
                + ((d.id_depart * 7) % 10)
                + CASE
                    WHEN EXTRACT(MONTH FROM d.date_depart) IN (6, 7, 8, 12)
                        THEN 5
                    ELSE 0
                  END
                + CASE
                    WHEN EXTRACT(ISODOW FROM d.date_depart) IN (5, 6, 7)
                        THEN 3
                    ELSE 0
                  END
            )
        )::int AS nombre_places
    FROM depart d
    JOIN vehicule v ON v.id_vehicule = d.id_vehicule
)
INSERT INTO reservation (
    numero_reservation,
    id_depart,
    nom_passager,
    prenom_passager,
    telephone_passager,
    numero_siege,
    statut,
    motif_annulation,
    date_reservation,
    id_caissier
)
SELECT
    'RES-' ||
    TO_CHAR(d.date_depart, 'YYYYMMDD') ||
    '-' ||
    LPAD(d.id_depart::text, 5, '0') ||
    '-' ||
    LPAD(s.numero_siege::text, 2, '0'),

    d.id_depart,

    CASE (d.id_depart + s.numero_siege) % 12
        WHEN 0 THEN 'Rakoto'
        WHEN 1 THEN 'Rabe'
        WHEN 2 THEN 'Andry'
        WHEN 3 THEN 'Rasolofoniaina'
        WHEN 4 THEN 'Randrianarivelo'
        WHEN 5 THEN 'Ravelo'
        WHEN 6 THEN 'Rakotobe'
        WHEN 7 THEN 'Rajaonarison'
        WHEN 8 THEN 'Razafindrakoto'
        WHEN 9 THEN 'Rakotondramanana'
        WHEN 10 THEN 'Randriamihaja'
        ELSE 'Andriamampianina'
    END,

    CASE (d.id_depart + s.numero_siege) % 10
        WHEN 0 THEN 'Lova'
        WHEN 1 THEN 'Miora'
        WHEN 2 THEN 'Kanto'
        WHEN 3 THEN 'Haja'
        WHEN 4 THEN 'Nina'
        WHEN 5 THEN 'Sitraka'
        WHEN 6 THEN 'Faly'
        WHEN 7 THEN 'Mamy'
        WHEN 8 THEN 'Tahina'
        ELSE 'Aina'
    END,

    '+26134' ||
    LPAD(
        ((d.id_depart * 37 + s.numero_siege * 13) % 10000000)::text,
        7,
        '0'
    ),

    s.numero_siege,

    CASE
        WHEN (d.id_depart + s.numero_siege) % 19 = 0
            THEN 'ANNULEE'
        ELSE 'CONFIRMEE'
    END,

    CASE
        WHEN (d.id_depart + s.numero_siege) % 19 = 0
            THEN 'Annulation demandée par le passager'
        ELSE NULL
    END,

    GREATEST(
        TIMESTAMP '2025-05-01 08:00:00',
        d.date_depart::timestamp
        - ((s.numero_siege % 14) + 1) * interval '1 day'
        + (s.numero_siege % 9) * interval '1 hour'
    ),

    CASE
        WHEN array_length(c.ids, 1) IS NULL THEN
            (
                SELECT MIN(id_utilisateur)
                FROM utilisateur
                WHERE actif = TRUE
            )
        ELSE
            c.ids[
                1 + (
                    (d.id_depart + s.numero_siege)
                    % array_length(c.ids, 1)
                )
            ]
    END
FROM depart_occupation d
CROSS JOIN caissiers c
CROSS JOIN LATERAL generate_series(
    1,
    d.nombre_places
) AS s(numero_siege);

-- ============================================================
-- 8. PAIEMENTS
-- Uniquement pour les réservations confirmées.
-- ============================================================

INSERT INTO paiement (
    id_reservation,
    montant,
    mode_paiement,
    statut,
    date_paiement
)
SELECT
    r.id_reservation,
    t.tarif_base,
    CASE r.id_reservation % 4
        WHEN 0 THEN 'ESPECES'
        WHEN 1 THEN 'MVOLA'
        WHEN 2 THEN 'ORANGE_MONEY'
        ELSE 'AIRTEL_MONEY'
    END,
    'PAYE',
    r.date_reservation + interval '2 hours'
FROM reservation r
JOIN depart d ON d.id_depart = r.id_depart
JOIN trajet t ON t.id_trajet = d.id_trajet
WHERE r.statut = 'CONFIRMEE';

-- ============================================================
-- 9. DÉPENSES DE CARBURANT
-- Une dépense pour chaque départ terminé ou en cours.
-- ============================================================

INSERT INTO depense (
    type_depense,
    description,
    montant,
    date_depense,
    id_vehicule,
    id_utilisateur
)
SELECT
    'Carburant',
    'Carburant pour le départ ' || d.id_depart ||
    ' - trajet ' || vd.nom_ville || ' vers ' || va.nom_ville,

    ROUND(
        (
            t.distance_km * 720
            + (d.id_vehicule * 12500)
        )::numeric,
        2
    ),

    d.date_depart,
    d.id_vehicule,

    (
        SELECT MIN(u.id_utilisateur)
        FROM utilisateur u
        JOIN role r ON r.id_role = u.id_role
        WHERE LOWER(r.nom_role) IN ('admin', 'superviseur')
          AND u.actif = TRUE
    )
FROM depart d
JOIN trajet t ON t.id_trajet = d.id_trajet
JOIN ville vd ON vd.id_ville = t.id_ville_depart
JOIN ville va ON va.id_ville = t.id_ville_arrivee
WHERE d.statut IN ('TERMINE', 'EN_COURS');

-- ============================================================
-- 10. SALAIRES MENSUELS DES CHAUFFEURS
-- ============================================================

WITH mois AS (
    SELECT mois::date AS premier_jour
    FROM generate_series(
        '2025-05-01'::date,
        '2026-07-01'::date,
        interval '1 month'
    ) AS mois
)
INSERT INTO depense (
    type_depense,
    description,
    montant,
    date_depense,
    id_vehicule,
    id_utilisateur
)
SELECT
    'Salaire chauffeur',
    'Salaire mensuel de ' || c.nom || ' ' || COALESCE(c.prenom, ''),
    650000 + (c.id_chauffeur * 25000),

    CASE
        WHEN m.premier_jour = '2026-07-01'
            THEN '2026-07-10'::date
        ELSE
            (m.premier_jour + interval '24 days')::date
    END,

    c.id_vehicule_habituel,

    (
        SELECT MIN(u.id_utilisateur)
        FROM utilisateur u
        JOIN role r ON r.id_role = u.id_role
        WHERE LOWER(r.nom_role) = 'admin'
          AND u.actif = TRUE
    )
FROM mois m
CROSS JOIN chauffeur c
WHERE c.actif = TRUE;

-- ============================================================
-- 11. AUTRES DÉPENSES MENSUELLES
-- ============================================================

WITH mois AS (
    SELECT
        mois::date AS premier_jour,
        ROW_NUMBER() OVER (ORDER BY mois)::int AS numero
    FROM generate_series(
        '2025-05-01'::date,
        '2026-07-01'::date,
        interval '1 month'
    ) AS mois
)
INSERT INTO depense (
    type_depense,
    description,
    montant,
    date_depense,
    id_vehicule,
    id_utilisateur
)
SELECT
    CASE m.numero % 3
        WHEN 0 THEN 'Péage'
        WHEN 1 THEN 'Nettoyage'
        ELSE 'Administration'
    END,

    CASE m.numero % 3
        WHEN 0 THEN 'Frais de péage et de route'
        WHEN 1 THEN 'Nettoyage mensuel de la flotte'
        ELSE 'Frais administratifs mensuels'
    END,

    CASE m.numero % 3
        WHEN 0 THEN 185000
        WHEN 1 THEN 140000
        ELSE 320000
    END,

    CASE
        WHEN m.premier_jour = '2026-07-01'
            THEN '2026-07-08'::date
        ELSE
            (m.premier_jour + interval '9 days')::date
    END,

    NULL,

    (
        SELECT MIN(u.id_utilisateur)
        FROM utilisateur u
        JOIN role r ON r.id_role = u.id_role
        WHERE LOWER(r.nom_role) = 'admin'
          AND u.actif = TRUE
    )
FROM mois m;

-- ============================================================
-- 12. ENTRETIENS
-- ============================================================

WITH dates_entretien AS (
    SELECT
        date_entretien::date,
        ROW_NUMBER() OVER (ORDER BY date_entretien)::int AS numero
    FROM generate_series(
        '2025-05-15'::date,
        '2026-07-15'::date,
        interval '2 months'
    ) AS date_entretien
)
INSERT INTO entretien (
    id_vehicule,
    date_entretien,
    type_entretien,
    cout,
    kilometrage,
    date_prochain_entretien,
    remarque
)
SELECT
    v.id_vehicule,
    d.date_entretien,

    CASE (d.numero + v.id_vehicule) % 4
        WHEN 0 THEN 'Vidange'
        WHEN 1 THEN 'Pneumatiques'
        WHEN 2 THEN 'Contrôle des freins'
        ELSE 'Contrôle général'
    END,

    CASE (d.numero + v.id_vehicule) % 4
        WHEN 0 THEN 180000
        WHEN 1 THEN 420000
        WHEN 2 THEN 240000
        ELSE 150000
    END,

    80000 + d.numero * 6500 + v.id_vehicule * 3200,

    (d.date_entretien + interval '3 months')::date,

    'Entretien périodique du véhicule ' || v.immatriculation
FROM dates_entretien d
CROSS JOIN vehicule v;

-- Ajout des coûts d'entretien dans les dépenses
INSERT INTO depense (
    type_depense,
    description,
    montant,
    date_depense,
    id_vehicule,
    id_utilisateur
)
SELECT
    'Entretien',
    e.type_entretien || ' - véhicule ' || v.immatriculation,
    e.cout,
    e.date_entretien,
    e.id_vehicule,

    (
        SELECT MIN(u.id_utilisateur)
        FROM utilisateur u
        JOIN role r ON r.id_role = u.id_role
        WHERE LOWER(r.nom_role) IN ('admin', 'superviseur')
          AND u.actif = TRUE
    )
FROM entretien e
JOIN vehicule v ON v.id_vehicule = e.id_vehicule;

COMMIT;