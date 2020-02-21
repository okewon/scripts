set SERVEROUTPUT on;

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

create or replace procedure registdept_test(p_deptno in dept_test.deptno%type, p_dname in dept_test.dname%type, p_loc in dept_test.loc%type) is
begin
    insert into dept_test (deptno, dname, loc) values (p_deptno, p_dname, p_loc);
end;
/

exec registdept_test(99, 'ddit','daejeon');

delete dept
where deptno = 99;

select * from dept_test;

commit;

create or replace procedure UPDATEdept_test (p_deptno in dept_test.deptno%type, p_dname in dept_test.dname%type, p_loc in dept_test.loc%type) is
begin
    update dept_test set dname = p_dname, loc = p_loc  where deptno = p_deptno;
    
    commit;
end;
/

exec registdept_test(99, 'ddit_m','daejeon');

select * from dept_test;

exec registdept_test(96, 'ddit_m','daejeon');

-- 복합 변수 %rowtype : 특정 테이블의 행의 모든 컬럼을 지정할 수 있는 변수
-- 사용 방법 : 변수명 테이블명%rowtype

set SERVEROUTPUT ON;
declare
    v_dept_row dept%rowtype;
begin
    select * into v_dept_row
    from dept
    where deptno = 10;
    
    DBMS_OUTPUT.put_line(v_dept_row.deptno || ' ' || v_dept_row.dname || ' ' || v_dept_row.loc);

end;
/

-- 복합변수 RECORD
-- 개발자가 직접 여러개의 컬럼을 관리할 수 있는 타입을 생성하는 명령
-- JAVA를 비유하면 클래스를 선언하는 과정
-- 인스턴스를 만드는 과정은 변수 선언

-- 문법
-- type 타입이름(개발자가 지정) is record(
--      변수명1 변수타입,
--      변수명2 변수타입,
-- );

-- 변수명 타입이름
declare
    type dept_row is record(
        deptno NUMBER(2),
        dname VARCHAR(14)
    );
    
    v_dept_row dept_row;
begin
    select deptno, dname into v_dept_row
    from dept
    where deptno = 10;
    
    DBMS_OUTPUT.put_line(v_dept_row.deptno || ' ' || v_dept_row.dname);
    
end;
/

-- table type 테이블 타입
-- 점 : 스칼라 변수
-- 선 : %rowtype, record type
-- 면 : table type
--      어떤 선(%rowtype, record type)을 저장할 수 있는지
--      인덱스 타입은 무엇인지

-- dept 테이블의 정보를 담을 수 있는 table type을 선언
-- 기존에 배운 스칼라 타입, rowtype에서는 한 행의 정보를 담을 수 있었지만
-- table 타입 변수를 이용하면 여러 행의 정보를 담을 수 있다.


-- PL/SQL에서는 자바와 다르게 배열에 대한 인덱스가 정수로 고정되어 있지 않고
-- 문자열도 가능하다

-- 그래서 TABLE 타입을 선언할 때는 인덱스에 대한 타입도 같이 명시
-- BINARY_INTEGER 타입은 PL/SQL에서만 사용 가능한 타입으로
-- NUMBER 타입을 이용하여 정수만 사용 가능하게끔 한 NUMBER 타입의 서브 타입이다
declare
    type dept_tab is table of dept%rowtype index by binary_integer;
    v_dept_tab dept_tab;
begin
    select * bulk collect into v_dept_tab
    from dept;
    -- 기존 스칼라 변수, record 타입을 실습시에는
    -- 한 행만 조회되도록 WHERE절을 통해 제한하였다.
    
    -- 자바에서는 배열[인덱스 번호]
    -- table변수(인덱스 번호)로 접근
    -- for(int i = 0; i < 10; i++){
    -- }    
    
    for i in 1..v_dept_tab.count loop
    DBMS_OUTPUT.put_line(v_dept_tab(i).deptno || ' ' || v_dept_tab(i).dname);
    end loop;
    
end;
/


-- 조건제어 IF
-- 문법

-- IF 조건문 THEN
--      실행문;
-- ELSIF 조건문 THEN
--      실행문;
-- ELSE
--      실행문;
-- END IF

declare
    p NUMBER(2) := 2; -- 변수 선언과 동시에 값을 대입
begin
    if p = 1 then
        dbms_output.put_line('1입니다');
    elsif p = 2 then
        DBMS_OUTPUT.PUT_LINE('2입니다');
    else
        DBMS_OUTPUT.PUT_LINE('알려지지 않았습니다');
    end if;
end;
/

-- case 구문
-- 1.일반 케이스 (java의 switch와 유사)
-- 1.검색 케이스 (if, else if, else)

-- case expression
--     when value then
--         실행문;
--     when value then
--         실행문;
--     else
--         실행문;
-- end case;

declare
    p NUMBER(2) := 2;
begin
    case p
        when 1 then
            dbms_output.put_line('1입니다');
        when 2 then
            dbms_output.put_line('2입니다');
        else
            dbms_output.put_line('모르는 값입니다');
    end case;
end;
/

declare
    p NUMBER(1) := 2;
begin
    case 
        when p = 1 then
            dbms_output.put_line('1입니다');
        when p = 2 then
            dbms_output.put_line('2입니다');
        else
            dbms_output.put_line('모르는 값입니다');
    end case;
end;
/

-- FOR LOOP 문법
-- FOR 루프 변수 / 인덱스 변수 IN [REVERSE] 시작값..종료값
--     반복할 로직
-- END LOOP

-- 1부터 5까지 FOR LOOP 반복문을 이용하여 숫자 출력
declare
begin
    for i in 1..5 loop
        dbms_output.put_line(i);
    end loop;
end;
/

-- 실습 2 ~ 9단까지의 구구단을 출력
declare
begin
    for i in 2..9 loop
        for j in 1..9 loop
            dbms_output.put_line(i || ' * ' || j || ' = ' || i*j);
        end loop;
        dbms_output.put_line(' ');
    end loop;
end;
/

-- while loop 문법
-- while 조건 loop
--      반복 실행할 로직;
-- end loop;

declare
    i number := 0;
begin
    while i <= 5 loop
        dbms_output.put_line(i);
        i := i+1;
    end loop;
end;
/

-- loop문 문법 ==> while(true)
-- loop
--      반복실행할 문자;
--      exit 조건;
-- end loop;

declare
    i number := 0;
begin
    loop
        dbms_output.put_line(i);
        exit when i > 4;
        i := i + 1;
    end loop;
end;
/