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
SELECT  userid 아이디, usernm 이름
FROM users
WHERE userid IN('brown', 'cony', 'sally');
