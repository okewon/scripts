-- emp 테이블에서 10번 부서(deptno) 혹은 30번 부서에 속하는 사람 중 급여(sal)가 1500이 넘는 사람들만
-- 조회하고 이름으로 내림차순 정렬되도록 쿼리를 작성하세요
SELECT *
FROM emp
WHERE deptno IN(10,30)
AND sal > 1500
ORDER BY ename DESC;

-- ROWNUM : 횡번호를 나타내는 컬럼
SELECT ROWNUM, empno, ename
FROM emp
WHERE deptno IN(10,30)
AND sal > 1500;

-- ROWNUM을 WHERE절에서도 사용가능
-- 동작하는거 : ROWNUM = 1, ROWNUM <= 2 --> ROWNUM = 1, ROWNUM <= N 
-- 동작하지 않는거 : ROWNUM = 2, ROWNUM >= 2 --> ROWNUM = N(N은 1이 아닌 정수), ROWNUM >= N(N은 1이 아닌 정수)
-- ROWNUM 이미 읽은 데이터에다가 순서를 부여
-- **유의점1 : 읽지 않은 상태의 값들(ROWNUM이 부여되지 않은 행)은 조회할 수가 없다.
-- **유의점2 : ORDER BY 절은 SELECT 절 이후에 실행
-- 사용 용도 : 페이징 처리
-- 테이블에 있는 모든 행을 조회하는 것이 아니라 우리가 원하는 페이지에 해당하는 행 데이터만 조회를 한다.
-- 페이징 처리시 고려사항 : 1페이지당 건수, 정렬 기준
-- emp 테이블 중 row 건수 : 14
-- 페이지당 5건의 데이터를 조회
-- 1page : 1 ~ 5
-- 2page : 6 ~ 10
-- 3page : 11 ~ 15
SELECT ROWNUM rn, empno, ename
FROM emp
ORDER BY ename;

-- 정렬된 결과에 ROWNUM을 부여하기 위해서는 IN LINE VIEW를 사용한다
-- 요점정리 : 1. 정렬, 2.ROWNUM 부여

-- SELECT *를 기술할 경우 다른 EXPRESSION을 표기하기 위해서 테이블명.* 테이블명칭.*로 표현해야 한다.
SELECT ROWNUM, emp.*
FROM emp;

SELECT ROWNUM, e.*
FROM emp e;

-- ROWNUM -> rn
-- *page size : 5, 정렬기준은 ename
-- 1 page : rn 1 ~ 5
-- 2 page : rn 6 ~ 10
-- 3 page : rn 11 ~ 15
-- n page : rn (page-1)* pageSize + 1 ~ page * pageSize
SELECT *
FROM
    (SELECT ROWNUM rn, a.*
    FROM
        (SELECT empno, ename
        FROM emp
        ORDER BY ename) a)
WHERE rn BETWEEN (1 - 1) * 5 AND 1 * 5;

-- emp 테이블에서 ROWNUM 값이 1~10인 값만 조회하는 쿼리를 작성해보세요 (정렬없이 진행하세요, 결과는 화면과 다를 수 있습니다)
SELECT ROWNUM rn, empno, ename
FROM emp
WHERE ROWNUM <= 10 AND ROWNUM >= 1;

-- ROWNUM 값이 11~20(11~14)인 값만 조회하는 쿼리를 작성해보세요
-- HINT : alias, inline - view
SELECT *
FROM (SELECT ROWNUM RN, empno, ename
      FROM emp)
WHERE RN BETWEEN 11 AND 20;

-- emp 테이블의 사원 정보를 이름컬럼으로 오름차순 적용했을 때의 11~14번째 행을 다음과 같이 조회하는 쿼리를 작성해보세요
SELECT *
FROM 
    (SELECT ROWNUM RN, B.*
    FROM
        (SELECT empno, ename
        FROM emp
        ORDER BY ename) B)
WHERE RN BETWEEN (:page-1)* :pageSize +1 AND :page*:pageSize;

SELECT *
FROM 
    (SELECT ROWNUM RN, B.*
    FROM
        (SELECT empno, ename
        FROM emp
        ORDER BY ename) B)
WHERE RN BETWEEN 11 AND 14;

-- DUAL 테이블 : 데이터와 관계 없이, 함수를 테스트 해볼 목적으로 사용
-- 문자열 대소문자 : LOWER, UPPPER, INITCAP
SELECT *
FROM dual;

SELECT LENGTH('TEST')
FROM dual;

SELECT LOWER('Hello, world'), UPPER('Hello, world'),INITCAP('Hello, world')
FROM dual;

SELECT LOWER(ename), UPPER(ename),INITCAP(ename)
FROM emp;

