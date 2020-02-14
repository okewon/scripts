-- 다음의 결과가 나오도록 쿼리를 작성하시오
select decode(grouping(job), 1, decode(grouping(deptno), 1, '총'), job) job,
       decode(grouping(deptno), 1, decode(grouping(job), 0, '소계', '계'), deptno) deptno,
       sum(sal + nvl(comm , 0)) sal
from emp
group by rollup (job, deptno);

-- MERGE : SELECT 하고 나서 데이터가 조회되면 UPDATE
--         SELECT 하고 나서 데이터가 조회되지 않으면 INSERT
-- SELECT + UPDATE / SELECT + INSERT ==> MERGE

-- REPORT GROUP FUNCTION
-- 1. ROLLUP
--    - GROUP BY ROLLUP (컬럼1, 컬럼2, ...)
--    - ROLLUP절에 기술한 컬럼을 오른쪽에서 하나씩 제거한 컬럼으로 SUBGROUP
--    - GROUP BY 컬럼1, 컬럼2
--    - UNION
--    - GROUP BY 컬럼1
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

select decode(grouping(dept.dname),1, decode(grouping(job),1 , '총합') , dept.dname) dname, job, sum(sal + nvl(comm, 0))
from emp, dept
where dept.deptno = emp.deptno
group by rollup (dname, job)
order by dept.dname, job desc;

-- REPORT GROUP FUNCTION
-- 1. ROLLUP
-- 2. CUBE
-- 3. GROUPING SETS
-- 활용도 
-- 3, 1 >>>>>>>>>>>>>>>>>>>>>> CUBE

-- GROUPING SETS
-- 순서와 관계없이 서브 그룹을 사용자가 직접 선언
-- 사용방법 : GROUP BY GROUPING SETS(col1, col2, ...)
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

-- GROUPING SETS의 경우 컬럼 기술 순서가 결과에 영향을 미치지 않는다
-- ROLLUP은 컬럼 기술 순서가 결과 영향을 미친다

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

-- job, deptno로 group by 한 결과와 mgr로 group by한 결과를 조회하는 sql을 grouping sets로 급여합 sum(sal)로 작성
select job, deptno, mgr, sum(sal) sal
from emp
group by grouping sets((job, deptno), mgr);

-- CUBE
-- 가능한 모든 조합으로 컬럼을 조합한 SUB GROUP을 생성한다
-- 단, 기술한 컬럼의 순서는 지킨다

-- EX : GROUP BY CUBE(col1, col2)

-- (col1, col2) ==> 
-- (col1, col2) ==> GROUP BY col2
-- (col1, col2) ==> GROUP BY 전체
-- (col1, col2) ==> GROUP BY col1
-- (col1, col2) ==> GROUP BY col1, col2

-- 만약 컬럼 3개를 CUBE절에 기술할 경우 나올 수 있는 가지수는?

select job, deptno, sum(sal) sal
from emp
group by cube(job, deptno);

-- 혼종
select job, deptno, mgr, sum(sal) sal
from emp
group by job, rollup(deptno), cube(mgr);

-- group by job, deptno, mgr == group by job, deptno, mgr
-- group by job, deptno == group by job, deptno
-- group by job, null, mgr == group by job, mgr
-- group by job, null, null == group by job

-- 서브쿼리 UPDATE
-- 1. emp_test 테이블 drop
-- 2. emp 태이블을 이용해서 emp_test 테이블 생성 (모든 행에 대해 ctas)
-- 3. emp_test 테이블에 dname VARCHAR2(14) 컬럼 추가
-- 4. emp_test.dname 컬럼을 dept 테이블을 이용해서 부서명을 업데이트
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

-- correlated subquery update - 실습 sub_a1
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

-- correlated subquery update - 실습 sub_a2
-- dept_test 테이블에 있는 부서 중에 직원이 속하지 않은 부서 정보를 삭제
-- dept_test.empcnt 컬럼은 사용하지 않고
insert into dept_test values(99, 'it1', 'daejeon');
insert into dept_test values(98, 'it2', 'daejeon');

-- 직원이 속하지 않는 부서 정보 조회
-- 직원 있다 없다.
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
        
-- correlated subquery update - 실습 sub_a3
update emp_test a set sal = sal + 200
where sal < (select avg(sal)
             from emp_test b
             where a.deptno = b.deptno);
        
rollback;             
select *
from emp_test;

-- with절
-- 하나의 쿼리에서 반복되는 SUBQUERY가 있을 때
-- 해당 SUBQUERY를 별도로 선언하여 재사용

-- MAIN 쿼리가 실행될 때 WITH 선언한 쿼리 블럭이 메모리에 임시적으로 저장
-- ==> MAIN 쿼리가 종료되면 메모리 해제

-- SUBQUERY 작성시에는 해당 SUBQUERY의 결과를 조회하기 위해서 I/O 반복적으로 일어나지만
-- WITH절을 통해 선어하려면 한번만 SUBQUERY가 실행되고 그 결과를 메모리에 저장해 놓고 재사용
-- 단, 하나의 쿼리에서 동일한 SUBQUERY가 반복적으로 나오는거는 잘못 작성한 SQL일 확률이 높음

-- WITH 쿼리블록이름 AS {
--     서브쿼리
-- }

-- SELECT *
-- FROM 쿼리블록이름

-- 직원의 부서별 급여 평균을 조회하는 쿼리 블록을 WITH절을 통해 선언

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
      
-- 달력 만들기
-- connect by level <[=] 정수
-- 해당 테이블의 행을 정수만큼 복제하고, 복제된 행을 구별하기 위해서 LEVEL을 부여
-- LEVEL은 1부터 시작

select dummy, level
from dual
connect by level <= 10;

select dept.*, level
from dept
connect by level <= 5;

-- 2020년 2월의 달력을 생성
-- dt = 202002, 202003
-- 1.
-- 달력
-- 일    월   화   수   목   금   토
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