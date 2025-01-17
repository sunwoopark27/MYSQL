## SubQuery 서브쿼리
# 하나의 SQL 문안에 있는 또다른 SQL 괄호로 감싸서 사용한다.

#  - Single-row Subquery(단일 행 서브쿼리)
#    : 실행 결과가 한건 이하로 단일값을 반환
#      (WHERE 이나 SELECT 절에 사용하는것이 일반적)
#      비교연산자와 함께 사용(IS 등)

#  - Multi-row Subquery(다중 행 서브쿼리)
#    :실행결과가 여러개의 결과 행을 반환할 수 있는 서브쿼리
#     단순 비교연산자를 사용할 수 없음
#     WHERE절과 HAVING절에 주로 사용됨
#     IN(그중하나), ANY(아무거나), ALL(다) 연산자와 함께 사용

#  - Multi-column Subquery(다중 열 서브쿼리)
#    : 실행결과가 하나 이상의 칼럼을 반환하는 서브쿼리
#    : 주로 메인 쿼리의 조건과 동시에 비교됨
#    : 주로 비교연산자나 EXISTS, IN 연산자와 함께 사용
	

use world;
# * Single-row Subquery(단일 행 서브쿼리)
# 1. country 테이블에서
#    Asia 대륙의 평균인구보다 인구가 많은 국가의 이름과 인구 조회

SELECT
	Name, Population
FROM country
WHERE Population > (
	SELECT
		AVG(Population)
	FROM country
    WHERE Continent = 'Asia'
	)
ORDER BY Population;

# 2. country 테이블의 각 국가마다
#    해당 국가 소속의 평균 인구를 city 테이블을 이용하여 조회
SELECT
	t.Name AS 'country_name',
    (   -- 각 국가에 소속된 시티들의 평균 인구
		SELECT ROUND(AVG(Population),0)
		FROM city
		WHERE CountryCode = t.Code
    ) AS avg_city_pop
FROM country t;

# 3. country 테이블의 Frace의 국가코드를 이용하여
#    city 테이블의 'France'의 모든 도시의 이름 조회
SELECT
	Name
FROM city
WHERE CountryCode = (
		SELECT Code
        FROM country
        WHERE Name = 'France'
      );
      
# * Multi-row Subquery(다중 행 서브쿼리)
# 2. Asia에 속하는 모든 도시를 조회
SELECT
	*
FROM city
WHERE CountryCode IN (
	SELECT Code
    FROM country
    WHERE Continent = 'Asia'
	);

# 국가의 인구가 1,000명 이하인 국가들의
# 국가코드, 도시이름, 도시인구를 조회 
SELECT
	t.Code, c.Name,c.Population
FROM city c
JOIN (
		SELECT Code
        FROM country
        WHERE Population <= 1000) t
	ON t.Code = c.CountryCode;

# * Multi-column Subquery(다중 열 서브쿼리)

# 1. 각 대륙별 독립연도가 가장 최근인 국가의 이름, 대륙, 독립연도를 조회
SELECT
	Name, Continent, IndepYear
FROM
	country
WHERE (Continent, IndepYear) IN (
		SELECT Continent, MAX(IndepYear)
		FROM country
		GROUP BY Continent
		);
