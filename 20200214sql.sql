-- ������ ����� �������� ������ �ۼ��Ͻÿ�
select decode(grouping(job), 1, decode(grouping(deptno), 1, '��'), job) job,
       decode(grouping(deptno), 1, decode(grouping(job), 0, '�Ұ�', '��'), deptno) deptno,
       sum(sal + nvl(comm , 0)) sal
from emp
group by rollup (job, deptno);

-- MERGE : SELECT �ϰ� ���� �����Ͱ� ��ȸ�Ǹ� UPDATE
--         SELECT �ϰ� ���� �����Ͱ� ��ȸ���� ������ INSERT
-- SELECT + UPDATE / SELECT + INSERT ==> MERGE

-- REPORT GROUP FUNCTION
-- 1. ROLLUP
--    - GROUP BY ROLLUP (�÷�1, �÷�2, ...)
--    - ROLLUP���� ����� �÷��� �����ʿ��� �ϳ��� ������ �÷����� SUBGROUP
--    - GROUP BY �÷�1, �÷�2
--    - UNION
--    - GROUP BY �÷�1
--    - UNION
--    - GROUP BY
-- 2. CUBE

SELECT deptno, job, sum(sal + nvl(comm, 0))
FROM emp
GROUP BY ROLLUP (deptno, job);

select b.dname, a.job, a.sum
from (SELECT deptno, job, sum(sal + nvl(comm, 0)) sum
      FROM emp
      GROUP BY ROLLUP (deptno, job)) a, dept b
where b.deptno(+) = a.deptno
order by b.dname, job desc;

select dept.dname, job, sum(sal + nvl(comm, 0))
from emp, dept
where dept.deptno = emp.deptno
group by rollup (dname, job)
order by dept.dname, job desc;

select decode(grouping(dept.dname),1, decode(grouping(job),1 , '����') , dept.dname) dname, job, sum(sal + nvl(comm, 0))
from emp, dept
where dept.deptno = emp.deptno
group by rollup (dname, job)
order by dept.dname, job desc;

-- REPORT GROUP FUNCTION
-- 1. ROLLUP
-- 2. CUBE
-- 3. GROUPING SETS
-- Ȱ�뵵 
-- 3, 1 >>>>>>>>>>>>>>>>>>>>>> CUBE

-- GROUPING SETS
-- ������ ������� ���� �׷��� ����ڰ� ���� ����
-- ����� : GROUP BY GROUPING SETS(col1, col2, ...)
-- ==>
-- GROUP BY col1
-- UNION ALL
-- GROUP BY col2

-- GROUP BY GROUPING SETS( (col1, col2,), col2, col4)
-- ==> 
-- GROUP BY col1, col2
-- UNION ALL
-- GROUP BY col3
-- UNION ALL
-- GROUP BY col4;

-- GROUPING SETS�� ��� �÷� ��� ������ ����� ������ ��ġ�� �ʴ´�
-- ROLLUP�� �÷� ��� ������ ��� ������ ��ģ��

-- GROUP BY GROUPING SETS(col1, col2)
-- ==>
-- GROUP BY col1
-- UNION ALL
-- GROUP BY col2
-- GROUP BY GROUPING SETS(col2, col1)
-- ==>
-- GROUP BY col2
-- UNION ALL
-- GROUP BY col1

select job, deptno, sum(sal) sal
from emp
group by grouping sets(job, deptno);

-- group by grouping sets(job, deptno)
-- ==>
-- group by job
-- union ALL
-- group by deptno

select job, sum(sal)
from emp
group by grouping sets(job, job);

-- job, deptno�� group by �� ����� mgr�� group by�� ����� ��ȸ�ϴ� sql�� grouping sets�� �޿��� sum(sal)�� �ۼ�
select job, deptno, mgr, sum(sal) sal
from emp
group by grouping sets((job, deptno), mgr);

-- CUBE
-- ������ ��� �������� �÷��� ������ SUB GROUP�� �����Ѵ�
-- ��, ����� �÷��� ������ ��Ų��

-- EX : GROUP BY CUBE(col1, col2)

-- (col1, col2) ==> 
-- (col1, col2) ==> GROUP BY col2
-- (col1, col2) ==> GROUP BY ��ü
-- (col1, col2) ==> GROUP BY col1
-- (col1, col2) ==> GROUP BY col1, col2

-- ���� �÷� 3���� CUBE���� ����� ��� ���� �� �ִ� ��������?

select job, deptno, sum(sal) sal
from emp
group by cube(job, deptno);

-- ȥ��
select job, deptno, mgr, sum(sal) sal
from emp
group by job, rollup(deptno), cube(mgr);

-- group by job, deptno, mgr == group by job, deptno, mgr
-- group by job, deptno == group by job, deptno
-- group by job, null, mgr == group by job, mgr
-- group by job, null, null == group by job

-- �������� UPDATE
-- 1. emp_test ���̺� drop
-- 2. emp ���̺��� �̿��ؼ� emp_test ���̺� ���� (��� �࿡ ���� ctas)
-- 3. emp_test ���̺� dname VARCHAR2(14) �÷� �߰�
-- 4. emp_test.dname �÷��� dept ���̺��� �̿��ؼ� �μ����� ������Ʈ
desc dept;

drop table emp_test;

create table emp_test as
select *
from emp;

alter table emp_test add(dname varchar2(14));

select * from emp_test;

update emp_test set dname = (select dname
                             from dept
                             where dept.deptno = emp_test.deptno);
                             
select *
from emp_test;

