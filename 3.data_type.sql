-- tinyint는 -128 ~127 까지 표현(1byte 할당)
-- author 테이블에 age컬럼 추가
alter table into author add column age tinyint;
-- data insert 테스트 : 200살 insert
insert into author(id, name, age) values(6, damn, 200)
alter table author modify column age tinyint unsigned;
insert into author (id, age) values(6, 200);

-- decimal 실습
-- decimal(정수부, 소수부)
alter table post add column price decimal(10, 3);
-- decimal 소수점 초과 후 값 
insert into post(id, title, price) values(2,'javaprograming', 10.33412); -- 위에서 decimal 값을 (10, 3)으로 설정했기 때문에 db에선 [10.334]까지만 보임

-- 문자열 실습
alter table author add column self_introduction text;
insert into author(id, self_introduction) values(7, '안녕하세요,인사불성입니다.');

-- blob(바이너리(binary:2진법)데이터) 타입 실습
alter table author add column profile_image longblob;
insert into author(id, profile_image) values(8, LOAD_FILE('C:\Users\Playdata\Desktop\my_image.jpg'));

-- enum : 삽입될수 있는 데이터의 종류를 한정하는 데이터 타입
-- role컬럼 추가
alter table author add column role enum('user', 'admin') not null default 'user';
-- user값 세팅후 insert
insert into author(id, role) values(10, 'user');
-- user값 세팅 후 insert(잘못된 값)
insert into author(id, role) values(10, 'user');
-- 아무것도 안넣고 inset(default 값)
insert into author(id, name) values(10, 'kang');

-- date : 날짜, datetime : 날짜 및 시분초(microseconds)
-- datetime은 입력, 수정, 조회 시에 문자열 형식을 활용
alter table post add column created_time datetime default current_timestamp();
update post set created_time = '2024-11-15 15:25:30' where id = 1;

-- 조회 시 비교연산자 *
select * from author where id >= 2 and id ,= 4;
select * from author where id between 2 and 4; --위 >= and <=4 구문과 같은 구문
select * from author where id not(id < 2 or id > 4);
select * from author where id not(id <= 1 or id >= 5);
select * from author where id in(2,3,4);
select * from author where id not in(1,5); -- 전체데이터가 1~5까지밖에 없다는 가정하에 바로위와 같은 구문

--select 조건에 select문을 입력해도 된다.
select * form author where id in(select author_id from post);
-- Like : 특정문자를 포함하는 데이터를 조회하기위해 사용하는 키워드
select * from post where title like '%동';  -- h로 끝나는 title검색
select * from post where title like '동%';  -- h로 시작하는 title검색
select * from post where title like '%동%'; -- 단어의 중간에 h라는 키워드가 있는 경우 검색

-- regexp : 정규표현식을 활용한 조회  *
-- not regexp도 활용 가능
select * from post where title regexp '[a-z]'; -- 하나라도 소문자 알파벳이 들어있으면
select * from post where title regexp'[가-힣]'; -- 하나라도 한글이 들어있으면

-- 날짜변환 cast, convert : 숫자->날짜, 문자->날짜  *
-- 문자 -> 숫자 변환
select cast(20241119 as date);
select cast('20241119' as date);
select convert(20241119, date);
select convert('20241119', date);
-- 문자 -> 숫자 변환
select cast('12'as unsigned);

-- 날짜 조회 방법    *
-- Like패턴, 부등호 활용, date_format
select * from post where created_time like '2024-11%'; --문자열처럼 조회
select * from post where created_time >= '2024-01-01' and created_time < '2025-01-01';
-- date_format활용
select date_format(created_time, '%Y-%m-%d') from post; 
select date_format(created_time, '%H:%i:%s') from post; 
 select * from post where date_format(created_time, '%Y')='2024'
 select * from post where cast(date_format(created_time, '%Y')='2024' as unsigned) = 2024;

-- 현재 시간
select now();