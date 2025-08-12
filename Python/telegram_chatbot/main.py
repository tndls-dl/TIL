# main.py

# 터미널에서 아래 두줄 설치해야함
# pip install fastapi
# pip install uvicorn[standard]

# 이후 아래 터미널 명령어로 서버 켬
# uvicorn main:app --reload


from fastapi import FastAPI, Request
import random
import requests
from dotenv import load_dotenv
import os
from openai import OpenAI


# .env 파일을 불러옴
load_dotenv()
app = FastAPI()


# /docs -> 라우팅 목록 페이지로 이동 가능

# http://localhost:8000/
# http://127.0.0.1:8000

@app.get('/')
def home():
    return {'home': 'i wanna go home'}


def send_message(chat_id, message):
    # .env에서 'TELEGRAM_BOT_TOKEN'에 해당하는 값을 불러옴
    bot_token = os.getenv('TELEGRAM_BOT_TOKEN')
    URL = f'https://api.telegram.org/bot{bot_token}'
    # bot에게 답장을 하자!
    body = {
        # 사용자 chat_id는 어디서 가져옴..?
        'chat_id': chat_id,
        'text': message,
    }
    requests.get(URL + '/sendMessage', body)


# /telegram 라우팅으로 텔레그램 서버가 Bot에 업데이트가 있을 경우, 우리에게 알려줌
@app.post('/telegram')
async def telegram(request: Request):
    print('텔레그램에서 요청이 들어왔다 !!!!!')

    data = await request.json()
    sender_id = data['message']['chat']['id']
    input_msg = data['message']['text']

    client = OpenAI(api_key=os.getenv('OPENAI_API_KEY'))
    res = client.responses.create(
        model='gpt-4.1-mini',
        input=input_msg,
        instructions='너는 MBTI ENFP야.',
        temperature=0
    )

    send_message(sender_id, res.output_text)

    return {'status': '굿'}



@app.get('/lotto')
def lotto():
    return {
        'numbers': random.sample(range(1, 46), 6)
    }

