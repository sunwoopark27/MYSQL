-- 실습 --
# 1. world DB의 city 테이블을 이용하여
# 국가별 도시 수 조회하는 프로시저 만들기
use world;

DROP PROCEDURE city_count;
DELIMITER $$
CREATE PROCEDURE city_count()
BEGIN
	SELECT t.Name, COUNT(c.Name)
	FROM city c
	JOIN country t
		ON c.CountryCode = t.Code
	GROUP BY CountryCode;
END $$
DELIMITER ;
-- version 2 간단!
DELIMITER $$
CREATE PROCEDURE city_count(IN country_code char(3))
BEGIN
	SELECT count(*)
    FROM city
    WHERE CountryCode = country_code;
END $$
DELIMITER ;

CALL city_count("KOR");


# 2. world DB의 city 테이블과 이용하여
# 특정 인구 이상의 도시 검색하는 프로시저 만들기alter
DROP PROCEDURE population_search;
DELIMITER $$
CREATE PROCEDURE population_search(IN num INT)
BEGIN
	SELECT Name, Population
    FROM city
    WHERE Population >= num
    ORDER BY Population;
END $$
DELIMITER ;

CALL population_search(100000);

# 3. world DB의 countrylanguage 테이블을 이용하여
# 국가의 공식 언어 조회하는 프로시저 만들기
DROP PROCEDURE country_language;
DELIMITER $$
CREATE PROCEDURE country_language(IN country_code CHAR(3))
BEGIN
	SELECT 
		CountryCode, 
		GROUP_CONCAT(Language) as 'Languages'
	FROM countrylanguage
	WHERE CountryCode = country_code AND IsOfficial = 'T'
	GROUP BY CountryCode; -- GROUP_CONCAT쓰려면
END $$
DELIMITER ;

CALL country_language("KOR");

# 4. world DB의 city와 country 테이블과 이용하여
# 도시 인구 비율 계산 함수 (도시인구/해당 국가의 인구)
# 강사님께 더 나음.
-- 이진로그를 활성화하여 함수의 특성(DETERMINISTIC, NO SQL 등)을
-- 명시하지 않아도 동작할 수 있도록 설정
-- SET GLOBAL log_bin_trust_function_creators = 1;
DELIMITER $$
CREATE FUNCTION cityPopulationRateFunc(cityPop INT, countryPop INT)
	RETURNS VARCHAR(50)
BEGIN
	DECLARE populationRate FLOAT;    -- 인구 비율 저장하는 변수 선언
    SET populationRate = cityPop / countryPop * 100;
    RETURN CONCAT(populationRate, '%');
END $$
DELIMITER ;

SELECT 
	t.Name as CountryName,
    c.Name as CityName, 
    cityPopulationRateFunc(c.Population,t.Population) as Rate
FROM city c
JOIN country t
	ON c.CountryCode = t.Code;

# 5. world DB의 countrylanguage 테이블을이용하여
# 국가에 대하여 공용어 사용 비율 계산 함수 만들기

DELIMITER $$
CREATE FUNCTION countryLanguageRate(country_code VARCHAR(5))
	RETURNS FLOAT
BEGIN
END $$
DELIMITER ;

# 6. world DB의 city 테이블을 이용하여
# 국가별 도시 수 조회하는 프로시저를 커서를 활용하여 만들기
DELIMITER $$
CREATE PROCEDURE CursorCityCount()
BEGIN
	DECLARE cityNum INT;                   -- 국가의 도시 수 
    DECLARE cnt INT DEFAULT 0;             -- 읽은 행의 수
    DECLARE totalNum INT DEFAULT 0;        -- 도시의 수 합계
    DECLARE endOfRow BOOLEAN DEFAULT FALSE;-- 행의 끝 여부 (기본 FALSE)
    
    DECLARE cityCursor CURSOR FOR
		SELECT CountryCode FROM city;
	
    DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET endOfRow = TRUE;
        
	OPEN cityCursor;
    
    cursor_loop : LOOP
		FETCH cityCursor INTO cityNum;
        IF endOfRow THEN
			LEAVE cursor_loop;
		END IF;
        SET cnt = cnt + 1;
        IF cityNumBefore = cityNum THEN
			SET totalNum = totalNum + 1;
		END IF;
        IF cityNumBefore != cityNum THEN
			SET cityNumBefore = cityNum;
		END IF;
	END LOOP cursor_loop;
END $$
DELIMITER ;

-- 강사님 --

