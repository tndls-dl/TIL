-- p02.sql

-- practice db 이동
USE practice;
-- userinfo 테이블에 진행 (p01 실습에서 진행했던 테이블)
DESC usefinfo;

-- 데이터 5건 넣기 (별명, 핸드폰) -> bob을 포함하세요
INSERT INTO userinfo (nickname, phone) 
VALUES ('윤돈', '01012345678'), ('필토끼', '01023456789'), ('강브라', '01034567890'), ('밥성진', '01045678901'), ('bob', '01056789012');

-- 전체 조회 (중간중간 계속 실행하면서 모니터링)
SELECT * FROM userinfo;

-- id가 3인 사람 조회
SELECT * FROM userinfo WHERE id=3;

-- 별명이 bob인 사람을 조회
SELECT * FROM userinfo WHERE nickname='bob';

-- 별명이 bob인 사람의 핸드폰 번호를 01099998888 로 수정 (id로 수정)
UPDATE userinfo SET phone='01099998888' WHERE id=5;

-- 별명이 bob인 사람 삭제 (id로 수정)
DELETE FROM userinfo WHERE id=5;
