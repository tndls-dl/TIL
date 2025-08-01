# 📊 데이터 분석

## ✍️ DAY 01

## 🔢 NumPy

> 수치 계산을 위한 파이썬 대표 라이브러리
> 
> 
> 대규모 데이터 처리에 최적화되어 있고, **배열 기반 연산**이 핵심
> 

### 🛠️ NumPy에서 배열 만들기

NumPy의 핵심 객체는 `ndarray` 라는 **다차원 배열**이다.

일반 파이썬 리스트보다 훨씬 빠르고 효율적으로 연산을 처리한다.

### 👶 배열 생성

- **리스트로부터 배열 생성**
    
    👉 `np.array([1, 2, 3])`
    
- **초기화된 배열 생성**
    - `np.zeros((2, 3))` → 0으로 채워진 2×3 배열
    - `np.ones((2, 2))` → 1로 채워진 2×2 배열
    - `np.empty((3, 3))` → 초기화 안 된 배열 (값은 랜덤일 수 있음)
- **일정한 수열 생성**
    - `np.arange(0, 10, 2)` → `[0, 2, 4, 6, 8]`
    - `np.linspace(0, 1, 5)` → `[0. , 0.25, 0.5 , 0.75, 1. ]`

> arange는 간격 중심, linspace는 개수 중심!
> 

---

### 🔎 배열의 속성 (형태 확인)

```python
arr = np.array([[1, 2, 3], [4, 5, 6]])
```

| 속성 | 의미 | 예시 결과 |
| --- | --- | --- |
| `.shape` | 배열의 구조 (행, 열) | `(2, 3)` |
| `.ndim` | 배열의 차원 수 | `2` |
| `.size` | 전체 원소의 개수 | `6` |
| `.dtype` | 데이터의 자료형 (int, float 등) | `int64` |

> 특히 .shape와 .ndim은 배열 연산 시 매우 중요!
> 

---

### ✂️ 배열 인덱싱과 슬라이싱

파이썬 리스트와 유사하지만, 다차원에서도 매우 직관적으로 동작한다.

**인덱싱**

- 1차원: `arr[0]`
- 2차원: `arr[1, 2]` → 2행 3열 값

**슬라이싱**

- `arr[1:4]` : 1~3번째 요소
- `arr[:, 0]` : 모든 행의 첫 열
- `arr[::2]` : 2칸씩 건너뛰기

> 대부분 슬라이싱은 **원본의 뷰(View)**를 반환 → 수정 시 원본도 바뀜
> 

---

### 🔀 배열 형태 바꾸기

**reshape**

- `arr.reshape(2, 3)` → 구조만 바꿔주는 함수
- 요소 수는 같아야 함
- 유용하게 쓰이는 경우: 모델 입력 차원 조정 등

**flatten**

- 다차원 배열을 **1차원으로 평탄화**
- `.flatten()`은 복사본 반환 (원본은 안 바뀜)
- `.ravel()`은 view 반환 (원본이 바뀔 수 있음)

**transpose**

- 배열의 축을 바꾸는 함수 (행 ↔ 열 전환 등)
- `.T`로도 사용 가능
- 예: `(3, 2)` → `(2, 3)`

---

### 🧮 배열 연산

NumPy는 **원소 단위의 벡터화 연산**을 기본으로 제공한다.

(→ for문 없이 전체 배열에 연산 적용 가능)

**기본 연산**

```python
arr + 3      # 모든 요소에 3 더하기
arr1 * arr2  # 같은 shape일 때 요소별 곱
```

**비교 연산**

```python
arr > 5      # 조건에 맞는 요소 찾기
```

- 불리언 배열 반환 → 조건 필터링 가능
    
    👉 `arr[arr > 5]` → 5보다 큰 요소만 추출
    

---

### ↔️ 브로드캐스팅 (Broadcasting)

> 서로 다른 shape을 가진 배열 간의 연산을 가능하게 만드는 규칙
> 

**예시 1: 스칼라 연산**

```python
arr + 5   # 모든 요소에 5 더해짐
```

**예시 2: 행 단위 확장**

```python
arr.shape = (3, 3)
row = np.array([1, 2, 3])  # shape: (3,)
arr + row  # row가 각 행에 반복 적용됨
```

**핵심 규칙**

- 작은 배열의 차원이 1이면 자동으로 확장됨
- 확장 후 shape가 같아지면 연산 수행

> 자동으로 차원을 "늘려서" 맞춰주는 똑똑한 기능!
> 

---

### ➡️ `axis`

NumPy에서 `axis`는 **연산의 방향을 지정**하는 중요한 개념이다.

조금 헷갈릴 수 있지만, **"어느 축을 따라 계산할 것인지"** 라고 생각하면 이해하기 쉽다.

**기본 개념**

```
2차원 배열 기준:
axis=0 → 열 방향 (세로로 연산)
axis=1 → 행 방향 (가로로 연산
```

**예시 배열:**

```python
arr = np.array([[1, 2, 3],
                [4, 5, 6]])
```

| axis 값 | 의미 | 결과 |
| --- | --- | --- |
| `axis=0` | 각 열(column) 기준 연산 | `[1+4, 2+5, 3+6] → [5, 7, 9]` |
| `axis=1` | 각 행(row) 기준 연산 | `[1+2+3, 4+5+6] → [6, 15]` |

**비유로 이해하기**

- `axis=0` : **위에서 아래로 연산** (세로 합, 세로 평균 등)
- `axis=1` : **왼쪽에서 오른쪽으로 연산** (가로 합, 가로 평균 등)

> 예를 들어 np.sum(arr, axis=1)은 각 행의 합을 구하고,
> 
> 
> `np.max(arr, axis=0)`은 **각 열의 최대값**을 구함.
> 

![image.png](/images/axis.png)