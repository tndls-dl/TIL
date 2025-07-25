# 🖥️ Phython

## ✍️ DAY 06

## ➡️ 함수의 입력(Input)

### 🤝 매개변수(Parameter) & 전달인자(Argument)

**📌 매개변수 (Parameter)**

```python
def func(x):
    return x + 2
```

- `x`는 매개변수(Parameter)
- **함수를 정의할 때** 입력으로 사용
- 함수 내부에서 사용될 **변수**

**📌 전달인자 (Argument)**

```python
func(2)
```

- `2`는 전달인자(Argument)
- 함수를 호출할 때 **실제로 전달되는 값**

> ✔️ 두 용어는 흔히 혼용하지만, 작동 원리를 이해하는 게 더 중요!
> 

---

### 🧩 함수의 인자

**📌 위치 인자 (Positional Arguments)**

- 함수 호출 시, 인자는 **위치**에 맞게 전달됨.

```python
def cylinder(r, h):
    pi = 3.14
    return pi * r**2 * h

print(cylinder(5, 2))  # 반지름 5, 높이 2
print(cylinder(2, 5))  # 순서 바뀌면 결과도 달라짐
```

---

### 🎁 기본 인자 값 (Default Argument Values)

- 함수 정의 시, 인자에 **기본값**을 설정해 둘 수 있음.

```python
def greeting(name='익명'):
    return f'{name}, 안녕!'

print(greeting('길동'))  # 길동, 안녕!
print(greeting())        # 익명, 안녕!
```

> ❗ 주의: 기본값이 있는 인자 뒤에 기본값이 없는 인자는 올 수 없음.
> 

```python
# 잘못된 예시
def greeting(name='john', age):
    return f'{name}은 {age}살입니다.'

# 수정 예시
def greeting(age, name='john'):
    return f'{name}은 {age}살입니다.'
```

---

### 🔑 키워드 인자 (Keyword Arguments)

- 함수 호출 시, 이름을 붙여 인자를 전달 가능.
- 순서를 바꿔도 문제 없음.

```python
def greeting(age, name, address, major):
    return f'{name}은 {age}살, {address} 거주, 전공은 {major}'

print(greeting(20, 'justin', '분당', '심리학'))
print(greeting(major='심리학', name='justin', age=30, address='분당'))
```

> ❗ 위치 인자 뒤에 키워드 인자는 가능하지만, 키워드 인자 뒤에 위치 인자는 불가
> 

```python
# 잘못된 예시
greeting(major='경영', age=24, '서울', '철수')
```

---

### 📜 가변 인자 리스트 (*args)

- 입력값의 개수가 **정해지지 않은** 위치 인자들을 받을 때 사용.
- `tuple`로 전달됨.

```python
def func(a, b, *args):
    print(a, b, args)

func(1, 2, 3, 4, 5)
```

**📝 [연습] `my_max()`**

```python
def my_max(*numbers):
    max_num = numbers[0]
    for num in numbers:
        if num > max_num:
            max_num = num
    return max_num

print(my_max(10, 20, 30, 50))  # 50
```

---

### 🏷️ 가변 키워드 인자 (**kwargs)

- 키워드 인자를 **dict 형태**로 받음.

```python
def my_func(a, b=1, *args, **kwargs):
    print(a, b, args, kwargs)

my_func(1, 2, True, False, x=1, y=2, z=3)
```

---

## 🔭 함수와 스코프(Scope)

### 🌍🏠 전역 스코프 & 지역 스코프

- **전역 스코프**: 코드 전체에서 접근 가능
- **지역 스코프**: 함수 내부에서만 접근 가능

```python
x = 1

def func():
    print(x)  # 전역 변수 사용 가능

func()

def func2():
    y = 2
func2()
# print(y)  # Error! 함수 내부 변수는 외부에서 사용 불가
```

---

### ♻️🪜 변수의 수명 주기 & LEGB Rule

- **L**ocal → **E**nclosed → **G**lobal → **B**uilt-in 순서로 탐색

```python
a = 'global'

def outer():
    a = 'enclosed'
    def inner():
        a = 'local'
        print(a)  # local
    inner()
    print(a)      # enclosed

outer()
print(a)          # global
```

---

### 🌐 `global` & `nonlocal`

```python
# global 예시
a = 10
def func():
    global a
    a = 100

func()
print(a)  # 100

# nonlocal 예시
def outer():
    x = 'outer'
    def inner():
        nonlocal x
        x = 'inner'
    inner()
    print(x)  # inner

outer()
```

---

## 🔄 재귀 함수 (Recursion)

### 💡 개념

- **재귀 함수**란 함수가 *자기 자신을 다시 호출*하는 함수입니다.
- 반복문(`for`, `while`)과 비슷한 역할을 할 수 있지만, 더 *자연스러운 단계적 로직*에 쓰면 좋습니다.
- **중요:** 재귀는 *종료 조건*이 꼭 있어야 합니다!
    
    그렇지 않으면 무한 호출로 `RecursionError`가 발생합니다.
    

### 📝 대표 예시 1: 팩토리얼

