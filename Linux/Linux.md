## 💡 리눅스 기본 개념

- **Linux** : 리누스 토르발즈가 개발한 유닉스(Unix) 기반 무료 OS
- **Unix** : 상용 OS, macOS · iOS · iPadOS · watchOS 등은 Unix 계열
- Android : Linux 기반, 무료

---

## 🧭 경로 기호

- `/` : 루트 디렉터리 (파일 시스템 최상위)
    - `/` 루트 디렉터리에 있어도 `cd` 만 입력하면 홈 폴더로 이동 (귀소본능)
- `~` : 현재 사용자의 홈 디렉터리
- `.` : 현재 디렉터리 / 숨김 처리된 파일-폴더 이름의 시작 구분자
- `..` : 상위 디렉터리 (한 단계 위)
- `pwd` : 현재 위치 확인 (print working directory)

---

## 📁 파일 & 폴더 관련 명령어

| 명령어 | 설명 | 예시 |
| --- | --- | --- |
| `touch` | 빈 파일 만들 때 사용 | `touch a.txt` → `a.txt` 라는 빈 파일 생성 |
| `rm` | 파일 삭제 (휴지통 X) | `rm a.txt` → a.txt 삭제 |
| `mkdir` | 새 폴더(디렉터리) 만들기 | `mkdir test` → `test` 폴더 생성 |
| `rm -r` | 폴더와 그 안의 내용까지 전부 삭제 | `rm -r test` → `test` 폴더와 내부 파일들 삭제 |

---

## 🔍 이동 & 보기 관련 명령어

| 명령어 | 설명 | 예시 |
| --- | --- | --- |
| `cd` | 폴더(디렉토리) 이동 | `cd test` → `test` 로 이동 |
| `cd ..` | 상위 폴더로 이동 | `cd ..` |
| `ls` | 현재 폴더의 파일 목록 보기 | `ls` → 파일/폴더 목록 출력 |

---

## ✂️ 복사 & 이동 관련 명령어

| 명령어 | 설명 | 예시 |
| --- | --- | --- |
| `cp` | 파일이나 폴더 복사 | `cp a.txt ./b.txt` → `a.txt` 를 `b.txt` 로 복사 |
| `mv` | 파일이나 폴더 이동 or 이름 변경 | `mv a.txt ~` → 홈으로 이동
`mv b.txt ./c.txt` → 이름 변경 |

---

## ⌨️ 탭(Tab) 자동완성

- **탭(Tab) 키** : 명령어나 파일 이름 자동완성 가능
    - 예 : `cd Doc` → `Tab` 누르면, `cd Documents/` 처럼 자동완성됨 (Documents 폴더가 있을 경우)
- 파일이나 폴더 이름이 **겹치지 않으면 바로 완성**
    - 예 : `touch rep` + `Tab` → `touch report.txt`
- 겹치는 이름이 **여러 개 있으면**, 한 번 더 `Tab` 누르면 가능한 목록 보여줌
    - 예 : `cd pro` + `Tab` → 아무 일도 안 생김 → 다시 `Tab` → `project/ profile / program/` 같은 목록 보여줌

---

## ✨ 기타 꿀팁

- `*` : 와일드카드
    - 예 : `rm *.txt` → `.txt` 파일 모두 삭제
- **띄어쓰기 주의!** : `cd..`❌  `cd ..` ✅

---

## 🧩 연습 예제

```bash
*# 1. 홈 폴더에 my-good-folder 생성*
mkdir my-good-folder

# 2. my-good-folder로 이동
cd my-good folder

# 3. a.txt 생성
touch a.txt

#4. b 폴더 생성
mkdir b

# 5. b 폴더로 이동
cd b

# 6. b.py 생성
touch b.py

# 7. 파일 목록 확인
ls

# 8. 상위 폴더로 이동
cd ..

# 9. b 폴더 삭제
rm -r b
```