# 🖥️ Phython

## ✍️ DAY 04

## 📜 문자열 순회 (String Iteration)

문자열은 글자 하나하나가 순서(sequence)를 가지는 자료형입니다.

따라서 `for`문으로 각 문자를 하나씩 꺼내서 처리할 수 있습니다.

```python
chars = '안녕!'

for char in chars:
    print(char)
```

✅ **언제 쓰나?**

- 문장 분석, 텍스트 처리 등에서 글자 단위로 작업할 때

---

## 🗄️딕셔너리 순회 (Dictionary Iteration)

딕셔너리는 `key: value` 쌍으로 이루어진 자료형입니다.

`for`문으로 순회하면 기본은 `key`만 가져옵니다.

```python
grades = {'john': 80, 'eric': 90}

# key만 출력
for key in grades:
    print(key)

# key와 value 출력
for key in grades:
    print(key, grades[key])

# .items() 사용 (추천)
for key, value in grades.items():
    print(f'{key} - {value}')
```

✅ **언제 쓰나?**

- 데이터베이스 레코드, JSON 데이터 등 key-value 처리 시

---

## 📝 `enumerate()` 함수

리스트를 `for`문으로 순회하면서 **인덱스**도 함께 얻고 싶을 때 사용합니다.

```python
members = ['민수', '영희', '철수']

for idx, member in enumerate(members):
    print(idx, member)
```

✅ **언제 쓰나?**

- 인덱스 값이 필요할 때 (`index` + `value` 같이 쓰기)

✅ **Tip**

`enumerate(iterable, start=숫자)`로 시작 인덱스를 바꿀 수도 있음.

---

## 🚀 List Comprehension (리스트 컴프리헨션)

`for`문과 표현식을 한 줄로 쓰는 방식입니다.

```python
# 1~3까지 숫자의 세제곱 리스트 만들기
cubic_list = [num ** 3 for num in range(1, 4)]
print(cubic_list)
```

✅ **언제 쓰나?**

- 새 리스트를 깔끔하고 간단히 만들고 싶을 때

---

## 💡Dictionary Comprehension (딕셔너리 컴프리헨션)

딕셔너리도 같은 방식으로 한 줄에 생성할 수 있습니다.

```python
# 1~3 숫자의 세제곱을 key-value로 만들기
cubic_dict = {num: num ** 3 for num in range(1, 4)}
print(cubic_dict)
```

✅ **언제 쓰나?**

- 조건, 연산 등을 적용해 딕셔너리를 새로 만들 때

---

## **🧑‍💻** [실습] for문 + if문: 홀수만 출력하기

`for`문과 `if`문을 함께 써서 조건에 맞는 값만 출력할 수 있습니다.

```python
# 1~30까지 중 홀수만 출력하기
for i in range(1, 31):
    if i % 2:
        print(i)
```

✅ **핵심 포인트**

- `range()`로 반복 범위 설정
- `if`로 조건 걸기 (`홀수 → 2로 나눈 나머지가 1`)

---

## 🚦`for-else`

`for`문이 **`break` 없이 끝까지 실행되면** `else`가 실행됩니다.

```python
numbers = [1, 3, 7, 9]

for num in numbers:
    if num == 4:
        print(True)
        break
else:
    print(False)
```

✅ **언제 쓰나?**

- `for`문에서 특정 조건을 못 찾았을 때, 그걸 따로 처리하고 싶을 때

---

## 🏗️ 데이터 구조란?

**데이터 구조(Data Structure)** 또는 자료구조란

데이터를 **효율적으로 저장, 관리, 접근, 수정**할 수 있도록 구성한 형태를 말합니다.

> 구성 요소
> 
> - **데이터 값(value)**
> - **값들 간의 관계**
> - **데이터에 적용할 수 있는 연산(함수/명령어)**

### 🗂️ 데이터의 분류

| 순서 | 순서가 있음 (Ordered) | 순서가 없음 (Unordered) |
| --- | --- | --- |
| 주요 타입 | 문자열 (String), 리스트 (List), 튜플 (Tuple) | 셋 (Set), 딕셔너리 (Dictionary) |

---

## ✏️ 순서가 있는 데이터 구조

---

### 1️⃣ 문자열 (`str`)

- **특징** : `immutable`(불변), `ordered`(순서 있음), `iterable`(순회 가능)
- **주요 메서드** :
    - `find`, `index`, `startswith`, `endswith`
    - `replace`, `split`, `join`
    - 대소문자 변환: `capitalize`, `title`, `upper`, `lower`, `swapcase`
    - `is~` : 조건 검증 (예: `isalpha`, `isdigit`, `isspace`)

