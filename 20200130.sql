-- emp 테이블을 이용하여 deptno에 따라 부서명으로 변경해서 다음과 같이 조회되는 쿼리를 작성하세요

-- CASE문
SELECT empno, ename,
      CASE
            WHEN deptno = 10 THEN 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESEARCH'
            WHEN deptno = 30 THEN 'SALES'
            WHEN deptno = 40 THEN 'OPERATIONS'
            ELSE 'DDIT'
      END DNAME
FROM emp;

-- DECODE문
SELECT empno, ename,
     DECODE(deptno, 10, 'ACCOUNTING',
                    20, 'RESEARCH', 
                    30, 'SALES', 
                    40, 'OPERATIONS',
                    'DDIT') DNAME
FROM emp;

-- emp 테이블을 이용하여 hiredate에 따라 올해 건강보험 검진 대상자인지 조회하는
-- 쿼리를 작성하세요 (생년을 기준으로 하나 여기서는 입사년도를 기준으로 한다
-- 올해년도가 짝수이면
--      입사년도가 짝수일 때 건강검진 대상자
--      입사년도가 홀수일 때 건강검진 비대상자
-- 올해년도가 홀수이면
--      입사년도가 짝수일 때 건강검진 비대상자
--      입사년도가 홀수일 때 건강검진 대상자

SELECT empno, ename, hiredate,
       DECODE(MOD(TO_NUMBER(TO_CHAR(hiredate, 'YYYY')),2), 0, DECODE(MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')), 2), 0, '건강검진 대상자', 1, '건강검진 미대상자'),
                                                            1, DECODE(MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')), 2), 1, '건강검진 대상자', 0, '건강검진 미대상자')) CONCAT_TO_DOCTOR
FROM emp;


-- users 테이블을 이용하여 reg_dt에 따라 올해 건강보험 검진 대상자인지 조회하는 쿼리를 작성하세요.
-- (생년을 기준으로 하나 여기서는 reg_gt를 기준으로 한다)
SELECT userid, usernm, alias, reg_dt,
       CASE WHEN MOD(TO_NUMBER(TO_CHAR(reg_dt, 'YYYY')), 2) = 0 THEN 
                                                                CASE WHEN MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')), 2) = 0 THEN '건강검진 대상자' WHEN MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')), 2) = 1 THEN '건강검진 비대상자' END
            WHEN MOD(TO_NUMBER(TO_CHAR(reg_dt, 'YYYY')), 2) = 1 THEN
                                                                CASE WHEN MOD(TO_NUMBER(TO_CHAR(reg_dt, 'YYYY')), 2) = 1 THEN '건강검진 대상자' WHEN MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')), 2) = 0 THEN '건강검진 비대상자' END
       ELSE '건강검진 비대상자'
       END
FROM users;                        


-- GROUP BY 행을 묶을 기준
-- 부서번호가 같은 ROW끼리 묶는 경우 : GROUP BY deptno
-- 담당업무가 같은 ROW끼리 묶는 경우 : GROUP BY job
-- MGR이 같고 담당업무가 같은 ROW끼리 묶는 경우 : GROUP BY mgr, job

-- 그룹함수의 종류
-- SUM : 합계
-- COUNT : 갯수
-- MAX : 최대값
-- MIN : 최소값
-- AVG : 평균

-- 그룹 함수의 특징
-- 해당 컬럼에 NUL값을 갖는 ROW가 존재할 경우 해당 값은 무시하고 계산한다 (NULL 연산의 결과는 null)

-- 부서별 급여 합

-- 그룹함수 주의점
-- GROUP BY 절에 나온 컬럼어외의 다른 컬럼이 SELECT절에 포함되면 에러
SELECT deptno, ename, 
       sum(sal) sum_sal, MAX(sal) man_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) avg_sal, COUNT(sal) count_sal,
       sum(comm)
FROM emp
GROUP BY deptno, ename;


SELECT sum(sal) sum_sal, MAX(sal) man_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) avg_sal, 
       COUNT(sal) count_sal, -- sal 컬럼의 값이 null이 아닌 row의 갯수
       COUNT(comm), -- comm 컬럼의 값이 null이 아닌 row의 갯수
       COUNT(*) -- 몇건의 데이터가 있는지
