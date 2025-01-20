### 데이터베이스 객체
#   : 테이블 외 인덱스, 뷰, 프로시저, 트리거, 함수 등의 객체가 있음
# - 인덱스(INDEX) : 데이터를 빠르게 검색할 수 있도록 돕는 데이터 구조
# - 뷰(VIEW) : "가상"의 테이블로, 하나 이상의 기존 테이블에서 데이터를 보여주는 역할
# - 트리거(TRIGGER) : 데이터 변경 시 자동으로 실행되는 SQL 동작
# - 프로시저(Stored Procedure) : 자주 사용하는 SQL 명령을 저장해두고 호출하는 기능
# - 함수 : 특정 입력에 대해 계산하여 결과를 반환하는 함수

# -- INDEX (ex. 목차, 이진트리)---------------------------------
#   : 주소정보 가지고 있어서 데이터 베이스에서 조회 빠르다
#  - 장점
#  조회하는 속도가 전반적으로 빠름
#  시스템의 부하가 적음
#  - 단점
#  인덱스 별로 메모리가 필요
#  그래서 삽입, 수정, 삭제가 빈번한 테이블인 경우 성능이 오히려 떨어짐(인덱스 재생성)

# 인덱스의 종류
-- 기본 인덱스
-- # 일반적으로 선언했을 때의 인덱스
-- # 인덱스로 설정된 칼럼의 데이터에 NULL값이 존재할 수 있음
-- # 인덱스가 설정된 칼럼의 데이터에 중복이 있을 수 있음
-- 유니크 인덱스
-- # UNIQUE 키우드와 함께 선언했을 때의 인덱스
-- # 인덱스를 설정할 칼럼의 데이터들은 각각 고유한 값이어야 함(중복데이터가 존재할 시 'Duplicate entry'에러 발생)

# INDEX 생성
# 자주 검색되거나 중복데이터가 적은 칼럼을 Index로 지정
# 데이터가 추가/수정/삭제될 때마다 인덱스를 수정하므로 테이블을 생성할때 지정하는 것이 좋음

# 1. 테이블을 생성할 때 지정
#    PRIMARY/FOREGIN KEY/UNIQUE 제약조건의 칼럼은 자동으로 인덱스 생성됨

# < 문법 >
#CREATE TABLE table_name(
#    col1
#    col2
#    col3
	-- INDEX 키워드 사용
#    INDEX index_name1 (col1),
	-- Key 키워드 사용
# 	 KEY index_name2 (col2)
#);

#2. INDEX 생성
# < 문법 >
-- 1) CREATE [UNIQUE] INDEX 구문 활용
# CREATE INDEX index_name
# ON table_name (col1 [index_type ASC|DESC], col2,...);
-- 2) ALTER TABLE 구문
# ALTER TABLE table_name
# ADD INDEX index_name (col1 [index_type ASC|DESC], col2,...);

# primary, foriegn, unique key에 대해서는 자동으로 인덱스 설정된다.
# UNIQUE 옵션 : 고유한 인덱스를 만들 때 사용
# index_type : 생략가능하며, *** 기본값인 B-Tree 사용 (바이너리트리)
# ASC, DESC : 정렬방식 지정, 기본값은 ASC

-- 실습
# world.city 테이블의 인덱스 정보 확인
use world;
SHOW INDEX FROM city;
# 이외에도 schemas 메뉴에 테이블에 랜치모양 아이콘 클릭시
# 밑에 index sheet(맨 밑줄에서 확인 가능)를 눌러 확인할 수 있다.

SELECT * from city; # 하면 인덱스 기준으로 정렬된 것을 볼 수 있다.

# Name INDEX 추가
CREATE INDEX idx_name
ON city(Name DESC);
# DESC 넣으면 다른거 다 만족시 그 다음 네임을 기준으로 내림차순 정렬

## 3. INDEX 삭제 ##
# < 문법 >
# -- 1) DROP 구문 활용
# DROP INDEX index_name ON table_name
# -- 2) ALTER 구문 활용
# ALTER TABLE table_name
# DROP INDEX index_name

DROP INDEX idx_name ON city;

## 4. INDEX 활용 
# 일반 조회시 활용 : 보다 빠르게 검색 가능
# 정렬 시 활용 : 인덱스기준으로 정렬되어 조회됨
# JOIN 시 활용 : 인덱스를 기준으로 JOIN할때 빠르게 검색 JOIN 가능

# 일반 조회 시 활용 ('Seoul'의 모든 정보 조회)
SELECT * FROM city         -- 적용 전 : 0.0030  sec
WHERE Name = 'Seoul';      -- 적용 후 : 0.00045 sec
# 인덱스를 위에 코드를 사용해 생성하고 코드를 돌려보고 시간 비교

# -- VIEW  ---------------------------------
# 데이터베이스 내에서 저장된 쿼리의 결과를 가상으로 나타내는 객체로 가상테이블
# 실제 데이터를 가지고 있지 않고, 실행 시점에 쿼리를 실행하여 결과를 생성하여 보여줌
# 약간 서브쿼리 같은거 만들어 놓는거?  
# 계속 select 쿼리를 쓰는게 아니라 뷰에 저장해놓고 가져와서 쓰는! 

# 장점
-- 복잡한 쿼리를 미리 정의된 뷰로 만들어 단순화 가능
-- 사용자가 데이터베이스 일부만 볼 수 있도록 제한 가능
-- 동일한 뷰를 여러 쿼리에서 사용 가능
-- ** 원본 테이블이 업데이트되면 뷰에 있는 데이터도 업데이트 된다!