**👉 `find(x)`**

문자열에서 x가 처음 나오는 인덱스 반환, 없으면 -1

```python
"abc".find("b")  # 1
```

**👉 `index(x)`**

문자열에서 x가 처음 나오는 인덱스 반환, 없으면 에러 발생

```python
"abc".index("c")  # 2
```

**👉 `startswith(x)`**

문자열이 x로 시작하는지 확인 (True/False)

```python
"hello".startswith("he")  # True
```

**👉 `endswith(x)`**

문자열이 x로 끝나는지 확인 (True/False)

```python
"world!".endswith("!")  # True
```

**👉 `replace(old, new)`**

문자열 내 old를 new로 교체

```python
"hello world".replace(" ", "-")  # 'hello-world'
```

**👉 `strip()`**

문자열 양 끝 공백 제거

```python
"  hi  ".strip()  # 'hi'
```

**👉 `split(sep)`**

구분자 sep로 문자열 나누기 (리스트 반환)

```python
"a,b,c".split(",")  # ['a', 'b', 'c']
```

**👉 `'sep'.join(list)`**

리스트 요소들을 sep로 연결해 문자열 생성

```python
"-".join(['a','b','c'])  # 'a-b-c'
```

**👉 `capitalize()`**

첫 글자만 대문자로 변환

```python
"hello".capitalize()  # 'Hello'
```

**👉 `title()`**

각 단어 첫 글자 대문자로 변환

```python
"hello world".title()  # 'Hello World'
```

**👉 `upper()`**

모두 대문자로 변환

```python
"hello".upper()  # 'HELLO'
```

**👉 `lower()`**

모두 소문자로 변환

```python
"HELLO".lower()  # 'hello'
```

**👉 `swapcase()`**

대문자는 소문자로, 소문자는 대문자로 변환

```python
"Hello".swapcase()  # 'hELLO'
```

> **참고**
> 
> - 문자열은 불변이므로 메서드 실행 시 **원본이 변하지 않고 새 객체를 반환**함.
> - `dir()`과 `help()`로 사용 가능한 메서드 확인 가능.

---

### 2️⃣ 리스트 (`list`)

- **특징** : `mutable`(가변), `ordered`(순서 있음), `iterable`(순회 가능)
- **주요 메서드** :
    - 추가 : `append`, `extend`, `insert`
    - 삭제 : `remove`, `pop`, `clear`
    - 탐색/카운트 : `index`, `count`
    - 정렬/역순 : `sort`, `reverse`

**👉 `append(x)`**

맨 뒤에 x 추가.

```python
lst = [1, 2]
lst.append(3)  # [1, 2, 3]
```

**👉 `extend(iterable)`**

여러 값 한꺼번에 추가.

```python
lst = [1, 2]
lst.extend([3, 4])  # [1, 2, 3, 4]
```

**👉 `insert(i, x)`**

i 위치에 x 삽입.

```python
lst = [1, 2, 3]
lst.insert(1, 9)  # [1, 9, 2, 3]
```

**👉 `remove(x)`**

첫 x 삭제.

```python
lst = [1, 2, 1]
lst.remove(1)  # [2, 1]
```

**👉 `pop([i])`**

i 위치 삭제 & 반환 (없으면 마지막).

```python
lst = [1, 2, 3]
lst.pop()    # 3
lst.pop(0)   # 1
```

**👉 `clear()`**

전부 삭제.

```python
lst = [1, 2]
lst.clear()  # []
```

**👉 `index(x)`**

x의 첫 인덱스.

```python
lst = [1, 2, 3]
lst.index(2)  # 1
```

**👉 `count(x)`**

x 갯수.

```python
lst = [1, 2, 1]
lst.count(1)  # 2
```

**👉 `sort)`**

원본 정렬.

```python
nums = [3, 1, 2]
nums.sort()  # [1, 2, 3]
```

**👉 `reverse()`**

원본 역순.

```python
nums = [1, 2, 3]
nums.reverse()  # [3, 2, 1]
```

> **참고**
> 
> - `append`는 **값 하나 추가**, `extend`는 **iterable 확장**.
> - `sort()`는 **원본 수정**, `sorted()`는 **새 정렬 리스트 반환**.

---

### 3️⃣ 튜플 (`tuple`)

