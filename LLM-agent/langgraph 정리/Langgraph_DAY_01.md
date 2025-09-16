# 🪄 Langgraph

## ✍️ DAY 01

## ⚙️ LangGraph 기본 개념

### 💡 핵심 개념

- **LangGraph**: 상태 기반(State-based) 워크플로우 오케스트레이션 프레임워크
- **구성요소**
    - **State**: 노드 간 데이터를 전달하는 중앙 저장소 (`TypedDict` 활용)
    - **Node**: 입력 상태 → 작업 수행 → 새로운 상태 반환 (Python 함수)
    - **Edge**: 노드 간 연결, 실행 흐름 정의
    - **Conditional Edge**: 조건에 따라 다른 노드로 분기

**👩‍💻 코드 예시**

```python
from typing import TypedDict, Literal
from langgraph.graph import StateGraph, START, END

# 1. 상태 정의
class State(TypedDict):
    graph_state: str
    history: list

# 2. 노드 정의
def node_1(state: State):
    new_str = state['graph_state'] + "!"
    return {"graph_state": new_str, "history": state["history"]}

# 3. 조건부 분기
def decide_mood(state: State) -> Literal['node_2', 'node_3']:
    return 'node_2' if len(state['graph_state']) % 2 else 'node_3'

# 4. 그래프 생성
builder = StateGraph(State)
builder.add_node('node_1', node_1)
builder.add_edge(START, 'node_1')
builder.add_conditional_edges('node_1', decide_mood)
builder.add_edge('node_2', END)
builder.add_edge('node_3', END)

graph = builder.compile()
graph.invoke({'graph_state': '안녕', 'history': []})
```

👉 **그래프 형태로 워크플로우를 시각적·구조적으로 설계 가능**

---

## ➡️ Tool 호출과 라우팅

### 💡 핵심 개념

- **MessagesState**: 대화 메시지를 누적 관리 (`add_messages`로 append)
- **Tool Binding**: `llm.bind_tools([tool])` → LLM에게 도구 사용법 알림
- **ToolNode**: LLM이 도구 호출을 요청하면 실제 실행하는 LangGraph 내장 노드
- **tools_condition**: LLM 응답에 도구 호출 포함 여부를 확인, 라우팅 결정

**👩‍💻 코드 예시**

```python
from langgraph.graph import StateGraph, START, END, MessagesState
from langgraph.prebuilt import ToolNode, tools_condition

# 1. 도구 정의
def multiply(a: int, b: int) -> int:
    """Multiply a and b"""
    return a * b

# 2. LLM에 도구 바인딩
llm_with_tools = llm.bind_tools([multiply])

# 3. LLM 호출 노드
def tool_calling_node(state: MessagesState):
    response = llm_with_tools.invoke(state['messages'])
    return {'messages': [response]}

# 4. 그래프 빌드
builder = StateGraph(MessagesState)
builder.add_node('tool_calling_node', tool_calling_node)
builder.add_node('tools', ToolNode([multiply]))

builder.add_edge(START, 'tool_calling_node')
builder.add_conditional_edges('tool_calling_node', tools_condition)
builder.add_edge('tools', END)

graph = builder.compile()
```

👉 사용자가 연산을 요청하면 **LLM → 도구 호출 여부 판단 → 실행 → 응답** 흐름 자동 처리

---

## 🤖 ReAct 기반 Agent

### 💡 핵심 개념

- **ReAct (Reason + Act)**:
    - **Reason** → LLM이 판단
    - **Act** → 도구 실행
    - **Observe** → 실행 결과 확인 후 다시 Reason
- **Agentic Loop**: 도구 실행 후 다시 LLM 노드로 돌아가 다음 행동 반복
- **메모리/체크포인터**: `MemorySaver` 등으로 상태 저장 → 대화 맥락 유지

**👩‍💻 코드 예시**

```python
from langgraph.graph import StateGraph, START
from langgraph.prebuilt import ToolNode, tools_condition
from langgraph.checkpoint import MemorySaver

builder = StateGraph(MessagesState)

# LLM assistant 노드
builder.add_node('assistant', assistant)
builder.add_node('tools', ToolNode(tools))

# Loop 구조
builder.add_edge(START, 'assistant')
builder.add_conditional_edges('assistant', tools_condition)
builder.add_edge('tools', 'assistant')  # 도구 실행 후 다시 LLM 판단

# 메모리 추가
memory = MemorySaver()
graph = builder.compile(checkpointer=memory)

# 특정 대화 스레드 유지
config = {'configurable': {'thread_id': 'thread-1'}}
graph.invoke({'messages': ['3 더하기 4는?']}, config=config)
graph.invoke({'messages': ['거기에 2를 곱해줘']}, config=config)
```

👉 LLM이 여러 번 도구를 사용하면서 **추론-행동-관찰**을 반복하는 복잡한 에이전트 구현 가능

---

## ✅ 인사이트 & 유의사항

- **LangGraph**는 LangChain보다 더 “상태 기반” → 복잡한 워크플로우 표현에 유리
- **조건부 Edge**를 사용하면 유연한 분기 가능
- **Tool 호출**과 **라우팅**을 조합하면 다중 도구 기반 AI 구축 가능
- **ReAct 구조 + Memory**를 활용하면 실제 서비스 가능한 에이전트 수준의 대화형 AI 개발 가능