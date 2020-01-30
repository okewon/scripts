-- DATE : TO_DATE 문자열 -> 날짜 (DATE) / TO_DATE 날짜 -> 문자열(날짜 포맷 지정)
-- JAVA에서는 날짜 포맷의 대소문자를 가린다 (MM / mm -> 월,분)
-- 주간일자(1~7) : 일요일 1, 월요일 2, ... , 토요일 7
-- 주차 IW : ISO 표준 - 해당주의 목요일을 기준으로 주차를 선정
-- 2019/12/31 화요일 --> 2020/01/02 목요일 --> 그렇기 때문에 1주차로 선정
SELECT TO_CHAR(SYSDATE, 'YYYY-MM/DD HH24:MI:SS'),
       TO_CHAR(SYSDATE, 'D'),        -- 오늘은 2020/01/29 (수) --> 4
       TO_CHAR(SYSDATE, 'IW'),
       TO_CHAR(TO_DATE('2019/12/31', 'YYYY/MM/DD'), 'IW')
FROM dual;

-- emp 테이블의 hiredate(입사일자) 컬럼의 년월일 시:분:초
SELECT ename, hiredate,
       TO_CHAR(hiredate, 'YYYY-MM-DD HH24:MI:SS') hiredate_ontime,
       TO_CHAR(hiredate + 1, 'YYYY-MM-DD HH24:MI:SS') hiredate_plus_1day,
       TO_CHAR(hiredate + 1/24, 'YYYY-MM-DD HH24:MI:SS') hiredate_plus_1hour,
       TO_CHAR(hiredate + (1/24/60)*30, 'YYYY-MM-DD HH24:MI:SS') hiredate_plus_30minutes -- hiredate에 30분을 더하여 TO_CHAR로 표현
FROM emp;

-- 오늘 날짜를 다음과 같은 포맷으로 조회하는 쿼리를 작성하시오
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') DT_DASH,
       TO_CHAR(SYSDATE, 'YYYY-MM-DD HH12-MI-SS') DT_DASH_WITH_TIME,
       TO_CHAR(SYSDATE, 'DD-MM-YYYY') DT_DD_MM_YYYY
FROM dual;

-- MONTHS-BETWEEN(DATE, DATE)
-- 인자로 들어온 두 날짜 사이의 개월수를 리턴
SELECT ename, hiredate,
       MONTHS_BETWEEN(SYSDATE, hiredate),
       MONTHS_BETWEEN(TO_DATE('2020-01-17', 'YYYY-MM-DD'), hiredate)
FROM emp
WHERE ename = 'SMITH';

-- ADD_MONTHS(DATE, 정수 -> 가감할 개월수)
SELECT ADD_MONTHS(SYSDATE, 5), -- 2020/01/29 --> 2020/06/29
       ADD_MONTHS(SYSDATE, -5)  -- 2020/01/29 --> 2019/08/29
FROM dual;

-- NEXT_DAY(DATE, 주간일자), ex : NEXT_DAY(SYSDATE, 5) --> SYSDATE 이후 처음 등장하는 주간일자 5(목)에 해당하는 일자
--                               SYSDATE 2020/01/29(수) 이후 처음 등장하는 5(목)요일 -> 2020/01/30(목)
SELECT NEXT_DAY(SYSDATE, 5)
FROM dual;

-- LAST_DAY(DATE) : DATE가 속한 월의 마지막 일자를 리턴
SELECT LAST_DAY(SYSDATE)    -- SYSDATE 2020/01/29 --> 2020/01/31
FROM dual;

-- LAST_DAY을 통해 인자로 들어온 date가 속한 월의 마지막 일자를 구할 수 있는데
-- date의 첫번째 일자는 어떻게 구할까?
SELECT SYSDATE,
       LAST_DAY(SYSDATE),
       ADD_MONTHS(LAST_DAY(SYSDATE) +1, -1),       
       TO_DATE('01','DD'),
       TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM') || '-01', 'YYYY-MM-DD')
FROM dual;

-- hiredate 값을 이용하여 해당 열의 첫번째 일자로 표현
SELECT ename, hiredate,
       ADD_MONTHS(LAST_DAY(hiredate) +1, -1),
       TO_DATE(TO_CHAR(hiredate, 'YYYY-MM') || '-01', 'YYYY-MM-DD')
FROM emp;


-- empno는 NUMBER 타입, 인자는 문자열
-- 타입이 맞지 않기 때문에 묵시적 형변환이 일어남.
-- 테이블 결합이 타입에 맞게 올바른 인자 값을 주는게 중요
SELECT *
FROM emp
WHERE empno = '7369';

SELECT *
FROM emp
WHERE empno = 7369;

-- hiredate의 경우 DATE 타입, 인자는 문자열로 주어졌기 때문에 묵시적 형변환이 발생
-- 날짜 문자열 보다 날짜 타입으로 명시적으로 기술하는 것이 좋음
SELECT *
FROM emp
WHERE hiredate = '1980/12/17';

SELECT *
FROM emp
WHERE hiredate = TO_DATE('1980/12/17', 'YYYY/MM/DD');

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = '7369';

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT *
FROM table(dbms_xplan.display);

-- 숫자를 문자열로 변경하는 경우 : 포맷
-- 천단위 구분자
-- 1000 이라는 숫자를
-- 한국 : 1,000.50
-- 독일 : 1.000,50

-- emp sal 컬럼(NUMBER 타입)을 포맷팅
-- 9 : 숫자
-- 0 : 강제 자리 맞춤(0으로 표기)
-- L : 통화단위
SELECT ename, sal, TO_CHAR(sal, 'L0,999')
FROM emp;

