-- 20-subquery3.sql

USE lecture;

-- 각 카테고리 별 평균매출 중에서 50만원 이상만 구하기
SELECT
	category,
    AVG(total_amount) AS 평균매출액
FROM sales
GROUP BY category
HAVING AVG(total_amount) >= 500000;	-- HAVING은 그루핑해서 나온 것을 필터링

-- 인라인 뷰(View) => 내가 만든 테이블 (물리적으로 저장되어 있지는 않음, 하지만 '마치' 실존하는 테이블처럼 사용하고 있음) 
SELECT
	*
FROM (
	SELECT
		category,
        AVG(total_amount) AS 평균매출액
	FROM sales GROUP BY category
) AS category_summary	-- 테이블을 만들어냈다면 (파생 테이블) alias를 꼭 붙여줘야 해
WHERE 평균매출액 >= 500000;


-- 1. 카테고리볆 매출 분석 후 필터링
-- 카테고리명, 주문건수, 총매출, 평균매출, 평균매출 [0 <= 저단가 < 400000 <= 중단가 < 800000 < 고단가]
SELECT 
	category,
    COUNT(*) AS 판매건수,
    SUM(total_amount) AS 총매출,
	AVG(total_amount) AS 평균매출,
	CASE
		WHEN AVG(total_amount) > 800000 THEN '고단가'
        WHEN AVG(total_amount) >= 400000 THEN '중단가'
        ELSE '저단가'
	END AS 단가구분
FROM sales
GROUP BY category;

SELECT
	category,
    판매건수,
    총매출,
    평균매출,
    CASE
		WHEN 평균매출 >= 800000 THEN '고단가'
        WHEN 평균매출 >= 400000 THEN '중단가'
        ELSE '저단가'
	END AS 단가구분
FROM (	-- 인라인 뷰
	SELECT 
		category,
		COUNT(*) AS 판매건수,
		SUM(total_amount) AS 총매출,
		ROUND(AVG(total_amount)) AS 평균매출
	FROM sales
	GROUP BY category
) AS c_a
WHERE 평균매출 >= 300000;

-- 영업사원별 성과 등급 분류 [영업사원, 총매출액, 주문건수, 평균주문액, 매출등급, 주문등급]
-- 매출등급 - [0 < C <= 1000000 < B <= 3000000 < A <= 5000000 <= S]
-- 주문등급 - 주문건수 [0 <= C < 15 <= B < 30 <= A]
-- ORDER BY 총매출액 DESC

SELECT
	영업사원,
    총매출액,
    주문건수,
    평균주문액,
    CASE
		WHEN 총매출액 >= 5000000 THEN 'S'
        WHEN 총매출액 >= 3000000 THEN 'A'
        WHEN 총매출액 >= 1000000 THEN 'B'
        ELSE 'C'
	END AS 매출등급,
    CASE
		WHEN 주문건수 >= 20 THEN 'A'
        WHEN 주문건수 >= 10 THEN 'B'
		ELSE 'C'
	END AS 주문등급
FROM (
	SELECT
		COALESCE(sales_rep, '확인불가') AS 영업사원,
		SUM(total_amount) AS 총매출액,
		COUNT(*) AS 주문건수,
		AVG(total_amount) AS 평균주문액
	FROM sales
	GROUP BY sales_rep
) AS s_r
ORDER BY 총매출액 DESC;