-- 함수는 WHERE 절에서도 사용 가능
-- 사원 이름이 SMITH인 사원만 조회
SELECT *
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM emp
WHERE ename = UPPER(:ename);

-- SQL 작성시 아래 형태는 지양해야 한다.
-- 테이블의 컬럼을 가공하지 않는 형태로 SQL을 작성한다.
SELECT *
FROM emp
WHERE ename = UPPER(:ename);

SELECT CONCAT('Hello,', ' world') CONCAT,
       SUBSTR('Hello, world', 1 ,5) SUBSTR, -- 1~5
       LENGTH('Hello, world') LENGTH,
       INSTR('Hello, world', 'o') INSTR1,
       INSTR('Hello, world', 'o', 6) INSTR2,
       LPAD('Hello, world', 15, '*') LPAD,
       RPAD('Hello, world', 15, '*') RPAD,
       REPLACE('Hello, world', 'H', 'T') REPLACE,
       TRIM('   Hello, world   ') TRIM, -- 공백을 제거
       TRIM('d' FROM 'Hello, world') TRIM2 --공백이 아닌 소문자 d 제거
FROM dual;

-- 숫자 함수
-- ROUND : 반올림 (10.6을 소수점 첫번째 자리에서 반올림 -> 11)
-- TRUNC : 절삭(버림) (10.6을 소수점 첫번째 자리에서 절삭 -> 10)
-- ROUND, TRUNC : 몇번째 자리에서 반올림/절삭
-- MOD : 나머지 (몫이 아니라 나누기 연산을 한 나머지 값) (13/5 -> 몫 : 2, 나머지 : 3)

-- ROUND(대상 숫자, 최종 결과 자리)
SELECT ROUND(105.54, 1) ROUND,-- 반올림 결과가 소수점 첫번째 자리까지 나오도록 --> 두번째 자리에서 반올림
       ROUND(105.55,1) ROUND,-- 반올림 결과가 소수점 첫번째 자리까지 나오도록 --> 두번째 자리에서 반올림
       ROUND(105.55,0) ROUND,-- 반올림 결과가 정수부만 --> 소수점 첫번째 자리에서 반올림
       ROUND(105.55,-1) ROUND,-- 반올림 결과가 십의 자리까지 --> 일의 자리에서 반올림
       ROUND(105.55) ROUND -- 두번째 인자를 입력하지 않을 경우 0이 적용
FROM dual;

SELECT TRUNC(105.54, 1) TRUNC, -- 절삭의 결과가 소수점 첫번째 자리까지 나오도록 -- > 두번째 자리에서 절삭
       TRUNC(105.55, 1) TRUNC, -- 절삭의 결과가 소수점 첫번째 자리까지 나오도록 --> 두번째 자리에서 절삭
       TRUNC(105.55, 0) TRUNC, -- 절삭의 결과가 정수부(일의 자리)까지 나오도록 --> 소수점 첫번째 자리에서 절삭
       TRUNC(105.55, -1) TRUNC, -- 절삭의 결과가 10의 자리까지 나오도록 --> 일의 자리에서 절삭
       TRUNC(105.55) TRUNC -- 두번째 인자를 입력하지 않을 경우 0이 적용
FROM dual;

-- EMP 테이블에서 사원의 급여(sal)를 100으로 나눴을 때 몫을 구하시오
SELECT ename, sal,
       TRUNC(sal/1000) TRUNC_sal, -- 몫을 구해보세요
       MOD(sal, 1000) MOD_sal -- MOD의 결과는 divisor보다 항상 작다(0~999)
FROM emp;

DESC emp;

-- 년도 2자리/월 2자리/일자 2자리
SELECT ename, hiredate
FROM emp;

-- SYSDATE : 현재 오라클 서버의 시분초가 포함된 날짜 정보를 리턴하는 특수 함수
-- 함수명(인자1, 인자2)
-- date + 정수 = 일자 연산
-- 2020/01/28 + 5
-- 1 = 하루
-- 1시간 = 1/24

-- 숫자 표기 : 숫자
-- 문자 표기 : 싱글 쿼테이션 + 문자열 + 싱글 쿼테이션 --> '문자열'
-- 날짜 표기 : TO_DATE('문자열 날짜 값', '문자열 날짜 값의 표기 형식') --> TO_DATE('2020-01-28', 'YYYY-MM-DD')
SELECT SYSDATE + 5, SYSDATE + 1/24
FROM dual;

SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD') LASTDAY, TO_DATE('2019/12/31', 'YYYY/MM/DD') - 5 LASTDAY_BEFORE5,
       SYSDATE NOW, SYSDATE - 3 NOW_BEFORE3
FROM dual;