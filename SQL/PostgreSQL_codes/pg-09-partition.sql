-- pg-09-partition.sql

-- PARTITION BY 데이터를 특정 그룹으로 나누고, Window 함수로 결과를 확인
--  동(1~4) | 층(1~20) | 호수 | 이름
-- 101 | 20 | 2001 |	<- 101동 에서는 1위
-- 102 | 20 | 2001 |	<- 102동 에서는 1위
-- 103 | 20 | 2001 |
-- 104 | 20 | 2001 |

-- 체육대회. 1, 2, 3 학년 -> 한번에 "학년 순위 | 전체 순위" 를 확인할 수 있다

SELECT
	region,
	customer_id,
	amount,
	ROW_NUMBER() OVER (ORDER BY amount DESC) AS 전체순위,
	ROW_NUMBER() OVER (PARTITION BY region ORDER BY amount DESC) AS 지역순위,
	RANK() OVER (ORDER BY amount DESC) AS 전체순위,
	RANK() OVER (PARTITION BY region ORDER BY amount DESC) AS 지역순위,
	DENSE_RANK() OVER (ORDER BY amount DESC) AS 전체순위,
	DENSE_RANK() OVER (PARTITION BY region ORDER BY amount DESC) AS 지역순위
FROM orders LIMIT 10;


-- SUM() OVER()
-- 일별 누적 매출액
WITH daily_sales AS (
	SELECT
		order_date,
		SUM(amount) AS 일매출
	FROM orders
	WHERE order_date BETWEEN '2024-06-01' AND '2024-08-31'
	GROUP BY order_date
	ORDER BY order_date
)
SELECT
	order_date,
	일매출,
	-- 범위 내에서 계속 누적
	SUM(일매출) OVER (ORDER BY order_date) AS 누적매출,
	-- 범위 내에서, PARTITION 바뀔 때 초기화.
	SUM(일매출) OVER (
		PARTITION BY DATE_TRUNC('month', order_date)
		ORDER BY order_date
	) AS 월누적매출
FROM daily_sales;

-- AVG() OVER() 
WITH daily_sales AS (
	SELECT
		order_date,
		SUM(amount) AS 일매출,
		COUNT(*) AS 주문수
	FROM orders
	WHERE order_date BETWEEN '2024-06-01' AND '2024-08-31'
	GROUP BY order_date
	ORDER BY order_date
)
SELECT
	order_date,
	일매출,
	주문수,
	ROUND(AVG(일매출) OVER (
		ORDER BY order_date
		ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
	)) AS 이동평균7일,
	ROUND(AVG(일매출) OVER (
		ORDER BY order_date
		ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
	)) AS 이동평균3일
FROM daily_sales;


SELECT
	region,
	order_date,
	amount,
	AVG(amount) OVER (PARTITION BY region ORDER BY order_date) AS 지역매출누적평균
FROM orders
WHERE order_date BETWEEN '2024-07-01' AND '2024-07-02';


-- 각 지역에서 총구매액 1위 고객 => ROW_NUMBER() 로 숫자를 매기고, 이 컬럼의 값이 1인 사람
-- [지역, 고객이름, 총구매액]
-- CTE
-- 1. 지역-사람별 "매출 데이터" 생성 [지역, 고객id, 이름, 해당 고객의 총 매출]
-- 2. "매출데이터" 에 새로운 열(ROW_NUMBER) 추가
-- 3. 최종 데이터 표시
-- 내가 한 거
WITH region_customer AS (
SELECT
	o.region AS 지역,
	o.customer_id AS 고객id,
	c.customer_name AS 이름,
	SUM(o.amount) AS 총구매액
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
GROUP BY o.region, o.customer_id, c.customer_name
)
SELECT
	지역,
	고객id,
	이름,
	총구매액
FROM (
	SELECT
		지역,
		고객id,
		이름,
		총구매액,
		ROW_NUMBER() OVER(PARTITION BY 지역 ORDER BY 총구매액 DESC) AS 총구매액순위
	FROM region_customer
) AS 총구매액1위
WHERE 총구매액순위 = 1;

-- 강사님 답안
WITH region_sales AS (
	SELECT
		c.region AS 지역,
		c.customer_id AS 고객id,
		c.customer_name AS 이름,
		SUM(o.amount) AS 고객별총매출
	FROM customers c
	INNER JOIN orders o ON c.customer_id = o.customer_id
	GROUP BY c.region, c.customer_id, c.customer_name
),
ranked_by_region AS (
	SELECT
		지역,
		고객id,
		이름,
		고객별총매출,
		ROW_NUMBER() OVER(PARTITION BY 지역 ORDER BY 고객별총매출 DESC) AS 지역순위
	FROM region_sales
)
SELECT
	지역,
	이름,
	고객별총매출,
	지역순위
FROM ranked_by_region
WHERE 지역순위 < 4;	-- 1~3위


-- 카테고리 별 인기 상품(매출순위) TOP 5
-- CTE
-- [상품 카테고리, 상품id, 상품이름, 상품가격, 해당상품의주문건수, 해당상품판매량, 해당상품총매출]
-- 위에서 만든 테이블에 WINDOW함수 컬럼 추가 + [매출순위, 판매량순위]
-- 총데이터 표시(매출순위 1 ~ 5위 기준으로 표시)
WITH category_sales AS (
	SELECT
		p.category AS 카테고리,
		p.product_id AS 상품id,
		p.product_name AS 상품이름,
		p.price AS 상품가격,
		COUNT(o.order_id) AS 주문건수,
		SUM(o.quantity) AS 판매개수,
		SUM(o.amount) AS 총매출
	FROM products p
	LEFT JOIN orders o ON p.product_id = o.product_id
	GROUP BY p.category, p.product_id, p.product_name, p.price
),
ranked_by_amount AS (
	SELECT
		*,
		DENSE_RANK() OVER(PARTITION BY 카테고리 ORDER BY 총매출) AS 매출순위,
		DENSE_RANK() OVER(PARTITION BY 카테고리 ORDER BY 판매개수) AS 판매량순위
	FROM category_sales
)
SELECT
	카테고리, 상품id, 상품이름, 상품가격, 주문건수, 판매개수, 총매출, 매출순위, 판매량순위
FROM ranked_by_amount
WHERE 매출순위 <= 5
ORDER BY 카테고리, 매출순위;
