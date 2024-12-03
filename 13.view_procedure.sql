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

 -- 여기부터 팀프 프로시저
 -- 
 delimiter //
create procedure 보유쿠폰 조회(in inputUserid bigint)
begin

select adddate(expire_time, interval 3 month) from coupon_list where user.id = inputUserid;


end
// delimiter ;



delimiter //
create procedure 회원가입(in inputName varchar(255), in inputPersonal_id varchar(255), 
in inputPhone_number varchar(255), in inputEmail varchar(255), in inputSex enum('남','여'), in inputCouponname, in inputDiscount, 
in inputCpdescribe)
begin
    declare userId bigint;
    declare
    select expire_time into expireTime from coupon_list
    insert into user as U(name, personal_id, phone_number, email, sex) values (inputName, inputPersonal_id, inputPhone_number, inputEmail, inputSex);
    insert into coupon as C(name, discount, cp_describe) values(inputCouponname, inputDiscount, inputCpdescribe);
    insert into coupon_list(user_id, coupon_id, expire_time) values(U, C, );
    
end
// delimiter ;




delimiter //
create procedure 쿠폰생성(in count int, in inputName varchar(255), in inputDiscount varchar(255), in inputDescribe varchar(255))
begin
    declare countValue int default 0;
    while countValue<count Do
        
    -- post 테이블에 insert
    insert into coupon(name, discount, describe) values(inputName, inputDiscount, inputDescribe);
    select id into postId from post order by id desc limit 1;
    select id into authorId from author where email= inputEmail;
    -- author_post 테이블 insert :author_id, post_id
    insert into author_post(author_id, post_id) values(authorId, postId);
        set countValue = countValue+1;
    end while;
    end
// delimiter ;







DELIMITER $$

CREATE PROCEDURE 쿠폰다운로드1(IN p_user_id BIGINT, IN p_coupon_id BIGINT)
BEGIN
    DECLARE coupon_exist INT;

    -- 쿠폰 존재 여부 체크
    SELECT COUNT(*) INTO coupon_exist
    FROM coupon
    WHERE id = p_coupon_id;

    IF coupon_exist = 0 THEN
        -- 쿠폰이 존재하지 않으면 에러 메시지 반환
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The coupon does not exist.';
    ELSE
        -- 이미 해당 유저가 이 쿠폰을 보유하고 있는지 확인
        IF EXISTS (SELECT 1 FROM coupon_list WHERE user_id = p_user_id AND coupon_id = p_coupon_id) THEN
            -- 이미 보유한 쿠폰이라면 에러 메시지 반환
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You already own this coupon.';
        ELSE
            -- 쿠폰을 coupon_list 테이블에 추가하여 유저가 쿠폰을 다운받도록 처리
            INSERT INTO coupon_list (user_id, coupon_id, created_time)
            VALUES (p_user_id, p_coupon_id, CURRENT_TIMESTAMP);

            -- 쿠폰 다운로드 성공 메시지
            SELECT 'Coupon downloaded successfully.' AS message;
        END IF;
    END IF;
END$$

DELIMITER ;








--회원가입 완료(쿠폰발급)**
DELIMITER $$

CREATE PROCEDURE 회원가입(
    IN 사용자이름 VARCHAR(255),
    IN 주민번호 VARCHAR(255),
    IN 전화번호 VARCHAR(255),
    IN 이메일 VARCHAR(255),
    IN 성별 ENUM('남', '여')
)
BEGIN
    INSERT INTO user (name, personal_id, phone_number, email, sex, level, created_time, delete_user)
    VALUES (사용자이름, 주민번호, 전화번호, 이메일, 성별, 'Bronze', CURRENT_TIMESTAMP(), 0);
    
    SET @user_id = LAST_INSERT_ID();
    
    
    SET @coupon_id = 1; 
    
    INSERT INTO coupon_list (user_id, coupon_id, created_time, expire_time, usable)
    VALUES (@user_id, @coupon_id, CURRENT_TIMESTAMP(), DATE_ADD(NOW(), INTERVAL 7 DAY), 1); 
    
    SELECT @user_id AS user_id, @coupon_id AS coupon_id;
    
END$$

DELIMITER ;


-- 리뷰작성(결제한 사람만)**
DELIMITER $$

CREATE PROCEDURE 리뷰작성(
    IN 사용자id BIGINT,       
    IN 숙소id BIGINT,
    IN 결제id BIGINT, 
    IN 주제 VARCHAR(255),
    IN 내용 TEXT,               
    IN 별점 INT,                   
    IN 사진첨부 VARCHAR(255)            
)
BEGIN
    DECLARE payment_exists INT;
    
    SELECT COUNT(*) INTO payment_exists
    FROM payment p
    WHERE p.reservation_id IN (SELECT r.id FROM reservation r WHERE r.user_id = 사용자id)
    AND p.id = 결제id;
    
    IF payment_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '미결제 고객은 이용할 수 없습니다.';
    ELSE
        INSERT INTO review (accommodation_id, payment_id, title, content, star, photo, created_time)
        VALUES (숙소id, 결제id, 주제, 내용, 별점, 사진첨부, CURRENT_TIMESTAMP());
        
        SELECT '작성이 완료되었습니다!' AS message;
    END IF;
