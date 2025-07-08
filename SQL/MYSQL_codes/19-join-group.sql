-- 19-join-group.sql

-- 모든 고객의 구매 현황 분석(구매를 하지 않았어도 분석)
SELECT
	c.customer_id,
    c.customer_name,
    c.customer_type,
	-- s.id는 NULL이라서 셀 수가 없는 것
    COUNT(s.id), 0 AS 구매건수,
    -- COALESCE(첫번째 값, 10) -> 첫번쨰 값이 NULL인 경우, 10을 쓴다.
    COALESCE(SUM(s.total_amount), 0) AS 총구매액,
    COALESCE(AVG(s.total_amount), 0) AS 평균구매액,
    CASE
		WHEN COUNT(s.id) = 0 THEN '잠재고객'
		WHEN COUNT(s.id) >= 5 THEN '충성고객'
        WHEN COUNT(s.id) >= 3 THEN '일반고객'
		ELSE '신규고객'
	END AS 활성도
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_type;


-- VIP 고객들의 구매 내역 조회 (고객명, 고객유형, 상품명, 카테고리, 주문금액)
SELECT
	*
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id
WHERE c.customer_type = 'VIP';

-- 각 등급별 구매액 평균
SELECT 
	AVG(s.total_amount)
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id
WHERE c.customer_type = 'VIP';

SELECT 
	AVG(s.total_amount)
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id
WHERE c.customer_type = '기업';

SELECT 
	AVG(s.total_amount)
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id
WHERE c.customer_type = '개인';


SELECT
	c.customer_type,
    AVG(s.total_amount) AS 각_등급별_구매액_평균
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_type;