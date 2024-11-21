-- case 문
select 컬럼1, 컬럼2, 컬럼3,
-- if (컬럼4==비교값1){결과값1출력}else if(컬럼4==비교값2){결과값2출력)else{결과값3출력}} 
case 컬럼4
when 비교값1 then 결과값1
when 비교값2 then 결과값2
else 결과값3
end
from 테이블명;

select id, email,
case name 
when name is null then '익명사용자' 
else name 
end
from author;

-- ifnull(a, b) : 만약에 a가 null이면 b반환, null 아니면 a 반환
select id, email, ifnull(name, '익명사용자')
as 사용자명 
from author;

-- 경기도에 위치한 식품창고목록 출력하기
SELECT WAREHOUSE_ID, WAREHOUSE_NAME, ADDRESS, IFNULL(FREEZER_YN, 'N') AS 'FREEZER_YN'
from FOOD_WAREHOUSE WHERE  ADDRESS LIKE'경기도%' ORDER BY WAREHOUSE_ID ASC;

-- IF(A,B,C) : A조건이 참이면 B반환, A조건이 거짓이면 c반환
select id, email, if(name is null, '익명사용자', name) as '사용자명' from author;

-- 조건에 부합하는 중고거래 상태 조회하기
SELECT BOARD_ID, WRITER_ID, TITLE, PRICE, 
CASE STATUS
WHEN 'SALE' THEN '판매중'
WHEN 'RESERVED' THEN '예약중'
WHEN 'DONE' THEN '거래완료'
END AS STATUS
FROM USED_GOODS_BOARD WHERE CREATED_DATE = '2022-10-05' ORDER BY BOARD_ID DESC;

-- 12세이하인 여자 환자목록 출력하기 
                    -- CASE문 사용 --
SELECT PT_NAME, PT_NO, GEND_CD, AGE,
CASE
WHEN TLNO IS NULL THEN 'NONE'
ELSE TLNO
END as TLNO
FROM PATIENT WHERE AGE <= 12 AND GEND_CD = 'W' ORDER BY AGE DESC, PT_NAME;
                    -- IFNULL문 사용 --
SELECT PT_NAME, PT_NO, GEND_CD, AGE,
IFNULL(TLNO, 'NONE') AS TLNO
FROM PATIENT WHERE AGE <= 12 AND GEND_CD = 'W' ORDER BY AGE DESC, PT_NAME;