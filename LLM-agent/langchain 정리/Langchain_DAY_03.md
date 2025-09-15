# 🪄 Langchain

## ✍️ DAY 03

## 🌐 웹 검색 (Web Search)

### 💡 핵심 개념

- **LLM의 한계**: 학습 시점 이후 지식 없음 → 최신 정보 부족
- **해결책**: 웹 검색 도구 연결
- **대표 도구**: `TavilySearch` → 웹 검색 결과 반환

### 🤖 에이전트 (Agent)

- LLM이 스스로 판단해 도구 사용 여부 결정
- 주요 구성요소:
    - **도구(tools)**: `TavilySearch`, RAG 등
    - **프롬프트(prompt)**: LLM에게 도구 사용법 안내
    - **메모리(memory)**: 대화 맥락 유지 (`ConversationBufferMemory`)
    - **AgentExecutor**: Agent 실행을 담당하는 체인
    

**👩‍💻 코드 예시**

```python
from langchain_tavily import TavilySearch
from langchain.agents import create_openai_tools_agent, AgentExecutor
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain.memory import ConversationBufferMemory

# 1. 도구 정의
search_tool = TavilySearch(max_results=5)
tools = [search_tool]

# 2. 프롬프트 설정
prompt = ChatPromptTemplate.from_messages([
    ('system', '너는 훌륭한 어시스턴트야. 반드시 웹 검색도구를 사용해서 정보를 얻어.'),
    MessagesPlaceholder(variable_name='chat_history'),
    ('human', '{input}'),
    MessagesPlaceholder(variable_name='agent_scratchpad')
])

# 3. 메모리 설정
memory = ConversationBufferMemory(memory_key='chat_history', return_messages=True)

# 4. Agent 생성
agent = create_openai_tools_agent(llm=llm, tools=tools, prompt=prompt)

# 5. Executor로 실행
agent_executor = AgentExecutor(agent=agent, tools=tools, memory=memory, verbose=True)

# 실행
agent_executor.invoke({'input': '요즘 인기있는 AI 모델 알려줘'})
```

**👉 최신 정보 기반 답변 제공 가능**

---

## 🔍 검색-증강 생성 (RAG: Retrieval-Augmented Generation)

### 💡 핵심 개념

- **RAG**: LLM + 특정 문서 기반 검색 결합
- 문서 기반 QA 챗봇 제작에 활용

### ⚙️ RAG 파이프라인 (4단계)

1. **Load**: 문서 불러오기 (예: `PyMuPDFLoader`)
2. **Split**: 문서 분할 (`RecursiveCharacterTextSplitter`)
3. **Embed**: 임베딩 생성 (`OpenAIEmbeddings`)
4. **Store**: 벡터DB 저장 (`FAISS`, `Chroma`)

### 🛠️ Retriever Tool

- `vectorstore.as_retriever()` → 검색기 생성
- `create_retriever_tool` → Agent가 사용할 수 있는 **도구 형태**로 변환

**👩‍💻 코드 예시**

```python
from langchain_community.document_loaders import PyMuPDFLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_openai import OpenAIEmbeddings
from langchain.vectorstores import FAISS
from langchain.tools.retriever import create_retriever_tool

# 1. 문서 로드
loader = PyMuPDFLoader('./data/spri.pdf')
docs = loader.load()

# 2. 분할
splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=50)
split_docs = splitter.split_documents(docs)

# 3. 임베딩 + 벡터스토어
embedding = OpenAIEmbeddings()
vectorstore = FAISS.from_documents(split_docs, embedding=embedding)
retriever = vectorstore.as_retriever()

# 4. Retriever Tool 생성
rag_tool = create_retriever_tool(
    retriever,
    name='pdf_search',
    description='PDF 문서에서 질문과 관련된 내용을 검색합니다.'
)

# Agent 생성 시 tools에 rag_tool 포함
tools = [search_tool, rag_tool]
```

👉 Agent가 **웹 검색**과 **문서 검색**을 상황에 맞게 선택

---

## ✨ 최종 결론

- **웹 검색 Agent**: 최신 정보 / 일반적 질문 처리에 유리
- **RAG Agent**: 특정 문서 기반 QA에 강력
- **통합 Agent**: 두 도구를 모두 포함 → 질문 성격에 따라 자동 선택

---

## ✅ 인사이트 & 유의사항

- Agent 설계 시 **도구 설명(description)**을 명확히 작성해야 LLM이 올바르게 도구 선택
- RAG는 **데이터 기반 QA**에 적합 → 회사 내부 문서, 법률, 기술 매뉴얼에 유용
- 웹 검색 + RAG 통합 시 **실제 서비스 챗봇 수준**의 에이전트 구현 가능