-- 제약조건 확인 방법
-- 1. tool
-- 2. dictionary view
-- 제약조건 : USER_CONSTRAINTS
-- 제약조건-컬럼 : USER_CONS_COLUMNS
-- 제약조건이 몇개의 컬럼에 관련되어 있는지 알 수 없기 때문에 테이블을 별도록 분리하여 설계
-- 제1정규형

SELECT *
FROM USER_CONSTRAINTS
WHERE table_name IN ('EMP', 'DEPT', 'EMP_TEST', 'DEPT_TEST');

-- EMP, DEPT에 PK, FK 제약이 존재하지 않음
-- 2. EMP : pk(empno)
-- 3.       fk(deptno) - dept.deptno
--          (fk 제약을 생성하기 위해서는 참조하는 테이블 컬럼에 인덱스가 존재해야 한다.

-- 1. dept : pk (deptno)
ALTER TABLE EMP ADD CONSTRAINT pk_emp PRIMARY KEY(empno);
ALTER TABLE EMP ADD CONSTRAINT fk_emp FOREIGN KEY (deptno) REFERENCES dept (deptno);
ALTER TABLE dept ADD CONSTRAINT pk__dept PRIMARY KEY(deptno);

-- 테이블, 컬럼 주석 : DICTIONARY 확인 가능
-- 테이블 주석 : USER_TAB_COMMENTS
-- 컬럼 주석 : USER_COL_COMMENTS

-- 주석 생성
-- 테이블 주석 : COMMENT ON TABLE 테이블명 IS '주석';
-- 컬럼 주석 : COMMENT ON TABLE 테이블명.컬럼 IS '주석';

-- emp : 직원
-- dept : 부서

COMMENT ON TABLE emp IS '직원';
COMMENT ON TABLE dept IS '부서';

SELECT *
FROM member;

SELECT *
FROM USER_TAB_COMMENTS
WHERE TABLE_NAME IN ('EMP','DEPT');

SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME IN ('EMP','DEPT');

/*
DEPT	DEPTNO : 부서번호
DEPT	DNAME : 부서명
DEPT	LOC : 부서위치
EMP	    EMPNO : 직원번호
EMP	    ENAME : 직원이름
EMP	    JOB : 담당업무
EMP	    MGR : 매니저 직원번호
EMP	    HIREDATE : 입사일자
EMP	    SAL : 급여
EMP	    COMM : 성과급
EMP	    DEPTNO : 소속부서번호;
*/

COMMENT ON COLUMN dept.deptno IS '부서번호';
COMMENT ON COLUMN dept.dname IS '부서명';
COMMENT ON COLUMN dept.loc IS '부서위치';

COMMENT ON COLUMN emp.empno IS '직원번호';
COMMENT ON COLUMN emp.ename IS '직원이름';
COMMENT ON COLUMN emp.job IS '담당업무';
COMMENT ON COLUMN emp.mgr IS '매니저 직원번호';
COMMENT ON COLUMN emp.hiredate IS '입사일자';
COMMENT ON COLUMN emp.sal IS '급여';
COMMENT ON COLUMN emp.comm IS '성과급';
COMMENT ON COLUMN emp.deptno IS '소속부서번호';


-- user_tab_comments, user_col_comments view를 이용하여 customer, product, cycle, daily 테이블과 컬럼의 주석 정보를 조회하는 쿼리를 작성하라
SELECT b.table_name, table_type, b.comments tab_comment, column_name, a.comments col_comment
FROM user_col_comments a, user_tab_comments b
WHERE a.table_name = b.table_name AND a.table_name IN ('CYCLE','PRODUCT','CUSTOMER','DAILY');


-- VIEW = QUERY
-- TABLE 커럼 DBMS에 미리 작성한 객체
-- ==> 작성하지 않고 QUERY에서 바로 작성한 VIEW : INLINE-VIEW ==> 이름이 없기 때문에 재활용이 불가
-- VIEW는 테이블이다 (X)

-- 사용목적
-- 1. 보안 목적(특정 컬럼을 제외하고 나머지 결과만 개발자에 제공)
-- 2. INLINE-VIEW를 VIEW로 생성하여 재활용
--      쿼리 길이 단축

-- 생성 방법
-- CREATE (OR PEPLACE) VIEW 뷰명칭 [ (column1, column2, ...) ] AS
-- SUBQUERY;

-- emp 테이블에서 8개의 컬럼 중 sal, comm 컬럼을 제외한 6개 컬럼을 제공하는 v_emp VIEW 생성
CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

-- 시스템 계정에서 OCK 계정으로 VIEW 생성권한 추가
GRANT CREATE VIEW TO OCK;

-- 기존 인라인 뷰로 작성시
SELECT *
FROM (SELECT empno, ename, job, mgr, hiredate, deptno
      FROM emp);
      
-- VIEW 객체 활용
SELECT *
FROM v_emp;

-- emp 테이블에는 부서명이 없음 ==> dept 테이블과 조인을 빈번하게 사용
-- 조인된 결과를 view로 생성해놓으면 코드를 간결하게 작성하는게 가능

-- VIEW : v_emp_dept
-- dname(부서명), empno(직원번호), ename(직원이름), job(담당업부), hiredate(입사일자)

CREATE OR REPLACE VIEW v_emp_dept AS
SELECT DEPT.DNAME, emp.empno, emp.ename, emp.job, emp.hiredate
FROM dept, emp
WHERE emp.deptno = dept.deptno;

-- 인라인 뷰로 작성시
SELECT *
FROM (SELECT DEPT.DNAME, emp.empno, emp.ename, emp.job, emp.hiredate
      FROM dept, emp
      WHERE emp.deptno = dept.deptno);

-- VIEW 활용시
SELECT *
FROM v_emp_dept;

-- SMITH 직원 삭제 후 v_emp_dept view 건수 변화를 확인
DELETE emp
WHERE ename = 'SMITH';


-- VIEW는 물리적인 데이터를 갖지 않고, 논리적인 데이터릐 정의 집합(SQL)이기 때문에 VIEW에서 참조하는 테이블의 데이터가 변경이 되면 VIEW의 결과도 영향을 받는다.
ROLLBACK;

-- SEQUENCE : 시퀀스 - 중복되지 않는 정수값을 리턴해주는 오라클 객체
-- CREATE SEQUENCE 시퀀스_이름
-- [OPTION ...]
-- 명명규칙 : 테이블명;

-- emp 테이블에서 사용할 시퀀스 생성
CREATE SEQUENCE seq_emp;

-- 시퀀스 제공 함수
-- NEXTVAL : 시퀀스에서 다음 값을 가져올 때 사용
-- CURRVAL : NEXTVAL을 사용하고 나서 현재 읽어들인 값을 재확인

-- 시퀀스 주의점
-- ROLLBAVK을 하더라도 NEXTVAL를 통해 얻은 값이 다시 복원되진 않는다.
-- NEXTVAL를 통해 값을 받아오면 그 값을 다시 사용할 수 없다.

SELECT seq_emp.NEXTVAL
FROM dual;

SELECT seq_emp.CURRVAL
FROM dual;

SELECT *
FROM emp_test;

INSERT INTO emp_test VALUES (seq_emp.NEXTVAL, 'james', 99);

-- INDEX
SELECT ROWID, emp.*
FROM emp;

SELECT *
FROM emp
WHERE ROWID = 'AAAE5gAAFAAAACLAAI';

-- 인덱스가 없을때 empno 값으로 조회하는 경우
-- emp 테이블에서 pk_emp 제약조건을 삭제하여 empno 컬럼으로 인덱스가 존재하지 않는 환경을 조성

ALTER TABLE emp DROP CONSTRAINT pk_emp;

explain plan for
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);


