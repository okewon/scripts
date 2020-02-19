SELECT b.ename, b.sal, a.lv
FROM
(SELECT a.*, rownum rm
FROM
(SELECT *
FROM
(   SELECT LEVEL lv
    FROM dual
    CONNECT BY LEVEL <=14) a,
(   SELECT deptno, COUNT(*) cnt
    FROM emp
    GROUP BY deptno) b
WHERE b.cnt >= a.lv
ORDER BY b.deptno, a.lv) a) a 
JOIN
(SELECT b.*, rownum rm
FROM
(SELECT ename, sal, deptno
FROM emp
ORDER BY deptno, sal desc)b) b ON(a.rm = b.rm);

-- ���� ������ �м��Լ��� ����ؼ� ǥ���ϸ�..
-- �μ��� �޿� ��ŷ

select ename, sal, deptno,
       rank() over (partition by deptno order by sal desc) sal_rank
from emp;

-- ���� ���� ��� 11��
-- ����¡ ó��(�������� 10���� �Խñ�)
-- 1������ : 1 ~ 10
-- 2������ : 11 ~ 20
-- ���ε� ���� : page, :pageSize
select *
from
    (select rownum rn, a.*
    from 
        (SELECT seq, LPAD(' ', (LEVEL-1)*4) || title title, DECODE(parent_seq, NULL, seq, parent_seq) root
         FROM board_test
         START WITH parent_seq IS NULL
         CONNECT BY PRIOR seq = parent_seq
         ORDER SIBLINGS BY root DESC, seq ASC) a)
where rn BETWEEN (:page-1)* :pageSize +1 AND :page*:pageSize;

-- �м��Լ� ����
-- �м��Լ���([����]) over ([partition by �÷�] [order by �÷�] [windowing])
-- partition by �÷� : �ش� �÷��� ���� row���� �ϳ��� �׷����� ���´�
-- order by �÷� : partition by�� ���� ���� �׷� ������ order by �÷����� ����

-- row_number() over (partition by deptno order by sal desc) rank

-- ���� ���� �м��Լ�
-- rank() : ���� ���� ���� �� �ߺ� ������ ����, �ļ����� �ߺ� ����ŭ ������ ������ ����
--          2���� 2���̸� 3���� ���� 4����� �ļ����� �����ȴ�.
-- densc_rank() : ���� ���� ���� �� �ߺ� ������ ����, �ļ����� �ߺ����� �������� ����
--                  2���� 2���̴��� �ļ����� 3����� ����
-- row_number() : rownum�� ����, �ߺ��� ���� ������� ����

-- �μ���, �޿� ������ 3���� ��ŷ �����Լ��� ����

select ename, sal, deptno,
        rank() over (partition by deptno order by sal) rank,
        dense_rank() over (partition by deptno order by sal) sal_dense_rank,
        row_number() over (partition by deptno order by sal) sal_row_number
from emp;

-- �޿��� �������� ���������� �������� ��
select ename, sal, deptno, empno,
        rank() over (order by sal) rank,
        dense_rank() over (order by sal) sal_dense_rank,
        row_number() over (order by sal) sal_row_number
from emp;

-- �޿��� �������� ���������� �����ϰ� �޿��� ���� ���� ���Ͽ� ����� ���� ����� ���� ������ �ǵ��� empno�� �ٽ� ����
select ename, sal, deptno, empno,
        rank() over (order by sal, empno asc) rank,
        dense_rank() over (order by sal, empno asc) sal_dense_rank,
        row_number() over (order by sal, empno asc) sal_row_number
from emp;

-- �׷� �Լ� : ��ü ������
select count(*)
from emp;

-- ana1 : ��� ��ü �޿� ����
-- �м��Լ����� �׷� : partition by ==> ������� ������ ��ü ���� �������
select emp.empno, emp.ename, emp.deptno, cnt
from emp,
    (select deptno, count(*) cnt
     from emp
     group by deptno) dept_cnt
where emp.deptno = dept_cnt.deptno; 

-- ������ �м��Լ� (group �Լ����� �����ϴ� �Լ� ������ ����)
-- sum(�÷�)
-- count(*),count(�÷�)
-- min(�÷�)
-- max(�÷�)
-- avg(�÷�)

-- no_ana2�� �м��Լ��� ����Ͽ� �ۼ�
-- �μ��� ������

select empno,ename,deptno,count(*) over(partition by deptno) cnt
from emp;

