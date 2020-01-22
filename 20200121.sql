-- PROD ���̺��� ��� �÷��� �ڷ� ��ȸ
SELECT *
FROM PROD;

-- PROD ���̺��� PROD_ID, PROD_NAME �÷��� �ڷḸ ��ȸ
SELECT PROD_ID, PROD_NAME
FROM PROD;

-- RROD ���̺��� PROD_PRICE �÷��� �ڷḸ ��ȸ
SELECT PROD_PRICE
FROM PROD;

-- PROD ���̺��� PROD_NAME �÷��� �ڷḸ ��ȸ
SELECT PROD_NAME
FROM PROD;

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