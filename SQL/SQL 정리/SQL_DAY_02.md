## 📚 DAY 02


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