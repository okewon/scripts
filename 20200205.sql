-- cycle 테이블을 이용하여 cid = 2인 고객이 애음하는 제품 중 cid = 1인 고객도 애음하는 제품의 애음정보를 조회하는 쿼리를 작성하세요
SELECT DISTINCT cycle.cid, cycle.pid, cycle.day, cycle.cnt
FROM (SELECT pid
      FROM cycle
      WHERE cid = 2) b, cycle
WHERE b.pid = cycle.pid AND cycle.cid = 1
ORDER BY day DESC;

SELECT *
FROM cycle
WHERE cid = 1
AND pid IN (SELECT pid
            FROM cycle
            WHERE cid = 2);

-- customer, cycle, product 테이블을 이용하여 cid = 2인 고객이 애음하는 제품 중 cid = 1인 고객도 애음하는 제품의 정보를 조회하고 고객명과 제품명까지
-- 포함하는 쿼리를 작성하세요
SELECT DISTINCT cycle.cid, customer.cnm, product.pid, product.pnm, cycle.day, cycle.cnt
FROM (SELECT pid
      FROM cycle
      WHERE cid = 2) b, cycle, product, customer
WHERE b.pid = cycle.pid AND cycle.cid = 1 AND product.pid = cycle.pid AND cycle.cid = customer.cid
ORDER BY day DESC;

SELECT cycle.cid, customer.cnm, product.pid, product.pnm, cycle.day, cycle.cnt
FROM cycle, customer, product
WHERE cycle.cid = 1
AND cycle.pid IN (SELECT pid
                  FROM cycle
                  WHERE cid = 2)
AND cycle.cid = customer.cid
AND product.pid = cycle.pid;

-- 매니저가 존재하는 직원을 조회(KING을 제외한 13명의 데이터가 조회)
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- EXISTS 조건에 만족하는 행이 존재하는지 확인하는 연산자
-- 다른 연산자와는 다르게 WHERE 절에 컬럼을 기술하지 않는다
-- WHERE empno = 7739
-- WHERE EXIST (SELECT *
--              FROM .....);

-- 매니저가 존재하는 직원을 EXISTS 연산자를 통해 조회
-- 매니저도 직원
SELECT *
FROM emp e
WHERE EXISTS (SELECT 'X'
              FROM emp m
              WHERE e.mgr = m.empno);
              
SELECT * from product;

-- cycle, product 테이블을 이용하여 cid인 고객이 애음하는 제품을 조회하는 쿼리를 EXISTS 연산자를 사용하여 작성하세요
SELECT *
FROM cycle
WHERE cid = 1;

SELECT *
FROM product
WHERE EXISTS (SELECT 'x'
              FROM cycle
              WHERE cid = 1
              AND cycle.pid = product.pid);
              
-- cycle, product 테이블을 이용하여 cid인 고객이 애음하는 제품을 조회하는 쿼리를 EXISTS 연산자를 사용하여 작성하세요
SELECT *
FROM product
WHERE NOT EXISTS (SELECT *
              FROM cycle
              WHERE cid = 1
              AND cycle.pid = product.pid);              
              
-- 집합 연산
-- 합집합 : UNION - 중복제거(집합개념) / UNION ALL - 중복을 제거하지 않음 (속도 향상)
-- 교집합 : INTERSEC (집합개념)
-- 차집합 : MINUS (집합개념)
-- 집합연산 공통사항
-- 두 집합의 컬럼의 개수, 타입이 일치 해야 한다.

-- 동일한 값을 합집합하기 때문에 중복되는 데이터는 한번만 적용된다

-- UNION
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698)


UNION

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

-- UNION ALL 연산자는 UNION 연산자와 다르게 중복을 허용한다;                    
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698)


UNION ALL

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

-- INTERSECT (교집합) : 위, 아래 집합에서 값이 같은 행만 조회
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)


INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)
;

-- MINUS (차집합) : 위 집합에서 아래 집합의 데이터를 제거한 나머지 집합
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)


MINUS

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

-- 집합의 기술 순서가 영향이 가는 집합 연산자
-- A UNION B         B UNION A ==> 같음
-- A UNION ALL B     B UNION ALL A ==> 같음(집합)
-- A INTERSECT B     B INTERSECT A ==> 같음
-- A MINUS B         B MINUS A ==> 같지 않음

-- 집합 연산의 결과 컬럼 이름은 첫번째 집합의 컬럼명을 따른다
SELECT 'X' first, 'B' second
FROM dual

UNION

SELECT 'Y', 'A'
FROM dual;

-- 정렬(ORDER BY)는 집합 연산 가장 마지막 집합 다음에 기술
SELECT deptno, dname, loc
FROM dept
WHERE deptno IN (10, 20)

UNION

SELECT *
FROM dept
WHERE deptno IN (30, 40)
ORDER BY deptno;

SELECT deptno, dname, loc
FROM (SELECT deptno, dname, loc
      FROM dept
      WHERE deptno IN (10, 20)
      ORDER BY deptno)
      
UNION

SELECT *
FROM dept
WHERE deptno IN (30, 40)
ORDER BY deptno;

-- 햄버거 도시 발전지수

SELECT *
FROM fastfood;

-- 시도, 시군수, 버거지수
SELECT sido, sigungu
FROM fastfood;

-- 시도별 버거킹 개수
SELECT sido, sigungu, COUNT(sigungu) 버거킹
FROM fastfood
WHERE GB = '버거킹'
GROUP BY sido, sigungu;

-- 시도별 맘스터치 개수
SELECT sido, sigungu, COUNT(sigungu) 맘스터치
FROM fastfood
WHERE GB = '맘스터치'
GROUP BY sido, sigungu;

-- 시도별 맥도날드 개수
SELECT sido, sigungu, COUNT(sigungu) 맥도날드
FROM fastfood
WHERE GB = '맥도날드'
GROUP BY sido, sigungu;

-- 시도별 롯데리아 개수
SELECT sido, sigungu, COUNT(sigungu) 롯데리아
FROM fastfood
WHERE GB = '롯데리아'
GROUP BY sido, sigungu;

SELECT b.sido, b.sigungu, ROUND(((b.버거킹 + m.맘스터치 + d.맥도날드) / l.롯데리아),1) 버거지수
FROM (SELECT sido, sigungu, COUNT(sigungu) 버거킹 FROM fastfood WHERE GB = '버거킹' GROUP BY sido, sigungu) b,
     (SELECT sido, sigungu, COUNT(sigungu) 맘스터치 FROM fastfood WHERE GB = '맘스터치' GROUP BY sido, sigungu) m,
     (SELECT sido, sigungu, COUNT(sigungu) 맥도날드 FROM fastfood WHERE GB = '맥도날드' GROUP BY sido, sigungu) d,
     (SELECT sido, sigungu, COUNT(sigungu) 롯데리아 FROM fastfood WHERE GB = '롯데리아' GROUP BY sido, sigungu) l
WHERE (b.sido = m.sido AND b.sigungu(+) = m.sigungu) AND (m.sido = d.sido AND m.sigungu(+) = d.sigungu) AND (d.sido = l.sido AND d.sigungu(+) = l.sigungu) AND (b.sido = l.sido AND b.sigungu = l.sigungu)
ORDER BY 버거지수 DESC;