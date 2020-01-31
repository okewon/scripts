-- WHERE2
-- WHERE 절에 기술하는 조건에 순서는 조회 결과에 영향을 미치지 않는다
-- SQL은 집합의 개념을 갖고 있다.

-- emp 테이블에서 입사 일자가 1982년 1월 1일 이후부터 1983년 1월 1일 이전인 사원의
-- ename, hiredate 데이터를 조회하는 쿼리를 작성하시오
-- 단, 연산자는 비교연산자를 사용한다.
-- 집함 : 키가 185cm 이상이고 몸무게가 70kg 이상인 사람들의 모임 --> 몸무게가 70kg 이상이고 키가 185cm 이상인 사람들의 모임
-- 집합의 특징 : 집합에는 순서가 없다.
-- (1, 5, 10) --> (10, 5, 1) : 두 집합은 서로 동일하다
-- 테이블에는 순서가 보장되지 않음
-- SELECT 결과가 순서가 다르더라도 값이 동일하면 정답
--  > 정렬기능 제공(ORDER BY)
-- 잘생긴 사람들의 모임 --> 집합 X

SELECT ename, CONCAT('19',hiredate) hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD')
AND hiredate <= TO_DATE('1983/01/01', 'YYYY/MM/DD');

SELECT ename, CONCAT('19',hiredate) hiredate
FROM emp
WHERE hiredate <= TO_DATE('1983/01/01', 'YYYY/MM/DD')
AND hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD');

-- IN 연산자
-- 특정 집합에 포함되는지 여부를 확인
-- 부서번호가 10번 혹은(OR) 20번 안에 속하는 직원 조회
SELECT empno, ename, deptno
FROM emp
WHERE deptno IN(10, 20);

-- IN 연산자를 사용하지 않고 OR 연산자 사용
SELECT empno, ename, deptno
FROM emp
WHERE deptno = 10
OR deptno = 20;

-- emp테이블에서 사원이름이 SMITH, JONES인 직원만 조회 (empno, ename, deptno)
-- AND / OR
-- 문자 상수
SELECT empno, ename, deptno
FROM emp
WHERE ename IN('SMITH', 'JONES');

SELECT empno, ename, deptno
FROM emp
WHERE ename = 'SMITH'
OR ename = 'JONES';

-- users 테이블에서 userid가 brown, cony, sally인 데이터를 다음과 같이 조회 하시오.
-- (단, IN 연산자 사용)
SELECT userid 아이디, usernm 이름, ALIAS 별칭
FROM users
WHERE userid IN('brown', 'cony', 'sally');

-- 문자열 매칭 연산자 : LIKE, %, _
-- 위에서 연습한 조건은 문자열 일치에 대해서 다룸
-- 이름이 BR로 시작하는 사람만 조회
-- 이름에 R 문자열이 들어가는 사람만 조회

-- 사원 이름이 S로 시작하는 사원 조회
-- SMITH, SMILE, SKC
-- % 어떤 문자열(한글자, 글자 없을수도 있고, 여러 문자열이 올수도 있다.)
SELECT *
FROM emp 
WHERE ename LIKE 'S%';

-- 글자수 제한한 패턴 매칭
-- _ 정확히 한문자
-- 직원 이름이 S로 시작하고 이름의 전체 길이가 5글자인 직원
SELECT *
FROM emp
WHERE ename LIKE 'S____';

-- 사원 이름에 S글자가 들어가는 사원 조회
-- ename LIKE '%S%'
SELECT *
FROM emp
WHERE ename LIKE '%S%';

-- member 테이블에서 회원의 성이 [신]씨인 사람의 mem_id, mem_name을 조회하는 쿼리를 작성하시오
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';

-- member 테이블세어 회원의 이름에 글자 [이]가 들어가는 모든 사람의 mem_id, mem_name을 조회하는 쿼리를 작성하시오
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%';

-- null 비교 연산 (IS)
-- comm 컬럼의 값이 null인 데이터를 조회 (WHERE comm = null)
SELECT *
FROM emp
WHERE comm IS NULL;

-- emp 테이블에서 상여(comm)가 있는 회원의 정보를 다음과 같이 조회되도록 쿼리를 작성하시오
SELECT *
FROM emp
WHERE comm IS NOT NULL;

SELECT *
FROM emp
WHERE comm >= 0;

-- 사원의 관리자가 7698, 7839 그리고 null이 아닌 직원만 조회
-- NOT IN 연산자에서는 NULL값을 포함 시키면 안된다
SELECT *
FROM emp
WHERE MGR NOT IN (7698, 7839, NULL);

-- -->
SELECT *
FROM emp
WHERE mgr NOT IN(7698, 7839)
AND mgr IS NOT NULL;

-- emp 테이블에서 job이 SALESMAN이고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요
SELECT *
FROM emp
WHERE job = 'SALESMAN'
AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

-- emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요
-- (IN, NOT IN 연산자 사용금지)
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('19810601', 'YYYYMMDD')
AND NOT deptno = 10;

-- emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요
-- (NOT IN 연산자 사용)
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('19810601', 'YYYYMMDD')
AND deptno NOT IN(10);

-- emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요
-- (부서는 10, 20, 30만 있다고 가정하고 IN 연산자를 사용)
SELECT *
FROM emp
WHERE deptno IN(20,30)
AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

-- emp 테이블에서 job이 SALEMAN이거나 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR hiredate >= TO_DATE('19810601', 'YYYYMMDD');

-- emp 테이블에서 job이 SALEMAN이거나 사원번호가 78로 시작하는 직원의 정보를 다음과 같이 조회하세요
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR empno LIKE '78%';

-- emp 테이블에서 job이 SALEMAN이거나 사원번호가 78로 시작하는 직원의 정보를 다음과 같이 조회하세요
-- (LIKE 연산자를 사용하지 마세요)
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR empno BETWEEN 7800 AND 7900;

-- 연산자 수선순위
-- *,/ 연산자가 +,- 보다 우선순위가 높다
-- 1+5*2 = 11 --> (1+5)*2 X
-- 우선순위 변경 ㅣ ()
-- AND > OR


-- emp 테이블에서 사원 이름이 SMITH이거나 사원 이름이 ALLEN 이면서 담당업무가 SALESMAN인 사원 조회
SELECT *
FROM emp
WHERE ename = 'SMITH' 
OR ename = 'ALLEN'
AND job = 'SALESMAN';

SELECT *
FROM emp
WHERE ename = 'SMITH' 
OR (ename = 'ALLEN' AND job = 'SALESMAN');

-- 사원 이름이 SMITH이거나 ALLEN이면 담당업무가 SALESMAN인 사원 조회
SELECT *
FROM emp
WHERE (ename = 'SMITH' OR ename = 'ALLEN')
AND job = 'SALESMAN';

-- emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하면서
-- 입사 일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요
SELECT *
FROM emp
WHERE job ='SALESMAN'
OR (empno LIKE '78%' AND hiredate >= TO_DATE('19810601', 'YYYYMMDD'));

SELECT *
FROM emp
WHERE (job ='SALESMAN'
OR empno LIKE '78%') AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

-- 정렬
-- SELECT *
-- FROM table
-- [WHERE]
-- ORDER BY [컬럼] [별칭] 컬럼인덱스 [ASC | DESC], ...]


-- emp 테이블의 모든 사원을 ename 컬럼 값을 기준으로 오름 차순 정렬한 결과를 조회하세요
SELECT *
FROM emp
ORDER BY ename;

-- emp 테이블의 모든 사원을 ename 컬럼 값을 기준으로 내림 차순 정렬한 결과를 조회하세요
SELECT *
FROM emp
ORDER BY ename DESC;

DESC emp; -- DES : DESCRIBE (설명하다)
ORDER BY ename DESC; -- DESC : DESCENDING (내림)

-- emp 테이블에서 사원 정보를 ename 컬럼을 내림차순, ename 값이 같을 경우 mgr 컬럼으로 오름차순 정렬하는 쿼리를 작성하세요
SELECT *
FROM emp
ORDER BY ename DESC, mgr ASC;

-- 정렬시 별칭을 사용
SELECT empno, ename AS NM, sal*12 AS year_sal
FROM emp
ORDER BY year_sal;

-- 컬럼 인덱스로 정렬
-- java array[0]
-- SQL COLUMN INDEX : 1부터 시작
SELECT empno, ename AS NM, sal*12 AS year_sal
FROM emp
ORDER BY 3;

-- dept 테이블의 모든 정보를 부서이름으로 오름차순 정렬로 조회되도록 쿼리를 작성하세요
SELECT *
FROM dept
ORDER BY dname;

-- dept 테이블의 모든 정보를 부서위치로 내림차순 정렬로 조회되도록 쿼리를 작성하세요
SELECT *
FROM dept
ORDER BY loc DESC;

-- emp 테이블에서 상여(comm) 정보가 있는 사람들만 조회하고, 상여를 많이 받는 사람이 먼저 조회되도록 하고, 상여가 같을 경우
-- 사번으로 오름차순 정렬하세요(상여가 0인 사람은 상여가 없는 것으로 간주)
SELECT *
FROM emp
WHERE comm IS NOT NULL AND comm <> 0
ORDER BY comm DESC, empno ASC;

-- emp 테이블에서 관리자가 있는 사람들만 조회하고 직군(job)순으로 오름차순 정렬하고,
-- 직업이 같을 경우 사번이 큰 사원이 먼저 조회되도록 쿼리를 작성하세요
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;

-- emp 테이블에서 10번 부서(deptno) 혹은 30번 부서에 속하는 사람 중 급여(sal)가
-- 1500이 넘는 사람들만 조회하고 이름으로 내림차순 정렬되도록 쿼리를 작성하세요
SELECT *
FROM emp
WHERE deptno IN(10,30) AND sal>1500
ORDER BY ename;