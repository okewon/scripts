-- synonym : 동의어
-- 1. 객체 별칭을 부여
--    ==> 이름을 간단하게 표현

-- OCK 사용자가 자신의 테이블 emp 테이블을 사용해서 만든 v_emp vie
-- hr 사용자가 사용할 수 있게끔 권한을 부여

-- v_emp : 민감한 정보 sal, comm를 제외한 view

-- hr 사용자 v_emp를 사용하기 위해 다음과 같이 작성
select * from ock.v_emp;

-- hr 계정에서
-- synonym OCK.v_emp ==> v_emp
-- v_emp == OCK.v_emp

select * from v_emp;

-- 1. OCK 계정에서 v_emp를 hr계정에서 조회할 수 있도록 조회 권한 부여
grant select on v_emp to hr;

-- 2. hr 계정에서 v_emp를 조회하는게 가능 (권한 1번에서 받았기 때문에)
--    사용시 해당 객체의 소유자를 명시 : OCK.v_emp
--    간단하게 OCK.v_emp ==> v_emp 사용하고 싶은 상황
--    synonym 생성

-- create synonym 시노님 이름 for 원래 객체명

-- synonym 삭제
-- drop synonym 시노님 이름

-- grant connect to OCK;
-- grant select on 객체명 to hr;

-- 권한
-- 1. 시스템 권한 : TABLE을 생성, VIIEW 생성, ...
-- 2. 객체 권한 : 특정 객체에 대해 SELECT, UPDATE, INSERT, DELETE, ...

-- ROLE : 권한을 모아놓은 집합
-- 사용자별로 개별 권한을 부여하게 되면 관리의 부담
-- 특정 ROLE에 권한을 부여하고 해당 ROLE 사용자에게 부여
-- 해당 ROLE을 수정하게 되면 ROLE을 갖고 있는 모든 사용자에게 영향

-- 권한 부여/회수
-- 시스템 권한 : GRANT 권한이름 TO 사용자 | ROLE
--              REVOKE 권한이름 FROM 사용자 | ROLE
-- 객체 권한 : GRANT 권한이름 ON 객체명 TO 사용자 | ROLE
--            REVOKE 권한이름 ON 객체명 FROM 사용자 | ROLE

-- data dictionary : 사용자가 관리하지 않고, dbms가 자체적으로 관리하는 시스템 정보를 담은 view
-- data dictionary 접두어
-- 1. USER : 해당 사용자가 소유한 객체
-- 2. ALL : 해당 사용자가 소유한 객체 + 다른 사용자로부터 (권한을) 부여받은 객체
-- 3. DBA : 모든 사용자의 객체

-- VS 특수 VIEW

select * from user_tables;
select * from all_tables;
select * from dba_tables;

-- dictionary 종류 확인 : SYS.DIIONARY

select * from dictionary;

-- 대표적인 ditionary
-- objects : 객체 정보 조회(테이블, 인덱스, view, synonym, ...)
-- tables : 테이블 정보만 조회
-- tab_columns : 테이블의 컬럼 정보 조회
-- indexes : 인덱스 정보 조회
-- ind_columns : 인덱스 구성 컬럼 조회
-- constraints : 제약 조건 조회
-- cons : 제약조건 구성 컬럼 조회
-- tab_comments : 테이블 주석
-- col_comments : 테이블의 컬럼 주석
select * from user_objects;

-- emp, dept 테이블의 인덱스와 인덱스 컬럼 정보 조회
-- user_indexes, user_ind_colums join
-- 테이블명, 인덱스명, 컬럼명
-- emp  ind_n_emp_04    ename
-- emp  ind_n_emp_04    job
select table_name, index_name, column_name, COLUMN_POSITION
from user_ind_columns
order by table_name, index_name, COLUMN_POSITION;

select * from user_ind_columns;

select * from user_indexes;

-- multiple insert : 하나의 insert 구문으로 여러 테이블에 데이터를 입력하는 DML

SELECT * FROM dept_test2;

SELECT * FROM dept_test;

-- 동일한 값을 여러 테이블에 동시에 입력하는 MULTIPLE INSERT
insert all
    into dept_test
    into dept_test2
select 98, '대덕', '중앙로' from dual union all
select 97, 'IT', '영민' from dual;

-- 테이블에 입력할 컬럼을 지정하여 multiple insert
rollback;
alter table dept_test drop constraint SYS_C007128;
alter table dept_test drop constraint PK_DEPT_TEST;
alter table emp_test drop constraint PK_emp_TEST;
alter table emp_test drop constraint FK_EMP_TEST_DEPT_TEST;
alter table dept_test2 drop constraint PK_DEPT_TEST2;
insert all
    into dept_test (deptno, loc) values (deptno, loc)
    into dept_test2
select 98 deptno, '대덕' dname, '중앙로' loc from dual union all
select 97, 'IT', '영민' from dual;

-- 테이블에 입력할 데이터를 조건에 따라 multiple insert
-- case
--      when 조건 기술 then
-- end
rollback;
insert all
    when deptno = 98 then
        into dept_test (deptno, loc) values (deptno, loc)
    else
        into dept_test2