# VIEW 생성
# < 문법 >
# CREATE VIEW view_name AS select_statement;
# -> AS키워드 이후 데이터는 SELECT구문 이용 ****

# VIEW 수정
# < 문법 >
# ALTER VIEW view_name
# AS select_statement;
# -- 뷰의 코드 확인
# SHOW CREATE VIEW veiw_name;

# VIEW 삭제
# < 문법 >
# DROP VIEW view_name;

-- --- 실습 ------
# country에 대한 국가 코드와 이름에 대한 VIEW 생성
CREATE VIEW view_simple_country AS
SELECT Code, Name FROM country;

# VIEW 조회
SELECT * FROM view_simple_country;

# VIEW 삭제
DROP VIEW view_simple_country;

# 각 국가별 가장 인구가 많은 도시를 조인한 VIEW 생성
CREATE VIEW v_largest_city AS
SELECT
    t.Name AS CountryName,
    c.Name AS LargestCity,
    c.Population AS CityMaxPopulation,
    t.Population AS CountryPopulation
FROM country t
JOIN city c ON t.Code = c.CountryCode
WHERE (c.CountryCode, c.Population) IN (
    SELECT CountryCode, MAX(Population)
    FROM city
    GROUP BY CountryCode
);

# 생성한 View 활용
# Asia 국가 중 가장 인구가 작은 곳보다 인구가 많은 모든 도시의 개수를 조회
# view 는 스키마 밑에 속해 있어 코드를 볼 수 있다 (Views)
SELECT COUNT(*)
FROM v_largest_city
WHERE CityMaxPopulation >=(
    SELECT MIN(Population)
    FROM country
    GROUP BY Continent
    HAVING Continent = 'Asia'
);

-- 실습 --
### 1.
# coffee DB의 product 테이블을 활용하여
# promotion 진행중인 제품의
# 제품이름과 설명, 가격(retail_price)를 조회하는 VIEW 생성
use coffee;
CREATE VIEW retail_price AS
SELECT product, current_retail_price
FROM product
WHERE promo_yn = 'Y';
#DROP VIEW retail_price;

-- 강사님
CREATE VIEW v_promo_item AS
SELECT product, current_retail_price 
FROM product
WHERE promo_yn = 'Y';

### 2.
# coffee DB의 customer테이블을 활용하여
# 오늘 생일인 고객정보(이름, 이메일)를 조회하는 VIEW 생성
CREATE VIEW today_birthday AS
SELECT first_name, customer_email, birthdate
FROM customer
WHERE DATE_FORMAT(birthdate,'%m-%d') = DATE_FORMAT(NOW(),'%m-%d');
#DROP VIEW today_birthday;

-- 강사님
CREATE VIEW v_birth_today AS
SELECT customer_first_name, customer_email
FROM customer
WHERE DATE_FORMAT(birthdate, '%m-%d') = DATE_FORMAT(CURDATE(), '%m-%d');
-- WHERE MONTH(birthdate) = MONTH(CURDATE()) AND DAY(birthdate) = DAY(CURDATE());

### 3.
# coffee DB의 sales_reciepts 테이블을 활용하여
# 매장(sales_outlet_id), 날짜별(transaction_date) 총 매출을 조회하는 VIEW 생성
# transaction별 판매금액은 line_item_amount
CREATE VIEW total_sales AS
SELECT
	   transaction_date,
	   sales_outlet_id, 
       SUM(line_item_amount) as daily_sales_amount
FROM sales_reciepts
GROUP BY sales_outlet_id, transaction_date;
#DROP VIEW total_sales;

-- 강사님 
CREATE VIEW v_daily_sales AS
SELECT sales_outlet_id, transaction_date, SUM(line_item_amount) AS daily_sales_amount
FROM sales_reciepts
GROUP BY sales_outlet_id, transaction_date;
 
### 4.
# coffee DB의 sales_reciepts, customer테이블을 활용하여
# 주문기록이 없는 고객의 정보(이름, 이메일)를 조회하는 VIEW 생성

CREATE VIEW no_order_customer as
SELECT c.first_name, c.customer_email
FROM customer c
LEFT JOIN sales_reciepts s
	ON c.customer_id = s.customer_id
WHERE product_id IS NULL;
#DROP VIEW no_order_customer;

-- 강사님
CREATE VIEW v_customer_Nbuy AS
SELECT customer_first_name, customer_email
FROM customer
WHERE customer_id NOT IN (SELECT customer_id
                          FROM sales_reciepts);

### 5.
# 생성한 VIEW와 sales_outlet테이블을 활용하여
# 일별 매출이 가장 높은 매장의 정보(id, 주소, 전화번호)를 조회

SELECT
	t.transaction_date, 
    s.sales_outlet_id, 
    s.store_address, 
    s.store_telephone
FROM sales_outlet s
LEFT JOIN (SELECT
			sales_outlet_id,
	        transaction_date,
            MAX(daily_sales_amount)
           FROM  total_sales
           GROUP BY transaction_date,sales_outlet_id) t
	ON s.sales_outlet_id = t.sales_outlet_id;
    
-- 강사님
SELECT d.transaction_date, s.sales_outlet_id, s.store_address, s.store_telephone
FROM sales_outlet s
JOIN v_daily_sales d
ON s.sales_outlet_id = d.sales_outlet_id
WHERE (d.transaction_date, d.daily_sales_amount) IN (
SELECT transaction_date, MAX(daily_sales_amount)
FROM v_daily_sales
GROUP BY transaction_date);
