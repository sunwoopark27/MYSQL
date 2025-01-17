# Day 19
## JOIN ##

# - INNER JOIN : 교집합
# - OUTER JOIN
#   - RIGHT JOIN : 두가지 중 오른쪽에 맞춰서 
#   - LEFT JOIN : 두가지 중 왼쪽에 맞춰서 LEFT를 기준으로 없는 아이들은 NULL로 들어감
#	- SELF (INNER) JOIN : 동일한 것을 가져와서 조인 RIGHT 기준으로 없는 아이들은 NULL로 들어감
#   - CROSS JOIN

# (정규화 - 불필요한 아이들이 같은 테이블에 있지 않고 나눠 놓아서 정리한 것)
# 그렇기 때문에 한꺼번에 보고 싶을 때, 조회할 때 사용한다.

# MySql에서 제공하는 example data 중 sakila DB 사용
use sakila;

select count(*) from country;

# 1. sakila.city에서 city id가 113인 도시명과 국가명을 확인
SELECT city.city, country.country
FROM city, country
WHERE city.country_id = country.country_id
	AND city_id=113;
    
# 1-1. FROM 절에 city와 country를 조인하면서 두개의 약칭을 c와 t로 정의한다.
SELECT c.city, t.country
FROM city c, country t
WHERE c.country_id = t.country_id
	AND city_id=113;

## JOIN 실습 ##
# market db 를 사용하겠다.(다운로드함/ 다운로드 파일에 있음)
use market;

# **INNER JOIN
# <문법>
#SELECT
#	select_list
#FROM # 메인 테이블 지정 
#	table_main 
#INNER JOIN table_join #조인할 테이블 지정
# ON table_main.fk = table_join.pk; #어떤 테이블의 컬럼들이 동일하게 맞는건지

# 1. 주문테이블에서 GRL이라는 아이디를 가진 사람의
#    구매정보와 고객정보 통합 조회

# inner join은 교집합이기 때문에 메인테이블과 조인테이블을 바꿔도 차이 없기 때문에 메인테이블의 길이(양)가 짧은 것으로 많이 설정
SELECT *
FROM buy b 
INNER JOIN member m
	ON b.mem_id = m.mem_id
WHERE b.mem_id = 'GRL';

# 2.전체 회원 ID에 대하여
#   아이디/이름/구매한제품/연락처(phone1과 phone2 합쳐서 출력)을 조회
SELECT
	m.mem_id, m.mem_name, b.prod_name,
	concat(m.phone1,m.phone2) as '연락처'
FROM member m
INNER JOIN buy b
	ON b.mem_id = m.mem_id;
    
# **LEFT JOIN - LEFT를 기준을 없는 아이들은 NULL로 들어감 
# <문법>
#SELECT
#	select_list
#FROM
#	table_left
#LEFT JOIN table_right
#	ON table_left.pk = table_right.fk;

# 1. 전체 회원의 구매목록 조회(구매이력이 없는 회원정보도 함께)
SELECT
	m.mem_id, m.mem_name, b.prod_name,
	concat(m.phone1,m.phone2) as '연락처'
FROM member m
LEFT JOIN buy b
	ON m.mem_id = b.mem_id
ORDER BY b.prod_name; #NULL값부터 출력

# 2. 구매이력이 없는 회원명과 전화번호 조회
SELECT
	m.mem_name,
	concat(m.phone1,m.phone2) as '연락처'
FROM member m
LEFT JOIN buy b
	ON m.mem_id = b.mem_id
WHERE b.prod_name IS NULL; 

# 3. 구매 이력의 모든 회원 정보 조회(아이디/이름/구매제품/주소/연락처)
SELECT
	m.mem_name, m.mem_name, b.prod_name, m.addr,
	concat(m.phone1,m.phone2) as '연락처'
FROM member m
RIGHT JOIN buy b
	ON m.mem_id = b.mem_id;

# 3. 구매 이력이 가장 높은 회원 정보 조회(아이디/이름/연락처)
SELECT
	m.mem_id,m.mem_name,
	concat(m.phone1,m.phone2) as '연락처'
FROM member m
RIGHT JOIN buy b
	ON m.mem_id = b.mem_id
GROUP BY mem_id
ORDER BY COUNT(b.prod_name) DESC
LIMIT 1;