select 98 deptno, '대덕' dname, '중앙로' loc from dual union all
select 97, 'IT', '영민' from dual;

-- 조건을 만족하는 첫번째 insert만 실행하는 multiple insert (switch문)
rollback;
insert first
    when deptno = 98 then
        into dept_test (deptno, loc) values (deptno, loc)
    when deptno >= 97 then
        into dept_test2
    else
        into dept_test2
select 98 deptno, '대덕' dname, '중앙로' loc from dual union all
select 97, 'IT', '영민' from dual;

-- 오라클 객체 : 테이블에 여러개의 구역을 파티션으로 구분
-- 테이블 이름이 동일하나 값의 종류에 따라 오라클 내부적으로 별도의 분리된 영역에 데이터를 저장

-- dept_test ==> dept_test_20200201
rollback;
insert first
    when deptno = 98 then
        into dept_test (deptno, loc) values (deptno, loc)
    when deptno >= 97 then
        into dept_test2
    else
        into dept_test2
select 98 deptno, '대덕' dname, '중앙로' loc from dual union all
select 97, 'IT', '영민' from dual;

-- merge : 통합
-- 테이블에 데이터를 입력/갱신하려고 함
-- 1. 내가 입력하려고 하는 데이터가 존재하면 ==> 업데이트
-- 2. 내가 입력하려고 하는 데이터가 존재하지 않으면 ==> insert

-- 1. select 실행
-- 2-1. select 실행 결과가 0 row이면 insert
-- 2-2. select 실행 결과가 1 row이면 update

-- merge 구문을 사용하게 되면 select를 하지 않아도 자동으로 데이터 유무에 따라 insert 혹은 update 실행한다
-- 2번 쿼리를 한번으로 준다.
-- merge into 테이블명 [alias]
-- using (table | view | INLINE-VIEW)
-- on (조인조건)
-- when matched then
--      update set col1 = 컬럽값, col2 = 컬럼값, ...
-- when not matched then
--          insert (컬럼1, 컬럼2, ...) values (컬럼값1, 컬럼값2, ...);

select * from emp_test;

delete emp_test;

-- 로그를 안남긴다 ==> 복구가 안된다 ==> 테스트용으로
truncate table emp_test;

-- emp테이블에서 emp_test테이블로 데이터를 복사 (7369-SMITH)
insert into emp_test
select empno, ename, deptno, '010'
from emp
where empno = 7369;

select * from emp_test;

update emp_test set ename = 'browm'
where empno = 7369;

-- emp 테이블의 모든 직원을 emp_test 테이블로 통합
-- emp 테이블에는 존재하지만 emp_test에는 존재하지 않으면 insert
-- emp 테이블에는 존재하고 emp_test에도 존재하면 ename, deptno를 update

-- emp 테이블에 존재하는 14건의 데이터 중 emp_test에도 존재하는 7369를 제외한 13건의 데이터가
-- emp_test 테이블에 신규로 입력이 되고 emp_test에 존재하는 7369번의 데이터는 ename(brown)이 emp 테이블에 존재하는 이름인 SMITH로 갱신

merge into emp_test a
using emp b
on (a.empno = b.empno)
when matched then
    update set a.ename = b.ename, a.deptno = b.deptno
when not matched then
    insert (empno, ename, deptno) values (b.empno, b.ename, b.deptno);
    
select * from emp_test;

-- 해당 테이블에 데이터가 있으면 insert, 없으면 update
-- emp_test 테이블에 사번이 9999번인 사람이 없으면 새롭게 insert
-- 있으면 update
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
    
-- merge, window function(분석함수) 

-- 부서별 합계, 전체 합계를 다음과 같이 구하려면??
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
-- 사용방법 : GROUP BY ROLLUP(컬럼1, 컬럼2, ...)
-- SUBGROUP을 자동적으로 생성
-- SUBGROUP을 생성하는 규칙 : ROLLUP에 기술한 컬럼을 오른쪽에서부터 하나씩 제거하면서 SUB GROUP을 생성
-- EX : GROUP BY ROLLUP (deptno)
-- => 
-- 첫번째 sub group : group by deptno
-- 두번째 sub group : group by null ==> 전체 행을 대상

-- group_ad1을 group by rollup 절을 사용하여 작성
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

-- group by (job, deptno) : 담당업무, 부서별 급여합
-- group by (job) : 담당업무별 급여합
-- group by : 전체 급여
select case when grouping(job) = 1 and grouping(deptno) = 1 then '총계' else job end job,
       deptno,
       sum(sal + NVL(comm, 0)) sal
from emp
group by rollup (job, deptno);


select decode(grouping(job), 1, decode(grouping(deptno), 1, '총계'), job) job, deptno,
       sum(sal + NVL(comm, 0)) sal
from emp
group by rollup (job, deptno);

-- 다음의 결과가 나오도록 쿼리를 작성하시오
select decode(grouping(job), 1, decode(grouping(deptno), 1, '총'), job) job,
       decode(grouping(deptno), 1, decode(grouping(job), 0, '소계', '계'), job) deptno,
       sum(sal + nvl(comm , 0)) sal
from emp
group by rollup (job, deptno);
