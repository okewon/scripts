-- CROSS JOIN ==> 카티션 프로덕트(Cartesian product)
-- 조인하는 두 테이블의 연결 조건이 누락되는 경우 : 가능한 모든 조합에 대해 연결(조인)이 시도
-- dept(4건), emp(14건)의 CROSS JOIN의 결과는 4 * 14 = 56건

-- dept 테이블과 emp 테이블을 조인을 하기 위해 FROM 절에 두개의 테이블을 기술
-- WHERE절에 두 테이블의 연결 조건을 누락

SELECT dept.dname, emp.empno, emp.ename
FROM dept, emp
WHERE dept.deptno = 10
      AND dept.deptno = emp.deptno;
      
-- customer, product 테이블을 이용하여 고객이 애음 가능한 모든 제품의 정보를 결합하여 다음과 같이 조회되도록 쿼리를 작성하세요
SELECT customer.cid, customer.cnm, product.pid, product.pnm
FROM customer, product;

-- SUBQUERY : 쿼리 안에 다른 쿼리가 들어가 있는 경우
-- SUBQUERY가 사용된 위치에 따라 3가지로 분류
-- SELECT 절 : SCALA SUBQUERY : 하나의 행, 하나의 컬럼만 리턴하여 에러가 발생하지 않음
-- FROM 절 : INLINE - VIEW (VIEW)
-- WHERE 절 : SUBQUERY QUERY

-- SMITH가 속한 부서에 속하는 직원들의 정보를 조회
-- 1. SMITH가 속하는 부서 번호를 구한다.
-- 2. 1번에서 구한 부서 번호에 직원들 정보를 조회한다.


-- 1
SELECT deptno
FROM emp
WHERE ename = 'SMITH';

-- 1에서 구한 부서번호를 이용하여 해당 부서에 속하는 직원 정보를 조회
SELECT *
FROM emp
WHERE deptno = 10;

-- SUBQUERY를 이용하면 두개의 쿼리를 동시에 하나의 SQL로 실행이 가능
SELECT *
FROM emp
WHERE deptno = ( SELECT deptno
                 FROM emp
                 WHERE ename = 'SMITH');
                 
-- 평균 급여보다 높은 급여를 받는 직원의 수를 조회하세요
SELECT COUNT(*)
FROM emp
WHERE sal > ( SELECT AVG(sal)
              FROM emp );
              
-- 평균 급요보다 높은 급여를 받는 직원의 정보를 조회하세요              
SELECT *
FROM emp
WHERE sal > ( SELECT AVG(sal)
              FROM emp );
              
-- SMITH와 WARD 사원이 속한 부서의 모든 사원 정보를 조회하는 쿼리를 다음과 같이 작성하세요
SELECT *
FROM emp
WHERE deptno IN ( SELECT deptno
                 FROM emp
                 WHERE ename IN ('SMITH', 'WARD'));

-- 다중행 연산자
-- IN : 서브 쿼리의 여러행 중 일치하는 값이 존재할 때
-- ANY (활용도는 다소 떨어짐) : 서브쿼리의 여러행 중 한 행이라도 조건을 만족할 때
-- ALL (활용도는 다소 떨어짐) : 서브쿼리의 여러행 중 모든 행에 대해 조건을 만족할 때

-- SMITH가 속하는 부서의 모든 직원을 조회
SELECT deptno
FROM emp
WHERE ename = 'SMITH' OR ename = 'WARD';

SELECT *
FROM emp
WHERE deptno IN (20, 30);

-- SMITH와 WARD 직원이 속하는 부서의 모든 직원을 조회
SELECT *
FROM emp
WHERE deptno IN ( SELECT deptno
                 FROM emp
                 WHERE ename IN ('SMITH', 'WARD'));

-- 서브 쿼리의 결과가 여러 행일 때는  = 연산자를 사용하지 못한다.

-- SMITH, WARD 사원의 급여보다 급여가 작은 직원을 조회(SMITH, WARD의 급여 중 아무거나)
SELECT *
FROM emp
WHERE ename IN ('SMITH', 'WARD');

SELECT *
FROM emp
WHERE sal < ANY (800, 1250);

SELECT *
FROM emp
WHERE sal < ANY ( SELECT sal
                  FROM emp
                  WHERE ename IN ('SMITH', 'WARD'));
                  
-- SMITH, WARD 사원의 급여보다 급여가 높은 직원을 조회(SMITH, WARD의 급여 2가지 모두에 대해 높을 때)                  
SELECT *
FROM emp
WHERE sal > ALL ( SELECT sal
                  FROM emp
                  WHERE ename IN ('SMITH', 'WARD'));

