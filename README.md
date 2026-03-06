# Community Health & Nutritional Analytics (SQL)
## Project Overview
This project demonstrates the design and analysis of a relational database focused on Public Health and Pediatric Nutrition. Using a real-world scenario—tracking child health metrics at local dispensaries—I built a schema to manage patient demographics, facility locations, and longitudinal nutritional assessments (MDD scores).

The goal of this project was to move beyond basic CRUD operations and perform complex analytical queries that could assist health administrators in identifying at-risk populations and tracking patient improvement over time.

## Database Architecture
The database consists of three primary tables:

facilities: Information on healthcare centers, regions, and service types.

patients: Demographic data for children, linked to their primary facility.

nutrition_assessments: Health metrics including weight, height, and Minimum Dietary Diversity (MDD) scores.

**Key Technical Features**:
Relational Integrity: Utilized Primary and Foreign Keys to ensure data consistency.

**Data Validation**: Implemented CHECK constraints to ensure MDD scores remain within the valid range (0–8).

## Featured Queries & Analysis
In this project, I solved several complex data challenges:

1. Identifying Nutritional Risk
Problem: Flag all children with an MDD score below the critical threshold of 4.

Skill: Data Filtering (WHERE clause).

2. Longitudinal Patient Tracking (Window Functions)
Problem: Compare a patient's initial nutritional score against their follow-up visit on a single row to measure improvement.

Skill: Advanced Window Functions (LEAD()).

SQL
SELECT patient_id, assessment_date, mdd_score,
LEAD(mdd_score, 1, 0) OVER(ORDER BY assessment_date) AS next_mdd_score
FROM nutrition_assessments
WHERE patient_id = 101;
3. Facility Performance Benchmarking
Problem: Calculate the average MDD score for every facility to identify regions needing more resource allocation.

Skill: Multi-table LEFT JOIN, AVG() aggregation, and GROUP BY.

4. Precision Date Math
Problem: Calculate the exact age of a patient (years/months/days) at the specific moment of an assessment.

Skill: PostgreSQL AGE() function and Interval handling.

🛠️ Tools Used
Database: PostgreSQL 18

Interface: psql Command Line / pgAdmin

Language: SQL

💡 Key Insights Generated
Identified that GSU Kibra Dispensary currently manages the highest volume of pediatric patients.

Successfully tracked a 16% improvement in dietary diversity for specific patients between January and March 2026.

Highlighted specific clinics where the average MDD score is below 4, signaling a need for nutritional intervention programs.
