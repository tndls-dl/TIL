-- 음악 시장 트렌드 예측 (장르별 성장률 분석)

WITH monthly_genre_sales AS (
	SELECT
		TO_CHAR(DATE_TRUNC('month', i.invoice_date), 'YYYY-MM') AS 년월,
		g.genre_id AS 장르id,
		g.name AS 장르이름,
		SUM(ii.quantity * ii.unit_price) AS 총매출
	FROM invoices i
	INNER JOIN invoice_items ii ON i.invoice_id=ii.invoice_id
	INNER JOIN tracks t ON ii.track_id = t.track_id
	INNER JOIN genres g ON t.genre_id=g.genre_id
	GROUP BY 년월, g.genre_id, g.name
	ORDER BY 년월
),
genre_sales_growth AS (
	SELECT
		년월,
		장르id,
		장르이름,
		총매출,
		LAG(총매출) OVER (PARTITION BY 장르이름 ORDER BY 년월) AS 이전달매출
	FROM monthly_genre_sales
	WHERE 년월 >= (SELECT TO_CHAR(DATE_TRUNC('month', MAX(invoice_date) - INTERVAL '2 year'), 'YYYY-MM') FROM invoices)
)
SELECT
	년월,
	장르id,
	장르이름,
	총매출,
	이전달매출,
	ROUND(((총매출 - 이전달매출) * 1.0  / 이전달매출), 2)::TEXT || '%' AS 성장률
FROM genre_sales_growth
WHERE 이전달매출 IS NOT NULL
ORDER BY 년월, 장르이름;


-- 데이터 기반 신규 상품/서비스 기획
WITH monthly_genre_sales AS (
	SELECT
		TO_CHAR(DATE_TRUNC('month', i.invoice_date), 'YYYY-MM') AS 년월,
		g.genre_id AS 장르id,
		g.name AS 장르이름,
		SUM(ii.quantity * ii.unit_price) AS 총매출
	FROM invoices i
	INNER JOIN invoice_items ii ON i.invoice_id=ii.invoice_id
	INNER JOIN tracks t ON ii.track_id = t.track_id
	INNER JOIN genres g ON t.genre_id=g.genre_id
	GROUP BY 년월, g.genre_id, g.name
	ORDER BY 년월
),
genre_sales_growth AS (
	SELECT
		년월,
		장르id,
		장르이름,
		총매출,
		LAG(총매출) OVER (PARTITION BY 장르이름 ORDER BY 년월) AS 이전달매출
	FROM monthly_genre_sales
	WHERE 년월 >= (SELECT TO_CHAR(DATE_TRUNC('month', MAX(invoice_date) - INTERVAL '2 year'), 'YYYY-MM') FROM invoices)
),
genre_growth_summary AS (
	SELECT
		년월,
		장르id,
		장르이름,
		총매출,
		이전달매출,
		ROUND((AVG(총매출 - 이전달매출) * 1.0  / 이전달매출), 2)::TEXT || '%' AS 평균성장률
	FROM genre_sales_growth
	WHERE 이전달매출 IS NOT NULL
	GROUP BY 년월, 장르id, 장르이름, 총매출, 이전달매출
	ORDER BY 년월, 장르이름
)
SELECT
	장르이름,
	평균성장률
FROM genre_growth_summary
ORDER BY 평균성장률 DESC;
