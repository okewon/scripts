-- 1. leaf ���(��)�� � ���������� Ȯ��
-- 2. level ==> ��ȲŽ���� �׷��� ���� ���� �ʿ��� ��
-- 3. leaf ������ ��Ȳ Ž��, ROWNUM
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

-- git_dt�� dt �÷����� 2020�� 2���� �ش��ϴ� ��¥�� �ߺ����� �ʰ� ���Ѵ� : �ִ� 29���� ��
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
              
-- PL/SQL ��� ����
-- DECLARE : ����, ��� ���� [���� ����]
-- BEGIN : ���� ��� [���� �Ұ�]
-- EXCEPTION : ����ó�� [���� ����]

-- PL/SQL ������
-- �ߺ��Ǵ� ������ ���� Ư����
-- ���� �����ڰ� �Ϲ����� ���α׷��� ���� �ٸ���
-- Java =
-- pl/sql :=

-- PL/SQL ���� ����
-- Java : Ÿ�� ������ ( String str; )
-- PL/SQL : ������ Ÿ�� ( deptno NUMBER(2); )

-- PL/SQL �ڵ� ������ ���� ����� JAVA�� �����ϰ� �����ݷ��� ����Ѵ�
-- Java : String str;
-- PL/SQL : deptno NUMBER(2);

-- PL/SQL ����� ���� ǥ���ϴ� ���ڿ� : /
-- SQL�� ���� ���ڿ� : ;

-- Hello World ���
set SERVEROUTPUT on;

declare
    msg VARCHAR(50);
begin
    msg := 'Hello, World!';
    dbms_output.put_line(msg);
end;
/

-- �μ� ���̺��� 10�� �μ��� �μ���ȣ�� �μ��̸��� PL/SQL ������ �����ϰ� ������ ���
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

-- PL/SQL ���� Ÿ��
-- �μ� ���̺��� �μ���ȣ, �μ����� ��ȸ�Ͽ� ������ ��� ����
-- �μ���ȣ, �μ����� Ÿ���� �μ� ���̺� ���ǰ� �Ǿ�����

-- NUMBER, VARCHAR2 Ÿ���� ���� ����ϴ°� �ƴ϶� �ش� ���̺��� �÷� Ÿ���� �����ϵ��� ���� Ÿ���� ������ �� �ִ�.
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

-- ���ν��� ��� ����
-- �͸� ��(�̸��� ���� ��)
--  . ������ �Ұ����ϴ� (IN-LINE VIEW vs VIEW)

-- ���ν��� (�̸��� �ִ� ��)
--  . ������ �����ϴ�
--  . �̸��� �ִ�
--  . ���ν����� ������ �� �Լ�ó�� ���ڸ� ���� �� �ִ�

-- �Լ� (�̸��� �ִ� ��)
--  . ������ �����ϴ�
--  . �̸��� �ִ�
--  . ���ν����� �ٸ� ���� ���� ���� �ִ�

-- ���ν��� ����
-- create on replace procedure ���ν��� �̸� is (IN param, OUT param, IN OUT param)
--    ����� (declare���� ������ ����)
--    begin
--    exception (�ɼ�)
-- end;
-- /

-- �μ� ���̺��� 10�� �μ��� �μ���ȣ�� �μ��̸��� PL/SQL ������ �����ϰ�
-- dbms_output.put_line �Լ��� �̿��Ͽ� ȭ�鿡 ����ϴ� printdept ���ν����� ����

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

-- ���ν��� ���� ���
-- exec ���ν�����(���� ...)

exec printdept_ock;

-- printdept_p ���ڷ� �μ���ȣ�� �޾Ƽ�
-- �ش� �μ���ȣ�� �ش��ϴ� �μ��̸��� ���������� �ֿܼ� ����ϴ� ���ν���

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