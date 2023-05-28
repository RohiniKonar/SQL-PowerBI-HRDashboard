UPDATE human_resource
SET birthdate = CASE
	WHEN birthdate LIKE '%/%' THEN CAST(birthdate as DATE)
    WHEN birthdate LIKE '%-%' THEN CAST(birthdate as DATE)
    ELSE NULL
END;

ALTER TABLE human_resource
ALTER COLUMN birthdate DATE;

UPDATE human_resource
SET hire_date = CASE
	WHEN hire_date LIKE '%/%' THEN CAST(hire_date as DATE)
    WHEN hire_date LIKE '%-%' THEN CAST(hire_date as DATE)
    ELSE NULL
END;

ALTER TABLE human_resource
ALTER COLUMN hire_date DATE;

ALTER TABLE human_resource 
ADD age INT;

UPDATE human_resource
SET age = DATEDIFF(YY, birthdate, GETDATE());