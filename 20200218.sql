SELECT dept_h.*, level, lpad(' ',(level-1)*4, ' ') || deptnm
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;

-- 상향식 계층쿼리 : leaf ==> root node(상위 node)
-- 전체 노드를 방문하는게 아니라 자신의 부모노드만 방문 (하향식과 다른점)
-- 시작점 : 디자인팀
-- 연결은 : 상위부서

select dept_h.*, level, lpad(' ', (level - 1) * 4) || deptnm
from dept_h
start with deptnm = '디자인팀'
connect by prior p_deptcd = deptcd;

select *
from h_sum;

-- 계층형쿼리 복습.sql을 이용하여 테이블을 생성하고 다음과 같은 결과가 나오도록 쿼리를 작성하세요
select lpad(' ', (level - 1) * 4) || s_id s_id, value
from h_sum
start with s_id = 0
connect by prior s_id = ps_id;

-- 계층형쿼리 스크립트.sql을 이용하여 테이블을 생성하고 다음과 같은 결과가 나오도록 쿼리를 작성하세요
select lpad(' ', (level - 1) * 4) || org_cd org_cd, no_emp
from no_emp
start with org_cd = 'XX회사'
connect by prior org_cd = parent_org_cd;

-- 계층형 쿼리의 행 제한 조건 기술 위치에 따른 결과 비교 (plumping branch - 가지치기)
-- from ==> start with, connect by ==> where
-- 1. where : 계층 연결을 하고 나서 행을 제한
-- 2. connect by : 계층 연결을 하는 과정에서 행을 제한


-- where절 기술 전 : 총 9개의 행이 조회되는 것 확인
-- where절 (deptnm != '정보기획부') : 정보기획부를 제외한 8개의 행 조회되는 것 확인

select lpad(' ', (level - 1) * 4) || org_cd org_cd, no_emp
from no_emp
where org_cd != '정보기획부'
start with org_cd = 'XX회사'
connect by prior org_cd = parent_org_cd;

-- connect by 절에 조건을 기술
select lpad(' ', (level - 1) * 4) || org_cd org_cd, no_emp
from no_emp
start with org_cd = 'XX회사'
connect by prior org_cd = parent_org_cd and org_cd != '정보기획부';

-- connect_by_root(컬럼) : 해당 컬럼의 최상위 행의 값을 반환
-- sys_connect_by_path(컬럼, 구분자) : 해당 행의 컬럼이 거쳐온 컬럼 값을 추천, 구분자로 이어준다
-- connect_by_isleaf : 해당 행이 leaf 노드인지(연결된 자식이 없는지) 값을 리턴 (1:leaf, 0:no leaf)

select lpad(' ', (level - 1) * 4) || org_cd org_cd, no_emp,
       connect_by_root(org_cd) root,
       ltrim(sys_connect_by_path(org_cd, '-'), '-') path,
       connect_by_isleaf leaf
from no_emp
start with org_cd = 'XX회사'
connect by prior org_cd = parent_org_cd;

-- 게시글을 저장하는 board_test 테이블을 이용하여 계층 쿼리를 작성하세요
select level, board_test.*
from board_test
start with parent_seq is null
connect by prior seq = parent_seq
order siblings by seq desc;
desc board_test;

select seq, lpad(' ', (level - 1) * 4) || title title
from board_test
start with parent_seq is null
connect by prior seq = parent_seq;

-- 게시글은 가장 최신글이 최상위로 온다. 가장 최신글이 오도록 정렬하시오
select seq, lpad(' ', (level - 1) * 4) || title title
from board_test
start with parent_seq is null
connect by prior seq = parent_seq
ORDER by seq desc;

-- 게시글은 가장 최신글이 최상위로 온다. 가장 최신글이 오도록 정렬하시오
select seq, lpad(' ', (level - 1) * 4) || title title
from board_test
start with parent_seq is null
connect by prior seq = parent_seq
ORDER siblings by seq desc;

-- 게시글은 가장 최신글이 최상위로 온다. 가장 최신글이 오도록 정렬하시오
select seq, lpad(' ', (level - 1) * 4) || title title
from board_test
start with parent_seq is null
connect by prior seq = parent_seq
ORDER siblings by gn desc, seq asc;

alter table board_test add(gn number);

update board_test set gn = 4
where seq IN (4, 5, 6, 7, 8, 10, 11);

update board_test set gn = 2
where seq IN (2, 3);

update board_test set gn = 1
where seq IN (1, 9);

select *
from emp
order by deptno desc, empno asc;

select *
from emp
where sal = (select max(sal)
             from emp);
          
select b.*, rownum sal_rank
from(
    select ename, sal, deptno
    from emp
    where deptno = 10
    order by sal desc) b
    
union all

select b.*, rownum sal_rank
from(
    select ename, sal, deptno
    from emp
    where deptno = 20
    order by sal desc) b
    
union all

select b.*, rownum sal_rank
from(
    select ename, sal, deptno
    from emp
    where deptno = 30
    order by sal desc) b;    

select ename, sal, deptno,
       row_number() over (partition by deptno order by sal desc) sal_rank
from emp;

select *
from (select level lv
      from dual
      connect by level <= 14) a,
      
      (select deptno, count(*) cnt
      from emp
      group by deptno) b
where b.cnt >= a.lv
order by b.deptno, a.lv;