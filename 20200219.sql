SELECT b.ename, b.sal, a.lv
FROM
(SELECT a.*, rownum rm
FROM
(SELECT *
FROM
(   SELECT LEVEL lv
    FROM dual
    CONNECT BY LEVEL <=14) a,
(   SELECT deptno, COUNT(*) cnt
    FROM emp
    GROUP BY deptno) b
WHERE b.cnt >= a.lv
ORDER BY b.deptno, a.lv) a) a 
JOIN
(SELECT b.*, rownum rm
FROM
(SELECT ename, sal, deptno
FROM emp
ORDER BY deptno, sal desc)b) b ON(a.rm = b.rm);

-- 위에 쿼리를 분석함수를 사용해서 표현하면..
-- 부서별 급여 랭킹

select ename, sal, deptno,
       rank() over (partition by deptno order by sal desc) sal_rank
from emp;

-- 쿼리 실행 결과 11건
-- 페이징 처리(페이지당 10건의 게시글)
-- 1페이지 : 1 ~ 10
-- 2페이지 : 11 ~ 20
-- 바인드 변수 : page, :pageSize
select *
from
    (select rownum rn, a.*
    from 
        (SELECT seq, LPAD(' ', (LEVEL-1)*4) || title title, DECODE(parent_seq, NULL, seq, parent_seq) root
         FROM board_test
         START WITH parent_seq IS NULL
         CONNECT BY PRIOR seq = parent_seq
         ORDER SIBLINGS BY root DESC, seq ASC) a)
where rn BETWEEN (:page-1)* :pageSize +1 AND :page*:pageSize;

-- 분석함수 문법
-- 분석함수명([인자]) over ([partition by 컬럼] [order by 컬럼] [windowing])
-- partition by 컬럼 : 해당 컬럼이 같은 row끼리 하나의 그룹으로 묶는다
-- order by 컬럼 : partition by에 의해 묶는 그룹 내에서 order by 컬럼으로 정렬

-- row_number() over (partition by deptno order by sal desc) rank

-- 순위 관련 분석함수
-- rank() : 같은 값을 가질 때 중복 순위를 인정, 후순위는 중복 값만큼 떨어진 값부터 시작
--          2등이 2명이면 3등은 없고 4등부터 후순위가 생성된다.
-- densc_rank() : 같은 값을 가질 때 중복 순위를 인정, 후순위는 중복순위 다음부터 시작
--                  2등이 2명이더라도 후순위는 3등부터 시작
-- row_number() : rownum과 유사, 중복된 값을 허용하지 않음

-- 부서별, 급여 순위를 3개의 랭킹 관련함수를 적용

select ename, sal, deptno,
        rank() over (partition by deptno order by sal) rank,
        dense_rank() over (partition by deptno order by sal) sal_dense_rank,
        row_number() over (partition by deptno order by sal) sal_row_number
from emp;

-- 급여를 기준으로 오름차순을 적용했을 때
select ename, sal, deptno, empno,
        rank() over (order by sal) rank,
        dense_rank() over (order by sal) sal_dense_rank,
        row_number() over (order by sal) sal_row_number
from emp;

-- 급여를 기준으로 오름차순을 적용하고 급여가 같은 값에 한하여 사번이 빠른 사람이 높은 순위가 되도록 empno로 다시 정렬
select ename, sal, deptno, empno,
        rank() over (order by sal, empno asc) rank,
        dense_rank() over (order by sal, empno asc) sal_dense_rank,
        row_number() over (order by sal, empno asc) sal_row_number
from emp;

-- 그룹 함수 : 전체 직원수
select count(*)
from emp;

-- ana1 : 사원 전체 급여 순위
-- 분석함수에서 그룹 : partition by ==> 기술하지 않으면 전체 행을 대상으로
select emp.empno, emp.ename, emp.deptno, cnt
from emp,
    (select deptno, count(*) cnt
     from emp
     group by deptno) dept_cnt
where emp.deptno = dept_cnt.deptno; 

-- 통계관련 분석함수 (group 함수에서 제공하는 함수 종류와 동일)
-- sum(컬럼)
-- count(*),count(컬럼)
-- min(컬럼)
-- max(컬럼)
-- avg(컬럼)

-- no_ana2를 분석함수를 사용하여 작성
-- 부서별 직원수