-- NULL에 대한 연산의 결과는 항상 NULL
-- emp 테이블의 sal 컬럼에는 null 데이터가 존재하지 않음 (14건의 데이터에 대해)
-- emp 테이블의 comm 컬럼에는 null 데이터가 존재 (14건의 데이터에 대해)
-- sal + comm --> comm인 null인 행에 대해서는 결과 null로 나온다.
-- 요구사항이 comm이 null이면 sal 컬럼의 값만 조회
-- 요구사항이 충족 시키지 못한다 -> SW에서는 [결함]

-- NVL(타겟, 대체값)
-- 타겟의 값이 NULL이면 대체값을 반환하고 타겟의 값이 NULL이 아니면 타겟 값을 변환
-- if(타겟 == null)
--      return 대체값;
-- else
--      return 타겟;
SELECT ename, sal, comm, sal+comm, NVL(sal+comm, 0),
       sal+NVL(comm, 0),
       NVL(sal+comm, 0)
FROM emp;

-- NVL2(expr1, expr2, expr3)
-- if(expr1 == null)
--      return expr2;
-- else
--      return expr3;

SELECT ename, sal, NVL2(comm, 10000, 0)
FROM emp;

-- NULLIF(expr1, expr2)
-- if(expr1 == expr2)
--      return null;
-- else
--      return expr1;

SELECT ename, sal, comm, NULLIF(sal, 1250) -- sal 1250인 사원은 null을 리턴, 1250이 아닌 사람은 sal을 리턴
FROM emp;

-- 가변인자
-- COALESCE 인자 중에 가장 처음으로 등장하는 NULL이 아닌 인자를 반환
-- COALESCE(expr1, expr2, ...)
-- if(expr1 != null)
--      return expr1;
-- else
--      return COALESCE(expr2, expr3, ...)

-- COALESCE(comm, sal) : comm이 null이 아니면 comm, comm이 null이면 sal
-- (단, sal 컬럼의 값이 NULL이 아닐때)
SELECT ename, sal, comm, COALESCE(comm, sal)
FROM emp;

-- emp테이블의 정보를 다음과 같이 조회되도록 쿼리를 작성하세요 (NVL, NVL2, COALEASCE)
SELECT empno, ename, MGR,
       NVL(MGR, 9999) MGR_N,
       NVL2(MGR, MGR, 9999) MGR_N_1,
       COALESCE(MGR, 9999) MGR_N_2
FROM emp;

-- users 테이블의 정보를 다음과 같이 조회되도록 쿼리를 작성하세요
-- reg_dt가 null일 경우 sysdate를 적용
SELECT userid, usernm, reg_dt, NVL(reg_dt, SYSDATE) n_reg_dt
FROM users
WHERE userid <> 'cony';

-- CASE : 조건절 
-- CASE :  JAVA의 if - else if - else
-- CASE
--      WHERE 조건 THEN 리턴값1
--      WHERE 조건2 THEN 리턴값2
--      ELSE 기본값
-- END
-- emp 테이블에서 job 컬럼의 값이 SALESMAN 이면 SAL * 1.05 리턴
--                             MANAGER 이면 SAL * 1.1 리턴
--                             PRESIDNENT 이면 SAL * 1.2 리턴
--                             그밖의 사람들은 SAL을 리턴

SELECT ename, job, sal,
       CASE
            WHEN job = 'SALESMAN' THEN sal * 1.05
            WHEN job = 'MANAGER' THEN sal * 1.1
            WHEN job = 'PRESIDENT' THEN sal * 1.2
            ELSE sal
        END bonus_sal
FROM emp;

-- DECODE 함수 : CASE절과 유사
-- (다른점 CASE절 : WHEN 절에 조건비교가 자유롭다.
--        DECODE 함수 : 하나의 값에 대해서 = 비교만 허용
-- DECODE 함수 : 가변인자(인자의 개수가 상황에 따라서 늘어날 수가 있음)
-- DECODE(col | expr, 첫번째 인자와 비교할 값, 첫번째 인자와 두번째 인자가 같을 경우 반환 값,
--              첫번째 인자와 비교할 값, 첫번째 인자와 네번째 인자가 같을 경우 반환 값, ...,
--              option - else 최종적으로 반환할 기본값)

-- emp 테이블에서 job 컬럼의 값이 SALESMAN 이면서 sal가 1400보다 크면 1.05 리턴
--                             SALESMAN 이면서 sal가 1400보다 작으면 1.1 리턴 
--                             MANAGER 이면 SAL * 1.1 리턴
--                             PRESIDNENT 이면 SAL * 1.2 리턴
--                             그밖의 사람들은 SAL을 리턴

SELECT ename, job, sal,
       DECODE(job, 'SALESMAN', sal * 1.05,
                   'MANAGER', sal * 1.1,
                   'PRESIDENT', sal * 1.2) bonus_sal
FROM emp;

-- 1. CASE만 이용해서
SELECT ename, job, sal,
       CASE
            WHEN job = 'SALESMAN' AND sal > 1400 THEN sal * 1.05
            WHEN job = 'SALESMAN' AND sal < 1400 THEN sal * 1.1
            WHEN job = 'MANAGER' THEN sal * 1.1
            WHEN job = 'PRESIDENT' THEN sal * 1.2
            ELSE sal
        END bonus_sal
FROM emp;

-- 2. DECODE, CASE 혼용해서 (DECODE안에 CASE나 DECODE 구문이 중첩이 가능하다)
SELECT ename, job, sal,
      DECODE(job, 'SALESMAN', CASE WHEN sal > 1400  THEN sal * 1.05 WHEN sal < 1400 THEN sal * 1.1 END,
                   'MANAGER', sal * 1.1,
                   'PRESIDENT', sal * 1.2,
                   sal) bonus_sal
FROM emp;
            