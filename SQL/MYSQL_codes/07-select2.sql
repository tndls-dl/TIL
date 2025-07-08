-- 07-select2.sql

-- SELECT 컬럼 FROM 테이블 WHERE 조건 ORDER BY 정렬기준 LIMIT 개수
-- 특정 테이블에서 어떤 조건을 만족하는 애들을 어떠한 정렬기준으로 몇 개만 가져와라

USE lecture;
DROP TABLE students;
CREATE TABLE students (
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20),
    age INT
);

DESC students;

INSERT INTO students (name, age) VALUES 
('임 수인', '20'),
('최 민석', '25'),
('윤 도운', '29'),
('김 원필', '30'),
('강 영현', '35'),
('박 성진', '40'),
('조 원상', '47'),
('최 상엽', '53'),
('신 예찬', '61'),
('신 광일', '75');

SELECT * FROM students;

SELECT * FROM students WHERE name='윤 도운';

SELECT * FROM students WHERE age >= 20;	-- 이상
SELECT * FROM students WHERE age >20;	-- 초과

SELECT * FROM students WHERE id<>1;	-- 여집합 (해당 조건이 아닌)
SELECT * FROM students WHERE id!=1;	-- 해당 조건이 아닌

SELECT * FROM students WHERE age BETWEEN 20 AND 40;	-- age가 20 이상 40 이하 (범위 지정 가능)

SELECT * FROM students WHERE id IN (1, 3, 5, 7);	-- 특정 id에 대해 다 가져옴

-- 문자열 패턴 LIKE (% -> 있을 수도 없을 수도 있다, _ -> 정확히 개수만큼 글자가 있다) // LIKE도 사실상 연산 기호
-- 최 씨만 찾기
SELECT * FROM students WHERE name LIKE '최%';	-- '최'로 시작만 하면 됨 반대로 '%최'였으면 '최'로 끝나기만 하면 됨
-- '상' 이라는 글자가 들어가는 사람
SELECT * FROM students WHERE name LIKE '%상%';
-- 이름이 정확히 3글자인 신씨
SELECT * FROM students WHERE name LIKE '신 __';	-- %로 썼으면 글자 수가 4, 5글자인 사람들도 나옴 _를 두 개를 사용함으로써 신씨인 이름 3글자인 사람을 찾을 수 있는 것임
