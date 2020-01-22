-- PROD 테이블의 모든 컬럼의 자료 조회
SELECT *
FROM PROD;

-- PROD 테이블에서 PROD_ID, PROD_NAME 컬럼의 자료만 조회
SELECT PROD_ID, PROD_NAME
FROM PROD;

-- RROD 테이블에서 PROD_PRICE 컬럼의 자료만 조회
SELECT PROD_PRICE
FROM PROD;

-- PROD 테이블에서 PROD_NAME 컬럼의 자료만 조회
SELECT PROD_NAME
FROM PROD;

--lprod 테이블에서 모든 데이터를 조회하는 쿼리를 작성하세요
SELECT *
FROM lprod;

--buyer 테이블에서 buyer_id, buyer_name 컬럼만 조회하는 쿼리를 작성하세요
SELECT buyer_id, buyer_name
FROM buyer;

--cart 테이블에서 모든 데이터를 조회하는 쿼리를 작성하세요
SELECT *
FROM cart;

--member 테이블에서 mem_id, mem_pass, mem_name 컬럼만 조회하는 쿼리를 작성하세요
SELECT mem_id, mem_pass, mem_name
FROM member;





-- users 테이블 조회
SELECT *
FROM users;

-- 테이블에 어떤 컬럼이 있는지 확인하는 방법
-- 1. SELECT *
-- 2. TOOL의 기능 (사용자-TABLES)
-- 3. DESC 테미블명 (DESC-DESCRIBE)

DESC users;

SELECT userid
FROM users;

-- users 테이블에서 userid, usernm, reg_dt 컬럼만 조회하는 sql을 작성하세요
-- 날짜 연상 (reg_dt 컬럼은 data정보를 담을 수 있는 타입)
-- 날짜컬럼 +(더하기 연산)
-- 수학적인 사칙연산이 아닌 것들(5+5)
-- String h = "hello";
-- String w = "world"
-- String hw = h+w; -- 자바에서는 두 문자열을 결합
-- sql에서 정의된 날짜 연산 : 날짜 + 정수 = 날짜에서 정수를 일자로 취급하여 더한 날짜가 된다
-- (2019/01/28 + 5 = 2019/02/02)
-- reg_dt : 등록일자 컬럼
-- null : 값을 모르는 상태
-- null에 대한 연산 결과는 항상 null
SELECT userid u_id, usernm, reg_dt, reg_dt + 5 AS reg_dt_after_5DAY
FROM users;

DESC users;

--String msg = ""; //공백문자
--String  = null; //

--prod 테이블에서 prod_id, prod_name 두 컬럼을 조회하는 쿼리를 작성하시오
--(단 prod_id -> id, prod_name -> name으로 컬럼 별칭을 지정)
SELECT prod_id id, prod_name name
FROM prod;

--lprod 테이블에서 lprod_gu, lprod_nm 두 컬럼을 조회하는 쿼리를 작성하시오
--(단 lrpod_gu -> gu, lprod_nm -> nm으로 컬럼 별칭을 지정)
SELECT lprod_gu gu, lprod_nm nm
FROM lprod;

--buyer 테이블에서 buyer_id,buyer_name 두 컬럼을 조회하는 쿼리를 작성하시오
--(단 buyer_id -> 바이어아이디, buyer_name -> 이름으로 컬럼 별칭을 지정)
SELECT buyer_id 바이어아이디, buyer_name 이름
FROM buyer;

--문자열 결합
-- 자바 언어에서 문자열 결합 : + ("Hello" + "world")
-- SQL에서는 : || ('Hello' || 'world')
-- SQL에서는 : concat('Hello', 'world')

-- userid, usernm 컬럼을 결합, 별칭 id_name
SELECT userid || usernm AS id_name
FROM users;

SELECT concat(userid, usernm) AS id_name
FROM users;

-- 변수, 상수
-- int a = 5; String msg = "HelloWorld";
-- System.out.println(msg);  //변수를 이용한 출력
-- System.out.println("Hello, World");  //상수를 이용한 출력