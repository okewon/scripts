-- erd 다이어그램을 참고하여 customer, cycle 테이블을 조인하여 고객별 애음 제품, 애음요일, 개수를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요
-- (고객명이 brown, sally인 고객만 조회)
-- (*정렬과 관계없이 값이 맞으면 정답)
SELECT customer.cid, customer.cnm, cycle.pid, cycle.day, cycle.cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid;

-- erd 다이어그램을 참고하여 customer, cycle, product 테이블을 조인하여 고객별 애음 제품, 애음요일, 개수를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요
-- (고객명이 brown, sally인 고객만 조회)
-- (*정렬과 관계없이 값이 맞으면 정답)
SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid AND cycle.pid = product.pid AND cnm IN('brown', 'sally');

-- erd 다이어그램을 참고하여 customer, cycle, product 테이블을 조인하여 애음요일과 관계없이 고객별 애음 제품, 개수를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요
-- (고객명이 brown, sally인 고객만 조회)
-- (*정렬과 관계없이 값이 맞으면 정답)
SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, COUNT(product.pnm) cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid AND cycle.pid = product.pid
GROUP BY customer.cid, customer.cnm, cycle.pid, product.pnm;

-- erd 다이어그램을 참고하여 cycle, product 테이블을 이용하여 제품별 개수의 합과 제품명을 다음과 같은 결과가 나오도록 쿼리를 작성해보세요
-- (*정렬과 관계없이 값이 맞으면 정답)
SELECT cycle.pid, product.pnm, COUNT(product.pnm)
FROM cycle, product
WHERE cycle.pid = product.pid
GROUP BY cycle.pid, product.pnm
ORDER BY product.pnm;

SELECT *
FROM dba_users;

ALTER USER HR IDENTIFIED BY java;
ALTER USER HR ACCOUNT UNLOCK;

-- OUTER JOIN
-- 두 테이블을 조인할 때 연결 조건을 만족시키지 못하는 데이터를 기준으로 지정한 테이블의 데이터만이라도
-- 조회 되게끔 하는 조인 방식

-- 연결 조건 : e.mgr = m.empno : KING의 MGR이 NULL이기 때문에 조인에 실패한다.
-- emp 테이블의 데이터는 총 14건이지만 아래와 같은 쿼리에서는 결과가 15건이 된다.(1건이 조인실패)
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

-- ANSI OUTER
-- 1. 조인에 실패하더라도 조회가 될 테이블을 선정 (매니저 정보가 없어도 사원정보는 나오게끔)
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e LEFT OUTER JOIN emp m ON e.mgr = m.empno;

-- RIGHT OUTER로 변경
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp m RIGHT OUTER JOIN emp e ON e.mgr = m.empno;

-- ORACLE OUTER JOIN
-- 데이터가 없는 쪽의 테이블 컬럼 뒤에 (+)기호를 붙여준다
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.empno = m.empno(+);

SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.empno = m.empno(+);

-- 위의 SQL을 ANSI SQL(OUTER JOIN)으로 변경해보세요
-- 매니저의 부서 번호가 10번인 직원만 조회
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno AND m.deptno = 10);


-- 아래 LEFT OUTER 조인은 실질적으로 OUTER 조인이 아니다.
-- 아래 INNER 조인과 결과가 똑같다.
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON e.mgr = m.empno
WHERE m.deptno = 10;

SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e JOIN emp m ON e.mgr = m.empno
WHERE m.deptno = 10;

-- ORACLE OUTER JOIN
-- ORACLE OUTER JOIN시 기준 테이블의 반대편 테이블의 모든 컬럼에 (+)를 붙여야 정상적인 OUTER JOIN으로 동작한다.
-- 한 컬럼이라도 (+)fmf snfkrgkaus INNER 조인으로 동작

-- 아래 ORACLE OUTER JOIN은 INNER 조인으로 동작 : m.deptno 컬럼에 (+)r가 붙지 않음
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+) AND m.deptno = 10;

SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+) AND m.deptno(+) = 10;

-- 사원 - 매니저간 RIGHT OUTER JOIN
SELECT empno, ename, mgr
FROM emp e;
 
SELECT empno, ename, mgr
FROM emp m;

SELECT e.empno, e.ename, e.mgr, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno);

-- FULL OUTER : LEFT OUTER + RIGHT OUTER - 중복 제거
-- LEFT OUTER : 14건, RIGHT OUTER : 21건, FULL OUTER : 22건
SELECT e.empno, e.ename, e.mgr, m.empno, m.ename
FROM emp e FULL  OUTER JOIN emp m ON (e.mgr = m.empno);

-- ORACLE JOIN에서는 (+)으로 FULL OUTER을 지원하지 않는다.

-- buyprod, prod테이블에 구매일자가 2005년 1월 25일인 데이터는 3품목 밖에 없다.
-- 모든 품목이 나올 수 있도록 쿼리를 작성해보세요
SELECT buyprod.buy_date, buyprod.buy_prod, prod.prod_id, prod.prod_name, buyprod.buy_qty
FROM buyprod RIGHT OUTER JOIN prod ON (buyprod.buy_prod = prod.prod_id AND buyprod.buy_date = TO_DATE('2005-01-25', 'YYYY-MM-DD')); 

SELECT buyprod.buy_date, buyprod.buy_prod, prod.prod_id, prod.prod_name, buyprod.buy_qty
FROM buyprod, prod
WHERE prod.prod_id = buyprod.buy_prod(+)
AND buyprod.buy_date(+) = TO_DATE('20050125', 'YYYYMMDD');

SELECT *
FROM buyprod;

SELECT *
FROM prod;

-- outer join1에서 작업을 시작하세요. buy_date 컬럼이 null인 항목이 안나오도록 다음처럼 데이터를 채워지도록 쿼리를 작성하세요.
SELECT NVL(buyprod.buy_date, TO_DATE('2005-01-25', 'YYYY-MM-DD')), buyprod.buy_prod, prod.prod_id, prod.prod_name, buyprod.buy_qty
FROM prod LEFT OUTER JOIN buyprod ON (buyprod.buy_prod = prod.prod_id AND buyprod.buy_date = TO_DATE('2005-01-25', 'YYYY-MM-DD')); 

-- outer join2에서 작업을 시작하세요.
-- buy_qty 컬럼이 null일 경우 0으로 보이도록 쿼리를 수정하세요.
SELECT NVL(buyprod.buy_date, TO_DATE('2005-01-25', 'YYYY-MM-DD')), buyprod.buy_prod, prod.prod_id, prod.prod_name, NVL(buyprod.buy_qty, 0)
FROM prod LEFT OUTER JOIN buyprod ON (buyprod.buy_prod = prod.prod_id AND buyprod.buy_date = TO_DATE('2005-01-25', 'YYYY-MM-DD')); 















