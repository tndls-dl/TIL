-- 상 난이도

-- 2. 장르별 상위 3개 아티스트 및 트랙 수
-- 각 장르별로 트랙 수가 가장 많은 상위 3명의 아티스트(artist_id, name, track_count)를 구하세요.
-- 동점일 경우 아티스트 이름 오름차순 정렬.

WITH genre_track AS (
SELECT
	t.genre_id AS 장르id,
	al.artist_id AS 아티스트id,
	ar.name AS 아티스트이름,
	g.name AS 장르_name,
	COUNT(t.track_id) AS track_count
FROM tracks t
INNER JOIN albums al ON t.album_id = al.album_id
INNER JOIN artists ar ON al.artist_id = ar.artist_id
INNER JOIN genres g ON t.genre_id = g.genre_id
GROUP BY t.genre_id, al.artist_id, ar.name, g.name
),
ranking AS (
	SELECT
		장르id,
		장르_name,
		아티스트id,
		아티스트이름,
		track_count,
		ROW_NUMBER() OVER (PARTITION BY 장르id ORDER BY track_count DESC, 아티스트이름) AS ranked_by_genre
	FROM genre_track
	GROUP BY 장르id, 장르_name, 아티스트id, 아티스트이름, track_count
)
SELECT
	장르_name,
	아티스트이름,
	track_count
FROM ranking
WHERE ranked_by_genre <= 3
ORDER BY 장르_name, track_count, 아티스트이름;
