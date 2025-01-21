### Trigger (트리거)
# INSERT, UPDATE, DELETE문이 작동할 때 자동으로 실행되는 코드
# DML문의 이벤트가 발생하때 테이블에 미리 부착되는 SQL 코드
# 임시테이블 NEW, OLD를 이용하여 데이터 내부적으로 관리
# UPDATE,DELETE는 기존 데이터는 OLD 테이블에, 새로운 데이터는 NEW테이블에 (OLD DATA 백업)
# BEFORE, AFTER 트리거를 설정할 수 있으며, 일반적으로 AFTER 트리거를 많이 사용

# Trigger 생성
# < 문법 > 
-- DELIMITER $$    -- $$로 처음과 끝 구분자 만들기
-- CREATE TRIGGER trigger_name
-- BEFORE/AFTER INSERT/UPDATE/DELETE
-- ON trigger_table_name
-- FOR EACH ROW
-- BEGIN
-- sql_statement   -- SQL 쿼리 그대로 사용
-- END $$
-- DELIMITER ;

# DELIMITER : 구분자 변경(코드블록 구분)
# sql_statement
# : INSERT/UPDATE/DELETE에 대하여 실행전과 후에 메시지 출력 가능( BEFORE INSERT / AFTER UPDATE 등)
#  메세지 출력 코드 => SET @msg = 'message to show'

# : 데이터 삭제또는 수정시 기존 데이터를 백업 테이블에 저장하도록 설정 가능
# INSERT INTO backup_table
# VALUES (OLD.col1, OLD_col2, ..., mod_type, mod_date, mod_user..); 
-- 다 OLD -- mode type(수정 삭제 중 뭔지) -- mode date( 수정 날짜) -- mode user(누가 바꾼건지)


# Trigger 수정 : 직접적인 수정하는 명령어가 없어 삭제 후 재생성
# Trigger 삭제
# <  문법 >
-- DROP TRIGGER IF EXISTS backup_staff_update;

use coffee;
# < IN workbench>
# 왼족 스키마들에 테이블에 마우스 대면 세가지 모양중 랜치 모양을 눌러 생성된 창의 맨 밑에
# Trigger 눌러서 직접 +, - 로 추가 하고 삭제할 수 있다.

# staff 백업테이블 생성
CREATE TABLE backup_staff(
	staff_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    position VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    location VARCHAR(50) NOT NULL,
    mod_type CHAR(6) NOT NULL, -- 수정타입
    mod_date DATETIME NOT NULL,
    mod_user VARCHAR(50) NOT NULL
    );

# UPDATE 에 대한 after trigger 생성
DELIMITER $$
CREATE TRIGGER update_backup_staff
	AFTER UPDATE -- after update다
    ON staff -- staff에 적용 
    FOR EACH ROW -- 모든 row에 대해
BEGIN
	INSERT INTO backup_staff VALUES( -- 위의 테이블에 넣을게
		 OLD.staff_id,
         OLD.first_name,
         OLD.last_name,
         OLD.position,
         OLD.start_date,
         OLD.location,
         'update',
         NOW(),
         CURRENT_USER()); -- 현재 작성한 사람
END $$
DELIMITER ;
# staff 테이블에 랜치 아이콘을 눌러 메뉴 중 Trigger에 들어가면 트리거가 생성된 것을 확인할 수 있다.

# UPDATE
UPDATE staff
SET first_name = 'lim'
WHERE staff_id = 55;

SELECT * FROM backup_staff;

# after Delete trigger 생성
DELIMITER $$
CREATE TRIGGER backup_staff_delete
    AFTER DELETE
    ON staff
    FOR EACH ROW
BEGIN
    INSERT INTO backup_staff VALUES (
        OLD.staff_id,
        OLD.first_name,
        OLD.last_name,
        OLD.position,
        OLD.start_date,
        OLD.location,
        'delete',
        CURDATE(),
        CURRENT_USER() );
END $$
DELIMITER ;

use coffee;
DELETE FROM staff WHERE staff_id = 55;
SELECT * FROM staff WHERE staff_id = 55;
SELECT * FROM backup_staff WHERE staff_id = 55; -- mod_type이 delete인것 확인(위에서 delete 했음)

# trigger 삭제 
DROP TRIGGER IF EXISTS staff_AFTER_INSERT;
DROP TRIGGER delete_backup_staff;


