-- 하 난이도
-- 모든 고객 목록 조회

-- 2. 모든 앨범과 해당 아티스트 이름 출력
-- 각 앨범의 title과 해당 아티스트의 name을 출력하고, 앨범 제목 기준 오름차순 정렬하세요.

SELECT
	al.title,
	ar.name AS artist_name
FROM albums al
INNER JOIN artists ar ON al.artist_id=ar.artist_id
ORDER BY al.title;
	