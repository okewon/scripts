-- erd ���̾�׷��� �����Ͽ� customer, cycle ���̺��� �����Ͽ� ���� ���� ��ǰ, ��������, ������ ������ ���� ����� �������� ������ �ۼ��غ�����
-- (������ brown, sally�� ���� ��ȸ)
-- (*���İ� ������� ���� ������ ����)
SELECT customer.cid, customer.cnm, cycle.pid, cycle.day, cycle.cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid;

-- erd ���̾�׷��� �����Ͽ� customer, cycle, product ���̺��� �����Ͽ� ���� ���� ��ǰ, ��������, ������ ������ ���� ����� �������� ������ �ۼ��غ�����
-- (������ brown, sally�� ���� ��ȸ)
-- (*���İ� ������� ���� ������ ����)
SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid AND cycle.pid = product.pid AND cnm IN('brown', 'sally');

-- erd ���̾�׷��� �����Ͽ� customer, cycle, product ���̺��� �����Ͽ� �������ϰ� ������� ���� ���� ��ǰ, ������ ������ ���� ����� �������� ������ �ۼ��غ�����
-- (������ brown, sally�� ���� ��ȸ)
-- (*���İ� ������� ���� ������ ����)
SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, COUNT(product.pnm) cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid AND cycle.pid = product.pid
GROUP BY customer.cid, customer.cnm, cycle.pid, product.pnm;

-- erd ���̾�׷��� �����Ͽ� cycle, product ���̺��� �̿��Ͽ� ��ǰ�� ������ �հ� ��ǰ���� ������ ���� ����� �������� ������ �ۼ��غ�����
-- (*���İ� ������� ���� ������ ����)
SELECT cycle.pid, product.pnm, COUNT(product.pnm)
FROM cycle, product
WHERE cycle.pid = product.pid
GROUP BY cycle.pid, product.pnm
ORDER BY product.pnm;

SELECT *
FROM dba_users;

ALTER USER HR IDENTIFIED BY java;
ALTER USER HR ACCOUNT UNLOCK;

-- OUTER JOIN
-- �� ���̺��� ������ �� ���� ������ ������Ű�� ���ϴ� �����͸� �������� ������ ���̺��� �����͸��̶�
-- ��ȸ �ǰԲ� �ϴ� ���� ���

-- ���� ���� : e.mgr = m.empno : KING�� MGR�� NULL�̱� ������ ���ο� �����Ѵ�.
-- emp ���̺��� �����ʹ� �� 14�������� �Ʒ��� ���� ���������� ����� 15���� �ȴ�.(1���� ���ν���)
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

-- ANSI OUTER
-- 1. ���ο� �����ϴ��� ��ȸ�� �� ���̺��� ���� (�Ŵ��� ������ ��� ��������� �����Բ�)
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e LEFT OUTER JOIN emp m ON e.mgr = m.empno;

-- RIGHT OUTER�� ����
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp m RIGHT OUTER JOIN emp e ON e.mgr = m.empno;

-- ORACLE OUTER JOIN
-- �����Ͱ� ���� ���� ���̺� �÷� �ڿ� (+)��ȣ�� �ٿ��ش�
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.empno = m.empno(+);

SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.empno = m.empno(+);

-- ���� SQL�� ANSI SQL(OUTER JOIN)���� �����غ�����
-- �Ŵ����� �μ� ��ȣ�� 10���� ������ ��ȸ
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno AND m.deptno = 10);


-- �Ʒ� LEFT OUTER ������ ���������� OUTER ������ �ƴϴ�.
-- �Ʒ� INNER ���ΰ� ����� �Ȱ���.
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON e.mgr = m.empno
WHERE m.deptno = 10;

SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e JOIN emp m ON e.mgr = m.empno
WHERE m.deptno = 10;

-- ORACLE OUTER JOIN
-- ORACLE OUTER JOIN�� ���� ���̺��� �ݴ��� ���̺��� ��� �÷��� (+)�� �ٿ��� �������� OUTER JOIN���� �����Ѵ�.
-- �� �÷��̶� (+)fmf snfkrgkaus INNER �������� ����

-- �Ʒ� ORACLE OUTER JOIN�� INNER �������� ���� : m.deptno �÷��� (+)r�� ���� ����
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+) AND m.deptno = 10;

SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+) AND m.deptno(+) = 10;

-- ��� - �Ŵ����� RIGHT OUTER JOIN
SELECT empno, ename, mgr
FROM emp e;
 
SELECT empno, ename, mgr
FROM emp m;

SELECT e.empno, e.ename, e.mgr, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno);

-- FULL OUTER : LEFT OUTER + RIGHT OUTER - �ߺ� ����
-- LEFT OUTER : 14��, RIGHT OUTER : 21��, FULL OUTER : 22��
SELECT e.empno, e.ename, e.mgr, m.empno, m.ename
FROM emp e FULL  OUTER JOIN emp m ON (e.mgr = m.empno);

-- ORACLE JOIN������ (+)���� FULL OUTER�� �������� �ʴ´�.

-- buyprod, prod���̺� �������ڰ� 2005�� 1�� 25���� �����ʹ� 3ǰ�� �ۿ� ����.
-- ��� ǰ���� ���� �� �ֵ��� ������ �ۼ��غ�����
SELECT buyprod.buy_date, buyprod.buy_prod, prod.prod_id, prod.prod_name, buyprod.buy_qty
FROM buyprod RIGHT OUTER JOIN prod ON (buyprod.buy_prod = prod.prod_id AND buyprod.buy_date = TO_DATE('2005-01-25', 'YYYY-MM-DD')); 

SELECT buyprod.buy_date, buyprod.buy_prod, prod.prod_id, prod.prod_name, buyprod.buy_qty
FROM buyprod, prod
WHERE prod.prod_id = buyprod.buy_prod(+)
AND buyprod.buy_date(+) = TO_DATE('20050125', 'YYYYMMDD');

SELECT *
FROM buyprod;

SELECT *
FROM prod;

-- outer join1���� �۾��� �����ϼ���. buy_date �÷��� null�� �׸��� �ȳ������� ����ó�� �����͸� ä�������� ������ �ۼ��ϼ���.
SELECT NVL(buyprod.buy_date, TO_DATE('2005-01-25', 'YYYY-MM-DD')), buyprod.buy_prod, prod.prod_id, prod.prod_name, buyprod.buy_qty
FROM prod LEFT OUTER JOIN buyprod ON (buyprod.buy_prod = prod.prod_id AND buyprod.buy_date = TO_DATE('2005-01-25', 'YYYY-MM-DD')); 

-- outer join2���� �۾��� �����ϼ���.
-- buy_qty �÷��� null�� ��� 0���� ���̵��� ������ �����ϼ���.
SELECT NVL(buyprod.buy_date, TO_DATE('2005-01-25', 'YYYY-MM-DD')), buyprod.buy_prod, prod.prod_id, prod.prod_name, NVL(buyprod.buy_qty, 0)
FROM prod LEFT OUTER JOIN buyprod ON (buyprod.buy_prod = prod.prod_id AND buyprod.buy_date = TO_DATE('2005-01-25', 'YYYY-MM-DD')); 















