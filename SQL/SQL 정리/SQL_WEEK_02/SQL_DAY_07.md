# 🧩 SQL_02

## 📚 DAY 07

## 🔍 MySQL EXPLAIN 기본 사용법

```sql
-- 데이터베이스 선택
USE lecture;

-- 1. 기본 EXPLAIN
EXPLAIN
SELECT * FROM sales WHERE total_amount > 500000;

-- 2. EXPLAIN EXTENDED (MySQL 5.1+)
EXPLAIN EXTENDED
SELECT * FROM sales WHERE total_amount > 500000;
SHOW WARNINGS;

-- 3. EXPLAIN FORMAT=JSON (MySQL 5.6+)
EXPLAIN FORMAT=JSON
SELECT * FROM sales WHERE total_amount > 500000;

-- 4. EXPLAIN ANALYZE (MySQL 8.0+)
EXPLAIN ANALYZE
SELECT * FROM sales WHERE total_amount > 500000;
```

---

## 🏗️ MySQL EXPLAIN 결과 구조

```sql
EXPLAIN
SELECT c.customer_name, s.product_name, s.total_amount
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id
WHERE c.customer_type = 'VIP';
```

| 컬럼 | 의미 |
| --- | --- |
| `id` | SELECT 단계 식별자 |
| `select_type` | SIMPLE / PRIMARY / SUBQUERY / DERIVED |
| `table` | 읽는 테이블명 |
| `type` | 접근 방법: system > const > eq_ref > ref > range > index > ALL |
| `possible_keys` | 사용 가능한 인덱스 |
| `key` | 실제 사용된 인덱스 |
| `key_len` | 인덱스 길이 |
| `ref` | 조인 조건 |
| `rows` | 예상 행 수 |
| `Extra` | 추가 정보 (Using where, Using index, Using temporary, Using filesort 등) |

---

## ⚖️ MySQL EXPLAIN vs PostgreSQL EXPLAIN

| 항목 | MySQL | PostgreSQL |
| --- | --- | --- |
| 출력 | 표(Table) | 트리(Tree) |
| 주요 컬럼 | `id`, `select_type`, `table`, `type`, `key`, `rows` | `cost`, `rows`, `width`, `actual time` |
| 분석 깊이 | 비교적 간단 | 비용 기반, 실제 통계 더 풍부 |
| 형식 | TEXT, JSON | TEXT, JSON, YAML 등 |
| 비용 정보 | 제한적 | 상세 cost, rows, width |
| 실제 통계 | MySQL 8.0+ | 기본 지원 (ANALYZE) |
| 메모리 정보 | 제한적 | BUFFERS 옵션 지원 |
| 접근 방식 | `type` 과 `Extra` 중심 | cost, rows, actual time |

```sql
-- PostgreSQL 예시
EXPLAIN SELECT * FROM large_orders WHERE customer_id = 'CUST-025000';

-- 결과 예:
Index Scan using idx_large_orders_customer_id on large_orders  (cost=0.42..8.45 rows=1 width=89)
  Index Cond: (customer_id = 'CUST-025000'::text)

```

✔️ **실무 팁**

- `type: ALL` (MySQL) → 인덱스 검토 필요
- `cost`가 큰 노드(PostgreSQL) → 쿼리 튜닝 대상

---

## 🔡 Datatype (PostgreSQL)

PostgreSQL은 **다양한 데이터 타입**을 지원해 복잡한 데이터를 유연하게 저장할 수 있음.

| 타입 | 설명 |
| --- | --- |
| `SERIAL` | 자동 증가 정수 (PK로 자주 사용) |
| `VARCHAR(n)` | 최대 n글자 문자열 |
| `INTEGER` | 정수 |
| `NUMERIC(12,2)` | 소수점 포함 숫자 |
| `BOOLEAN` | 참/거짓 |
| `TIMESTAMP` | 날짜/시간 |
| `TEXT[]` | 문자열 배열 |
| `JSONB` | JSON(Binary) 타입 |
| `INET` | IP 주소 저장 |
| `POINT` | (x,y) 기하학 좌표 |
| `INT4RANGE` | 범위 |

```sql
-- 테이블 예시
CREATE TABLE datatype_demo(
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  age INTEGER,
  salary NUMERIC(12, 2),
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT NOW(),
  tags TEXT[],
  metadata JSONB,
  ip_address INET,
  location POINT,
  salary_range INT4RANGE
);
```

✔️ **특징**

- `ARRAY`, `JSONB` 같이 구조화된 데이터 쉽게 다룸
- IP/좌표/범위 타입까지 가능 → 다양한 상황에서 유용

---

## 🌐 Large Dataset

대용량 데이터 실습: `generate_series`로 더미 데이터 생성해 연습.

