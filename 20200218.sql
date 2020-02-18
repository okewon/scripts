SELECT dept_h.*, level, lpad(' ',(level-1)*4, ' ') || deptnm
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;

-- ����� �������� : leaf ==> root node(���� node)
-- ��ü ��带 �湮�ϴ°� �ƴ϶� �ڽ��� �θ��常 �湮 (����İ� �ٸ���)
-- ������ : ��������
-- ������ : �����μ�

select dept_h.*, level, lpad(' ', (level - 1) * 4) || deptnm
from dept_h
start with deptnm = '��������'
connect by prior p_deptcd = deptcd;

select *
from h_sum;

-- ���������� ����.sql�� �̿��Ͽ� ���̺��� �����ϰ� ������ ���� ����� �������� ������ �ۼ��ϼ���
select lpad(' ', (level - 1) * 4) || s_id s_id, value
from h_sum
start with s_id = 0
connect by prior s_id = ps_id;

-- ���������� ��ũ��Ʈ.sql�� �̿��Ͽ� ���̺��� �����ϰ� ������ ���� ����� �������� ������ �ۼ��ϼ���
select lpad(' ', (level - 1) * 4) || org_cd org_cd, no_emp
from no_emp
start with org_cd = 'XXȸ��'
connect by prior org_cd = parent_org_cd;

-- ������ ������ �� ���� ���� ��� ��ġ�� ���� ��� �� (plumping branch - ����ġ��)
-- from ==> start with, connect by ==> where
-- 1. where : ���� ������ �ϰ� ���� ���� ����
-- 2. connect by : ���� ������ �ϴ� �������� ���� ����


-- where�� ��� �� : �� 9���� ���� ��ȸ�Ǵ� �� Ȯ��
-- where�� (deptnm != '������ȹ��') : ������ȹ�θ� ������ 8���� �� ��ȸ�Ǵ� �� Ȯ��

select lpad(' ', (level - 1) * 4) || org_cd org_cd, no_emp
from no_emp
where org_cd != '������ȹ��'
start with org_cd = 'XXȸ��'
connect by prior org_cd = parent_org_cd;

-- connect by ���� ������ ���
select lpad(' ', (level - 1) * 4) || org_cd org_cd, no_emp
from no_emp
start with org_cd = 'XXȸ��'
connect by prior org_cd = parent_org_cd and org_cd != '������ȹ��';

-- connect_by_root(�÷�) : �ش� �÷��� �ֻ��� ���� ���� ��ȯ
-- sys_connect_by_path(�÷�, ������) : �ش� ���� �÷��� ���Ŀ� �÷� ���� ��õ, �����ڷ� �̾��ش�
-- connect_by_isleaf : �ش� ���� leaf �������(����� �ڽ��� ������) ���� ���� (1:leaf, 0:no leaf)

select lpad(' ', (level - 1) * 4) || org_cd org_cd, no_emp,
       connect_by_root(org_cd) root,
       ltrim(sys_connect_by_path(org_cd, '-'), '-') path,
       connect_by_isleaf leaf
from no_emp
start with org_cd = 'XXȸ��'
connect by prior org_cd = parent_org_cd;

-- �Խñ��� �����ϴ� board_test ���̺��� �̿��Ͽ� ���� ������ �ۼ��ϼ���
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

-- �Խñ��� ���� �ֽű��� �ֻ����� �´�. ���� �ֽű��� ������ �����Ͻÿ�
select seq, lpad(' ', (level - 1) * 4) || title title
from board_test
start with parent_seq is null
connect by prior seq = parent_seq
ORDER by seq desc;

-- �Խñ��� ���� �ֽű��� �ֻ����� �´�. ���� �ֽű��� ������ �����Ͻÿ�
select seq, lpad(' ', (level - 1) * 4) || title title
from board_test
start with parent_seq is null
connect by prior seq = parent_seq
ORDER siblings by seq desc;

-- �Խñ��� ���� �ֽű��� �ֻ����� �´�. ���� �ֽű��� ������ �����Ͻÿ�
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