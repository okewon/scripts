-- users ���̺� ��й�ȣ�� ����� �� ����Ǳ� ���� ��й�ȣ�� users_history ���̺�� �̷��� �����ϴ� Ʈ���� ����
select *
from users;

-- 1. users_history ���̺� ����
desc users;

-- key(�ĺ���) : �ش� ���̺��� �ش� �÷��� �ش� ���� �ѹ��� ����
create table users_history(
    userid varchar2(20),
    pass varchar2(100),
    mod_dt date,
    
    constraint pk_users_history primary key (userid, mod_dt)
);

comment on table users_history is '����� ��й�ȣ �̷�';
comment on column users_history.userid is '����� ���̵�';
comment on column users_history.pass is '��й�ȣ';
comment on column users_history.mod_dt is '�����Ͻ�';

select *
from user_col_comments
where table_name in ('USERS_HISTORY');

-- 2. users ���̺��� pass �÷� ������ ������ trigger�� ����
create or replace trigger make_history
    before update on users
    for each row
       
    begin
        -- ��й�ȣ�� ����� ��츦 üũ
        -- ���� ��й�ȣ / ������Ʈ �Ϸ����ϴ� �ű� ��й�ȣ
        -- :OLD.�÷� / :NEW.�÷�
        if :OLD.pass != :NEW.pass THEN
            INSERT INTO users_history VALUES (:NEW.userid, :OLD.pass, sysdate);
        end if;
    end;
/

-- 3. Ʈ���� Ȯ��
--  1. users_history�� �����Ͱ� ���� ���� Ȯ��
--  2. users ���̺��� brown ������� ��й�ȣ�� ������Ʈ
--  3. users_history ���̺� �����Ͱ� ������ �Ǿ�����(trigger�� ����) Ȯ��

--  4. users ���̺��� brown ������� ����(alias)�� ������Ʈ
--  5. users_history ���̺� �����Ͱ� ������ �Ǿ�����(trigger�� ����) Ȯ��

-- 1.
select *
from users_history;

-- 2.
update users set pass = 'test'
where userid = 'brown';

-- 3.
select *
from users_history;

-- 4.
update users set alias = '����'
where userid = 'brown';

-- 5.
select *
from users_history;

select *
from users;

rollback;

-- mybatis :
-- java�� �̿��Ͽ� �����ͺ��̽� ���α׷��� : jdbc
-- jdbc�� �ڵ��� �ߺ��� ���ϴ�

-- sql�� ������ �غ�
-- sql�� ������ �غ�
-- sql�� ������ �غ�
-- sql�� ������ �غ�

-- sql ����

-- sql ���� ȯ�� close
-- sql ���� ȯ�� close
-- sql ���� ȯ�� close
-- sql ���� ȯ�� close
-- sql ���� ȯ�� close

-- 1. ���� ==> mybatis �����ڰ� ���س��� ����� �����...
-- sql �����ϱ� ���ؼ���... dbms�� �ʿ�(�������� �ʿ�) ==> xml
-- mybatis���� �������ִ� class�� �̿�
-- sql�� �ڹ� �ڵ忡�ٰ� ���� �ۼ��ϴ°� �ƴ϶�
-- xml ������ sql�� ���Ƿ� �ο��ϴ� id�� ���� ����
-- 
-- 2. Ȱ��

select *
from emp
where empno = 7369;