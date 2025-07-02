# 🧩 SQL_01

## 📚 DAY 01

## 💡 SQL이란?

- **SQL (Structured Query Language)**
    
    : 구조화된 데이터를 다루는 표준 언어
    
    → 데이터베이스에 **질문(쿼리)** 하고 답을 받는다.
    
- **주로 쓰는 DBMS**
    - RDBMS : MySQL, PostgreSQL, Oracle, SQLite, MariaDB
    - NoSQL : Document DB, Key-Value DB, Graph DB 등

---

## 🧩 **DB 기본 구조**

- **Database (DB)** : 데이터를 모아 놓는 **저장소**
- **Table** : DB 안의 표. 데이터는 행(Row)과 열(Column)로 저장됨.
- **Row (Record)** : 한 사람/하나의 항목 → 한 줄
- **Column (Field)** : 속성(이름, 나이 등)

---

## 📐 **스키마 (Schema)**

- 데이터베이스 구조와 제약 조건의 설계도
- 테이블 구조, 데이터 타입, 관계, 키 등 포함
- → 데이터 무결성과 효율성 유지

---

## ⚙️ **SQL 문법 핵심**

- **명령어는 대문자**, 내가 정한 이름은 소문자 → 관습(Convention)
- `;` 세미콜론으로 명령어 끝을 반드시 마무리!
- `-` 로 주석 작성 가능
- `Ctrl + Enter` : 현재 줄 실행 (툴 마다 다름)

---

## 📌 **DDL & DML**

| 구분 | DDL (정의) | DML (조작 |
| --- | --- | --- |
| 의미 | Data Definition Language | Data Manipulation Language |
| 목적 | DB 구조 만들고 바꾸기 | 데이터 값 추가, 수정, 삭제, 조회 |
| 대표 | CREATE, ALTER, DROP | INSERT, SELECT, UPDATE, DELETE |

---

## 🗂️ **핵심 명령어 흐름**

### **1) 데이터베이스 관리**

- **생성** `CREATE DATABASE db_name;`
- **조회** `SHOW DATABASES;`
- **삭제** `DROP DATABASE db_name;`
- **사용** `USE db_name;`

---

### **2) 테이블 관리**

- **생성**
    
    ```sql
    CREATE TABLE table_name (
      id INT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(30) NOT NULL
    );
    ```
    

- **구조 확인**
    - 테이블 목록 : `SHOW TABLES;`
    - 상세 구조 : `DESC table_name;`

- **구조 변경**
    - 컬럼 추가 : `ALTER TABLE table_name ADD COLUMN col_name DATATYPE;`
    - 컬럼 수정 : `ALTER TABLE table_name MODIFY COLUMN col_name DATATYPE;`
    - 컬럼 삭제 : `ALTER TABLE table_name DROP COLUMN col_name;`

- **삭제**
    
    `DROP TABLE table_name;`
    
    **3) 데이터 조작**
    

---

- **추가** `INSERT INTO table_name (col1, col2) VALUES ('A', 'B');`
- **조회** `SELECT * FROM table_name;`
- **조건 조회** `SELECT * FROM table_name WHERE 조건;`
- **수정** `UPDATE table_name SET col = value WHERE 조건;`
- **삭제** `DELETE FROM table_name WHERE 조건;`

---

## 🔑 **핵심 제약 조건**

| 제약 조건 | 의미 | 예시 |
| --- | --- | --- |
| PRIMARY KEY | 고유 식별자, 중복 & NULL 불가 | `id INT AUTO_INCREMENT PRIMARY KEY` |
| NOT NULL | 빈 값 불가 | `name VARCHAR(30) NOT NULL` |
| UNIQUE | 중복 방지 | `email VARCHAR(50) UNIQUE` |
| DEFAULT | 기본 값 | `join_date DATE DEFAULT(CURRENT_DATE)` |
| AUTO_INCREMENT | 자동 숫자 증가 | `id INT AUTO_INCREMENT` |

---

## ⚡ **주의할 점**

- `WHERE` 절 안 쓰면 테이블 전체에 영향!
    - `DELETE FROM table_name;` ❌ (전체 삭제)
    - `UPDATE table_name SET name = 'a';` ❌ (전체 수정)
