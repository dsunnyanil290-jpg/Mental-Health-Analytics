CREATE TABLE mental_health (
    age INTEGER,
    gender VARCHAR(20),
    employment_status VARCHAR(30),
    work_environment VARCHAR(30),
    mental_health_history VARCHAR(10),
    seeks_treatment VARCHAR(10),
    stress_level INTEGER,
    sleep_hours NUMERIC(5,2),
    physical_activity_days INTEGER,
    depression_score INTEGER,
    anxiety_score INTEGER,
    social_support_score INTEGER,
    productivity_score NUMERIC(6,2),
    mental_health_risk VARCHAR(20),
    age_group VARCHAR(20),
    sleep_category VARCHAR(20),
    stress_category VARCHAR(20),
    depression_category VARCHAR(20),
    anxiety_category VARCHAR(20),
    mental_wellness_score NUMERIC(6,2),
    activity_category VARCHAR(30),
    wellness_category VARCHAR(20)
);
SELECT * FROM mental_health;

COPY mental_health
FROM 'D:/mental_health_dataset.csv'
DELIMITER ','
CSV HEADER;

/*----------------------------------------------------
 SECTION 1: Data Overview & Demographics
-----------------------------------------------------*/

--1.What is the total number of participants included in the mental health study?--
SELECT COUNT(*) AS Total_Respondents
FROM mental_health;

--2.What is the average age of participants in the dataset?--
SELECT AVG(age) AS Avg_Age
FROM mental_health;

--3.How are participants distributed across different genders?--
SELECT gender,
COUNT(*) AS Total
FROM mental_health
GROUP BY gender;

--4.What is the employment status distribution among participants?--
SELECT employment_status,
COUNT(*) AS Total
FROM mental_health
GROUP BY employment_status;

/*----------------------------------------------------
 SECTION 2: Mental Health Risk Analysis
-----------------------------------------------------*/

--1.How are participants distributed across different mental health risk categories?--
SELECT mental_health_risk,
COUNT(*) AS Total
FROM mental_health
GROUP BY mental_health_risk;

--2.Which mental health risk category contains the highest number of participants?--
SELECT
mental_health_risk,
COUNT(*) AS Total
FROM mental_health
GROUP BY mental_health_risk;

--3.Which age group contributes the most to high mental health risk cases?--
SELECT age_group,
mental_health_risk,
COUNT(*) AS Total
FROM mental_health
GROUP BY age_group, mental_health_risk
ORDER BY Total DESC;


/*----------------------------------------------------
 SECTION 3: Stress, Anxiety & Depression Analysis
-----------------------------------------------------*/

--1.How does average stress level vary across genders?--
SELECT gender,
AVG(stress_level) AS Avg_Stress
FROM mental_health
GROUP BY gender;

--2.How do depression scores differ across genders?--
SELECT gender,
AVG(depression_score) AS Avg_Depression
FROM mental_health
GROUP BY gender;

--3.How do anxiety levels vary among different genders?--
SELECT gender,
AVG(anxiety_score) AS Avg_Anxiety
FROM mental_health
GROUP BY gender;

--4.How are participants distributed across low, medium, and high stress categories?--
SELECT CASE
WHEN stress_level <= 3 THEN 'Low'
WHEN stress_level <= 7 THEN 'Medium'
ELSE 'High'
END AS Stress_Category,
COUNT(*) AS Total
FROM mental_health
GROUP BY
CASE
WHEN stress_level <= 3 THEN 'Low'
WHEN stress_level <= 7 THEN 'Medium'
ELSE 'High'
END;

--5.Which participants have depression scores higher than the overall average?--
WITH avg_dep AS
(SELECT AVG(depression_score) AS avg_score
FROM mental_health)

--6.Which age groups experience the highest average stress levels?--
SELECT
age_group,
AVG(stress_level) AS Avg_Stress
FROM mental_health
GROUP BY age_group
ORDER BY Avg_Stress DESC LIMIT 5;


/*----------------------------------------------------
 SECTION 4: Treatment & Support Analysis
-----------------------------------------------------*/

--1.Which gender is most likely to seek mental health treatment?--
SELECT gender,
COUNT(*) AS Treatment_Count
FROM mental_health
WHERE seeks_treatment='Yes'
GROUP BY gender
ORDER BY Treatment_Count DESC;

--2.Is there a relationship between social support and anxiety levels?--
SELECT social_support_score,
AVG(anxiety_score) AS Avg_Anxiety
FROM mental_health
GROUP BY social_support_score
ORDER BY social_support_score;

/*----------------------------------------------------
 SECTION 5: Lifestyle Impact Analysis
-----------------------------------------------------*/

