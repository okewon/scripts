-- erd ���̾�׷��� �����Ͽ�, countries, regions ���̺��� �̿��Ͽ� ������ �Ҽ� ������ ������ ���� ����� �������� ������ �ۼ��غ�����
-- (������ ������ ����)
SELECT regions.region_id, regions.region_name, countries.country_name
FROM countries, regions
WHERE regions.region_id = countries.country_name AND regions.region_name IN ('Europe');

SELECT *
FROM regions;