- 항상 `WHERE` 절로 대상 한정 !
- `DROP DATABASE` `DROP TABLE` 은 돌이킬 수 없음 → `IF EXISTS` 사용 권장

---

## 🚫 **실수 주의**

- 세미콜론 빠짐
- WHERE 안 쓰고 UPDATE/DELETE
- DROP 시 IF EXISTS 빼 먹기

---

---

## 📚 DAY 02

---

## ✅ SELECT 기본 구조

```sql
SELECT 컬럼명 FROM 테이블명 WHERE 조건 ORDER BY 정렬기준 LIMIT 개수 OFFSET 개수;
```

- `SELECT` : 조회할 컬럼
- `FROM` : 대상 테이블
- `WHERE` : 조건 지정 (필터링)
- `ORDER BY` : 정렬
- `LIMIT` : 몇 개까지
- `OFFSET` : 앞에서 몇 개나 건너뛸 지

---

## 🔍 WHERE 조건식

| 연산자 | 의미 | 예시 |
| --- | --- | --- |
| = | 같다 | name = 'kim' |
| <> , != | 같지 않다 | id != 1 |
| > , >= | 크다 / 크거나 같다 | age >= 20 |
| < , <= | 작다 / 작거나 같다 | id < 5 |
| BETWEEN | 범위 | age BETWEEN 20 AND 40 |
| IN | 목록 | id IN (1, 3, 5) |
| LIKE | 패턴 | name LIKE '%kim%' |
| IS NULL | NULL 여부 | email IS NULL |
| IS NOT NULL | NOT NULL 여부 | email IS NOT NULL |
| AND | 모두 만족 | age > 20 AND id < 5 |
| OR | 하나 만족 | name = 'kim' OR name = 'lee' |
| NOT | 반대 | NOT name = 'kim' |

**LIKE 패턴 문자**

| 기호 | 의미 |
| --- | --- |
| `%` | 0개 이상의 **임의 문자(문자열)** |
| `_` | 정확히 1개 문자 |

---

## 📊 ORDER BY 정렬

```sql
-- 오름차순 (기본)
ORDER BY 컬럼명 ASC;

-- 내림차순
ORDER BY 컬럼명 DESC;

-- 다중 정렬 (우선순위: name → id)
ORDER BY name ASC, id DESC;
```

---

## 🗂️ 데이터 타입 정리

### 문자열 타입

| 타입 | 특징 | 사용 예시 |
| --- | --- | --- |
| CHAR(n) | 고정 길이 | 주민번호, 우편번호 |
| VARCHAR(n) | 가변 길이 | 이름, 이메일 |
| TEXT | 긴 문자열 (~65KB) | 게시글 내용 |
| LONGTEXT | 매우 긴 텍스트 (~4GB) | 대용량 문서 |

### 숫자 타입

| 타입 | 크기 | 특징 | 사용 예시 |
| --- | --- | --- | --- |
| TINYINT | 1바이트 | -128 ~ 127 | 나이, 등급 |
| INT | 4바이트 | -21억 ~ 21억 | ID, 개수 |
| BIGINT | 8바이트 | 큰 정수 | 조회수, 금액 |
| FLOAT | 4바이트 | 소수점 7자리 | 점수, 비율 |
| DOUBLE | 8바이트 | 소수점 15자리 | 정밀 계산 |
| DECIMAL(m,d) | 가변 | 정확한 소수 | 금액, 정밀 계산 |

### 날짜/시간 타입

| 타입 | 형식 | 사용 예시 |
| --- | --- | --- |
| DATE | YYYY-MM-DD | 생년월일 |
| TIME | HH:MM:SS | 시/분/초 |
| DATETIME | YYYY-MM-DD HH:MM:SS | 정확한 시점 |
| TIMESTAMP | YYYY-MM-DD HH:MM:SS | 자동 갱신 시각 |

---

## 🔤 문자열 함수

