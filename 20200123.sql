-- WHERE2
-- WHERE ���� ����ϴ� ���ǿ� ������ ��ȸ ����� ������ ��ġ�� �ʴ´�
-- SQL�� ������ ������ ���� �ִ�.

-- emp ���̺��� �Ի� ���ڰ� 1982�� 1�� 1�� ���ĺ��� 1983�� 1�� 1�� ������ �����
-- ename, hiredate �����͸� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
-- ��, �����ڴ� �񱳿����ڸ� ����Ѵ�.
-- ���� : Ű�� 185cm �̻��̰� �����԰� 70kg �̻��� ������� ���� --> �����԰� 70kg �̻��̰� Ű�� 185cm �̻��� ������� ����
-- ������ Ư¡ : ���տ��� ������ ����.
-- (1, 5, 10) --> (10, 5, 1) : �� ������ ���� �����ϴ�
-- ���̺��� ������ ������� ����
-- SELECT ����� ������ �ٸ����� ���� �����ϸ� ����
--  > ���ı�� ����(ORDER BY)
-- �߻��� ������� ���� --> ���� X

SELECT ename, CONCAT('19',hiredate) hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD')
AND hiredate <= TO_DATE('1983/01/01', 'YYYY/MM/DD');

SELECT ename, CONCAT('19',hiredate) hiredate
FROM emp
WHERE hiredate <= TO_DATE('1983/01/01', 'YYYY/MM/DD')
AND hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD');

-- IN ������
-- Ư�� ���տ� ���ԵǴ��� ���θ� Ȯ��
-- �μ���ȣ�� 10�� Ȥ��(OR) 20�� �ȿ� ���ϴ� ���� ��ȸ
SELECT empno, ename, deptno
FROM emp
WHERE deptno IN(10, 20);

-- IN �����ڸ� ������� �ʰ� OR ������ ���
SELECT empno, ename, deptno
FROM emp
WHERE deptno = 10
OR deptno = 20;

-- emp���̺��� ����̸��� SMITH, JONES�� ������ ��ȸ (empno, ename, deptno)
-- AND / OR
-- ���� ���
SELECT empno, ename, deptno
FROM emp
WHERE ename IN('SMITH', 'JONES');

SELECT empno, ename, deptno
FROM emp
WHERE ename = 'SMITH'
OR ename = 'JONES';

-- users ���̺��� userid�� brown, cony, sally�� �����͸� ������ ���� ��ȸ �Ͻÿ�.
-- (��, IN ������ ���)
SELECT userid ���̵�, usernm �̸�, ALIAS ��Ī
FROM users
WHERE userid IN('brown', 'cony', 'sally');

-- ���ڿ� ��Ī ������ : LIKE, %, _
-- ������ ������ ������ ���ڿ� ��ġ�� ���ؼ� �ٷ�
-- �̸��� BR�� �����ϴ� ����� ��ȸ
-- �̸��� R ���ڿ��� ���� ����� ��ȸ

-- ��� �̸��� S�� �����ϴ� ��� ��ȸ
-- SMITH, SMILE, SKC
-- % � ���ڿ�(�ѱ���, ���� �������� �ְ�, ���� ���ڿ��� �ü��� �ִ�.)
SELECT *
FROM emp 
WHERE ename LIKE 'S%';

-- ���ڼ� ������ ���� ��Ī
-- _ ��Ȯ�� �ѹ���
-- ���� �̸��� S�� �����ϰ� �̸��� ��ü ���̰� 5������ ����
SELECT *
FROM emp
WHERE ename LIKE 'S____';

-- ��� �̸��� S���ڰ� ���� ��� ��ȸ
-- ename LIKE '%S%'
SELECT *
FROM emp
WHERE ename LIKE '%S%';

-- member ���̺��� ȸ���� ���� [��]���� ����� mem_id, mem_name�� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '��%';

-- member ���̺��� ȸ���� �̸��� ���� [��]�� ���� ��� ����� mem_id, mem_name�� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%��%';

-- null �� ���� (IS)
-- comm �÷��� ���� null�� �����͸� ��ȸ (WHERE comm = null)
SELECT *
FROM emp
WHERE comm IS NULL;

-- emp ���̺��� ��(comm)�� �ִ� ȸ���� ������ ������ ���� ��ȸ�ǵ��� ������ �ۼ��Ͻÿ�
SELECT *
FROM emp
WHERE comm IS NOT NULL;

SELECT *
FROM emp
WHERE comm >= 0;

-- ����� �����ڰ� 7698, 7839 �׸��� null�� �ƴ� ������ ��ȸ
-- NOT IN �����ڿ����� NULL���� ���� ��Ű�� �ȵȴ�
SELECT *
FROM emp
WHERE MGR NOT IN (7698, 7839, NULL);

-- -->
SELECT *
FROM emp
WHERE mgr NOT IN(7698, 7839)
AND mgr IS NOT NULL;

-- emp ���̺��� job�� SALESMAN�̰� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ������ ���� ��ȸ�ϼ���
SELECT *
FROM emp
WHERE job = 'SALESMAN'
AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

-- emp ���̺��� �μ���ȣ�� 10���� �ƴϰ� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ������ ���� ��ȸ�ϼ���
-- (IN, NOT IN ������ ������)
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('19810601', 'YYYYMMDD')
AND NOT deptno = 10;

-- emp ���̺��� �μ���ȣ�� 10���� �ƴϰ� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ������ ���� ��ȸ�ϼ���
-- (NOT IN ������ ���)
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('19810601', 'YYYYMMDD')
AND deptno NOT IN(10);

