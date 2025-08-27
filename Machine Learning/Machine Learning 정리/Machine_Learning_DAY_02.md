# 🤖 Machine Learning

## ✍️ DAY 02

## 🎲 Logistic Regression

## 🧹 데이터 준비

- 데이터: `fish_data.csv`
- 입력 변수: Weight, Length, Diagonal, Height, Width
- 출력 변수: Species (생선 종류)
- 훈련/테스트 분리 후 **스케일링(StandardScaler)** 적용

---

## 🧠 KNN 복습

- `KNeighborsClassifier(n_neighbors=3)`
- 특정 데이터 주위 3개의 이웃으로 확률 계산
- `predict_proba()` → 각 클래스일 확률 반환
- `classes_` 속성: 분류 가능한 클래스 목록

🧑‍💻 예시 코드

```python
from sklearn.neighbors import KNeighborsClassifier

kn = KNeighborsClassifier(n_neighbors=3)
kn.fit(X_train, y_train)

print(kn.score(X_train, y_train), kn.score(X_test, y_test))
print(kn.classes_)
print(kn.predict(X_test[:5]))
print(kn.predict_proba(X_test[:5]))
```

---

## 💡 로지스틱 회귀 개념

- 이름은 회귀(Regression)이지만 실제로는 **분류(Classification) 모델**
- 선형 방정식 `z` 계산 후:
    - **이진분류** → 시그모이드(sigmoid) 함수
    - **다중분류** → 소프트맥스(softmax) 함수
- 출력: 확률 (0~1), 가장 큰 확률의 클래스로 예측

🧑‍💻 시그모이드

```python
phi(z) = 1 / (1 + e^(-z))
```

🧑‍💻 소프트맥스

```python
σ(z_i) = exp(z_i) / Σ_j exp(z_j)
```

---

## 🎣 이진 분류 (빙어 vs 도미)

- `LogisticRegression()` 학습
- 결과: `coef_`, `intercept_` → 방정식 계수
- `decision_function()` : z값 반환
- `expit()` : 직접 시그모이드 적용 가능
- `predict_proba()` : 클래스 확률 반환
    
    ⚠️ 클래스는 **알파벳 순으로 정렬됨** → 기준 클래스 확인 필요
    

🧑‍💻 예시 코드

```python
from sklearn.linear_model import LogisticRegression
from scipy.special import expit

lr = LogisticRegression()
lr.fit(X_bream_smelt_train, y_bream_smelt_train)

print(lr.coef_, lr.intercept_)
print(lr.classes_)
print(lr.predict(X_bream_smelt_train[:5]))

decisions = lr.decision_function(X_bream_smelt_train[:5])
print(expit(decisions))
print(lr.predict_proba(X_bream_smelt_train[:5]))
```

---

## 🍣 다중 분류 (7종 생선)

- `LogisticRegression(C=20, max_iter=1000)`
- One-vs-Rest(OVR) 방식 → 각 클래스별 방정식 학습
- `decision_function()` : 각 클래스별 z값
- `predict_proba()` : softmax 적용된 확률 반환
- `coef_` : 어떤 피처가 어떤 생선 분류에 영향을 주는지 해석 가능

🧑‍💻 예시 코드

```python
lr = LogisticRegression(C=20, max_iter=1000)
lr.fit(X_train_s, y_train)

print(lr.score(X_train_s, y_train))
print(lr.score(X_test_s, y_test))

print(lr.classes_)
print(lr.predict_proba(X_test_s[:3]))
print(lr.coef_)
```

---

## ⚙️ 하이퍼파라미터

- **C (규제 강도, Inverse of Regularization Strength)**
    - 값 ↑ → 규제 약화 → 과적합 위험 ↑
    - 값 ↓ → 규제 강화 → 일반화 ↑ (과소적합 위험 ↑)
- **max_iter** : 최적화 반복 횟수 (데이터 크면 크게 설정 필요)

---

## 📌 실무 적용 팁

- 스케일링 필수 : 변수 크기 차이에 민감
- 계수(`coef_`) 해석
    - 양수 → 피처 ↑ → 특정 클래스 확률 ↑
    - 음수 → 피처 ↑ → 특정 클래스 확률 ↓
- 규제 활용
    - L2 규제 (Ridge, 기본)
    - L1 규제 (Lasso) → 변수 선택 효과

---

## ✅ 핵심 정리

- 로지스틱 회귀는 **분류 모델**
- 이진분류 → 시그모이드 / 다중분류 → 소프트맥스
- `decision_function()` → z값, `predict_proba()` → 확률
- **C** 파라미터로 규제 조정 → 과적합/과소적합 제어
- 단순 정확도보다 **AUC, F1** 등 지표 활용
- `coef_` 해석으로 어떤 피처가 중요한지 확인 가능