| 함수 | 설명 | 예시 | 결과 |
| --- | --- | --- | --- |
| CHAR_LENGTH(str) | 문자열 길이 | CHAR_LENGTH('hello') | 5 |
| CONCAT(str1, str2) | 문자열 연결 | CONCAT('A', 'B') | 'AB' |
| UPPER(str) | 대문자 | UPPER('hello') | 'HELLO' |
| LOWER(str) | 소문자 | LOWER('HELLO') | 'hello' |
| SUBSTRING(str, pos, len) | 부분 추출 | SUBSTRING('hello', 2, 3) | 'ell' |
| LEFT(str, len) | 왼쪽 n글자 | LEFT('hello', 3) | 'hel' |
| RIGHT(str, len) | 오른쪽 n글자 | RIGHT('hello', 3) | 'llo' |
| REPLACE(str, old, new) | 치환 | REPLACE('hello', 'l', 'x') | 'hexxo' |
| LOCATE(substr, str) | 위치 찾기 | LOCATE('ll', 'hello') | 3 |
| TRIM(str) | 공백 제거 | TRIM(' hello ') | 'hello' |

---

## ✏️ 실무 예시 모음

```sql
-- 이메일에서 사용자명 추출
SELECT email, SUBSTRING(email, 1, LOCATE('@', email) - 1) AS username
FROM member
WHERE email IS NOT NULL;

-- 이름에 '수'가 포함되고 gmail 사용자
SELECT * FROM member
WHERE name LIKE '%수%' AND email LIKE '%gmail%';

-- 이름과 이메일을 한 줄로 출력
SELECT CONCAT(name, '(', email, ')') AS member_info
FROM member;
```

---

## ⚠️ 주의사항

- `= NULL` ❌ → `IS NULL` ✅
- `ORDER BY`는 성능 영향 큼 → `LIMIT`, `OFFSET` 활용
- `LIKE`는 `%`의 위치로 인덱스 사용 여부가 갈림
- 문자열 함수는 대량 데이터에서 성능 영향 있음

---

---
## 📚 DAY 03

## 🗓️ 날짜/시간 함수 (Datetime Functions)

| 함수 | 설명 | 예시 |
| --- | --- | --- |
| NOW() | 현재 날짜 + 시간 | SELECT NOW(); |
| CURDATE() | 현재 날짜만 | SELECT CURDATE(); |
| CURTIME() | 현재 시간만 | SELECT CURTIME(); |
| CURRENT_TIMESTAMP | NOW() 동일 | SELECT CURRENT_TIMESTAMP; |
| DATE_FORMAT() | 날짜 형식 변환 | DATE_FORMAT(birth, '%Y년 %m월 %d일') |
| DATEDIFF() | 날짜 간 일수 차이 | DATEDIFF(CURDATE(), birth) |
| TIMESTAMPDIFF() | 기간 단위 차이 | TIMESTAMPDIFF(YEAR, birth, CURDATE()) |
| DATE_ADD() | 날짜 더하기 | DATE_ADD(birth, INTERVAL 1 YEAR) |
| DATE_SUB() | 날짜 빼기 | DATE_SUB(birth, INTERVAL 10 MONTH) |
| YEAR(), MONTH(), DAY() | 날짜 요소 추출 | YEAR(birth), MONTH(birth) |
| DAYOFWEEK(), DAYNAME() | 요일 번호/이름 | DAYOFWEEK(birth), DAYNAME(birth) |
| %Y, %m, %c, %d, %H, %i | 형식 기호 | %Y(연도), %m(월), %c(월-한자리), %d(일), %H(시), %i(분) |

### 📌 `%m` vs `%c` 비교 정리

| 형식 기호 | 의미 | 예시 결과 |
| --- | --- | --- |
| `%m` | **두 자리 월** (01~12) | 01, 02, …, 12 |
| `%c` | **한 자리 월** (1~12, 앞에 0 안 붙음) | 1, 2, …, 12 |

예를 들어:

```sql
SELECT DATE_FORMAT('2025-07-02', '%Y-%m') AS 두자리_월,
       DATE_FORMAT('2025-07-02', '%Y-%c') AS 한자리_월;
```

**결과**

| 두자리_월 | 한자리_월 |
| --- | --- |
| 2025-07 | 2025-7 |

💡 **실무 팁**

- **`%m`** : 데이터 정렬, 파일명에 주로 사용 (자릿수 맞춤)
- **`%c`** : 사람 읽기 편한 출력

