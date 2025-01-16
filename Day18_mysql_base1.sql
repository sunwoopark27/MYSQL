# mysql 실습 mysql workbench 사용법 google 문서에


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
