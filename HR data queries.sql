-- 1. What is the gender breakdown of employees in the company?

SELECT
	gender,
	COUNT(id) as no_of_employees	
FROM
	dbo.human_resource
GROUP BY gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?
SELECT
	race,
	COUNT(id) as no_of_employees	
FROM
	dbo.human_resource
GROUP BY race
order by no_of_employees desc;


-- 3. What is the age distribution of employees in the company?
SELECT
	age_group,
	count(*) as no_of_employees
FROM
(SELECT
	CASE
		WHEN age >= 20 and age <=29 then '20-29'
		WHEN age >= 30 and age <=39 then '30-39'
		WHEN age >= 40 and age <=49 then '40-49'
		WHEN age >= 50 and age <=59 then '50-59'
		ELSE '60+'
	END as age_group
FROM
	human_resource) as age_groups
GROUP BY age_group
ORDER BY age_group;

-- 4. How many employees work at headquarters versus remote locations?
SELECT
	location,
	count(id) as no_of_employees	
FROM	
	human_resource
group by location;


-- 5. What is the average length of employment for employees who have been terminated?
SELECT
	AVG(DATEDIFF(YY,hire_date,termdate)) as avg_length_of_employement
FROM
	human_resource;

-- 6. How does the gender distribution vary across departments?
SELECT
	gender,
	department,
	count(id) as no_of_employees
FROM
	human_resource
GROUP BY department,gender
ORDER BY department,gender;

-- 7. What is the distribution of job titles across the company?
SELECT
	jobtitle,
	count(id) as no_of_employees
FROM
	human_resource
GROUP BY jobtitle
order by no_of_employees desc;

-- 8. Which department has the highest turnover rate?
WITH CTE AS
(SELECT
	department,
	count(id) as total,
	SUM(CASE WHEN termdate<=GETDATE() then 1 else 0 END) as terminated_count,
	SUM(CASE WHEN termdate>GETDATE() or termdate is null then 1 else 0 END) as active_count
FROM
	human_resource
GROUP BY department)

SELECT
	department,
	total,
	active_count,
	terminated_count,
	ROUND(terminated_count/CAST(total as FLOAT),2) as termination_rate
FROM
	CTE


-- 9. What is the distribution of employees across locations by state?
SELECT
	location_state,
	location_city,
	count(id) as no_of_employees
FROM
	human_resource
GROUP BY location_state,location_city
ORDER BY location_state,location_city;

-- 10. How has the company's employee count changed over time based on hire and term dates?
WITH CTE AS
(SELECT
	YEAR(hire_date) as year,
	COUNT(CASE WHEN hire_date is not null then hire_date END) as total_hire,
	COUNT(CASE WHEN termdate<=GETDATE() then termdate END) as total_termination,
	COUNT(CASE WHEN hire_date is not null then hire_date END) - COUNT(CASE WHEN termdate<=GETDATE() then termdate END) as net_change
FROM
	human_resource
group by YEAR(hire_date))

SELECT
	year,
	total_hire,
	total_termination,
	net_change,
	ROUND(net_change/CAST(total_hire as FLOAT),2) as net_change_percent
FROM
	CTE
where year is not null

-- 11. What is the tenure distribution for each department?
SELECT
	department,
	SUM(DATEDIFF(YY,hire_date, termdate))/365 as avg_tenure
FROM
	human_resource
WHERE termdate <= GETDATE()
GROUP BY department;