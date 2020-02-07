-- TRUNCATE �׽�Ʈ
-- 1. prod�α׸� �������� �ʱ� ������ ������ ������ ������ �Ұ��ϴ�.
-- 2. DML(SELECT, INSERT, UPDATE, DELETE)�� �ƴ϶� DDL�� �з�(ROLLBACK�� �Ұ�)

-- �׽�Ʈ �ó�����
-- emp ���̺� ���縦 �Ͽ� emp_copy��� �̸����� ���̺��� �ۼ�
-- emp_copy ���̺��� ������� TRUNCATE TABLE emp_copy ����

-- emp_copy ���̺� �����Ͱ� �����ϴ��� (���������� ������ �Ǿ�����) Ȯ��

-- EMP_COPY ���̺� ����

-- CREATE ==> DDL (ROLLBACK�� �ȵȴ�.)
CREATE TABLE EMP_COPY AS
SELECT *
FROM emp;

SELECT *
FROM EMP_COPY;

TRUNCATE TABLE emp_copy;

-- TRUNCATE TABLE ��ɾ�� DDL�̱� ������ ROLLBACK�� �Ұ��ϴ�.
-- ROLLBACK �� SELECT�� �غ��� �����Ͱ� ���� ���� ���� ���� �� �� �ִ�.
ROLLBACK;

-- ��ȭ ����

-- DDL : Data Definition Language -> ������ ���Ǿ�
-- ��ü�� ����, ����, ���� �� ���
-- ROLLBACK �Ұ�
-- �ڵ� COMMIT

-- ���̺� ����
-- CREATE TABLE [��Ű����.]���̺��{
--    �÷��� �÷� Ÿ�� [DEFAULT ����],
--    �÷���2 �÷� Ÿ��2 [DEFAULT ����], ...
-- };

-- ranger��� �̸��� ���̺� ����
CREATE TABLE ranger(
    ranger_no NUMBER,
    ranger_nm VARCHAR(50),
    reg_di DATE DEFAULT SYSDATE
);    

SELECT * FROM ranger;

INSERT INTO ranger (ranger_no, ranger_nm) VALUES (1, 'brown');

COMMIT;

-- ���̺� ����
-- DROP TABLE ���̺��

SELECT * FROM ranger;

-- ranger ���̺� ����(drop)
DROP TABLE ranger;

-- DDL�� ROLLBACK �Ұ�
ROLLBACK;

-- ���̺��� ROLLBACK���� ���� ���� Ȯ�� �� �� �ִ�.
SELECT * FROM ranger;

-- ������ Ÿ��
-- ���ڿ� (varchar2 ���, char Ÿ�� ��� ����)
-- varchar2(10) : �������� ���ڿ�
--                �ԷµǴ� ���� �÷� ������� �۾Ƶ� ���� ������ �������� ä���� �ʴ´�
-- char(10) : �������� ���ڿ�
--            �ش� �÷��� ���ڿ��� 8byte�� �����ϸ� ������ 2byte�� �������� ä������
--            'test' ==> 'test      '
--            'test' != 'test      '  

-- ����
-- NUMBER(p, s) : p - ��ü�ڸ��� (30), s - �Ҽ��� �ڸ���
-- INTEGER ==> NUMBER(30, 0)
-- ranger_no NUMBER ==> NUMBER(30, 0)

-- ��¥
-- DATE : ���ڿ� �ð� ������ ����
--        7Byte

-- ��¥ - DATE
--       VARCHAR(8) '20200207'
--       �� �ΰ��� Ÿ���� �ϳ��� ������ �� 1BYTE�� ����� ���̰� ����
--       ������ ���� �������� �Ǹ� ������ �� ���� �������, ����� Ÿ�Կ� ���� ����� �ʿ�

-- LOB(Large Object) - �ִ� 4GB
-- CLOB - Character Large Object
--        varchar2�� ���� �� ���� �������� ���ڿ�(4000byte �ʰ���)
--        ex : �� �����Ϳ� ������ html �ڵ�
        
-- SLOB - Character Large Object
--        ������ �����ͺ��̽��� ���̺��� ������ ��

--        �Ϲ������� �Խñ� ÷�������� ���̺� ���� �������� �ʰ� 
--        ���� ÷�������� ��ũ�� Ư�� ������ �����ϰ�, �ش� (���)�� ���ڿ��� ����

--        ������ �ſ� �߿��� ��� : �� ������� ���Ǽ� -> [����]�� ���̺� ����

-- �������� : �����Ͱ� ���Ἲ�� ��Ű���� �ϱ� ���� ����
-- 1. UNIQUE ��������
--    �ش� �÷��� ���� �ٸ� ���� �����Ϳ� �ߺ����� �ʵ��� ����
--    EX : ����� ���� ����� ���� ���� ����

-- 2. NOT NULL �������� (CHECK ��������)
--    �ش� �÷��� ���� �ݵ�� �����ؾ� �ϴ� ����
--    EX : ��� �÷��� NULL�� ����� ������ ���� ����
--         ȸ�����Խ� �ʼ� �Է»��� ( GITGHUB - �̸����̶� �̸� )

