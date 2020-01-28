-- emp ���̺��� 10�� �μ�(deptno) Ȥ�� 30�� �μ��� ���ϴ� ��� �� �޿�(sal)�� 1500�� �Ѵ� ����鸸
-- ��ȸ�ϰ� �̸����� �������� ���ĵǵ��� ������ �ۼ��ϼ���
SELECT *
FROM emp
WHERE deptno IN(10,30)
AND sal > 1500
ORDER BY ename DESC;

-- ROWNUM : Ⱦ��ȣ�� ��Ÿ���� �÷�
SELECT ROWNUM, empno, ename
FROM emp
WHERE deptno IN(10,30)
AND sal > 1500;

-- ROWNUM�� WHERE�������� ��밡��
-- �����ϴ°� : ROWNUM = 1, ROWNUM <= 2 --> ROWNUM = 1, ROWNUM <= N 
-- �������� �ʴ°� : ROWNUM = 2, ROWNUM >= 2 --> ROWNUM = N(N�� 1�� �ƴ� ����), ROWNUM >= N(N�� 1�� �ƴ� ����)
-- ROWNUM �̹� ���� �����Ϳ��ٰ� ������ �ο�
-- **������1 : ���� ���� ������ ����(ROWNUM�� �ο����� ���� ��)�� ��ȸ�� ���� ����.
-- **������2 : ORDER BY ���� SELECT �� ���Ŀ� ����
-- ��� �뵵 : ����¡ ó��
-- ���̺� �ִ� ��� ���� ��ȸ�ϴ� ���� �ƴ϶� �츮�� ���ϴ� �������� �ش��ϴ� �� �����͸� ��ȸ�� �Ѵ�.
-- ����¡ ó���� ������� : 1�������� �Ǽ�, ���� ����
-- emp ���̺� �� row �Ǽ� : 14
-- �������� 5���� �����͸� ��ȸ
-- 1page : 1 ~ 5
-- 2page : 6 ~ 10
-- 3page : 11 ~ 15
SELECT ROWNUM rn, empno, ename
FROM emp
ORDER BY ename;

-- ���ĵ� ����� ROWNUM�� �ο��ϱ� ���ؼ��� IN LINE VIEW�� ����Ѵ�
-- �������� : 1. ����, 2.ROWNUM �ο�

-- SELECT *�� ����� ��� �ٸ� EXPRESSION�� ǥ���ϱ� ���ؼ� ���̺��.* ���̺��Ī.*�� ǥ���ؾ� �Ѵ�.
SELECT ROWNUM, emp.*
FROM emp;

SELECT ROWNUM, e.*
FROM emp e;

-- ROWNUM -> rn
-- *page size : 5, ���ı����� ename
-- 1 page : rn 1 ~ 5
-- 2 page : rn 6 ~ 10
-- 3 page : rn 11 ~ 15
-- n page : rn (page-1)* pageSize + 1 ~ page * pageSize
SELECT *
FROM
    (SELECT ROWNUM rn, a.*
    FROM
        (SELECT empno, ename
        FROM emp
        ORDER BY ename) a)
WHERE rn BETWEEN (1 - 1) * 5 AND 1 * 5;

-- emp ���̺��� ROWNUM ���� 1~10�� ���� ��ȸ�ϴ� ������ �ۼ��غ����� (���ľ��� �����ϼ���, ����� ȭ��� �ٸ� �� �ֽ��ϴ�)
SELECT ROWNUM rn, empno, ename
FROM emp
WHERE ROWNUM <= 10 AND ROWNUM >= 1;

-- ROWNUM ���� 11~20(11~14)�� ���� ��ȸ�ϴ� ������ �ۼ��غ�����
-- HINT : alias, inline - view
SELECT *
FROM (SELECT ROWNUM RN, empno, ename
      FROM emp)
WHERE RN BETWEEN 11 AND 20;

-- emp ���̺��� ��� ������ �̸��÷����� �������� �������� ���� 11~14��° ���� ������ ���� ��ȸ�ϴ� ������ �ۼ��غ�����
SELECT *
FROM 
    (SELECT ROWNUM RN, B.*
    FROM
        (SELECT empno, ename
        FROM emp
        ORDER BY ename) B)
WHERE RN BETWEEN (:page-1)* :pageSize +1 AND :page*:pageSize;

SELECT *
FROM 
    (SELECT ROWNUM RN, B.*
    FROM
        (SELECT empno, ename
        FROM emp
        ORDER BY ename) B)
WHERE RN BETWEEN 11 AND 14;

-- DUAL ���̺� : �����Ϳ� ���� ����, �Լ��� �׽�Ʈ �غ� �������� ���
-- ���ڿ� ��ҹ��� : LOWER, UPPPER, INITCAP
SELECT *
FROM dual;

SELECT LENGTH('TEST')
FROM dual;

SELECT LOWER('Hello, world'), UPPER('Hello, world'),INITCAP('Hello, world')
FROM dual;

