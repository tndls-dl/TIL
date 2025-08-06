# 🔢🐼 Numpy & Pandas

## ✍️ DAY 06

## 📈 시계열(Time Series) 데이터 분석

### 🗓️ 시계열 데이터

- **시간의 흐름에 따라 수집된 데이터**
- Pandas는 시계열 분석을 위한 다양한 기능 제공
    
    👉 `pd.to_datetime()`, `pd.date_range()`, `DatetimeIndex`, `resample()`, `rolling()` 등
    

---

### ⚙️ 날짜 처리와 변환

- 다양한 문자열 날짜 포맷을 자동으로 변환
    
    👉 `pd.to_datetime("2025년8월6일")` → `Timestamp('2025-08-06')`
    
- 예외 발생 시 `try-except` 처리로 안정성 확보

---

### 🔗 날짜 인덱스 생성

```python
pd.date_range(start='2023-01-01', end='2023-12-31', freq='D|M|W')
```

- `'D'`: 일별, `'M'`: 월 말, `'W'`: 주간(일요일 기준)

---

### 📄 시계열 데이터프레임 구성

- 일별 매출 시뮬레이션 데이터 생성 (주기 포함)
- 음수 제거 → `.clip(lower=10000)`
- `set_index('date')`로 **날짜 인덱스** 설정

---

### 🔍 날짜 속성 추출

```python
df.index.year / month / day / weekday
df.index.day_name()  # 요일 이름
df.index.quarter     # 분기
```

---

### 📊 그룹 분석 & 시각화

- 요일/월/분기별 평균 매출

```python
df.groupby('weekname')['sales'].mean()
```

- 📌 `reindex()`로 요일 순서 정렬 가능

**📝 주요 시각화**

- 일별 매출 추이
- 요일별 평균 매출 (막대그래프)
- 월별/분기별 평균 매출
- 월별 박스플롯 (분포 비교)

---

### 🧪 날짜 인덱싱 & 조건 필터링

```python
df['2023-01']              # 월 전체
df['2023-01-01':'2023-01-15']  # 범위 지정
df.loc['2023-06']          # loc 슬라이싱
df[df['weekname'] == 'Friday']   # 특정 요일
df[df['weekday'].isin([5, 6])]  # 주말만
```

---

### 🔬 고급 분석 & 시각화

**🕝 시계열 분해 (계절성/추세/잔차)**

```python
from statsmodels.tsa.seasonal import seasonal_decompose
seasonal_decompose(df['sales'], model='additive', period=7)
```

**🔥 히트맵 (월 vs 요일)**

```python
sns.heatmap(df.pivot_table(values='sales', index='month', columns='weekday'))
```

**📦 박스플롯**

- 월별 / 분기별 매출 분포 비

```python
sns.boxplot(x='quarter', y='sales', data=df)
```

---

### 🧮 주요 시계열 연산

| 함수 | 설명 |
| --- | --- |
| `cumsum()` | 누적합 계산 |
| `rolling().mean()` | 이동 평균선 (추세 파악) |
| `pct_change()` | 변화율 계산 (일간/주간 성장률 등) |

**📝 예시**

```python
df['ma_7'] = df['sales'].rolling(7).mean()
df['weekly_change'] = df['sales'].pct_change(periods=7)
```

---

### ♻️ 리샘플링 (Resampling)

```python
df.resample('W|M|Q').agg(['sum', 'mean', 'min', 'max'])
```

- `'W'`: 주간, `'M'`: 월간, `'Q'`: 분기
- 리샘플링 후 추세 시각화 가능

**📝 리샘플링 예시 시각화**

- 주간/월간/분기별 총 매출
- 주간 매출 통계 (최소/평균/최대)

---

### ✅ 실습 요약: 가상 매출 분석 시나리오

| 분석 항목 | 설명 |
| --- | --- |
| 요일/월별 매출 평균 | 주기적 패턴 파악 |
| 월/분기별 박스플롯 | 분포 확인 |
| 누적 매출 | 연간 총합 추이 |
| 이동 평균선 | 단기/중기 추세 파악 |
| 변화율(pct_change) | 성장률/감소율 분석 |
| 시계열 분해 | 추세/계절/잔차 요소 분리 |
| 히트맵 | 월-요일 매출 강도 시각화 |

---

### 🔑 핵심 함수 요약

```python
pd.to_datetime(), pd.date_range(), DatetimeIndex.year/month/day
groupby(), resample(), rolling(), pct_change(), cumsum()
seasonal_decompose(), sns.heatmap(), boxplot()
```

### 💡 Tip

- `FuncFormatter`: y축 단위 유연하게 설정
- `tight_layout()`, `subplot()` 등으로 그래프 간격 자동 정리
- `seaborn`, `matplotlib` 조합으로 고급 시각화 가능