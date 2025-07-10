-- pg-10-lag-lead.sql

-- LAG() - 이전 값을 가져온다.
-- 전원 대비 매출 분석

-- 매달 매출을 확인
-- 위 테이블에 증감률 컬럼 추가

WITH monthly_sales AS (
	SELECT
		DATE_TRUNC('month', order_date) AS 월,
		SUM(amount) as 월매출
	FROM orders
	GROUP BY 월
),
compare_before AS (
	SELECT
		TO_CHAR(월, 'YYYY-MM') as 년월,
		월매출,
		LAG(월매출, 1) OVER (ORDER BY 월) AS 전월매출
	FROM monthly_sales
)
SELECT
	*,
	월매출 - 전월매출 AS 증감액,
	CASE
		WHEN 전월매출 IS NULL THEN NULL
		ELSE ROUND((월매출 - 전월매출) * 100 / 전월매출, 2)::TEXT || '%'
	END AS 증감률
FROM compare_before
ORDER BY 년월;


-- 고객별 다음 구매를 예측?
-- [고객id, 		주문일, 					구매액,
-- 		   다음구매일, 구매간격(일수), 다음구매액수, 구매금액차이]
-- 고객별로 PARTITION 필요
-- order by customer_id, order_date LIMIT 10;

SELECT
	customer_id AS 고객id,
	order_date AS 주문일,
	amount AS 구매액,
	LEAD(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS 다음구매일,
	LEAD(amount, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS 다음구매액수
FROM orders
ORDER BY customer_id, order_date


-- [고객id, 주문일, 금액, 구매 순서(ROW_NUMBER),
--	이전구매간격, 다음구매간격
-- 금액변화=(이번-저번), 금액변화율
-- 누적 구매 금액(SUM OVER)
-- [추가]누적 평균 구매 금액 (AVG OVER)

WITH sales_report AS(
SELECT
	ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date) AS 구매순서,
	customer_id AS 고객id,
	LAG(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS 이전구매일,
	order_date AS 주문일,
	LEAD(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS 다음구매일,
	LAG(amount, 1) OVER (PARTITION BY customer_id ORDER BY order_DATE) AS 이전구매금액,
	amount AS 구매액,
	LEAD(amount, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS 다음구매액수
FROM orders
)
SELECT
	고객id,
	주문일,
	구매액,
	구매순서,
	(주문일 - 이전구매일)::INTEGER AS 이전구매간격,
	(다음구매일 - 주문일)::INTEGER AS 다음구매간격,
	-- ROUND((구매액 - 이전구매금액) * 100 / NULLIF(이전구매금액, 0), 2)::TEXT || '%' AS 금액변화율,
	구매액 - 이전구매금액 AS 금액변화,
	CASE
		WHEN 이전구매금액 IS NULL THEN NULL
		ELSE ROUND((구매액 - 이전구매금액) * 100 / 이전구매금액, 2)::TEXT || '%' 
	END AS 금액변화율,
	SUM(구매액) OVER(PARTITION BY 고객id ORDER BY 주문일) AS 누적구매금액,
	ROUND(AVG(구매액) OVER(PARTITION BY 고객id ORDER BY 주문일 
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)	-- 현재 확인중인 ROW부터 맨 앞까지
		-- ROWS BETWEEN 2 PRECEDING AND CURRENT ROW 	-- 현재 확인중인 ROW 포함 총 3개
	, 2) AS 누적평균구매금액,
	-- 고객 구매 단계 분류
	CASE
		WHEN 구매순서 = 1 THEN '첫구매'
		WHEN 구매순서 <= 3 THEN '초기고객'
		WHEN 구매순서 <= 10 THEN '일반고객'
		ELSE 'VIP고객'
	END AS 고객단계
FROM sales_report
ORDER BY 고객id, 주문일;

