-- �������� Ȯ�� ���
-- 1. tool
-- 2. dictionary view
-- �������� : USER_CONSTRAINTS
-- ��������-�÷� : USER_CONS_COLUMNS
-- ���������� ��� �÷��� ���õǾ� �ִ��� �� �� ���� ������ ���̺��� ������ �и��Ͽ� ����
-- ��1������

SELECT *
FROM USER_CONSTRAINTS
WHERE table_name IN ('EMP', 'DEPT', 'EMP_TEST', 'DEPT_TEST');

-- EMP, DEPT�� PK, FK ������ �������� ����
-- 2. EMP : pk(empno)
-- 3.       fk(deptno) - dept.deptno
--          (fk ������ �����ϱ� ���ؼ��� �����ϴ� ���̺� �÷��� �ε����� �����ؾ� �Ѵ�.

-- 1. dept : pk (deptno)
ALTER TABLE EMP ADD CONSTRAINT pk_emp PRIMARY KEY(empno);
ALTER TABLE EMP ADD CONSTRAINT fk_emp FOREIGN KEY (deptno) REFERENCES dept (deptno);
ALTER TABLE dept ADD CONSTRAINT pk__dept PRIMARY KEY(deptno);

-- ���̺�, �÷� �ּ� : DICTIONARY Ȯ�� ����
-- ���̺� �ּ� : USER_TAB_COMMENTS
-- �÷� �ּ� : USER_COL_COMMENTS

-- �ּ� ����
-- ���̺� �ּ� : COMMENT ON TABLE ���̺�� IS '�ּ�';
-- �÷� �ּ� : COMMENT ON TABLE ���̺��.�÷� IS '�ּ�';

-- emp : ����
-- dept : �μ�

COMMENT ON TABLE emp IS '����';
COMMENT ON TABLE dept IS '�μ�';

SELECT *
FROM member;

SELECT *
FROM USER_TAB_COMMENTS
WHERE TABLE_NAME IN ('EMP','DEPT');

SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME IN ('EMP','DEPT');

/*
DEPT	DEPTNO : �μ���ȣ
DEPT	DNAME : �μ���
DEPT	LOC : �μ���ġ
EMP	    EMPNO : ������ȣ
EMP	    ENAME : �����̸�
EMP	    JOB : ������
EMP	    MGR : �Ŵ��� ������ȣ
EMP	    HIREDATE : �Ի�����
EMP	    SAL : �޿�
EMP	    COMM : ������
EMP	    DEPTNO : �ҼӺμ���ȣ;
*/

COMMENT ON COLUMN dept.deptno IS '�μ���ȣ';
COMMENT ON COLUMN dept.dname IS '�μ���';
COMMENT ON COLUMN dept.loc IS '�μ���ġ';

COMMENT ON COLUMN emp.empno IS '������ȣ';
COMMENT ON COLUMN emp.ename IS '�����̸�';
COMMENT ON COLUMN emp.job IS '������';
COMMENT ON COLUMN emp.mgr IS '�Ŵ��� ������ȣ';
COMMENT ON COLUMN emp.hiredate IS '�Ի�����';
COMMENT ON COLUMN emp.sal IS '�޿�';
COMMENT ON COLUMN emp.comm IS '������';
COMMENT ON COLUMN emp.deptno IS '�ҼӺμ���ȣ';


-- user_tab_comments, user_col_comments view�� �̿��Ͽ� customer, product, cycle, daily ���̺�� �÷��� �ּ� ������ ��ȸ�ϴ� ������ �ۼ��϶�
SELECT b.table_name, table_type, b.comments tab_comment, column_name, a.comments col_comment
FROM user_col_comments a, user_tab_comments b
WHERE a.table_name = b.table_name AND a.table_name IN ('CYCLE','PRODUCT','CUSTOMER','DAILY');


-- VIEW = QUERY
-- TABLE Ŀ�� DBMS�� �̸� �ۼ��� ��ü
-- ==> �ۼ����� �ʰ� QUERY���� �ٷ� �ۼ��� VIEW : INLINE-VIEW ==> �̸��� ���� ������ ��Ȱ���� �Ұ�
-- VIEW�� ���̺��̴� (X)

-- ������
-- 1. ���� ����(Ư�� �÷��� �����ϰ� ������ ����� �����ڿ� ����)
-- 2. INLINE-VIEW�� VIEW�� �����Ͽ� ��Ȱ��
--      ���� ���� ����

-- ���� ���
-- CREATE (OR PEPLACE) VIEW ���Ī [ (column1, column2, ...) ] AS
-- SUBQUERY;

-- emp ���̺��� 8���� �÷� �� sal, comm �÷��� ������ 6�� �÷��� �����ϴ� v_emp VIEW ����
CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

-- �ý��� �������� OCK �������� VIEW �������� �߰�
GRANT CREATE VIEW TO OCK;

-- ���� �ζ��� ��� �ۼ���
SELECT *
FROM (SELECT empno, ename, job, mgr, hiredate, deptno
      FROM emp);
      
-- VIEW ��ü Ȱ��
SELECT *
FROM v_emp;

-- emp ���̺��� �μ����� ���� ==> dept ���̺�� ������ ����ϰ� ���
-- ���ε� ����� view�� �����س����� �ڵ带 �����ϰ� �ۼ��ϴ°� ����

-- VIEW : v_emp_dept
-- dname(�μ���), empno(������ȣ), ename(�����̸�), job(������), hiredate(�Ի�����)

CREATE OR REPLACE VIEW v_emp_dept AS
SELECT DEPT.DNAME, emp.empno, emp.ename, emp.job, emp.hiredate
FROM dept, emp
WHERE emp.deptno = dept.deptno;

-- �ζ��� ��� �ۼ���
SELECT *
FROM (SELECT DEPT.DNAME, emp.empno, emp.ename, emp.job, emp.hiredate
      FROM dept, emp
      WHERE emp.deptno = dept.deptno);

-- VIEW Ȱ���
SELECT *
FROM v_emp_dept;

-- SMITH ���� ���� �� v_emp_dept view �Ǽ� ��ȭ�� Ȯ��
DELETE emp
WHERE ename = 'SMITH';


-- VIEW�� �������� �����͸� ���� �ʰ�, ������ �����͐l ���� ����(SQL)�̱� ������ VIEW���� �����ϴ� ���̺��� �����Ͱ� ������ �Ǹ� VIEW�� ����� ������ �޴´�.
ROLLBACK;

-- SEQUENCE : ������ - �ߺ����� �ʴ� �������� �������ִ� ����Ŭ ��ü
-- CREATE SEQUENCE ������_�̸�
-- [OPTION ...]
-- ����Ģ : ���̺��;

-- emp ���̺��� ����� ������ ����
CREATE SEQUENCE seq_emp;

-- ������ ���� �Լ�
-- NEXTVAL : ���������� ���� ���� ������ �� ���
-- CURRVAL : NEXTVAL�� ����ϰ� ���� ���� �о���� ���� ��Ȯ��

-- ������ ������
-- ROLLBAVK�� �ϴ��� NEXTVAL�� ���� ���� ���� �ٽ� �������� �ʴ´�.
-- NEXTVAL�� ���� ���� �޾ƿ��� �� ���� �ٽ� ����� �� ����.

SELECT seq_emp.NEXTVAL
FROM dual;

SELECT seq_emp.CURRVAL
FROM dual;

SELECT *
FROM emp_test;

INSERT INTO emp_test VALUES (seq_emp.NEXTVAL, 'james', 99);

-- INDEX
SELECT ROWID, emp.*
FROM emp;

SELECT *
FROM emp
WHERE ROWID = 'AAAE5gAAFAAAACLAAI';

-- �ε����� ������ empno ������ ��ȸ�ϴ� ���
-- emp ���̺��� pk_emp ���������� �����Ͽ� empno �÷����� �ε����� �������� �ʴ� ȯ���� ����

ALTER TABLE emp DROP CONSTRAINT pk_emp;

explain plan for
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);