# 1. world DB의 city 테이블을 이용하여
# 국가별 도시 수 조회하는 프로시저 만들기
# 1) 코드로 조회 
use world;
DROP PROCEDURE city_count_by_country;
DELIMITER $$
CREATE PROCEDURE city_count_by_country(IN country_Code CHAR(3), OUT city_count INT)
BEGIN
	SELECT COUNT(*) INTO city_count
    FROM city
    WHERE CountryCode = country_Code;  -- 입력받은것과 같게
END $$
DELIMITER ;

# 2) 이름으로 조회
DELIMITER $$
CREATE PROCEDURE city_count_by_country_name (IN country_name CHAR(52))
BEGIN
    SELECT COUNT(*)
    FROM city c
    JOIN country t
    ON c.CountryCode = t.Code
    WHERE t.Name = country_name;
END $$
DELIMITER ;

CALL city_count_by_country_name("South Korea");

CALL city_count_by_country("KOR",@count);
SELECT @count;

# 2.world DB의 city 테이블과 이용하여
# 특정 인구 이상의 도시 검색하는 프로시저 만들기

--  위에 내가 한 것과 같음

# 3. world DB의 countrylanguage 테이블을 이용하여
# 국가의 공식 언어 조회하는 프로시저 만들기
-- 위에와 같음 (GROUP_CONCAT은 사용안하긴함)

# 4. world DB의 city와 country 테이블과 이용하여
# 도시 인구 비율 계산 함수 (도시인구/해당 국가의 인구)

# 한번에 INTO를 두번 쓰면 오류나기 때문에 두번의 SELECT 문으로 넣어줌
DELIMITER $$
CREATE FUNCTION city_pop_percentage(city_name VARCHAR(35))
RETURNS DOUBLE
BEGIN
    DECLARE city_pop INT;
    DECLARE country_pop INT;
    
    SELECT Population INTO city_pop
    FROM city 
    WHERE Name = city_name;
    
    SELECT Population INTO country_pop
    FROM country
    WHERE Code = (SELECT CountryCode FROM city WHERE Name = city_name);

    RETURN (city_pop/country_pop) *100;
END $$
DELIMITER ; 

SELECT city_pop_percentage("Seoul");

# 5. world DB의 countrylanguage 테이블을이용하여
# 국가에 대하여 공용어 사용 비율 계산 함수 만들기
DELIMITER $$
CREATE FUNCTION official_percent(country_code VARCHAR(5))
	RETURNS DOUBLE
BEGIN
	DECLARE count_lang INT;
    DECLARE official_lang INT;
    
    SELECT COUNT(*) INTO count_lang
    FROM countrylanguage
    WHERE CountryCode = country_code;
    
    SELECT COUNT(*) INTO official_lang
    FROM countrylanguage
    WHERE CountryCode = country_code AND IsOfficial = 'T';
    
    RETURN ROUND((official_lang/count_lang) * 100 ,4);
END $$
DELIMITER ;

# function 사용
SELECT official_percent('KOR'); -- 50이 나오는데 이건 언어 두개라서! 50:50 느낌 
# 확인 
SELECT * FROM countrylanguage WHERE CountryCode='KOR';

# 사용 비율을 퍼센테이지로 제대로!!!
-- version 2

DELIMITER $$
CREATE FUNCTION official_percentage(country_code CHAR(3))
RETURNS DOUBLE
BEGIN 
    DECLARE official_percent DOUBLE;
    
    SELECT AVG(Percentage) INTO official_percent
    FROM countrylanguage
    WHERE CountryCode = country_code AND IsOfficial ='T';
    
    RETURN ROUND(official_percent,2);
END $$
DELIMITER ;

SELECT official_percentage('KOR');

# 6. world DB의 city 테이블을 이용하여
# 국가별 도시 수 조회하는 프로시저를 커서를 활용하여 만들기
DROP PROCEDURE cursor_count_cities;
DELIMITER $$
CREATE PROCEDURE cursor_count_cities(IN country_code CHAR(3))
BEGIN
    DECLARE endOfRow BOOLEAN DEFAULT FALSE;
    DECLARE city_id INT;
    DECLARE cnt INT DEFAULT 0;
    
    DECLARE city_cursor CURSOR FOR
        SELECT ID FROM city WHERE CountryCode=country_code;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET endOfRow = TRUE;
    
    OPEN city_cursor;
    
    cursor_loop : LOOP
        FETCH city_cursor INTO city_id;
        
        IF endOfRow THEN 
            LEAVE cursor_loop;
        END IF;
        
        SET cnt = cnt + 1;
    END LOOP cursor_loop;
    
    SELECT (cnt) AS "국가의 도시의 개수";
    
    CLOSE city_cursor;
END $$
DELIMITER ;

CALL cursor_count_cities("KOR");