-- emp ���̺��� �μ���ȣ�� 10���� �ƴϰ� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ������ ���� ��ȸ�ϼ���
-- (�μ��� 10, 20, 30�� �ִٰ� �����ϰ� IN �����ڸ� ���)
SELECT *
FROM emp
WHERE deptno IN(20,30)
AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

-- emp ���̺��� job�� SALEMAN�̰ų� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ������ ���� ��ȸ�ϼ���
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR hiredate >= TO_DATE('19810601', 'YYYYMMDD');

-- emp ���̺��� job�� SALEMAN�̰ų� �����ȣ�� 78�� �����ϴ� ������ ������ ������ ���� ��ȸ�ϼ���
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR empno LIKE '78%';

-- emp ���̺��� job�� SALEMAN�̰ų� �����ȣ�� 78�� �����ϴ� ������ ������ ������ ���� ��ȸ�ϼ���
-- (LIKE �����ڸ� ������� ������)
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR empno BETWEEN 7800 AND 7900;

-- ������ ��������
-- *,/ �����ڰ� +,- ���� �켱������ ����
-- 1+5*2 = 11 --> (1+5)*2 X
-- �켱���� ���� �� ()
-- AND > OR


-- emp ���̺��� ��� �̸��� SMITH�̰ų� ��� �̸��� ALLEN �̸鼭 �������� SALESMAN�� ��� ��ȸ
SELECT *
FROM emp
WHERE ename = 'SMITH' 
OR ename = 'ALLEN'
AND job = 'SALESMAN';

SELECT *
FROM emp
WHERE ename = 'SMITH' 
OR (ename = 'ALLEN' AND job = 'SALESMAN');

-- ��� �̸��� SMITH�̰ų� ALLEN�̸� �������� SALESMAN�� ��� ��ȸ
SELECT *
FROM emp
WHERE (ename = 'SMITH' OR ename = 'ALLEN')
AND job = 'SALESMAN';

-- emp ���̺��� job�� SALESMAN�̰ų� �����ȣ�� 78�� �����ϸ鼭
-- �Ի� ���ڰ� 1981�� 6�� 1�� ������ ������ ������ ������ ���� ��ȸ�ϼ���
SELECT *
FROM emp
WHERE job ='SALESMAN'
OR (empno LIKE '78%' AND hiredate >= TO_DATE('19810601', 'YYYYMMDD'));

SELECT *
FROM emp
WHERE (job ='SALESMAN'
OR empno LIKE '78%') AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

-- ����
-- SELECT *
-- FROM table
-- [WHERE]
-- ORDER BY [�÷�] [��Ī] �÷��ε��� [ASC | DESC], ...]


-- emp ���̺��� ��� ����� ename �÷� ���� �������� ���� ���� ������ ����� ��ȸ�ϼ���
SELECT *
FROM emp
ORDER BY ename;

-- emp ���̺��� ��� ����� ename �÷� ���� �������� ���� ���� ������ ����� ��ȸ�ϼ���
SELECT *
FROM emp
ORDER BY ename DESC;

DESC emp; -- DES : DESCRIBE (�����ϴ�)
ORDER BY ename DESC; -- DESC : DESCENDING (����)

-- emp ���̺��� ��� ������ ename �÷��� ��������, ename ���� ���� ��� mgr �÷����� �������� �����ϴ� ������ �ۼ��ϼ���
SELECT *
FROM emp
ORDER BY ename DESC, mgr ASC;

-- ���Ľ� ��Ī�� ���
SELECT empno, ename AS NM, sal*12 AS year_sal
FROM emp
ORDER BY year_sal;

-- �÷� �ε����� ����
-- java array[0]
-- SQL COLUMN INDEX : 1���� ����
SELECT empno, ename AS NM, sal*12 AS year_sal
FROM emp
ORDER BY 3;

-- dept ���̺��� ��� ������ �μ��̸����� �������� ���ķ� ��ȸ�ǵ��� ������ �ۼ��ϼ���
SELECT *
FROM dept
ORDER BY dname;

-- dept ���̺��� ��� ������ �μ���ġ�� �������� ���ķ� ��ȸ�ǵ��� ������ �ۼ��ϼ���
SELECT *
FROM dept
ORDER BY loc DESC;

-- emp ���̺��� ��(comm) ������ �ִ� ����鸸 ��ȸ�ϰ�, �󿩸� ���� �޴� ����� ���� ��ȸ�ǵ��� �ϰ�, �󿩰� ���� ���
-- ������� �������� �����ϼ���(�󿩰� 0�� ����� �󿩰� ���� ������ ����)
SELECT *
FROM emp
WHERE comm IS NOT NULL AND comm <> 0
ORDER BY comm DESC, empno ASC;

-- emp ���̺��� �����ڰ� �ִ� ����鸸 ��ȸ�ϰ� ����(job)������ �������� �����ϰ�,
-- ������ ���� ��� ����� ū ����� ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;

-- emp ���̺��� 10�� �μ�(deptno) Ȥ�� 30�� �μ��� ���ϴ� ��� �� �޿�(sal)��
-- 1500�� �Ѵ� ����鸸 ��ȸ�ϰ� �̸����� �������� ���ĵǵ��� ������ �ۼ��ϼ���
SELECT *
FROM emp
WHERE deptno IN(10,30) AND sal>1500
ORDER BY ename;