END$$

DELIMITER ;

--내리뷰확인
DELIMITER $$

CREATE PROCEDURE 내가쓴리뷰조회(IN 사용자id BIGINT)
BEGIN
    SELECT 
        r.id AS review_id,
        a.name AS accommodation_name,
        a.type AS accommodation_type,
        r.title AS review_title,
        r.content AS review_content,
        r.star AS review_star,
        r.photo AS review_photo,
        r.created_time AS review_created_time
    FROM 
        review r
    JOIN 
        accommodation a ON r.accommodation_id = a.id
    WHERE 
        r.payment_id IN (SELECT p.id FROM payment p WHERE p.reservation_id IN 
                        (SELECT r.id FROM reservation r WHERE r.user_id = 사용자id))
    ORDER BY 
        r.created_time DESC;
    
END$$

DELIMITER ;

-- 유저정보조회
DELIMITER $$

CREATE PROCEDURE 유저정보조회(IN 사용자id BIGINT)
BEGIN
    SELECT 
        id AS user_id,
        name,
        personal_id,
        phone_number,
        email,
        sex,
        level,
        created_time,
        delete_user
    FROM 
        user
    WHERE 
        id = 사용자id;
END$$

DELIMITER ;


--쿠폰등록
DELIMITER $$

CREATE PROCEDURE 새쿠폰등록(
    IN 쿠폰이름 VARCHAR(255),         
    IN 할인금액 VARCHAR(255),         
    IN 할인내용 VARCHAR(255)       
)
BEGIN
    INSERT INTO coupon (name, discount, cp_describe, update_time)
    VALUES (쿠폰이름, 할인금액, 할인내용, CURRENT_TIMESTAMP());
    
    SELECT '쿠폰 등록이 완료되었습니다.' AS message;
END$$

DELIMITER ;



--쿠폰조회시 만료기간지났으면 사용불가처리
DELIMITER $$

CREATE PROCEDURE 쿠폰조회(IN 사용자id BIGINT)
BEGIN
    SELECT 
        u.name AS user_name,           
        c.id AS coupon_id,          
        c.name AS coupon_name,      
        c.discount AS coupon_discount, 
        c.cp_describe AS coupon_description, 
        cl.created_time AS coupon_created_time, 
        cl.expire_time AS coupon_expire_time,  
        CASE
            WHEN cl.expire_time < CURRENT_TIMESTAMP THEN '사용불가' 
            ELSE DATE_FORMAT(cl.expire_time, '%Y-%m-%d')  
        END AS coupon_status
    FROM 
        coupon_list cl
    JOIN 
        coupon c ON cl.coupon_id = c.id
    JOIN 
        user u ON cl.user_id = u.id
    WHERE 
        cl.user_id = 사용자id
    ORDER BY 
        cl.created_time DESC;  
END$$

DELIMITER ;

-- 쿠폰다운로드
DELIMITER $$

CREATE PROCEDURE 쿠폰다운로드(IN 사용자id BIGINT, IN 쿠폰id BIGINT)
BEGIN
    DECLARE coupon_exist INT;

    
    SELECT COUNT(*) INTO coupon_exist
    FROM coupon
    WHERE id = 쿠폰id;

    IF coupon_exist = 0 THEN
        
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The coupon does not exist.';
    ELSE
       
        IF EXISTS (SELECT 1 FROM coupon_list WHERE user_id = 사용자id AND coupon_id = 쿠폰id) THEN
          
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You already own this coupon.';
        ELSE
           
            INSERT INTO coupon_list (user_id, coupon_id, created_time)
            VALUES (사용자id, 쿠폰id, CURRENT_TIMESTAMP);

            SELECT 'Coupon downloaded successfully.' AS message;
        END IF;
    END IF;
END$$

DELIMITER ;








-- 유저등급조회
 delimiter //
create procedure 유저등급조회(in inputUserid bigint)
begin

select u.name, u.level 
from user u where u.id = inputUserid;
end
// delimiter ;



 delimiter //
create procedure 보유쿠폰조회3(in inputUserid bigint)
begin

select u.name, c.name, c.discount, c.cp_discribe, cl.usable, cl.adddate(expire_time, interval 3 month) 
from user u, coupon c, coupon_list cl where u.id = inputUserid;
if datetime > expire_time then 
update coupon_list set usable = 0 where coupon_list.id = inputUserid

end
// delimiter ;
