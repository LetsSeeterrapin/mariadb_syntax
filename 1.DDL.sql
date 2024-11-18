-- mariadb서버에 접속
mariadb -u root -p

-- 스키마(database) 목록 조회
show databases;

-- 스키마(database) 생성 *
CREATE DATABASE board;

--스키마 삭제
drop database;

-- 데이터베이스 선택 *
use board;

-- 테이블 목록 조회 *
show tables;

-- 문자인코딩(문자체계) 조회
show variables like 'character_set_server'

-- 문자 인코딩 변경
alter database board default character set utf8mb4;

-- 테이블 생성
create table author(id INT primary key, name varchar(100), email varchar(100), password varchar(100));

-- 테이블 컬럼 조회 *
describe author;

-- 테이블 컬럼 상세조회
show full culumns from author;

-- 테이블 생성명령문 조회
show create table author; 

-- post 테이블 신규생성(id, title, content, author_id) *
create table post(id int primary key, title varchar(255), content varchar(255), author_id int not null, foreign key(athor_id) references author(id));

--테이블 index 조회(성능향상 옵션) 조회
show index from author;

-- alter문 : 테이블의 구조를 변경
-- 테이블의 이름변경
alter table post rename posts;

-- 테이블 컬럼 추가 *
alter table author add column age int;

-- 테이블 컬럼 삭제
alter table author drop column age;

-- 테이블 컬럼명 변경
alter table post change column content contents varchar(100);

--테이블 컬럼 타입과 제약조건 변경 => 덮어쓰기 됨에 유의(안붙이면 nullable이 됨)*
alter table author modify column email varchar(100) not null;


-- 실습 : author 테이블에 address컬럼 추가. varchar 255
alter table author add column address varchar(100);

-- 실습 : post 테이블에 title은 not null로 변경, contents 3000자로 변경
alter table post modify column title varchar(100) not null, modify column contents varchar(3000);