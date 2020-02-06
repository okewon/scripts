-- fastfood ���̺��� �ѹ��� �д� ������� �ۼ��ϱ�
SELECT sido, sigungu, ROUND(((kfc + burgerking + mc) / lot), 2) burger_score
FROM
(SELECT sido, sigungu,
       NVL(SUM(decode(gb, 'KFC', 1)), 0) kfc ,NVL(SUM(decode(gb, '����ŷ', 1)), 0) burgerking,
       NVL(SUM(decode(gb, '�Ƶ�����', 1)), 0) mc, NVL(SUM(decode(gb, '�Ե�����', 1)), 1) lot
FROM fastfood
WHERE gb IN ('KFC', '����ŷ', '�Ƶ�����', '�Ե�����')
GROUP BY sido, sigungu)
ORDER BY burger_score DESC;


SELECT sido, sigungu, ROUND(sal/people) pri_sal
FROM tax
ORDER BY pri_sal DESC;

-- �ܹ��� ����, ���κ� �ٷμҵ� �ݾ� ������ ���� �õ����� [����]
-- ����, ���κ� �ٷμҵ� �ݾ����� ���� �� ROWNUM�� ���� ������ �ο�
-- ���� ������ �ೢ�� ����
-- �ܹ������� �õ�, �ܹ������� �ñ���, �ܹ�������, ���� �õ�, ���� �ñ���, ���κ� �ٷμҵ��
-- ����Ư����	    �߱�	            5.67      ����Ư����	������	    70
-- ��⵵	    ������	        5         ����Ư����	���ʱ�	    69
-- ����Ư����	    ������	        5         ����Ư����	��걸	    57
-- ����Ư����	    ������	        4.57      ��⵵	    ��õ��       54
-- ����Ư����	    ���ʱ�	        4         ����Ư���� ���α�       47

-- ROWNUM ���� ����
-- 1. SELECT ==> ORDER BY
--    ���ĵ� ����� ROWNUM�� �����ϱ� ���ؼ��� INLINE_VIEW
-- 2. 1������ ���������� ��ȸ�� �Ǵ� ���ǿ� ���ؼ��� WHERE ������ ����� ����
-- ROWNUM = 1 (O)
-- ROWNUM = 2 (X)
-- ROWNUM < 10 (O)
-- ROWNUM > 10 (X)

-- ROWNUM - ORDER BY
-- ROUND
-- GROUP BY SUM
-- JOIN
-- DECODE
-- NVL
-- IN

SELECT ROWNUM, hamburger_rn.sido, hamburger_rn.sigungu, hamburger_rn.burger_score, tax_rn.sido, tax_rn.sigungu, tax_rn.pri_sal
FROM (SELECT ROWNUM rn, hamburger.*
     FROM(SELECT sido, sigungu, ROUND(((kfc + burgerking + mc) / lot), 2) burger_score
          FROM
            (SELECT sido, sigungu,
               NVL(SUM(decode(gb, 'KFC', 1)), 0) kfc ,NVL(SUM(decode(gb, '����ŷ', 1)), 0) burgerking,
               NVL(SUM(decode(gb, '�Ƶ�����', 1)), 0) mc, NVL(SUM(decode(gb, '�Ե�����', 1)), 1) lot
             FROM fastfood
             WHERE gb IN ('KFC', '����ŷ', '�Ƶ�����', '�Ե�����')
             GROUP BY sido, sigungu)
        ORDER BY burger_score DESC) hamburger) hamburger_rn,
     (SELECT ROWNUM rn, tax.*
      FROM (SELECT sido, sigungu, ROUND(sal/people) pri_sal
            FROM tax
            ORDER BY pri_sal DESC) tax) tax_rn
WHERE hamburger_rn.rn = tax_rn.rn;


-- empno �÷��� NOT NULL ���� ������ �ִ� - INSERT �� �ݵ�� ���� �����ؾ� ���������� �Էµȴ�
-- empno �÷��� ������ ������ �÷��� NULLABLE�̴� (NULL ���� ����� �� �ִ�)

INSERT INTO emp (empno, ename, job)
VALUES (9999, 'brown', NULL);

SELECT *
FROM emp;

INSERT INTO emp (ename, job)
VALUES ('sally', 'SALESMAN');

