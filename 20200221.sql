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

-- ���� ���� %rowtype : Ư�� ���̺��� ���� ��� �÷��� ������ �� �ִ� ����
-- ��� ��� : ������ ���̺��%rowtype

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

-- ���պ��� RECORD
-- �����ڰ� ���� �������� �÷��� ������ �� �ִ� Ÿ���� �����ϴ� ���
-- JAVA�� �����ϸ� Ŭ������ �����ϴ� ����
-- �ν��Ͻ��� ����� ������ ���� ����

-- ����
-- type Ÿ���̸�(�����ڰ� ����) is record(
--      ������1 ����Ÿ��,
--      ������2 ����Ÿ��,
-- );

-- ������ Ÿ���̸�
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

-- table type ���̺� Ÿ��
-- �� : ��Į�� ����
-- �� : %rowtype, record type
-- �� : table type
--      � ��(%rowtype, record type)�� ������ �� �ִ���
--      �ε��� Ÿ���� ��������

-- dept ���̺��� ������ ���� �� �ִ� table type�� ����
-- ������ ��� ��Į�� Ÿ��, rowtype������ �� ���� ������ ���� �� �־�����
-- table Ÿ�� ������ �̿��ϸ� ���� ���� ������ ���� �� �ִ�.


-- PL/SQL������ �ڹٿ� �ٸ��� �迭�� ���� �ε����� ������ �����Ǿ� ���� �ʰ�
-- ���ڿ��� �����ϴ�

-- �׷��� TABLE Ÿ���� ������ ���� �ε����� ���� Ÿ�Ե� ���� ���
-- BINARY_INTEGER Ÿ���� PL/SQL������ ��� ������ Ÿ������
-- NUMBER Ÿ���� �̿��Ͽ� ������ ��� �����ϰԲ� �� NUMBER Ÿ���� ���� Ÿ���̴�
declare
    type dept_tab is table of dept%rowtype index by binary_integer;
    v_dept_tab dept_tab;
begin
    select * bulk collect into v_dept_tab
    from dept;
    -- ���� ��Į�� ����, record Ÿ���� �ǽ��ÿ���
    -- �� �ุ ��ȸ�ǵ��� WHERE���� ���� �����Ͽ���.
    
    -- �ڹٿ����� �迭[�ε��� ��ȣ]
    -- table����(�ε��� ��ȣ)�� ����
    -- for(int i = 0; i < 10; i++){
    -- }    
    
    for i in 1..v_dept_tab.count loop
    DBMS_OUTPUT.put_line(v_dept_tab(i).deptno || ' ' || v_dept_tab(i).dname);
    end loop;
    
end;
/


-- �������� IF
-- ����

-- IF ���ǹ� THEN
--      ���๮;
-- ELSIF ���ǹ� THEN
--      ���๮;
-- ELSE
--      ���๮;
-- END IF

declare
    p NUMBER(2) := 2; -- ���� ����� ���ÿ� ���� ����
begin
    if p = 1 then
        dbms_output.put_line('1�Դϴ�');
    elsif p = 2 then
        DBMS_OUTPUT.PUT_LINE('2�Դϴ�');
    else
        DBMS_OUTPUT.PUT_LINE('�˷����� �ʾҽ��ϴ�');
    end if;
end;
/

-- case ����
-- 1.�Ϲ� ���̽� (java�� switch�� ����)
-- 1.�˻� ���̽� (if, else if, else)

-- case expression
--     when value then
--         ���๮;
--     when value then
--         ���๮;
--     else
--         ���๮;
-- end case;

declare
    p NUMBER(2) := 2;
begin
    case p
        when 1 then
            dbms_output.put_line('1�Դϴ�');
        when 2 then
            dbms_output.put_line('2�Դϴ�');
        else
            dbms_output.put_line('�𸣴� ���Դϴ�');
    end case;
end;
/

declare
    p NUMBER(1) := 2;
begin
    case 
        when p = 1 then
            dbms_output.put_line('1�Դϴ�');
        when p = 2 then
            dbms_output.put_line('2�Դϴ�');
        else
            dbms_output.put_line('�𸣴� ���Դϴ�');
    end case;
end;
/

-- FOR LOOP ����
-- FOR ���� ���� / �ε��� ���� IN [REVERSE] ���۰�..���ᰪ
--     �ݺ��� ����
-- END LOOP

-- 1���� 5���� FOR LOOP �ݺ����� �̿��Ͽ� ���� ���
declare
begin
    for i in 1..5 loop
        dbms_output.put_line(i);
    end loop;
end;
/

-- �ǽ� 2 ~ 9�ܱ����� �������� ���
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

-- while loop ����
-- while ���� loop
--      �ݺ� ������ ����;
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

-- loop�� ���� ==> while(true)
-- loop
--      �ݺ������� ����;
--      exit ����;
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