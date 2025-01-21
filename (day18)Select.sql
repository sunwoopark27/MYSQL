# mysql 실습 mysql workbench 사용법 google 문서에
## 정리(밑에 실습 있음)
## SELECT
# : 테이블에서 데이터를 조회
#   조회 기능이 많아 DQL 이라고도 함

# SELECT select_list
# FROM table_name;
# SELECT 키워드: 데이터를 선택하려는 필드를 하나 이상 지정(모든 필드는 *로 표시)
# FROM 키워드: 데이터를 선택하려는 테이블 지정

# coffee DB 활용
USE coffee;

-- 1. SELECT 기본
# 1-1. 고객정보 테이블에서 name 조회
SELECT first_name
FROM customer;

# 1-2. 고객정보 테이블에서 모든 이름과 이메일 주소 조회
SELECT first_name, customer_email
FROM customer;

# 1-3. 고객정보의 모든 데이터 조회
SELECT * FROM customer;

-- 2. SELECT AS : 필드의 이름을 임시 이름으로 변경하여 조회
# <문법>
# SELECT column_name AS '표시하고자 하는 컬럼명'
# FROM table_name;

# 2-1. 고객정보 테이블에서 이메일을 조회하는데, 컬럼명 '이메일주소'로 출력하여 조회
SELECT customer_email as '이메일 주소'
FROM customer;

# 2-2. 주문(sales_reciepts) 테이블에서 unit_price를 1000과 곱하여 (KRW)단위로 출력
SELECT 
	product_id,
	unit_price * 1000 as '가격(KRW)'
FROM sales_reciepts;

-- 3. Filtering : 데이터를 필터링하여 조회
# Filering Data 키워드
# - 절 (Clause)
#  * DISTINCT
#  * WHERE
# - 연산자 (Operator)
#  * BETWEEN min_value AND max_value
#  * IN
#  * LIKE
#  * IS
#  * 비교연산자 : =, =>, <=, !=
#  * 논리연산자 : AND(&&), OR(||), NOT(!)

-- 1. DISTINCT
#     : 조회 결과에서 중복된 레코드를 제거
# < 문법 >
# SELECT DISTINCT
#    select_list
# FROM table_name;

# DISTINCT는 SELECT 바로 뒤에 작성
# SELECT DISTINCT절 : 고유한 값을 선택하려는 하나 이상의 필드 지정

# 1-1. 매장정보(sales_outlet)에서 city에 대한 고유값 선택
SELECT DISTINCT
	store_city
FROM sales_outlet;

-- 2. WHERE : 조회 시 틀정 검색 조건 지정
# < 문법 >
# SELECT select_list
# FROM table_name
# WHERE search_condition;

# FROM절 뒤에 작성
# search_condition은 비교연산자 및 논리연산자, 연산자를 사용하여 조건을 지정

# 2-1. sales_outlet 테이블에서 city가 Jamaica인 outlet_id와 outlet_type 조회
SELECT sales_outlet_id, sales_outlet_type
FROM sales_outlet
WHERE store_city = 'Jamaica';

-- 3. BETWEEN : 칼럼의 데이터가 a와 b사이에 있는지 확인
# < 문법 >
# col_name BETWEEN a AND b;

# 3-1. sales_outlet 테이블에서
# manager가 10명에서 30명사이의 outlet_id와 square_feet 조회

SELECT 
	sales_outlet_id,
    store_square_feet
FROM sales_outlet
WHERE manager BETWEEN 10 AND 30;

-- 4. IN : 값이 특정 목록 안에 있는지 확인
# < 문법 >
# col_name IN (목록);

# 4-1. product 테이블에서 product_category가 ('Coffee', 'Tea')인 product_type 조회
SELECT product_type
FROM product
WHERE product_category IN ('Coffee', 'Tea');

-- 5. LIKE : 값이 특정패턴에 일치하는지 확인
# Wildcard Characters
#  % : 0개 이상의 문자열과 일치하는지 확인
#  _ : 단일문자와 일치하는지 확인

# 5-1. product 테이블에서 product_category에 'Tea'가 포함된 product 조회
SELECT product
FROM product
WHERE product_category LIKE '%Tea%';

