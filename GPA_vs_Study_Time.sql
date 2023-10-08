-- Fixing decimal points
SELECT gpa FROM gpa.gpa_study_hours WHERE gpa NOT REGEXP '^[0-9]+(\.[0-9]+)?$';


UPDATE gpa.gpa_study_hours SET gpa = REPLACE(gpa, ',', '.');


SELECT gpa FROM gpa.gpa_study_hours WHERE gpa NOT REGEXP '^[0-9]+(\.[0-9]+)?$';


ALTER TABLE gpa.gpa_study_hours MODIFY COLUMN gpa DECIMAL(10, 1);

-- Query

-- Average, max & min --

SELECT
    'GPA' AS "",
    ROUND(MIN(gpa),1) AS Minimum,
    ROUND(MAX(gpa),1) AS Maximum,
    ROUND(AVG(gpa),1)  AS Average
FROM gpa_study_hours
UNION ALL
SELECT
    'Hours Studied' AS "",
    ROUND(MIN(study_hours),1),
    ROUND(MAX(study_hours),1),
   ROUND(AVG(study_hours),1)
FROM gpa_study_hours;

-- Median GPA -- 

WITH a AS (
    SELECT gpa
    FROM gpa_study_hours
    ORDER BY 1),
b AS (
    SELECT gpa, ROW_NUMBER() OVER (ORDER BY gpa) AS row_num, COUNT(*) OVER () AS total_rows
    FROM a)
SELECT ROUND(AVG(gpa),1) AS median_gpa
FROM b
WHERE row_num IN (FLOOR((total_rows + 1) / 2), CEIL((total_rows + 1) / 2)); // row_num is equal to either floor or ceiling num

-- Median Hours studied -- 

WITH a AS (
    SELECT study_hours
    FROM gpa_study_hours
    ORDER BY 1),
b AS (
    SELECT study_hours, ROW_NUMBER() OVER (ORDER BY study_hours) AS row_num, COUNT(*) OVER () AS total_rows
    FROM a)
SELECT ROUND(AVG(study_hours),1) AS median_hours
FROM b
WHERE row_num IN (FLOOR((total_rows + 1) / 2), CEIL((total_rows + 1) / 2));

-- lower quartile GPA score --

SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(gpa ORDER BY gpa), ',', FLOOR(0.25 * COUNT(*) + 1)), ',', -1) AS lower_quartile
FROM gpa_study_hours; // scores sorted in asc, concat'ed, percentile found, percentile extracted 

-- upper quartile GPA score --

SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(gpa ORDER BY gpa), ',', FLOOR(0.75 * COUNT(*) + 1)), ',', -1) AS upper_quartile
FROM gpa_study_hours;

-- lower quartile hours studied --

SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(study_hours ORDER BY study_hours), ',', FLOOR(0.25 * COUNT(*) + 1)), ',', -1) AS lower_quartile
FROM gpa_study_hours;

-- upper quartile hours studied --

SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(study_hours ORDER BY study_hours), ',', FLOOR(0.75 * COUNT(*) + 1)), ',', -1) AS upper_quartile
FROM gpa_study_hours;

-- Correlation Coefficient --

SELECT
    ROUND((SUM(gpa * study_hours) - COUNT(*) * AVG(gpa) * AVG(study_hours)) /
    (SQRT((SUM(gpa * gpa) - COUNT(*) * AVG(gpa) * AVG(gpa)) * (SUM(study_hours * study_hours) - COUNT(*) * AVG(study_hours) * AVG(study_hours)))),2)
    AS correlation_coefficient
FROM gpa_study_hours;

-- Number of students above the average --

SELECT COUNT(*) as no_of_students
FROM gpa_study_hours
WHERE gpa > (SELECT ROUND(AVG(gpa),1) AS avg_gpa
FROM gpa_study_hours);

-- GPA Score frequency table --

SELECT
    CASE
        WHEN gpa BETWEEN 0.0 AND 0.9 THEN '0.0-0.9'
        WHEN gpa BETWEEN 1.0 AND 1.9 THEN '1.0-1.9'
        WHEN gpa BETWEEN 2.0 AND 2.9 THEN '2.0-2.9'
        WHEN gpa BETWEEN 3.0 AND 3.9 THEN '3.0-3.9'
        ELSE '4.0'
    END AS "GPA Score",
    COUNT(*) AS frequency
FROM gpa_study_hours
GROUP BY 1
ORDER BY 1 asc;

-- Study hours frequency table--

SELECT
    CASE
        WHEN study_hours BETWEEN 1 AND 10 THEN '1-10'
        WHEN study_hours BETWEEN 11 AND 20 THEN '11-20'
        WHEN study_hours BETWEEN 21 AND 30 THEN '21-30'
        WHEN study_hours BETWEEN 31 AND 40 THEN '31-40'
        WHEN study_hours BETWEEN 41 AND 50 THEN '41-50'
        WHEN study_hours BETWEEN 51 AND 60 THEN '51-60'
        WHEN study_hours BETWEEN 61 AND 70 THEN '61-70'
    END AS "Hours Studied",
    COUNT(*) AS frequency
FROM gpa_study_hours
GROUP BY 1
ORDER BY 1;





