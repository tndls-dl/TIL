# 🧩 SQL_02

## 📚 DAY 09

## 🧩 PARTITION BY

### 💡 개념

- 데이터를 그룹(파티션)으로 나누고 그 안에서 순위/누적/평균 계산
- `ORDER BY`랑 같이 쓰면 **그룹별 + 순서별** 로 결과 뽑기

### 🛠️ 언제 쓰나 ?

- 학급별, 지역별, 카테고리별로 순위/누적/평균 나눠볼 때
- “전체 순위 + 그룹별 순위” 같이 비교할 때

### 📝 예시

```sql
-- 지역별 & 전체 매출 순위
SELECT
  region,
  customer_id,
  amount,
  ROW_NUMBER() OVER (ORDER BY amount DESC) AS 전체순위,
  ROW_NUMBER() OVER (PARTITION BY region ORDER BY amount DESC) AS 지역순위
FROM orders;
```

---

## 📊 SUM() / AVG() OVER

### 💡 개념

- 윈도우 함수로 누적합, 이동평균, 그룹별 평균 등 구할 때 사용

### 🛠️ 언제 쓰나 ?

- 매출의 누적값
- 월별 누적합 / 이동평균
- 지역별 누적 매출 평균

### 📝 예시

```sql
-- 월별 누적 매출
SELECT
  order_date,
  daily_sales,
  SUM(daily_sales) OVER (ORDER BY order_date) AS 누적매출
FROM daily_sales;

-- 7일 이동 평균
SELECT
  order_date,
  amount,
  AVG(amount) OVER (
    ORDER BY order_date
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
  ) AS 이동평균7일
FROM orders;
```

---

## ⏪⏩ LAG() / LEAD()

### 💡 개념

- `LAG()` : 이전 행 값
- `LEAD()` : 다음 행 값
- 변화량, 간격, 차이 분석에 필수

### 🛠️ 언제 쓰나 ?

- 전월 대비 매출 변화
- 고객별 구매 간격
- 금액 변화율

### 📝 예시

```sql
-- 전월 매출 비교
SELECT
  월,
  매출,
  LAG(매출, 1) OVER (ORDER BY 월) AS 전월매출
FROM monthly_sales;

-- 고객별 다음 구매일
SELECT
  customer_id,
  order_date,
  LEAD(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS 다음구매일
FROM orders;
```

---

## 🏆 NTILE() / PERCENT_RANK()

### 💡 개념

- `NTILE(n)` : 데이터를 n등분
- `PERCENT_RANK()` : 백분위 구간 나눔

### 🛠️ 언제 쓰나 ?

- 상위 10%, 하위 30% 같은 등급 나눌 때
- VIP/Gold/Silver 같은 등급 만들기

### 📝 예시

```sql
-- 4분위로 고객 등급 나누기
SELECT
  customer_id,
  NTILE(4) OVER (ORDER BY total_amount DESC) AS 분위
FROM customer_totals;

-- 가격 백분위
SELECT
  product_name,
  PERCENT_RANK() OVER (ORDER BY price) AS 백분위
FROM products;
```

---

## 🎯 FIRST_VALUE() / LAST_VALUE()

### 💡 개념

- 파티션 안에서 **첫 값**, **마지막 값** 추출
- ROWS 범위 잘 지정해야 함!

### 🛠️ 언제 쓰나 ?

- 카테고리별 최고가/최저가 상품 찾기
- 그룹별 최초/최종 기록 찾기

### 📝 예시

```sql
-- 카테고리별 최고가/최저가 상품명
SELECT
  category,
  product_name,
  FIRST_VALUE(product_name) OVER (
    PARTITION BY category ORDER BY price DESC
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS 최고가상품,
  LAST_VALUE(product_name) OVER (
    PARTITION BY category ORDER BY price DESC
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS 최저가상품
FROM products;
```

---

## 📌 요약

| 함수 | 핵심 사용 | 언제? |
| --- | --- | --- |
| PARTITION BY | 그룹 나누기 | 지역별, 학년별 |
| SUM() OVER | 누적합 | 매출 누적 |
| AVG() OVER | 이동평균 | 일/주/월 |
| LAG() / LEAD() | 이전/다음 값 | 전월, 다음 구매 |
| ROW_NUMBER() | 고유 순번 | 순서 |
| RANK() | 순위(건너뜀) | 순위표 |
| DENSE_RANK() | 순위(연속) | 그룹 순위 |
| NTILE() | 분위 | 등급 |
| PERCENT_RANK() | 백분위 | 상/중/하 구간 |
| FIRST_VALUE() | 파티션 첫 값 | 최고가 |
| LAST_VALUE() | 파티션 마지막 값 | 최저가 |