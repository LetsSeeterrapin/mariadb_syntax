-- 여러사용자가 1개의 글을 수정할 수 있다 가정 후 DB 리뉴얼
-- author 와 post가 n:m관계가 되어 관계테이블을 별도로 생성
create table author 
(id bigint primary key auto_increment,
 email varchar(255) not null unique,
 password varchar(255),
 name varchar(255),
 created_time datetime default current_timestamp());

  create table post 
 (id bigint primary key auto_increment,
 title varchar(255) not null, 
 contents varchar(3000), 
 created_time datetime default current_timestamp());

 -- 1:1관계인 author_address
 -- 1:1관계의 보장은
create table author_address(id bigint auto_increment primary key,
 author_id bigint not null unique,
 country varchar(255), city varchar(255), street varchar(255),
 created_time datetime default current_timestamp(),
foreign key(author_id) references author(id));
 -- author_post는 연결테이블로 생성
create table author_post (id bigint primary key auto_increment, 
 author_id bigint, 
 post_id bigint, 
 created_time datetime default current_timestamp(), 
 foreign key(author_id) references author(id), 
 foreign key(post_id) references post(id));
 -- 복합키로 author_post 생성
 create table author_post2(
    author_id bigint not null, 
    post_id bigint not null, 
    primary key(author_id, post_id),
    foreign key(author_id) references author(id), 
    foreign key(post_id) references post(id)
 );

 -- 내 id로 내가 쓴 글 조회
 select p.* 
 from post p 
 inner join author_post ap 
 on p.id=ap.post_id 
 where ap.author_id = 1;

 -- 글 2번 이상 쓴 사람에 대한 정보조회
 select a.* 
 from author a 
 inner join author_post ap 
 on a.id=ap.author_id 
 group by a.id 
 having count(a.id)>=2 
 order by author_id;
 -- 
 select * 
 from author_post2 
 where author_id=1 
 and post_id=2;





-- 온라인 쇼핑몰
-- 판매자 테이블 생성
create table seller(
id bigint primary key
 auto_increment, 
name varchar(255), 
gender enum('male','female') not null, 
password varchar(255), 
address varchar(255), 
email varchar(255) not null unique, 
created_time datetime default current_timestamp());
-- 구매자 테이블 생성
create table buyer(
    id bigint primary key auto_increment, 
    name varchar(255), 
    gender enum('male','female') not null, 
    password varchar(255), 
    address varchar(255), 
    email varchar(255) not null unique, 
    created_time datetime default current_timestamp());
-- 주문 테이블 생성
create table orders(
    id bigint primary key auto_increment, 
    buyer_id bigint not null, 
    foreign key(buyer_id) 
    references buyer(id)
);
-- 상품 테이블 생성
create table item(
    id bigint primary key
    auto_increment, 
    seller_id bigint not null, 
    item_name varchar(255), 
    left_count varchar(255), 
    one_mountain_paper varchar(255), 
foreign key(seller_id) references seller(id));
-- 주문상세 테이블 생성
create table orders_list(
id bigint primary key
 auto_increment, 
item_id bigint not null, 
orders_id bigint not null, 
orders_time datetime default current_timestamp(), 
count varchar(255), 
foreign key(item_id) references item(id), 
foreign key(orders_id) references orders(id));
-- 구매자이름, 상품명, 제조사, 주문수량, 재고수량, 판매자이름, 주문시각 조회하기
select b.name,
       i.item_name,
       i.company,
       ol.count,
       i.left_count,
       s.name,
       ol.orders_time
from orders_list ol,
     seller s,
     item i,
     buyer b,
     orders o 
where s.id=i.seller_id
    and i.id=ol.item_id
    and o.id=ol.orders_id
    and b.id=o.buyer_id
order by b.id;
