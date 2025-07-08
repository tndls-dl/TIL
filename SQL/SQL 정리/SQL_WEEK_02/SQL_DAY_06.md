## 📚 DAY 06

## 🔗 **관계 설계 완전 정리**

### 🤝 **1:1 관계 (One-to-One)**

**예시:** `employees` ↔ `employee_details`

**특징:**

- 같은 PK
- 민감 정보 분리 (보안)
- CASCADE로 데이터 무결성 유지

```sql
CREATE TABLE employees (
  emp_id INT PRIMARY KEY,
  emp_name VARCHAR(50),
  department VARCHAR(30)
);

CREATE TABLE employee_details (
  emp_id INT PRIMARY KEY,
  social_number VARCHAR(20),
  salary DECIMAL(10,2),
  FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE
);
```

### 🤝 **1:N 관계 (One-to-Many)**

**예시:** 고객(`customers`) ↔ 주문(`sales`)

**특징:**

- 외래키는 항상 'N'쪽에 둔다.
- 부모 삭제 시 자식 처리 방법 중요!

```sql
SELECT
  c.customer_id,
  c.customer_name,
  COUNT(s.id) AS 주문횟수,
  GROUP_CONCAT(s.product_name) AS 주문제품들
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name;

📌 **N:M 관계 (Many-to-Many)**
```

### **🤝 N:M 관계 (Many-to-Many)**

**예시:** 학생(`students`) ↔ 수업(`courses`)

중간 테이블(`students_courses`) 필요!

```sql
-- 학생 테이블
CREATE TABLE students (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(20)
);

-- 수업 테이블
CREATE TABLE courses (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50),
  classroom VARCHAR(20)
);

-- 중간 테이블
CREATE TABLE students_courses (
  student_id INT,
  course_id INT,
  grade VARCHAR(5),
  PRIMARY KEY (student_id, course_id),
  FOREIGN KEY(student_id) REFERENCES students(id),
  FOREIGN KEY(course_id) REFERENCES courses(id)
);
```

💡 **중간 테이블 특징:**

- 다대다 관계 연결
- 추가 정보(예: 성적) 저장 가능
- 복합 PK로 유일성 보장

---

## 🧩 **고급 JOIN 패턴**

### 🌍 **FULL OUTER JOIN**

**👉 핵심:**

- **LEFT JOIN + RIGHT JOIN = FULL OUTER JOIN**
- MySQL에는 FULL OUTER JOIN이 따로 없음 → `UNION`으로 구현

**💡 언제 씀?**

- 데이터 무결성 검사
- 왼쪽/오른쪽 모두 존재하지 않는 데이터 찾기
- 마스터 데이터 통합

```sql
-- FULL OUTER JOIN 대신 LEFT + RIGHT + UNION
SELECT 'LEFT에서' AS 출처, c.customer_name, s.product_name
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id

UNION

SELECT 'RIGHT에서' AS 출처, c.customer_name, s.product_name
FROM customers c
RIGHT JOIN sales s ON c.customer_id = s.customer_id
WHERE c.customer_id IS NULL;
```

### 📊 **JOIN 관계 핵심 도식**

| JOIN 유형 | 설명 | 간단 그림 (텍스트) |
| --- | --- | --- |
| `INNER JOIN` | 양쪽 다 존재 | ⚪️ ∩ ⚪️ |
| `LEFT JOIN` | 왼쪽 기준, 오른쪽 없으면 NULL | ⚪️ ⬅️ |
| `RIGHT JOIN` | 오른쪽 기준, 왼쪽 없으면 NULL | ➡️ ⚪️ |
| `FULL OUTER JOIN` | 양쪽 다 포함 | ⚪️ ∪ ⚪️ |

![이미지](../images/screenshot8.png) 

### 🗣️ **텍스트로 그린 비유**

```
[INNER JOIN]
 A: 고객
 B: 주문

   (A)
    ●─────● (B)
   교집합만 선택됨

[LEFT JOIN]
 A: 고객
 B: 주문

   ●─────●
   ▲
  A만 가져옴
  B 없으면 NULL

[RIGHT JOIN]
   ●─────●
           ▲
           B만 가져옴
           A 없으면 NULL

[FULL OUTER JOIN]
   ●─────●
   양쪽 전체
   NULL 허용
```

