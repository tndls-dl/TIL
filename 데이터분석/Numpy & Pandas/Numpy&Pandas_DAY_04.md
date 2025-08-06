# 🔢🐼 Numpy & Pandas

## ✍️ DAY 04

## 👥 GroupBy (그룹화)

### 💡 개념

`GroupBy`는 데이터를 **공통된 기준으로 묶어서 요약**할 수 있는 기능이다.

마치 엑셀에서 **피벗 테이블**을 만드는 것과 비슷하다.

> **비유** : 마트에서 물건을 "카테고리별로" 정리해서 각각의 평균 가격을 보는 느낌!
> 

### 🏗️ 기본 구조

```python
df.groupby('열이름')
```

### 📊 그룹별 통계 요약

```python
df.groupby('category')['price'].mean()
```

---

## 🧮 집계 (Aggregation)

### 💡 개념

`sum`, `mean`, `count`, `max`, `min` 등의 **집계 함수**를 사용해 그룹별로 데이터를 요약할 수 있다.

### ✨ 다양한 집계

```python
df.groupby('type').agg({
    'price': 'mean',
    'sales': 'sum'
})
```

---

## 🪄⚙️ transform과 apply

### 💡 개념

- `transform`: **원래의 row 수를 유지하면서** 그룹 단위 연산
- `apply`: **그룹마다 다른 연산**을 자유롭게 적용할 수 있음

> **비유**: transform은 "비율 계산해서 원래 자리에 넣기", apply는 **"그룹마다 특수한 방법으로 계산하기"**
> 

**예시**

```python
df['normalized'] = df.groupby('category')['sales'].transform(lambda x: x / x.max())
```

---

## 📈 시각화

### 💡 개념

Pandas는 내부적으로 `matplotlib`을 사용하여 **데이터프레임에서 바로 그래프를 그릴 수 있음**

### 🛠️ 기본 사용법

```python
df['sales'].plot(kind='bar')
```

### 🤝 groupby와 함께

```python
df.groupby('month')['sales'].sum().plot(kind='line')
```

> **비유**: groupby로 "월별 매출 요약" → plot으로 "선 그래프"
> 

---

## 🔗 데이터 결합

### 💡 개념

`merge`, `concat`, `join` 등으로 **여러 데이터프레임을 합칠 수 있음**

| 방식 | 설명 |
| --- | --- |
| `merge` | SQL의 JOIN과 유사 |
| `concat` | 위아래 또는 좌우로 단순 연결 |
| `join` | 인덱스를 기준으로 병합 |

### ↔️ merge 예시

```python
pd.merge(df1, df2, on='key', how='inner')
```

### ➕ concat 예시

```python
pd.concat([df1, df2], axis=0)  # 세로로 붙이기
```