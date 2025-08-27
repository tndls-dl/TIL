# 📊 데이터 분석

## ✍️ DAY 06

## 📊 EDA 상관관계 분석

### **💡 핵심 개념 요약**

상관관계 분석은 두 변수 간의 **선형/비선형 관계**를 정량적으로 측정하여 **비즈니스 인사이트**를 도출하는 과정

### **📜 핵심 원칙**

- 상관관계 ≠ 인과관계
- 데이터 타입에 따른 적절한 측정 방법 필요
- 혼란변수 통제의 중요성
- 반드시 **비즈니스 액션**으로 연결

---

## 📈📉 기본 상관관계 분석

### **🧑‍🏫 핵심 학습 내용**

- Online Retail 데이터 전처리 및 고객 단위 집계
- RFM 기반 고객 특성 변수 생성
- 피어슨 vs 스피어만 vs 켄달 상관계수 비교

### **🔍 주요 발견사항**

- **구매횟수 ↔ 총구매액**: 0.8+ (강한 양의 상관)
- **상품종류수 ↔ 총구매액**: 0.6+ (중강 양의 상관)
- **평균단가 ↔ 구매횟수**: -0.3 (약한 음의 상관)

### **💼 실무 적용**

- 매출 전략: 구매빈도 증가 → 매출 직결
- 상품 전략: 다양성 확대 → 크로스셀링 효과
- 가격 전략: 가격 인상 시 구매빈도 감소 고려

### 💻 핵심 코드

```python
# 기본 상관관계 분석
pearson_corr = df.corr(method='pearson')    # 선형 관계
spearman_corr = df.corr(method='spearman')  # 순위 기반
kendall_corr = df.corr(method='kendall')    # 이상값 강건

# 시각화
sns.heatmap(pearson_corr, annot=True, cmap='RdBu_r', center=0)
```

---

## 🌀 비선형 상관관계와 고급 측정

### **🧑‍🏫 핵심 학습 내용**

- 켄달 타우: 이상값에 강건한 순위 상관
- 상호정보량(Mutual Information): 정보이론 기반 비선형 관계 탐지
- 조건부 상관관계: 고객 세그먼트별 차이
- 다양한 패턴: U자형, 포화점, 지수적 관계

### **🔬 고급 기법 정리**

- Distance Correlation → 비선형 일반 관계
- MIC (MINE) → 패턴 공평 탐색
- Kendall τ → 이상값 강건
- Mutual Information → 특성 선택, 비선형 탐지

 

### 💻 핵심 코드

```python
# 켄달 타우
from scipy.stats import kendalltau
tau, p_value = kendalltau(x, y)

# 상호정보량
from sklearn.feature_selection import mutual_info_regression
mi_scores = mutual_info_regression(X, y)

# 조건부 상관관계 (VIP 세그먼트)
vip_corr = df[df['segment']=='VIP']['x'].corr(df[df['segment']=='VIP']['y'])
```

---

## 🧮 범주형 변수와 혼합형 연관성

### **🧑‍🏫 핵심 학습 내용**

- 국가/시간대/요일별 구매패턴 분석
- 카이제곱 검정 + Cramér's V (범주형-범주형)
- 상관비(η²): 범주형→수치형 영향
- ANOVA 그룹 간 차이
- φk (Phi_k): 모든 타입에 일관된 측정

### **🔍 주요 발견사항**

- 국가별: 영국 vs 기타 국가 차이
- 시간대: 10~15시 집중
- 요일: 주중 vs 주말 차이

### 💻 핵심 코드

```python
# Cramér's V
def cramers_v(x, y):
    confusion_matrix = pd.crosstab(x, y)
    chi2 = chi2_contingency(confusion_matrix)[0]
    n = confusion_matrix.sum().sum()
    return np.sqrt(chi2 / (n * (min(confusion_matrix.shape) - 1)))

# 상관비 (η²)
def correlation_ratio(categories, values):
    return eta_squared

# 카이제곱 검정
chi2, p_value, dof, expected = chi2_contingency(crosstab)
```

---

