# 🪄 Langchain

## ✍️ DAY 01

## 🔗 LangChain

### 💡 핵심 개념

- **LangChain**: LLM을 외부 데이터·컴포넌트와 연결해 강력한 애플리케이션을 만드는 프레임워크
- 주요 구성 요소:
    - **LLM/Chat Model**: GPT 같은 언어 모델 (`ChatOpenAI`)
    - **Prompt Template**: 동적으로 메시지를 생성하는 템플릿
    - **Output Parser**: LLM 출력(예: AIMessage)을 string/JSON 등 원하는 형식으로 변환
    - **Chain (LCEL)**: 위 요소들을 `|` 연산자로 연결한 실행 흐름

**👩‍💻 코드 예시**

```python
from dotenv import load_dotenv
from langchain_openai import ChatOpenAI

load_dotenv()
llm = ChatOpenAI(model="gpt-4.1-nano")
```

### ⚙️ 실행 방식

- `invoke`: 단일 입력 → 단일 출력
- `stream`: 토큰 단위로 스트리밍 출력
- `batch`: 여러 입력을 동시에 처리

```python
response = llm.invoke("Hello, world!")  # 단일 호출
print(response.content)
```

---

## 🧩 프롬프트 다루기

### 📝 PromptTemplate (단발성)

- `{변수}` 형태로 입력값을 받을 수 있음

```python
from langchain_core.prompts import PromptTemplate
template = "{country}의 수도는 어디인가요?"
prompt = PromptTemplate.from_template(template)

chain = prompt | llm
print(chain.invoke({"country": "대한민국"}).content)
```

**👉 실행 결과:**

 `대한민국의 수도는 서울입니다.`

### 💬 ChatPromptTemplate (대화형)

- 역할(`system`, `human`, `ai`) 기반 메시지 구조
- `StrOutputParser`와 함께 사용

```python
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser

chat_template = ChatPromptTemplate.from_messages([
    ('system', '당신은 {lang}으로 번역하는 번역가입니다.'),
    ('human', '{text}를 번역해주세요.')
])

chain = chat_template | llm | StrOutputParser()
print(chain.invoke({'lang': '영어', 'text': '버거가 먹고싶다'}))
```

**👉 실행 결과:**

 `I want to eat a burger.`

### 📚 Few-Shot Prompting (예시 기반)

- LLM이 원하는 **출력 형식과 사고 흐름**을 학습하도록 예시 제공
- 복잡한 질문을 단계별로 분해 가능

```python
from langchain_core.prompts import FewShotPromptTemplate, PromptTemplate

examples = [
    {"question": "네이버의 창립자는 언제 태어났나요?",
     "answer": "...(예시 답변 구조)"}
]

example_prompt = PromptTemplate.from_template(
    "Question:\n{question}\nAnswer:\n{answer}"
)

prompt = FewShotPromptTemplate(
    examples=examples,
    example_prompt=example_prompt,
    suffix="Question:\n{question}\nAnswer:",
    input_variables=["question"],
)

chain = prompt | llm | StrOutputParser()
print(chain.invoke({"question": "Google이 창립된 연도에 Bill Gates의 나이는 몇 살인가요?"}))
```

**👉 실행 결과 (요약):**

- Google 창립연도 확인 (1998)
- Bill Gates 출생 확인 (1955)
- 나이 계산 → `43세`

---

## 🌐 LangChain Hub

- 전 세계 개발자들이 공유하는 프롬프트 저장소
- 쉽게 불러와서 재사용 가능

```python
from langchain import hub
prompt = hub.pull('hwchase17/react')
print(prompt.template)
```

---

## ✅ 인사이트 & 유의사항

- **Prompt 설계가 핵심** → 결과 품질은 프롬프트에 달려있음
- `|` 연산자를 사용한 **Chain 구조**가 코드 가독성과 유지보수에 유리
- Few-Shot은 단순 예시 제공이 아니라 **사고 과정(Chain-of-Thought)을 유도**할 수 있는 강력한 기법
- Hub 활용 시 검증된 프롬프트를 빠르게 적용 가능