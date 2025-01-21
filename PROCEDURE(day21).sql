-- Procedure --
--  반복적인 작업, 복잡한 로직 처리, 트랜잭션 관리 등에 유용
## 메뉴바 Stored Procedure 을 찾아 볼 수 있다.
USE market;
# market DB에서 member테이블에서
# mem_name를 입력하였을때 고객 정보 데이터 조회 함수
DELIMITER $$
CREATE PROCEDURE proc_mem_info(IN userName VARCHAR(10))
BEGIN
  SELECT * FROM member WHERE mem_name = userName;
END $$
DELIMITER ;

# 프로시저 호출
CALL proc_mem_info('블랙핑크');

# 프로시저 삭제 
DROP PROCEDURE IF EXISTS proc_mem_info;

# IF-ELSE문을 사용한 프로시저
# 정보가 없으면 정보가 없다고 출력, 있다면 데뷔연도에 따라 메시지 출력
# 데뷔연도가 2015년 이전이면 고참가수, 이후이면 신인가수 출력

DELIMITER $$
CREATE PROCEDURE ifelse_proc(
    IN memName VARCHAR(10)
)
BEGIN
    DECLARE debutYear INT;              -- 변수 선언
    SELECT YEAR(debut_date) into debutYear FROM member -- year정보 내가 만든 변수에 넣어줌
        WHERE mem_name = memName;
    IF debutYear IS NULL THEN   -- 변수가 null값이면
        SELECT CONCAT(memName,'에 대한 정보가 없습니다.') AS '메시지';
    ELSE
        IF (debutYear >= 2015) THEN
            SELECT CONCAT(memName,'는 신인가수입니다.') AS '메시지';
        ELSE
            SELECT CONCAT(memName,'는 고참가수입니다.') AS '메시지';
        END IF;
    END IF;
END $$
DELIMITER ;

CALL ifelse_proc('소녀시대');
CALL ifelse_proc('뉴진스');

# while문을 사용한 프로시저
# 1부터 num까지의 합계를 구하는 함수
DELIMITER $$
CREATE PROCEDURE while_proc(IN num INT, OUT result INT)
BEGIN
    SET result = 0;                -- 합계 초기화
    WHILE (num >= 1) DO            -- while문 실행 (num이 1까지 반복)
        SET result = result + num; -- result에서 + num을 result로 할당
        SET num = num - 1;         -- num-1을 num으로 저장
    END WHILE;
END $$
DELIMITER ;

CALL while_proc(100, @sum); -- 가지고 와서
SELECT @sum;                -- select 해줘야함

-- Stored Function --
# : 내장함수외 사용자가 정의하는 함수
-- procedure와의 차이 --
-- 내용에 insert, update, delete 와 같은 아이들은 사용 불가
-- return이 반드시 존재해야 합니다! 
# workbench schemas 메뉴바에 스키마 밑에 Functions 에 생성된다. 

# 1. 함수 생성
# < 문법 >
-- DELIMITER $$
-- CREATE FUNCTION function_name(입력변수)
-- 		RETURNS return_data_type
-- BEGIN
-- 		RETURN return_data_name;
-- END $$
-- DELIMITER ;
# RETURNS 예약어를 통해 하나의 값을 반환

# 2. 함수 활용
# < 문법 >
# SELECT function_name() 
# *** 이진로그를 활성화하여 함수의 특성(DETERMINISTIC, NO SQL 등)을
# 명시하지 않아도 동작할 수 있도록 설정 -- 안전하지 않아도 저장을 하겠다.(DETERMINISTIC(사용자 정의))
-- 저장함수를 사용할 수 있도록 이진로그 함수 생성 (1로 변경) (warning 이 나오긴 함)
SET GLOBAL log_bin_trust_function_creators = 1; 

# 3. 함수 삭제
# < 문법 >
# DROP FUNCTION function_name;

# 4. 함수 수정
# : 직접적인 수정하는 명령어가 없어 삭제 후 재생성

# 두개의 숫자를 더하는 함수
DELIMITER $$
CREATE FUNCTION sumFunc(number1 INT, number2 INT)
    RETURNS INT
BEGIN
    RETURN number1 + number2;
END $$
DELIMITER ;

SELECT sumFunc(55, 3);

# marketDB의 member에서
# 데뷔연도를 기준으로 활동기간(연도)가 몇년인지 출력하는 함수
DELIMITER $$
CREATE FUNCTION calcYearFunc(dYear INT)
    RETURNS INT
BEGIN
    DECLARE runYear INT;                    -- 활동기간(연도)
    SET runYear = YEAR(CURDATE()) - dYear;  -- 현재 연도 - 데뷔연도 계산
    RETURN runYear;
END $$
DELIMITER ;

# 2010년이 데뷔연도일 경우
SELECT calcYearFunc(2010) AS '활동기간(연도)';

# 함수 삭제
Drop FUNCTION calcYear;

# member 테이블의 데뷔연도를 기준으로 활동기간 출력
SELECT
    mem_id, mem_name,
    calcYearFunc(YEAR(debut_date)) AS '활동기간(연도)'
FROM member;

