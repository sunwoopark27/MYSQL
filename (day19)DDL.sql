# 데이터 베이스 DDL (DATA DEFINITION LANGUAGE)
# - CREATE TABLE : 테이블 생성
# - ALTER TABLE  : 테이블 수정
# - DROP TABLE or DATABASE : 테이블 이나 데이터베이스 삭제
#                            FOREIGN KEY 설정되어 있는 경우, 해당 조건 해제 후 삭제 가능
# - TRUNCATE TABLE : 테이블을 삭제한 후 재 생성
#                    DROP 와 유사하지만 Table을 DROP후 재생성하기 때문에 ID(PK)값이 초기화됨

use db;
## CREATE

CREATE TABLE examples (
    ExamId INT PRIMARY KEY AUTO_INCREMENT,
    LastName VARCHAR(50) NOT NULL,
    FirstName VARCHAR(50)
);

## ALTER
# <문법>
# ALTER TABLE table_name(고정)
# - 칼럼 추가
# ADD COLUMN col_name 컬럼 정의(create 할 때 처럼);
# - 칼럼명 변경
# RENAME COLUMN con_name TO new_col_name;
# - 테이블명 변경
# RENAME TO new_table_name;
# - 칼럼 삭제
# DROP COLUMN col_name;
# - 제약조건 추가
# ADD CONSTRAINT constraint_name constraints;
# 1. examples 테이블에 Country 필드 추가 (varchar(100) NOT NULL)
ALTER TABLE examples
ADD COLUMN Country VARCHAR(100) NOT NULL DEFAULT 'default value';

# 2. examples 테이블에 Age, Address 필드 추가
#    Age : int, not null, 기본값은 0
#    Address : 가변길이문자(100), not null, 기본값은 'default value'
ALTER TABLE examples
ADD COLUMN
		(Age INT NOT NULL DEFAULT 0,
        Address VARCHAR(100) NOT NULL DEFAULT 'default value');
        
# 3. 컬럼의 이름 변경(Address를 PostCode로 변경)
ALTER TABLE examples
RENAME COLUMN Address TO PostCode;

# 4. 테이블 이름 변경 (examples를 new_examples로 변경)
ALTER TABLE examples
RENAME TO new_examples;

# 5. 컬럼 삭제 (age 컬럼 삭제)
ALTER TABLE new_examples
DROP COLUMN Age;

# 6. 제약조건 추가 (employee 테이블의 store_id를 FK로 추가 설정)
ALTER TABLE new_examples
ADD CONSTRAINT FOREIGN KEY (store_id) REFERENCES store(store_id);

## DROP

# <문법>
# - DROP TABLE table_name;
# - DROP DATABASE database_name;
# - DROP DATABASE IF EXISTS database_name;

# ** foriegn key 가 존재한다면 먼저 삭제 후 테이블 삭제 가능
# 		ALTER TABLE table_name
# 		DROP FOREIGN KEY fk_constraint_name;

# ** CONTSTRAINT 이름 찾기
# SELECT CONSTRAINT_NAME
# FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
# WHERE TABLE_NAME = 'table_name' AND TABLE_SCHEMA = 'database_name';



# 1. new_examples 테이블 삭제
DROP TABLE new_examples;

## TRUNCATE
# <문법>
# TRUNCATE TABLE table_name;

# ++ SHOW
# - DB 목록 확인
#   : SHOW DATABASES;
# - 테이블 목록 확인
#   : SHOW TABLES;
#   : SHOW FROM db_name;
