-- 18-JOIN.sql

USE lecture;

-- 고객정보 + 주문정보
-- 외부 테이블에 있는 정보를 가져올 수 있다
-- 일일이 컬럼마다 지정해서 찾아라
SELECT
	*,
    (
     SELECT customer_name FROM customers c
     WHERE c.customer_id=s.customer_id
	) AS 주문고객이름,
    (
     SELECT customer_type FROM customers c
     WHERE c.customer_id=s.customer_id
	) AS 고객등급
FROM sales s;

-- JOIN
-- 합쳐서 찾아라
SELECT
	*
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
WHERE s.total_amount >= 500000;

-- 모든 고객의 구매 현황 분석(구매를 하지 않았어도 분석)
SELECT
	c.customer_id,
    c.customer_name,
    c.customer_type,
    -- 주문 횟수
    COUNT(*) AS 주문횟수,
    -- 총 구매액
    SUM(s.total_amount) AS 총구매액
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c. customer_name, c.customer_type;

-- LEFT JOIN -> 왼쪽 테이블(c)의 모든 데이터와 + 매칭되는 오른쪽 데이터 | 매칭되는 오른쪽 데이터 (없어도 등장) 
SELECT *
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id;
-- WHERE s.id IS NULL; -> 한번도 주문한 적 없는 사람들이 나온다

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