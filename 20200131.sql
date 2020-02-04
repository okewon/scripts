-- 올해 년도의 짝수 구분과, REF_DT 년도의 짝수 구분이 동일하면 --> 건강검진 대상자
-- 올해 년도의 짝수 구분과, REF_DT 년도의 짝수 구분이 동일하지 않으면 --> 건강검진 비대상자

SELECT ename, deptno
FROM emp;

SELECT *
FROM dept;

-- JOIN : 두 테이블을 연결하는 작업
-- JOIN 문법
-- 1. ANSI 문법
-- 2. ORACLE 문법

-- Natural Join
-- 두 테이블간 컬럼명이 같을 때 해당 컬럼으로 연결(조인)
-- emp, dept 테이블에는 deptno라는 컬럼이 존재

SELECT *
FROM emp NATURAL JOIN dept;

-- Natural Join에 사용된 조인 컬럼(deptno)는 한정자(ex: 테이블명, 테이블 별칭)을 사용하지 않고
-- 컬럼명만 기술한다 ( dept.deptno --> deptno )
SELECT emp.empno, emp.ename, dept.dname, deptno
FROM emp NATURAL JOIN dept;

-- 테이블에 대한 별칭도 사용가능
SELECT e.empno, e.ename, d.dname, deptno
FROM emp e NATURAL JOIN dept d;

-- ORACLE JOIN
-- FROM 절에 조인할 테이블 목록을 ,로 구분하여 나열한다
-- 조인할 테이블의 연결 조건을 WHERE절에 기술한다
-- emp, dept 테이블에 존재하는 deptno 컬럼이 (같을 때) 조인
SELECT emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno != dept.deptno;

-- 오라클 조인의 테이블 별칭
SELECT e.empno, e.dname, d.dname, e.deptno
FROM emp e, dept d
WHERE e.deptno = d.deptno;

-- ANSI : join with USING
-- 조인하려는 두개의 테이블에 이름이 같은 컬럼이 두개이지만 하나의 컬럼으로만 조인하고자할 때 조인하려는 기준 컬럼을 기술;
-- emp, dept 테이블의 공통 컬럼 : deptno;
SELECT emp.ename, dept.dname, deptno
FROM emp JOIN dept USING(deptno);

-- JOIN WHIT USING을 ORACLE로 표현한다면?
SELECT emp.ename, dept.dname, emp.deptno
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- ANSI : JOIN WITH ON
-- 조인하려고 하는 테이블의 컬럼 이름이 서로 다를때
SELECT emp.ename, dept.dname, emp.deptno
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

-- JOIN WHIT ON --> ORACLE
SELECT emp.ename, dept.dname, emp.deptno
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- SELF JOIN : 같은 테이블간의 조인;
-- 예 : emp 테이블에서 관리되는 사원의 관리자 사번을 이용하여 관리자 이름을 조회할 때; 
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno) ;

-- 오라클 문법으로 작성;
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

-- equal 조인 : =
-- non - equal 조인 : !=, >, <, BETWEEN AND;

SELECT ename, sal
FROM emp;

SELECT *
FROM salgrade;

-- 사원의 급여 정보와 급여 등급 테이블을 이용하여 해당사원의 급여 등급을 구해보자;
-- ANSI 문법을 이용하여 조인 문을 작성;
SELECT emp.ename, emp.sal, salgrade.grade
FROM emp JOIN salgrade ON(emp.sal BETWEEN losal AND hisal);

-- 오라클 문법을 이용하여 조인 문을 작성;
SELECT emp.ename, emp.sal, salgrade.grade
FROM emp, salgrade
WHERE emp.sal BETWEEN losal AND hisal;

-- emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하에요
SELECT emp.empno, emp.ename, deptno, dept.dname
FROM emp NATURAL JOIN dept
ORDER BY deptno;

-- emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요
-- (부서번호가 10, 30인 데이터만 조회)
SELECT emp.empno, emp.ename, dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno AND dept.deptno IN(10, 30);

-- emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요
-- (급여가 2500초과)
SELECT emp.empno, emp.ename, emp.sal, dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno AND emp.sal > 2500
ORDER BY dept.deptno; 

-- emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요
-- (급여가 2500초과, 사번이 7600보다 큰 직원)
SELECT emp.empno, emp.ename, emp.sal, dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno AND emp.sal > 2500 AND emp.empno > 7600
ORDER BY dept.deptno; 


-- emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하에요
-- (급여가 2500초과, 사번이 7600보다 큰고 부서명이 RESEARCH인 부서에 속한 직원)
SELECT emp.empno, emp.ename, emp.sal, dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno AND emp.sal > 2500 AND emp.empno > 7600 AND dept.dname = 'RESEARCH'
ORDER BY dept.deptno; 

-- PROD : PROD_LGU
-- LPROD : LPROD

-- erd 다이어그램을 참고하여 prod 테이블과 lprod 테이블을 조인하여 다음과 같은 결과가 나오는 쿼리를 작성해보세요
SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM lprod, prod
WHERE prod.prod_LGU = lprod.lprod_gu;

-- erd 다이어그램을 참고하여 buyer, prod 테이블을 조인하여 buyer별 담당하는 제품 정보를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer, prod
WHERE prod.prod_buyer = buyer.buyer_id
ORDER BY buyer.buyer_id;

-- erd 다이어그램을 참고하여 member, cart, prod 테이블을 조인하여 회원별 장바구니에 담은 제품 정보를 다음과 같은 결과가 나오는 쿼리를 작성해보세요
SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
FROM member, prod, cart
WHERE member.mem_id = cart.cart_member AND cart.cart_prod = prod.prod_id;

-- ANSI 문법
SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
FROM member JOIN cart ON (member.mem_id = cart.cart_member) JOIN prod ON cart.cart_prod = prod.prod_id;

-- erd 다이어그램을 참고하여 customer, cycle 테이블을 조인하여 고객별 애음 제품, 애음요일, 개수를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요
-- (고객명이 brown, sally인 고객만 조회)
-- (*정렬과 관계없이 값이 맞으면 정답)
SELECT customer.cid, customer.cnm, cycle.pid, cycle.day, cycle.cnt
FROM customer, cycle
WHERE customer.cid = cycle.pid;

-- erd 다이어그램을 참고하여 customer, cycle, product 테이블을 조인하여 고객별 애음 제품, 애음요일, 개수를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요
-- (고객명이 brown, sally인 고객만 조회)
-- (*정렬과 관계없이 값이 맞으면 정답)


-- erd 다이어그램을 참고하여 customer, cycle, product 테이블을 조인하여 애음요일과 관계없이 고객별 애음 제품, 개수를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요
-- (고객명이 brown, sally인 고객만 조회)
-- (*정렬과 관계없이 값이 맞으면 정답)


-- erd 다이어그램을 참고하여 cycle, product 테이블을 이용하여 제품별 개수의 합과 제품명을 다음과 같은 결과가 나오도록 쿼리를 작성해보세요
-- (*정렬과 관계없이 값이 맞으면 정답)


