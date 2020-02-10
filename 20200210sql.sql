DROP TABLE dept_exam;
DROP TABLE rank;
DROP TABLE position;
DROP TABLE counsel;
DROP TABLE counselCase;
DROP TABLE employee;

-- 1. �μ� ���̺� ���� (PRIMARY KEY : �μ� �ڵ�)

CREATE TABLE dept_exam(
   d_cd VARCHAR2(20) NOT NULL,
   d_nm VARCHAR2(50) NOT NULL,
   p_d_cd VARCHAR2(20),

   CONSTRAINT PK_dept PRIMARY KEY(d_cd)
);

-- 2. ���� ���̺� ���� (PRIMARY KEY : ����)
CREATE TABLE rank(
   g_cd VARCHAR2(20) NOT NULL,
   g_nm VARCHAR2(50) NOT NULL,
   ord NUMBER(2),

   CONSTRAINT PK_rank PRIMARY KEY(g_cd)
);

-- 3. ��å ���̺� ���� (PRIMARY KEY : ��å�ڵ�)
CREATE TABLE position(
   j_cd VARCHAR2(20) NOT NULL,
   j_nm VARCHAR2(50) NOT NULL,
   ord NUMBER(2),

   CONSTRAINT PK_position PRIMARY KEY(j_cd)
);

-- 4. ��� ���� ���̺� ���� (PRIMARY KEY : ����ڵ�)
CREATE TABLE counselCase(
   cs_cd VARCHAR2(20) NOT NULL,
   cs_nm VARCHAR2(50) NOT NULL,
   p_cs_cd VARCHAR(20),

   CONSTRAINT PK_counselCase PRIMARY KEY(cs_cd)
);
   

-- 5. ��� ���̺� ���� (PRIMARY KEY : ����ڵ�)
CREATE TABLE counsel(
   cs_id VARCHAR2(20) NOT NULL,
   cs_reg_dt DATE,
   cs_cont VARCHAR2(4000) NOT NULL,
   e_no NUMBER(2) NOT NULL,
   cs_cd1 VARCHAR2(20) REFERENCES counselCase (cs_cd),
   cs_cd2 VARCHAR2(20) REFERENCES counselCase (cs_cd),
   cd_cd3 VARCHAR2(20) REFERENCES counselCase (cs_cd),

   CONSTRAINT PK_counsel PRIMARY KEY(cs_id)
);

-- 6. ��� ���̺� ���� (PRIMARY KEY : �����ȣ(��� ���̺� ���� ���) , FOREIGN KEY : �μ� ���̺� �μ��ڵ�, ���� ���̺� �����ڵ�, ��å ���̺� ��å�ڵ�)
CREATE TABLE employee(
   e_no NUMBER(2) CONSTRAINT PK_employee PRIMARY KEY,
   e_nm VARCHAR(50) NOT NULL,
   g_cd VARCHAR2(20) CONSTRAINT FK_employee_g_cd REFERENCES rank (g_cd),
   j_cd VARCHAR2(20) CONSTRAINT FK_employee_j_cd REFERENCES position (j_cd),
   d_cd VARCHAR2(20) CONSTRAINT FK_employee_d_cd REFERENCES dept_exam (d_cd)

);

-- 1. PRIMARY KEY �������� ���� �� ����Ŭ dbms�� �ش� Ŀ������ unique index�� �ڵ����� �����Ѵ�.
-- (***��Ȯ���� UNIQUE ���࿡ ���� UNIQUE �ε����� �ڵ����� �����ȴ�.
--      PRIMARY = UNIQUE + NOT NULL )
-- index : �ش� �÷����� �̸� ������ �س��� ��ü
-- ������ �Ǿ��ֱ� ������ ã���� �ϴ� ���� �����ϴ��� ������ �� ���� �ִ�.
-- ���࿡ �ε����� ���ٸ� ���ο� �����͸� �Է��� �� �ߺ��Ǵ� ���� ã�� ���ؼ� �־��� ��� ���̺��� ��� �����͸� ã�ƾ� �Ѵ�.
-- ������ �ε����� ������ �̹� ������ �Ǿ��ֱ� ������ �ش� ���� ���� ������ ������ �� ���� �ִ�.

