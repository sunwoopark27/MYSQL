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
