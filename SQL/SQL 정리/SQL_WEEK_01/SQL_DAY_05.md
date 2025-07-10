# 🧩 SQL_01

## 📚 DAY 05

## ➕ UNION

- 여러 SELECT 결과를 **세로로(행 단위)** 합쳐 리포트 만들기
- `UNION` : 중복 제거, `UNION ALL` : 중복 포함
- 모든 SELECT의 컬럼 수 & 데이터 타입 동일해야 함

```sql
-- 고객 & 매출 테이블 건수
SELECT '고객' AS 구분, COUNT(*) FROM customers
UNION
SELECT '매출' AS 구분, COUNT(*) FROM sales;
```

```sql
-- 카테고리별 vs 고객유형별 통합 분석
SELECT
  '카테고리별' AS 분석유형,
  category AS 구분,
  COUNT(*) AS 건수,
  SUM(total_amount) AS 총액
FROM sales
GROUP BY category

UNION ALL

SELECT
  '고객유형별' AS 분석유형,
  customer_type AS 구분,
  COUNT(*) AS 건수,
  SUM(total_amount) AS 총액
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY customer_type

ORDER BY 분석유형, 총액 DESC;
```

---

## 🔍 서브쿼리 — 반환 유형 정리

| 유형 | 반환 | 사용 위치 | 연산자 |
| --- | --- | --- | --- |
| 스칼라 | 1행 1열 | SELECT, WHERE | =, > |
| 벡터 | 여러행 1열 | WHERE, HAVING | IN |
| 매트릭스 | 여러행 여러열 | FROM, EXISTS | EXISTS |

### 🎯 스칼라 서브쿼리

```sql
sql
복사편집
-- 각 주문금액과 전체평균 비교
SELECT
  product_name,
  total_amount,
  (SELECT AVG(total_amount) FROM sales) AS 전체평균,
  total_amount - (SELECT AVG(total_amount) FROM sales) AS 차이
FROM sales;

```

### 📏 벡터 서브쿼리

```sql
sql
복사편집
-- VIP 고객 주문 내역
SELECT * FROM sales
WHERE customer_id IN (
  SELECT customer_id FROM customers WHERE customer_type = 'VIP'
);

```

### ▦ 매트릭스 서브쿼리

```sql
sql
복사편집
-- EXISTS로 다중 조건 확인
SELECT customer_name
FROM customers c
WHERE EXISTS (
  SELECT 1 FROM sales s
  WHERE s.customer_id = c.customer_id AND s.total_amount >= 1000000
);

```

---

## 🚧 Inline View (파생 테이블)

```sql
sql
복사편집
-- 카테고리별 평균매출이 50만원 이상인 것만
SELECT *
FROM (
  SELECT
    category,
    AVG(total_amount) AS 평균매출
  FROM sales
  GROUP BY category
) AS category_avg
WHERE 평균매출 >= 500000;

```

---

## 🎭 View (가상 테이블)

```sql
sql
복사편집
-- View 생성
CREATE VIEW customer_summary AS
SELECT
  c.customer_id,
  c.customer_name,
  c.customer_type,
  COUNT(s.id) AS 주문횟수,
  COALESCE(SUM(s.total_amount), 0) AS 총구매액,
  COALESCE(MAX(s.order_date), '없음') AS 최근주문일
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_type;

-- View 활용
SELECT * FROM customer_summary WHERE 주문횟수 >= 5;

-- View 삭제
DROP VIEW customer_summary;

```

|  | Inline View | VIEW |
| --- | --- | --- |
| 저장 | 임시 (일회성) | DB에 저장 |
| 재사용 | 불가 | 가능 |
| 주 용도 | 복잡한 임시 분석 | 자주 쓰는 쿼리 |

---

## 🧩 실습 문제 주요 패턴

**① 고객별 주문 요약**

```sql
sql
복사편집
-- 서브쿼리 vs JOIN 비교
SELECT
  c.customer_id,
  c.customer_name,
  c.customer_type,
  COUNT(s.id) AS 주문횟수,
  COALESCE(SUM(s.total_amount), 0) AS 총구매액,
  COALESCE(MAX(s.order_date), '없음') AS 최근주문일
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_type;

```

**② 등급 분류**

```sql
sql
복사편집
-- CASE WHEN 으로 등급 나누기
SELECT
  customer_name,
  COUNT(s.id) AS 구매횟수,
  CASE
    WHEN COUNT(s.id) >= 10 THEN '플래티넘'
    WHEN COUNT(s.id) >= 5 THEN '골드'
    WHEN COUNT(s.id) >= 3 THEN '실버'
    ELSE '브론즈'
  END AS 활동등급
FROM customers c
LEFT JOIN sales s ON s.customer_id = c.customer_id
GROUP BY customer_name;

```

**③ 고객 활성도 분석**

```sql
sql
복사편집
SELECT
  CASE
    WHEN MAX(order_date) IS NULL THEN '구매없음'
    WHEN DATEDIFF(CURDATE(), MAX(order_date)) <= 30 THEN '활성'
    WHEN DATEDIFF(CURDATE(), MAX(order_date)) <= 90 THEN '관심'
    ELSE '휴면'
  END AS 고객상태,
  COUNT(*) AS 고객수
FROM customers c
LEFT JOIN sales s ON s.customer_id = c.customer_id
GROUP BY 고객상태;

```

---

## 📌 오늘 핵심 키워드

- `UNION` : 여러 쿼리 결과 합치기
- **서브쿼리 반환 유형** : 스칼라 / 벡터 / 매트릭스
- `Inline View` & `VIEW` : 쿼리 재사용 & 가상 테이블
- `JOIN`, `GROUP BY` 실수 방지

---

## 🚩 SQL 작성 체크리스트

- 테이블 별명(alias) 필수
- JOIN 조건 정확히!
- `GROUP BY` 컬럼 누락 없음
- `LEFT JOIN` 시 `COUNT(특정컬럼)` 사용
- NULL → `COALESCE`로 처리
- 서브쿼리 반환값 유형 맞게