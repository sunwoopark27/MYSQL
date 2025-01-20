### 데이터베이스 객체
#   : 테이블 외 인덱스, 뷰, 프로시저, 트리거, 함수 등의 객체가 있음
# - 인덱스(INDEX) : 데이터를 빠르게 검색할 수 있도록 돕는 데이터 구조
# - 뷰(VIEW) : "가상"의 테이블로, 하나 이상의 기존 테이블에서 데이터를 보여주는 역할
# - 트리거(TRIGGER) : 데이터 변경 시 자동으로 실행되는 SQL 동작
# - 프로시저(Stored Procedure) : 자주 사용하는 SQL 명령을 저장해두고 호출하는 기능
# - 함수 : 특정 입력에 대해 계산하여 결과를 반환하는 함수

# -- INDEX (ex. 목차, 이진트리)
#   : 데이터베이스에서 데이터를 보다 빠르게 찾기 위해 사용되는 자료구조(주소정보 가지고 있음)
#  - 장점
#  조회하는 속도가 전반적으로 빠름
#  시스템의 부하가 적음
#  - 단점
#  인덱스 정보를 추가로 저장하기 위한 저장공간이 필요
#  삽입, 수정, 삭제가 빈번한 테이블인 경우 성능이 오히려 떨어짐(인덱스 재생성)

# 인덱스의 종류
-- 기본 인덱스
-- # 일반적으로 선언했을 때의 인덱스
-- # 인덱스로 설정된 칼럼의 데이터에 NULL값이 존재할 수 있음
-- # 인덱스가 설정된 칼럼의 데이터에 중복이 있을 수 있음
-- 유니크 인덱스
-- # UNIQUE 키우드와 함께 선언했을 때의 인덱스
-- # 인덱스를 설정할 칼럼의 데이터들은 각각 고유한 값이어야 함(중복데이터가 존재할 시 'Duplicate entry'에러 발생)

# INDEX 생성
# 자주 검색되거나 중복데이터가 적은 칼럼을 Index로 지정
# 데이터가 추가/수정/삭제될 때마다 인덱스를 수정하므로 테이블을 생성할때 지정하는 것이 좋음

# 1. 테이블을 생성할 때 지정
#    PRIMARY/FOREGIN KEY/UNIQUE 제약조건의 칼럼은 자동으로 인덱스 생성됨

# < 문법 >
#CREATE TABLE table_name(
#    col1
#    col2
#    col3
	-- INDEX 키워드 사용
#    INDEX index_name1 (col1),
	-- Key 키워드 사용
# 	 KEY index_name2 (col2)
#);

#2. INDEX 생성
# < 문법 >
-- CREATE [UNIQUE] INDEX 구문 활용
# CREATE INDEX index_name
# ON table_name (col1 [index_type ASC|DESC], col2,...);
-- ALTER TABLE 구문
# ALTER TABLE table_name
# ADD INDEX index_name (col1 [index_type ASC|DESC], col2,...);

# UNIQUE 옵션 : 고유한 인덱스를 만들 때 사용
# index_type : 생략가능하며, 기본값인 B-Tree 사용
# ASC, DESC : 정렬방식 지정, 기본값은 ASC

-- 실습
# world.city 테이블의 인덱스 정보 확인
use world;
SHOW INDEX FROM city;
# 이외에도 schemas 메뉴에 테이블에 랜치모양 아이콘 클릭시
# 밑에 index sheet(맨 밑줄에서 확인 가능)를 눌러 확인할 수 있다.

SELECT * from city; # 하면 인덱스 기준으로 정렬된 것을 볼 수 있다.

# Name INDEX 추가
CREATE INDEX idx_name
ON city(Name DESC);
# DESC 넣으면 다른거 다 만족시 그 다음 네임을 기준으로 내림차순 정렬

## 3. INDEX 삭제 ##
# < 문법 >
# --  DROP 구문 활용
# DROP INDEX index_name ON table_name
# -- ALTER 구문 활용
# ALTER TABLE table_name
# DROP INDEX index_name

DROP INDEX idx_name ON city;

## 4. INDEX 활용 
# 일반 조회시 활용 : 보다 빠르게 검색 가능
# 정렬 시 활용 : 인덱스기준으로 정렬되어 조회됨
# JOIN 시 활용 : 인덱스를 기준으로 JOIN할때 빠르게 검색 JOIN 가능

# 일반 조회 시 활용 ('Seoul'의 모든 정보 조회)
SELECT * FROM city         -- 적용 전 : 0.0030  sec
WHERE Name = 'Seoul';      -- 적용 후 : 0.00045 sec
# 인덱스를 위에 코드를 사용해 생성하고 코드를 돌려보고 시간 비교