## 🔗 편상관, 조건부 독립성, 인과관계

### **🧑‍🏫 핵심 학습 내용**

- 편상관: 혼란변수 통제 효과
- Fisher's Z 검정: 유의성 확인
- 조건부 독립성: p > 0.05 → 독립
- 인과 추론 4조건
    - 시간적 선후관계
    - 통계적 연관성
    - 혼란변수 통제
    - 도메인 지식

### 💻 핵심 코드

```python
# 편상관 구현
def partial_correlation(data, x, y, control_vars):
    reg_x = LinearRegression().fit(data[control_vars], data[x])
    residual_x = data[x] - reg_x.predict(data[control_vars])
    reg_y = LinearRegression().fit(data[control_vars], data[y])
    residual_y = data[y] - reg_y.predict(data[control_vars])
    return np.corrcoef(residual_x, residual_y)[0, 1]
```

---

## ✅ 실무 활용 체크리스트

- 분석 목적 명확화
- 데이터 타입별 측정방법 선택
- 혼란변수 식별
- 도메인 지식 기반 가설 설정
- 단계별 접근 (기본 → 비선형 → 범주형 → 편상관 → 조건부 독립성)
- 유의성과 실무적 의미 동시 고려
- ROI 기준 액션 아이템 도출

---

## ✔️ 실무 적용 베스트 프랙티스

### **💰📈🛒 매출 전략**

- 구매빈도 ↑ (0.8+) → 리타겟팅, 구매 알림
- 상품 다양성 ↑ (0.6+) → 크로스셀링, 번들
- 장바구니 크기 ↑ (0.4+) → 무료배송, 묶음할인
- 가격 정책: 가격 탄력성 반영

### **🎯👥💡 세그멘테이션 전략**

- VIP: 고단가+빈도 유지
- 가격민감: 할인 중심
- 다양성 추구: 신상품 노출
- 충성 고객: 정기구매

### **🌍✈️📈 글로벌 전략**

- 국가별 차별화 (Cramér’s V > 0.3)
- 시간대 최적화: 피크타임 집중
- 문화 차이 반영

---

## 📋 핵심 코드 스니펫

### 💻 종합 상관관계 분석 함수

```python
def comprehensive_correlation_analysis(df):
    results = {}
    results['pearson'] = df.corr(method='pearson')
    results['spearman'] = df.corr(method='spearman')
    results['kendall'] = df.corr(method='kendall')
    key_vars = ['총구매액', '구매횟수', '평균단가']
    results['partial'] = {}
    for i, var1 in enumerate(key_vars):
        for var2 in key_vars[i+1:]:
            control_var = '상품종류수'
            partial_r = partial_correlation(df, var1, var2, [control_var])
            results['partial'][f'{var1}_{var2}'] = partial_r
    return results

```

### 💻 범주형 연관성 매트릭스

```python
def categorical_association_matrix(df, cat_vars):
    n_vars = len(cat_vars)
    cramers_matrix = np.zeros((n_vars, n_vars))
    for i, var1 in enumerate(cat_vars):
        for j, var2 in enumerate(cat_vars):
            if i <= j:
                if i == j:
                    cramers_matrix[i, j] = 1.0
                else:
                    cramers_v = calculate_cramers_v(df[var1], df[var2])
                    cramers_matrix[i, j] = cramers_v
                    cramers_matrix[j, i] = cramers_v
    return pd.DataFrame(cramers_matrix, index=cat_vars, columns=cat_vars)

```

---

## ✨ 핵심 인사이트

- 매출 공식: 총매출 = 구매횟수 × 평균구매액
- 전략 우선순위: 빈도 ↑ > 단가 ↑
- 세그먼트별 패턴 차이 (VIP vs 일반)
- 국가별 차이 η² > 0.4 (강한 연관)

### ⚠️ **주의사항**

- 상관관계 ≠ 인과관계 (심슨의 역설)
- 이상값 왜곡 주의
- 다중비교 시 오류 증가 (FDR 교정 필요)
- 비선형 관계를 선형으로만 해석하는 실수