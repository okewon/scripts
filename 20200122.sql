--lprod ���̺��� ��� �����͸� ��ȸ�ϴ� ������ �ۼ��ϼ���
SELECT *
FROM lprod;

--buyer ���̺��� buyer_id, buyer_name �÷��� ��ȸ�ϴ� ������ �ۼ��ϼ���
SELECT buyer_id, buyer_name
FROM buyer;

--cart ���̺��� ��� �����͸� ��ȸ�ϴ� ������ �ۼ��ϼ���
SELECT *
FROM cart;

--member ���̺��� mem_id, mem_pass, mem_name �÷��� ��ȸ�ϴ� ������ �ۼ��ϼ���
SELECT mem_id, mem_pass, mem_name
FROM member;





-- users ���̺� ��ȸ
SELECT *
FROM users;

-- ���̺� � �÷��� �ִ��� Ȯ���ϴ� ���
-- 1. SELECT *
-- 2. TOOL�� ��� (�����-TABLES)
-- 3. DESC �׹̺�� (DESC-DESCRIBE)

DESC users;

SELECT userid
FROM users;

-- users ���̺��� userid, usernm, reg_dt �÷��� ��ȸ�ϴ� sql�� �ۼ��ϼ���
-- ��¥ ���� (reg_dt �÷��� data������ ���� �� �ִ� Ÿ��)
-- ��¥�÷� +(���ϱ� ����)
-- �������� ��Ģ������ �ƴ� �͵�(5+5)
-- String h = "hello";
-- String w = "world"
-- String hw = h+w; -- �ڹٿ����� �� ���ڿ��� ����
-- sql���� ���ǵ� ��¥ ���� : ��¥ + ���� = ��¥���� ������ ���ڷ� ����Ͽ� ���� ��¥�� �ȴ�
-- (2019/01/28 + 5 = 2019/02/02)
-- reg_dt : ������� �÷�
-- null : ���� �𸣴� ����
-- null�� ���� ���� ����� �׻� null
SELECT userid u_id, usernm, reg_dt, reg_dt + 5 AS reg_dt_after_5DAY
FROM users;

DESC users;

--String msg = ""; //���鹮��
--String  = null; //

--prod ���̺��� prod_id, prod_name �� �÷��� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
--(�� prod_id -> id, prod_name -> name���� �÷� ��Ī�� ����)
SELECT prod_id id, prod_name name
FROM prod;

--lprod ���̺��� lprod_gu, lprod_nm �� �÷��� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
--(�� lrpod_gu -> gu, lprod_nm -> nm���� �÷� ��Ī�� ����)
SELECT lprod_gu gu, lprod_nm nm
FROM lprod;

--buyer ���̺��� buyer_id,buyer_name �� �÷��� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
--(�� buyer_id -> ���̾���̵�, buyer_name -> �̸����� �÷� ��Ī�� ����)
SELECT buyer_id ���̾���̵�, buyer_name �̸�
FROM buyer;

--���ڿ� ����
-- �ڹ� ���� ���ڿ� ���� : + ("Hello" + "world")
-- SQL������ : || ('Hello' || 'world')
-- SQL������ : concat('Hello', 'world')

-- userid, usernm �÷��� ����, ��Ī id_name
SELECT userid || usernm AS id_name
FROM users;

SELECT concat(userid, usernm) AS id_name
FROM users;

-- ����, ���
-- int a = 5; String msg = "HelloWorld";
-- System.out.println(msg);  //������ �̿��� ���
-- System.out.println("Hello, World");  //����� �̿��� ���

-- SQL������ ������ ����(�÷��� ����� ����, pl/sql ���� ������ ����)
-- SQL���� ���ڿ� ����� �̱� �����̼����� ǥ��
-- "Hello, world" --> 'Hello, world'

-- ���ڿ� ����� �÷����� ����
-- user id : brown
-- user id : cony
SELECT 'user id : '|| userid AS "userid"
FROM users;

SELECT 'SELECT * FROM ' || table_name || ';' AS QUERY
FROM user_tables;

-- || --> CONCAT
-- CONCAT(arg1, arg2)

SELECT concat(concat('SELECT * FROM ', table_name), ';') AS query
FROM user_tables;

--int a = 5;
--if(a==5) (a�� ���� 5���� ��)
--sql������ ������ ������ ����(PL/SQL)
--sql => --> equal

-- users��  ���̺��� ��� �࿡ ���ؼ� ��ȸ
-- users���� 5���� �����Ͱ� ����
SELECT *
FROM users;

--WHERE �� : ���̺��� �����͸� ��ȸ�� �� ���ǿ� �´� �ุ ��ȸ
--ex : userid �÷��� ���� brown�� �ุ ��ȸ
--brown, 'brown' ����
--�÷�, ���ڿ� ���
SELECT *
FROM users
WHERE userid = 'brown';

--userid�� brown�� �ƴ� �ุ ��ȸ(brown�� ������ 4��)
-- ������ : =, �ٸ��� : !=, <>
SELECT *
FROM users
WHERE userid != 'brown';

--emp ���̺� �����ϴ� �÷��� Ȯ�� �غ�����
SELECT *
FROM emp;

--emp ���̺��� ename �÷� ���� JONES�� �ุ ��ȸ
--* SQL KEY WORD�� ��ҹ��ڸ� ������ ������ �÷��� ���̳�, ���ڿ� ����� ��ҹ��ڸ� ������.
--'JONES', 'jones'�� ���� �ٸ� ���
SELECT *
FROM emp
WHERE ename = 'JONES';

SELECT *
FROM emp;

DESC emp;
5>10 --FALSE
5>5 --FALSE
5>=5 --TRUE

-- emp���̺��� deptno(�μ���ȣ)�� 30���� ũ�ų� ���� ����鸸 ��ȸ
SELECT *
FROM emp
WHERE deptno >=30;

--���ڿ� : '���ڿ�'
--���� : 50
--��¥ : ??? --> �Լ��� ���ڿ��� �����Ͽ� ǥ��. ���ڿ��� �̿��Ͽ� ǥ�� ���� (but �������� ����)
--�������� ��¥ ǥ�� ����� �ٸ�
--�ѱ� : �⵵4�ڸ�-��2�ڸ�-����2�ڸ�
--�̱� : ��2�ڸ�-����2�ڸ�-�⵵2�ڸ�

--�Ի����ڰ� 1980�� 12�� 17�� ������ ��ȸ
SELECT ename, hiredate
FROM emp
WHERE hiredate >= '80/12/17';

--TO_DATE : ���ڿ��� data Ÿ������ �����ϴ� �Լ�
--RO_DATE(��¥���� ���ڿ�, ù���� ������ ����)
--'1980/02/03'
--TO_DATE('19980424','YYYY,MM,DD') or TO_DATE('1998/04/24', 'YYYY/MM/DD')
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01','YYYY/MM/DD');

--��������
--sql �÷��� ���� 1000���� 2000 ������ ���
--sal >= 1000, sal<=2000
SELECT *
FROM emp
WHERE sal >= 1000
AND sal <= 2000;

--���������ڸ� �ε�ȣ ��ſ� BETWEEN AND �����ڷ� ��ü
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

--emp ���̺��� �Ի� ���ڰ� 1982�� 1�� 1�� ���ĺ��� 1983�� 1�� 1�� ������ ����� ename, hiredate �����͸� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
--(�� �����ڴ� between�� ����Ѵ�)
SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('1982/01/01','YYYY/MM/DD') AND TO_DATE('1983/01/01','YYYY/MM/DD');