-- emp 테이블의 empno 컬럼으로 PK 제약을 생성하고 동일한 SQL을 실행
-- PK : UNIQUE + NOT NULL
--      (UNIQUE 인덱스를 생성해준다)
-- ==> empno 커럼으로 unique 인덱스가 생성됨

-- 인덱스로 SQL을 실행하게 되면 인덱스가 없을 때와 어떻게 다른지 차이점을 확인

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);

SELECT rowid, emp.*
FROM emp;

SELECT empno, rowid
FROM emp
ORDER BY empno;

explain plan for
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

explain plan for
SELECT *
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

-- SELECT 조회컬럼이 테이블 접근에 미치는 영향
-- SELECT * FROM emp WHERE empno = 7782 ==> SELECT empno FROM emp WHERE empno = 7782

explain plan for
select empno
from emp
where empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

-- UNIQUE VS NON-UNIQUE 인덱스의 차이 확인
-- 1. pk_emp 삭제
-- 2. empno 컬럼으로 NON_UNIQUE 인덱스 생성
-- 3. 실행계획 확인

alter table emp drop CONSTRAINT pk_emp;
CREATE INDEX idx_n_emp_01 ON emp (empno);

explain plan for
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

-- emp 테이블에 job 컬럼을 기준으로 하는 새로운 NON_UNIQUE 인덱스를 생성
CREATE INDEX idx_n_emp_02 ON emp (job);

SELECT rowid, job
from emp
order by job;

-- 선택가능한 사항
-- 1. emp 테이블을 전체 읽기
-- 2. idx_n_emp_01 인덱스 활용
-- 3. idx_n_emp_02 인덱스 활용

explain plan for
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY)