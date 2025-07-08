-- 18-join.sql

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

-- INNER JOIN 교집합
SELECT
	'1. INNER JOIN' AS 구분,
    COUNT(*) AS 줄수,
    COUNT(DISTINCT c.customer_id) AS 고객수
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id

UNION	-- 단순히 결과를 합치겠다 
-- LEFT JOIN 왼쪽(FROM 뒤에 온) 테이블은 무조건 다 나옴
SELECT
	'2. LEFT JOIN' AS 구분,
    COUNT(*) AS 줄수,
    COUNT(DISTINCT c.customer_id) AS 고객수
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id

UNION

SELECT
	'3. 전체 고객수' AS 구분,
    COUNT(*) AS 줄수,
    COUNT(*) AS 고객수
FROM customers;