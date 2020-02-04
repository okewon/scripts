-- CROSS JOIN ==> īƼ�� ���δ�Ʈ(Cartesian product)
-- �����ϴ� �� ���̺��� ���� ������ �����Ǵ� ��� : ������ ��� ���տ� ���� ����(����)�� �õ�
-- dept(4��), emp(14��)�� CROSS JOIN�� ����� 4 * 14 = 56��

-- dept ���̺�� emp ���̺��� ������ �ϱ� ���� FROM ���� �ΰ��� ���̺��� ���
-- WHERE���� �� ���̺��� ���� ������ ����

SELECT dept.dname, emp.empno, emp.ename
FROM dept, emp
WHERE dept.deptno = 10
      AND dept.deptno = emp.deptno;
      
-- customer, product ���̺��� �̿��Ͽ� ���� ���� ������ ��� ��ǰ�� ������ �����Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���
SELECT customer.cid, customer.cnm, product.pid, product.pnm
FROM customer, product;

-- SUBQUERY : ���� �ȿ� �ٸ� ������ �� �ִ� ���
-- SUBQUERY�� ���� ��ġ�� ���� 3������ �з�
-- SELECT �� : SCALA SUBQUERY : �ϳ��� ��, �ϳ��� �÷��� �����Ͽ� ������ �߻����� ����
-- FROM �� : INLINE - VIEW (VIEW)
-- WHERE �� : SUBQUERY QUERY

-- SMITH�� ���� �μ��� ���ϴ� �������� ������ ��ȸ
-- 1. SMITH�� ���ϴ� �μ� ��ȣ�� ���Ѵ�.
-- 2. 1������ ���� �μ� ��ȣ�� ������ ������ ��ȸ�Ѵ�.


-- 1
SELECT deptno
FROM emp
WHERE ename = 'SMITH';

-- 1���� ���� �μ���ȣ�� �̿��Ͽ� �ش� �μ��� ���ϴ� ���� ������ ��ȸ
SELECT *
FROM emp
WHERE deptno = 10;

-- SUBQUERY�� �̿��ϸ� �ΰ��� ������ ���ÿ� �ϳ��� SQL�� ������ ����
SELECT *
FROM emp
WHERE deptno = ( SELECT deptno
                 FROM emp
                 WHERE ename = 'SMITH');
                 
-- ��� �޿����� ���� �޿��� �޴� ������ ���� ��ȸ�ϼ���
SELECT COUNT(*)
FROM emp
WHERE sal > ( SELECT AVG(sal)
              FROM emp );
              
-- ��� �޿亸�� ���� �޿��� �޴� ������ ������ ��ȸ�ϼ���              
SELECT *
FROM emp
WHERE sal > ( SELECT AVG(sal)
              FROM emp );
              
-- SMITH�� WARD ����� ���� �μ��� ��� ��� ������ ��ȸ�ϴ� ������ ������ ���� �ۼ��ϼ���
SELECT *
FROM emp
WHERE deptno IN ( SELECT deptno
                 FROM emp
                 WHERE ename IN ('SMITH', 'WARD'));

-- ������ ������
-- IN : ���� ������ ������ �� ��ġ�ϴ� ���� ������ ��
-- ANY (Ȱ�뵵�� �ټ� ������) : ���������� ������ �� �� ���̶� ������ ������ ��
-- ALL (Ȱ�뵵�� �ټ� ������) : ���������� ������ �� ��� �࿡ ���� ������ ������ ��

-- SMITH�� ���ϴ� �μ��� ��� ������ ��ȸ
SELECT deptno
FROM emp
WHERE ename = 'SMITH' OR ename = 'WARD';

SELECT *
FROM emp
WHERE deptno IN (20, 30);

-- SMITH�� WARD ������ ���ϴ� �μ��� ��� ������ ��ȸ
SELECT *
FROM emp
WHERE deptno IN ( SELECT deptno
                 FROM emp
                 WHERE ename IN ('SMITH', 'WARD'));

-- ���� ������ ����� ���� ���� ����  = �����ڸ� ������� ���Ѵ�.

-- SMITH, WARD ����� �޿����� �޿��� ���� ������ ��ȸ(SMITH, WARD�� �޿� �� �ƹ��ų�)
SELECT *
FROM emp
WHERE ename IN ('SMITH', 'WARD');

SELECT *
FROM emp
WHERE sal < ANY (800, 1250);

SELECT *
FROM emp
WHERE sal < ANY ( SELECT sal
                  FROM emp
                  WHERE ename IN ('SMITH', 'WARD'));
                  
-- SMITH, WARD ����� �޿����� �޿��� ���� ������ ��ȸ(SMITH, WARD�� �޿� 2���� ��ο� ���� ���� ��)                  
SELECT *
FROM emp
WHERE sal > ALL ( SELECT sal
                  FROM emp
                  WHERE ename IN ('SMITH', 'WARD'));

