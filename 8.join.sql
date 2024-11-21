-- inner join
-- 두테이블 사이에 지정된 조건에 맞는 레코드만 반환. on조건을 통해 교집합찾기
select * from author inner join post on author.id=post.author_id;
select * from author a inner join post p on a.id=post.author_id;
-- 출력순서만 달라질뿐 조회결과는 동일.
select * from post inner join author on author.id=post.author_id;
-- 글쓴이가 있는 글 목록과 글쓴이의 이메일만 출력하시오.
-- 글쓴이가 없는 post의 데이터는 포함x, 글쓴이 중에 글을 한번도 안쓴사람 포함x
select p.*, a.email from post p inner join author a on a.id=p.author_id;
-- 글쓴이가 있는 글의 제목, 내용과 글쓴이의 이메일만 출력하시오.
select p.title, p.contents, a.email from post p inner join author a on a.id=p.author_id;

-- 모든 글목록을 출력하고, 만약에 글쓴이가 있다면 이메일 정보를 출럭.
-- left outer join -> left join
-- 글을 한번도 안 쓴 글쓴이의 정보는 포함x
select p.*, a.email from post p left join author a on a.id=p.author_id;

-- 글쓴이를 기준으로 left join 할 경우, 글쓴이가 n개의 글을 쓸 수 있으므로 같은 글쓴이가 여러번 출력 가능
-- author와 post가 1:n 관계이므로
-- 글쓴이가 없는 글은 포함x
select * from author a left join post p on a.id=p.author_id;

-- 실습) 글쓴이가 있는 글 중에서 글의 title과 저자의 email만을 출력하되,
-- 저자의 나이가 30세 이상인 글만 출력
select p.title, a.email from author a inner join post p on a.id=p.author_id where a.age >= 30;

-- 글의 내용과 글의 저자에 이름이 있는, 글 목록을 출력하되 2024-06 이후에 만들어진 글만 출력
select * from post p inner join author a on a.id=p.author_id 
where p.contents is not null and a,name is not null and p.created_time > '2024-06';

-- 조건에 맞는 도서와 저자 리스트 출력
SELECT B.BOOK_ID, A.AUTHOR_NAME, DATE_FORMAT(B.PUBLISHED_DATE, '%Y-%m-%d') PUBLISHED_DATE FROM BOOK B INNER JOIN 
AUTHOR A ON B.AUTHOR_ID = A.AUTHOR_ID WHERE B.CATEGORY = '경제' ORDER BY B.PUBLISHED_DATE ASC;

-- union : 두 테이블의 select 결과를 횡으로 결합(기본적으로 distinct 적용)
-- 컬럼의 개수와 컬럼의 타입이 같아야람에 우의
-- union all : 중복까지 모두포함
select name, email from author union select title, contents from post;

-- 서브쿼리 : sselect문 안에 또 다른 select문을 서브쿼리라 한다
-- where절 안에 서브쿼리
-- 한번이라도 글을 쓴 author 조회
select distinct a.* from author a inner join post p on a.id=p.author_id;
select * from author where id in  (select author_id from post)
-- select절 안에 서브쿼리
-- author의 email과 author별로 본인이 쓴 글의 개수를 출력
select email, (select count(*) from post where author_id=a.id) 'count of post' from author a;

-- from절 안에 서브쿼리
select a.name from (select * from author) as a;

-- 없어진 기록 찾기
-- 서브쿼리

-- join
SELECT O.ANIMAL_ID, O.NAME FROM ANIMAL_OUTS O LEFT JOIN ANIMAL_INS I ON I.ANIMAL_ID=O.ANIMAL_ID WHERE I.ANIMAL_ID IS NULL;

-- 집계함수
-- null은 count에서 제외
select count(password) from author;
select sum(price) from post;
select avg(price)from post;
-- 소수점 n+1번쨰자리에서 반올림해서 n번째까지 조회
select round(avg(price), n) from post;

-- group by 그룹화된 데이터를 하나의 행(row)처럼 취급.
-- author_id로 그룹핑 하였으면, 그외의 컬럼을 조회하는 것은 적절치않음.
select author_id from post group by author_id;
-- group by와 집계함수
-- 알래 쿼리에서 *은 그룹화된 데이터내에서의 개수
select author_id, count(*) from post group by author_id;
select author_id, count(*), sum(price) from post group by author_id;

-- author의 email과 author별로 본인이 쓴 글의 개수를 출력
-- join과 group by, 집계함수 활용한 글의 개수 출력
select email, (select count(*) from post where author_id=a.id) from author a;                        -- 서브쿼리를 사용
select a.email, count(author_id) from author a left join post p on a.id=p.author_id group by a.id;   -- join 사용

-- where와 group by
-- 연도별 post 글의 개수 출력, 연도가 null인 값은 제외
select date_format(created_time, '%Y') year, count(*) from post p where created_time is not null group by year;

-- 자동차 종류별 특정 옵션이 포함된 자동차 수 구하기
SELECT CAR_TYPE, COUNT(*) CARS FROM CAR_RENTAL_COMPANY_CAR C 
WHERE OPTIONS LIKE '%열선시트%' OR OPTIONS LIKE '%가죽시트%' OR OPTIONS LIKE '%통풍시트%' GROUP BY C.CAR_TYPE ORDER BY CAR_TYPE ASC;
-- 입양 시각 구하기
SELECT DATE_FORMAT(DATETIME, '%H') HOUR, COUNT(*) COUNT FROM ANIMAL_OUTS 
WHERE DATE_FORMAT(DATETIME, '%H:%i') >= '09' AND DATE_FORMAT(DATETIME, '%H:%i') < '19:59' GROUP BY HOUR ORDER BY HOUR ASC;

-- 글을 2개이상 쓴사랑에 대한 정보조회
select author_id from post group by author_id having count(*) >= 2;
select author_id, count(*) count from post group by author_id having count >= 2;

-- 동명 동물 수 찾기
SELECT NAME, COUNT(*) COUNT FROM ANIMAL_INS GROUP BY NAME HAVING COUNT(NAME) >= 2 ORDER BY NAME ASC;

-- 다중열 group by
-- post에서 작성자별로 만든 제목의 개수를 출력하시오.
select author_id, title, count(*) from post group by author_id, title;

-- 재구매가 일어난 상품과 회원리스트 구하기
SELECT USER_ID, PRODUCT_ID FROM ONLINE_SALE GROUP BY USER_ID, PRODUCT_ID HAVING COUNT(*) >= 2 ORDER BY USER_ID, PRODUCT_ID DESC;