--1.How does sleep duration influence depression levels?--
SELECT sleep_category,
AVG(depression_score) AS Avg_Depression
FROM mental_health
GROUP BY sleep_category;

--2.How does physical activity impact anxiety levels?--
SELECT activity_category,
AVG(anxiety_score) AS Avg_Anxiety
FROM mental_health
GROUP BY activity_category;

--3.How does stress level affect productivity?--
SELECT stress_category,
AVG(productivity_score) AS Avg_Productivity
FROM mental_health
GROUP BY stress_category;


/*----------------------------------------------------
 SECTION 6: Workplace Analysis
-----------------------------------------------------*/

--1.How does work environment influence stress levels?--
SELECT work_environment,
AVG(stress_level) AS Avg_Stress
FROM mental_health
GROUP BY work_environment;

--2.Which work environment is associated with the highest mental wellness score?--
SELECT work_environment,
AVG(mental_wellness_score) AS Wellness
FROM mental_health
GROUP BY work_environment
ORDER BY Wellness DESC;

/*----------------------------------------------------
 SECTION 7: Advanced SQL Concepts
-----------------------------------------------------*/

--1.Who are the most stressed individuals based on stress rankings?--
SELECT *,
RANK() OVER(ORDER BY stress_level DESC) AS Stress_Rank
FROM mental_health;

--2.What is the average mental wellness score across genders?--
WITH wellness AS
(SELECT
gender,
AVG(mental_wellness_score) AS Avg_Wellness
FROM mental_health
GROUP BY gender)
SELECT *
FROM wellness;


/*----------------------------------------------------
 SECTION 8: Business-Driven Insights
-----------------------------------------------------*/

--1. Which Employment Status Has Highest Mental Risk?--
SELECT
employment_status,
COUNT(*) AS High_Risk_Count
FROM mental_health
WHERE mental_health_risk='High'
GROUP BY employment_status
ORDER BY High_Risk_Count DESC;

--2. Does Treatment Reduce Stress?--
SELECT
seeks_treatment,
AVG(stress_level) AS Avg_Stress
FROM mental_health
GROUP BY seeks_treatment;

--3. Which Age Group Has Highest Depression?--
SELECT
age_group,
AVG(depression_score) AS Avg_Depression
FROM mental_health
GROUP BY age_group
ORDER BY Avg_Depression DESC;

--4. Relationship Between Sleep and Wellness--
SELECT
sleep_category,
AVG(mental_wellness_score) AS Avg_Wellness
FROM mental_health
GROUP BY sleep_category
ORDER BY Avg_Wellness DESC;

--5. Which Factors Drive High Mental Risk?--
SELECT
employment_status,
work_environment,
AVG(stress_level) AS Avg_Stress,
AVG(anxiety_score) AS Avg_Anxiety,
AVG(depression_score) AS Avg_Depression
FROM mental_health
GROUP BY employment_status, work_environment
ORDER BY Avg_Stress DESC;

--6. High Risk Percentage by Employment Status--
SELECT
employment_status,
ROUND(
100.0 * SUM(CASE WHEN mental_health_risk='High' THEN 1 ELSE 0 END)
/ COUNT(*),2
) AS High_Risk_Percentage
FROM mental_health
GROUP BY employment_status
ORDER BY High_Risk_Percentage DESC;

--8. Which age group has the highest proportion of high-risk individuals?--
SELECT age_group,
ROUND(
100.0 * SUM(
CASE
WHEN mental_health_risk='High' THEN 1
ELSE 0
END
) / COUNT(*),2
) AS High_Risk_Percentage
FROM mental_health
GROUP BY age_group
ORDER BY High_Risk_Percentage DESC;

--9. Which work environment is associated with the lowest mental health risk percentage?--

SELECT
work_environment,
ROUND(
100.0 * SUM(
CASE
WHEN mental_health_risk='High' THEN 1
ELSE 0
END
) / COUNT(*),2
) AS High_Risk_Percentage
FROM mental_health
GROUP BY work_environment
ORDER BY High_Risk_Percentage;

/*
BUSINESS INSIGHTS

1. Younger participants show higher mental health risk.

2. Unemployed individuals experience the highest risk levels.

3. Treatment seekers demonstrate lower stress levels.

4. Better sleep duration is associated with improved wellness.

5. Supportive work environments correlate with lower mental health risk.

6. Physical activity contributes positively to overall wellness.

RECOMMENDATIONS

1. Expand mental health awareness programs.

2. Improve access to counseling services.

3. Promote workplace wellness initiatives.

4. Encourage healthy sleep habits.

5. Support physical activity programs.
*/


























