SELECT * FROM hr_dataset.hr;

select * from hr;

alter table hr 
change column id emp_id varchar(20) NOT NULL;

describe hr;

update  hr
set birthdate = case
when birthdate like '%/%' then date_format(str_to_date(birthdate, '%m/%d/%Y'),'%Y-%m-%d')
when birthdate like'%-%' then date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
else null
end;

alter table hr
modify column birthdate date;

update hr
set hire_date = case
when hire_date like '%/%' then date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
when hire_date like '%-%' then date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
else null
end;

alter table hr
modify column hire_date date;


select termdate from hr;

ALTER TABLE hr
modify column termdate date;

UPDATE hr
SET termdate = '0000-00-00'
WHERE termdate IS NULL OR termdate = '';

alter table hr add column age int;

update hr
set age = timestampdiff(year,birthdate,curdate());

select * from hr;

select 
min(age) as youngest,
max(age)as oldest
FROM hr;

-- QUESTIONS

-- 1. What is the gender breakdown of employees in the company?

select gender, count(*) AS COUNT
from hr
where age >=18 and termdate = '0000-00-00'
group by gender;

-- 2. What is the race/ethenicity breakdown of employees in the company?

select race, count(*) AS COUNT
from hr 
where age >=18 and termdate = '0000-00-00'
group by race order by count(*) desc;

-- 3. what is the age distribution of the employees in the company?

select
min(age) AS Youngest,
max(age) AS Oldest
from hr
where age>=18 and termdate = '0000-00-00';

-- lets create a age group to see which age group has most number of emps

select
case
when age >=18 and age <=24 then '18-24'
when age >=25 and age <=34 then '25-34'
when age >=35 and age <=44 then '35-44'
when age >=45 and age <=55 then '45-54'
when age >=55 and age <=65 then '55-65'
else '65+'
end as age_group,
count(*) as COUNT
from hr
where age>=18 and termdate = '0000-00-00'
group by age_group
order by age_group;

-- age_group_gender


select
case
when age >=18 and age <=24 then '18-24'
when age >=25 and age <=34 then '25-34'
when age >=35 and age <=44 then '35-44'
when age >=45 and age <=55 then '45-54'
when age >=55 and age <=65 then '55-65'
else '65+'
end as age_group,gender,
count(*) as COUNT
from hr
where age>=18 and termdate = '0000-00-00'
group by age_group,gender
order by age_group,gender;

-- 4. How many employees work at headquaters versus remote location
select location,count(*) AS COUNT
from hr
where age>=18 and termdate = '0000-00-00' 
group by location;

-- 5. What is the average length of employement for the employees who have been terminated?

SELECT ROUND(ABS(AVG(DATEDIFF(hire_date, termdate) / 365)), 0) AS Avg_employment
FROM hr
WHERE termdate <= CURDATE() AND termdate <> '0000-00-00' AND age >= 18;


-- 6. How does the gender distribution vary across departments and job titles?

select department,gender,count(*) AS COUNT
from hr 
where age>=18 and termdate = '0000-00-00' 
group by department,gender
order by department;

-- 7. What is the distribution of job titles accross the company?

select jobtitle,count(*) AS COUNT
from hr 
where age>=18 and termdate = '0000-00-00' 
group by  jobtitle
order by  jobtitle desc;

-- 8. which department has the higest turnover rate?
-- turnoover means termination rate
select
department,
total_count,
terminated_count,
terminated_count/total_count as termination_rate
from
(select department,
count(*) as total_count,
sum(case when termdate <> '0000-00-00'and termdate <= curdate() then 1 else 0 end) as terminated_count
from hr
where age >=18
group by department) as subqueries
order by termination_rate desc;

-- 9. what is the distribution of employees across locations by city and state?

select location_state, count(*) AS COUNT
from hr
where age>=18 and termdate = '0000-00-00'
group  by location_state
order  by count desc;

-- 10. How has the company's employee count changed over time based on hire date and termdate?

select 
year,
hires,
terminations,
hires-terminations as net_change,
round((hires-terminations)/hires*100,2) as net_change_percent
from
(select year(hire_date) as year,
count(*) as hires,
sum(case when termdate <> '0000-00-00' and termdate <= curdate() then 1 else 0 end) as terminations
from hr 
where age>=18
group by year(hire_date)) as subquery
order by year;

-- 11. what is the tenure distribution for each department?

select department, round(avg(datediff(termdate,hire_date)/365),0) as avg_tenure 
from hr
where termdate <> '0000-00-00' and termdate <= curdate() and age >= 18
group by department;




 