-- emp ���̺��� empno �÷����� PK ������ �����ϰ� ������ SQL�� ����
-- PK : UNIQUE + NOT NULL
--      (UNIQUE �ε����� �������ش�)
-- ==> empno Ŀ������ unique �ε����� ������

-- �ε����� SQL�� �����ϰ� �Ǹ� �ε����� ���� ���� ��� �ٸ��� �������� Ȯ��

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);

SELECT rowid, emp.*
FROM emp;

SELECT empno, rowid
FROM emp
ORDER BY empno;

explain plan for
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

explain plan for
SELECT *
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

-- SELECT ��ȸ�÷��� ���̺� ���ٿ� ��ġ�� ����
-- SELECT * FROM emp WHERE empno = 7782 ==> SELECT empno FROM emp WHERE empno = 7782

explain plan for
select empno
from emp
where empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

-- UNIQUE VS NON-UNIQUE �ε����� ���� Ȯ��
-- 1. pk_emp ����
-- 2. empno �÷����� NON_UNIQUE �ε��� ����
-- 3. �����ȹ Ȯ��

alter table emp drop CONSTRAINT pk_emp;
CREATE INDEX idx_n_emp_01 ON emp (empno);

explain plan for
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

-- emp ���̺� job �÷��� �������� �ϴ� ���ο� NON_UNIQUE �ε����� ����
CREATE INDEX idx_n_emp_02 ON emp (job);

SELECT rowid, job
from emp
order by job;

-- ���ð����� ����
-- 1. emp ���̺��� ��ü �б�
-- 2. idx_n_emp_01 �ε��� Ȱ��
-- 3. idx_n_emp_02 �ε��� Ȱ��

explain plan for
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY)