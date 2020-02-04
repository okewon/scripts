-- erd 다이어그램을 참고하여, countries, regions 테이블을 이용하여 지역별 소속 국가를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요
-- (지역은 유럽만 한정)
SELECT regions.region_id, countries.country_name, countries.country_name
FROM countries, regions
WHERE regions.REGION_ID = countries.region_id AND regions.region_name = 'Europe';

SELECT *
FROM regions;

SELECT *
FROM countries;

-- erd 다이어그램을 참고하여 countries, regions, locations 테이블을 이용하여
-- 지역별 소속 국가, 국가에 소속된 도시 이름을 다음과 같은 결과가 나오도록 쿼리를 작성해보세요
-- (지역은 유럽만 한정)
SELECT regions.region_id, regions.region_name, countries.country_name, locations.city
FROM regions, countries, locations
WHERE regions.REGION_ID = countries.region_id AND countries.country_id = locations.country_id AND regions.region_name = 'Europe';

-- erd 다이어그램을 참고하여 countries, regions, locations, departures 테이블을 이용하여 지역별 소속 국가, 국가에 소속된 도시 이름 및 도시에 있는 부서를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요
-- (지역은 유럽만 한정)
SELECT regions.region_id, regions.region_name, countries.country_name, locations.city, departments.department_name
FROM regions, countries, locations, departments
WHERE regions.REGION_ID = countries.region_id AND countries.country_id = locations.country_id AND locations.location_id = departments.location_id AND regions.region_name = 'Europe';

-- erd 다이어그램을 참고하여 countries, regions, locations, departments, employee 테이블을 이용하여 지역별 소속 국가, 국가에 소속된 도시 이름 및 도시에 있는 부서, 부서에 소속된 직원 정보를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요
-- (지역은 유럽만 한정)
SELECT regions.region_id, regions.region_name, countries.country_name, locations.city, departments.department_name, concat(employees.first_name,employees.last_name) NAME
FROM regions, countries, locations, departments, employees
WHERE regions.REGION_ID = countries.region_id 
    AND countries.country_id = locations.country_id 
    AND locations.location_id = departments.location_id
    AND employees.employee_id = departments.manager_id
    AND regions.region_name = 'Europe';
    
-- erd 다이어그램을 참고하여 employees, jobs 테이블을 이용하여 직원의 담당업무 명칭을 포함하여 다음과 같은 결과가 나오도록 쿼리를 작성해보세요
SELECT employees.employee_id, concat(employees.first_name,employees.last_name) NAME, jobs.job_id, jobs.job_title
FROM employees, jobs
WHERE employees.job_id = jobs.job_id;

-- erd 다이어그램을 참고하여 employees, jobs 테이블을 이용하여 직원의 담당업무 명칭, 직원의 매니저 정보를 포함하여 다음과 같은 결과가 나오도록 쿼리를 작성해보세요
SELECT e.manager_id MGR_ID, CONCAT(m.first_name, m.last_name) MGR_NAME,
       e.employee_id, concat(e.first_name, e.last_name) NAME,
       j.job_id, j.job_title
FROM employees e, jobs j, employees m
WHERE e.job_id = j.job_id
      AND m.employee_id = e.manager_id
      AND e.manager_id IS NOT NULL;
