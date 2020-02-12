-- 1. table null
-- 2. idx1 : empno
-- 3. idx2 : job

explain plan for
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

CREATE INDEX idx_n_emp_03 ON emp (job, ename);

explain plan for
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

SELECT rowid, ename, job
FROM emp
order by job, ename;

-- 1. table full
-- 2. idx1 : empno
-- 3. idx2 : job
-- 4. idx3 : job + ename
-- 5. idx4 : ename + job

create index idx_n_emp_04 on emp (ename,job);

select ename, job, rowid
FROM emp
order by ename, job;

-- 3번째 인덱스를 지우자
-- 3, 4번째 인덱스가 컬럼 구성이 동일하고 순서만 다르다

drop index idx_n_emp_03;

explain plan for
select *
from emp
where job = 'MANAGER'
and ename LIKE 'C%';

select *
from table (dbms_xplan.display);

-- emp - table full, pk_emp(empno)
-- dept - table full, pk_dept(deptno)

-- (emp - table full, dept - table full)
-- (dept - table full, emp - table full)

-- (emp - table full, dept - pk_dept)
-- (dept - pk_dept, emp - table full)

-- (emp - pk_emp, dept - table full)
-- (dept - table full, emp - pk_emp)

-- (emp - pk_emp, dept - pk_dept)
-- (dept - pk_dept, emp - pk_emp)


-- 1. 순서
-- 2개의 테이블 조인
-- 각각의 테이블에 인덱스가 5개씩 있다면 한 테이블에 접근 전략 : 6
-- 36 * 2 = 72
-- ORACLE - 실시간 응답 : OLTP (ON LINE TRANSACTION PROCESSING)
--          전체 처리시간 : OLAP (ON LINE ANALYSIS PROCESSING) - 복잡한 쿼리의 실행계획을 세우는데 30M ~ 1H

-- emp 부터 읽을까 dept 부터 읽을까?

explain plan for
select ename, dname, loc
from emp, dept
where emp.deptno = dept.deptno
and emp.empno = 7788;

select *
from table(dbms_xplan.display);

-- 읽는 순서 4 - 3 - 5 - 2 - 6 - 1 - 0 
----------------------------------------------------------------------------------------------
| Id  | Operation                     | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |              |     1 |    63 |     3   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                 |              |       |       |            |          |
|   2 |   NESTED LOOPS                |              |     1 |    63 |     3   (0)| 00:00:01 |
|   3 |    TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    33 |     2   (0)| 00:00:01 |
|*  4 |     INDEX RANGE SCAN          | IDX_N_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
|*  5 |    INDEX UNIQUE SCAN          | PK__DEPT     |     1 |       |     0   (0)| 00:00:01 |
|   6 |   TABLE ACCESS BY INDEX ROWID | DEPT         |     1 |    30 |     1   (0)| 00:00:01 |
----------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access("EMP"."EMPNO"=7788)
   5 - access("EMP"."DEPTNO"="DEPT"."DEPTNO");
   
-- CTAS
-- 제약조건 복사가 NOT NULL만 된다.
-- 백업이나 테스트용으로 사용
select dept_test2.*, rowid
from dept_test2;

-- create table dept_test2 as select * from dept where 1 = 1 구문으로 dept_test 테이블 생성 후 다음 조건에 맞는 인덱스를 생성하세요
create table dept_test2 as
(select *
from dept
where 1 = 1);

desc dept_test2;

-- deptno 컬럼을 기준으로 unique 인덱스 생성
create unique index idx_u_dept_test2_01 dept_test2 (deptno);
-- alter table dept_test2 drop constraint pk_dept_test2;
alter table dept_test2 add constraint pk_dept_test2 PRIMARY KEY (deptno);
-- create index idx_n_dept_test_01 on dept_test2 (deptno);

-- dname 컬럼을 기준으로 non - unique 인덱스 생성
create index idx_n_dept_test_02 on dept_test2 (dname);

-- deptno, dname 컬럼을 기준으로 non - unique 인덱스 생성
create index idx_n_dept_test_03 on dept_test2 (deptno, dname);

-- 실습 idx1에서 생성한 인덱스를 삭제하는 DDL문을 작성하세요
drop index idx_n_dept_test_02;
drop index idx_n_dept_test_03;



select * from emp_test3;
create index idx_n_sal on emp_test3 (sal);
drop index idx_n_sal;
-- 인덱스  : sla
-----------------------------------------------------------------------------------------
| Id  | Operation                   | Name      | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |           |     1 |    87 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP_TEST3 |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_N_SAL |     1 |       |     1   (0)| 00:00:01 |
-----------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("DEPTNO"=20)
   2 - access("SAL">=1000 AND "SAL"<=2000)
   
create index idx_n_deptno on emp_test3 (deptno);
drop index idx_n_deptno;  

-- 인덱스 : deptno
--------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |     1 |    87 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP_TEST3    |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_N_DEPTNO |     1 |       |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("SAL">=1000 AND "SAL"<=2000)
   2 - access("DEPTNO"=20)
   
create index idx_n_deptno_sal on emp_test3 (deptno,sal);
drop index idx_n_deptno_sal;   
-- 인덱스 : 부서번호 + 급여
------------------------------------------------------------------------------------------------
| Id  | Operation                   | Name             | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |                  |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP_TEST3        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_N_DEPTNO_SAL |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("DEPTNO"=20 AND "SAL">=1000 AND "SAL"<=2000)
   
explain plan for
select *
from emp_test3
where sal between 1000 and 2000
and deptno = 20;

select *
from table(dbms_xplan.display);

explain plan for
select b.*
from emp_test3 a, emp_test3 b
where a.mgr = b.empno
and a.deptno = 20;

select *
from table(dbms_xplan.display);

create index idx_n_emp_test3 on emp_test3(deptno);
drop index idx_n_emp_test3;

-------------------------------------------------------------------------------------------------------------------------------
-- deptno(=), empno(LIKE 직원번호%) ==> empno, deptno

-- deptno, sal, mgr, hiredate