FROM emp;

-- GROUP BY의 기준이 empno이면 결과수가 몇건??
-- 그룹화와 관련없는 임의의 문자열, 함수, 숫자 등은 SELECT절에 나오는 것이 가능
SELECT 1, SYSDATE, 'ACCOUNTING', empno, sum(sal) sum_sal, MAX(sal) man_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) avg_sal, 
       COUNT(sal) count_sal, -- sal 컬럼의 값이 null이 아닌 row의 갯수
       COUNT(comm), -- comm 컬럼의 값이 null이 아닌 row의 갯수
       COUNT(*) -- 몇건의 데이터가 있는지
FROM emp
GROUP BY empno;


-- SINGLE ROW FUNCTION의 경우 WHERE절에서 사용하는 것이 가능하나 MULTI ROW FUNCTION(GROUP BY)의 경우 WHERE절에서 사용하는 것이 불가능하고
-- HAVING절에서 조건을 기술한다

-- 부서별 급여 합 조회, 단 급여합이 9000이상인 row만 조회
-- deptno, 급여합

SELECT deptno, SUM(sal) sum_sal
FROM emp
WHERE SUM(sal) >= 9000
GROUP BY deptno;

SELECT deptno, SUM(sal) sum_sal
FROM emp
GROUP BY deptno
HAVING SUM(sal) > 9000;

-- emp 테이블을 이용하여 다음을 구하시오
SELECT MAX(sal) max_sal,
       MIN(sal) min_sal,
       ROUND(AVG(sal),2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal) count_sal,
       COUNT(mgr) count_mgr,
       count(*) count_all
FROM emp;


-- emp 테이블을 이용하여 다음을 구하시오
SELECT deptno,
       MAX(sal) max_sal,
       MIN(sal) min_sal,
       ROUND(AVG(sal),2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal) count_sal,
       COUNT(mgr) count_mgr,
       count(*) count_all
FROM emp
GROUP BY deptno;

-- emp 테이블을 이용하여 다음을 구하시오
-- grp2에서 작성한 쿼리를 활용하여 deptno 대신 부서명이 나올 수 있도록 수정하시오
SELECT DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES') DNAME,
       MAX(sal) max_sal,
       MIN(sal) min_sal,
       ROUND(AVG(sal),2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal) count_sal,
       COUNT(mgr) count_mgr,
       count(*) count_all
FROM emp
GROUP BY DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES')
ORDER BY DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES');

-- emp 테이블을 이용하여 다음을 구하시오
-- 직원의 입사 년월별로 몇명의 직원이 입사했는지 조회하는 쿼리를 작성하세요
-- ORACLE 9I 이전까지는 GROUP BY절에 기술한 컬럼으로 정렬을 보장
-- ORACLE 10G 이후부터는 GROUP BY절에 기술한 컬럼으로 정렬을 보장하지 않는다 (GRUOP BY 연산 속도 향상)
SELECT TO_CHAR(hiredate, 'YYYYMM') HIRE_YYYYMM, COUNT(*) CNT
FROM emp 
group by TO_CHAR(hiredate, 'YYYYMM');

-- emp 테이블을 이용하여 다음을 구하시오
-- 직원의 입사 년별로 몇명의 직원이 입사했는지 조회하는 쿼리를 작성하세요
SELECT TO_CHAR(hiredate, 'YYYY') HIRE_YYYYMM, COUNT(*) CNT
FROM emp 
group by TO_CHAR(hiredate, 'YYYY');

-- 회사에 존재하는 부서의 개수는 몇개인지 조회하는 쿼리를 작성하세요
-- (dept 테이블 사용)
SELECT *
FROM dept;

SELECT COUNT(*) CNT
FROM dept;

-- 직원이 속한 부서의 개수를 조회하는 쿼리를 작성하시오
-- (emp 테이블 사용)
SELECT *
FROM emp
ORDER BY deptno;

SELECT COUNT(*) CNT
FROM (SELECT COUNT(deptno)
      FROM emp
      GROUP BY deptno);