-- synonym : ���Ǿ�
-- 1. ��ü ��Ī�� �ο�
--    ==> �̸��� �����ϰ� ǥ��

-- OCK ����ڰ� �ڽ��� ���̺� emp ���̺��� ����ؼ� ���� v_emp vie
-- hr ����ڰ� ����� �� �ְԲ� ������ �ο�

-- v_emp : �ΰ��� ���� sal, comm�� ������ view

-- hr ����� v_emp�� ����ϱ� ���� ������ ���� �ۼ�
select * from ock.v_emp;

-- hr ��������
-- synonym OCK.v_emp ==> v_emp
-- v_emp == OCK.v_emp

select * from v_emp;

-- 1. OCK �������� v_emp�� hr�������� ��ȸ�� �� �ֵ��� ��ȸ ���� �ο�
grant select on v_emp to hr;

-- 2. hr �������� v_emp�� ��ȸ�ϴ°� ���� (���� 1������ �޾ұ� ������)
--    ���� �ش� ��ü�� �����ڸ� ��� : OCK.v_emp
--    �����ϰ� OCK.v_emp ==> v_emp ����ϰ� ���� ��Ȳ
--    synonym ����

-- create synonym �ó�� �̸� for ���� ��ü��

-- synonym ����
-- drop synonym �ó�� �̸�

-- grant connect to OCK;
-- grant select on ��ü�� to hr;

-- ����
-- 1. �ý��� ���� : TABLE�� ����, VIIEW ����, ...
-- 2. ��ü ���� : Ư�� ��ü�� ���� SELECT, UPDATE, INSERT, DELETE, ...

-- ROLE : ������ ��Ƴ��� ����
-- ����ں��� ���� ������ �ο��ϰ� �Ǹ� ������ �δ�
-- Ư�� ROLE�� ������ �ο��ϰ� �ش� ROLE ����ڿ��� �ο�
-- �ش� ROLE�� �����ϰ� �Ǹ� ROLE�� ���� �ִ� ��� ����ڿ��� ����

-- ���� �ο�/ȸ��
-- �ý��� ���� : GRANT �����̸� TO ����� | ROLE
--              REVOKE �����̸� FROM ����� | ROLE
-- ��ü ���� : GRANT �����̸� ON ��ü�� TO ����� | ROLE
--            REVOKE �����̸� ON ��ü�� FROM ����� | ROLE

-- data dictionary : ����ڰ� �������� �ʰ�, dbms�� ��ü������ �����ϴ� �ý��� ������ ���� view
-- data dictionary ���ξ�
-- 1. USER : �ش� ����ڰ� ������ ��ü
-- 2. ALL : �ش� ����ڰ� ������ ��ü + �ٸ� ����ڷκ��� (������) �ο����� ��ü
-- 3. DBA : ��� ������� ��ü

-- VS Ư�� VIEW

select * from user_tables;
select * from all_tables;
select * from dba_tables;

-- dictionary ���� Ȯ�� : SYS.DIIONARY

select * from dictionary;

-- ��ǥ���� ditionary
-- objects : ��ü ���� ��ȸ(���̺�, �ε���, view, synonym, ...)
-- tables : ���̺� ������ ��ȸ
-- tab_columns : ���̺��� �÷� ���� ��ȸ
-- indexes : �ε��� ���� ��ȸ
-- ind_columns : �ε��� ���� �÷� ��ȸ
-- constraints : ���� ���� ��ȸ
-- cons : �������� ���� �÷� ��ȸ
-- tab_comments : ���̺� �ּ�
-- col_comments : ���̺��� �÷� �ּ�
select * from user_objects;

-- emp, dept ���̺��� �ε����� �ε��� �÷� ���� ��ȸ
-- user_indexes, user_ind_colums join
-- ���̺��, �ε�����, �÷���
-- emp  ind_n_emp_04    ename
-- emp  ind_n_emp_04    job
select table_name, index_name, column_name, COLUMN_POSITION
from user_ind_columns
order by table_name, index_name, COLUMN_POSITION;

