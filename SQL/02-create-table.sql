-- 02-create-table.sql
USE lecture;

-- 테이블 생성
CREATE TABLE sample (
	name VARCHAR(30),
	age INT
);

-- 테이블 삭제
DROP TABLE sample;

-- 테이블 확인
SHOW TABLES;

CREATE TABLE members (	-- 테이블 명 : members 생성
	id INT AUTO_INCREMENT PRIMARY KEY,	-- 회원 고유번호 (정수, 자동증가), primary key는 반드시 필요 하지만 테이블마다 하나만 존재 가능
    name VARCHAR(30) NOT NULL,	-- 이름 (필수 입력)
	email VARCHAR(100) UNIQUE,	-- 이메일(중복 불가능)
	join_date DATE DEFAULT(CURRENT_DATE)	-- 가입일(아무 값도 넣지 않으면 -> 기본값-오늘)
);

SHOW TABLES;

-- members 테이블을 상세히 확인 (Describe)
DESC members;