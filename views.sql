-- Views --

-- Average, max & min --

SELECT
    'GPA' AS "",
    ROUND(MIN(gpa),1) AS Minimum,
    ROUND(MAX(gpa),1) AS Maximum,
    ROUND(AVG(gpa),1)  AS Avgerage
FROM gpa_study_hours
UNION ALL
SELECT
    'Hours Studied' AS "",
    ROUND(MIN(study_hours),1),
    ROUND(MAX(study_hours),1),
   ROUND(AVG(study_hours),1)
FROM gpa_study_hours;

-- GPA Scores and the average amount of hours a student has studied --

CREATE VIEW avg_hours_studied AS(
SELECT gpa, ROUND(AVG(study_hours),1) AS avg_no_of_hrs_studied
FROM gpa_study_hours
GROUP BY 1
ORDER BY 2 DESC);

-- The number of students with each GPA --

CREATE VIEW count_students_per_score AS(
SELECT gpa, COUNT(*) AS no_of_students
FROM gpa_study_hours
GROUP BY 1
ORDER BY 1 ASC);