select * from user_ind_columns;

select * from user_indexes;

-- multiple insert : �ϳ��� insert �������� ���� ���̺� �����͸� �Է��ϴ� DML

SELECT * FROM dept_test2;

SELECT * FROM dept_test;

-- ������ ���� ���� ���̺� ���ÿ� �Է��ϴ� MULTIPLE INSERT
insert all
    into dept_test
    into dept_test2
select 98, '���', '�߾ӷ�' from dual union all
select 97, 'IT', '����' from dual;

-- ���̺� �Է��� �÷��� �����Ͽ� multiple insert
rollback;
alter table dept_test drop constraint SYS_C007128;
alter table dept_test drop constraint PK_DEPT_TEST;
alter table emp_test drop constraint PK_emp_TEST;
alter table emp_test drop constraint FK_EMP_TEST_DEPT_TEST;
alter table dept_test2 drop constraint PK_DEPT_TEST2;
insert all
    into dept_test (deptno, loc) values (deptno, loc)
    into dept_test2
select 98 deptno, '���' dname, '�߾ӷ�' loc from dual union all
select 97, 'IT', '����' from dual;

-- ���̺� �Է��� �����͸� ���ǿ� ���� multiple insert
-- case
--      when ���� ��� then
-- end
rollback;
insert all
    when deptno = 98 then
        into dept_test (deptno, loc) values (deptno, loc)
    else
        into dept_test2
select 98 deptno, '���' dname, '�߾ӷ�' loc from dual union all
select 97, 'IT', '����' from dual;

-- ������ �����ϴ� ù��° insert�� �����ϴ� multiple insert (switch��)
rollback;
insert first
    when deptno = 98 then
        into dept_test (deptno, loc) values (deptno, loc)
    when deptno >= 97 then
        into dept_test2
    else
        into dept_test2
select 98 deptno, '���' dname, '�߾ӷ�' loc from dual union all
select 97, 'IT', '����' from dual;

-- ����Ŭ ��ü : ���̺� �������� ������ ��Ƽ������ ����
-- ���̺� �̸��� �����ϳ� ���� ������ ���� ����Ŭ ���������� ������ �и��� ������ �����͸� ����

-- dept_test ==> dept_test_20200201
rollback;
insert first
    when deptno = 98 then
        into dept_test (deptno, loc) values (deptno, loc)
    when deptno >= 97 then
        into dept_test2
    else
        into dept_test2
select 98 deptno, '���' dname, '�߾ӷ�' loc from dual union all
select 97, 'IT', '����' from dual;

-- merge : ����
-- ���̺� �����͸� �Է�/�����Ϸ��� ��
-- 1. ���� �Է��Ϸ��� �ϴ� �����Ͱ� �����ϸ� ==> ������Ʈ
-- 2. ���� �Է��Ϸ��� �ϴ� �����Ͱ� �������� ������ ==> insert

-- 1. select ����
-- 2-1. select ���� ����� 0 row�̸� insert
-- 2-2. select ���� ����� 1 row�̸� update

-- merge ������ ����ϰ� �Ǹ� select�� ���� �ʾƵ� �ڵ����� ������ ������ ���� insert Ȥ�� update �����Ѵ�
-- 2�� ������ �ѹ����� �ش�.
-- merge into ���̺�� [alias]
-- using (table | view | INLINE-VIEW)
-- on (��������)
-- when matched then
--      update set col1 = �÷���, col2 = �÷���, ...
-- when not matched then
--          insert (�÷�1, �÷�2, ...) values (�÷���1, �÷���2, ...);

select * from emp_test;

delete emp_test;

-- �α׸� �ȳ���� ==> ������ �ȵȴ� ==> �׽�Ʈ������
truncate table emp_test;

-- emp���̺��� emp_test���̺�� �����͸� ���� (7369-SMITH)
insert into emp_test
select empno, ename, deptno, '010'
from emp
where empno = 7369;

select * from emp_test;

