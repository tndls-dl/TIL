-- p08.sql

-- practice DB에
USE practice;
-- lecture - sales, products 복사해오기
CREATE TABLE sales AS SELECT * FROM lecture.sales;
CREATE TABLE products AS SELECT * FROM lecture.products;
CREATE TABLE customers AS SELECT * FROM lecture.customers;

-- 단일값 서브쿼리
-- 1-1. 평균 이상 매출 주문들(성과가 좋은 주문들)
-- 평균
SELECT AVG(total_amount) FROM sales;

SELECT * FROM sales
WHERE total_amount >= (SELECT AVG(total_amount) FROM sales);

SELECT
	*,
	product_name,
    total_amount,
    ROUND((SELECT AVG(total_amount) FROM sales), 0) AS 전체평균,
    ROUND(total_amount - (SELECT AVG(total_amount) FROM sales), 0) AS 평균초과금액
FROM sales
WHERE total_amount >= (SELECT AVG(total_amount) FROM sales);

-- 1-2. 최고 매출 지역의 모든 주문들
-- 최고 매출 지역 ?   
SELECT 
	region
FROM sales
GROUP BY region
ORDER BY SUM(total_amount) DESC LIMIT 1;

SELECT * FROM sales
WHERE region = (
	-- 최고 매출 지역
	SELECT region
	GROUP BY region
	ORDER BY SUM(total_amount) DESC 
    LIMIT 1);


-- 여러 데이터(벡터) 서브쿼리
-- 2-2. 재고 부족(50개 미만) 제품의 매출 내역
-- guantity < 50 인 제품의 매출 내역
SELECT product_id FROM products WHERE stock_quantity < 50;

SELECT * FROM sales
WHERE product_name IN (SELECT product_name FROM products WHERE stock_quantity < 50);

-- 2-3. 상위 3개 매출 지역의 주문들
SELECT region FROM sales
GROUP BY region
ORDER BY SUM(total_amount) DESC LIMIT 3;

SELECT * FROM sales
WHERE region IN (
	SELECT region FROM sales 
	GROUP BY region 
    ORDER BY SUM(total_amount) DESC 
    LIMIT 3
);

-- 2-4. 상반기(24-01-01 ~ 24-06-30)에 주문한 고객들의 하반기(24-07-01 ~ 24-12-31) 주문 내역
SELECT DISTINCT customer_id FROM sales
WHERE order_date BETWEEN '2024-01-01' AND '2024-06-30';

SELECT * FROM sales
WHERE customer_id IN (
	SELECT DISTINCT customer_id FROM sales
    WHERE order_date BETWEEN '2024-01-01' AND '2024-06-30'
    )
AND order_date BETWEEN '2024-07-01' AND '2024-12-31'
ORDER BY customer_id, order_date;
