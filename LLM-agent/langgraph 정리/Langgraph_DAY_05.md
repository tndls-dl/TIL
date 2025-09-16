# 🪄 Langgraph

## ✍️ DAY 05

## 1️⃣ 프로젝트 구조 변환

기존 노트북(`15_code_interpreter.ipynb`) 내용을 모듈 단위로 나눠서 폴더 구조로 재구성:

```
15_code_interpreter/
 ├── graph.py        # 그래프 정의 및 최종 컴파일
 ├── nodes.py        # 노드 정의 (SQL, 코드 생성/실행, 답변 생성, 저장 등)
 ├── router.py       # 조건부 라우팅 함수
 ├── sql_db.py       # PostgreSQL 연결 설정
 ├── state.py        # 상태 정의 (State 클래스)
 ├── langgraph.json  # LangGraph 실행 설정 파일
 └── codes/          # save_code 노드가 생성하는 코드 파일 저장 폴더
```

---

## 2️⃣ 핵심 구성 요소

### (1) 상태 정의 (`state.py`)

```python
class State(MessagesState):
    question: str
    db_status: bool
    db_reason: str
    sql: str
    sql_result: Any
    code: str
    code_result: str
    answer: str
```

👉 대화 상태 + SQL + 코드 실행 결과까지 모두 관리

### (2) DB 연결 (`sql_db.py`)

```python
POSTGRES_USER = os.getenv('POSTGRES_USER')
POSTGRES_PASSWORD = os.getenv('POSTGRES_PASSWORD')
POSTGRES_DB = os.getenv('POSTGRES_DB')

URI = f"postgresql://{POSTGRES_USER}:{POSTGRES_PASSWORD}@localhost:5432/{POSTGRES_DB}"
db = SQLDatabase.from_uri(URI)
table_info = db.get_table_info()
```

👉 PostgreSQL 연결 후 테이블 스키마 불러오기

### (3) 노드 정의 (`nodes.py`)

- **question_analysis**: 질문 분석 (DB 질의 가능 여부 판단)
- **write_sql**: 질문을 SQL 쿼리로 변환
- **execute_sql**: SQL 실행 결과 반환
- **generate_code**: SQL 결과 기반 Python 코드 생성
- **execute_code**: PythonREPL로 코드 실행
- **save_code**: 생성된 코드를 `codes/` 폴더에 파일로 저장
- **generate_answer**: 질문 + SQL + 코드 실행 결과 기반 최종 답변 생성
- **decline_answer**: DB 질의 불가능 시 이유 설명

### (4) 라우터 정의 (`router.py`)

- **route_after_analysis**: DB 질의 가능 여부에 따라 분기
- **should_generate_code**: SQL 실행 결과만으로 답변 가능한지, 코드 실행이 필요한지 판단

### (5) 그래프 구성 (`graph.py`)

```python
builder.add_node('question_analysis', question_analysis)
builder.add_node('write_sql', write_sql)
builder.add_node('execute_sql', execute_sql)
builder.add_node('generate_code', generate_code)
builder.add_node('execute_code', execute_code)
builder.add_node('save_code', save_code)
builder.add_node('generate_answer', generate_answer)
builder.add_node('decline_answer', decline_answer)

builder.add_edge(START, 'question_analysis')
builder.add_conditional_edges('question_analysis', route_after_analysis, {...})
builder.add_edge('write_sql', 'execute_sql')
builder.add_conditional_edges('execute_sql', should_generate_code, {...})
builder.add_edge('generate_code', 'execute_code')
builder.add_edge('execute_code', 'save_code')
builder.add_edge('save_code', 'generate_answer')
builder.add_edge('generate_answer', END)
```

👉 **흐름**: 질문 → 분석 → SQL 생성/실행 → 필요시 코드 생성/실행(+저장) → 최종 답변

### (6) 실행 설정 (`langgraph.json`)

```json
{
    "graphs": {
        "graph": "./graph.py:graph"
    },
    "env": "./.env",
    "python_version": "3.13",
    "dependencies": [
        "."
    ]
}
```

👉 `langgraph dev` 명령어로 실행하면 LangGraph Studio에서 인터랙티브 실행 가능

---

## 3️⃣ 실행 과정

1. 프로젝트 폴더로 이동
    
    ```bash
    cd 15_code_interpreter/
    langgraph dev
    ```
    
2. LangGraph Studio 접속 → `question`, `dataset` 입력 후 실행
3. 실행 흐름:
    - 질문 분석 → SQL 작성 및 실행 → 필요시 Python 코드 생성 → 실행 → 저장 → 답변

---

## 4️⃣ 추가 기능: **코드 저장 (save_code 노드)**

- 코드와 질문을 함께 `.py` 파일로 저장
- 폴더: `codes/`
- 파일명: `code_<uuid>.py`
- 질문은 docstring, 코드 블록은 그대로 기록

---

## 5️⃣ PostgreSQL 연동 분석

- `.env` 파일에서 접속 정보 읽어 DB 연결
- `table_info`를 프롬프트에 포함시켜 SQL 쿼리 정확도 확보
- LLM이 생성한 SQL 실행 → 그 결과를 데이터셋으로 활용해 코드 실행 및 분석

---

## ✅ 인사이트

- 기존 노트북을 **모듈화 + 프로젝트화**하면 유지보수와 확장성↑
- **save_code 노드** 추가로 코드 기록 및 재사용 가능
- PostgreSQL 연결까지 포함 → 데이터 질의 + 분석 자동화 파이프라인 완성
- LangGraph Studio를 통한 시각적 실행 → 디버깅, 학습에 매우 유용