update emp_test set ename = 'browm'
where empno = 7369;

-- emp ���̺��� ��� ������ emp_test ���̺�� ����
-- emp ���̺��� ���������� emp_test���� �������� ������ insert
-- emp ���̺��� �����ϰ� emp_test���� �����ϸ� ename, deptno�� update

-- emp ���̺� �����ϴ� 14���� ������ �� emp_test���� �����ϴ� 7369�� ������ 13���� �����Ͱ�
-- emp_test ���̺� �űԷ� �Է��� �ǰ� emp_test�� �����ϴ� 7369���� �����ʹ� ename(brown)�� emp ���̺� �����ϴ� �̸��� SMITH�� ����

merge into emp_test a
using emp b
on (a.empno = b.empno)
when matched then
    update set a.ename = b.ename, a.deptno = b.deptno
when not matched then
    insert (empno, ename, deptno) values (b.empno, b.ename, b.deptno);
    
select * from emp_test;

-- �ش� ���̺� �����Ͱ� ������ insert, ������ update
-- emp_test ���̺� ����� 9999���� ����� ������ ���Ӱ� insert
-- ������ update
-- insert into dept_test vales (9999, 'brown', 10, '010)
-- update dept_test set ename = 'brown'
--                      deptno = 10
--                      hp = '010'
-- where empno = 9999

alter table emp_test ADD(hp varchar2(20));
merge into emp_test
using emp_test
on (empno = 9999)
when matched then
    update set ename = 'brown', deptno = 10, hp = '010'
when not matched then
    insert values (9999, 'brown', 10, '010');
    
-- merge, window function(�м��Լ�) 

-- �μ��� �հ�, ��ü �հ踦 ������ ���� ���Ϸ���??
SELECT deptno, SUM(sal)
FROM emp
GROUP BY deptno

UNION ALL

SELECT null, SUM(sal)
FROM emp;

-- I/O
-- CPU cache > RAN > SSD > HDD > NETWORK

-- REPORT GROUP FUNCTION
-- ROLLUP
-- CUBE
-- GROUPING

-- ROLLUP
-- ����� : GROUP BY ROLLUP(�÷�1, �÷�2, ...)
-- SUBGROUP�� �ڵ������� ����
-- SUBGROUP�� �����ϴ� ��Ģ : ROLLUP�� ����� �÷��� �����ʿ������� �ϳ��� �����ϸ鼭 SUB GROUP�� ����
-- EX : GROUP BY ROLLUP (deptno)
-- => 
-- ù��° sub group : group by deptno
-- �ι�° sub group : group by null ==> ��ü ���� ���

-- group_ad1�� group by rollup ���� ����Ͽ� �ۼ�
select deptno, sum(sal)
from emp
group by rollup (deptno);

select job, deptno,
       sum(sal + NVL(comm, 0)) sal
from emp
group by rollup (job, deptno);

select job, deptno,
       GROUPING(job), GROUPING(deptno),
       sum(sal + NVL(comm, 0)) sal
from emp
group by rollup (job, deptno);

-- group by (job, deptno) : ������, �μ��� �޿���
-- group by (job) : �������� �޿���
-- group by : ��ü �޿�
select case when grouping(job) = 1 and grouping(deptno) = 1 then '�Ѱ�' else job end job,
       deptno,
       sum(sal + NVL(comm, 0)) sal
from emp
group by rollup (job, deptno);


select decode(grouping(job), 1, decode(grouping(deptno), 1, '�Ѱ�'), job) job, deptno,
       sum(sal + NVL(comm, 0)) sal
from emp
group by rollup (job, deptno);

-- ������ ����� �������� ������ �ۼ��Ͻÿ�
select decode(grouping(job), 1, decode(grouping(deptno), 1, '��'), job) job,
       decode(grouping(deptno), 1, decode(grouping(job), 0, '�Ұ�', '��'), job) deptno,
       sum(sal + nvl(comm , 0)) sal
from emp
group by rollup (job, deptno);