-- 2. FOREIGN KEY �������ǵ� �����ϴ� ���̺� ���� �ִ����� Ȯ���ؾ� �Ѵ�.
-- �׷��� �����ϴ� �÷��� �ε����� �־������ FOREIGN KEY ������ ������ ���� �ִ�.


-- FOREIGN KEY ������ �ɼ�
-- FOREIGN KEY (���� ���Ἲ) : �����ϴ� ���̺��� �÷��� �����ϴ� ���� �Էµ� �� �ֵ��� ����
-- (ex : emp ���̺� ���ο� �����͸� �Է½� deptno �÷����� dept ���̺� �����ϴ� �μ���ȣ�� �Էµ� �� �ִ�.)

-- FOREIGN KEY�� �����ʿ� ���� �����͸� ������ �� ������
-- � ���̺��� �����ϰ� �ִ� �����͸� �ٷ� ������ �ȵ�
-- (EX : EMP.deptno --> DEPT.deptno �÷��� �����ϰ� ���� �� �μ� ���̺��� �����͸� ������ ���� ����)

SELECT *
FROM emp_test;

SELECT *
FROM dept_test;

INSERT INTO dept_test  VALUES (98, 'ddit2', '����');
INSERT INTO emp_test (empno, ename, deptno) VALUES (9999, 'brown', 99);
commit;

-- emp : 9999, 99
-- dept : 98, 99
-- ==> 98�� �μ��� �����ϴ� emp ���̺��� �����ʹ� ����
--     99�� �μ��� �����ϴ� emp ���̺��� �����ʹ� 9999�� brown ����� ����

-- ���࿡ ���� ������ �����ϰ� �Ǹ�
DELETE dept_test
WHERE deptno = 99;

-- emp ���̺��� �����ϴ� �����Ͱ� ���� 98�� �μ��� �����ϸ�??
DELETE dept_test
WHERE deptno = 98;

ROLLBACK;

-- FOREIGN KEY �ɼ�
-- 1. ON DELETE CASCADE : �θ� ������ ���(dept) �����ϴ� �ڽ� �����͵� ���� �����Ѵ�(emp)
-- 2. ON DELETE SET NULL : �θ� ������ ���(dept) �����ϴ� �ڽ� �������� �÷��� NULL�� ����

-- emp_test ���̺��� DROP �� �ɼ��� �����ư��� ���� �� ���� �׽�Ʈ
DROP TABLE emp_test;

CREATE TABLE emp_test (
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    
    CONSTRAINT PK_emp_test PRIMARY KEY (empno),
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test(deptno) ON DELETE CASCADE
);

INSERT INTO emp_test VALUES (9999, 'brown', 99);

COMMIT;

-- emp ���̺��� deptno �÷��� dept ���̺��� deptno �÷��� ����(ON DELETE CASCADE)
-- �ɼǿ� ���� �θ� ���̺�(dept_test) ���� �� �����ϰ� �ִ� �ڽ� �����͵� ���� �����ȴ�.

DELETE dept_test
WHERE deptno = 99;

-- �ɼ� �ο����� �ʾ��� ���� ���� DELETE ������ ������ �߻�
-- �ɼǿ� ���� �����ϴ� �ڽ� ���̺��� �����Ͱ� ���������� �����Ǿ����� SELECT Ȯ��

SELECT *
FROM emp_test;

-- FK ON DELETE SET NULL �ɼ� �׽�Ʈ
-- �θ� ���̺��� ������ ���� �� (dept_test) �ڽ� ���̺��� �����ϴ� �����͸� NULL�� ������Ʈ
ROLLBACK;
SELECT * FROM dept_test;
SELECT * FROM emp_test;
DROP TABLE emp_test;

