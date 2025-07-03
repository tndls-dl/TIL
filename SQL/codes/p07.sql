-- p07.sql
USE practice;

CREATE TABLE dt_demo2 AS SELECT * FROM lecture.dt_demo;

SELECT * FROM dt_demo2;

SELECT
-- 종합 정보 표시
-- id
-- name
	id,
	name,
    
-- nickname (NULL -> '미설정')
	IFNULL(nickname, '미설정') AS 닉네임,
    
-- 출생년도 (19XX년생)
-- DATE_FORMAT(birth, '%Y년생') AS 출생년도,
    CASE
		WHEN birth IS NULL THEN '미입력'	-- NULL 값 먼저 처리
        ELSE DATE_FORMAT(birth, '%Y년생')
	END AS 출생년도,
    
-- 나이 (TIMESTAMPDIFF 로 나이만 표시)
-- TIMESTAMPDIFF(YEAR, birth, CURDATE()) AS 나이,
    CASE
		WHEN birth IS NULL THEN '미입력'	-- NULL 값 먼저 처리
        ELSE TIMESTAMPDIFF(YEAR, birth, CURDATE())
	END AS 나이,
    
-- 점수 (소수 1자리 반올림, NULL -> 0)
	-- ROUND(IFNULL(score, 0), 1) AS 점수,
    IF(score IS NOT NULL, ROUND(score, 1), 0) AS 점수,
    COALESCE(ROUND(score, 1), 0) AS 점수,
    
-- 등급 (A >= 90 | B >= 80 | C >= 70 | D)
	CASE
		WHEN score >= 90 THEN 'A'
        WHEN score >= 80 THEN 'B'
        WHEN score >= 70 THEN 'C'
        ELSE 'D'
	END AS 등급,
    
-- 상태 (is_active 가 1이면 '활성' / 0 '비활성')
	IF(is_active = 1, '활성', '비활성') AS 상태,

-- 연령대 (청년 < 30 < 청장년 < 50 < 장년)
	CASE
		WHEN birth IS NULL THEN '알 수 없음'	-- NULL 값 먼저 처리
		WHEN TIMESTAMPDIFF(YEAR, birth, CURDATE()) < 30 THEN '청년'
		WHEN TIMESTAMPDIFF(YEAR, birth, CURDATE()) < 50 THEN '청장년'
        ELSE '장년'
	END AS 연령대
FROM dt_demo2;