### ✖️ **CROSS JOIN**

**👉 핵심:**

- 모든 조합(카르테시안 곱)
- ON 조건 없음
- 조인 조건 없으면 폭발적 행수!

```sql
SELECT
  c.customer_name,
  p.product_name
FROM customers c
CROSS JOIN products p;
```

**💡 실무 예시:**

- 구매 안 한 상품 추천
- 달력 테이블 만들기
- 시나리오 조합 분석

### 🔄 **SELF JOIN**

**👉 핵심:**

- 같은 테이블끼리 JOIN
- 예: 상사-직원, 고객 유사성

```sql
sql
복사편집
-- 상사-직원
SELECT
  상사.name AS 상사명,
  직원.name AS 직원명
FROM employees 상사
LEFT JOIN employees 직원 ON 직원.id = 상사.id + 1;

-- 고객 유사성
SELECT
  c1.customer_id, c1.customer_name,
  c2.customer_id, c2.customer_name,
  COUNT(DISTINCT s1.category) AS 공통구매카테고리수,
  GROUP_CONCAT(DISTINCT s1.category) AS 공통카테고리
FROM customers c1
INNER JOIN sales s1 ON c1.customer_id = s1.customer_id
INNER JOIN customers c2 ON c1.customer_id < c2.customer_id
INNER JOIN sales s2 ON c2.customer_id = s2.customer_id AND s1.category = s2.category
GROUP BY c1.customer_id, c2.customer_id
ORDER BY 공통구매카테고리수 DESC;

```

---

## 🕵️‍♀️ **고급 서브쿼리 연산자**

### ✨ **ANY**

- 서브쿼리 결과 중 하나라도 만족 → TRUE

```sql
-- VIP 최소 주문액보다 높은 일반고객 주문
SELECT customer_id, total_amount
FROM sales
WHERE total_amount > ANY (
  SELECT s.total_amount
  FROM sales s
  JOIN customers c ON s.customer_id = c.customer_id
  WHERE c.customer_type = 'VIP'
);
```

### ✅ **ALL**

- 서브쿼리 결과 모두를 만족해야 TRUE

```sql
-- VIP 최대 주문액보다 더 큰 주문
SELECT customer_id, total_amount
FROM sales
WHERE total_amount > ALL (
  SELECT s.total_amount
  FROM sales s
  JOIN customers c ON s.customer_id = c.customer_id
  WHERE c.customer_type = 'VIP'
);
```

### 🤔 **EXISTS vs IN**

```sql
-- IN 방식
SELECT customer_id FROM customers
WHERE customer_id IN (SELECT customer_id FROM sales WHERE category = '전자제품');

-- EXISTS 방식
SELECT customer_id FROM customers c
WHERE EXISTS (
  SELECT 1 FROM sales s WHERE s.customer_id = c.customer_id AND s.category = '전자제품'
);
```

✅ **차이점**

- EXISTS: 조건만 있으면 O(1)
- IN: 값 비교(리스트 짧을 때 OK)

---

## **⚔️ PostgreSQL vs MySQL 핵심**

| 구분 | MySQL | PostgreSQL |
| --- | --- | --- |
| 철학 | 빠르고 단순 | 표준/복잡 쿼리 강점 |
| 강점 | 단순 CRUD | 고급 쿼리/데이터타입 |
| 특화 | JSON, 배열, 범위 | generate_series 등 |
| 성능 | 웹 읽기 빠름 | 대용량 분석 강함 |

✅ **PostgreSQL 특화 예시**

```sql
-- generate_series
SELECT generate_series(1, 1000000);
```

```sql
-- 배열 검색
SELECT * FROM orders WHERE '전자제품' = ANY(categories);

-- JSONB 검색
SELECT * FROM orders WHERE details @> '{"express": true}';
```

---

## 🔍 **EXPLAIN**

| MySQL | PostgreSQL |
| --- | --- |
| 간단 테이블 | 트리 + 비용 |
| type: const > eq_ref > ref > range > index > ALL | cost, rows, buffers |

```sql
EXPLAIN SELECT * FROM sales;

EXPLAIN ANALYZE SELECT * FROM orders;
```