```sql
-- 숫자 시리즈
SELECT generate_series(1, 10);

-- 날짜 시리즈
SELECT generate_series(
  '2024-01-01'::date,
  '2024-12-31'::date,
  '1 day'
);
```

### 👥 대용량 주문/고객 테이블 생성

- 주문 100만 건
- 고객 10만 명
- 랜덤 태그, JSON, 배열 포함

✔️ **핵심**

- `generate_series` + `random()` → 샘플 데이터 대량 생성
- JSONB와 배열로 데이터 구조 복잡성 연습
- 이후 `EXPLAIN` 연습용 데이터로 사용

---

## 🗺️ 실행 계획 (EXPLAIN / ANALYZE)

> ✅ EXPLAIN: 쿼리가 어떻게 실행될지 보여줌
> 
> 
> ✅ **ANALYZE**: 실제 실행하고 통계 출력
> 

📖 **비유:**

쿼리가 데이터를 어떻게 찾는지 *로드맵*을 그려봄 → 계획만 볼 수도 있고(Explain), 실제 경로/소요시간까지 측정할 수도 있음(Analyze).

```sql
-- 기본 실행 계획
EXPLAIN SELECT * FROM large_customers WHERE customer_type = 'VIP';

-- 실행 + 통계
EXPLAIN ANALYZE SELECT * FROM large_customers WHERE customer_type = 'VIP';
```

---

## 🔖 Index

🔍 **인덱스 = 책의 찾아보기**

> 📖 찾아보기(인덱스) 덕분에 500쪽 책에서 특정 단어를 빠르게 찾을 수 있음
> 
> 
> DB도 같은 원리 → 특정 컬럼에 인덱스를 걸면 탐색 속도 대폭 향상
> 

### 💡 핵심 개념

- **정렬된 데이터 구조(B-Tree)**: 대부분 B-Tree 기반 → 빠른 범위 검색과 정렬
- **해시 인덱스(Hash)**: 정확 일치 검색만 빠름, 범위/정렬 불가
- **포인터**: 인덱스는 키 + 데이터 위치 주소 저장

### 👍 장점

- SELECT 속도 향상 (`WHERE`, `JOIN`, `ORDER BY`, `GROUP BY`)
- `UNIQUE INDEX`로 컬럼 고유값 보장
- 기본 키 → 자동 인덱스 생성

### 👎 단점

- 저장 공간 소모
- 데이터 변경 시 인덱스 갱신 비용 → `INSERT/UPDATE/DELETE` 성능 저하

### 🏷️ 인덱스 종류

| 종류 | 설명 | 비유 |
| --- | --- | --- |
| **클러스터형** | 데이터 자체가 인덱스 순서로 정렬됨 | 책 본문이 정렬된 목차 |
| **비클러스터형** | 데이터는 따로, 인덱스는 별도 저장 | 책의 찾아보기 페이지 |
| **B-Tree** | 범위 검색/정렬 강점 | 책 목차 |
| **Hash** | 정확 일치 검색에 최적 | 해시태그처럼 정확히 연결 |

### 🧑‍💻 실전 예시

```sql
-- 단일 컬럼 인덱스
CREATE INDEX idx_employee_name ON employees (employee_name);

-- 복합 인덱스
CREATE INDEX idx_order_date_customer ON orders (order_date, customer_id);

-- 고유 인덱스
CREATE UNIQUE INDEX udx_user_email ON users (email);

-- 삭제
DROP INDEX idx_employee_name;
```

### 🧠 설계 팁

- 자주 검색/조인되는 컬럼에 인덱스 생성
- 선택도(Cardinality) 높을수록 효율적
- 너무 많은 인덱스 = 관리 비용 ↑
- 복합 인덱스는 컬럼 순서 중요 (WHERE 조건 맨 앞!)

---

## 🚀 성능 개선 사례

| 검색 유형 | 인덱스 없음 | B-Tree | Hash |
| --- | --- | --- | --- |
| 단일 정확 검색 | 매우 느림 | 매우 빠름 | 초고속 |
| 범위 검색 | 느림 | 매우 빠름 | ❌ |
| 복합 조건 | 느림 | 매우 빠름 | 제한적 |
| 정렬 포함 | 매우 느림 | 매우 빠름 | ❌ |

### 👨‍💼실무 가이드

- 범위 검색 → B-Tree 필수
- 정확 일치 → Hash 가능
- 불확실하면 B-Tree 선택
- 실제 쿼리 패턴, 데이터 분포 분석 → 맞춤 설계

### 🎯 결론

**인덱스는 선택이 아니라 필수!**

잘못 쓰면 독이 되고, 잘 쓰면 성능이 몇 배 이상 향상됨.

→ 실제 데이터로 성능 비교 → EXPLAIN → 필요시 튜닝 반복!