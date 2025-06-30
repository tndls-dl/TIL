-- 03-insert.sql

USE lecture;
DESC members;

-- 데이터 입력
INSERT INTO members (name, email) VALUES ('임수인', 'soo@a.com');
INSERT INTO members (name, email) VALUES ('홍길동', 'hong@a.com');

-- 여러 줄, (col1, col2) 순서 잘 맞추기 !
INSERT INTO members (email, name) 
VALUES ('woon@a.com', '윤도운'), ('pil@a.com', '김원필'), ('yk@a.com', '강영현'), ('jin@a.com', '박성진');

-- 데이터 전체 조회 (Read)
SELECT * FROM members;	-- * 는 와일드카드, 여기서는 members에 있는 거 다 갖고 오라는 뜻
-- 단일 데이터 조회 (* -> 모든 컬럼)
SELECT * FROM members WHERE id=1;	-- members에서 id가 1번인 사람의 모든 컬럼을 갖고 와 (WHERE라는 말을 통해서 조건을 거는 것)
