## DML(DATA MANIPULATION LANGUAGE) : 데이터 조작어

# update를 자유롭게 할 수 있도록 설정
# save update 비활성화
# SET GLOBAL SQL_SAFE_UPDATES = 0;
# save update 활성화
# SET GLOBAL SQL_SAFE_UPDATES = 1;

# - INSERT : 데이터 삽입
# - SELECT : 데이터 조회
# - UPDATE : 데이터 수정
# - DELETE : 데이터 삭제

## INSERT
# <문법>
# INSERT INTO table_name (c1, c2, ..)
# VALUES (v1, v2, ...);
# - INSERT INTO 절: 다음에 테이블이름, 괄호안에 필드목록 작성
# - VALUES 키워드: 괄호안에 해당 필드에 삽입할 값 목록 작성
# - date/time 형식의 데이터는 "NOW()함수" 이용하여 현재 시간 추가 가능
use test;
# 1. 직원정보 테이블에 name = 'sunmee' group_id = 1 추가
INSERT INTO employee (name, group_id, pay, store_id)
VALUES('sunwoo', 1, 20000, 1);

# 2. 여러개의 데이터 추가
INSERT INTO employee (name, group_id)
VALUES
 ('gildong', 1),
 ('nolbu', 0),
 ('lucky', 1);

# 3. 매장관리 테이블에 다음과 같은 데이터 추가
INSERT INTO store (store_name, store_time, store_id)
VALUES ('star', '2025-01-19 08:00:00',2);

# 4. # NOW()를 이용한 데이터 추가
INSERT INTO store (store_name, store_time, store_id)
VALUES ('maximum', NOW(), 3);


## UPDATE

# <문법>
# UPDATE table_name
# SET col_name = expression
# WHERE condition;
# - SET절: 수정할 필드와 새값 지정
# - WHERE절: 수정할 레코드를 지정하는 조건 / WHERE를 작성하지 않으면 모든 레코드를 수정

# 1. 직원관리 테이블에서 'sunmee'의 그룹ID를 '0'으로 변경
UPDATE employee
SET group_id = 0
WHERE name = 'sunwoo';

# 2. 직원정보 테이블에서 4번 레코드의 이름과 임금을 동시에 변경
UPDATE employee
SET name = 'sun', pay=300000
WHERE emp_id = 9;

# 3. 직원정보 테이블에서 모든 레코드의 pay를 0으로 변경
UPDATE employee
SET pay=0; #check 옵션으로 인해 변경 불가

## DELETE

# <문법>
# DELETE FROM table_name
# WHERE condition;

# 1. 고객정보에서 devil 레코드 삭제
DELETE FROM employee
WHERE
    name='devil';
    
## SELECT
