-- day 21 추가
### OVER
# 조회된 데이터를 특정 기준으로 보여주는 구문

# < 문법 >
-- window_fuction() OVER ([PARTITION BY <col_name>] [ORDER BY <col_name>]) [AS new_col_name]
# OVER 절뒤에 보여주는 기준을 정의
# window_funtion : 데이터를 분석하거나 처리하는 함수
# PARTITION BY : 데이터를 그룹화
# ORDER BY : 데이터를 정렬
# [] 생략가능

# GROUP BY 와 유사하지만 OVER 라는 형태의 함수와 같이쓰면 window 함수도 사용할 수 있다.


## 윈도우 함수 (window function)
-- 집계함수 : 값을 집계해주는 함수 (Aggregation Function)
-- 순위함수 : 값의 순위를 반환하는 함수
-- 행간 이동함수 : 이전행/다음행의 값을 참조하는 함수

# 순위함수 (Ranking Function)
-- 그룹별, 정렬기준으로 순위를 지정하여 주는 함수
-- 데이터의 순위 계산
# 순위함수 종류
-- ROW_NUMBER() : 각 행의 고유한 순위, 동일한 값이여도 행이 다르면 다른 순위를 부여
-- RANK() : 각 행의 순위, 동일한 값(동일 컬럼)은 동일한 순위 부여  얘는 같은 애들은 0 denth_rank() 는 같은 값 다 111 이런식
-- NTILE(n) : 데이터를 n개로 나누어 각 행이 속한 그룹의 분위값 부여


-- ROW_NUMBER() 이용 
# city테이블을 활용하여 국가별 각 도시의 인구 순위
SELECT 
    Name, CountryCode, Population, 
    ROW_NUMBER() OVER (PARTITION BY CountryCode ORDER BY Population DESC) AS population_rank
FROM city
ORDER BY CountryCode, population_rank;
-- 국가 별이니까 CountryCode를 partition by에

-- RANK() 이용
# country테이블을 활용하여 국가별 GDP 순위
SELECT 
    Name, Continent, GNP, 
    RANK() OVER (PARTITION BY Continent ORDER BY GNP DESC) AS gnp_rank
FROM country
WHERE GNP IS NOT NULL 
ORDER BY Continent, gnp_rank;

-- 파티션이 없어 Name, Continent, GNP 이 select 기준으로는 다 1등(order by와 별개)
SELECT 
    Name, Continent, GNP, 
    RANK() OVER () AS gnp_rank
FROM country
WHERE GNP IS NOT NULL 
ORDER BY Continent, gnp_rank;

-- ROW_NUMBER하면 select 기준, order by와 별개로 rank를 가지고 온다.
SELECT 
    Name, Continent, GNP, 
    ROW_NUMBER() OVER () AS gnp_rank
FROM country
WHERE GNP IS NOT NULL 
ORDER BY Continent, gnp_rank;

-- NTILE(n) 사용 
# country테이블을 활용하여 대륙별 4분위값을 확인 내 인구가 어떤 4분위에 속하는지 
SELECT 
    Name, Population, -- Continent, : 따로 안 넣어도 Partition by 할 수 있음. 
					  -- 그래서 조회하는데 보이지 않게 할 때 사용할 수 있다. 
    NTILE(4) OVER (PARTITION BY Continent ORDER BY Population) AS population_quantile
FROM country
ORDER BY Continent, population_quantile;

# 행간이동함수 (Navigation Function)

-- 이전/이후의 행의 값을 참조하는 함수
-- 트렌드분석, 시계열 데이터 비교 -- 년도별로 조회할 때 12개씩 가져오기?

# 행간 이동함수 종류
-- LAG(col_name, n) : 현재행을 기준으로 이전 행의 값 반환
-- LEAD(col_name, n) : 현재행을 기준으로 다음 행의 값 반환
-- FIRST_VALUE(col_name) : 그룹별, 전체 데이터의 첫번째 행의 값 반환
-- LAST_VALUE(col_name) : 그룹별, 전체 데이터의 마지막 행의 값 반환

USE coffee;

-- LAG(col_name, n) 사용 
# sales_reciepts 테이블 이용하여 날짜별, 이전 트랜잭션의 값 반환 (2019-4-1에서 4-2 갈 때 보기)
SELECT 
    transaction_id, transaction_date, line_item_amount,
    LAG(line_item_amount) OVER (PARTITION BY transaction_date ORDER BY transaction_id) AS previous_sales_amount
FROM sales_reciepts
ORDER BY transaction_date, transaction_id; 

-- LEAD(col_name, n) 사용 
SELECT 
    transaction_id, transaction_date, line_item_amount,
    LEAD(line_item_amount) OVER (PARTITION BY transaction_date ORDER BY transaction_id) AS previous_sales_amount
FROM sales_reciepts
ORDER BY transaction_date, transaction_id;

-- FIRST_VALUE(col_name) 사용 -- ex) 날짜별 최댓값 가져올 수 있음
# sales_reciepts 테이블 이용하여 날짜별, 가장 큰 판매금액의 값 반환
SELECT 
    transaction_id, transaction_date, line_item_amount,
    FIRST_VALUE(line_item_amount) OVER 
     (PARTITION BY transaction_date ORDER BY line_item_amount DESC) 
     AS max_sales_amount
FROM sales_reciepts
-- WHERE transaction_date='2019-04-01' -- 다 9.5 들어감 
ORDER BY transaction_date;

--  max 구하기
SELECT transaction_date, MAX(line_item_amount)
FROM sales_reciepts
GROUP BY transaction_date
HAVING transaction_date='2019-04-01';

-- LAST_VALUE(col_name) 사용
# sales_reciepts 테이블 이용하여 날짜별, 가장 작은 판매금액의 값 반환
SELECT 
    transaction_id, 
    transaction_date, 
    line_item_amount,
    LAST_VALUE(line_item_amount) OVER 
    (PARTITION BY transaction_date ORDER BY line_item_amount DESC 
     ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS min_sales_amount
     -- 각 파티션 내에서 전체 데이터를 고려하여 가장 작은 값 반환
FROM sales_reciepts
ORDER BY transaction_date, transaction_id; --  2가 들어간 것을 볼 수 있다

-- 최소값
SELECT transaction_date, MIN(line_item_amount)
FROM sales_reciepts
GROUP BY transaction_date
HAVING transaction_date='2019-04-01';

# 테이블을 다 가져와서 조합해서 보여줌
# group by와 다르게 그 column 을 select 하지 않아도 partition 나눠서 볼 수 있다. 

### WITH
-- : 참조할 임시테이블을 만들어서 활용할 수 있도록 하는 구문
-- Subquery 사용
-- VIEW와 유사하나, Query문안에서만 활용 가능(단발성 임시테이블)
-- -> 따로 저장해 놓는게 아니라 코드 안에서!

use world;
WITH gnp_ranking AS(
SELECT 
    Name, Continent, GNP, 
    RANK() OVER (PARTITION BY Continent ORDER BY GNP DESC) AS gnp_rank
FROM country
WHERE GNP IS NOT NULL -- AND gnp_rank =< 3 -- where 이 select 보다 실행 순서상 앞에 있으므로 실행되지 않음 
ORDER BY Continent, gnp_rank)

-- 3위까지 보여주기 위해 with사용해 조회 
SELECT 
	Name, Continent, GNP
FROM gnp_ranking
WHERE gnp_rank <= 3 and Continent = 'Asia';



