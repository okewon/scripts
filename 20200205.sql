-- cycle ���̺��� �̿��Ͽ� cid = 2�� ���� �����ϴ� ��ǰ �� cid = 1�� ���� �����ϴ� ��ǰ�� ���������� ��ȸ�ϴ� ������ �ۼ��ϼ���
SELECT DISTINCT cycle.cid, cycle.pid, cycle.day, cycle.cnt
FROM (SELECT pid
      FROM cycle
      WHERE cid = 2) b, cycle
WHERE b.pid = cycle.pid AND cycle.cid = 1
ORDER BY day DESC;

SELECT *
FROM cycle
WHERE cid = 1
AND pid IN (SELECT pid
            FROM cycle
            WHERE cid = 2);

-- customer, cycle, product ���̺��� �̿��Ͽ� cid = 2�� ���� �����ϴ� ��ǰ �� cid = 1�� ���� �����ϴ� ��ǰ�� ������ ��ȸ�ϰ� ����� ��ǰ�����
-- �����ϴ� ������ �ۼ��ϼ���
SELECT DISTINCT cycle.cid, customer.cnm, product.pid, product.pnm, cycle.day, cycle.cnt
FROM (SELECT pid
      FROM cycle
      WHERE cid = 2) b, cycle, product, customer
WHERE b.pid = cycle.pid AND cycle.cid = 1 AND product.pid = cycle.pid AND cycle.cid = customer.cid
ORDER BY day DESC;

SELECT cycle.cid, customer.cnm, product.pid, product.pnm, cycle.day, cycle.cnt
FROM cycle, customer, product
WHERE cycle.cid = 1
AND cycle.pid IN (SELECT pid
                  FROM cycle
                  WHERE cid = 2)
AND cycle.cid = customer.cid
AND product.pid = cycle.pid;

-- �Ŵ����� �����ϴ� ������ ��ȸ(KING�� ������ 13���� �����Ͱ� ��ȸ)
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- EXISTS ���ǿ� �����ϴ� ���� �����ϴ��� Ȯ���ϴ� ������
-- �ٸ� �����ڿʹ� �ٸ��� WHERE ���� �÷��� ������� �ʴ´�
-- WHERE empno = 7739
-- WHERE EXIST (SELECT *
--              FROM .....);

-- �Ŵ����� �����ϴ� ������ EXISTS �����ڸ� ���� ��ȸ
-- �Ŵ����� ����
SELECT *
FROM emp e
WHERE EXISTS (SELECT 'X'
              FROM emp m
              WHERE e.mgr = m.empno);
              
SELECT * from product;

-- cycle, product ���̺��� �̿��Ͽ� cid�� ���� �����ϴ� ��ǰ�� ��ȸ�ϴ� ������ EXISTS �����ڸ� ����Ͽ� �ۼ��ϼ���
SELECT *
FROM cycle
WHERE cid = 1;

SELECT *
FROM product
WHERE EXISTS (SELECT 'x'
              FROM cycle
              WHERE cid = 1
              AND cycle.pid = product.pid);
              
-- cycle, product ���̺��� �̿��Ͽ� cid�� ���� �����ϴ� ��ǰ�� ��ȸ�ϴ� ������ EXISTS �����ڸ� ����Ͽ� �ۼ��ϼ���
SELECT *
FROM product
WHERE NOT EXISTS (SELECT *
              FROM cycle
              WHERE cid = 1
              AND cycle.pid = product.pid);              
              
-- ���� ����
-- ������ : UNION - �ߺ�����(���հ���) / UNION ALL - �ߺ��� �������� ���� (�ӵ� ���)
-- ������ : INTERSEC (���հ���)
-- ������ : MINUS (���հ���)
-- ���տ��� �������
-- �� ������ �÷��� ����, Ÿ���� ��ġ �ؾ� �Ѵ�.

-- ������ ���� �������ϱ� ������ �ߺ��Ǵ� �����ʹ� �ѹ��� ����ȴ�

-- UNION
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698)


UNION

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

-- UNION ALL �����ڴ� UNION �����ڿ� �ٸ��� �ߺ��� ����Ѵ�;                    
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698)


UNION ALL

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

-- INTERSECT (������) : ��, �Ʒ� ���տ��� ���� ���� �ุ ��ȸ
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)


INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)
;

-- MINUS (������) : �� ���տ��� �Ʒ� ������ �����͸� ������ ������ ����
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)


MINUS

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

-- ������ ��� ������ ������ ���� ���� ������
-- A UNION B         B UNION A ==> ����
-- A UNION ALL B     B UNION ALL A ==> ����(����)
-- A INTERSECT B     B INTERSECT A ==> ����
-- A MINUS B         B MINUS A ==> ���� ����

-- ���� ������ ��� �÷� �̸��� ù��° ������ �÷����� ������
SELECT 'X' first, 'B' second
FROM dual

UNION

SELECT 'Y', 'A'
FROM dual;

-- ����(ORDER BY)�� ���� ���� ���� ������ ���� ������ ���
SELECT deptno, dname, loc
FROM dept
WHERE deptno IN (10, 20)

UNION

SELECT *
FROM dept
WHERE deptno IN (30, 40)
ORDER BY deptno;

SELECT deptno, dname, loc
FROM (SELECT deptno, dname, loc
      FROM dept
      WHERE deptno IN (10, 20)
      ORDER BY deptno)
      
UNION

SELECT *
FROM dept
WHERE deptno IN (30, 40)
ORDER BY deptno;

-- �ܹ��� ���� ��������

SELECT *
FROM fastfood;

-- �õ�, �ñ���, ��������
SELECT sido, sigungu
FROM fastfood;

-- �õ��� ����ŷ ����
SELECT sido, sigungu, COUNT(sigungu) ����ŷ
FROM fastfood
WHERE GB = '����ŷ'
GROUP BY sido, sigungu;

-- �õ��� ������ġ ����
SELECT sido, sigungu, COUNT(sigungu) ������ġ
FROM fastfood
WHERE GB = '������ġ'
GROUP BY sido, sigungu;

-- �õ��� �Ƶ����� ����
SELECT sido, sigungu, COUNT(sigungu) �Ƶ�����
FROM fastfood
WHERE GB = '�Ƶ�����'
GROUP BY sido, sigungu;

-- �õ��� �Ե����� ����
SELECT sido, sigungu, COUNT(sigungu) �Ե�����
FROM fastfood
WHERE GB = '�Ե�����'
GROUP BY sido, sigungu;

SELECT b.sido, b.sigungu, ROUND(((b.����ŷ + m.������ġ + d.�Ƶ�����) / l.�Ե�����),1) ��������
FROM (SELECT sido, sigungu, COUNT(sigungu) ����ŷ FROM fastfood WHERE GB = '����ŷ' GROUP BY sido, sigungu) b,
     (SELECT sido, sigungu, COUNT(sigungu) ������ġ FROM fastfood WHERE GB = '������ġ' GROUP BY sido, sigungu) m,
     (SELECT sido, sigungu, COUNT(sigungu) �Ƶ����� FROM fastfood WHERE GB = '�Ƶ�����' GROUP BY sido, sigungu) d,
     (SELECT sido, sigungu, COUNT(sigungu) �Ե����� FROM fastfood WHERE GB = '�Ե�����' GROUP BY sido, sigungu) l
WHERE (b.sido = m.sido AND b.sigungu(+) = m.sigungu) AND (m.sido = d.sido AND m.sigungu(+) = d.sigungu) AND (d.sido = l.sido AND d.sigungu(+) = l.sigungu) AND (b.sido = l.sido AND b.sigungu = l.sigungu)
ORDER BY �������� DESC;