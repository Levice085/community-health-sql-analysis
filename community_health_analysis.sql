/* =======================================================
   PROJECT: Community Health & Nutritional Analysis
   AUTHOR: Levis Kitonge
   DESCRIPTION: Relational database schema creation, mock data 
                insertion, and analytical queries for tracking 
                pediatric health and Minimum Dietary Diversity 
                (MDD) scores across local dispensaries.
   ======================================================= */

/* -------------------------------------------------------
   PART 1: SCHEMA CREATION (DDL)
   ------------------------------------------------------- */

-- 1. Create the facilities table
CREATE TABLE facilities (
    facility_id INT PRIMARY KEY,
    facility_name VARCHAR(100) NOT NULL,
    region VARCHAR(50),
    has_inpatient_care BOOLEAN
);

-- 2. Create the patients table
CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    facility_id INT,
    gender VARCHAR(10),
    date_of_birth DATE,
    FOREIGN KEY (facility_id) REFERENCES facilities(facility_id) 
);

-- 3. Create the nutrition assessments table
CREATE TABLE nutrition_assessments (
    assessment_id INT PRIMARY KEY,
    patient_id INT,
    assessment_date DATE,
    mdd_score INT CHECK (mdd_score >= 0 AND mdd_score <= 8), 
    weight_kg DECIMAL(5,2),
    height_cm DECIMAL(5,2),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

/* -------------------------------------------------------
   PART 2: MOCK DATA INSERTION (DML)
   ------------------------------------------------------- */

-- Insert facilities
INSERT INTO facilities (facility_id, facility_name, region, has_inpatient_care)
VALUES 
    (1, 'GSU Kibra Dispensary', 'Nairobi', TRUE),
    (2, 'Langa Langa Health Centre', 'Nakuru', FALSE),
    (3, 'Makina Clinic', 'Nairobi', FALSE);

-- Insert patients
INSERT INTO patients (patient_id, facility_id, gender, date_of_birth)
VALUES 
    (101, 1, 'Female', '2023-05-14'),
    (102, 1, 'Male', '2024-02-20'),
    (103, 2, 'Female', '2022-11-08'),
    (104, 3, 'Male', '2025-01-30');

-- Insert nutritional assessments (includes a follow-up visit for patient 101)
INSERT INTO nutrition_assessments (assessment_id, patient_id, assessment_date, mdd_score, weight_kg, height_cm)
VALUES 
    (1001, 101, '2026-01-15', 6, 12.5, 88.0),
    (1002, 102, '2026-01-16', 3, 9.2, 75.5),
    (1003, 103, '2026-02-10', 7, 14.1, 95.0),
    (1004, 104, '2026-02-12', 2, 7.8, 71.0),
    (1005, 101, '2026-03-01', 7, 12.8, 88.5); 

/* -------------------------------------------------------
   PART 3: DATA ANALYSIS QUERIES (DQL)
   ------------------------------------------------------- */

-- Q1: The Risk List (Identify patients with an MDD score below 4)
SELECT assessment_id, patient_id, mdd_score
FROM nutrition_assessments
WHERE mdd_score < 4;

-- Q2: Total Assessments (Calculate the baseline total of all assessments)
SELECT COUNT(*) AS total_assessments
FROM nutrition_assessments;

-- Q3: Facility Roster (List registered children for a specific facility using a subquery)
SELECT patient_id, gender, date_of_birth
FROM patients
WHERE facility_id IN (
    SELECT facility_id
    FROM facilities 
    WHERE facility_name = 'GSU Kibra Dispensary'
);

-- Q4: Average Score by Facility (Compare nutritional outcomes across clinics)
SELECT f.facility_name, AVG(n.mdd_score) AS avg_mdd_score 
FROM nutrition_assessments AS n
LEFT JOIN patients AS p
    ON p.patient_id = n.patient_id
LEFT JOIN facilities AS f
    ON f.facility_id = p.facility_id
GROUP BY f.facility_name;

-- Q5: Age at Assessment (Calculate exact age using PostgreSQL date math)
SELECT p.patient_id, AGE(n.assessment_date, p.date_of_birth) AS age_of_patient
FROM patients AS p
LEFT JOIN nutrition_assessments AS n 
    ON p.patient_id = n.patient_id
WHERE n.assessment_id = 1002;

-- Q6: Tracking Improvement (Compare initial and follow-up MDD scores using Window Functions)
SELECT patient_id, assessment_date, mdd_score,
    LEAD(mdd_score, 1, 0) OVER(ORDER BY assessment_date) AS next_mdd_score
FROM nutrition_assessments
WHERE patient_id = 101;