select empno, ename, deptno,
        count(deptno) over (partition by deptno) cnt
from emp;

select empno, ename, deptno,
        count(*) over (partition by deptno) cnt
from emp;

select empno, ename, sal, deptno,
        round(avg(sal) over (partition by deptno),2) avg_sal
from emp;     

select empno, ename, sal, deptno,
        max(sal) over (partition by deptno)
from emp;

select empno, ename, sal, deptno,
        min(sal) over (partition by deptno)
from emp;

-- �޿��� ������������ �����ϰ�, �޿��� ���� ���� �Ի����ڰ� ���� ����� ���� �켱������ �ǵ��� �����Ͽ�
-- �������� ������(lead)�� sal �÷��� ���ϴ� ���� �ۼ�
select empno, ename, hiredate, sal,
       lead(sal) over (order by sal desc, hiredate) lead_sal
from emp;       
       
select empno, ename, hiredate, sal,
       lag(sal) over (order by sal desc, hiredate) lead_sal
from emp;       

select empno, ename, hiredate, sal,
       lag(sal) over (partition by job order by sal desc, hiredate) lag_sal
from emp;

select aa.empno, aa.ename, aa.sal
from
    (select a.*, case when a.sal < b.sal then sum(a.sal) end c_sum
     from
        (select empno, ename, sal
        from emp
        order by sal, hiredate desc) a,
        (select empno, ename, sal
        from emp
        order by sal, hiredate desc) b
     where a.sal < b.sal) aa;


select a.*, case when a.sal < b.sal then a.sal + nvl(b.sal, 0) end c_sum
from
        (select empno, ename, sal
        from emp
        order by sal, hiredate desc) a,
        (select empno, ename, sal
        from emp
        order by sal, hiredate desc) b;

SELECT a.empno, a.ename, a.sal, SUM(b.sal) C_SUM
FROM 
    (SELECT a.*, rownum rn
     FROM 
        (SELECT *
         FROM emp
         ORDER BY sal)a)a,
    (SELECT a.*, rownum rn
     FROM 
        (SELECT *
         FROM emp
         ORDER BY sal, empno)a)b
WHERE a.rn >= b.rn
GROUP BY a.empno, a.ename, a.sal, a.rn
ORDER BY a.rn, a.empno;

-- no_ana3�� �м��Լ��� �̿��Ͽ� SQL �ۼ�

select empno, ename, sal, sum(sal) over (order by sal, empno rows between unbounded preceding and current row) c_sal
from emp;

-- ���� ���� �������� ���� �� ����� ���� �� ����� �� 3������ sal �հ� ���ϱ�
select empno, ename, sal, sum(sal) over (order by sal, empno rows between 1 preceding and 1 following) c_sum
from emp;

-- �����ȣ, ����̸�, �μ���ȣ, �޿� ������ �μ����� �޿�, �����ȣ ������������ �������� ��, �ڽ��� �޿��� �����ϴ� ������� �޿� ���� ��ȸ�ϴ� ������ �ۼ��ϼ���
-- order by ��� �� windowing ���� ������� ���� ��� ���� windowing�� �⺻ ������ ����ȴ�
-- range unboundede preceding
-- range between unbounded preceding and current row
select emp.empno, emp.ename, emp.deptno, emp.sal,
       sum(emp.sal) over(partition by emp.deptno order by emp.sal, emp.empno rows between a.cnt preceding and current row) c_sum
from emp,
    (select deptno, count(*) cnt
     from emp
     group by deptno) a
where emp.deptno = a.deptno;

select empno, ename, deptno, sal,
        sum(sal) over (partition by deptno order by sal, empno rows between unbounded preceding and current row) c_sum
from emp;

select empno, ename, deptno, sal,
        sum(sal) over (partition by deptno order by sal, empno) c_sum
from emp;

-- windowing�� range, row ��
-- range : ������ ���� ����, ���� ���� ������ �÷����� �ڽ��� ������ ���
-- rows : �������� ���� ����
select empno, ename, deptno, sal,
        sum(sal) over (partition by deptno order by sal rows unbounded preceding) row_, -- ������ ��(�ߺ��Ǵ� ��)�� ���� �� ���� ������ �ٸ�
        sum(sal) over (partition by deptno order by sal range unbounded preceding) range_,
        sum(sal) over (partition by deptno order by sal) default_
from emp;