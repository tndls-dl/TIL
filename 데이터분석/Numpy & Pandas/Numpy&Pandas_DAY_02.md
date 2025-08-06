# 🔢🐼 Numpy & Pandas

## ✍️ DAY 02

### Numpy 유틸리티 함수

### 🤔 `np.where()`

조건에 따라 값을 선택하거나, 조건을 만족하는 인덱스를 반환하는 함수입니다.

- **형식**: `np.where(조건, 참일 때 값, 거짓일 때 값)`
- **활용**: 조건부 치환, 조건 만족 위치 찾기

```python
import numpy as np
arr = np.array([1, 2, 3, 4])
np.where(arr > 2, 100, 0)  # [0, 0, 100, 100]
```

---

### 🏆 `np.argmax()` / `np.argmin()`

배열에서 최댓값 또는 최솟값의 **인덱스**를 반환합니다.

다차원 배열의 경우 `axis`를 지정하여 행 또는 열 기준으로 구할 수 있습니다.

```python
a = np.array([[10, 20, 30], [40, 5, 6]])
np.argmax(a)         # 전체 중 최대값 위치: 3
np.argmax(a, axis=0) # 열별 최대값 위치: [1 0 0]
```

---

### 🔑 `np.unique()`

배열에서 중복을 제거하고 **고유한 값들만 정렬**하여 반환합니다.

`return_counts=True` 옵션을 사용하면 각 값의 등장 횟수도 함께 확인할 수 있습니다.

```python
a = np.array([3, 1, 2, 1, 3])
np.unique(a)  # [1 2 3]
np.unique(a, return_counts=True)  # (array([1, 2, 3]), array([2, 1, 2]))
```

---

### 📏 `np.linspace()` / `np.arange()`

- `linspace()` : 지정 구간을 동일한 간격으로 나눈 값을 생성
- `arange()` : 시작값부터 일정 간격으로 값 생성 (Python의 range 유사)

```python
np.linspace(0, 1, 5)   # [0. , 0.25, 0.5 , 0.75, 1. ]
np.arange(0, 5, 1.5)   # [0. , 1.5, 3. ]
```

---

### 🔄 `np.reshape()` / `np.ravel()` / `np.flatten()`

- `reshape()` : 배열 모양 변경 (원소 수 유지)
- `ravel()` : 다차원 → 1차원 (참조 반환)
- `flatten()` : 다차원 → 1차원 (복사본 반환)

```python
a = np.array([[1, 2], [3, 4]])
a.reshape(4,)    # [1 2 3 4]
a.ravel()        # [1 2 3 4]
a.flatten()      # [1 2 3 4]
```

---

### 🔁 `np.repeat()` / `np.tile()`

- `repeat()` : 각 원소를 반복
- `tile()` : 배열 전체를 반복하여 확장

```python
a = np.array([1, 2])
np.repeat(a, 3)  # [1 1 1 2 2 2]
np.tile(a, 2)    # [1 2 1 2]
```

---

### 🎯 axis 개념 요약

- `axis=0` : **세로 방향**, 행 고정 → 열끼리 연산
- `axis=1` : **가로 방향**, 열 고정 → 행끼리 연산

```python
a = np.array([[1, 2], [3, 4]])
np.sum(a, axis=0)  # [4, 6]  (열끼리 합)
np.sum(a, axis=1)  # [3, 7]  (행끼리 합)
```

> 시각적으로 axis=0은 ↓ 방향, axis=1은 → 방향의 연산으로 이해하면 직관적입니다.


---
---
# 🐼 Pandas

Pandas는 **표 형태의 데이터**(행과 열)를 다루기 위한 Python 라이브러리입니다.

데이터 과학과 분석 분야에서 가장 널리 사용되며, 엑셀보다 훨씬 강력한 기능을 갖고 있습니다.

> "Pandas는 정형 데이터 처리의 필수 도구입니다."
> 

