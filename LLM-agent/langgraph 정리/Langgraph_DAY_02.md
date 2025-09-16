# 🪄 Langgraph

## ✍️ DAY 02

## 🗣️ LangGraph를 이용한 대화형 챗봇 구축

### 💡 핵심 개념

- **LangGraph 기본 요소**
    - `StateGraph`: 워크플로우(그래프)를 정의
    - `MessagesState`: 대화 메시지 기록을 저장하는 기본 상태 구조
    - **Node**: LLM 호출 등 작업을 수행하는 함수
    - **Edge**: 노드 간 흐름 (START → END)
- **대화 기록 관리 (Memory)**
    - `MemorySaver`: 그래프 실행 시 대화 내용을 저장
    - `thread_id`: 같은 ID로 실행하면 대화 맥락이 이어지고, 다르면 새로운 대화 시작
- **상태 확장**
    - `MessagesState`를 상속해 언어(lang) 같은 부가 정보를 추가 가능
    - 프롬프트에서 이 확장된 상태 값을 활용해 동적으로 답변 제어 가능
- **컨텍스트 윈도우 관리 (Trimming)**
    - LLM의 토큰 제한을 넘지 않도록 오래된 메시지 자동 제거
    - `trim_messages(strategy='last', max_tokens=65, ...)`
    - 최신 메시지 위주 유지하면서 시스템 메시지도 포함 가능

**👩‍💻 코드 예시**

```python
from langgraph.graph import StateGraph, START, END, MessagesState
from langgraph.checkpoint.memory import MemorySaver
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langgraph.prebuilt import trim_messages

# 1. 상태 확장
class MyState(MessagesState):
    lang: str

# 2. 메시지 트리머
trimmer = trim_messages(
    strategy="last",
    max_tokens=65,
    token_counter=llm,
    include_system=True,
)

# 3. 노드 정의
def simple_node(state: MyState):
    # 메시지 정리
    trimmed_messages = trimmer.invoke(state["messages"])

    # 프롬프트 + LLM 연결
    prompt_template = ChatPromptTemplate.from_messages([
        ("system", "너는 유능한 어시스턴트야. {lang} 언어로 답해."),
        MessagesPlaceholder(variable_name="messages")
    ])
    chain = prompt_template | llm

    # 업데이트
    state["messages"] = trimmed_messages
    res = chain.invoke(state)
    return {"messages": [res]}

# 4. 그래프 생성
builder = StateGraph(MyState)
builder.add_node("simple_node", simple_node)
builder.add_edge(START, "simple_node")
builder.add_edge("simple_node", END)

# 5. 메모리 추가
memory = MemorySaver()
graph = builder.compile(checkpointer=memory)

# 실행 (thread_id별 대화 맥락 유지)
config = {"configurable": {"thread_id": "chat-1"}}
graph.invoke({"messages": ["안녕!"]}, config=config)
```

👉 `thread_id` 기반으로 **대화방 구분** 가능 → 실제 채팅 서비스 구현에 활용 가능

---

## ✅ 인사이트 & 유의사항

- LangGraph로 만든 챗봇은 **상태(State)**와 **메모리** 기반으로 설계됨 → 단순 LLM 호출보다 훨씬 유연
- **Trimming 전략**을 통해 긴 대화에서도 컨텍스트 윈도우 관리 가능 → 비용 절감 + 성능 안정화
- 상태 확장을 통해 **다국어 지원, 사용자 메타데이터 반영** 등 맞춤형 챗봇 제작 가능