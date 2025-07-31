# 📊 데이터 분석

## ✍️ DAY 03

## 💾 CSV 파일 로드 & 저장

### ✨ 개념

CSV 파일은 엑셀처럼 행과 열로 구성된 텍스트 기반 데이터 파일이다.

한글이 포함된 경우 인코딩(EUC-KR, UTF-8 등)을 정확히 지정해야 데이터가 깨지지 않는다.

**📝 예시**

```python
import pandas as pd

# 파일 읽기
df = pd.read_csv('./namsan.csv', encoding='EUC-KR', dtype={
    'ISBN': str, '세트 ISBN': str
})

# 파일 저장
df.to_csv('./test.csv', encoding='utf-8', index=False)
```

### 💡 팁

- `dtype`을 지정하면 숫자처럼 보이는 값도 문자열로 불러올 수 있다. (예: ISBN)
- 저장할 때는 `index=False` 를 넣지 않으면 인덱스 열이 추가로 저장된다 !

---

## 🩹 결측치 처리 (Missing Values)

### ✨ 개념

누락된 데이터(NaN)는 분석 결과에 영향을 미칠 수 있으므로 반드시 확인하고 처리해야 한다.

대표적인 처리 방법은 **확인 → 삭제 or 채우기 → 보간**

### 🔍 결측치 확인

```python
df.isna().sum()           # 컬럼별 결측치 개수
df.isna().mean() * 100    # 결측치 비율(%)
```

### 🚦 결측치가 있는 행/없는 행

```python
df[df.isna().any(axis=1)]   # 결측치 있는 행만
df[df.notna().all(axis=1)]  # 결측치 없는 행만
```

### 🗑️ 결측치 삭제

```python
df.dropna()                             # 결측치 있는 행 제거
df.dropna(subset=['이름', '성별'])      # 특정 열 기준
df.dropna(axis=1, how='all')            # 전체가 NaN인 열만 제거
```

### ➕ 결측치 채우기

```python
df.fillna(0)  # 기본값으로 채우기

# 열마다 다른 값으로 채우기
df.fillna({'이름': '익명', '급여': df['급여'].mean()})

# 앞/뒤 값 복사해서 채우기
df.ffill()  # 이전 값
df.bfill()  # 다음 값
```

### 〰️ 보간법 (Interpolate)

```python
df.interpolate(method='linear')  # 선형 보간
df.interpolate(method='time')    # 시계열 보간 (datetime 인덱스 필수)
```

### 💡 팁

- 결측치가 많을 땐 `df.isna().sum().plot(kind='bar')` 로 시각화 해보기
- 시간 기반 데이터는 `method='time'` 을 쓰면 자연스럽게 채워진다 !

---

## 🔠 문자열 처리

### ✨ 개념

문자열 컬럼은 `.str` 접근자를 통해 문자열 메서드를 쓸 수 있다.

**📝 문자열 메서드 예시**

```python
df['이메일'].str.upper()                  # 대문자 변환
df['이메일'].str.contains('gmail')       # 포함 여부
df['전화번호'].str.replace('-', '')      # 문자 제거
```

### 🤏 문자열 추출 / 분리

```python
df['이메일'].str.extract(r'@([^.]+)')              # 이메일 도메인 추출
df['이메일'].str.split('@', expand=True)           # 사용자명 / 도메인 분리
```

### 💡 팁

- `.str.extract()`는 정규표현식을 쓸 수 있어 복잡한 패턴 추출도 가능해요
- 분리한 값은 새로운 컬럼으로도 저장 가능해요 (`df[['user', 'domain']] = ...`)

---

## 🔀 데이터 타입 변환

### ✨ 개념

데이터 타입이 잘못되면 연산이 불가능하거나 오류가 발생할 수 있다.

Pandas에서는 `astype()`, `pd.to_datetime()`, `pd.to_numeric()` 등을 사용한다.

**📝 예시**

```python
df['정수형'] = df['정수형'].astype(int)
df['불리언'] = df['불리언'].astype(bool)
df['날짜'] = pd.to_datetime(df['날짜'])

pd.to_numeric(df['혼합형'], errors='coerce')  # 변환 불가 → NaN
```

### 💡 팁

- `errors='coerce'`로 설정하면 변환 불가능한 값은 NaN으로 처리된다.
- `astype(str)`을 쓰면 숫자 → 문자로 쉽게 바꿀 수 있다.

---

## ↕️ 열(Column) 처리

### ❌ 열 삭제 / 이름 변경

```python
df.drop('비고', axis=1)
df.rename(columns={'국어점수': '국어'})
```

### ➡️ 열 순서 변경 / 추가

```python
df = df[['이름', '학번', '국어', '영어']]  # 열 순서 재정렬
df['총점'] = df[['국어', '영어', '수학']].sum(axis=1)
```

### ⚖️ 조건 기반 열 생성

```python
df['성적등급'] = pd.cut(df['평균'], bins=[0, 70, 80, 90, 100], labels=['D', 'C', 'B', 'A'])
```

### 💡 팁

- `pd.cut()`을 사용하면 구간별로 자동 등급을 나눌 수 있다.
- 새로운 파생 컬럼은 분석에 큰 도움을 준다 !

---

## ↔️ 행(Row) 처리

### 🗑️🔎 행 삭제 / 필터링

```python
df.drop(0)                     # 첫 번째 행 삭제
df[df['나이'] < 30]           # 조건 필터링
```

### 🧹 중복 제거 / 정렬 / 인덱스 초기화

```python
df.drop_duplicates()
df.sort_values('급여', ascending=False)
df.reset_index(drop=True)
```

### 💡 팁

- 여러 조건 정렬: `df.sort_values(['부서', '급여'], ascending=[True, False])`
- 정렬 후에는 `reset_index()` 로 인덱스를 정리하는 게 좋다.