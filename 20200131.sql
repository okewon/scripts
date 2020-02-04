-- ���� �⵵�� ¦�� ���а�, REF_DT �⵵�� ¦�� ������ �����ϸ� --> �ǰ����� �����
-- ���� �⵵�� ¦�� ���а�, REF_DT �⵵�� ¦�� ������ �������� ������ --> �ǰ����� ������

SELECT ename, deptno
FROM emp;

SELECT *
FROM dept;

-- JOIN : �� ���̺��� �����ϴ� �۾�
-- JOIN ����
-- 1. ANSI ����
-- 2. ORACLE ����

-- Natural Join
-- �� ���̺� �÷����� ���� �� �ش� �÷����� ����(����)
-- emp, dept ���̺��� deptno��� �÷��� ����

SELECT *
FROM emp NATURAL JOIN dept;

-- Natural Join�� ���� ���� �÷�(deptno)�� ������(ex: ���̺��, ���̺� ��Ī)�� ������� �ʰ�
-- �÷��� ����Ѵ� ( dept.deptno --> deptno )
SELECT emp.empno, emp.ename, dept.dname, deptno
FROM emp NATURAL JOIN dept;

-- ���̺� ���� ��Ī�� ��밡��
SELECT e.empno, e.ename, d.dname, deptno
FROM emp e NATURAL JOIN dept d;

-- ORACLE JOIN
-- FROM ���� ������ ���̺� ����� ,�� �����Ͽ� �����Ѵ�
-- ������ ���̺��� ���� ������ WHERE���� ����Ѵ�
-- emp, dept ���̺� �����ϴ� deptno �÷��� (���� ��) ����
SELECT emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno != dept.deptno;

-- ����Ŭ ������ ���̺� ��Ī
SELECT e.empno, e.dname, d.dname, e.deptno
FROM emp e, dept d
WHERE e.deptno = d.deptno;

-- ANSI : join with USING
-- �����Ϸ��� �ΰ��� ���̺� �̸��� ���� �÷��� �ΰ������� �ϳ��� �÷����θ� �����ϰ����� �� �����Ϸ��� ���� �÷��� ���;
-- emp, dept ���̺��� ���� �÷� : deptno;
SELECT emp.ename, dept.dname, deptno
FROM emp JOIN dept USING(deptno);

-- JOIN WHIT USING�� ORACLE�� ǥ���Ѵٸ�?
SELECT emp.ename, dept.dname, emp.deptno
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- ANSI : JOIN WITH ON
-- �����Ϸ��� �ϴ� ���̺��� �÷� �̸��� ���� �ٸ���
SELECT emp.ename, dept.dname, emp.deptno
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

-- JOIN WHIT ON --> ORACLE
SELECT emp.ename, dept.dname, emp.deptno
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- SELF JOIN : ���� ���̺��� ����;
-- �� : emp ���̺��� �����Ǵ� ����� ������ ����� �̿��Ͽ� ������ �̸��� ��ȸ�� ��; 
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno) ;

-- ����Ŭ �������� �ۼ�;
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

-- equal ���� : =
-- non - equal ���� : !=, >, <, BETWEEN AND;

SELECT ename, sal
FROM emp;

SELECT *
FROM salgrade;

-- ����� �޿� ������ �޿� ��� ���̺��� �̿��Ͽ� �ش����� �޿� ����� ���غ���;
-- ANSI ������ �̿��Ͽ� ���� ���� �ۼ�;
SELECT emp.ename, emp.sal, salgrade.grade
FROM emp JOIN salgrade ON(emp.sal BETWEEN losal AND hisal);

-- ����Ŭ ������ �̿��Ͽ� ���� ���� �ۼ�;
SELECT emp.ename, emp.sal, salgrade.grade
FROM emp, salgrade
WHERE emp.sal BETWEEN losal AND hisal;

-- emp, dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��Ͽ���
SELECT emp.empno, emp.ename, deptno, dept.dname
FROM emp NATURAL JOIN dept
ORDER BY deptno;

-- emp, dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���
-- (�μ���ȣ�� 10, 30�� �����͸� ��ȸ)
SELECT emp.empno, emp.ename, dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno AND dept.deptno IN(10, 30);

-- emp, dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���
-- (�޿��� 2500�ʰ�)
SELECT emp.empno, emp.ename, emp.sal, dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno AND emp.sal > 2500
ORDER BY dept.deptno; 

-- emp, dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���
-- (�޿��� 2500�ʰ�, ����� 7600���� ū ����)
SELECT emp.empno, emp.ename, emp.sal, dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno AND emp.sal > 2500 AND emp.empno > 7600
ORDER BY dept.deptno; 


-- emp, dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��Ͽ���
-- (�޿��� 2500�ʰ�, ����� 7600���� ū�� �μ����� RESEARCH�� �μ��� ���� ����)
SELECT emp.empno, emp.ename, emp.sal, dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno AND emp.sal > 2500 AND emp.empno > 7600 AND dept.dname = 'RESEARCH'
ORDER BY dept.deptno; 

-- PROD : PROD_LGU
-- LPROD : LPROD

-- erd ���̾�׷��� �����Ͽ� prod ���̺�� lprod ���̺��� �����Ͽ� ������ ���� ����� ������ ������ �ۼ��غ�����
SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM lprod, prod
WHERE prod.prod_LGU = lprod.lprod_gu;

-- erd ���̾�׷��� �����Ͽ� buyer, prod ���̺��� �����Ͽ� buyer�� ����ϴ� ��ǰ ������ ������ ���� ����� �������� ������ �ۼ��غ�����
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer, prod
WHERE prod.prod_buyer = buyer.buyer_id
ORDER BY buyer.buyer_id;

-- erd ���̾�׷��� �����Ͽ� member, cart, prod ���̺��� �����Ͽ� ȸ���� ��ٱ��Ͽ� ���� ��ǰ ������ ������ ���� ����� ������ ������ �ۼ��غ�����
SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
FROM member, prod, cart
WHERE member.mem_id = cart.cart_member AND cart.cart_prod = prod.prod_id;

-- ANSI ����
SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
FROM member JOIN cart ON (member.mem_id = cart.cart_member) JOIN prod ON cart.cart_prod = prod.prod_id;

-- erd ���̾�׷��� �����Ͽ� customer, cycle ���̺��� �����Ͽ� ���� ���� ��ǰ, ��������, ������ ������ ���� ����� �������� ������ �ۼ��غ�����
-- (������ brown, sally�� ���� ��ȸ)
-- (*���İ� ������� ���� ������ ����)
SELECT customer.cid, customer.cnm, cycle.pid, cycle.day, cycle.cnt
FROM customer, cycle
WHERE customer.cid = cycle.pid;

-- erd ���̾�׷��� �����Ͽ� customer, cycle, product ���̺��� �����Ͽ� ���� ���� ��ǰ, ��������, ������ ������ ���� ����� �������� ������ �ۼ��غ�����
-- (������ brown, sally�� ���� ��ȸ)
-- (*���İ� ������� ���� ������ ����)


-- erd ���̾�׷��� �����Ͽ� customer, cycle, product ���̺��� �����Ͽ� �������ϰ� ������� ���� ���� ��ǰ, ������ ������ ���� ����� �������� ������ �ۼ��غ�����
-- (������ brown, sally�� ���� ��ȸ)
-- (*���İ� ������� ���� ������ ����)


-- erd ���̾�׷��� �����Ͽ� cycle, product ���̺��� �̿��Ͽ� ��ǰ�� ������ �հ� ��ǰ���� ������ ���� ����� �������� ������ �ۼ��غ�����
-- (*���İ� ������� ���� ������ ����)


