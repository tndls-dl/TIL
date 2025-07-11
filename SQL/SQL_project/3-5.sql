-- 상 난이도

-- 5. 최근 1년간 월별 신규 고객 및 잔존 고객
-- 최근 1년(마지막 인보이스 기준 12개월) 동안,
-- 각 월별 신규 고객 수와 해당 월에 구매한 기존 고객 수를 구하세요.

SELECT
	MAX(invoice_date) - INTERVAL '1 year' AS 마지막기준1년
FROM invoices;

SELECT
	customer_id AS 고객id,
	invoice_date
FROM invoices
WHERE invoice_date >= (SELECT MAX(invoice_date) - INTERVAL '1 year' FROM invoices)
GROUP BY 고객id, invoice_date
ORDER BY 고객id;

-- 
WITH first_invoice AS (
	SELECT
		customer_id AS 고객id,
		MIN(invoice_date) AS 첫구매일
	FROM invoices
	GROUP BY 고객id
),
invoice_customers AS (
	SELECT
		fi.고객id,
		i.invoice_date,
		fi.첫구매일,
		TO_CHAR(DATE_TRUNC('month', i.invoice_date), 'YYYY-MM') AS 년월,
		TO_CHAR(DATE_TRUNC('month', fi.첫구매일), 'YYYY-MM') AS 첫구매일년월
	FROM first_invoice fi
	INNER JOIN invoices i ON fi.고객id=i.customer_id
	WHERE i.invoice_date >= (SELECT MAX(i.invoice_date) - INTERVAL '1 year' FROM invoices i)
),
customer_grade AS (
	SELECT
		년월,
		COUNT(DISTINCT 고객id) AS 고객수,
		CASE
			WHEN 년월 = 첫구매일년월 THEN '신규고객'
			ELSE '기존고객'
		END AS 고객등급
	FROM invoice_customers
	GROUP BY 년월, 고객등급
)
SELECT
	년월,
	SUM(CASE WHEN 고객등급 = '신규고객' THEN 고객수 ELSE 0 END) AS 신규고객수,
	SUM(CASE WHEN 고객등급 = '기존고객' THEN 고객수 ELSE 0 END) AS 기존고객수
FROM customer_grade
GROUP BY 년월;
	