CREATE TABLE emp_test (
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    
    CONSTRAINT PK_emp_test PRIMARY KEY (empno),
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test(deptno) ON DELETE SET NULL
);

INSERT INTO emp_test VALUES (9999, 'brown', 99);

COMMIT;

-- dept_test ���̺��� 99�� �μ��� �����ϰ� �Ǹ�(�θ� ���̺��� �����ϸ�)
-- 99�� �μ��� �����ϴ� emp_test ���̺��� 9999��(brown) �������� deptno �÷��� FK �ɼǿ� ���� NULL�� �����Ѵ�.

DELETE dept_test
WHERE deptno = 99;

-- �θ� ���̺��� ������ ���� �� �ڽ� ���̺��� �����Ͱ� NULL�� ����Ǿ����� Ȯ��
SELECT *
FROM emp_test;

-- CHECK �������� : �÷��� ���� ���� ������ ������ �� ���
-- ex : �޿� �÷��� ���ڷ� ����, �޿��� ������ �� �� ������?
--      �Ϲ����� ��� �޿����� > 0
--      CHECK ������ ����� ��� �޿����� 0���� ū ���� �˻� ����
--      EMP ���̺��� job �÷��� ���� ���� ���� 4������ ���Ѱ���
--      'SALESMAN', 'PRESIDENT', 'ANALYST', 'MANAGER'

-- ���̺� ���� �� �÷� ����� �Բ� CHECK ���� ����
-- emp_test ���̺��� sal �÷��� 0���� ũ�ٴ� CHECK �������� ����
INSERT INTO dept_test VALUES(99, 'ddit', '����');

DROP TABLE emp_test;

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    sal NUMBER CHECK ( sal > 0 ),
    
    CONSTRAINT PK_emp_test PRIMARY KEY (empno),
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno)
);

SELECT *
FROM emp_test;

INSERT INTO emp_test VALUES(9999, 'brown', 99, 1000);
INSERT INTO emp_test VALUES(9998, 'sally', 99, -1000); --(sal üũ ���ǿ� ���� 0���� ū ���� �Է� ����)

-- ���ο� ���̺� ����
-- CREATE TABLE ���̺�� ( �÷�1.... );

-- CREATE TABLE ���̺�� AS
-- SELECT ����� ���ο� ���̺�� ����

-- emp ���̺��� �̿��ؼ� �μ���ȣ�� 10�� ����鸸 ��ȸ�Ͽ� �ش� �����ͷ� emp_test2 ���̺��� ����
CREATE TABLE emp_test2 AS
SELECT *
FROM emp
WHERE deptno = 10;

SELECT *
FROM emp_test2;

-- TABLE ����
-- 1. �÷� �߰�
-- 2. �÷� ������ ����, Ÿ�� ����
-- 3. �⺻�� ����
-- 4. �÷����� RENAME
-- 5. �÷��� ����
-- 6. �������� �߰�/����

-- TABLE ���� 1. �÷� �߰� ( HP VARCHAR2(20) )
DROP TABLE emp_test;

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    
    CONSTRAINT PK_emp_test PRIMARY KEY (empno),
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test(deptno)
);

-- ALTER TABLE ���̺�� ADD (�ű� �÷��� �ű� �÷� Ÿ��)
ALTER TABLE emp_test ADD(HP VARCHAR2(20));

DESC emp_test;

SELECT * FROM emp_test;

-- TABLE ���� 2. �÷� ������ ����, Ÿ�� ����
-- ex : �÷� varchar2(20) ==> varchar(5)
--      ������ �����Ͱ� ������ ��� ���������� ������ �ȵ� Ȯ���� �ſ� ����
-- �Ϲ������� �����Ͱ� �������� ���� ����, �� ���̺��� ������ ���ļ� �÷��� ������, Ÿ���� �߸��� ��� �÷� ������, Ÿ���� ������

-- �����Ͱ� �Էµ� ���ķδ� Ȱ�뵵�� �ſ� ������ (������ �ø��� �͸� ����)

DESC emp_test;
-- hp VARCHAR2(20) ==> hp VARCHAR(30)

-- ALTER TABLE ���̺�� MODIFY (���� �÷��� �ű� �÷� Ÿ��(������))
ALTER TABLE emp_test MODIFY (hp VARCHAR2(30));
DESC emp_test;

-- hp VARCHAR(30) ==> hp NUMBER
ALTER TABLE emp_test MODIFY(hp NUMBER);
DESC emp_test;

-- TABLE ���� 3. �÷� �⺻�� ����
-- ALTER TABLE ���̺�� MODIFY (�÷��� DEFAULT �⺻��);

-- HP NUMBER ==> HP VARCHAR2(20) DEFAULT '010'
ALTER TABLE emp_test MODIFY (hp VARCHAR2(20) DEFAULT '010');

DESC emp_test;
SELECT *
FROM emp_test;

-- hp �÷����� ���� ���� �ʾ����� DEFAULT ������ ���� '010' ���ڿ��� �⺻������ ����ȴ�.
INSERT INTO emp_test (empno, ename, deptno) VALUES (9999, 'brown', 99);

-- TABLE ���� 4. ���� �� �÷� ����
-- �����Ϸ��� �ϴ� �÷��� FK����, PK������ �־ ��� ����
-- ALTER TABLE ���̺�� RENAME COLUMN ���� �÷��� To �ű� �÷���
ALTER TABLE emp_test RENAME COLUMN hp TO hp_n;

-- TABLE ���� 5. �÷� ����
-- ALTER TABLE ���̺�� DROP COLUMN �÷���
-- emp_test ���̺��� hp_n �÷� ����

-- emp_test�� hp_n �÷��� �ִ� ���� Ȯ��
SELECT * FROM emp_test;

ALTER TABLE emp_test DROP COLUMN hp_n;

-- emp_test���� hp_n �÷��� �����Ǿ����� Ȯ��
DESC emp_test;
SELECT * FROM emp_test;

-- 1. emp_test ���̺��� drop �� empno, ename, deptno, hp 4���� �÷����� ���̺� ����
-- 2. empno, ename, deptno 3���� �÷����� (9999, 'brown', 99) �����ͷ� INSERT
-- 3. emp_test ���̺��� hp �÷��� �⺻���� '010'���� ����
-- 4. 2�� ������ �Է��� �������� hp �÷� ���� ��� �ٲ���� Ȯ��

DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    hp VARCHAR2(20),
    
    CONSTRAINT PK_emp_test PRIMARY KEY (empno),
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test(deptno)
);
INSERT INTO emp_test (empno, ename,deptno) VALUES (9999, 'brown', 99);
ALTER TABLE emp_test MODIFY(hp VARCHAR2(20) DEFAULT '010');
SELECT * FROM emp_test;


-- TABLE ���� 6. �������� �� / ����
-- ALTER TABLE ���̺�� ADD CONSTRAINT �������Ǹ� �������� Ÿ��(PRIMARY KEY, FOREIGN KEY) (�ش��÷�);
-- ALTER TABLE ���̺�� DROP CONSTRAINT �������Ǹ�

-- 1. emp_test ���̺� ���� ��
-- 2. �������� ���� ���̺� ����
-- 3. PRIMARY KEY, FOREIGN KEY ������ ALTER TABLE ������ ���� ����
-- 4. �� ���� �������ǿ� ���� �׽�Ʈ

DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2)
);

ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY(empno);
ALTER TABLE emp_test ADD CONSTRAINT fk_emp_test_dept_test FOREIGN KEY(deptno) REFERENCES dept_test(deptno);

