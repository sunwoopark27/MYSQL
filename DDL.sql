# 데이터 베이스 DDL 
# - CREATE TABLE : 테이블 생성
# - ALTER TABLE  : 테이블 수정
# - DROP TABLE or DATABASE : 테이블 이나 데이터베이스 삭제
# - TRUNCATE TABLE : 테이블을 삭제한 후 재 생성
#                    Table을 DROP후 재생성하기 때문에 ID(PK)값이 초기화됨

  
use db;

#테이블 생성
CREATE TABLE examples (
    ExamId INT PRIMARY KEY AUTO_INCREMENT,
    LastName VARCHAR(50) NOT NULL,
    FirstName VARCHAR(50)
);

# examples 테이블에 Country 필드 추가 (varchar(100) NOT NULL)
ALTER TABLE examples
ADD COLUMN Country VARCHAR(100) NOT NULL DEFAULT 'default value';

# examples 테이블에 Age, Address 필드 추가
# Age : int, not null, 기본값은 0
# Address : 가변길이문자(100), not null, 기본값은 'default value'
ALTER TABLE examples
ADD COLUMN
		(Age INT NOT NULL DEFAULT 0,
        Address VARCHAR(100) NOT NULL DEFAULT 'default value');
        
# 컬럼의 이름 변경(Address를 PostCode로 변경)
ALTER TABLE examples
RENAME COLUMN Address TO PostCode;

# 테이블 이름 변경 (examples를 new_examples로 변경)
ALTER TABLE examples
RENAME TO new_examples;

# 컬럼 삭제 (age 컬럼 삭제)
ALTER TABLE new_examples
DROP COLUMN Age;

# 제약조건 추가 (employee 테이블의 store_id를 FK로 추가 설정)
ALTER TABLE new_examples
ADD CONSTRAINT FOREIGN KEY (store_id) REFERENCES store(store_id);
