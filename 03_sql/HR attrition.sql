CREATE DATABASE IF NOT EXISTS hr_analytics;
USE hr_analytics;
show tables;
use hr_analytics;


ALTER TABLE hr_attrition_cleaned
  ADD COLUMN Attrition_Flag INT,
  ADD COLUMN Age_Group VARCHAR(10),
  ADD COLUMN Tenure_Group VARCHAR(15),
  ADD COLUMN Salary_Band VARCHAR(25);
  SET SQL_SAFE_UPDATES = 0;
  

-- whether the helper columns exist
SELECT COUNT(*) AS helper_columns
FROM information_schema.columns
WHERE table_schema = 'hr_analytics'
  AND column_name IN ('Attrition_Flag','Age_Group','Tenure_Group','Salary_Band');
  
SELECT COUNT(*) AS total_rows, SUM(Attrition_Flag) AS total_left FROM employees;

SELECT Department, COUNT(*) AS headcount, SUM(Attrition_Flag) AS employees_left
FROM employees
GROUP BY Department;  

-- overall numbers
SELECT COUNT(*) AS total_employees,
       SUM(Attrition_Flag) AS employees_left,
       COUNT(*) - SUM(Attrition_Flag) AS active_employees,
       ROUND(100.0 * SUM(Attrition_Flag) / COUNT(*), 2) AS attrition_rate_pct
FROM employees;


-- department headcount
SELECT Department, COUNT(*) AS headcount,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM employees), 1) AS pct_of_workforce
FROM employees
GROUP BY Department
ORDER BY headcount DESC;

-- Headcount by department and job role
SELECT Department, JobRole, COUNT(*) AS headcount
FROM employees
GROUP BY Department, JobRole
ORDER BY Department, headcount DESC;

-- Attrition rate by department
SELECT Department, COUNT(*) AS headcount, SUM(Attrition_Flag) AS employees_left,
       COUNT(*) - SUM(Attrition_Flag) AS active_employees,
       ROUND(100.0 * SUM(Attrition_Flag) / COUNT(*), 2) AS attrition_rate_pct
FROM employees
GROUP BY Department
ORDER BY attrition_rate_pct DESC;

-- Attrition rate by job role
SELECT JobRole, COUNT(*) AS headcount, SUM(Attrition_Flag) AS employees_left,
       COUNT(*) - SUM(Attrition_Flag) AS active_employees,
       ROUND(100.0 * SUM(Attrition_Flag) / COUNT(*), 2) AS attrition_rate_pct
FROM employees
GROUP BY JobRole
ORDER BY attrition_rate_pct DESC;

-- Attrition rate by tenure group
SELECT Tenure_Group, COUNT(*) AS headcount, SUM(Attrition_Flag) AS employees_left,
       ROUND(100.0 * SUM(Attrition_Flag) / COUNT(*), 2) AS attrition_rate_pct
FROM employees
GROUP BY Tenure_Group
ORDER BY MIN(YearsAtCompany);

-- Attrition by age group
SELECT Age_Group, COUNT(*) AS headcount, SUM(Attrition_Flag) AS employees_left,
       ROUND(100.0 * SUM(Attrition_Flag) / COUNT(*), 2) AS attrition_rate_pct
FROM employees
GROUP BY Age_Group
ORDER BY MIN(Age);


-- Attrition by overtime
SELECT OverTime, COUNT(*) AS headcount, SUM(Attrition_Flag) AS employees_left,
       ROUND(100.0 * SUM(Attrition_Flag) / COUNT(*), 2) AS attrition_rate_pct
FROM employees
GROUP BY OverTime
ORDER BY attrition_rate_pct DESC;

-- Attrition salary band
SELECT Salary_Band, COUNT(*) AS headcount, SUM(Attrition_Flag) AS employees_left,
       ROUND(100.0 * SUM(Attrition_Flag) / COUNT(*), 2) AS attrition_rate_pct
FROM employees
GROUP BY Salary_Band
ORDER BY MIN(MonthlyIncome);


-- Attrition job satisfaction
SELECT JobSatisfaction, COUNT(*) AS headcount, SUM(Attrition_Flag) AS employees_left,
       ROUND(100.0 * SUM(Attrition_Flag) / COUNT(*), 2) AS attrition_rate_pct
FROM employees
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;

-- Attrition work life balance
SELECT WorkLifeBalance, COUNT(*) AS headcount, SUM(Attrition_Flag) AS employees_left,
       ROUND(100.0 * SUM(Attrition_Flag) / COUNT(*), 2) AS attrition_rate_pct
FROM employees
GROUP BY WorkLifeBalance
ORDER BY WorkLifeBalance;

-- Attrition environment satisfaction
SELECT EnvironmentSatisfaction, COUNT(*) AS headcount, SUM(Attrition_Flag) AS employees_left,
       ROUND(100.0 * SUM(Attrition_Flag) / COUNT(*), 2) AS attrition_rate_pct
FROM employees
GROUP BY EnvironmentSatisfaction
ORDER BY EnvironmentSatisfaction;

-- tenure and overtime
SELECT OverTime, Tenure_Group, COUNT(*) AS headcount, SUM(Attrition_Flag) AS employees_left,
       ROUND(100.0 * SUM(Attrition_Flag) / COUNT(*), 2) AS attrition_rate_pct
FROM employees
GROUP BY OverTime, Tenure_Group
HAVING COUNT(*) >= 30
ORDER BY attrition_rate_pct DESC
LIMIT 6;

-- Department × overtime × salary band
SELECT Department, OverTime, Salary_Band, COUNT(*) AS headcount, SUM(Attrition_Flag) AS employees_left,
       ROUND(100.0 * SUM(Attrition_Flag) / COUNT(*), 2) AS attrition_rate_pct
FROM employees
GROUP BY Department, OverTime, Salary_Band
HAVING COUNT(*) >= 30
ORDER BY attrition_rate_pct DESC
LIMIT 5;

-- Age group × overtime
SELECT Age_Group, OverTime, COUNT(*) AS headcount, SUM(Attrition_Flag) AS employees_left,
       ROUND(100.0 * SUM(Attrition_Flag) / COUNT(*), 2) AS attrition_rate_pct
FROM employees
GROUP BY Age_Group, OverTime
HAVING COUNT(*) >= 30
ORDER BY attrition_rate_pct DESC
LIMIT 5;
  
  