-- IN, NOT IN의 NULL과 관련된 유의사항
-- 직원의 관리자 사번이 7902이거나(OR) NULL
SELECT *
FROM emp
WHERE mgr IN (7902, null);

-- NULL 비교는 = 연산자가 아니라 IS NULL로 비교해야 하지만 IN 연산자는 =로 계산한다.
SELECT *
FROM emp
WHERE mgr = 7902
OR mgr = null;

SELECT *
FROM emp
WHERE mgr = 7902
OR mgr IS null;

-- empno NOT IN (7902, NULL) ==> AND
-- 사원 번호가 7902가 아니면서 NULL이 아닌 데이터
SELECT *
FROM emp
WHERE mgr NOT IN (7902, null);

SELECT *
FROM emp
WHERE mgr != 7902
AND mgr != NULL;

SELECT *
FROM emp
WHERE mgr != 7902
AND mgr IS NOT NULL;

-- pairwise (순서쌍)
-- 순서쌍의 결과를 동시에 만족 시킬 때
SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499, 7782));
                        
-- nor-pairwise는 순서쌍을 동시에 만족시키지 않는 형태로 작성
-- mgr 값이 7698이거나 7839 이면서
-- deptno가 10이거나 30번인 직원
-- MGR, DEPTNO
-- (7698, 10), (7698, 30)
-- (7839, 10), (7839, 30)
SELECT *
FROM emp
WHERE mgr IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499, 7782))
AND deptno IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499, 7782));

-- SCALA SUBQUERY : SELECT 절에 기술, 1개의 ROW, 1개의 COL을 조회하는 쿼리
-- SCALA SUBQUERY는 MAIN 쿼리의 컬럼을 사용하는게 가능하다.
SELECT (SELECT SYSDATE
        FROM dual), dept.*
FROM dept;

SELECT emp.empno, emp.ename, deptno, 
      (SELECT dname FROM dept WHERE deptno = emp.deptno) dname
FROM emp;

-- INLINE VIEW : FROM 절에 기술되는 서브쿼리;

-- MAIN 쿼리의 컬럼을 SUBQUERY에서 사용하는 지 유무에 따른 분류
-- 사용할 경우 : CORRELATED SUBQUERY (상호 연관 쿼리), 서브 쿼리만 단독으로 실행하는게 불가능
--             실행순서가 정해져있다 (main ==> sub)
-- 사용하지 않을 경우 : NON-CORRELATED SUBQUERY(비상호 연관 서브쿼리), 서브쿼리만 단독으로 실행하는게 가능
--                   실행순서가 정해져 있지 않다 (main ==> sub, sub ==> main)

-- 모든 직원의 급여 평균보다 급여가 높은 사람을 조회
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);
             
-- 직원이 속한 부서의 급여 평균보다 급여가 높은 사람을 조회
SELECT *
FROM emp m
WHERE sal > (SELECT AVG(sal)
             FROM emp s
             WHERE s.deptno = m.deptno);
             
-- 위의 문제를 조인을 이용해서 풀어보자
-- 1. 조인 테이블 선정
-- emp, 부서별 급여 평균(inline view)
SELECT emp.ename, sal, emp.deptno, dept_sal.*
FROM emp, (SELECT deptno, ROUND(AVG(sal)) avg_sal
           FROM emp
           GROUP BY deptno) dept_sal
WHERE emp.deptno = dept_sal.deptno
AND emp.sal > dept_sal.avg_sal;

-- dept 테이블에는 신규 등록된 99번 부서에 속한 사람은 없음
-- 직원이 속하지 않은 부서를 조회하는 쿼리를 작성해보세요.
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
-- ROLLBACK : 트랜잭션 취소
-- COMMIT : 트랜잭션 확정

DELETE dept
WHERE deptno = 99;

COMMIT;

-- 상호연관
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                     FROM emp
                     WHERE emp.deptno = dept.deptno)
ORDER BY deptno DESC;

-- 비상호연관


-- cycle, product 테이블을 이용하여 cid = 1인 고객이 애음하지 않는 제품을 조회하는 쿼리를 작성하세요
SELECT pid, pnm
FROM product
WHERE pid NOT IN (SELECT pid
                  FROM cycle
                  WHERE cycle.cid = 1);
                  
SELECT *
FROM product;

SELECT *
FROM cycle;

-- cycle 테이블을 이용하여 cid = 2인 고객이 애음하는 제품 중 cid = 1인 고객도 애음하는 제품의 애음정보를 조회하는 쿼리를 작성하세요


-- customer, cycle, product 테이블을 이용하여 cid = 2인 고객이 애음하는 제품 중 cid = 1인 고객도 애음하는 제품의 정보를 조회하고 고객명과 제품명까지
-- 포함하는 쿼리를 작성하세요

