# 🖥️ Phython

## ✍️ DAY 02

## 📚 컨테이너(Container)

여러 개의 값을 하나로 묶어 담을 수 있는 **객체**를 의미합니다.

서로 다른 자료형도 함께 담을 수 있습니다.

### 🗂️ 컨테이너 분류

| 종류 | 설명 |
| --- | --- |
| **시퀀스형 (Sequence)** | 순서가 **있는(ordered)** 데이터 |
| **비 시퀀스형 (Non-sequence)** | 순서가 **없는(unordered)** 데이터 |

---

### 🧵 시퀀스형 컨테이너

> 📏 순서(인덱스) 를 가짐
> 
> 
> 🔢 *정렬(sorted)* 과는 다름!
> 

### 📏 시퀀스형 종류

- 리스트 `list`
- 튜플 `tuple`
- 레인지 `range`
- 문자열 `str`
    
    (문자열도 시퀀스!)
    
- 바이너리 `binary`
    
    (일반적으로 다루지 않음)
    

### 📋 **리스트 (List)**

- `[]` 대괄호 혹은 `list()`로 생성
- 값 수정/삽입/삭제 가능

```python
my_list = [1, 2, 3]
another_list = list()
```

- 인덱스로 접근 가능
    
    `my_list[0]` (첫번째 원소)
    

### 📦 **튜플 (Tuple)**

- `()` 소괄호 혹은 `tuple()`로 생성
- **불변(immutable)** : 수정 불가
- 다중 값 반환 등에 활용

```python
my_tuple = (1, 2, 3)
single_tuple = (1, )  # 쉼표 필수
```

### 🔢 **레인지 (Range)**

- 정수 시퀀스 표현
- `range(start, end, step)`
    
    (끝은 포함하지 않음)
    
- 리스트/튜플로 형 변환해서 사용

```python
list(range(5))  # [0,1,2,3,4]
range(0, -5, -1)  # [0,-1,-2,-3,-4]
```

---

### 🧩 비 시퀀스형 컨테이너

### 🧺 **세트 (Set)**

- `{}` 중괄호 혹은 `set()`로 생성
- 순서 없음, 중복 없음
- 삽입/삭제 가능

```python
my_set = {1, 2, 3}
```

- 연산
    - 차집합:
    - 합집합: `|`
    - 교집합: `&`

### 🗄️ **딕셔너리 (Dictionary)**

- `{key: value}` 형태
- `dict()`로 생성 가능
- **Key는 immutable**
    
    (문자열, 숫자, 튜플 등)
    
- Value는 제한 없음

```python
phone_book = {'서울': '02', '광주': '062'}
phone_book['서울'] = '002'
```

- `.keys()`, `.values()`, `.items()`로 조회

---

### 🔄 컨테이너형 간 형변환

| 원본 | 변환 가능 | 설명 |
| --- | --- | --- |
| list | tuple, set, str |  |
| tuple | list, set, str |  |
| range | list, tuple, set, str |  |
| set | list, tuple, str |  |
| dict | list, tuple, set (`key`만) |  |

> ✅ dict는 key만 변환됩니다.
> 

---

## 🏞️🌊 얕은 복사 vs 깊은 복사

컨테이너는 복사 시 원본과 복사본이 **서로 영향을 미칠 수 있음**!

| 구분 | 특징 | 예시 |
| --- | --- | --- |
| **얕은 복사 (Shallow Copy)** | 같은 참조값 공유 → 내부 객체는 공유됨 | `copy.copy()` |
| **깊은 복사 (Deep Copy)** | 내부 객체까지 새로 복제 | `copy.deepcopy()` |

```python
import copy

a = [[1, 2], [3, 4]]
b = copy.copy(a)       # 얕은 복사
c = copy.deepcopy(a)   # 깊은 복사
```

### 💡 예제

```python
import copy

original = [[1, 2], [3, 4]]

# 얕은 복사
shallow = copy.copy(original)

# 깊은 복사
deep = copy.deepcopy(original)

# 원본 수정
original[0][0] = 100

print('원본:', original)         # [[100, 2], [3, 4]]
print('얕은 복사:', shallow)     # [[100, 2], [3, 4]] → 내부 값 공유
print('깊은 복사:', deep)        # [[1, 2], [3, 4]]   → 내부 값 독립적
```

### 🎯 핵심 포인트

|  | 얕은 복사 | 깊은 복사 |
| --- | --- | --- |
| `copy.copy()` | 가장 바깥만 새로 만들고, 내부는 공유 |  |
| `copy.deepcopy()` | 내부 객체까지 모두 새로 복사 |  |
- **Mutable**한 자료형(`list`, `dict`, `set`)은 얕은 복사 시 내부 값이 연결됨.
- **Immutable** 자료형은 원본 수정이 불가능하므로 복사 영향 없음.

### ✨ 요약

- 리스트 같은 **Mutable 자료형**은 얕은 복사 시 내부가 연결된다!
- 완전히 독립적으로 복사하려면 `deepcopy()`!

---

## ✏️🔒 Mutable vs Immutable

| 구분 | 뜻 | 예시 |
| --- | --- | --- |
| **Mutable** | 값 수정 가능 | list, dict, set |
| **Immutable** | 값 수정 불가 | tuple, str, int, float, range |

> ✅ dict의 key, set의 원소는 반드시 immutable 이어야 함!
> 

---

## ✅ 정리

| 시퀀스 | 비 시퀀스 |
| --- | --- |
| list, tuple, range, str | set, dict |
- **인덱싱/슬라이싱**: 시퀀스만 가능
- **복사**: 얕은 복사/깊은 복사 주의!
- **Mutable**: 내부 값 수정 가능 → 얕은 복사 시 영향받음