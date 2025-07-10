# 🧩 SQL_01

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
| %Y, %m, %d, %H, %i | 형식 기호 | %Y(연도), %m(월), %d(일), %H(시), %i(분) |

### 📌 시/분/초 형식 기호

| 기호 | 의미 | 예시 |
| --- | --- | --- |
| %H | 24시간제 시 (00–23) | 14 |
| %h | 12시간제 시 (01–12) | 02 |
| %i | 분 (00–59) | 05 |
| %S | 초 (00–59) | 09 |
| %p | AM/PM | AM, PM |

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

