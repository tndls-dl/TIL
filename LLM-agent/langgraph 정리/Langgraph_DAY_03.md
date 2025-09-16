# 🪄 Langgraph

## ✍️ DAY 03

## 💬 대화형 RAG 에이전트

### 💡 핵심 개념

- **Tool 사용**
    - `@tool` 데코레이터로 `retrieve` 함수를 LangGraph 에이전트에서 호출 가능한 도구로 등록
- **대화 상태 관리**
    - `MessagesState`를 사용하여 Human, AI, Tool 메시지를 모두 저장
- **조건부 라우팅**
    - `tools_condition`으로 LLM 응답에 `tool_calls`가 있으면 ToolNode로, 없으면 사용자에게 바로 응답
- **메모리 관리**
    - `MemorySaver`를 checkpointer로 설정
    - `thread_id` 단위로 대화 상태를 저장 → 다턴 대화에서도 맥락 유지

**👩‍💻 코드 예시**

```python
from langgraph.graph import StateGraph, START, MessagesState
from langgraph.prebuilt import ToolNode, tools_condition
from langgraph.checkpoint.memory import MemorySaver
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain_core.tools import tool

# 1. Tool 정의
@tool
def retrieve(query: str) -> str:
    """사용자의 질문과 관련된 문서를 검색합니다."""
    docs = retriever.get_relevant_documents(query)
    return "\n".join([d.page_content for d in docs])

tools = [retrieve]

# 2. LLM + Tool 바인딩
llm_with_tools = llm.bind_tools(tools)

# 3. LLM 호출 노드
def assistant(state: MessagesState):
    response = llm_with_tools.invoke(state["messages"])
    return {"messages": [response]}

# 4. 그래프 구성
builder = StateGraph(MessagesState)
builder.add_node("assistant", assistant)
builder.add_node("tools", ToolNode(tools))

builder.add_edge(START, "assistant")
builder.add_conditional_edges("assistant", tools_condition)
builder.add_edge("tools", "assistant")  # Loop 구조

# 5. 메모리 추가
memory = MemorySaver()
graph = builder.compile(checkpointer=memory)

# 실행
config = {"configurable": {"thread_id": "rag-thread-1"}}
graph.invoke({"messages": ["이 문서에서 AI 관련 내용 찾아줘"]}, config=config)
```

👉 결과:

- LLM이 Tool 호출을 판단 → `retrieve` 실행 → 검색 결과 반환 → 다시 LLM이 최종 답변 생성
- thread_id를 유지하면, “방금 검색한 내용 요약해줘” 같은 후속 질문도 처리 가능

---

## 🖥️↔️📊 SQL 연동

### 💡 핵심 개념

- **DB 연결**
    - `SQLDatabase.from_uri()`로 DB 연결 (예: PostgreSQL)
    - `get_table_info()`로 테이블 스키마 확인
- **SQL 생성 프롬프트**
    - DB 스키마를 프롬프트에 포함시켜 LLM이 올바른 SQL 생성하도록 유도
- **LLM 출력 구조화**
    - `with_structured_output` + `TypedDict`로 LLM 출력이 반드시 SQL 문자열이 되도록 강제

**👩‍💻 코드 예시**

```python
from langchain_community.utilities import SQLDatabase
from typing import TypedDict

# 1. DB 연결
db = SQLDatabase.from_uri("postgresql+psycopg2://user:password@localhost/mydb")

# 2. SQL 스키마 확인
table_info = db.get_table_info()
print(table_info)

# 3. SQL 출력 형식 정의
class SQLQuery(TypedDict):
    query: str  # 실행 가능한 SQL 쿼리

# 4. LLM 프롬프트
query_prompt_template = """
당신은 SQL 전문가입니다.
다음 DB 스키마를 참고하여 질문에 맞는 SQL 쿼리를 작성하세요.

스키마:
{schema}

질문:
{question}
"""

# 5. SQL 생성 노드
def write_sql(state):
    prompt = query_prompt_template.format(schema=table_info, question=state["question"])
    s_llm = llm.with_structured_output(SQLQuery)
    sql_query = s_llm.invoke(prompt)
    return {"sql": sql_query["query"]}

```

👉 결과:

- 사용자 질문 → LLM이 SQL 쿼리 생성 → DB에서 실행 가능
- 예:
    - 질문: “지난 달 가장 많이 팔린 제품은?”
    - 출력: `SELECT product_name, SUM(quantity) FROM sales WHERE sale_date >= '2025-08-01' AND sale_date < '2025-09-01' GROUP BY product_name ORDER BY SUM(quantity) DESC LIMIT 1;`

---

## ✅ 인사이트 & 유의사항

- **대화형 RAG**
    - Tool 기반으로 LLM이 필요 시 검색을 수행 → **ReAct 패턴**과 유사
    - thread_id + MemorySaver로 다턴 QA 가능 → 실 서비스형 QA 챗봇 구조
- **SQL 연동**
    - 자연어 → SQL 쿼리 변환 자동화
    - 스키마를 항상 프롬프트에 포함해야 정확한 SQL 생성
    - `with_structured_output`으로 출력 형식 강제하면 안정성↑