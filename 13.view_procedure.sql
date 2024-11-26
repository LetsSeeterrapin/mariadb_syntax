-- view : 실제데이터를 참조만 하는 가상의 테이블
-- 사용목적 1)복잡한 쿼리대신 2)테이블의 컬럼까지 권한 분리

-- -- view생성
create view author_for_marketing as select name, email from author;
-- view 조회
select * from author_for_marketing;

--view 권한 부여
grant select on board.author_for_marketing to '계정명'@'localhost';

-- view 삭제
drop view author_for_marketing;

-- 프로시저 생성
delimiter //
create procedure hello_procedure()
begin
    select'hello world';
    end
// delimiter ;
--프로시저 호출
call hello_procedure();

-- 프로시저 삭제
drop procedure hello_procedure();

-- 게시글 목록 조회
delimiter //
create procedure 게시글목록조회()
begin
    select * from post;
    end
// delimiter ;

call 게시글 목록조회();

-- 게시글 id 단건 조회
delimiter //
create procedure 게시글id단건조회(in postid bigint)
begin
    select * from post where id = postid;
    end
// delimiter ;

call 게시글 목록조회(1);

-- 게시글 목록조회 byemail
delimiter //
create procedure 게시글목록조회byemail(in inputEmail varchar(255))
begin
    select id, title, contents from post where id = inputEmail;
    end
// delimiter ;

-- 글쓰기
delimiter //
create procedure 글쓰기(in inputTitle varchar(255), in inputContents varchar(255), in inputEmail varchar(255))
begin
    declare authorId bigint;
    declare postId bigint;
    -- post 테이블에 insert
    insert into post(title, contents) values(inputTitle, inputContents);
    select id into postId from post order by id desc limit 1;
    select id into authorId from author where email= inputEmail;
    -- author_post 테이블 insert :author_id, post_id
    insert into author_post(author_id, post_id) values(authorId, postId);
    end
// delimiter ;

--글삭제: 입력값으로 글 id, 본인 email
delimiter //
create procedure 글삭제(in inputPostId bigint, in inputEmail varchar(255))
begin
    declare authorPostCount bigint;
    declare authorId bigint;
    select count(*) into authorPostCount from author_post where post_id = inputPostId;
    select id into authorId from author where email = inputEmail;
    if authorPostCount>=2 then
    -- elseif까지 사용가능
        delete  from author_post where post_id = inputPostId and author_id = authorId;
    else
		delete from author_post where post_id=inputPostId and author_id = authorId;
        delete from post where id = inputPostId;
    end if;
    end
// delimiter ;

-- 반복문을 통해 post 대량생성 : title, 글쓴이 email

delimiter //
create procedure 글도배(in count int, in inputEmail varchar(255))
begin
    declare countValue int default 0;
    declare authorId bigint;
    declare postId bigint;
    while countValue<count Do
        
    -- post 테이블에 insert
    insert into post(title) values('안녕하세요');
    select id into postId from post order by id desc limit 1;
    select id into authorId from author where email= inputEmail;
    -- author_post 테이블 insert :author_id, post_id
    insert into author_post(author_id, post_id) values(authorId, postId);
        set countValue = countValue+1;
    end while;
    end
// delimiter ;