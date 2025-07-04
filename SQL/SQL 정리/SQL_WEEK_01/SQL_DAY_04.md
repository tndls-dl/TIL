
## 📚 DAY 04

## **🗂️** 서브쿼리 (Subquery)

**💡 서브쿼리란?**

- 쿼리 안에 쿼리를 넣어 조건, 값, 집계 기준으로 사용
- 대표 패턴
    1. 평균, 최대, 최소 등과 비교
    2. "~~한 적이 있는" 조건 만들기 (IN)
    3. 특정 그룹에 속한 데이터 찾기

**서브쿼리 기본 예시**

| 목적 | 예시 |
| --- | --- |
| 평균보다 높은 주문 | `WHERE total_amount > (SELECT AVG(total_amount) FROM sales)` |
| 가장 비싼 주문 | `WHERE total_amount = (SELECT MAX(total_amount) FROM sales)` |
| VIP 고객 주문 | `WHERE customer_id IN (SELECT customer_id FROM customers WHERE customer_type = 'VIP')` |
| 재고 부족(50 미만) 제품의 주문 | `WHERE product_name IN (SELECT product_name FROM products WHERE stock_quantity < 50)` |

**실전 패턴**

| 패턴 | 설명 |
| --- | --- |
| `= (SELECT ...)` | 서브쿼리 결과가 단일 값이면 `=` |
| `IN (SELECT ...)` | 서브쿼리 결과가 여러 값이면 `IN` |
| `ORDER BY ABS(컬럼 - (SELECT ...))` | 평균과 가까운 값 찾기 |

**✔️ 서브쿼리 핵심**

- 서브쿼리는 괄호로 감싼다 `(SELECT ...)`
- 내부 쿼리가 먼저 실행 → 외부 쿼리가 나중 실행

---

## 🤝 JOIN - 테이블 연결

**💡 JOIN이 필요한 이유?**

- 서로 다른 테이블에서 정보 결합 (ex. 고객 정보 + 주문 정보)

 **JOIN 종류**

| JOIN | 특징 | 사용 예 |
| --- | --- | --- |
| `INNER JOIN` | 교집합, 양쪽 다 있어야 | 실제 구매한 고객만 |
| `LEFT JOIN` | 왼쪽(기준) 테이블은 모두, 오른쪽은 있으면 | 구매 안 한 고객도 포함 |

 **JOIN 기본 문법**

```sql
SELECT 컬럼들
FROM 테이블1 별명1
[INNER | LEFT] JOIN 테이블2 별명2
ON 연결조건
WHERE 조건;
```

**JOIN 실전 패턴**

| 패턴 | 설명 |
| --- | --- |
| 고객 + 주문 | `FROM customers c JOIN sales s ON c.customer_id = s.customer_id` |
| 모든 고객 + 주문 | `FROM customers c LEFT JOIN sales s ON c.customer_id = s.customer_id` |
| 주문 없는 고객만 | `LEFT JOIN ... WHERE s.id IS NULL` |

**✔️ JOIN 시 자주 쓰는 함수**

- `COALESCE(컬럼, 대체값)` : NULL이면 대체값 사용
- `COUNT(컬럼)` : LEFT JOIN에서 `COUNT(*)` 대신 `COUNT(오른쪽테이블.id)`

---

## 🔗 GROUP BY + JOIN

**여러 테이블 연결 후 그룹별 집계**

| 예시 | 설명 |
| --- | --- |
| 고객 유형별 평균 구매액 | `GROUP BY customer_type` |
| 모든 고객의 구매 현황 | `LEFT JOIN + GROUP BY` |

**실전 예시**

**✅ VIP 고객들의 구매 내역**

```sql
SELECT c.customer_name, s.product_name, s.total_amount
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id
WHERE c.customer_type = 'VIP';
```

**✅ 주문 없는 고객 찾기**

```sql
SELECT c.customer_name
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.id IS NULL;
```

**✅ 고객 유형별 평균 구매액**

```sql
SELECT c.customer_type, AVG(s.total_amount) AS 평균구매액
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_type;
```

---

## ⚖️ 서브쿼리 vs JOIN

| 상황 | 추천 |
| --- | --- |
| 단일 값 비교 (평균, 최대) | 서브쿼리 |
| 여러 조건 포함 여부 | 서브쿼리 + IN |
| 테이블 간 데이터 연결 | JOIN |
| 집계 + 연결 | JOIN + GROUP BY |

### ⚠️ 자주 하는 실수

✅ GROUP BY에 SELECT 컬럼 누락 X

✅ LEFT JOIN 시 `COUNT(*)` 대신 `COUNT(오른쪽.id)`

✅ JOIN에 별명(Alias) 꼭 쓰기
