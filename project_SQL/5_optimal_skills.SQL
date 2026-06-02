/*
What are the most optimal skills to learn?
- Identify skills in high demand with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries),
    offering strategic insights for career development in data analysis
*/

WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        count(skills_job_dim.job_id) AS skill_count
    FROM
        job_postings_fact
    INNER JOIN
        skills_job_dim
        ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN
        skills_dim
        ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_work_from_home = TRUE AND 
        salary_year_avg is not null
    GROUP BY
        skills_dim.skill_id
),
average_salary as (
    SELECT
    skills_job_dim.skill_id,
    ROUND (avg (salary_year_avg),0) as avg_salary
    FROM
        job_postings_fact
    INNER JOIN
        skills_job_dim
        ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN
        skills_dim
        ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' and
        job_work_from_home = TRUE
        AND salary_year_avg is not null
    GROUP BY
        skills_job_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    skill_count,
    avg_salary
FROM
    skills_demand
INNER Join
    average_salary on skills_demand.skill_id = average_salary.skill_id
WHERE
    skill_count > 10
ORDER BY
    avg_salary DESC
LIMIT
    25