- 강점:
    - 다양한 데이터 소스를 불러오고 정제하기 쉬움
    - 행/열 구조로 데이터를 쉽게 다룸
    - 통계/집계/변환/시각화 기능 지원
    - Numpy와 호환 가능

---

## 🏗️ 주요 데이터 구조

### Series (1차원)

- 1차원 데이터(리스트나 배열) + 인덱스
- Numpy 배열과 비슷하지만, **인덱스를 명시할 수 있음**

```python
import pandas as pd

s = pd.Series([10, 20, 30], index=['a', 'b', 'c'])
```

> → s['a']는 10을 반환
> 

---

### ➡️ DataFrame (2차원)

- 표(table) 형식의 구조 (행 + 열)
- 여러 개의 Series로 구성된 것과 유사

```python
data = {
    '이름': ['철수', '영희'],
    '점수': [85, 90]
}
df = pd.DataFrame(data)
```

> df['이름'] → Series, df[['이름', '점수']] → DataFrame
> 

---

## ℹ️ 기본 속성 확인

| 속성 | 설명 | 예시 |
| --- | --- | --- |
| `.shape` | 행과 열의 수 반환 | `df.shape → (2, 2)` |
| `.columns` | 열 이름 확인 | `df.columns` |
| `.index` | 행 인덱스 확인 | `df.index` |
| `.dtypes` | 각 열의 데이터 타입 | `df.dtypes` |
| `.info()` | 전체 구조 요약 | `df.info()` |

---

## ✂️ 데이터 선택 및 슬라이싱

**🔸 열 선택**

```python
df['이름']      # 단일 열 (Series)
df[['이름']]     # DataFrame
```

**🔸 행 선택**

- `.loc[]`: 이름 기반 접근
- `.iloc[]`: 정수 기반 접근

```python
df.loc[0]     # 첫 번째 행
df.iloc[1]    # 두 번째 행
```

> iloc은 numpy의 인덱싱과 유사하게 작동
> 

---

## 🔍 조건 필터링 (Boolean Indexing)

조건에 따라 특정 행만 선택할 수 있습니다.

```python
df[df['점수'] > 85]
```

복합 조건은 `&`, `|` 를 사용하며, 괄호로 감싸야 합니다.

```python
df[(df['점수'] > 80) & (df['이름'] == '영희')]
```

또는 `query()` 방식도 사용 가능:

```python
df.query("점수 > 80 and 이름 == '영희'")
```

---

## 🩹 결측치 처리

| 함수 | 설명 |
| --- | --- |
| `isnull()` | 결측값 여부 확인 |
| `dropna()` | 결측값 제거 |
| `fillna()` | 결측값 대체 |

```python
df.dropna()
df.fillna(0)
```

---

## 📝 통계 요약

```python
df['점수'].mean()        # 평균
df['점수'].sum()         # 총합
df['점수'].describe()    # 기초 통계 요약
df['이름'].value_counts() # 값 개수 세기
```

---

## 👥 그룹화와 집계: `groupby()`

특정 열을 기준으로 묶어서 집계할 수 있습니다.

```python
df.groupby('이름')['점수'].mean()
df.groupby('이름').agg({'점수': ['mean', 'max']})
```

> "학생별 평균과 최고 점수를 알고 싶을 때 유용"
> 

---

## 🔀 정렬과 인덱스 조작

**🔸 정렬**

```python
df.sort_values(by='점수', ascending=False)
```

**🔸 인덱스 설정 / 초기화**

```python
df.set_index('이름')
df.reset_index()
```

---

## 📈 간단한 시각화

```python
import matplotlib.pyplot as plt

df.plot(kind='bar', x='이름', y='점수')
plt.title("학생별 점수")
plt.show()
```

---

## ↔️ Pandas와 Numpy 차이

| 항목 | NumPy | Pandas |
| --- | --- | --- |
| 구조 | 배열 (ndarray) | 표 (DataFrame) |
| 인덱싱 | 정수 기반 | 라벨 기반 가능 |
| 사용 분야 | 수치 연산 중심 | 데이터 분석 중심 |
| 열 이름 | 없음 | 있음 |