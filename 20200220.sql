-- 1. leaf 노드(행)가 어떤 데이터인지 확인
-- 2. level ==> 상황탐색시 그룹을 묶기 위해 필요한 값
-- 3. leaf 노드부터 상황 탐색, ROWNUM
select lpad(' ', (level - 1) * 4) || org_cd org_cd, total
from
    ((select org_cd, parent_org_cd, sum(total) total
    from
        (select org_cd, parent_org_cd, no_emp, sum(no_emp) over (partition by gno order by rn rows between unbounded preceding and current row) total
        from
            (select org_cd, parent_org_cd, lv, rownum rn, lv + rownum gno,
                   no_emp / count(*) over (partition by org_cd) no_emp
            from
                (select no_emp.*, level lv, CONNECT_BY_ISLEAF leaf
                from no_emp
                start with parent_org_cd is null
                connect by prior org_cd = parent_org_cd)
            Start with leaf = 1
            connect by prior parent_org_cd = org_cd))
    group by org_cd, parent_org_cd))
start with parent_org_cd is null
connect by prior org_cd = parent_org_cd;

-- git_dt의 dt 컬럼에서 2020년 2월에 해당하는 날짜를 중복되지 않게 구한다 : 최대 29건의 행
-- 2020/02/01
-- 2020/02/02
-- 2020/02/03
-- 2020/02/04
-- ...
-- 2020/02/29

-- 2020/02/03 ==> 2020/02/03
-- 2020/02/03
-- 2020/02/03
-- 2020/02/04
select *
from gis_dt;

select to_date(dt, 'yyyy-MM-DD'), count(dt)
from gis_dt
where dt between to_date('20200201', 'YYYYMMDD') and to_date('20200301', 'YYYYMMDD')
group by  to_date(dt, 'yyyy-MM-DD')
order by  to_date(dt, 'yyyy-MM-DD');

select *
from
    (select to_date('20200201', 'yyyyMMDD') + (level - 1) dt
    from dual
    connect by level <= 29) a
where exists (select 'X'
              from gis_dt
              where gis_dt.dt between dt and to_date(to_char(dt, 'YYYYMMDD') || '235959', 'YYYYMMDDHH24MISS'));
              
-- PL/SQL 블록 구조
-- DECLARE : 변수, 상수 선언 [생략 가능]
-- BEGIN : 로직 기술 [생략 불가]
-- EXCEPTION : 예외처리 [생략 가능]

-- PL/SQL 연산자
-- 중복되는 연산자 제외 특이점
-- 대입 연산자가 일반적인 프로그래밍 언어와 다르다
-- Java =
-- pl/sql :=

-- PL/SQL 변수 선언
-- Java : 타입 변수명 ( String str; )
-- PL/SQL : 변수명 타입 ( deptno NUMBER(2); )

-- PL/SQL 코드 라인의 끝을 기술은 JAVA와 동일하게 세미콜론을 기술한다
-- Java : String str;
-- PL/SQL : deptno NUMBER(2);

-- PL/SQL 블록의 종료 표시하는 문자열 : /
-- SQL의 종료 문자열 : ;

-- Hello World 출력
set SERVEROUTPUT on;

declare
    msg VARCHAR(50);
begin
    msg := 'Hello, World!';
    dbms_output.put_line(msg);
end;
/

-- 부서 테이블에서 10번 부서의 부서번호와 부서이름을 PL/SQL 변수에 저장하고 변수를 출력
desc dept;

declare
    v_deptno NUMBER(2);
    v_dname VARCHAR2(14);
begin
    select deptno, dname into v_deptno, v_dname
    from dept
    where deptno = 10;
    
    DBMS_OUTPUT.put_line(v_deptno || ' ' || v_dname);
end;
/

-- PL/SQL 참조 타입
-- 부서 테이블의 부서번호, 부서명을 조회하여 변수에 담는 과정
-- 부서번호, 부서명의 타입을 부서 테이블에 정의가 되어있음

-- NUMBER, VARCHAR2 타입을 직접 명시하는게 아니라 해당 테이블의 컬럼 타입을 참조하도록 변수 타입을 선언할 수 있다.
-- v_deptno NUMBER(2) ==> dept.deptno%TYPE
set SERVEROUTPUT on;

declare
    v_deptno dept.deptno%type;
    v_dname dept.dname%type;
begin
    select deptno, dname into v_deptno, v_dname
    from dept
    where deptno = 10;
    
    DBMS_OUTPUT.put_line(v_deptno || ' : ' || v_dname);
end;
/

-- 프로시저 블록 유형
-- 익명 블럭(이름이 없는 블럭)
--  . 재사용이 불가능하다 (IN-LINE VIEW vs VIEW)

-- 프로시저 (이름이 있는 블럭)
--  . 재사용이 가능하다
--  . 이름이 있다
--  . 프로시저를 실행할 때 함수처럼 인자를 받을 수 있다

-- 함수 (이름이 있는 블럭)
--  . 재사용이 가능하다
--  . 이름이 있다
--  . 프로시저와 다른 점은 리턴 값이 있다

-- 프로시저 형태
-- create on replace procedure 프로시저 이름 is (IN param, OUT param, IN OUT param)
--    선언부 (declare절이 별도로 없다)
--    begin
--    exception (옵션)
-- end;
-- /

-- 부서 테이블에서 10번 부서의 부서번호와 부서이름을 PL/SQL 변수에 저장하고
-- dbms_output.put_line 함수를 이용하여 화면에 출력하는 printdept 프로시저를 생성

create or replace procedure printdept_ock is
    v_deptno dept.deptno%type;
    v_dname dept.dname%type;
    
    begin
        select deptno, dname into v_deptno, v_dname
        from dept
        where deptno = 10;
    DBMS_OUTPUT.PUT_LINE(v_deptno || ' : ' || v_dname);
end;
/

-- 프로시저 실행 방법
-- exec 프로시저명(인자 ...)

exec printdept_ock;

-- printdept_p 인자로 부서번호를 받아서
-- 해당 부서번호에 해당하는 부서이름과 지역정보를 콘솔에 출력하는 프로시저

create or replace procedure printdept_p(p_deptno IN dept.deptno%type) is
    v_dname dept.dname%type;
    v_loc dept.loc%type;
begin
    select dname, loc into v_dname, v_loc
    from dept
    where deptno = P_deptno;
    
    DBMS_OUTPUT.PUT_LINE(v_dname || ', ' || v_loc);
end;
/
    
exec printdept_p(10);

create or replace procedure printtemp(p_empno IN emp.empno%type) is
    v_dname dept.dname%type;
    v_ename emp.ename%type;
begin
    select ename, dname into v_dname, v_ename
    from dept, emp
    where p_empno = emp.empno and dept.deptno = emp.deptno;
    
    DBMS_OUTPUT.PUT_LINE(v_dname || ', ' || v_ename);
end;
/

exec printtemp(7566);