-- correlated subquery update - �ǽ� sub_a1
drop table dept_test;

create table dept_test as
select *
from dept;

alter table dept_test add(empcnt NUMBER(10));

select *
from dept_test;

update dept_test set empcnt = nvl((select count(*) cnt
                                   from emp
                                   where deptno = dept_test.deptno
                                   group by deptno), 0);

select *
from emp;

-- correlated subquery update - �ǽ� sub_a2
-- dept_test ���̺� �ִ� �μ� �߿� ������ ������ ���� �μ� ������ ����
-- dept_test.empcnt �÷��� ������� �ʰ�
insert into dept_test values(99, 'it1', 'daejeon');
insert into dept_test values(98, 'it2', 'daejeon');

-- ������ ������ �ʴ� �μ� ���� ��ȸ
-- ���� �ִ� ����.
select dept_test.deptno, count(emp_test.deptno)
from dept_test, emp_test
where dept_test.deptno = emp_test.deptno
group by dept_test.deptno
having count(emp_test.deptno) > 0
order by dept_test.deptno;

select *
from dept_test
where 0 < (select count(*)
           from emp_test
           where emp_test.deptno = dept_test.deptno);
           
delete dept_test
where 0 = (select count(*)
           from emp_test
           where emp_test.deptno = dept_test.deptno);
        
-- correlated subquery update - �ǽ� sub_a3
update emp_test a set sal = sal + 200
where sal < (select avg(sal)
             from emp_test b
             where a.deptno = b.deptno);
        
rollback;             
select *
from emp_test;

-- with��
-- �ϳ��� �������� �ݺ��Ǵ� SUBQUERY�� ���� ��
-- �ش� SUBQUERY�� ������ �����Ͽ� ����

-- MAIN ������ ����� �� WITH ������ ���� ���� �޸𸮿� �ӽ������� ����
-- ==> MAIN ������ ����Ǹ� �޸� ����

-- SUBQUERY �ۼ��ÿ��� �ش� SUBQUERY�� ����� ��ȸ�ϱ� ���ؼ� I/O �ݺ������� �Ͼ����
-- WITH���� ���� �����Ϸ��� �ѹ��� SUBQUERY�� ����ǰ� �� ����� �޸𸮿� ������ ���� ����
-- ��, �ϳ��� �������� ������ SUBQUERY�� �ݺ������� �����°Ŵ� �߸� �ۼ��� SQL�� Ȯ���� ����

-- WITH ��������̸� AS {
--     ��������
-- }

-- SELECT *
-- FROM ��������̸�

-- ������ �μ��� �޿� ����� ��ȸ�ϴ� ���� ����� WITH���� ���� ����

WITH sal_avg_dept as (
    select deptno, round(avg(sal), 2) sal
    from emp
    group by deptno
), 
    dept_empcnt as(
    select deptno, count(*) empcnt
    from emp
    group by deptno)

select *
from sal_avg_dept a, dept_empcnt b
where a.deptno = b.deptno;

WITH temp as (
    select sysdate - 1 from dual union all
    select sysdate - 2 from dual union all
    select sysdate - 3 from dual)

select *
from temp;

select *
from (select sysdate - 1 from dual union all
      select sysdate - 2 from dual union all
      select sysdate - 3 from dual);
      
-- �޷� �����
-- connect by level <[=] ����
-- �ش� ���̺��� ���� ������ŭ �����ϰ�, ������ ���� �����ϱ� ���ؼ� LEVEL�� �ο�
-- LEVEL�� 1���� ����

select dummy, level
from dual
connect by level <= 10;

select dept.*, level
from dept
connect by level <= 5;

-- 2020�� 2���� �޷��� ����
-- dt = 202002, 202003
-- 1.
-- �޷�
-- ��    ��   ȭ   ��   ��   ��   ��
select TO_DATE('202002', 'YYYYMM') + level - 1,
       TO_CHAR(TO_DATE('202002', 'YYYYMM') + (level - 1), 'D'),
       DECODE(TO_CHAR(TO_DATE('202002', 'YYYYMM') + (level - 1), 'D'), 1, TO_DATE('202002', 'YYYYMM') + level - 1) Sunday,
       DECODE(TO_CHAR(TO_DATE('202002', 'YYYYMM') + (level - 1), 'D'), 2, TO_DATE('202002', 'YYYYMM') + level - 1) Monday,
       DECODE(TO_CHAR(TO_DATE('202002', 'YYYYMM') + (level - 1), 'D'), 3, TO_DATE('202002', 'YYYYMM') + level - 1) Tuesday,
       DECODE(TO_CHAR(TO_DATE('202002', 'YYYYMM') + (level - 1), 'D'), 4, TO_DATE('202002', 'YYYYMM') + level - 1) Wednesday,
       DECODE(TO_CHAR(TO_DATE('202002', 'YYYYMM') + (level - 1), 'D'), 5, TO_DATE('202002', 'YYYYMM') + level - 1) Thursday,
       DECODE(TO_CHAR(TO_DATE('202002', 'YYYYMM') + (level - 1), 'D'), 6, TO_DATE('202002', 'YYYYMM') + level - 1) Friday,
       DECODE(TO_CHAR(TO_DATE('202002', 'YYYYMM') + (level - 1), 'D'), 7, TO_DATE('202002', 'YYYYMM') + level - 1) Saturday
from dual
connect by level <= TO_CHAR(LAST_DAY(to_date('202002', 'YYYYMM')), 'DD');

select TO_CHAR(LAST_DAY(to_date('202002', 'YYYYMM')), 'DD')
from dual;