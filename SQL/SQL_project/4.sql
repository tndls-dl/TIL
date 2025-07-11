-- 직원(지원 담당자)별 고객 만족도 분석

-- 직원들의 역량이 전반적으로 고르게 분포되어 있음.
-- 분석 요약
-- Jane: 매출 기여도 및 관리 고객 수 1위 (양적 성과 우수)
-- Steve: 고객당 평균 매출 1위 (질적 성과 우수)

SELECT
    e.employee_id AS 직원id,
    e.first_name AS 직원이름,
    COALESCE(SUM(i.total), 0) AS 총매출,
	COUNT(DISTINCT c.customer_id) AS 고객수,
    CASE
        WHEN COUNT(DISTINCT c.customer_id) = 0 THEN 0
        ELSE ROUND(COALESCE(SUM(i.total), 0) / COUNT(DISTINCT c.customer_id), 2)
    END AS 고객당평균매출
FROM employees e
LEFT JOIN customers c ON e.employee_id = c.support_rep_id
LEFT JOIN invoices i ON c.customer_id = i.customer_id
GROUP BY 직원id, 직원이름
ORDER BY 총매출 DESC;

--

SELECT
    e.employee_id AS 직원id,
    e.first_name AS 직원이름,
    COUNT(DISTINCT c.customer_id) AS 관리고객수,
    COALESCE(SUM(i.total), 0) AS 총매출
FROM employees e
JOIN customers c ON e.employee_id = c.support_rep_id
JOIN invoices i ON c.customer_id = i.customer_id
GROUP BY 직원id, 직원이름
ORDER BY 총매출 DESC;


-- 재구매율 분석
-- 총구매횟수가 동일 -- 직원별로 재구매율에 차이가 없음.
SELECT
    customer_id AS 고객id,
    COUNT(invoice_id) AS 총구매횟수
FROM invoices
GROUP BY customer_id
ORDER BY 총구매횟수 DESC;
