-- users 테이블에 비밀번호가 변경될 때 변경되기 전의 비밀번호를 users_history 테이블로 이력을 생성하는 트리거 생성
select *
from users;

-- 1. users_history 테이블 생성
desc users;

-- key(식별자) : 해당 테이블의 해당 컬럼에 해당 값이 한번만 존재
create table users_history(
    userid varchar2(20),
    pass varchar2(100),
    mod_dt date,
    
    constraint pk_users_history primary key (userid, mod_dt)
);

comment on table users_history is '사용자 비밀번호 이력';
comment on column users_history.userid is '사용자 아이디';
comment on column users_history.pass is '비밀번호';
comment on column users_history.mod_dt is '수정일시';

select *
from user_col_comments
where table_name in ('USERS_HISTORY');

-- 2. users 테이블의 pass 컬럼 변경을 감지할 trigger를 생성
create or replace trigger make_history
    before update on users
    for each row
       
    begin
        -- 비밀번호가 변경된 경우를 체크
        -- 기존 비밀번호 / 업데이트 하려고하는 신규 비밀번호
        -- :OLD.컬럼 / :NEW.컬럼
        if :OLD.pass != :NEW.pass THEN
            INSERT INTO users_history VALUES (:NEW.userid, :OLD.pass, sysdate);
        end if;
    end;
/

-- 3. 트리거 확인
--  1. users_history에 데이터가 없는 것을 확인
--  2. users 테이블의 brown 사용자의 비밀번호를 업데이트
--  3. users_history 테이블에 데이터가 생성이 되었는지(trigger를 통해) 확인

--  4. users 테이블의 brown 사용자의 별명(alias)를 업데이트
--  5. users_history 테이블에 데이터가 생성이 되었는지(trigger를 통해) 확인

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
update users set alias = '수정'
where userid = 'brown';

-- 5.
select *
from users_history;

select *
from users;

rollback;

-- mybatis :
-- java를 이용하여 데이터베이스 프로그래밍 : jdbc
-- jdbc가 코드의 중복이 심하다

-- sql을 실행할 준비
-- sql을 실행할 준비
-- sql을 실행할 준비
-- sql을 실행할 준비

-- sql 실행

-- sql 실행 환경 close
-- sql 실행 환경 close
-- sql 실행 환경 close
-- sql 실행 환경 close
-- sql 실행 환경 close

-- 1. 설정 ==> mybatis 개발자가 정해놓은 방식을 따라야...
-- sql 실행하기 위해서는... dbms가 필요(연결정보 필요) ==> xml
-- mybatis에서 제공해주는 class를 이용
-- sql을 자바 코드에다가 직접 작성하는게 아니라
-- xml 문서에 sql에 임의로 부여하는 id를 통해 관리
-- 
-- 2. 활용

select *
from emp
where empno = 7369;