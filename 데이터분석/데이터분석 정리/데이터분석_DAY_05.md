# 📊 데이터 분석

## ✍️ DAY 05

## 🔧 이상치(Outlier) 처리

### 🎈 이상치

- 데이터 분포에서 **극단적으로 벗어난 값**
- 분석 결과 왜곡 → **모델 성능 저하** 가능성
- 따라서 **사전 탐지 및 적절한 처리** 필요

---

### 🔍 이상치 탐지 방법

### 🧮 Z-Score (표준점수)

- 평균과 표준편차를 기준으로 얼마나 떨어졌는지 계산
- 일반 기준: `|Z| > 3` 이상이면 이상치

**📝 `scipy` 활용 예시**

```python
from scipy import stats
z_scores = stats.zscore(df['가격'])
df[np.abs(z_scores) > 3]
```

### 📦 IQR (Interquartile Range, 사분위수)

- Q1 (25%) ~ Q3 (75%) 사이의 범위를 벗어난 값
- 기준: `Q1 - 1.5*IQR`, `Q3 + 1.5*IQR`

**📝 함수로 정의**

```python
def detect_outlier_iqr(series):
    Q1 = series.quantile(0.25)
    Q3 = series.quantile(0.75)
    IQR = Q3 - Q1
    return (series < Q1 - 1.5*IQR) | (series > Q3 + 1.5*IQR)

df[detect_outlier_iqr(df['가격'])]
```

### 💯 Percentile (백분위수 기반)

- 상위/하위 몇 % 기준 이상치 판단
- 유연하게 커스텀 가능 (예: 상위 97%, 하위 1%)

**📝 예시 코드**

```python
def detect_outlier_perc(series, lower=1, upper=97):
    return (series < series.quantile(lower / 100)) | (series > series.quantile(upper / 100))

df[detect_outlier_perc(df['가격'], 1, 97)]
```

---

### 🧰 이상치 처리 방법

### 🗑️ 제거 (Remove)

**📝 IQR 기준 이상치 제거**

```python
def remove_outliers_iqr(df, col):
    Q1 = df[col].quantile(0.25)
    Q3 = df[col].quantile(0.75)
    IQR = Q3 - Q1
    return df[(df[col] >= Q1 - 1.5*IQR) & (df[col] <= Q3 + 1.5*IQR)]
```

### ♻️ 변환 (Winsorization)

- 극단값을 특정 백분위 값으로 대체 (clip)

**📝 윈저화 함수**

```python
def winsorize_outliers(df, col, lower=5, upper=95):
    low = df[col].quantile(lower / 100)
    high = df[col].quantile(upper / 100)
    df[col] = df[col].clip(low, high)
    return df
```

### 🩹 대체 (Imputation)

- 이상치를 **중앙값 등으로 치환**하여 안정성 확보

**📝 중앙값으로 대체**

```python
def replace_outliers_with_median(df, col):
    Q1 = df[col].quantile(0.25)
    Q3 = df[col].quantile(0.75)
    IQR = Q3 - Q1
    lower = Q1 - 1.5 * IQR
    upper = Q3 + 1.5 * IQR
    med_val = df[col].median()
    outliers = (df[col] < lower) | (df[col] > upper)
    df.loc[outliers, col] = int(med_val)
    return df
```

---

### 📈 시각화를 통한 비교

- **히스토그램 / 박스플롯 / 산점도**로 이상치 탐색 및 처리 전후 비교 가능

| 비교 대상 | 시각화 예시 |
| --- | --- |
| 원본 데이터 | 가격 분포, 박스플롯, 수량 vs 가격 산점도 |
| 제거 후 | 이상치 제거된 가격 분포 및 산점도 |
| 변환 (윈저화) 후 | 윈저화된 데이터 분포 시각화 |
| 대체 (중앙값) 후 | 중앙값 대체된 가격 분포 확인 가능 |

> ✅ 시각화는 이상치 탐지와 처리 결과의 직관적인 검증 수단이 됨
> 

---

### 💡 실무 팁

- **탐지와 처리 전략은 함께 고려**해야 함
- 모델 민감도에 따라 제거보다 **변환/대체**가 유리한 경우도 많음
- **시각화는 필수**, 특히 산점도는 다른 변수와의 관계를 파악할 때 유용함