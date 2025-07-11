-- 고객 음악 취향 클러스터링

WITH customer_genre AS (
	SELECT
		i.customer_id AS 고객id,
		g.name AS 장르이름,
		SUM(ii.unit_price * ii.quantity) AS 총구매액
	FROM invoices i
	INNER JOIN invoice_items ii ON i.invoice_id=ii.invoice_id
	INNER JOIN tracks t ON ii.track_id=t.track_id
	INNER JOIN genres g ON t.genre_id = g.genre_id
	GROUP BY 고객id, 장르이름
	ORDER BY 고객id
),
genre_sales AS (
	SELECT
		고객id,
		장르이름,
		총구매액,
		SUM(총구매액) OVER (PARTITION BY 고객id) AS 고객별총구매액,
		(ROUND(총구매액 / SUM(총구매액) OVER (PARTITION BY 고객id), 2) * 100)::TEXT || '%' AS 구매비율
	FROM customer_genre
),
rankedbygenre AS (
	SELECT
		고객id,
		장르이름,
		ROW_NUMBER() OVER (PARTITION BY 고객id ORDER BY 총구매액 DESC) AS 장르순위
	FROM genre_sales
)
SELECT
	고객id,
	장르이름
FROM rankedbygenre
WHERE 장르순위 = 1;