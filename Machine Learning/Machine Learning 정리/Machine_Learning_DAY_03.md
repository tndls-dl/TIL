# 🤖 Machine Learning

## ✍️ DAY 03

## 🌳🤞🏻 Decision Tree & 교차검증

## 1️⃣ 데이터 준비

- 데이터셋: **wine.csv**
- 특징(Features): `alcohol`, `sugar`, `pH`
- 타깃(Target): `class`

```python
X = wine[['alcohol', 'sugar', 'pH']]
y = wine['class']

# Train / Test = 80:20
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)
```

👉 선택: **스케일링** (Logistic Regression용)

```python
ss = StandardScaler()
X_train_scaled = ss.fit_transform(X_train)
X_test_scaled = ss.transform(X_test)
```

---

## 2️⃣ One-Hot Encoding (OHE)

- **개념**: 범주형 데이터를 순서/크기 왜곡 없이 0/1 벡터로 변환
- **예시**
    
    
    | Color | Label Encoding | One-Hot Encoding |
    | --- | --- | --- |
    | Red | 0 | [1, 0, 0] |
    | Blue | 1 | [0, 1, 0] |
    | Green | 2 | [0, 0, 1] |

✅ 장점: 순서 왜곡 방지

⚠ 단점: 범주 수 많으면 차원 폭발

```python
df_ohe = pd.get_dummies(df, columns=['Color'])
```

---

## 3️⃣ 모델 학습

### (1) Logistic Regression

```python
lr = LogisticRegression()
lr.fit(X_train_scaled, y_train)

print(lr.score(X_train_scaled, y_train))  # 훈련 점수
print(lr.score(X_test_scaled, y_test))    # 테스트 점수
print(lr.coef_, lr.intercept_)
```

- `.predict_proba()` → 클래스별 확률 출력
- `.coef_, .intercept_` → 선형 계수 확인

### (2) Decision Tree

```python
dt = DecisionTreeClassifier(random_state=42)
dt.fit(X_train, y_train)

print(dt.score(X_train, y_train))  # 훈련 점수
print(dt.score(X_test, y_test))    # 테스트 점수
```

### 🌲 트리 시각화

```python
plt.figure(figsize=(12, 10))
plot_tree(dt, max_depth=2, filled=True, feature_names=['alcohol', 'sugar', 'pH'])
plt.show()
```

### ⚙️ 주요 하이퍼파라미터

| 파라미터 | 설명 |
| --- | --- |
| `max_depth` | 트리 최대 깊이 |
| `min_samples_split` | 노드 분할을 위한 최소 샘플 수 |
| `min_impurity_decrease` | 노드 분할 시 최소 불순도 감소 |

---

## 4️⃣ 교차검증 (Cross Validation)

- **훈련 데이터만 사용**
- 모델 일반화 성능 평가용
- Test set은 마지막 1번만 사용

```python
from sklearn.model_selection import cross_validate

scores = cross_validate(dt, X_train, y_train)
np.mean(scores['test_score'])
```

**🔢 폴드 수 변경 (기본 5 → 10)**

```python
from sklearn.model_selection import StratifiedKFold

splitter = StratifiedKFold(n_splits=10, shuffle=True, random_state=42)
scores = cross_validate(dt, X_train, y_train, cv=splitter)
```

---

## 5️⃣ GridSearchCV (하이퍼파라미터 튜닝)

- 단계
    1. 탐색할 파라미터 정의
    2. `GridSearchCV` 실행 (내부 교차검증)
    3. 최적 조합 확인 → `best_params_`, `best_score_`
    4. 최종 모델 학습 → `best_estimator_`

```python
params = {
    'min_impurity_decrease': np.arange(0.0001, 0.001, 0.0001),
    'max_depth': range(5, 20),
    'min_samples_split': range(2, 100, 10)
}

gs = GridSearchCV(
    DecisionTreeClassifier(random_state=42),
    param_grid=params,
    n_jobs=-1,
    cv=5
)

gs.fit(X_train, y_train)

print(gs.best_params_)
print(gs.best_score_)
```

🔹 **best_score_ 계산 방식**

- 후보 파라미터 조합별로 K-Fold CV 수행
- fold별 검증 점수 평균 = `mean_test_score`
- 최고 평균 점수 = `best_score_`

---

## 6️⃣ 최종 모델 평가

- GridSearch로 찾은 최적 모델(`best_estimator_`)을 **테스트셋 1회 평가**

```python
dt_best = gs.best_estimator_
dt_best.score(X_test, y_test)
```

---

## 7️⃣ 시각화

- 최적 트리 구조 확인

```python
plot_tree(dt_best, filled=True, feature_names=['alcohol', 'sugar', 'pH'])
```

- 트리 깊이 / 불순도 제한 → 과적합 방지
- OHE 후 범주형 특성 시각화 → 입력 확인 가능

---

## 8️⃣ 핵심 포인트

- **데이터 분리**: Train / Validation(CV) / Test
- **Decision Tree 과적합**: `max_depth`, `min_samples_split`, `min_impurity_decrease` 조절
- **GridSearchCV**: 하이퍼파라미터 튜닝 + 교차검증 동시 수행
- **OHE**: 범주형 데이터 처리 필수
- **시각화**: 트리 구조와 Feature Importance 파악에 도움