# 🖥️ Phython

## ✍️ DAY 05

## 🤔 함수 (Function) I

### ❓ 함수란?

> 특정한 기능(Function)을 하는 코드의 묶음
> 

### 💡 함수를 사용하는 이유

- **가독성**: 코드의 목적이 한 눈에 보인다.
- **재사용성**: 같은 코드를 반복 작성하지 않고 호출해서 사용.
- **유지보수성**: 수정이 필요한 경우 함수만 수정하면 된다.

### 🏗️ 함수의 기본 구조

```python
def 함수이름(매개변수1, 매개변수2):
    """Docstring (선택)"""
    <코드 블럭>
    return 반환값
```

- `def` 키워드를 사용해 선언.
- 들여쓰기(4 spaces)로 함수 몸체 작성.
- 필요하다면 `return`으로 값을 반환.
    
    (반드시 **하나의 객체**만 반환됨. 여러 값은 튜플로 묶여 반환됨)
    
- 함수 호출은 `함수이름()` 형태.

---

## 💻 함수 예시

### ✏️ [예시] 표준편차 구하기

**✅ 긴 코드**

```python
values = [100, 75, 85, 90, 65, 95, 90, 60, 85, 50, 90, 80]
total = 0
cnt = 0

for value in values:
    total += value
    cnt += 1
mean = total / cnt

total_var = 0
for value in values:
    total_var += (value - mean) ** 2
sum_var = total_var / cnt

target = sum_var
count = 0
while True:
    count += 1
    root = 0.5 * (target + (sum_var / target))
    if abs(root - target) < 1e-16:
        break
    target = root

std_dev = target
print(std_dev)
```

**✅ 조금 더 깔끔한 버전**

```python
import math

values = [100, 75, 85, 90, 65, 95, 90, 60, 85, 50, 90, 80]
cnt = len(values)
mean = sum(values) / cnt
sum_var = sum(pow(value - mean, 2) for value in values) / cnt
std_dev = math.sqrt(sum_var)
print(std_dev)
```

**✅ 라이브러리 활용**

```python
import statistics

values = [100, 75, 85, 90, 65, 95, 90, 60, 85, 50, 90, 80]
print(statistics.pstdev(values))
```

> 동일한 작업이라면 함수나 라이브러리를 활용하면 훨씬 효율적임!
> 

---

## ✍️ 함수 연습 예제

### ✏️ [연습] 세제곱 함수 만들기

입력받은 값을 세제곱하여 반환하는 `cube` 함수 만들기

```python
def cube(n):
    return n ** 3

print(cube(2))   # 8
print(cube(100)) # 1,000,000
print(type(cube(3)))
```

### ✏️ [연습] 두 정수 중 큰 값 반환

내장 함수 `max`처럼 작동하는 `my_max` 함수 만들기

```python
def my_max(a, b):
    if a > b:
        return a
    else:
        return b

print(my_max(1, 5))  # 5
```

---

## 🚀 함수 실행 흐름 예시

아래 코드를 실행하기 전에 결과를 예상해보세요!

```python
num1 = 0
num2 = 1

def func1(a, b):
    return a + b

def func2(a, b):
    return a - b

def func3(a, b):
    return func1(a, 5) + func2(5, b)

result = func3(num1, num2)
print(result)
```

👉 `func3(0, 1)` → `func1(0, 5)` + `func2(5, 1)`

👉 `5 + 4` → `9`

---

## ✨ 함수의 `return`

- 함수는 `return`을 만나면 즉시 종료되며, 값을 반환.
- `return`이 없으면 `None`이 반환됨.

```python
def i_loop():
    while True:
        return 1

print(i_loop())  # 1
```

### ✏️ [연습] 사각형의 넓이와 둘레

너비와 높이를 입력 받아 `(넓이, 둘레)` 반환하기

```python
def rectangle(width, height):
    area = width * height
    perimeter = 2 * (width + height)
    return area, perimeter

print(rectangle(30, 20))  # (600, 100)
print(rectangle(50, 70))  # (3500, 240)
```

### ✏️ [연습] 두 리스트 비교

두 리스트를 받아 합이 큰 리스트 반환하기

```python
def my_list_max(a, b):
    return a if sum(a) > sum(b) else b

print(my_list_max([10, 3], [5, 9]))     # [10, 3]
print(my_list_max([10, 3, 5], [5, 9]))  # [10, 3, 5]
```

### 🔄 함수와 `return` - 무한루프 예시

```python
def i_loop():
    while True:
        return 1  # return을 만나면 함수는 즉시 종료됩니다!

print(i_loop())  # 1
```

- `while True`는 무한 루프처럼 보이지만, `return`을 만나면 루프가 돌지 않고 **즉시 함수가 종료**됩니다.
- `return` 뒤에 값이 없으면 `None`을 반환합니다.

아래는 `break`로만 루프를 끊으면, `return`이 없기 때문에 `None`이 반환됩니다.

```python
def i_loop():
    while True:
        break  # 루프를 빠져나옴
    # return 없음 → None 반환

print(i_loop())  # None
```

👉 **핵심 포인트**

- `return`은 값을 돌려주고 함수 실행을 끝냄.
- `break`는 루프만 종료하고 함수는 계속 진행.
- `return`이 없으면 `None`이 반환됨.