select empno,ename,deptno,count(*) over(partition by deptno) cnt
from emp;

select empno, ename, deptno,
        count(deptno) over (partition by deptno) cnt
from emp;

select empno, ename, deptno,
        count(*) over (partition by deptno) cnt
from emp;

select empno, ename, sal, deptno,
        round(avg(sal) over (partition by deptno),2) avg_sal
from emp;     

select empno, ename, sal, deptno,
        max(sal) over (partition by deptno)
from emp;

select empno, ename, sal, deptno,
        min(sal) over (partition by deptno)
from emp;

-- 급여를 내림차순으로 정렬하고, 급여가 같을 때는 입사일자가 빠른 사람이 높은 우선순위가 되도록 정렬하여
-- 현재햄의 다음행(lead)의 sal 컬럼을 구하는 쿼리 작성
select empno, ename, hiredate, sal,
       lead(sal) over (order by sal desc, hiredate) lead_sal
from emp;       
       
select empno, ename, hiredate, sal,
       lag(sal) over (order by sal desc, hiredate) lead_sal
from emp;       

select empno, ename, hiredate, sal,
       lag(sal) over (partition by job order by sal desc, hiredate) lag_sal
from emp;

select aa.empno, aa.ename, aa.sal
from
    (select a.*, case when a.sal < b.sal then sum(a.sal) end c_sum
     from
        (select empno, ename, sal
        from emp
        order by sal, hiredate desc) a,
        (select empno, ename, sal
        from emp
        order by sal, hiredate desc) b
     where a.sal < b.sal) aa;


select a.*, case when a.sal < b.sal then a.sal + nvl(b.sal, 0) end c_sum
from
        (select empno, ename, sal
        from emp
        order by sal, hiredate desc) a,
        (select empno, ename, sal
        from emp
        order by sal, hiredate desc) b;

SELECT a.empno, a.ename, a.sal, SUM(b.sal) C_SUM
FROM 
    (SELECT a.*, rownum rn
     FROM 
        (SELECT *
         FROM emp
         ORDER BY sal)a)a,
    (SELECT a.*, rownum rn
     FROM 
        (SELECT *
         FROM emp
         ORDER BY sal, empno)a)b
WHERE a.rn >= b.rn
GROUP BY a.empno, a.ename, a.sal, a.rn
ORDER BY a.rn, a.empno;

-- no_ana3을 분석함수를 이용하여 SQL 작성

select empno, ename, sal, sum(sal) over (order by sal, empno rows between unbounded preceding and current row) c_sal
from emp;

-- 현재 행을 기준으로 이전 한 행부터 이후 한 행까지 총 3개행의 sal 합계 구하기
select empno, ename, sal, sum(sal) over (order by sal, empno rows between 1 preceding and 1 following) c_sum
from emp;

-- 사원번호, 사원이름, 부서번호, 급여 정보를 부서별로 급여, 사원번호 오름차순으로 정렬했을 때, 자신의 급여와 선행하는 사원들의 급여 합을 조회하는 쿼리를 작성하세요
-- order by 기술 후 windowing 절을 기술하지 않을 경우 다음 windowing이 기본 값으로 적용된다
-- range unboundede preceding
-- range between unbounded preceding and current row
select emp.empno, emp.ename, emp.deptno, emp.sal,
       sum(emp.sal) over(partition by emp.deptno order by emp.sal, emp.empno rows between a.cnt preceding and current row) c_sum
from emp,
    (select deptno, count(*) cnt
     from emp
     group by deptno) a
where emp.deptno = a.deptno;

select empno, ename, deptno, sal,
        sum(sal) over (partition by deptno order by sal, empno rows between unbounded preceding and current row) c_sum
from emp;

select empno, ename, deptno, sal,
        sum(sal) over (partition by deptno order by sal, empno) c_sum
from emp;

-- windowing의 range, row 비교
-- range : 논리적인 행의 단위, 같은 값을 가지는 컬럼까지 자신의 행으로 취급
-- rows : 물리적인 행의 단위
select empno, ename, deptno, sal,
        sum(sal) over (partition by deptno order by sal rows unbounded preceding) row_, -- 동일한 값(중복되는 값)이 있을 때 포함 유무가 다름
        sum(sal) over (partition by deptno order by sal range unbounded preceding) range_,
        sum(sal) over (partition by deptno order by sal) default_
from emp;