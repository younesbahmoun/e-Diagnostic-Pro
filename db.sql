-- =========================
-- 1. STAFF
-- =========================

-- Generaliste 1 ─────── 0..* Consultation
-- Specialiste 1 ───────── 0..* Creneau
CREATE TABLE staff (
    id BIGSERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('INFIRMIER', 'GENERALISTE', 'SPECIALISTE')),
    specialite VARCHAR(100),
    tarif NUMERIC(10,2)
);

-- =========================
-- 2. PATIENTS
-- =========================

-- - antecedents TEXT = السوابق الطبية ديال المريض، يعني الأمراض أو العمليات اللي كانت عندو من قبل. مثال: "Diabète, hypertension" أو "Opération du genou en 2022".
-- - allergies TEXT = الحوايج اللي عند المريض حساسية منهم، خصوصاً الأدوية. مثال: "Allergie à la pénicilline".
-- - traitements_en_cours TEXT = الأدوية أو العلاج اللي كياخذ المريض حالياً. مثال: "Metformine 500mg".

-- Patient 1  ─────────  0..* SignesVitaux
-- Patient 1 ───────── 0..* FileAttente
-- Patient 1 ───────── 0..* Consultation
CREATE TABLE patients (
id BIGSERIAL PRIMARY KEY,
nom VARCHAR(100) NOT NULL,
prenom VARCHAR(100) NOT NULL,
date_naissance DATE NOT NULL,
    
    numero_securite_sociale VARCHAR(100) UNIQUE NOT NULL,

    telephone VARCHAR(30),
    adresse VARCHAR(255),

    antecedents TEXT,
    allergies TEXT,
    traitements_en_cours TEXT,

    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);

-- =========================
-- 3. SIGNES VITAUX
-- =========================
CREATE TABLE signes_vitaux (
id BIGSERIAL PRIMARY KEY,

    patient_id BIGINT NOT NULL REFERENCES patients(id),

    tension_arterielle VARCHAR(20), -- هي ضغط الدم
    frequence_cardiaque INT, -- عدد ضربات القلب في الدقيقة
    temperature NUMERIC(4,1), -- درجة حرارة الجسم
    frequence_respiratoire INT, --عدد مرات التنفس في الدقيقة 
    poids NUMERIC(5,2), --الوزن بالكيلوغرام
    taille NUMERIC(5,2), --الطول

    date_mesure TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
);

-- =========================
-- 4. FILE D'ATTENTE
-- =========================
CREATE TABLE file_attente (
id BIGSERIAL PRIMARY KEY,

    patient_id BIGINT NOT NULL REFERENCES patients(id),

    heure_arrivee TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    statut VARCHAR(30) DEFAULT 'EN_ATTENTE' CHECK (statut IN ('EN_ATTENTE', 'EN_CONSULTATION', 'TERMINE'))

);

-- =========================
-- 5. CONSULTATIONS
-- =========================
CREATE TABLE consultations (
id BIGSERIAL PRIMARY KEY,

    patient_id BIGINT NOT NULL REFERENCES patients(id),

    generaliste_id BIGINT NOT NULL REFERENCES staff(id),

    motif TEXT NOT NULL,
    observations TEXT, -- شنو لاحظ الطبيب أثناء examination.

    diagnostic TEXT, -- هو المرض أو الحالة اللي شخصها الطبيب
    traitement TEXT, -- العلاج اللي وصف الطبيب

    cout NUMERIC(10,2) DEFAULT 150, -- ثمن consultation.

    statut VARCHAR(50) DEFAULT 'EN_COURS' CHECK (statut IN ('EN_COURS', 'EN_ATTENTE_AVIS_SPECIALISTE', 'TERMINEE')),

    date_consultation TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);

-- =========================
-- 6. CRENEAUX SPECIALISTES
-- =========================
CREATE TABLE creneaux (
id BIGSERIAL PRIMARY KEY,

    specialiste_id BIGINT NOT NULL REFERENCES staff(id),

    debut TIMESTAMP NOT NULL,
    fin TIMESTAMP NOT NULL,

    statut VARCHAR(20) DEFAULT 'DISPONIBLE' CHECK (statut IN ('DISPONIBLE', 'INDISPONIBLE', 'ARCHIVE'))

);

-- =========================
-- 7. DEMANDES D'EXPERTISE
-- =========================
CREATE TABLE demandes_expertise (
id BIGSERIAL PRIMARY KEY,

    consultation_id BIGINT NOT NULL REFERENCES consultations(id),

    specialiste_id BIGINT NOT NULL REFERENCES staff(id),

    creneau_id BIGINT REFERENCES creneaux(id),

    question TEXT NOT NULL,
    donnees_analyses TEXT,

    priorite VARCHAR(20) NOT NULL CHECK (priorite IN ('URGENTE', 'NORMALE', 'NON_URGENTE')),

    statut VARCHAR(30) DEFAULT 'EN_ATTENTE' CHECK (statut IN ('EN_ATTENTE', 'TERMINEE')),

    avis_medical TEXT,
    recommandations TEXT,

    date_demande TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);

