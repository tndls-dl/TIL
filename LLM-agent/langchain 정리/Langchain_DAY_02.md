# 🪄 Langchain

## ✍️ DAY 02

## 🧩 출력 파서 (Output Parsers)

👉 LLM의 자유로운 텍스트 응답을 **구조화된 데이터**로 변환

### 🗂️ 주요 파서 종류

### 1) **PydanticOutputParser**

- **특징**: `Pydantic` 모델 기반으로 원하는 데이터 구조 강제
- **활용**: 이메일 요약, 사용자 정보 추출 등 복잡한 구조

```python
from pydantic import BaseModel, Field
from langchain_core.prompts import PromptTemplate
from langchain.output_parsers import PydanticOutputParser

# 모델 정의
class EmailSummary(BaseModel):
    person: str = Field(description='메일 보낸 사람')
    email: str = Field(description='보낸사람의 메일주소')
    summary: str = Field(description='메일 본문 요약')

# 파서 생성
parser = PydanticOutputParser(pydantic_object=EmailSummary)

# 프롬프트에 format_instructions 포함
prompt = PromptTemplate(
    template="Summarize the email:\n{email_conversation}\n{format_instructions}",
    partial_variables={"format_instructions": parser.get_format_instructions()},
)

# 체인 실행
chain = prompt | llm | parser
summary_object = chain.invoke({'email_conversation': email_text})
print(summary_object.person)  # "홍길동"
```

### 2) **CommaSeparatedListOutputParser**

- **특징**: 답변을 **쉼표 구분 리스트**로 변환
- **활용**: 메뉴, 항목, 키워드 리스트 생성

```python
from langchain.output_parsers import CommaSeparatedListOutputParser

parser = CommaSeparatedListOutputParser()

prompt = PromptTemplate(
    template="List 5 {subject}.\n{format_instructions}",
    partial_variables={"format_instructions": parser.get_format_instructions()},
)

chain = prompt | llm | parser
menu_list = chain.invoke({"subject": "맥도날드 대표메뉴"})
print(menu_list)
# ['Big Mac', 'Quarter Pounder with Cheese', ...]
```

### 3) **StructuredOutputParser**

- **특징**: `ResponseSchema` 기반, LLM 출력 → `dict` 변환
- **활용**: Pydantic까지 필요 없는 간단 구조

```python
from langchain.output_parsers import StructuredOutputParser, ResponseSchema

response_schemas = [
    ResponseSchema(name="answer", description="사용자의 질문에 대한 답변"),
    ResponseSchema(name="source", description="답변의 출처"),
]

parser = StructuredOutputParser.from_response_schemas(response_schemas)

chain = prompt | llm | parser
result = chain.invoke({"question": "처서는 언제야?"})
print(result)
# {'answer': '8월 23일경', 'source': '한국 전통 절기'}
```

### 4) **기타 파서**

- `PandasDataFrameOutputParser`: 자연어 → Pandas DataFrame 연산 결과
- `DatetimeOutputParser`: 날짜/시간 → Python datetime 객체
- `EnumOutputParser`: 미리 정의한 Enum 값만 선택 가능 (답변 범위 제한)

---

## 🧠 메모리 (Memory)

👉 기본적으로 LLM은 **stateless** → 이전 대화를 기억하지 못함.

➡️ `Memory`를 이용해 대화 맥락을 유지 가능

### **💬 ConversationBufferMemory**

- 대화 내용을 **버퍼 형태**로 저장
- `MessagesPlaceholder`를 통해 프롬프트 내에 삽입

```python
from langchain.memory import ConversationBufferMemory
from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain_core.runnables import RunnablePassthrough, RunnableLambda
from operator import itemgetter

# 1. 메모리 생성
memory = ConversationBufferMemory(return_messages=True, memory_key="chat_history")
llm = ChatOpenAI(model="gpt-4.1-nano")

# 2. 프롬프트 설정
prompt = ChatPromptTemplate.from_messages([
    ("system", "넌 유용한 챗봇이야."),
    MessagesPlaceholder(variable_name="chat_history"),
    ("human", "{input}"),
])

# 3. 메모리 → 프롬프트 연결
runnable = RunnablePassthrough.assign(
    chat_history=RunnableLambda(memory.load_memory_variables) | itemgetter("chat_history")
)

chain = runnable | prompt | llm

# --- 대화 루프 ---
user_input = "내 이름은 제미니야."
response = chain.invoke({"input": user_input})
memory.save_context({"human": user_input}, {"ai": response.content})

# 이어서 대화
user_input_2 = "내 이름이 뭐라고 했지?"
response_2 = chain.invoke({"input": user_input_2})
print(response_2.content)
# "당신의 이름은 제미니라고 하셨습니다."
```

---

## ✅ 인사이트 & 유의사항

- **Output Parser** → LLM 답변의 **일관성과 안정성** 확보 필수
    - 프롬프트에 `parser.get_format_instructions()`를 포함해야 원하는 구조 보장
- **Pydantic vs StructuredOutputParser**
    - 구조가 복잡 → Pydantic
    - 단순 dict → StructuredOutputParser
- **Memory**는 실제 대화형 앱에서 필수
    - 단, 저장되는 내용이 많으면 프롬프트 길이 증가 → 비용 상승 주의
- 여러 Memory 유형이 있음 (Buffer, Summary, Vector 등) → 상황에 맞게 선택