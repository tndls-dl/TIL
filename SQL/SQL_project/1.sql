-- 1. 데이터 품질 및 이상 탐지 이상 거래 탐지

-- 비정상적으로 높은/낮은 단가, 짧은 시간 내 반복 구매 등 이상 패턴 탐색
-- 데이터 누락/오류 사례 분석
-- 주소, 이메일, 가격 등 주요 필드의 NULL/이상값 빈도 및 원인 파악

-- 1) 비정상적으로 높은/낮은 단가
-- 없음 (양호)
SELECT
	invoice_id,
	track_id,
	unit_price,
	quantity
FROM invoice_items
WHERE unit_price = 0 OR quantity > 10;

-- 없음 (양호)
SELECT
	invoice_id,
	track_id,
	unit_price,
	quantity
FROM invoice_items
WHERE unit_price > 10;

-- 2) 데이터 누락/오류 사례 분석 (NULL 값 탐색)
SELECT
	customer_id,
	first_name,
	email,
	phone,
	fax,
	company,
	state
FROM customers
WHERE email IS NULL OR phone IS NULL OR fax IS NULL OR company IS NULL OR state IS NULL;

WITH customer_count AS (
	SELECT
		COUNT(*) AS 고객수,
		COUNT(email) AS email,
		COUNT(phone) AS phone,
		COUNT(fax) AS fax,
		COUNT(company) AS company,
		COUNT(state) AS state
	FROM customers
),
count_null AS (
	SELECT
		고객수,
		고객수 - email AS email_null,
		고객수 - phone AS phone_null,
		고객수 - fax AS fax_null,
		고객수 - company AS company_null,
		고객수 - state AS state_null
	FROM customer_count
)
SELECT
	(ROUND((email_null * 100.0) / 고객수, 2))::TEXT || '%' AS email_누락률,
	(ROUND((phone_null * 100.0) / 고객수, 2))::TEXT || '%' AS phone_누락률,
	(ROUND((fax_null * 100.0) / 고객수, 2))::TEXT || '%' AS fax_누락률,
	(ROUND((company_null * 100.0) / 고객수, 2))::TEXT || '%' AS company_누락률,
	(ROUND((state_null * 100.0) / 고객수, 2))::TEXT || '%' AS state_누락률
FROM count_null;

--
-- email_이상값이 나오지 않음 (양호)
SELECT
	customer_id,
	first_name,
	email
FROM customers
WHERE email IS NOT NULL AND (TRIM(email) = '' OR TRIM(email) = '-' OR TRIM(email) = 'N/A');

-- phone_이상값이 나오지 않음 (양호)
SELECT
	customer_id,
	first_name,
	phone
FROM customers
WHERE phone IS NOT NULL AND (TRIM(phone) = '' OR TRIM(phone) = '-' OR TRIM(phone) = 'N/A');

-- fax_이상값이 나오지 않음 (양호)
SELECT
	customer_id,
	first_name,
	fax
FROM customers
WHERE fax IS NOT NULL AND (TRIM(fax) = '' OR TRIM(fax) = '-' OR TRIM(fax) = 'N/A');

-- company_이상값이 나오지 않음 (양호)
SELECT
	customer_id,
	first_name,
	company
FROM customers
WHERE company IS NOT NULL AND (TRIM(company) = '' OR TRIM(company) = '-' OR TRIM(company) = 'N/A');

-- state_이상값이 나오지 않음 (양호)
SELECT
	customer_id,
	first_name,
	state
FROM customers
WHERE state IS NOT NULL AND (TRIM(state) = '' OR TRIM(state) = '-' OR TRIM(state) = 'N/A');


-- 3) 이상 거래 탐지: 짧은 시간 내 반복 구매
-- 같은 날짜에 2번 이상 구매한 이력 없음.
SELECT
	customer_id,
	invoice_date,
	COUNT(invoice_date) AS 일별구매횟수
FROM invoices
GROUP BY customer_id, invoice_date
HAVING COUNT(invoice_date) > 1;