-- ���ڿ� : '���ڿ�' ==> "���ڿ�"
-- ���� : 10
-- ��¥ : ��������� ���� TO_DATE('20200206', 'YYYYMMDD'), SYSDATE

-- emp ���̺��� hiredate �÷��� date Ÿ��
-- emp ���̺��� 8���� �÷��� ���� �Է�
DESC emp;

INSERT INTO emp
VALUES (9999, 'sally', 'SALESMAN', NULL, SYSDATE, 1000, NULL, 99);

ROLLBACK;

-- ���� ���� �����͸� �ѹ��� INSERT :
-- INSERT INTO ���̺�� (�÷���1, �÷���2, ...)
-- SELECT ...
-- FROM ;

INSERT INTO emp
SELECT 9999, 'sally', 'SALESMAN', NULL, SYSDATE, 1000, NULL, 99
FROM dual

UNION ALL

SELECT 9999, 'brown', 'CLERK', NULL, TO_DATE('20200205', 'YYYYMMDD'), 1100, NULL, 99
FROM dual;

SELECT *
FROM emp;

-- UPDATE ����
-- UPDATE ���̺�� SET �÷���1 = ������ �÷� ��1, �÷���2 = ������ �÷� ��, ...
-- WHERE �� ���� ����
-- ������Ʈ ���� �ۼ��� WHERE ���� �������� ������ �ش� ���̺��� ��� ���� ������� ������Ʈ�� �Ͼ��
-- UPDATE, DELETE ���� WHERE���� ������ �ǵ��Ѱ� �´��� �ٽ� �� �� Ȯ���Ѵ�

-- WHERE���� �ִٰ� �ϴ��� �ش� �������� �ش� ���̺��� SELECT �ϴ� ������ �ۼ��Ͽ� �����ϸ�
-- UPDATE ��� ���� ��ȸ �� �� �����Ƿ� Ȯ���ϰ� �����ϴ� �͵� ��� �߻� ������ ������ �ȴ�

-- 99�� �μ���ȣ�� ���� �μ� ������ DEPT ���̺� �ִ� ��Ȳ
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
COMMIT;

SELECT *
FROM dept;

-- 99�� �μ���ȣ�� ���� �μ��� dname �÷��� ���� '���IT', loc �÷��� ���� '���κ���'���� ������Ʈ

UPDATE dept SET dname = '���IT', loc = '���κ���'
WHERE deptno = 99;

SELECT *
FROM dept;
ROLLBACK;

-- �Ǽ��� WHERE���� ������� �ʾ��� ���
UPDATE dept SET dname = '���IT', loc = '���κ���';

-- 10 ==> SUBQUERY
-- SMITH, WARD�� ���� �μ��� �Ҽӵ� ���� ����
SELECT *
FROM emp
WHERE deptno IN (20, 30);

SELECT *
FROM emp
WHERE deptno IN (SELECT deptno FROM emp WHERE ename IN ('SMITH', 'WARD'));

-- UPDATE�ÿ��� ���� ���� ����� ����
INSERT INTO emp (empno, ename)
VALUES (9999, 'brown');

-- 9999�� ��� deptno, job ������ SMITH ����� ���� �μ�����, �������� ������Ʈ

UPDATE emp SET deptno = (SELECT deptno FROM emp WHERE ename = 'SMITH'), 
               job = (SELECT job FROM emp WHERE ename = 'WARD')
WHERE empno = 9999;

SELECT *
FROM emp;

ROLLBACK;

-- DELETE SQL : Ư�� ���� ����
-- WHERE �� ���� ����

SELECT *
FROM dept;

-- 99�� �μ���ȣ�� �ش��ϴ� �μ� ���� ����
DELETE dept
WHERE deptno = 99;

SELECT *
FROM dept;

COMMIT;

-- SUBQUERY�� ���ؼ� Ư�� ���� �����ϴ� ������ ���� DELETE
-- �Ŵ����� 7698 ����� ������ �����ϴ� ������ �ۼ�
DELETE emp
WHERE empno IN (7499, 7521, 7654, 7844, 7900);

SELECT *
FROM emp;

ROLLBACK;

DELETE emp
WHERE mgr = 7698;

DELETE emp
WHERE empno IN (SELECT empno FROM emp WHERE mgr = 7698);