### DCL(Data Control Language) : 데이터 사용권한 관리에 사용되는 언어
# 1. 사용자 추가
# < 문법 >
# CREATE USER 'username'@'host' IDENTIFIED BY 'password';
# username : 생성할 사용자의 이름
# host : 사용자가 접속할 수 있는 호스트
#    - localhost : 같은 서버에서만 접속
#    - % : 모든 호스트에서 접속가능
#    - 특정 IP : 특정IP에서만 접속 허용
# password : 사용자의 비밀번호

CREATE USER 'sunwoo'@'localhost' IDENTIFIED BY '1234';

-- workbench home 화면에서 + 버튼을 눌러 포트 추가
-- 호스트는 'localhost', 접속자 name은 'sunwoo' 로 하고 비밀번호 1234 누르면 박스하나 더 생성
-- 그 안에 스키마(디비)는 아무것도 없는 것을 볼 수 있다.

# 2. GRANT
# 사용자에게 특정 테이블이나 DB에 권한 부여
# < 문법 >
# GRANT privilege ON db_name.table_name TO 'user'@'host';
# privilege(권한) : ALL PRIVILEGES, SELECT, INSERT, UPDATE 등

# 2-1. 모든 권한 부여
# GRANT ALL PRIVILEGES ON *.* TO 'username'@'localhost';
GRANT ALL PRIVILEGES ON *.* TO 'sunwoo'@'localhost';

# 2-2. 특정 데이터베이스의 특정 테이블에 대한 권한 부여
# GRANT SELECT, INSERT, UPDATE ON db_name.table_name TO 'username'@'localhost';
# GRANT SELECT, INSERT, UPDATE ON *.* TO 'sunwoo'@'localhost';

# 2-3. 특정 데이터베이스의 모든 테이블에 대한 권한 부여
# GRANT SELECT, INSERT, UPDATE ON db_name.* TO 'username'@'localhost';

# 2-4. 권한 확인
# SHOW GRANTS FOR 'username'@'localhost';
show grants for 'sunwoo'@'localhost';

# 2-5. 권한 변경사항 적용 
# mysql에서는 바로 적용됨!
# FLUSH PRIVILEGES;

# 2-6. 사용자 리스트 확인
SELECT user, host FROM mysql.user;

# 3. REVOKE
# : 사용자에게 부여된 특정 권한을 회수
# < 문법 >
# REVOKE privilege ON db_name.table_name FROM 'user'@'host';

# username : 생성할 사용자의 이름
# host : 사용자가 접속할 수 있는 호스트
#	- localhost : 같은 서버에서만 접속
#	- % : 모든 호스트에서 접속가능
#	- 특정 IP : 특정IP에서만 접속 허용
#password : 사용자의 비밀번호


# INSERT, UPDATE 권한 삭제
# 모든 권한 삭제 (한번에 * 로 모든 권한을 부여했다면 이렇게 다 삭제해야함)
REVOKE ALL PRIVILEGES ON *.* FROM 'sunwoo'@'localhost';

# 다시 부여하고(SELECT, INSERT, UPDATE 만)
GRANT SELECT, INSERT, UPDATE ON *.* TO 'sunwoo'@'localhost';

# 권한 삭제
REVOKE INSERT,UPDATE ON *.* FROM 'sunwoo'@'localhost';

# 3. DROP : 사용자 삭제
#           해당 사용자에 대한 권한 및 관련 정보 함께 삭제
# 접속 하고 있을 경우 삭제가 안될 수 있다.
# < 문법 > 
# DROP USER 'username'@'host';
DROP USER 'sunwoo'@'localhost';



