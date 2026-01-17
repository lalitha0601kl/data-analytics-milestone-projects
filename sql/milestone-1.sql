SELECT * FROM salary_survey.`salary survey`;
use salary_survey;
DESCRIBE salary_survey.`salary survey`;
-- avg salary by ind & gender-- 1st qn
SELECT 
    `Industry`,
    `Gender`,
    ROUND(AVG(`Annual Salary`), 2) AS `Avg_Salary`
FROM salary_survey.`salary survey`
WHERE `Annual Salary` IS NOT NULL
GROUP BY `Industry`, `Gender`
ORDER BY `Industry`, `Gender`;

-- Annual Salary by Job title--2nd qn

SELECT 
    `Job Title`,
    SUM(`Annual Salary` + IFNULL(`Additional Monetary Compensation`, 0)) AS `Total_Compensation`
FROM salary_survey.`salary survey`
WHERE `Annual Salary` IS NOT NULL
GROUP BY `Job Title`
ORDER BY `Total_Compensation` DESC;

-- 3rd qn - salary distribution by education
SELECT 
    `Highest Level of Education Completed` AS Education_Level,
    ROUND(AVG(`Annual Salary`), 2) AS Average_Salary,
    MIN(`Annual Salary`) AS Minimum_Salary,
    MAX(`Annual Salary`) AS Maximum_Salary
FROM salary_survey.`salary survey`
GROUP BY `Highest Level of Education Completed`
ORDER BY Average_Salary DESC;

-- 4th-- No. of. Emp by Ind and exp--
SELECT
    `Industry`,
    `Years of Professional Experience Overall`,
    COUNT(*) AS Number_of_Employees
FROM salary_survey.`salary survey`
GROUP BY `Industry`, `Years of Professional Experience Overall`
ORDER BY `Industry`, `Years of Professional Experience Overall`;

WITH SalaryRanked AS (
    SELECT
        `Age Range`,
        `Gender`,
        `Annual Salary`,
        ROW_NUMBER() OVER (PARTITION BY `Age Range`, `Gender` ORDER BY `Annual Salary`) AS rn_asc,
        ROW_NUMBER() OVER (PARTITION BY `Age Range`, `Gender` ORDER BY `Annual Salary` DESC) AS rn_desc
    FROM salary_survey.`salary survey`
    WHERE `Annual Salary` IS NOT NULL
)
SELECT 
    `Age Range`,
    `Gender`,
    ROUND(AVG(`Annual Salary`), 2) AS `Median_Salary`
FROM SalaryRanked
WHERE rn_asc = rn_desc
GROUP BY `Age Range`, `Gender`
ORDER BY `Age Range`, `Gender`;

WITH RankedJobs AS (
    SELECT
        `Country`,
        `Job Title`,
        `Annual Salary`,
        RANK() OVER (PARTITION BY `Country` ORDER BY `Annual Salary` DESC) AS salary_rank
    FROM salary_survey.`salary survey`
    WHERE `Annual Salary` IS NOT NULL
)
SELECT
    `Country`,
    `Job Title`,
    ROUND(`Annual Salary`, 2) AS `Annual_Salary`
FROM RankedJobs
WHERE salary_rank = 1
ORDER BY `Country`, `Annual Salary` DESC;
UPDATE salary_survey.`salary survey`
SET `Country` = 'United States of America'
WHERE `Country` = 'America';
UPDATE salary_survey.`salary survey`
SET `Country` = 'United States of America'
WHERE `Country` = 'United States of AmericAa.';

SELECT 
    `City`,
    `Industry`,
    ROUND(AVG(`Annual Salary`), 2) AS `Avg_Salary`
FROM salary_survey.`salary survey`
WHERE `Annual Salary` IS NOT NULL
GROUP BY `City`, `Industry`
ORDER BY `City`, `Industry`;

SELECT 
    ROUND(
        (SUM(CASE WHEN `Additional Monetary Compensation` IS NOT NULL AND `Additional Monetary Compensation` > 0 THEN 1 ELSE 0 END) 
        / COUNT(*)) * 100, 2
    ) AS `Percentage_with_Additional_Comp`
FROM salary_survey.`salary survey`;

SHOW TABLES IN salary_survey;
DESCRIBE salary_survey.`salary survey`;

SELECT 
    `Job Title`,
    `Years of Professional Experience Overall`,
    ROUND(SUM(`Annual Salary` + IFNULL(`Additional Monetary Compensation`, 0)), 2) AS `Total_Compensation`
FROM salary_survey.`salary survey`
WHERE `Annual Salary` IS NOT NULL
GROUP BY `Job Title`, `Years of Professional Experience Overall`
ORDER BY `Job Title`, `Years of Professional Experience Overall`;
SELECT 
    `Industry`,
    `Gender`,
    `Highest Level of Education Completed`,
    ROUND(AVG(`Annual Salary`), 2) AS `Avg_Salary`
FROM salary_survey.`salary survey`
WHERE `Annual Salary` IS NOT NULL
GROUP BY `Industry`, `Gender`, `Highest Level of Education Completed`
ORDER BY `Industry`, `Gender`, `Highest Level of Education Completed`;