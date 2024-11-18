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

-- 조회 시 비교연산자
select * from author where id >= 2 and id ,= 4;
select * from author where id between 2 and 4; --위 >= and <=4 구문과 같은 구문
select * from author where id not(id < 2 or id > 4);
select * from author where id not(id <= 1 or id >= 5);
select * from author where id in(2,3,4);
select * from author where id not in(1,5); -- 전체데이터가 1~5까지밖에 없다는 가정하에 바로위와 같은 구문

--select 조건에 select문을 입력해도 된다.
select * form author where id in(select author_id from post);