-- PRIMARY KEY �׽�Ʈ
INSERT INTO emp_test VALUES(9999, 'brown', 99);
INSERT INTO emp_test VALUES(9999, 'sally', 99); -- ù��° INSERT ������ ���� �ߺ��ǹǷ� ����

-- FOREIGN KEY �׽�Ʈ
SELECT * FROM dept_test;
SELECT * FROM emp_test;

INSERT INTO emp_test VALUES(9998, 'sally', 98);

-- �������� ���� : PRIMARY KEY, FOREIGN KEY
ALTER TABLE emp_test DROP CONSTRAINT pk_emp_test;
ALTER TABLE emp_test DROP CONSTRAINT fk_emp_test_dept_test;

-- ���������� �����Ƿ� empno�� �ߺ��� ���� �� �� �ְ�, dept_test ���̺� �������� �ʴ� deptno ���� �� ���� �ִ�.

-- �ߺ��� empno ������ ������ �Է�
INSERT INTO emp_test VALUES(9999, 'brown', 99);
INSERT INTO emp_test VALUES(9999, 'sally', 99);

-- �������� �ʴ� 98�� �μ��� ������ �Է�
INSERT INTO emp_test VALUES(9998, 'sally', 98);

-- NOT NULL, CHECK, UNIQUE

-- �������� Ȱ��ȭ / ��Ȱ��ȭ
-- ALTER TABLE ���̺�� ENABLE | DISABLE CONSTRAINT �������Ǹ�

-- 1. emp_test ���̺� ����
-- 2. emp_test ���̺� ����
-- 3. ALTER TABLE PRIMARY KEY(empno), FOREIGN KEY(dept_test.deptno) �������� ����
-- 4. �ΰ��� �������� ��Ȱ��ȭ
-- 5. ��Ȱ��ȭ �Ǿ����� INSERT�� ���� Ȯ��
-- 6. ���������� ������ �����Ͱ� �� ���¿��� �������� Ȱ��ȭ

DROP TABLE emp_test;

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2));

ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY (empno);

ALTER TABLE emp_test ADD CONSTRAINT fk_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno);

ALTER TABLE emp_test DISABLE CONSTRAINT pk_emp_test;
ALTER TABLE emp_test DISABLE CONSTRAINT fk_emp_test_dept_test;

INSERT INTO emp_test VALUES (9999, 'brown', 99);
INSERT INTO emp_test VALUES (9999, 'sally', 98);

COMMIT;

SELECT * FROM emp_test;

-- emp_test ���̺��� empno �÷��� ���� 9999�� ����� �� �� �����ϱ� ������ PRIMARY KEY ���������� Ȱ��ȭ �� ���� ����.
-- ==> empno �÷��� ���� �ߺ����� �ʵ��� �����ϰ� ���������� Ȱ��ȭ �� �� �ִ�.
ALTER TABLE emp_test ENABLE CONSTRAINT pk_emp_test;
ALTER TABLE emp_test ENABLE CONSTRAINT fk_emp_test_dept_test;

SELECT * FROM emp_test;

-- empno �ߺ� ������ ����
DELETE emp_test
WHERE ename = 'brown';

-- PRIMARY KEY �������� Ȱ��ȭ
ALTER TABLE emp_test ENABLE CONSTRAINT pk_emp_test;

-- dept_test ���̺� �������� �ʴ� �μ���ȣ 98�� emp_test���� ��� ��
-- 1. dept_test ���̺� 98�� �μ��� ����ϰų�
-- 2. sally�� �μ���ȣ�� 99������ �����ϰų�
-- 3. sally�� ����ų�

UPDATE emp_test SET deptno = 99
WHERE ename = 'sally';

-- FOREIGN KEY �������� Ȱ��ȭ
ALTER TABLE emp_test ENABLE CONSTRAINT fk_emp_test_dept_test;