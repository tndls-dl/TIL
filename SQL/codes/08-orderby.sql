-- 08-orderby.sql

USE lecture;

-- 특정 컬럼을 기준으로 정렬함
-- ASC 오름차순 | DESC 내림차순

SELECT * FROM students;	-- id 오름차순으로 정렬하도록 기본값이 되어 있음 ( 별 말 없으면 오름차순이 기본 정렬 방식 = ASC

-- 이름 ㄱㄴㄷ 순으로 정렬 -> Default(기본) 정렬 방식 = ASC
SELECT * FROM students ORDER BY name;
SELECT * FROM students ORDER BY name ASC;	-- 위와 결과 동일
SELECT * FROM students ORDER BY name DESC;	-- 이름 내림차순으로 정렬

-- 테이블 스키마(구조) 변경 -> 컬럼 추가 -> grade VARCHAR(1) -> 기본값으로 'B'
ALTER TABLE students ADD COLUMN grade VARCHAR(1) DEFAULT 'B';
-- 데이터 수정 9명 -> id 1~3 -> A | id 8~10 -> C
UPDATE students SET grade = 'A' WHERE id BETWEEN 1 AND 3;
UPDATE students SET grade = 'C' WHERE id BETWEEN 8 AND 10;

-- 다중 컬럼 정렬 -> 앞에 말한 게 우선 정렬
SELECT * FROM students ORDER BY
age ASC, 
grade DESC;

SELECT * FROM students ORDER BY
grade DESC, 
age ASC;

-- 나이가 40 미만인 학생들 중에서 학점순 - 나이 많은순 으로 상위 5명 뽑기
SELECT * FROM students WHERE age < 40 ORDER BY grade ASC, age DESC LIMIT 5;