-- =========================
-- 8. ACTES TECHNIQUES
-- =========================
CREATE TABLE actes_techniques (
id BIGSERIAL PRIMARY KEY,
nom VARCHAR(150) NOT NULL,
prix NUMERIC(10,2) NOT NULL
);

CREATE TABLE consultation_actes (
    consultation_id BIGINT REFERENCES consultations(id),

    acte_id BIGINT REFERENCES actes_techniques(id),

    PRIMARY KEY (consultation_id, acte_id)
);







-- ================================================= INSERTION ============================================================

-- =========================
-- STAFF
-- =========================
INSERT INTO staff
(nom, prenom, email, password, role, specialite, tarif)
VALUES
('Alaoui', 'Ahmed', 'ahmed@hopital.ma', 'password', 'GENERALISTE', NULL, NULL),

('Benali', 'Sara', 'sara@hopital.ma', 'password', 'INFIRMIER', NULL, NULL),

('Amrani', 'Karim', 'karim@hopital.ma', 'password', 'SPECIALISTE', 'Cardiologie', 300),

('Idrissi', 'Salma', 'salma@hopital.ma', 'password', 'SPECIALISTE', 'Dermatologie', 250),

('Bennani', 'Youssef', 'youssef@hopital.ma', 'password', 'SPECIALISTE', 'Neurologie', 350);


-- =========================
-- PATIENTS
-- =========================

INSERT INTO patients
(nom, prenom, date_naissance, numero_securite_sociale,
 telephone, adresse, antecedents, allergies, traitements_en_cours)
VALUES
('Bahmoun', 'Younes', '2004-07-15', 'CNSS001',
 '0611111111', 'Sale', 'Aucun', 'Aucune', 'Aucun'),

('El Amrani', 'Mohamed', '1990-03-20', 'CNSS002',
 '0622222222', 'Rabat', 'Hypertension', 'Penicilline', 'Traitement hypertension'),

('Bennani', 'Fatima', '1985-11-10', 'CNSS003',
 '0633333333', 'Casablanca', 'Diabete', 'Aucune', 'Insuline');


-- =========================
-- SIGNES VITAUX
-- =========================

INSERT INTO signes_vitaux
(patient_id, tension_arterielle, frequence_cardiaque,
 temperature, frequence_respiratoire, poids, taille)
VALUES
(1, '120/80', 70, 36.8, 16, 58, 170),

(2, '140/90', 82, 37.2, 18, 75, 175),

(3, '130/85', 76, 36.9, 17, 65, 165);


-- =========================
-- FILE D'ATTENTE
-- =========================

INSERT INTO file_attente
(patient_id, statut)
VALUES
(1, 'EN_ATTENTE'),
(2, 'EN_ATTENTE'),
(3, 'EN_ATTENTE');


-- =========================
-- CONSULTATIONS
-- =========================

INSERT INTO consultations
(patient_id, generaliste_id, motif, observations)
VALUES
(1, 1, 'Douleur thoracique', 'Douleur depuis deux jours'),

(2, 1, 'Fatigue et vertiges', 'Patient présente des vertiges'),

(3, 1, 'Maux de tête', 'Céphalées fréquentes');


-- =========================
-- CRENEAUX
-- specialist_id 3 = Cardiologue
-- =========================

INSERT INTO creneaux
(specialiste_id, debut, fin, statut)
VALUES
(3, '2026-10-01 09:00:00', '2026-10-01 09:30:00', 'DISPONIBLE'),

(3, '2026-10-01 09:30:00', '2026-10-01 10:00:00', 'DISPONIBLE'),

(3, '2026-10-01 10:00:00', '2026-10-01 10:30:00', 'DISPONIBLE'),

(3, '2026-10-01 10:30:00', '2026-10-01 11:00:00', 'INDISPONIBLE');


-- =========================
-- DEMANDE EXPERTISE
-- =========================

INSERT INTO demandes_expertise
(consultation_id, specialiste_id, creneau_id,
 question, donnees_analyses, priorite)
VALUES
(
    1,
    3,
    1,
    'La douleur thoracique nécessite-t-elle des examens complémentaires ?',
    'ECG à vérifier',
    'URGENTE'
);


-- =========================
-- ACTES TECHNIQUES
-- =========================

INSERT INTO actes_techniques (nom, prix)
VALUES
('Radiographie', 200),
('Echographie', 300),
('IRM', 1000),
('Electrocardiogramme', 250),
('Acte dermatologique laser', 500),
('Fond oeil', 300),
('Analyse de sang', 150),
('Analyse urine', 100);