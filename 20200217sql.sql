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

-- 기존 : 시작일자 1일, 마지막 날짜 : 해당 월의 마지막 일자
select to_date('202002', 'yyyymm') + (level - 1)
from dual
connect by level <= 29;

-- 변경 : 시작일자 : 해당 월의 1일바가 속한 주의 월요일
--       마지막날짜 : 해당 월의 마지막 일자가 속한 주의 토요일
원본쿼리 1일~말일자;
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
 

1일자가 속한 주의 일요일구하기
마지막일자가 속한 주의 토요일구 하기
일수 구하기; 
SELECT 
        TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1) st,
        LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7- TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'D')) ed,
        LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7- TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'D'))
                      - ( TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D'))) daycnt
FROM dual;      


1일자, 말일자가 속한 주차까지 표현한 달력
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

-- dt(일자) ==> 월, 월단위별 SUM(SALES) ==> 월의 수만큼 행이 그룹핑된다
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

insert into dept_h values ('dept0', 'XX회사', '');
insert into dept_h values ('dept0_00', '디자인부', 'dept0');
insert into dept_h values ('dept0_01', '정보기획부', 'dept0');
insert into dept_h values ('dept0_02', '정보시스템부', 'dept0');
insert into dept_h values ('dept0_00_0', '디자인팀', 'dept0_00');
insert into dept_h values ('dept0_01_0', '기획팀', 'dept0_01');
insert into dept_h values ('dept0_02_0', '개발1팀', 'dept0_02');
insert into dept_h values ('dept0_02_1', '개발2팀', 'dept0_02');
insert into dept_h values ('dept0_00_0_0', '기획파트', 'dept0_01_0');
commit;

select *
from dept_h;

-- 오라클 계층형 쿼리 문법
-- SELECT ...
-- FROM ...
-- WHERE
-- START WITH 조건 : 어떤 행을 시작점으로 삼을지

-- CONNECT BY 행과 행을 연결하는 기준
--           PRIOR : 이미 읽은 행
--           "   " : 앞으로 읽을 행

-- 하향식 : 상위에서 자식노드로 연결

-- XX회사(최상위 조직에서) 시작하여 하위부서로 내려가는 계층 쿼리

select *
from dept_h
start with deptcd = 'dept0'
connect by prior deptcd = p_deptcd;

-- connect by 행과 행과의 연결 조건(XX회사 - 3가지 부서(디자인부, 정보기획부, 정보시스템부);
-- prior XX회사.deptcd = 디자인부.p_deptcd
-- prior 디자인부.deptcd = 디자인팀.p_deptcd
-- prior 디자인팀.deptcd != p_deptcd

-- prior XX회사.deptcd = 정보기획부.p_deptcd
-- prior 정보기획부.deptcd = 기획팀.p_deptcd
-- prior 기획팀.deptcd = 기획파트.p_deptcd

-- prior XX회사.deptcd = 정보시스템부.p_deptcd (개발1팀, 개발2팀)
-- prior 정보시스템부.deptcd = 개발1팀.p_deptcd
-- prior 개발1팀.deptcd != ....
-- prior 정보시스템부.deptcd = 개발2팀.p_deptcd
-- prior 개발2팀.deptcd != ....

-- start with deptnm = 'XX회사'
-- start with p_;deptcd IS NULL

-- 계층쿼리 (실습 h_1)
select dept_h.*, level, lpad(' ', (level - 1) * 4, ' ') || deptnm
from dept_h
start with deptcd = 'dept0'
connect by prior deptcd = p_deptcd;