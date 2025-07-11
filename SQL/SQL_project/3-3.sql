-- 상 난이도

-- 3. 고객별 누적 구매액 및 등급 산출
-- 각 고객의 누적 구매액을 구하고,
-- 상위 20%는 'VIP', 하위 20%는 'Low', 나머지는 'Normal' 등급을 부여하세요.

WITH customer_total AS (
	SELECT
		i.customer_id AS customer_id,
		c.first_name AS customer_name,
		SUM(i.total) AS 누적구매금액
	FROM invoices i
	INNER JOIN customers c ON i.customer_id=c.customer_id
	GROUP BY i.customer_id, c.first_name
)
SELECT
	customer_id,
	customer_name,
	누적구매금액,
	CASE
		WHEN PERCENT_RANK() OVER (ORDER BY 누적구매금액 DESC) <= 0.2 THEN 'VIP'
		WHEN PERCENT_RANK() OVER (ORDER BY 누적구매금액 DESC) >= 0.8 THEN 'Low'
		ELSE 'Normal'
	END AS 구매금액등급
FROM customer_total
ORDER BY 누적구매금액 DESC;