- **특징** : `immutable`(불변), `ordered`(순서 있음), `iterable`(순회 가능)
- **주요 메서드** :
    - 탐색 : `index`, `count`

**👉 `index(x)`**

x 첫 위치 반환.

```python
t = (1, 2, 3)
t.index(2)  # 1
```

**👉 `count(x)`**

x 갯수.

```python
t = (1, 2, 1)
t.count(1)  # 2
```

- **주의** :
    - 값 변경 불가 → 추가/삭제 메서드 없음

---

## ✏️ 순서가 없는 데이터 구조

---

### 4️⃣ 셋 (`set`)

- **특징** : `mutable`(가변), `unordered`(순서 없음), `iterable`(순회 가능)
- **주요 메서드** :
    - 추가 : `add`, `update`
    - 삭제 : `remove`, `discard`

**👉 `add(x)`**

값 추가.

```python
s = {1, 2}
s.add(3)  # {1, 2, 3}
```

**👉 `update(iterable)`**

여러 값 추가.

```python
s = {1}
s.update([2, 3])  # {1, 2, 3}
```

**👉 `remove(x)`**

x 삭제, 없으면 에러.

```python
s = {1, 2}
s.remove(1)  # {2}
```

**👉 `discard(x)`**

x 삭제, 없어도 에러 안남.

```python
s = {1}
s.discard(2)  # ok
```

> **참고**
> 
> - **중복 허용 X** → 동일한 값 여러 번 추가 불가
> - `remove`는 없으면 오류, `discard`는 없으면 무시

---

### 5️⃣ 딕셔너리 (`dict`)

- **특징** : `mutable`(가변), `unordered`(순서 없음), `iterable`(순회 가능)
- **구조** : `key: value` 쌍으로 구성
- **주요 메서드** :
    - 조회 : `get`, `setdefault`
    - 추가/삭제 : `pop`, `update`

**👉 `get(key[, default])`**

key 값 반환, 없으면 default.

```python
d = {"a": 1}
d.get("a")    # 1
d.get("b", 0) # 0
```

**👉 `setdefault(key[, default])`**

key 있으면 반환, 없으면 default 넣고 반환.

```python
d = {"a": 1}
d.setdefault("b", 2)  # 2
```

**👉 `pop(key[, default])`**

key 제거 & 반환, 없으면 default.

```python
d = {"a": 1}
d.pop("a")  # 1
```

**👉 `update([other])`**

다른 딕셔너리 병합.

```python
d = {"a": 1}
d.update({"b": 2})
```

> **참고**
> 
> - `get` : key 없으면 `None` 반환 (KeyError 방지)
> - `setdefault` : key 없으면 key 생성 후 default 반환

---

### 📋 요약

| 자료형 | 변경 가능 | 순서 | 예시 |
| --- | --- | --- | --- |
| 문자열 | ❌ | ✅ | `'hello'` |
| 리스트 | ✅ | ✅ | `[1, 2, 3]` |
| 튜플 | ❌ | ✅ | `(1, 2, 3)` |
| 셋 | ✅ | ❌ | `{1, 2, 3}` |
| 딕셔너리 | ✅ | ❌ | `{'a': 1}` |

---

## **🖇️ 복사와 할당**

| 구분 | 의미 | 특징 |
| --- | --- | --- |
| **할당(참조)** | 같은 객체를 가리킴 | 원본과 복사본이 완전히 동일한 객체 |
| **얕은 복사** | 1단계만 새 객체 | 내부 중첩 객체는 공유 |
| **깊은 복사** | 모든 단계 새 객체 | 내부 중첩 객체까지 새로 만듦 |

### **🔗 할당(참조) 예시**

```python
a = [1, 2, 3]
b = a   # b는 a와 같은 리스트를 가리킴
b[0] = 100
print(a)  # [100, 2, 3] -> 같이 바뀜!
print(a is b)  # True
```

- `a`와 `b`는 같은 **객체 ID**를 가짐
- `id(a) == id(b)` → `True`
- **값이 아니라 주소만 복사**한다는 점이 핵심

### **⚖️ 얕은 복사 vs 깊은 복사**

```python
import copy

a = [1, [2, 3]]

# 얕은 복사
b = a[:]
b[1][0] = 200
print(a)  # [1, [200, 3]]

# 깊은 복사
c = copy.deepcopy(a)
c[1][0] = 999
print(a)  # [1, [200, 3]] -> 깊은 복사면 원본 안 바뀜!
```