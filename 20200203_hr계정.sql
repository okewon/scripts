-- erd ���̾�׷��� �����Ͽ�, countries, regions ���̺��� �̿��Ͽ� ������ �Ҽ� ������ ������ ���� ����� �������� ������ �ۼ��غ�����
-- (������ ������ ����)
SELECT regions.region_id, countries.country_name, countries.country_name
FROM countries, regions
WHERE regions.REGION_ID = countries.region_id AND regions.region_name = 'Europe';

SELECT *
FROM regions;

SELECT *
FROM countries;

-- erd ���̾�׷��� �����Ͽ� countries, regions, locations ���̺��� �̿��Ͽ�
-- ������ �Ҽ� ����, ������ �Ҽӵ� ���� �̸��� ������ ���� ����� �������� ������ �ۼ��غ�����
-- (������ ������ ����)
SELECT regions.region_id, regions.region_name, countries.country_name, locations.city
FROM regions, countries, locations
WHERE regions.REGION_ID = countries.region_id AND countries.country_id = locations.country_id AND regions.region_name = 'Europe';

-- erd ���̾�׷��� �����Ͽ� countries, regions, locations, departures ���̺��� �̿��Ͽ� ������ �Ҽ� ����, ������ �Ҽӵ� ���� �̸� �� ���ÿ� �ִ� �μ��� ������ ���� ����� �������� ������ �ۼ��غ�����
-- (������ ������ ����)
SELECT regions.region_id, regions.region_name, countries.country_name, locations.city, departments.department_name
FROM regions, countries, locations, departments
WHERE regions.REGION_ID = countries.region_id AND countries.country_id = locations.country_id AND locations.location_id = departments.location_id AND regions.region_name = 'Europe';

-- erd ���̾�׷��� �����Ͽ� countries, regions, locations, departments, employee ���̺��� �̿��Ͽ� ������ �Ҽ� ����, ������ �Ҽӵ� ���� �̸� �� ���ÿ� �ִ� �μ�, �μ��� �Ҽӵ� ���� ������ ������ ���� ����� �������� ������ �ۼ��غ�����
-- (������ ������ ����)
SELECT regions.region_id, regions.region_name, countries.country_name, locations.city, departments.department_name, concat(employees.first_name,employees.last_name) NAME
FROM regions, countries, locations, departments, employees
WHERE regions.REGION_ID = countries.region_id 
    AND countries.country_id = locations.country_id 
    AND locations.location_id = departments.location_id
    AND employees.employee_id = departments.manager_id
    AND regions.region_name = 'Europe';
    
-- erd ���̾�׷��� �����Ͽ� employees, jobs ���̺��� �̿��Ͽ� ������ ������ ��Ī�� �����Ͽ� ������ ���� ����� �������� ������ �ۼ��غ�����
SELECT employees.employee_id, concat(employees.first_name,employees.last_name) NAME, jobs.job_id, jobs.job_title
FROM employees, jobs
WHERE employees.job_id = jobs.job_id;

-- erd ���̾�׷��� �����Ͽ� employees, jobs ���̺��� �̿��Ͽ� ������ ������ ��Ī, ������ �Ŵ��� ������ �����Ͽ� ������ ���� ����� �������� ������ �ۼ��غ�����
SELECT e.manager_id MGR_ID, CONCAT(m.first_name, m.last_name) MGR_NAME,
       e.employee_id, concat(e.first_name, e.last_name) NAME,
       j.job_id, j.job_title
FROM employees e, jobs j, employees m
WHERE e.job_id = j.job_id
      AND m.employee_id = e.manager_id
      AND e.manager_id IS NOT NULL;