SELECT LOWER(ename), UPPER(ename),INITCAP(ename)
FROM emp;

-- �Լ��� WHERE �������� ��� ����
-- ��� �̸��� SMITH�� ����� ��ȸ
SELECT *
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM emp
WHERE ename = UPPER(:ename);

-- SQL �ۼ��� �Ʒ� ���´� �����ؾ� �Ѵ�.
-- ���̺��� �÷��� �������� �ʴ� ���·� SQL�� �ۼ��Ѵ�.
SELECT *
FROM emp
WHERE ename = UPPER(:ename);

SELECT CONCAT('Hello,', ' world') CONCAT,
       SUBSTR('Hello, world', 1 ,5) SUBSTR, -- 1~5
       LENGTH('Hello, world') LENGTH,
       INSTR('Hello, world', 'o') INSTR1,
       INSTR('Hello, world', 'o', 6) INSTR2,
       LPAD('Hello, world', 15, '*') LPAD,
       RPAD('Hello, world', 15, '*') RPAD,
       REPLACE('Hello, world', 'H', 'T') REPLACE,
       TRIM('   Hello, world   ') TRIM, -- ������ ����
       TRIM('d' FROM 'Hello, world') TRIM2 --������ �ƴ� �ҹ��� d ����
FROM dual;

-- ���� �Լ�
-- ROUND : �ݿø� (10.6�� �Ҽ��� ù��° �ڸ����� �ݿø� -> 11)
-- TRUNC : ����(����) (10.6�� �Ҽ��� ù��° �ڸ����� ���� -> 10)
-- ROUND, TRUNC : ���° �ڸ����� �ݿø�/����
-- MOD : ������ (���� �ƴ϶� ������ ������ �� ������ ��) (13/5 -> �� : 2, ������ : 3)

-- ROUND(��� ����, ���� ��� �ڸ�)
SELECT ROUND(105.54, 1) ROUND,-- �ݿø� ����� �Ҽ��� ù��° �ڸ����� �������� --> �ι�° �ڸ����� �ݿø�
       ROUND(105.55,1) ROUND,-- �ݿø� ����� �Ҽ��� ù��° �ڸ����� �������� --> �ι�° �ڸ����� �ݿø�
       ROUND(105.55,0) ROUND,-- �ݿø� ����� �����θ� --> �Ҽ��� ù��° �ڸ����� �ݿø�
       ROUND(105.55,-1) ROUND,-- �ݿø� ����� ���� �ڸ����� --> ���� �ڸ����� �ݿø�
       ROUND(105.55) ROUND -- �ι�° ���ڸ� �Է����� ���� ��� 0�� ����
FROM dual;

SELECT TRUNC(105.54, 1) TRUNC, -- ������ ����� �Ҽ��� ù��° �ڸ����� �������� -- > �ι�° �ڸ����� ����
       TRUNC(105.55, 1) TRUNC, -- ������ ����� �Ҽ��� ù��° �ڸ����� �������� --> �ι�° �ڸ����� ����
       TRUNC(105.55, 0) TRUNC, -- ������ ����� ������(���� �ڸ�)���� �������� --> �Ҽ��� ù��° �ڸ����� ����
       TRUNC(105.55, -1) TRUNC, -- ������ ����� 10�� �ڸ����� �������� --> ���� �ڸ����� ����
       TRUNC(105.55) TRUNC -- �ι�° ���ڸ� �Է����� ���� ��� 0�� ����
FROM dual;

-- EMP ���̺��� ����� �޿�(sal)�� 100���� ������ �� ���� ���Ͻÿ�
SELECT ename, sal,
       TRUNC(sal/1000) TRUNC_sal, -- ���� ���غ�����
       MOD(sal, 1000) MOD_sal -- MOD�� ����� divisor���� �׻� �۴�(0~999)
FROM emp;

DESC emp;

-- �⵵ 2�ڸ�/�� 2�ڸ�/���� 2�ڸ�
SELECT ename, hiredate
FROM emp;

-- SYSDATE : ���� ����Ŭ ������ �ú��ʰ� ���Ե� ��¥ ������ �����ϴ� Ư�� �Լ�
-- �Լ���(����1, ����2)
-- date + ���� = ���� ����
-- 2020/01/28 + 5
-- 1 = �Ϸ�
-- 1�ð� = 1/24

-- ���� ǥ�� : ����
-- ���� ǥ�� : �̱� �����̼� + ���ڿ� + �̱� �����̼� --> '���ڿ�'
-- ��¥ ǥ�� : TO_DATE('���ڿ� ��¥ ��', '���ڿ� ��¥ ���� ǥ�� ����') --> TO_DATE('2020-01-28', 'YYYY-MM-DD')
SELECT SYSDATE + 5, SYSDATE + 1/24
FROM dual;

SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD') LASTDAY, TO_DATE('2019/12/31', 'YYYY/MM/DD') - 5 LASTDAY_BEFORE5,
       SYSDATE NOW, SYSDATE - 3 NOW_BEFORE3
FROM dual;