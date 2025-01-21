### Cursor (커서)
# 테이블에서 한행씩 처리
# 첫번째 행부터 마지막행까지 한행씩 접근하여 값을 반환
# Stored Procedure 내부에서 활용 가능

# 동작과정
--  1. 사용한 변수 지정 (출력을 위한 변수)
# DECLARE name data_type DEFAULT value; --default라는 이름으로
-- 2. 커서 선언 (반복할 행 지정)
# DECLARE cursor_name CURSOR FOR -- 커서 이름 
# SELECT col_name FROM table_name; -- 여러 행이 나오면 한 줄 씩 볼거야.
-- 3. 반복조건 지정 -- 약간 while 문 조건같은!
# DECLARE CONTINUE HANDLER
# FOR NOT FOUND SET condition;
-- 4. 커서를 열기
# OPEN cursor_name;
-- 5. 행 반복
# cursor_loop : LOOP
# <반복할 내용>
# [LEAVE cursor_loop]
# END LOOP cursor_loop;
-- 6. 커서 닫기
# CLOSE cursor_name;

# market DB의 member 테이블에 대하여
# 회원의 평균 인원수를 계산하기 위한 커서 활용 예제
DELIMITER $$
CREATE PROCEDURE cursor_proc()
BEGIN
    -- 필요한 변수 선언
    DECLARE memNumber INT;                  -- 각 회원의 인원수 변수 선언
    DECLARE cnt INT DEFAULT 0;              -- 읽은 행의 수 카운트하는 cnt 선언, 초기값 0으로 설정
    DECLARE totalNumber INT DEFAULT 0;      -- 전체 회원의 인원의 합을 저장하는 totalNumber 선언하고, 초기값 0으로 설정
    DECLARE endOfRow BOOLEAN DEFAULT FALSE; -- 행이 끝인지 확인하는 endOfrow 선언, 초기값은 FALSE 로 설정(마지막 행이 아니니까)
    
    -- 커서 선언 
    DECLARE memCursor CURSOR FOR
        SELECT mem_number FROM member;
	
    -- 반복조건 선언(행이 끝나면 endOfRow 변수를 TRUE로 변경)
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET endOfRow = TRUE;
        
	-- 커서 열기
    OPEN memCursor;  
    
    -- 행 반복
    cursor_loop: LOOP
        FETCH  memCursor INTO memNumber;  -- memberCuror이거 가져와서 memNumber 여기에
        IF endOfRow THEN                    -- endOfRow가 TRUE 되면 loop 빠져나가
            LEAVE cursor_loop;
        END IF;
        SET cnt = cnt + 1;                  -- 한 행 씩 불러준다.
        SET totalNumber = totalNumber + memNumber;
    END LOOP cursor_loop;
    
    SELECT (totalNumber/cnt) AS '회원의 평균 인원 수';
    CLOSE memCursor;
END $$
DELIMITER ;

-- procedure 니가 call 해서 가져옴 
CALL cursor_proc();
