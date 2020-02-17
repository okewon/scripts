-- :dt ==> 202002

select DECODE(d, 1, iw + 1, iw),
       MIN(DECODE(d, 1, dt)) SUN,
       MIN(DECODE(d, 2, dt)) MON,
       MIN(DECODE(d, 3, dt)) TUE,
       MIN(DECODE(d, 4, dt)) WED,
       MIN(DECODE(d, 5, dt)) THU,
       MIN(DECODE(d, 6, dt)) FRI,
       MIN(DECODE(d, 7, dt)) SAT
from(
    select TO_DATE(:dt, 'yyyymm') + (LEVEL - 1) dt,
       TO_CHAR(TO_DATE(:dt,'yyyymm') + (LEVEL - 1), 'D') d,
       TO_CHAR(TO_DATE(:dt,'yyyymm') + (LEVEL - 1), 'iw') iw
    from dual
    connect by level <= TO_CHAR(LAST_DAY(TO_DATE(:dt,'yyyymm')),'DD'))
group by DECODE(d, 1, iw + 1, iw)
order by DECODE(d, 1, iw + 1, iw);

-- ���� : �������� 1��, ������ ��¥ : �ش� ���� ������ ����
select to_date('202002', 'yyyymm') + (level - 1)
from dual
connect by level <= 29;

-- ���� : �������� : �ش� ���� 1�Ϲٰ� ���� ���� ������
--       ��������¥ : �ش� ���� ������ ���ڰ� ���� ���� �����
�������� 1��~������;
SELECT DECODE(d, 1, iw+1, iw) i,
       MIN(DECODE(d, 1, dt)) sun,
       MIN(DECODE(d, 2, dt)) mon,
       MIN(DECODE(d, 3, dt)) tue,
       MIN(DECODE(d, 4, dt)) wed,
       MIN(DECODE(d, 5, dt)) tur,
       MIN(DECODE(d, 6, dt)) fri,
       MIN(DECODE(d, 7, dt)) sat
FROM 
(SELECT TO_DATE(:dt, 'yyyymm') + (level-1) dt,
        TO_CHAR(TO_DATE(:dt, 'yyyymm')  + (LEVEL-1), 'D') d,
        TO_CHAR(TO_DATE(:dt, 'yyyymm')  + (LEVEL-1), 'iw') iw
 FROM dual
 CONNECT BY LEVEL <=  TO_CHAR(last_day(to_date(:dt,'yyyymm')), 'DD'))
 GROUP BY DECODE(d, 1, iw+1, iw)
 ORDER BY DECODE(d, 1, iw+1, iw);
 

1���ڰ� ���� ���� �Ͽ��ϱ��ϱ�
���������ڰ� ���� ���� ����ϱ� �ϱ�
�ϼ� ���ϱ�; 
SELECT 
        TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1) st,
        LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7- TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'D')) ed,
        LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7- TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'D'))
                      - ( TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D'))) daycnt
FROM dual;      


1����, �����ڰ� ���� �������� ǥ���� �޷�
SELECT DECODE(d, 1, iw+1, iw) i,
       MIN(DECODE(d, 1, dt)) sun,
       MIN(DECODE(d, 2, dt)) mon,
       MIN(DECODE(d, 3, dt)) tue,
       MIN(DECODE(d, 4, dt)) wed,
       MIN(DECODE(d, 5, dt)) tur,
       MIN(DECODE(d, 6, dt)) fri,
       MIN(DECODE(d, 7, dt)) sat
FROM 
(SELECT TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1) + (level-1) dt,
        TO_CHAR(TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1)  + (LEVEL-1), 'D') d,
        TO_CHAR(TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1)  + (LEVEL-1), 'iw') iw
 FROM dual
 CONNECT BY LEVEL <=  last_day(to_date(:dt,'yyyymm'))+(7-to_char(last_day(to_date(:dt,'yyyymm')),'D'))
                    -to_date(:dt,'yyyymm')-(to_char(to_date(:dt,'yyyymm'),'D')-1)  )
 GROUP BY DECODE(d, 1, iw+1, iw)
 ORDER BY DECODE(d, 1, iw+1, iw);
 
 SELECT DECODE(d, 1, iw+1, iw) i,
       MIN(DECODE(d, 1, dt)) sun,
       MIN(DECODE(d, 2, dt)) mon,
       MIN(DECODE(d, 3, dt)) tue,
       MIN(DECODE(d, 4, dt)) wed,
       MIN(DECODE(d, 5, dt)) tur,
       MIN(DECODE(d, 6, dt)) fri,
       MIN(DECODE(d, 7, dt)) sat
FROM 
(SELECT TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1) + (level-1) dt,
        TO_CHAR(TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1)  + (LEVEL-1), 'D') d,
        TO_CHAR(TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1)  + (LEVEL-1), 'iw') iw
 FROM dual
 CONNECT BY LEVEL <=  last_day(to_date(:dt,'yyyymm'))+(7-to_char(last_day(to_date(:dt,'yyyymm')),'D'))
                    -to_date(:dt,'yyyymm')-(to_char(to_date(:dt,'yyyymm'),'D')-1)  )
 GROUP BY DECODE(d, 1, iw+1, iw)
 ORDER BY DECODE(d, 1, iw+1, iw);
 
 create table sales as 