```python
# 팩토리얼 n! = n * (n-1)!
def factorial(n):
    if n == 1:  # 종료 조건
        return 1
    return n * factorial(n - 1)

print(factorial(5))  # 출력: 120
```

### 📝 대표 예시 2: 피보나치 수열

```python
# 피보나치: 0, 1, 1, 2, 3, 5, 8, ...
def fibonacci(n):
    if n <= 1:  # 종료 조건
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)

print(fibonacci(6))  # 출력: 8
```

---

### 🤔 언제 쓰면 좋을까?

| 상황 | 설명 |
| --- | --- |
| 단계적으로 같은 작업 반복 | ex) 팩토리얼, 피보나치, 하노이탑 |
| 계층 구조 탐색 | ex) 폴더 구조, 트리 구조 |
| 분할 정복 | ex) 퀵소트, 병합정렬 |

---

### 🌟 재귀 팁

- **종료 조건 꼭 설정!** → `if`로 멈출 시점 정의
- 너무 깊게 호출되면 `RecursionError` 발생 (`파이썬 최대 호출 깊이: 약 1000`)
- 복잡한 재귀는 `반복문`이나 `동적 계획법`으로 바꾸면 성능이 더 좋을 수 있음

---

### ⚖️ 재귀 vs 반복문

| 항목 | 재귀 | 반복문 |
| --- | --- | --- |
| 직관성 | 수학적 정의와 유사 | 명령형, 단계적 |
| 성능 | 스택 사용 → 호출 비용 있음 | 메모리 효율적 |
| 예시 | 팩토리얼, 트리 탐색 | 합계 계산, 순회 |

---

### 📚 정리

- 함수가 *자기 자신을 호출* → 단계별로 문제를 쪼개 해결!
- **종료 조건 필수!**
- 너무 깊으면 성능 이슈 → 반복문/DP로 대체 가능

---

## 🛠️ 함수 응용

### 🗺️ `map(function, iterable)`

**✅ 개념**

- `map`은 순회 가능한 자료형(iterable)의 모든 요소에 함수를 *하나씩 적용*한 뒤 결과를 돌려줍니다.
- `map`의 결과는 `map object`(이터레이터)이므로 `list()`로 감싸서 리스트로 자주 사용합니다.
- **활용 예:** `문자 → 숫자` 변환, 리스트 요소 일괄 변환 등

### 📝 예시: 문자열을 정수로 변환하기

```python
# '12345'의 각 문자를 정수로 변환해서 리스트로 반환
result = list(map(int, '12345'))
print(result)  # 출력: [1, 2, 3, 4, 5]
```

### 📝 예시: 사용자 정의 함수와 함께 사용하기

```python
# 세제곱을 반환하는 함수
def cube(n):
    return n ** 3

numbers = [1, 2, 3]

# 각 요소에 cube 함수를 적용
result = list(map(cube, numbers))
print(result)  # 출력: [1, 8, 27]
```

---

### 🔍 `filter(function, iterable)`

**✅ 개념**

- `filter`는 순회 가능한 자료형에서 *조건을 만족(True)* 하는 요소만 골라냅니다.
- `map`과 달리 `True`/`False`로 거를지를 판단합니다.
- 반환값은 `filter object` → `list()`로 감싸서 사용

### 📝 예시: 홀수만 걸러내기

```python
# 홀수 판별 함수
def is_odd(n):
    return n % 2 == 1

numbers = range(10)
result = list(filter(is_odd, numbers))
print(result)  # 출력: [1, 3, 5, 7, 9]
```

### 📝 예시: filter + lambda

```python
# lambda로 짧게 홀수 판별
result = list(filter(lambda n: n % 2, range(10)))
print(result)  # 출력: [1, 3, 5, 7, 9]
```

---

### 🐑 `lambda` 함수

**✅ 개념**

- 이름이 없는 *익명 함수*로, `def`로 만드는 함수보다 짧게 작성할 수 있습니다.
- `return`은 쓰지 않고 `:` 뒤에 표현식만 작성.
- 간단한 로직에만 사용 (조건문도 간단해야 함)
- `map`, `filter` 등과 함께 자주 사용

### 📝 예시: lambda로 삼각형 넓이 구하기

```python
# 기명 함수 버전
def triangle_area(b, h):
    return 0.5 * b * h

print(triangle_area(3, 4))  # 6.0

# lambda 버전
print((lambda b, h: 0.5 * b * h)(3, 4))  # 6.0
```

### 📝 예시: map + lambda

```python
# 리스트 요소를 3제곱으로 변환
numbers = [1, 2, 3]
result = list(map(lambda n: n ** 3, numbers))
print(result)  # 출력: [1, 8, 27]
```

---

### 📚 정리

| 함수 | 특징 | 주 사용 예 |
| --- | --- | --- |
| `map` | 모든 요소에 함수를 적용 | 자료형 변환, 일괄 처리 |
| `filter` | 조건에 맞는 요소만 선택 | 조건에 맞는 데이터 추출 |
| `lambda` | 짧은 익명 함수 작성 | `map`/`filter`와 함께 |