필요하다면 `%e`도 알아두세요!

- **`%e`** → 일(day)을 한 자리 숫자로 출력 (`1`~`31`)

---

## 🔢 숫자 함수 (Number Functions)

| 함수 | 설명 | 예시 |
| --- | --- | --- |
| ROUND() | 반올림 | ROUND(score, 1) |
| CEIL() | 올림 | CEIL(score) |
| FLOOR() | 내림 | FLOOR(score) |
| TRUNCATE() | 소수점 버림 | TRUNCATE(score, 1) |
| ABS() | 절댓값 | ABS(score - 80) |
| MOD(), % | 나머지 | MOD(id, 2), id % 2 |
| POWER() | 거듭제곱 | POWER(score, 2) |
| SQRT() | 제곱근 | SQRT(score) |

---

## 🧠 조건 함수 (Conditional Functions)

| 함수 | 설명 | 예시 |
| --- | --- | --- |
| IF() | 단순 조건 분기 | IF(score >= 80, '우수', '보통') |
| CASE WHEN | 다중 조건 분기 | CASE WHEN score >= 90 THEN 'A' ELSE 'B' END |
| IFNULL() | NULL 처리 | IFNULL(nickname, '미설정') |
| COALESCE() | 첫 번째 NULL 아님 값 | COALESCE(nickname, name, 'Unknown') |

---

## 🎯 집계 함수 (Aggregate Functions)

| SQL | Excel/Sheets | 설명 |
| --- | --- | --- |
| COUNT(*) | =COUNT() | 행 개수 |
| COUNT(DISTINCT) | - | 중복 제거 개수 |
| SUM() | =SUM() | 합계 |
| AVG() | =AVERAGE() | 평균 |
| MIN() | =MIN() | 최소값 |
| MAX() | =MAX() | 최대값 |

---

## 👥 GROUP BY & 피벗 테이블

**기본 패턴**

```sql
SELECT
  category,             -- 피벗 행
  COUNT(*) AS 주문건수,  -- 피벗 값
  SUM(total_amount) AS 매출액
FROM sales
GROUP BY category
ORDER BY 매출액 DESC;
```

**교차분석 (Cross Tab)**

```sql
SELECT
  region,
  SUM(
	  CASE 
		  WHEN category = '전자제품' THEN total_amount 
		  ELSE 0 
		  END
		  ) AS 전자제품,
  SUM(
	  CASE 
		  WHEN category = '의류' THEN total_amount 
		  ELSE 0 
		  END
		  ) AS 의류
FROM sales
GROUP BY region;
```

---

## 🔍 HAVING = 피벗 필터

| 구분 | 설명 | 예시 |
| --- | --- | --- |
| WHERE | 원본 행 필터 | WHERE total_amount >= 1000000 |
| HAVING | 그룹 결과 필터 | HAVING SUM(total_amount) >= 1000000 |
- **WHERE**: GROUP BY 전에 조건 걸기 (개별 행 필터)
- **HAVING**: GROUP BY 후에 조건 걸기 (집계 조건 필터)
- 🔑 **집계함수(`SUM()`, `AVG()`, `COUNT()` 등)** 조건은 무조건 `HAVING`

### 📌 WHERE vs HAVING 요약 표

| 비교 | WHERE | HAVING |
| --- | --- | --- |
| 위치 | GROUP BY 전에 실행 | GROUP BY 후에 실행 |
| 대상 | 개별 행(원본 데이터) | 그룹핑된 결과 |
| 사용 가능 조건 | 일반 조건 | 집계 조건 |
| 예시 | `WHERE score >= 80` | `HAVING AVG(score) >= 80` |

---

## 💡 실전 쿼리 예시 패턴

| 케이스 | 쿼리 패턴 |
| --- | --- |
| **대시보드 요약** | SELECT COUNT(*), SUM(), AVG(), MAX() ... |
| **월별 트렌드** | GROUP BY DATE_FORMAT(order_date, '%Y-%m') |
| **우수고객/사원** | HAVING으로 평균조건 걸기 |
| **교차분석 (Crosstab)** | CASE WHEN으로 행/열 분기 |

---

---