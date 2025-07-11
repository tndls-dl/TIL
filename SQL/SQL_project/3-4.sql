-- 상 난이도

-- 4. 국가별 재구매율(Repeat Rate)
-- 각 국가별로 전체 고객 수, 2회 이상 구매한 고객 수, 재구매율을 구하세요.
-- 재구매율 = 2회 이상 구매한 고객 수 / 국가별 고객수 * 100 
-- 결과는 재구매율 내림차순 정렬.

WITH country_sales AS (
	SELECT
		customer_id AS 고객id,
		billing_country AS 국가,
		COUNT(*) AS 주문수,
		CASE
			WHEN COUNT(invoice_id) >= 2 THEN 1
			ELSE 0
		END AS 재구매여부
	FROM invoices
	GROUP BY customer_id, billing_country
	ORDER BY 고객id
),
customer_sales AS (
	SELECT
		국가,
		SUM(주문수) AS 주문수,
		COUNT(DISTINCT 고객id) AS 고객수,
		SUM(재구매여부) AS 재구매고객수
	FROM country_sales
	GROUP BY 국가
)
SELECT
	국가,
	고객수,
	재구매고객수,
	(재구매고객수 / 고객수 * 100)::TEXT || '%' AS 재구매율
FROM customer_sales
GROUP BY 국가, 고객수, 재구매고객수
ORDER BY 재구매율 DESC;