select to_date('2019-01-03', 'yyyy-MM-dd') dt, 500 sales from dual union all
select to_date('2019-01-15', 'yyyy-MM-dd') dt, 700 sales from dual union all
select to_date('2019-02-17', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-02-28', 'yyyy-MM-dd') dt, 1000 sales from dual union all
select to_date('2019-04-05', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-04-20', 'yyyy-MM-dd') dt, 900 sales from dual union all
select to_date('2019-05-11', 'yyyy-MM-dd') dt, 150 sales from dual union all
select to_date('2019-05-30', 'yyyy-MM-dd') dt, 100 sales from dual union all
select to_date('2019-06-22', 'yyyy-MM-dd') dt, 1400 sales from dual union all
select to_date('2019-06-27', 'yyyy-MM-dd') dt, 1300 sales from dual;

-- dt(����) ==> ��, �������� SUM(SALES) ==> ���� ����ŭ ���� �׷��εȴ�
select nvl(sum(jan), 0) jan, nvl(sum(feb), 0) feb, nvl(sum(mar), 0) mar, nvl(sum(apr), 0) apr, nvl(sum(may), 0) may, nvl(sum(jun), 0) jun
from(select decode(to_char(dt, 'mm'), '01', sum(sales)) JAN,
       decode(to_char(dt, 'mm'), '02', sum(sales)) FEB,
       decode(to_char(dt, 'mm'), '03', sum(sales)) MAR,
       decode(to_char(dt, 'mm'), '04', sum(sales)) APR,
       decode(to_char(dt, 'mm'), '05', sum(sales)) MAY,
       decode(to_char(dt, 'mm'), '06', sum(sales)) JUN
       from sales
       group by to_char(dt, 'mm'));

desc sales;
select * from sales;

select DECODE(to_char(dt, 'mm'), '01', nvl(0, total)) Jan,
       DECODE(to_char(dt, 'mm'), '02', nvl(0, total)) FEB,
       DECODE(to_char(dt, 'mm'), '03', nvl(0, total)) MAR,
       DECODE(to_char(dt, 'mm'), '04', nvl(0, total)) APR,
       DECODE(to_char(dt, 'mm'), '05', nvl(0, total)) MAY,
       DECODE(to_char(dt, 'mm'), '06', nvl(0, total)) JUN
from (select to_char(dt, 'mm'), sum(sales) total
     from sales
     group by to_char(dt, 'mm');
     
create table dept_h (
    deptcd varchar2(20) primary key ,
    deptnm varchar2(40) not null,
    p_deptcd varchar2(20),
    
    CONSTRAINT fk_dept_h_to_dept_h FOREIGN KEY
    (p_deptcd) REFERENCES  dept_h (deptcd) 
);

insert into dept_h values ('dept0', 'XXȸ��', '');
insert into dept_h values ('dept0_00', '�����κ�', 'dept0');
insert into dept_h values ('dept0_01', '������ȹ��', 'dept0');
insert into dept_h values ('dept0_02', '�����ý��ۺ�', 'dept0');
insert into dept_h values ('dept0_00_0', '��������', 'dept0_00');
insert into dept_h values ('dept0_01_0', '��ȹ��', 'dept0_01');
insert into dept_h values ('dept0_02_0', '����1��', 'dept0_02');
insert into dept_h values ('dept0_02_1', '����2��', 'dept0_02');
insert into dept_h values ('dept0_00_0_0', '��ȹ��Ʈ', 'dept0_01_0');
commit;

select *
from dept_h;

-- ����Ŭ ������ ���� ����
-- SELECT ...
-- FROM ...
-- WHERE
-- START WITH ���� : � ���� ���������� ������

-- CONNECT BY ��� ���� �����ϴ� ����
--           PRIOR : �̹� ���� ��
--           "   " : ������ ���� ��

-- ����� : �������� �ڽĳ��� ����

-- XXȸ��(�ֻ��� ��������) �����Ͽ� �����μ��� �������� ���� ����

select *
from dept_h
start with deptcd = 'dept0'
connect by prior deptcd = p_deptcd;

-- connect by ��� ����� ���� ����(XXȸ�� - 3���� �μ�(�����κ�, ������ȹ��, �����ý��ۺ�);
-- prior XXȸ��.deptcd = �����κ�.p_deptcd
-- prior �����κ�.deptcd = ��������.p_deptcd
-- prior ��������.deptcd != p_deptcd

-- prior XXȸ��.deptcd = ������ȹ��.p_deptcd
-- prior ������ȹ��.deptcd = ��ȹ��.p_deptcd
-- prior ��ȹ��.deptcd = ��ȹ��Ʈ.p_deptcd

-- prior XXȸ��.deptcd = �����ý��ۺ�.p_deptcd (����1��, ����2��)
-- prior �����ý��ۺ�.deptcd = ����1��.p_deptcd
-- prior ����1��.deptcd != ....
-- prior �����ý��ۺ�.deptcd = ����2��.p_deptcd
-- prior ����2��.deptcd != ....

-- start with deptnm = 'XXȸ��'
-- start with p_;deptcd IS NULL

-- �������� (�ǽ� h_1)
select dept_h.*, level, lpad(' ', (level - 1) * 4, ' ') || deptnm
from dept_h
start with deptcd = 'dept0'
connect by prior deptcd = p_deptcd;