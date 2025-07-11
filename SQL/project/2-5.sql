-- 중 난이도

-- 5. 각 고객의 최근 구매 내역
-- 각 고객별로 가장 최근 인보이스(invoice_id, invoice_date, total) 정보를 출력하세요.

-- WITH invoices_max AS (
--     SELECT
--         customer_id,
--         invoice_id,
--         invoice_date,
--         total,
--         ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY invoice_date DESC) as 최근인보이스
--     FROM invoices
-- )
SELECT
    customer_id,
    invoice_id,
    invoice_date,
    total
FROM 
	(SELECT
        customer_id,
        invoice_id,
        invoice_date,
        total,
        ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY invoice_date DESC) as 최근인보이스
    FROM invoices)
WHERE 최근인보이스 = 1
ORDER BY invoice_id;