-- IN, NOT IN�� NULL�� ���õ� ���ǻ���
-- ������ ������ ����� 7902�̰ų�(OR) NULL
SELECT *
FROM emp
WHERE mgr IN (7902, null);

-- NULL �񱳴� = �����ڰ� �ƴ϶� IS NULL�� ���ؾ� ������ IN �����ڴ� =�� ����Ѵ�.
SELECT *
FROM emp
WHERE mgr = 7902
OR mgr = null;

SELECT *
FROM emp
WHERE mgr = 7902
OR mgr IS null;

-- empno NOT IN (7902, NULL) ==> AND
-- ��� ��ȣ�� 7902�� �ƴϸ鼭 NULL�� �ƴ� ������
SELECT *
FROM emp
WHERE mgr NOT IN (7902, null);

SELECT *
FROM emp
WHERE mgr != 7902
AND mgr != NULL;

SELECT *
FROM emp
WHERE mgr != 7902
AND mgr IS NOT NULL;

-- pairwise (������)
-- �������� ����� ���ÿ� ���� ��ų ��
SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499, 7782));
                        
-- nor-pairwise�� �������� ���ÿ� ������Ű�� �ʴ� ���·� �ۼ�
-- mgr ���� 7698�̰ų� 7839 �̸鼭
-- deptno�� 10�̰ų� 30���� ����
-- MGR, DEPTNO
-- (7698, 10), (7698, 30)
-- (7839, 10), (7839, 30)
SELECT *
FROM emp
WHERE mgr IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499, 7782))
AND deptno IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499, 7782));

-- SCALA SUBQUERY : SELECT ���� ���, 1���� ROW, 1���� COL�� ��ȸ�ϴ� ����
-- SCALA SUBQUERY�� MAIN ������ �÷��� ����ϴ°� �����ϴ�.
SELECT (SELECT SYSDATE
        FROM dual), dept.*
FROM dept;

SELECT emp.empno, emp.ename, deptno, 
      (SELECT dname FROM dept WHERE deptno = emp.deptno) dname
FROM emp;

-- INLINE VIEW : FROM ���� ����Ǵ� ��������;

-- MAIN ������ �÷��� SUBQUERY���� ����ϴ� �� ������ ���� �з�
-- ����� ��� : CORRELATED SUBQUERY (��ȣ ���� ����), ���� ������ �ܵ����� �����ϴ°� �Ұ���
--             ��������� �������ִ� (main ==> sub)
-- ������� ���� ��� : NON-CORRELATED SUBQUERY(���ȣ ���� ��������), ���������� �ܵ����� �����ϴ°� ����
--                   ��������� ������ ���� �ʴ� (main ==> sub, sub ==> main)

-- ��� ������ �޿� ��պ��� �޿��� ���� ����� ��ȸ
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);
             
-- ������ ���� �μ��� �޿� ��պ��� �޿��� ���� ����� ��ȸ
SELECT *
FROM emp m
WHERE sal > (SELECT AVG(sal)
             FROM emp s
             WHERE s.deptno = m.deptno);
             
-- ���� ������ ������ �̿��ؼ� Ǯ���
-- 1. ���� ���̺� ����
-- emp, �μ��� �޿� ���(inline view)
SELECT emp.ename, sal, emp.deptno, dept_sal.*
FROM emp, (SELECT deptno, ROUND(AVG(sal)) avg_sal
           FROM emp
           GROUP BY deptno) dept_sal
WHERE emp.deptno = dept_sal.deptno
AND emp.sal > dept_sal.avg_sal;

-- dept ���̺��� �ű� ��ϵ� 99�� �μ��� ���� ����� ����
-- ������ ������ ���� �μ��� ��ȸ�ϴ� ������ �ۼ��غ�����.
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
-- ROLLBACK : Ʈ����� ���
-- COMMIT : Ʈ����� Ȯ��

DELETE dept
WHERE deptno = 99;

COMMIT;

-- ��ȣ����
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                     FROM emp
                     WHERE emp.deptno = dept.deptno)
ORDER BY deptno DESC;

-- ���ȣ����


-- cycle, product ���̺��� �̿��Ͽ� cid = 1�� ���� �������� �ʴ� ��ǰ�� ��ȸ�ϴ� ������ �ۼ��ϼ���
SELECT pid, pnm
FROM product
WHERE pid NOT IN (SELECT pid
                  FROM cycle
                  WHERE cycle.cid = 1);
                  
SELECT *
FROM product;

SELECT *
FROM cycle;

-- cycle ���̺��� �̿��Ͽ� cid = 2�� ���� �����ϴ� ��ǰ �� cid = 1�� ���� �����ϴ� ��ǰ�� ���������� ��ȸ�ϴ� ������ �ۼ��ϼ���


-- customer, cycle, product ���̺��� �̿��Ͽ� cid = 2�� ���� �����ϴ� ��ǰ �� cid = 1�� ���� �����ϴ� ��ǰ�� ������ ��ȸ�ϰ� ����� ��ǰ�����
-- �����ϴ� ������ �ۼ��ϼ���

