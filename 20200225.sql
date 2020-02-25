select * from cycle;
-- 1번 고객이 100번 제품을 월요일날 1개 애음
-- 2020년 2월에 대한 일실적을 생성
-- 1. 2020년 2월의 월요일에 대해 일실적 생성
-- 1    100 2   1 한행이 다음 4개의 행으로 생성되어야 한다.
-- 1    100 20200203    1
-- 1    100 20200210    1
-- 1    100 20200217    1
-- 1    100 20200224    1

select to_char(to_date('202002' || '01', 'YYYYMMDD') + (LEVEL - 1), 'YYYYMMDD') dt,
       to_char(to_date('202002' || '01', 'YYYYMMDD') + (LEVEL - 1), 'd') d
from dual
connect by level <= to_char(last_day(to_date('202002' || '01', 'YYYYMMDD')), 'DD');

set serveroutput on;

SET SERVEROUTPUT ON;


CREATE OR REPLACE PROCEDURE create_daily_dales(p_yyyymm IN daily.dt%TYPE) IS
    TYPE cal_row IS RECORD(
        dt VARCHAR2(8),
        d  NUMBER);
    TYPE cal_tab IS TABLE OF cal_row INDEX BY BINARY_INTEGER;
    v_cal_tab cal_tab;
BEGIN

    SELECT TO_CHAR(TO_DATE(p_yyyymm,'YYYYMM') + LEVEL -1,'YYYYMMDD') dt,
           TO_CHAR(TO_DATE(p_yyyymm,'YYYYMM') + LEVEL -1,'d') d
           BULK COLLECT INTO v_cal_tab 
     FROM dual
     CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(p_yyyymm,'YYYYMM')),'DD');
     
     -- 일실적 데이터를 생성하기 전에 기존에 생성된 데이터를 삭제
     delete daily
     where dt like '202002' || '%';

    --애음주기 정보를 조회(FOR - CURSOR)
    FOR daily_row IN (SELECT * FROM cycle) LOOP
        DBMS_OUTPUT.PUT_LINE(daily_row.cid || ' ' || daily_row.day ||  ' ' || daily_row.cnt);
        FOR i IN 1..v_cal_tab.count LOOP
          -- outer loop(애음주기)에서 요일이랑 inner loop(달력)에서 읽은 요일이 같은 데이터를 체크
          IF daily_row.day = v_cal_tab(i).d THEN
            INSERT INTO daily VALUES (daily_row.cid, daily_row.pid, v_cal_tab(i).dt, daily_row.cnt);
            DBMS_OUTPUT.PUT_LINE(v_cal_tab(i).dt || ' ' || v_cal_tab(i).d);
          END IF;
        END LOOP;      
    END LOOP;
    
    COMMIT;
END;
/ 
exec CREATE_DAILY_DALES('202002');
SELECT *
FROM daily;

DELETE daily
WHERE dt LIKE '202002%';

-- create_daily_sales 프로시저에서 건별로 insert하던 로직은 insert select 구문, one-query 형태로 변형하여 속도를 단축

select *
from cycle;

-- 변형하여 속도를 단축
delete daily
where dt like '202002%';

insert into daily
select cycle.cid, cycle.pid, cal.dt, cycle.cnt
from cycle,
    (select to_char(to_date('202002', 'YYYYMM') + (LEVEL - 1), 'YYYYMMDD') dt,
           to_char(to_date('202002', 'YYYYMM') + (LEVEL - 1), 'D') d
    from dual
    connect by level <= to_char(last_day(to_date('202002', 'YYYYMM')), 'DD')) cal
where cycle.day = cal.d
    and cycle.cid = 1
    and cycle.pid = 100
    and cycle.day = 2;
    
select to_char(last_day(to_date('202002', 'YYYYMM') + (LEVEL - 1)), 'DD')
from dual;

-- PL/SQL에서는 SELECT 결과가 없어도 예외 : NO_DATA_FOUND;

declare
    v_dname dept.dname%type;
begin
    select dname into v_dname
    from dept
    where deptno = 70;
exception
    when no_data_found then
        DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND');
    when too_many_rows then
        DBMS_OUTPUT.PUT_LINE('TO_MANY_ROWS');        
end;
/

-- 사용자 정의 예외 생성
-- no_data_found ==> 우리가 직접 만든 사용자 예외로 변경하여 새롭게 예외를 던지는 예제

declare
    no_emp exception;
    v_ename emp.ename%type;
begin
    begin
        select ename into v_ename
        from emp
        where empno = 8000;
    exception
        when no_data_found then
            raise no_emp;
    end;
exception
    when no_emp then
        DBMS_OUTPUT.PUT_LINE('no_emp');
end;
/

-- emp 테이블을 통해서는 부서이름을 알수가 없다 (부서이름 dept 테이블에 존재)
-- ==> 1. join
--     2. 서브쿼리 - 스칼라 서브쿼리(select )

select *
from emp, dept
where emp.deptno = dept.deptno;

select emp.*, (select dname from dept where dept.deptno = emp.deptno) dname
from emp;

-- 부서번호를 인자로 받고 부서명을 리턴해주는 함수 생성
getDeptName;

create or replace function getDeptName(p_deptno dept.deptno%type) return varchar2 is
    v_dname dept.dname%type;
begin
    select dname into v_dname
    from dept
    where deptno = p_deptno;
    
    return v_dname;
end;
/

select emp.*, getDeptName(emp.deptno) dname
from emp;

-- getEmpName 함수를 생성
-- 직원번호를 인자로 하고
-- 해당 직원의 이름을 리턴해주는 함수를 생성해보세요
desc emp;
create or replace function getEmpName (p_empno emp.empno%type) return varchar2 is
    v_ename emp.ename%type;
begin
    select ename into v_ename
    from emp
    where emp.empno = p_empno;
    
    return v_ename;
end;
/

select getEmpName(7369) ename
from dual;

select lpad(' ', (level - 1) * 4) || deptnm
from dept_h
start with deptcd = 'dept0'
connect by prior deptcd = p_deptcd;

select '*' || lpad(' ', (:lv - 1) * 4) || '*'
from dual;

create or replace function getPadding(p_lv NUMBER, p_indent number, p_padding varchar2) return varchar2 is
    v_padding varchar2(200);
begin
    select lpad(' ', (p_lv - 1) * p_indent, p_padding) into v_padding
    from dual;
    
    return v_padding;
end;
/

select getPadding(level, 5, '-') || deptnm deptnm
from dept_h
start with deptcd = 'dept0'
connect by prior deptcd = p_deptcd;

select *
from table(dbms_xplain.display);

-- declare - 연관된 PL/SQL 블록을 묶어주는 오라클 객체
-- 선업부
-- 몸체(구현부)로 구성

-- getEmpName, getDeptName ==> NAMES 패키지에 담는다

create or replace package names as
    function getempname(p_empno emp.empno%type) return varchar2;
    function getdeptname(p_deptno dept.deptno%type) return varchar2;
end names;
/

create or replace package body names as

    function getdeptname(p_deptno dept.deptno%type) return varchar2 as
        v_dname dept.dname%type;
    begin
        select dname into v_dname
        from dept
        where deptno = p_deptno;
        
        return v_dname;
    end;
    
    function getempname (p_empno emp.empno%type) return varchar2 is
        v_ename emp.ename%type;
    begin
        select ename into v_ename
        from emp
        where emp.empno = p_empno;
    
        return v_ename;
    end;
end;
/

select emp.*, NAMES.GETDEPTNAME(emp.empno) dname
from emp;