## 6. IS : NULL 값은 연산자(=)를 이용하여 비교 불가
#          IS연산자를 활용하여 NULL인지 확인
# < 문법 >
# NULL인 경우 :     col_name IS NULL
# NULL이 아닌 경우 : col_name IS NOT NULL

# 6-1. product 테이블에서
# product가 'NULL인 경우'의 product_category 중복 제외하고 조회
SELECT DISTINCT 
	product_category
FROM product
WHERE product IS NULL;

# 6-2. product 테이블에서
# product가 'NULL이 아닌 경우'의 product_category 중복 제외하고 조회
SELECT DISTINCT 
	product_category
FROM product
WHERE product IS NOT NULL;

## **연산자 우선순위**
# 	  1. 괄호
# 	  2. NOT 연산자
# 	  3. 비교연산자
# 	  4. AND
# 	  5. OR

--  MySQL 내장함수를 활용한 SELECT
#   . 문자형
#	 - CONCAT, TRIM, REPLACE
#    - LOCATE
#   . 숫자형
#    - ABS, MOD, POW
#	 - CEIL, FLOOR, ROUND
#   . 날짜형
#	 - CURDATE, CURTIME, NOW
#    - DATE_FORMAT
#   . NULL 관련
#    - IFFULL, COALESCE, NULLIF

-- 1. 문자형 함수
-- . CONCAT(str1,str2...)
#   : 인자로 들어오는 문자열을 하나씩 연결해주는 함수

SELECT CONCAT('Hello', '!', 'World');
# sales_outlet 테이블에서 address와 postcode를 중간에 공백을 추가하여 조회
SELECT CONCAT(store_address, ' ', store_postal_code)
FROM sales_outlet;

-- . TRIM(([BOTH/LEADING/TRAILING] remove_str) target_str)
#   : 왼쪽 또는 오른쪽의 특정 문자를 삭제하는 함수
#     remove_str을 생략하는 경우 공백문자를 삭제

SELECT TRIM('   phone   ');                    # 공백 삭제
SELECT TRIM('-' FROM '---title---');           # - 전부 삭제
SELECT TRIM(LEADING '-' FROM '---title---');   # 앞의 - 삭제
SELECT TRIM(TRAILING '-' FROM '---title---');  # 뒤의 - 삭제

# . REPLACE(target_str, from_str, to_str)
#   : 문자열을 수정하기 위해 사용하는 함수

SELECT REPLACE('$10000','$', '₩');
# product 테이블에서 current_retail_price에서 $표시 삭제
SELECT REPLACE(current_retail_price, '$', '')
FROM product;

# . LOCATE(sub_str, target_str, start)
#   : 찾으려는 문자가 있다면, 그 문자의 첫번째 위치를 반환
#     찾으려는 문자가 없다면, 0을 반환
#     start에 숫자를 작성하면 해당 위치부터 탐색

SELECT LOCATE('download', 'dev.mysql.com/downloads/mysql/8.0.html');
SELECT LOCATE('download', 'dev.mysql.com/downloads/mysql/8.0.html', 10);

# sales_outlet 테이블에서 store_postal_code에서 '100'의 위치
SELECT LOCATE('100', store_postal_code)
FROM sales_outlet;

-- 2. 숫자형 함수
-- . ABS(x) 
#    : x의 <절대값>을 반환
SELECT ABS(-12);

-- . MOD(n,m)
#  : n을 m으로 나누었을때 <나머지>를 반환(n%m과 동일)
SELECT MOD(10, 3);

-- . POW(n,m)
#  : n의 m승의 결과를 반환
SELECT POW(2, 10);

-- . CEIL(x)
#  : x의 올림값을 반환
SELECT CEIL(10.1);

-- . FLOOR(x)
#  : x의 내림값을 반환
SELECT FLOOR(10.1);

-- . ROUND(x,d)
#  : x의 반올림값을 반환 (d는 소수점 자리수를 의미)
SELECT ROUND(10.83);
SELECT ROUND(10.83, 1);

-- 3. 날짜형 함수
-- . CURDATE()
#  : 현재 날짜를 반환
SELECT CURDATE();

