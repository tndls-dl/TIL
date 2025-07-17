# 🖥️ Phython

## ✍️ DAY 03

## 🚦 조건문 (Conditional Statement)

### **🏗️ 기본 구조: `if` / `else`**

- 프로그램의 흐름을 조건에 따라 분기할 때 사용.
- `if` 뒤에는 참/거짓을 판별할 수 있는 조건식을 사용.
- `else`는 선택적으로 사용하여 `if` 조건이 거짓일 때 실행.

```python
a = 100

if a > 5:
    print('5 초과')
else:
    print('5 이하')

print(a)
```

**✅ Point**

- 콜론(`:`)과 들여쓰기 필수!
- 파이썬은 `{}` 대신 들여쓰기로 코드 블록을 구분한다.

### **🧑‍💻 실습: 크리스마스 판독기**

- 사용자가 입력한 날짜가 크리스마스(12/25)인지 판별.

```python
date = input('날짜를 입력해주세요 ex)12/25 : ')

if date == '12/25':
    print('크리스마스입니다 :)')
else:
    print('크리스마스가 아닙니다 :(')
```

### **🧑‍💻 실습: 홀수/짝수 판독기**

- 입력한 숫자가 홀수인지 짝수인지 판단.

```python
num = int(input('숫자를 입력하세요 : '))

if num % 2 == 1:
    print('홀수입니다')
else:
    print('짝수입니다')
```

**✅ Point**

- `num % 2 == 1` → 홀수, `num % 2 == 0` → 짝수.

### **➕ `elif` : 복수 조건**

- 조건이 여러 개인 경우 `elif`로 추가 분기.

```python
dust = int(input('점수를 입력하세요 : '))

if dust > 150:
    print('매우 나쁨')
elif dust > 80:
    print('나쁨')
elif dust > 30:
    print('보통')
else:
    print('좋음')

print('미세먼지 확인 완료!')
```

**✅ Point**

- 위에서부터 순차적으로 비교.
- 조건 순서 중요!

### **🪜 중첩 조건문**

- 조건문 안에 조건문을 포함해서 더 복잡한 상황 처리.

```python
dust = 500

if dust > 150:
    print('매우 나쁨')
    if dust > 300:
        print('실외 활동을 자제하세요.')
elif dust > 80:
    print('나쁨')
elif dust > 30:
    print('보통')
elif dust >= 0:
    print('좋음')
else:
    print('값이 잘못 되었습니다.')
```

**✅ Point**

- 조건문 안에서 추가적인 조건 체크 가능!

### **❓ 조건 표현식 (삼항 연산자)**

- 간단한 조건 분기를 한 줄로 작성할 때 사용.

```python
num = 2
result = '홀수입니다.' if num % 2 else '짝수입니다.'
print(result)
```

**✅ Point**

- `참일때 값 if 조건 else 거짓일때 값`

---

## 🔁 반복문 (Loop Statement)

### **`while` 기본 구조**

- 조건이 `True`인 동안 계속 반복.

```python
a = 0

while a < 5:
    print(a)
    a += 1

print('끝')
```

**✅ Point**

- 반드시 종료 조건 있어야 무한루프 방지!

### **🔄 while 예제 1)**

- 입력값이 ‘안녕’이 될 때까지 반복.

```python
user_input = ''

while user_input != '안녕':
    print('암호를 입력하세요')
    user_input = input()

print('정답!')
```

### **🔄 while 예제 2)**

- 1부터 n까지 더하는 반복문.

```python
num = int(input())
total = 0
number = 1

while number <= num:
    total += number
    number += 1

print(total)
```

### **🔄 while 예제 3)**

- 입력한 정수의 각 자리 수를 1의 자리부터 출력.

```python
a = int(input())

while a > 0:
    value = a % 10
    print(value)
    a = a // 10
```

**✅ Point**

- `% 10` : 마지막 자리
- `// 10` : 마지막 자리 제거

### **➡️ `for` 기본 구조**

- 리스트나 range 등 반복 가능한 객체 순회.

```python
python
복사편집
numbers = [1, 3, 2, 10, 4]
total = 0

for num in numbers:
    total += num

print(total)

```

---

## 🛑 반복 제어 (`break`, `continue`, `pass`)

### 🚫 **`break`**

- 반복문을 즉시 종료.

```python
n = 0
while True:
    print(n)
    n += 1
    if n == 3:
        break
```

### **⏭️ `continue`**

- 이후 코드를 건너뛰고 다음 반복.

```python
for num in range(6):
    if num % 2 == 0:
        continue
    print(num)
```

```python
ages = [10, 23, 8, 30, 25, 31]

for age in ages:
    if age < 20:
        continue
    print(f'{age} 살은 성인입니다.')
```

### **🤫 `pass`**

- 문법적으로 문장이 필요하지만, 아무것도 안 하고 넘어갈 때 사용.

```python
score = 78

if score > 90:
    pass
elif score > 80:
    pass
elif score > 70:
    pass
else:
    pass
```