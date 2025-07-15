# 🖥️ Phython

## ✍️ DAY 01

## 📘 개요

- **공식 문서 기반:** Python Tutorial
- **권장 버전:** Python 3.9 이상
- **스타일 가이드:** [PEP-8](https://peps.python.org/pep-0008/)
- 구글, TensorFlow 등도 자체 스타일 가이드 제공

---

## ✏️ 문법 (Syntax)

### ✅ 들여쓰기 (Indentation)

- 파이썬은 `{}` 대신 **들여쓰기**로 코드 블록을 구분
- **4칸 공백**(`space`) 또는 `Tab` 사용 → PEP-8은 공백 권장
- 한 코드 안에서 혼용 ❌

```python
if True:
    print('hello')
else:
    print('world')
```

---

## 📦 변수 (Variables)

- 변수: 메모리에 저장된 **객체(object)** 에 이름을 붙임
- **할당 연산자:** `=`
- **타입 확인:** `type()`
- **메모리 주소 확인:** `id()`

```python
x = 'apple'
print(type(x), id(x))
```

**여러 변수 동시 할당:**

```python
x = y = 1
x, y = 1, 2
x, y = y, x  # 값 교환
```

### 🏷️ 식별자 (Identifiers)

- 영문자, 숫자, `_` 사용 (숫자로 시작 ❌)
- 대소문자 구분
- 예약어(`True`, `class` 등) 사용 불가
- 내장함수(`print`, `len` 등) 이름 덮어쓰기 주의!

```python
import keyword
print(keyword.kwlist)
```

---

## 💬 주석 (Comments)

- 한 줄: `#`
- 여러 줄: `''' ... '''` 또는 `""" ... """`
    
    → 함수/클래스 설명 `docstring` 으로 자주 사용
    

```python
# 한 줄 주석
'''
여러 줄 주석 예시
'''
```

---

## ⌨️ 사용자 입력 (Input)

- `input()` 함수로 입력 받기
- 항상 `str` 로 반환됨

```python
name = input("이름을 입력하세요: ")
print(name, type(name))
```

---

## 🗃️ 자료형 (Data Types)

| 분류 | 예시 |
| --- | --- |
| 불린형 (bool) | `True`, `False`, `bool()` |
| 수치형 (int, float, complex) | `3`, `3.14`, `3+4j` |
| 문자열 (str) | `'hello'`, `"hi"` |
| 없음 (None) | `None` |

### ☯️ 불린형

- `0`, `''`, `[]`, `{}`, `None` → `False`

```python
print(bool(0), bool([]))  # False False
```

### 🔢 수치형

- `int`: 정수 (Python 3 → 무제한 정밀도)
- `float`: 실수 (부동소수점 오차 주의)
- `complex`: 복소수 (`j` 사용)

```python
a = 2 ** 64
print(a, type(a))

b = 3.14
print(b, type(b))
```

### 🅰️ 문자열 (str)

- 작은따옴표 `' '` 또는 큰따옴표 `" "` 모두 가능
- **f-string** 사용 (Python 3.6+)

```python
name = 'Neo'
score = 4.2
print(f'이름: {name}, 학점: {score}')
```

**이스케이프 시퀀스:** `\n`, `\t`, `\'`, `\"`, `\\`

---

## ➕ 연산자 (Operators)

### 🧮 산술 연산자

| 연산자 | 의미 |
| --- | --- |
| `+`, `-`, `*`, `/` | 사칙연산 |
| `//`, `%`, `**` | 몫, 나머지, 거듭제곱 |

```python
2 ** 3  # 8
10 // 3  # 3
```

### ⚖️ 비교 연산자

| 연산자 | 의미 |
| --- | --- |
| `<`, `>`, `<=`, `>=` | 대소 비교 |
| `==`, `!=` | 같다/다르다 |
| `is`, `is not` | 동일 객체 비교 |

### 🤔 논리 연산자

| 연산자 | 의미 |
| --- | --- |
| `and` | 모두 True |
| `or` | 하나라도 True |
| `not` | 부정 |

### ⚡ 단축평가 (Short-circuit)

- `and`: 앞이 `False`면 뒤는 보지 않음
- `or`: 앞이 `True`면 뒤는 보지 않음

```python
True and False  # False
True or False   # True
```

### 🔗 복합 연산자

| 연산자 | 의미 |
| --- | --- |
| `+=` | 더하고 할당 |
| `-=` | 빼고 할당 |
| `*=` | 곱하고 할당 |

```python
x = 1
x += 1  # x = x + 1
```

### 🔎 포함 연산자

```python
'a' in 'apple'  # True
```

### 🪞 동일성 연산자

```python
x = 255
y = 255
x is y  # True
```

---

## 📚 연산자 우선순위

1. `()` 괄호
2. `*` 거듭제곱
3. 단항 `+`, 
4. , `/`, `%`
5. `+`, 
6. 비교 연산자, `in`, `is`
7. `not`
8. `and`
9. `or`

---

### 💡 Tip

- 실수 비교는 `==` 대신 `math.isclose()` 추천!
- 항상 직접 코드 실행하면서 연습할 것!