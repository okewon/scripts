-- emp ���̺��� �̿��Ͽ� deptno�� ���� �μ������� �����ؼ� ������ ���� ��ȸ�Ǵ� ������ �ۼ��ϼ���

-- CASE��
SELECT empno, ename,
      CASE
            WHEN deptno = 10 THEN 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESEARCH'
            WHEN deptno = 30 THEN 'SALES'
            WHEN deptno = 40 THEN 'OPERATIONS'
            ELSE 'DDIT'
      END DNAME
FROM emp;

-- DECODE��
SELECT empno, ename,
     DECODE(deptno, 10, 'ACCOUNTING',
                    20, 'RESEARCH', 
                    30, 'SALES', 
                    40, 'OPERATIONS',
                    'DDIT') DNAME
FROM emp;

-- emp ���̺��� �̿��Ͽ� hiredate�� ���� ���� �ǰ����� ���� ��������� ��ȸ�ϴ�
-- ������ �ۼ��ϼ��� (������ �������� �ϳ� ���⼭�� �Ի�⵵�� �������� �Ѵ�
-- ���س⵵�� ¦���̸�
--      �Ի�⵵�� ¦���� �� �ǰ����� �����
--      �Ի�⵵�� Ȧ���� �� �ǰ����� ������
-- ���س⵵�� Ȧ���̸�
--      �Ի�⵵�� ¦���� �� �ǰ����� ������
--      �Ի�⵵�� Ȧ���� �� �ǰ����� �����

SELECT empno, ename, hiredate,
       DECODE(MOD(TO_NUMBER(TO_CHAR(hiredate, 'YYYY')),2), 0, DECODE(MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')), 2), 0, '�ǰ����� �����', 1, '�ǰ����� �̴����'),
                                                            1, DECODE(MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')), 2), 1, '�ǰ����� �����', 0, '�ǰ����� �̴����')) CONCAT_TO_DOCTOR
FROM emp;


-- users ���̺��� �̿��Ͽ� reg_dt�� ���� ���� �ǰ����� ���� ��������� ��ȸ�ϴ� ������ �ۼ��ϼ���.
-- (������ �������� �ϳ� ���⼭�� reg_gt�� �������� �Ѵ�)
SELECT userid, usernm, alias, reg_dt,
       CASE WHEN MOD(TO_NUMBER(TO_CHAR(reg_dt, 'YYYY')), 2) = 0 THEN 
                                                                CASE WHEN MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')), 2) = 0 THEN '�ǰ����� �����' WHEN MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')), 2) = 1 THEN '�ǰ����� ������' END
            WHEN MOD(TO_NUMBER(TO_CHAR(reg_dt, 'YYYY')), 2) = 1 THEN
                                                                CASE WHEN MOD(TO_NUMBER(TO_CHAR(reg_dt, 'YYYY')), 2) = 1 THEN '�ǰ����� �����' WHEN MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')), 2) = 0 THEN '�ǰ����� ������' END
       ELSE '�ǰ����� ������'
       END
FROM users;                        


-- GROUP BY ���� ���� ����
-- �μ���ȣ�� ���� ROW���� ���� ��� : GROUP BY deptno
-- �������� ���� ROW���� ���� ��� : GROUP BY job
-- MGR�� ���� �������� ���� ROW���� ���� ��� : GROUP BY mgr, job

-- �׷��Լ��� ����
-- SUM : �հ�
-- COUNT : ����
-- MAX : �ִ밪
-- MIN : �ּҰ�
-- AVG : ���

-- �׷� �Լ��� Ư¡
-- �ش� �÷��� NUL���� ���� ROW�� ������ ��� �ش� ���� �����ϰ� ����Ѵ� (NULL ������ ����� null)

-- �μ��� �޿� ��

-- �׷��Լ� ������
-- GROUP BY ���� ���� �÷������ �ٸ� �÷��� SELECT���� ���ԵǸ� ����
SELECT deptno, ename, 
       sum(sal) sum_sal, MAX(sal) man_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) avg_sal, COUNT(sal) count_sal,
       sum(comm)
FROM emp
GROUP BY deptno, ename;


SELECT sum(sal) sum_sal, MAX(sal) man_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) avg_sal, 
       COUNT(sal) count_sal, -- sal �÷��� ���� null�� �ƴ� row�� ����
       COUNT(comm), -- comm �÷��� ���� null�� �ƴ� row�� ����
       COUNT(*) -- ����� �����Ͱ� �ִ���
FROM emp;

-- GROUP BY�� ������ empno�̸� ������� ���??
-- �׷�ȭ�� ���þ��� ������ ���ڿ�, �Լ�, ���� ���� SELECT���� ������ ���� ����
SELECT 1, SYSDATE, 'ACCOUNTING', empno, sum(sal) sum_sal, MAX(sal) man_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) avg_sal, 
       COUNT(sal) count_sal, -- sal �÷��� ���� null�� �ƴ� row�� ����
       COUNT(comm), -- comm �÷��� ���� null�� �ƴ� row�� ����
       COUNT(*) -- ����� �����Ͱ� �ִ���
FROM emp
GROUP BY empno;


-- SINGLE ROW FUNCTION�� ��� WHERE������ ����ϴ� ���� �����ϳ� MULTI ROW FUNCTION(GROUP BY)�� ��� WHERE������ ����ϴ� ���� �Ұ����ϰ�
-- HAVING������ ������ ����Ѵ�

-- �μ��� �޿� �� ��ȸ, �� �޿����� 9000�̻��� row�� ��ȸ
-- deptno, �޿���

SELECT deptno, SUM(sal) sum_sal
FROM emp
WHERE SUM(sal) >= 9000
GROUP BY deptno;

SELECT deptno, SUM(sal) sum_sal
FROM emp
GROUP BY deptno
HAVING SUM(sal) > 9000;

-- emp ���̺��� �̿��Ͽ� ������ ���Ͻÿ�
SELECT MAX(sal) max_sal,
       MIN(sal) min_sal,
       ROUND(AVG(sal),2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal) count_sal,
       COUNT(mgr) count_mgr,
       count(*) count_all
FROM emp;


-- emp ���̺��� �̿��Ͽ� ������ ���Ͻÿ�
SELECT deptno,
       MAX(sal) max_sal,
       MIN(sal) min_sal,
       ROUND(AVG(sal),2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal) count_sal,
       COUNT(mgr) count_mgr,
       count(*) count_all
FROM emp
GROUP BY deptno;

-- emp ���̺��� �̿��Ͽ� ������ ���Ͻÿ�
-- grp2���� �ۼ��� ������ Ȱ���Ͽ� deptno ��� �μ����� ���� �� �ֵ��� �����Ͻÿ�
SELECT DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES') DNAME,
       MAX(sal) max_sal,
       MIN(sal) min_sal,
       ROUND(AVG(sal),2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal) count_sal,
       COUNT(mgr) count_mgr,
       count(*) count_all
FROM emp
GROUP BY DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES')
ORDER BY DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES');

-- emp ���̺��� �̿��Ͽ� ������ ���Ͻÿ�
-- ������ �Ի� ������� ����� ������ �Ի��ߴ��� ��ȸ�ϴ� ������ �ۼ��ϼ���
-- ORACLE 9I ���������� GROUP BY���� ����� �÷����� ������ ����
-- ORACLE 10G ���ĺ��ʹ� GROUP BY���� ����� �÷����� ������ �������� �ʴ´� (GRUOP BY ���� �ӵ� ���)
SELECT TO_CHAR(hiredate, 'YYYYMM') HIRE_YYYYMM, COUNT(*) CNT
FROM emp 
group by TO_CHAR(hiredate, 'YYYYMM');

-- emp ���̺��� �̿��Ͽ� ������ ���Ͻÿ�
-- ������ �Ի� �⺰�� ����� ������ �Ի��ߴ��� ��ȸ�ϴ� ������ �ۼ��ϼ���
SELECT TO_CHAR(hiredate, 'YYYY') HIRE_YYYYMM, COUNT(*) CNT
FROM emp 
group by TO_CHAR(hiredate, 'YYYY');

-- ȸ�翡 �����ϴ� �μ��� ������ ����� ��ȸ�ϴ� ������ �ۼ��ϼ���
-- (dept ���̺� ���)
SELECT *
FROM dept;

SELECT COUNT(*) CNT
FROM dept;

-- ������ ���� �μ��� ������ ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
-- (emp ���̺� ���)
SELECT *
FROM emp
ORDER BY deptno;

SELECT COUNT(*) CNT
FROM (SELECT COUNT(deptno)
      FROM emp
      GROUP BY deptno);