-- . CURTIME()
#  : 현재 시간을 반환
SELECT CURTIME();

-- . NOW()
#  : 현재 날짜와 시간을 반환
SELECT NOW();

-- . DATE_FORMAT(date, format)
#  : 날짜 정보를 원하는 format 형태로 변환
SELECT DATE_FORMAT('2025-01-16 13:30:54', '%b-%d (%a) %r');

# 참고 링크
# https://dev.mysql.com/doc/refman/8.4/en/date-and-time-functions.html#function_date-format


-- 4. NULL 관련함수
-- . IFNULL(expr1, expr2)
#  : expr1이 NULL이면 expr2 반환 / expr1이 NULL이 아니면 expr1 반환

SELECT IFNULL(NULL, '비어있는 값입니다.');
SELECT IFNULL(100, '비어있는 값입니다.');

# customer 테이블에서 name과 birth_year를 조회
# birth_year가 NULL이면 No data가 출력될 수 있도록 조회

SELECT
	first_name, 
    IFNULL(birth_year,'No data')
FROM customer;

# sales_outlet 테이블에서 manager가 NULL인 경우 0이 표시되도록
# store_id와 manager조회
SELECT
	sales_outlet_id,
    IFNULL(manager,0) AS manager
FROM sales_outlet;

-- . NULLIF(expr1, expr2)
#  : expr1과 expr2이 동일한 경우 NULL 반환
#  : expr1과 expr2이 동일하지 않다면 expr1을 반환

SELECT NULLIF('hello', 'hello');
SELECT NULLIF('hello', 'world');

-- . COALESCE(v1, v2, v3,..)
#  : 첫번째 인자 v1부터 순서대로 확인하여 NULL이 아닌 값 반환
#  : 모두 NULL인 경우 NULL 반환

SELECT COALESCE('hello', 'world', NULL);
SELECT COALESCE(NULL, 'hello', NULL);
SELECT COALESCE(NULL, NULL, NULL);

# customer 테이블에서 gender가 N이거나 NULL인 경우
# customer_name을 출력하고 만약 Name도 NULL인 경우 'No Data'를 출력
SELECT
    COALESCE(NULLIF(gender, 'N'), customer_name, 'No Data')
FROM customer;


	
-- 실습 --------------------------------------------------------------------------------------
CREATE DATABASE db;
USE db;
CREATE TABLE test(
	Name VARCHAR(50) PRIMARY KEY,
    Age INT
    );
USE test;

CREATE TABLE examples (
    ExamId INT PRIMARY KEY AUTO_INCREMENT,
    LastName VARCHAR(50) NOT NULL,
    FirstName VARCHAR(50)
);

DESC examples;

ALTER TABLE examples
ADD COLUMN Country VARCHAR(100) NOT NULL;

ALTER TABLE examples
ADD COLUMN
    (Age INT NOT NULL DEFAULT 0,
    Address VARCHAR(100) NOT NULL DEFAULT 'default value');

USE test;
ALTER TABLE employee
ADD COLUMN store_id INT NOT NULL;

USE db;
ALTER TABLE examples
RENAME COLUMN Address TO PostCode; 

ALTER TABLE examples
RENAME TO new_examples;

ALTER TABLE new_examples
DROP COLUMN Age;

USE test;
#제약조건 추가
ALTER TABLE employee
ADD CONSTRAINT FOREIGN KEY (store_id) REFERENCES store(store_id);

DESC employee;

USE coffee;

SELECT 
	first_name
FROM customer;

SELECT
	first_name, customer_email
FROM customer;

SELECT * FROM customer;

SELECT
	customer_email AS '이메일 주소'
FROM customer;

SELECT
	product_id,
    unit_price,
    unit_price * 1000 AS '가격(KRW)'
FROM sales_reciepts;

SELECT distinct	
	store_city
from sales_outlet;

SELECT
	sales_outlet_id,sales_outlet_type
from sales_outlet
WhERE store_city = 'Jamaica';

# sales_outlet 테이블에서
# manager가 10명에서 30명사이의 outlet_id와 square_feet 조회

select
	sales_outlet_id, store_square_feet