-- 3. PRIMARY KEY ��������
--    UNIQUE + NOT NULL
--    EX : ����� ���� ����� ���� ���� ����, ����� ���� ����� ���� ���� ����
--    PRIMARY KEY ���������� ������ ��� �ش� �÷����� UNIQUE INDEX�� �����ȴ�

-- 4. FOREIGN KEY �������� (�������Ἲ)
--    �ش� �÷��� �����ϴ� �ٸ� ���̺� ���� �����ϴ� ���� �־�� �Ѵ�.
--    emp ���̺��� deptno �÷��� dept ���̺��� deptno �÷��� ����(����)
--    emp ���̺��� deptno �÷����� dept ���̺� �������� �ʴ� �μ���ȣ�� �Էµ� �� ����.
--    ex : ���� dept ���̺��� �μ���ȣ�� 10, 20, 30, 40���� ���� �� ���
--         emp ���̺� ���ο� ���� �߰��ϸ鼭 �μ���ȣ ���� 99������ ����� ��� �� �߰��� �����Ѵ�

-- 5. CHECK �������� (���� üũ)
-- NOT NULL ���� ���ǵ� CHECK ���࿡ ����
-- emp ���̺� JOB �÷��� ��� �� �� �ִ� ���� 'SALESMAN", 'PRESIDENT', 'CLERK'

-- �������� ���� ���
-- 1. ���̺��� �����ϸ鼭 �÷��� ���
-- 2. ���̺��� �����ϸ鼭 �÷� ��� ���Ŀ� ������ ���������� ���
-- 3. ���̺� ������ ������ �߰������� ���������� �߰�

-- CREATE TABLE ���̺��(
--     �÷�1 �÷� Ÿ�� [1.��������],
--     �÷�2 �÷� Ÿ�� [1.��������],
--     
--     [2.TABLE_CONSTRAINT]
-- );

-- 3. ALTER TABLE emp ...;

-- PRIMARY KEY ���������� �÷� ������ ����(1�� ���)
-- dept ���̺��� �����Ͽ� dept_test ���̺��� PRIMARY KEY �������ǰ� �Բ� ����
-- ��, �� ����� ���̺��� key �÷��� ���� �÷��� �Ұ�, ���� �÷��� ���� ����

CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

INSERT INTO dept_test (deptno) VALUES (99); -- ���������� ����;
INSERT INTO dept_test (deptno) VALUES (99); -- �ٷ� ���� ������ ���� ���� ���� �����Ͱ� �̹� �����

SELECT * FROM dept_test;

-- �������, �츮�� ���ݱ��� ������ ����� dept ���̺� deptno �÷����� UNIQUE �����̳� PRIMARY KEY ���������� ������ ������
-- �Ʒ� �ΰ��� QUERY ������ ���������� ����ȴ�
INSERT INTO dept (deptno) VALUES (99);
INSERT INTO dept (deptno) VALUES (99);

SELECT * FROM dept;
ROLLBACK;

-- �������� Ȯ�� ���
-- 1. TOOL�� ���� Ȯ��
--    Ȯ���ϰ��� �ϴ� ���̺� ����
-- 2. dictionary�� ���� Ȯ�� (USER_TABLES, USER_CONSTRAINTS, CONSTRAINT_NAME)

SELECT *
FROM USER_CONSTRAINTS
WHERE table_name = 'DEPT_TEST';

SELECT *
FROM USER_CONSTRAINTS
WHERE CONSTRAINT_NAME = 'SYS_C007109';

-- 3. �𵨸� (ex : exerd)���� Ȯ��

-- �������� ���� ������� ���� ��� ����Ŭ���� �������� �̸��� ���Ƿ� �ο� (ex : SYS_C007109)
-- �������� �������� ������ ��� ��Ģ�� �����ϰ� �����ϴ°� ���, � ������ ����
-- PRIMARY KEY �������� : PK_���̺��
-- FOREIGN KEY �������� : PK_������̺��_ �������̺��

DROP TABLE dept_test;

-- �÷� ������ ���������� �����ϸ鼭 �������� �̸��� �ο�
-- CONSTRAINT �������Ǹ� �������� Ÿ��(PRIMARY KEY)

CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT PK_dept_test PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

INSERT INTO dept_test (deptno) VALUES (99);
INSERT INTO dept_test (deptno) VALUES (99);

-- ORA-00001: unique constraint (SYS_C007109) violated
-- ORA-00001: unique constraint (OCK.PK_DEPT_TEST) violated

-- ��� �������ǿ� �̸��� �޾ƾ� �ϴ� ���� �ƴ�

-- ���̺� ���� �� �÷� ��� ���� ������ �������� ���

DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT PK_dept_test PRIMARY KEY(deptno)
    
);

-- NOT NULL �������� �����ϱ�
-- 1. �÷��� ����ϱ� (O)
--    �÷��� ����ϸ鼭 �������� �̸��� �ο��ϴ°� �Ұ�
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14) NOT NULL,
    loc VARCHAR2(13),
    
    CONSTRAINT PK_dept_test PRIMARY KEY(deptno)
    
);

-- NOT NULL �������� Ȯ��
INSERT INTO dept_test (deptno, dname) VALUES (99, NULL);

-- 2. ���̺� ������ �÷� ��� ���Ŀ� �������� �߰�
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT NN_dept_test_dname CHECK(deptno IS NOT NULL)
    
);

-- UNIQUE ���� : �ش� �÷��� �ߺ��Ǵ� ���� ������ ���� ����, �� NULL�� �Է��� �����ϴ�
-- PRIMARY KEY = UNIQUE + NOT NULL

-- 1. ���̺� ������ �÷� ���� UNIQUE ��������
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT PK_dept_test PRIMARY KEY,
    dname VARCHAR2(14) UNIQUE,
    loc VARCHAR2(13)    
);

-- dept_test ���̺��� dname �÷��� ������ UNIQUE ���������� Ȯ��
INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (59, 'ddit', 'daejeon');

-- 2. ���̺� ������ �÷��� �������� ���, �������� �̸� �ο�
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT PK_dept_test PRIMARY KEY,
    dname VARCHAR2(14)CONSTRAINT UK_dept_test_dname UNIQUE,
    loc VARCHAR2(13)    
);

-- dept_test ���̺��� dname �÷��� ������ UNIQUE ���������� Ȯ��
INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (59, 'ddit', 'daejeon');

-- 2. ���̺� ������ �÷� ��� ���� �������� ���� - ���� �÷�(deptno = dname) (unique)
DROP TABLE dept_test;

CREATE TABLE dept_test(
       deptno NUMBER(2),
       dname VARCHAR2(14),
       loc VARCHAR(13),
       
       CONSTRAINT UK_dept_test_deptno_dname PRIMARY KEY(deptno, dname)
);       

-- ���� �÷��� ���� UNIQUE ���� Ȯ�� (deptno, dname)
INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (98, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (98, 'ddit', '����');

-- FOREIGN KEY ���� ����
-- �����ϴ� ���̺��� �÷��� �����ϴ� ���� ��� ���̺��� �÷��� �Է��� �� �ֵ��� ����
-- EX : emp ���̺� deptno �÷��� ���� �Է��� ��, dept ���̺��� deptno �÷��� �����ϴ� �μ���ȣ�� �Է��� �� �ֵ��� ����
--      �������� �ʴ� �μ���ȣ�� emp ���̺��� ������� ���ϰԲ� ����

-- 1. dept_test ���̺� ����
-- 2. emp_test ���̺� ����
--      emp_test ���̺� ���� �� deptno �÷����� dept.deptno �÷��� �����ϵ��� FK�� ����
DROP TABLE dept_test;

CREATE TABLE dept_test(
       deptno NUMBER(2),
       dname VARCHAR2(14),
       loc VARCHAR(13),
       CONSTRAINT pk_dept_test PRIMARY KEY (deptno)
);  

DROP TABLE emp_test;

CREATE TABLE emp_test(
       empno NUMBER(4),
       ename VARCHAR2(10),
       deptno NUMBER(2) REFERENCES dept_test (deptno),
       
       CONSTRAINT PK_EMP_TEST PRIMARY KEY (empno)
);

-- ���̺� �Է� ����
-- emp_test ���̺� �����͸� �Է��ϴ°� �����Ѱ�??
--  ���� ��Ȳ(dept_test, emp_test ���̺��� ��� ���� - �����Ͱ� �������� ���� ��)
INSERT INTO emp_test VALUES(9999, 'brown', NULL); -- FK�� ������ �÷��� NULL�� ���
INSERT INTO emp_test VALUES(9999, 'brown', 10); -- 10�� �μ��� dept_test ���̺� �������� �ʾƼ� ����

-- dept_test ���̺� �����͸� �غ�
INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon');
INSERT INTO emp_test VALUES (9999, 'sally', 10); -- 10�� �μ��� dept_test�� �������� �����Ƿ� ����
INSERT INTO emp_test VALUES (9999, 'sally', 99); -- 99�� �μ��� dept_test�� �����ϹǷ� ���� ����

-- ���̺� ���� �� �÷� ��� ���� FOREIGN KEY �������� ����
DROP TABLE emp_test;
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14) NOT NULL,
    loc VARCHAR2(13),
    
    CONSTRAINT PK_dept_test PRIMARY KEY(deptno)
    
);

INSERT INTO dept_test VALUES(99, 'ddit', 'daejeon');

CREATE TABLE emp_test(
    empno NUMBER(2),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno)
);

INSERT INTO emp_test VALUES(10, 'brown', 10); -- dept_test ���̺� 10�� �μ��� �������� �����Ƿ� ����
INSERT INTO emp_test VALUES(10, 'brown', 99); -- dept_test ���̺� 99�� �μ��� �����ϹǷ� ���� ����

SELECT *
FROM emp_test;

SELECT *
FROM dept_test;































       
