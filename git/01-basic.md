0. Git 기초 개념
- Git은 코드 변경 이력을 관리하는 도구
- Git ≠ Github.
- 내 컴퓨터 내부에서 버전 관리(Version Control System)만을 담당

1. **git init (initialize)**
- git 저장소 초기화
- 저장소가 아닌 일반 폴더에서 최초 1회만 실행하는 명령어
- 실행하면 현재 위치한 폴더가 Git 저장소로 초기화
```
git init
```

2. **git add**
- 수정한 파일을 커밋할 준비.
- 특정 파일 또는 모든 파일을 추가
```
git add<filename> ; 특정 파일만 지정 git add . ; 현재 폴더 전체
```

3. **git commit**
- 변경 사항을 Git에 저장
- 커밋 메시지로 설명 추가
```
git commit -m "<message>"
'''


git config --global user.name
git config --global user.email

git add <filename>
git add .

git commit -m '<message>'
<!-- 지금 TIL은 remote add origin 할 필요 없음 -> clone 했기 때문 -->
git remote add origin <URL>

git push origin main

git status