from sales_outlet
where manager between 10 and 30;

# product 테이블에서 product_category가 ('Coffee', 'Tea')인 product_type 조회

select
	product_type
from product
where product_category IN ('Coffee','Tea');

# product 테이블에서 product_category에 'Tea'가 포함된 product
select
	product
from product
where product_category Like '%tea%';

# product 테이블에서
# product가 NULL인 경우의 product_category 중복 제외하고 조회

select distinct
	product_category
from product
where product is null;

# product 테이블에서
# product가 NULL이 아닌 경우의 product_category 중복 제외하고 조회

select distinct
	product_category
from product
where product is not null;

# Concat
SELECT CONCAT('Hello','!','World');

#TRIM
select TRIM('       phone         ');
select trim('-' from '--title--');
select trim(Leading '-' from '--title--');
select trim(Trailing '-' from '--title--');

#REPLACE
select replace('$10000','$','');

#LOCATE
select locate('download' , 'dev.mysql.com/downloads/mysql/8.0.html');

# sales_outlet 테이블에서 address와 postcode를 중간에 공백을 추가하여 조회
select 
	concat(store_address,' ',store_postal_code)
from sales_outlet;

# product 테이블에서 current_retail_price에서 $표시 삭제
select 
	replace(current_retail_price,'$','')
from product;

select
	trim(leading'$' from current_retail_price)
from product;

# sales_outlet 테이블에서 store_postal_code에서 '100'의 위치 
select
	locate(100,store_postal_code)
from sales_outlet;

select store_postal_code from sales_outlet;

SET SQL_SAFE_UPDATES=0;

UPDATE product
SET current_retail_price = replace(current_retail_price,'$','')
WHERE current_retail_price LIKE '$%';

# MODIFY :current_retail_price의 데이터 타입 변경
ALTER TABLE product
MODIFY COLUMN current_retail_price INT;

#바뀌었는지 확인
desc product;

#ABS 절댓값
SELECT ABS(-15.4);

#MOD 나머 
SELECT MOD(8,3);

#POW 지수승 
SELECT POW(2,10);


SELECT 
	CEIL(10.89) as '올림',
	FLOOR(10.89) as '내림',
    ROUND(10.89) as '반올림',    
    ROUND(10.89,1) as '반올림(.1f)'; 

#날짜형함수
SELECT
	CURDATE(),
    CURTIME(),
    NOW();

#DATE_FORMAT 데이터 포맷 변경
# 월 일 (요일) 현재시간
SELECT DATE_FORMAT(NOW(), '%b %d (%a) %r');

# IFNULL(a,b)
# 앞의 값이 비어있으면 b, 비어있지 않으면 a 
SELECT 
	IFNULL(NULL, '비어있는 값입니다.'),
	IFNULL('비어있지 않습니다.','비어있는 값입니다');
    
#NULLIF(a,b)
# 두 값이 같지않으면 a, 같으면 null
SELECT
	NULLIF('hello','world'),
    NULLIF('hello','hello');

#COALESCE(a,b,c)
#여러개 들어갈 수 있음. 저 중에 첫번째 null이 아닌 값 출력
SELECT
	COALESCE('hello','world',NULL),
    COALESCE(NULL,'hello','world'),
    COALESCE(NULL,NULL,NULL);

# customer 테이블에서 first_name과 birth_year를 조회
#birth_year가 NULL이면 No data 가 출력될 수 있도록 조회
SELECT
	first_name,
	IFNULL(birth_year,'No data')
FROM customer;

# sales_outlet 테이블에서 manager가 NULL 인 경우 0이 표시도록 조회
# manager에 빈칸도 있어서 공백도 처리
SELECT
	sales_outlet_id,
	IFNULL(NULLIF(manager,''),0)
FROM sales_outlet;

# customer 테이블에서 gender가 N이거나 NULL인 경우
#first_name을 출력하고 만약 first_name이 NULL인 경 'No data' 출력

SELECT
	COALESCE(NULLIF(gender,'N'), first_name, 'No data')
FROM customer;

SELECT
    COALESCE (first_name, 'No Data')
FROM customer
WHERE gender = 'N' OR gender IS NULL;
