# 📊 데이터 분석

## ✍️ DAY 03

## 🗺️ EDA 실습 요약 (Titanic & Boston Housing)

## 🧩 EDA 전략 프레임워크

> EDA(Exploratory Data Analysis): 데이터를 다양한 관점에서 관찰·이해해 비즈니스 의사결정을 돕는 과정
> 

**절차**

1. 가설 수립
2. 데이터 이해
3. 데이터 품질 검사
4. 시각화
5. 변수 간 관계 분석
6. 가설 검정

---

## 🚢 Titanic 데이터 분석

### 🎯 분석 목적

- 생존에 영향을 준 요인 파악
- 구조 우선순위 및 위험 그룹 탐지

### 🤔 가설

1. 여성과 아동이 우선 구조되었을 것이다.
2. 상류층(1등급) 승객이 구조에서 우대받았을 것이다.

**🧑‍💻 핵심 코드**

```python
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from scipy.stats import chi2_contingency

titanic = sns.load_dataset('titanic')

# 객실 등급별 생존률
pclass_survival = titanic.groupby('pclass')['survived'].mean()

# 성별 생존률
sex_survival = titanic.groupby('sex')['survived'].mean()

# 연령대별 생존률
titanic['age_group'] = pd.cut(
    titanic['age'], bins=[0, 12, 18, 35, 60, 100],
    labels=['아동', '청소년', '청년', '중장년', '노년']
)
age_survival = titanic.groupby('age_group')['survived'].mean()

# 성별 × 객실등급
survival_ct = pd.crosstab(titanic['sex'], titanic['pclass'], titanic['survived'], aggfunc='mean')

# 카이제곱 검정
chi2, p_value, _, _ = chi2_contingency(pd.crosstab(titanic['sex'], titanic['survived']))
```

### 📊 주요 결과

- **객실 등급별 생존율**
    - 1등급: 63% / 3등급: 24% → 등급이 높을수록 ↑
- **성별 생존율**
    - 여성: 74% / 남성: 19% → 여성 생존율 약 4배
- **연령대별**
    - 아동(58%) > 청소년(43%) > 청년(38%) > 중장년(40%) > 노년(23%)
- **성별 × 객실등급**
    - 1등급 여성: 96.8% (거의 전원 구조)
- **카이제곱 검정**
    - p-value < 0.05 → 성별과 생존율은 유의미한 관계

### 💡 인사이트

- 여성·아동·상류층이 구조에서 우선순위
- 변수 조합 분석이 단일 변수보다 설명력 ↑

---

## 🏠 Boston Housing 데이터 품질 진단

### 🎯 분석 목적

- 예측 모델 전 품질 점검
- 자동화 프로파일링 + 도메인 검증 + 품질 점수화

**🧑‍💻 핵심 코드**

```python
import pandas as pd
import numpy as np
import seaborn as sns

boston = pd.read_csv('./boston-housing.csv', header=None, sep=r'\s+')
boston.columns = ['CRIM','ZN','INDUS','CHAS','NOX','RM','AGE','DIS','RAD',
                  'TAX','PTRATIO','B','LSTAT','PRICE']

# 결측치 확인
missing = boston.isnull().sum().sum()

# PRICE와 상관관계
corr = boston.corr()['PRICE'].sort_values(ascending=False)

# 도메인 검증 예시
invalid_rooms = boston[boston['RM'] < 1]
invalid_chas = boston[~boston['CHAS'].isin([0,1])]
```

### 📊 주요 결과

- 결측치 없음 → 완전성 100
- PRICE와 강한 상관 변수:
    - RM(+) / LSTAT(-) / PTRATIO(-)
- 도메인 검증
    - 방 개수 < 1 → 이상값 존재
    - CHAS 값 범위 오류 없음
- 품질 점수 예시
    - 완전성 100 / 일관성 97 / 유효성 92 → 종합 96.3 (우수)

### 💡 인사이트

- 자동화 프로파일링으로 품질 점검 효율 ↑
- 도메인 지식 결합 시 통계로는 안 잡히는 이상값 탐지 가능
- 논리 검증(범죄율↔가격, 방 개수↔가격) 필수