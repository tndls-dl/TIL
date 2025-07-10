# 🧩 SQL_02

## 📚 DAY 08

## 🧱 CTE (Common Table Expression)

### 📖 **정의**

- **CTE = WITH절**
    
    👉 쿼리 내에서 **임시 테이블**로 사용할 수 있는 이름 붙은 SELECT.
    
- 복잡한 쿼리를 **단계별로 나누어** 가독성과 유지보수를 높인다.

### ✨ **장점**

1️⃣ 가독성 ↑ : 단계별로 쿼리 설계

2️⃣ 중복계산 제거 : 동일한 로직 여러 번 실행 X

3️⃣ 유지보수 편함 : 중간 결과 디버깅 쉬움

4️⃣ 재귀 가능 : `WITH RECURSIVE`

### 🏗️ **기본 구조**

```sql
WITH 이름 AS (
  SELECT ...
),
이름2 AS (
  SELECT ...
)
SELECT ...
FROM 이름
JOIN 이름2 ...;
```

### ⚖️ **서브쿼리/VIEW와 비교**

| 항목 | CTE (WITH) | 서브쿼리 | VIEW |
| --- | --- | --- | --- |
| 정의 | `WITH name AS` | SELECT 내부 | `CREATE VIEW name AS` |
| 재사용 | ❌ (한 쿼리 한정) | ❌ | ✔ 여러 쿼리 |
| 지속성 | ❌ 임시 | ❌ | ✔ 영구 |
| 가독성 | ✔ 좋음 | ❌ 복잡하면 읽기 힘듦 | ✔ 좋음 |
| 재귀 가능 | ✔ 가능 | ❌ | ❌ |
| 권한 관리 | ❌ | ❌ | ✔ 가능 (권한 부여) |

### 🥊 **실전 비교**

✅ **예) 평균 주문 금액보다 큰 주문**

**서브쿼리**

```sql
SELECT *
FROM orders
WHERE amount > (SELECT AVG(amount) FROM orders);
```

❌ 동일한 AVG 중복 실행 → 느림

**CTE**

```sql
WITH avg_amount AS (
  SELECT AVG(amount) AS avg_amt FROM orders
)
SELECT *
FROM orders, avg_amount
WHERE amount > avg_amt;
```

✔ 평균값 1회 계산 → 효율 & 구조 명확

### 🪜 **단계별 계산 예시**

> 목표: 지역별 고객수/주문수/평균주문금액
> 

```sql
WITH region_stats AS (
  SELECT
    c.region,
    COUNT(DISTINCT c.customer_id) AS 고객수,
    COUNT(o.order_id) AS 주문수,
    COALESCE(AVG(o.amount), 0) AS 평균주문금액
  FROM customers c
  LEFT JOIN orders o ON c.customer_id = o.customer_id
  GROUP BY c.region
)
SELECT *
FROM region_stats
ORDER BY 고객수 DESC;
```

### ✂️ **복잡 계산 중복 제거**

```sql
-- ❌ 중복계산
SELECT
  customer_id,
  (SELECT AVG(amount) FROM orders) AS avg_amt,
  amount - (SELECT AVG(amount) FROM orders) AS diff
FROM orders;

-- ✅ CTE 사용
WITH avg_order AS (
  SELECT AVG(amount) AS avg_amt FROM orders
)
SELECT
  customer_id,
  avg_amt,
  amount - avg_amt AS diff
FROM orders, avg_order;
```

---

## 🔄 Recursive CTE

### 📖 **정의**

- `WITH RECURSIVE`
- CTE를 **자기 자신**과 다시 JOIN해서 **계층 구조, 반복 시퀀스** 생성

### 🌳 **조직도 예시**

```sql
WITH RECURSIVE org_chart AS (
  SELECT
    employee_id, employee_name, manager_id, 1 AS level
  FROM employees
  WHERE manager_id IS NULL

  UNION ALL

  SELECT
    e.employee_id, e.employee_name, e.manager_id, oc.level + 1
  FROM employees e
  JOIN org_chart oc ON e.manager_id = oc.employee_id
)
SELECT *
FROM org_chart
ORDER BY level;
```

### 🔢 **연속 숫자/날짜 시퀀스 예시**

```sql
-- 숫자 1~10
WITH RECURSIVE numbers AS (
  SELECT 1 AS num
  UNION ALL
  SELECT num + 1 FROM numbers WHERE num < 10
)
SELECT * FROM numbers;

-- 2024-01-01 ~ 2024-01-31 달력 생성
WITH RECURSIVE calendar AS (
  SELECT '2024-01-01'::DATE AS dt
  UNION ALL
  SELECT dt + 1 FROM calendar WHERE dt < '2024-01-31'
)
SELECT * FROM calendar;
```

---

## 📈 Window Function

### 📖 **정의**

- `OVER()` 구문 사용
- 그룹핑 없이도 **행 단위로 집계/순위** 계산

### 📊 **대표 함수**

- `ROW_NUMBER()` → 고유 순번
- `RANK()` → 공동순위 허용
- `DENSE_RANK()` → 공동순위 시 건너뛰지 않음
- 집계함수 + `OVER()` → 전체/부분 집계

### ✅ **기본 예시**

```sql
-- 주문별 전체 평균 표시
SELECT
  order_id, customer_id, amount,
  AVG(amount) OVER() AS 전체평균
FROM orders;
```

### 🥇 **순위 매기기**

```sql
-- 금액순으로 주문 순위
SELECT
  order_id, amount,
  ROW_NUMBER() OVER (ORDER BY amount DESC) AS 순위
FROM orders;

-- 날짜순 최신 주문 순위
SELECT
  order_id, order_date,
  ROW_NUMBER() OVER (ORDER BY order_date DESC) AS 최신순,
  RANK() OVER (ORDER BY order_date DESC) AS 랭크,
  DENSE_RANK() OVER (ORDER BY order_date DESC) AS 덴스랭크
FROM orders;
```

### 👑 **지역별 매출 1위 고객**

```sql
WITH region_sales AS (
  SELECT
    region,
    customer_id,
    SUM(amount) AS total_sales
  FROM orders
  GROUP BY region, customer_id
)
SELECT *
FROM (
  SELECT *,
    ROW_NUMBER() OVER (PARTITION BY region ORDER BY total_sales DESC) AS rn
  FROM region_sales
) t
WHERE rn = 1;
```

---

## 🗺️ 언제 뭘 쓸까? 실무 상황별 정리

| 상황 | 추천 |
| --- | --- |
| 쿼리 복잡 → 단계 분리 | CTE |
| 동일한 서브쿼리 반복 | CTE |
| 계층/트리 | Recursive CTE |
| 순위/누적/전체집계 | Window |
| 1회성 즉석 | 서브쿼리 |
| 여러 쿼리 재사용 | VIEW |

### 📝 **요약 한 줄**

- **CTE:** 복잡 쿼리를 단계로 쪼개라!
- **Recursive CTE:** 조직도/트리/시퀀스 생성!
- **Window:** 그룹없이 순위/집계 한번에!
- **Subquery:** 즉석 임시 처리!
- **VIEW:** 반복 사용은 뷰로!