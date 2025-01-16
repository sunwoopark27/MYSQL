# MYSQL

MYSQL WORKBENCH

윗 줄<br>
파일 아이콘 : SQL 파일 불러오기
디스크 모양: 저장 
번개 모양 : 전체 실행 (Ctrl+ Shift+Enter)
번개 모양 +  커서(I) : 지금 커서가 있는 줄만 실행(Ctrl+Enter)
엑스 모양(빨간색): 틀린줄 알려줌
LImit to 1000rows : 결과물을 몇줄 보여줄지 설정

왼쪽 면

Administrations 랑 Schemas 탭 있음

Schemas Tap
	
동전 쌓여있는 아이콘 : database(Schema)볼 수 있음!
스키마 밑에는 테이블들을 볼 수 있음
-> 테이블들에 마우스 올려두면
   세개의 아이콘 (  i , 레고손, 네모)
레고손 :  여기서 직접 column 추가나 수정가능
네모: 결과 테이블을 보여줌

Administrations Tap

Data Import 
: SQL 파일을 가져올 수 있음
O Import form  Self-Constrained File 선택해 다운받은 sql 파일 가져옴
New.. 버튼 눌러서 Database(Schema) 이름을 설정할 수 있다.
Import 버튼 누르면 끝
그리고 생성된 스키마 탭에 데이터 베이스(스키마)에서 왼쪽 마우스를 누르고
“ Table Data Import Wizard” 눌러서 csv파일이나 json 파일을 가져와 데이터를 넣을 수 있다. (**디비명, 테이블명 선택 가능**)

Data Export
: 데이터를 추출해 저장
스키마(디비)들이 나옴 
저장할 것들 체크 (디비랑 테이블)
DumpStructure and Data => 구조랑 데이터 같이 가져오는 것(알아서 선택)
O Export to Self-Contained File 체크하고
파일루트/파일명 정하기
Start Export 


**ERD 단축키
DB -> ERD  
: 데이터 베이스 선택하고 ctrl + R 하면 ERD 생성
ERD -> DB :   ERD 에서 ctrl +G 하면 데이터 베이스 생성
