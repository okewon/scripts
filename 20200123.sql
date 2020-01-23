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
SELECT  userid ���̵�, usernm �̸�
FROM users
WHERE userid IN('brown', 'cony', 'sally');
