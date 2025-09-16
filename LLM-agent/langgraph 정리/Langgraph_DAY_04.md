# 🪄 Langgraph

## ✍️ DAY 04

## 📝 대용량 문서 요약

### 💡 핵심 개념

- **문제**: 긴 문서는 LLM의 컨텍스트 윈도우 제한 때문에 한 번에 요약 불가
- **해결 방법**
    - **Stuff 방식**: 모든 문서를 통째로 넣고 요약 (간단, 하지만 길이 제한 존재)
    - **Map-Reduce 방식**:
        - Map 단계: 문서를 작은 chunk로 나눈 뒤 각각 요약
        - Reduce 단계: 요약본들을 합쳐 최종 요약 생성 (필요시 재귀적 collapse)

---

### 🗺️ LangGraph 기반 Map-Reduce 파이프라인

1. **문서 분할**: `CharacterTextSplitter`로 문서 chunk 생성
2. **상태 정의**
    - `OverallState`: 전체 진행 상태 (원문, 중간 요약본, 최종 요약본 등)
    - `SummaryState`: 개별 chunk 요약 시 사용
3. **노드 정의**
    - `generate_summary`: 각 chunk → 요약 (Map)
    - `collect_summaries`: 모든 chunk 요약본 수집
    - `collapse_summaries`: 토큰 수 초과 시 요약본을 다시 축약 (조건부 실행)
    - `generate_final_summary`: 최종 요약 생성
4. **조건부 엣지**
    - `should_collapse`: 요약본 길이에 따라 collapse 실행 or final summary 실행

**👩‍💻 코드 예시**

```python
from langgraph.graph import StateGraph, START, END

# 상태 정의
class OverallState(TypedDict):
    documents: list
    summaries: list
    final_summary: str

# Map 단계
def generate_summary(state):
    summaries = [llm.invoke(doc) for doc in state["documents"]]
    return {"summaries": summaries}

# Reduce 단계
def collapse_summaries(state):
    collapsed = llm.invoke("다음 요약들을 합쳐 더 간결하게 정리:\n" + "\n".join(state["summaries"]))
    return {"summaries": [collapsed]}

def generate_final_summary(state):
    final = llm.invoke("최종 요약:\n" + "\n".join(state["summaries"]))
    return {"final_summary": final}

# 라우팅 함수
def should_collapse(state) -> str:
    token_count = sum(len(s) for s in state["summaries"])
    return "collapse" if token_count > 1000 else "final"

# 그래프 빌드
builder = StateGraph(OverallState)
builder.add_node("generate_summary", generate_summary)
builder.add_node("collapse", collapse_summaries)
builder.add_node("final", generate_final_summary)

builder.add_edge(START, "generate_summary")
builder.add_conditional_edges("generate_summary", should_collapse, {"collapse": "collapse", "final": "final"})
builder.add_edge("collapse", "final")
builder.add_edge("final", END)

graph = builder.compile()
```

👉 **장점**: 문서 길이에 상관없이 요약 가능 + 토큰 제한 극복

---

## 💻 코드 실행기

### 💡 핵심 개념

- 사용자 질문을 기반으로 LLM이 **코드를 생성 → 실행 → 결과 기반 답변 생성**
- 데이터 분석/시각화 자동화에 적합

---

### 🛠️ 파이프라인 구성

1. **상태 정의 (State)**
    - question: 사용자 질문
    - dataset: 데이터셋
    - code: LLM이 생성한 코드
    - result: 코드 실행 결과
    - answer: 최종 답변
2. **노드 정의 (Nodes)**
    - `generate_code`: 질문 + 데이터 기반으로 Python 코드 생성
    - `execute_code`: `PythonREPL`로 코드 실행 → 결과 반환
    - `generate_answer`: 질문, 코드, 실행 결과 종합 → 사용자 답변 생성
3. **그래프 빌드**
    - START → generate_code → execute_code → generate_answer → END

**👩‍💻 코드 예시**

```python
from langgraph.graph import StateGraph, START, END
from langchain_experimental.utilities import PythonREPL

# 상태 정의
class CodeState(TypedDict):
    question: str
    dataset: str
    code: str
    result: str
    answer: str

# 코드 생성
def generate_code(state: CodeState):
    code = llm.invoke(f"다음 질문을 해결하는 파이썬 코드를 작성하세요:\n질문: {state['question']}\n데이터셋: {state['dataset']}")
    return {"code": code}

# 코드 실행
def execute_code(state: CodeState):
    repl = PythonREPL()
    result = repl.run(state["code"])
    return {"result": result}

# 답변 생성
def generate_answer(state: CodeState):
    answer = llm.invoke(f"""
    질문: {state['question']}
    코드: {state['code']}
    결과: {state['result']}
    위 내용을 종합해 자연스럽게 답변해줘.
    """)
    return {"answer": answer}

# 그래프 빌드
builder = StateGraph(CodeState)
builder.add_node("generate_code", generate_code)
builder.add_node("execute_code", execute_code)
builder.add_node("generate_answer", generate_answer)

builder.add_edge(START, "generate_code")
builder.add_edge("generate_code", "execute_code")
builder.add_edge("execute_code", "generate_answer")
builder.add_edge("generate_answer", END)

graph = builder.compile()
```

👉 예시:

- 질문: `"키와 몸무게 데이터셋을 주고, 키=173일 때 몸무게를 예측해줘"`
- 흐름: 질문 입력 → LLM이 코드 작성 (회귀분석) → 코드 실행 → 결과값 반환 → 최종 답변

---

## ✅ 인사이트 & 유의사항

- **문서 요약**
    - Stuff 방식은 간단하지만 한계 뚜렷
    - Map-Reduce 방식은 토큰 제한 극복 + 확장성↑
    - 조건부 엣지(`should_collapse`)로 재귀적 요약 가능 → 실무에서도 활용성 높음
- **코드 실행기**
    - 단순 계산을 넘어 데이터 분석/시각화까지 자동화 가능
    - 보안 문제로 코드 실행 환경을 제한해야 함 (샌드박스 권장)
    - LangGraph로 구성하면 “질문 → 코드 → 실행 → 답변” 흐름을 구조적으로 관리 가능