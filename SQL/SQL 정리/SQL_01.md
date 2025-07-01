# 🧩 SQL_01

## 📊 DAY 01

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

### ✅ **1) 데이터베이스 관리**

- **생성** `CREATE DATABASE db_name;`
- **조회** `SHOW DATABASES;`
- **삭제** `DROP DATABASE db_name;`
- **사용** `USE db_name;`

---

### ✅ **2) 테이블 관리**

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
    

---

### ✅ **3) 데이터 조작**

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