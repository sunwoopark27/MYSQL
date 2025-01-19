-- SELECT SORTING --
# : 데이터를 정렬하여 조회

-- 1. ORDER BY : 조회 결과의 레코드 <정렬>
# < 문법 >
# SELECT
# select_list
# FROM
# table_name
# ORDER BY
# column1 [ASC | DESC],
# column2 [ASC | DESC],...;

# 하나 이상의 칼럼을 기준으로 결과를 오름차순(ASC, 기본값), 내림차순(DESC)으로 정렬
# 정렬에서 NULL값이 존재할 경우, 오름차순 정렬시 결과에 NULL이 먼저 출력

# world db 사용
USE world;

# 1-1. country 테이블에서 GovernmentForm 필드의 데이터를 내림차순으로 정렬하여 조회
SELECT 
    GovernmentForm
FROM 
    country
ORDER BY GovernmentForm DESC;

# 1-2. country 테이블에서 GovernmentForm 필드 기준으로 내림차순으로 정렬한 후
#      SurfaceArea 필드 기준으로 오름차순 정렬하여 조회
SELECT 
	GovernmentForm, SurfaceArea
From 
	country
ORDER BY 
	GovernmentForm DESC, SurfaceArea ASC;

# 1-3. country 테이블에서 Continent 필드가 'Africa'인 데이터 중에 Population 기준으로
#      오름차순 정렬한 후 Name, Population 데이터
SELECT 
    Name, Population
FROM 
    country
WHERE
    Continent = 'Africa'
ORDER BY Population;

# 1-4. country 테이블에서 Continent 필드가 'Africa'인 데이터 중에
#      IndepYear 기준으로 오름차순 정렬할때 NULL 데이터를 마지막에 위치하게 Name, IndepYear 데이터 조회
SELECT
	Name, IndepYear
FROM
	country
WHERE
	Continent = 'Africa'
ORDER BY
	IndepYear IS NULL, IndepYear;
    
-- 2. LIMIT : 조회하는 레코드의 수를 제한
# < 문법 >
# SELECT
# select_list
# FROM
# table_name
# LIMIT
# [offset,] row_count;

# offset은 시작하는 레코드의 위치, 작성하지 않을경우 첫번째레코드부터 반환
# row_count : 조회하는 최대 레코드 수를 지정

# 2-1. country 테이블에서 Name, SurfaceArea, Population 데이터를
#      Population 내림차순 기준으로 top 5 조회
SELECT
	Name, SurfaceArea, Population
FROM 
	country
ORDER BY 
	Population DESC
LIMIT 5; 

# 2-2. country 테이블에서 Name, SurfaceArea, Population 데이터를
#      Population 내림차순 기준으로 6번째부터 12번째 데이터만 조회
SELECT Name, SurfaceArea, Population
FROM country
ORDER BY Population DESC
LIMIT 5, 7;
# LIMIT 7, OFFSET 5;
# 6으로 포함해야하기 떄문에 5/ 출력할 행의 갯수 7

## Grouping
# Aggregate Function(집계함수)

# 1. country 테이블의 전체 행의 수
SELECT count(*) FROM country;

# 2. country 테이블에서 GNP필드에 대하여 NULL값을 제외한 행의 수
SELECT count(GNP) FROM country;

# country 테이블에서
# GNP필드에 대하여 합계, 평균, 분산, 표준편차, 최대값, 최소값을 출력
SELECT 
	SUM(GNP) as 합계, 
    AVG(GNP) as 평균, 
    VARIANCE(GNP) as 분산, 
    STDDEV(GNP) as 표준편차, 
    MAX(GNP) as 최대값, 
    MIN(GNP) as 최소값
FROM country;

## GROUP BY
# HAVING - 그룹화된 결과의 조건지정 (GROUP BY가 없다면 WHERE 절과 비슷하게 동작)

# country테이블에서 Continent 필드를 그룹화
SELECT Continent
FROM country
GROUP BY Continent;

# DISTINCT를 사용한 위와 같은 결과 
SELECT DISTINCT Continent FROM country;

# country테이블에서 Continent 필드를 그룹화하고 전체 행의 수를 카운트
SELECT
	Continent, count(*)
FROM country
GROUP BY Continent
ORDER BY count DESC;

# country 테이블에서 Continent 필드로 그룹화하고
# GNP 평균값을 소수점 2자로 반올림하여 조회하고 이름을 avg_GNP로 출력
SELECT
	Continent,
    round(AVG(GNP),2) as avg_GNP
FROM country
GROUP BY Continent;

# country 테이블에서 Region 필드로 그룹화하고
# 나라의 개수가 15이상 20이하인 데이터를 count_reg로 하여 내림차순으로

SELECT
	Region,
    count(*) as count_reg
FROM country
GROUP BY Region
HAVING count(Region) BETWEEN 15 AND 20
ORDER BY count_reg DESC;
