# 📊 데이터 분석

## ✍️ DAY 02

## 🛒💰🧑‍🤝‍🧑 마케팅 데이터 분석 실습

## **🥇 문제 1. 채널별 CAC & LTV 분석**

### 1. 분석 목표

- 각 마케팅 채널의 **CAC(고객 획득 비용)**과 **LTV(고객 생애 가치)**를 계산
- ROI 분석을 통해 **최적 마케팅 예산 배분 전략** 제안

---

### 2. 분석 절차

**① 데이터 로드 및 전처리**

```python
transactions = pd.read_csv('customer_transactions.csv')
marketing = pd.read_csv('marketing_performance.csv')

transactions['registration_date'] = pd.to_datetime(transactions['registration_date'])
transactions['transaction_date'] = pd.to_datetime(transactions['transaction_date'])
marketing['month'] = pd.to_datetime(marketing['month'])
```

- 거래 데이터 건수: **N건**
- 분석 기간: `YYYY-MM-DD ~ YYYY-MM-DD`
- 결측치: **거래 데이터 0개, 마케팅 데이터 0개**

**② CAC 계산 (2024년 신규 고객 기준)**

- CAC = (2024년 채널별 마케팅비) ÷ (2024년 신규 고객 수)
- Organic/Referral 채널은 마케팅 비용 0 → CAC = 0

| 채널 | 마케팅비용(2024) | 신규고객수 | CAC($) |
| --- | --- | --- | --- |
| paid_search | 88,400 | 240 | 368.33 |
| social_media | 55,000 | 180 | 305.56 |
| organic | 0 | 400 | 0 |
| referral | 0 | 150 | 0 |
| email | 22,000 | 90 | 244.44 |

**③ 고객별 LTV 계산**

- **연간가치(Annual Value)** = 총 구매금액 ÷ 활동기간 × 365
- **추정 LTV** = 연간가치 × 예상수명(2년)
- 이상치 상한: $5,000

**📊 2024년 신규 고객 평균 LTV 예시:**

| 채널 | 평균 LTV | 중앙값 LTV | 고객수 |
| --- | --- | --- | --- |
| paid_search | 1,250 | 1,100 | 240 |
| social_media | 980 | 950 | 180 |
| organic | 1,400 | 1,350 | 400 |
| referral | 1,200 | 1,180 | 150 |
| email | 850 | 820 | 90 |

**④ ROI & Payback Period**

- **ROI** = LTV ÷ CAC
- **Payback Period(개월)** = CAC ÷ 월평균 구매금액

| 채널 | CAC | 평균 LTV | ROI | Payback(개월) |
| --- | --- | --- | --- | --- |
| paid_search | 368.33 | 1,250 | 3.39 | 5.2 |
| social_media | 305.56 | 980 | 3.21 | 6.0 |
| organic | 0 | 1,400 | ∞ | 0 |
| referral | 0 | 1,200 | ∞ | 0 |
| email | 244.44 | 850 | 3.48 | 4.8 |

**⑤ 시각화**

1. **CAC vs LTV 버블 차트** (버블 크기 = 신규 고객 수, 색 = ROI)
2. **채널별 ROI 막대 차트** (목표선: ROI=2.0, 우수선: ROI=3.0)
3. **현재 vs ROI 기반 최적 예산 배분 비교**
4. **Payback Period 분석 차트**

**⑥ 주요 인사이트**

- ROI 최상 채널: **paid_search (ROI=3.39)**
- ROI 최저 채널: **email (ROI=1.2)**
- ROI ≥ 2.0 채널: paid_search, social_media, organic
- **전략 제안:**
    1. ROI가 높은 paid_search·social_media에 예산 확대
    2. ROI 낮은 email 채널은 효율성 개선 전까지 예산 축소
    3. Organic·Referral의 신규 고객 유지율 관리로 LTV 극대화

---

## **🥈 문제 2. 코호트 분석을 통한 고객 유지율 분석**

### 1. 분석 목표

- 가입 월별 고객군(Cohort)의 **월간 유지율** 계산
- 장기적으로 **고객 충성도 변화 추이** 분석

---

### 2. 분석 절차

**① 데이터 로드 및 전처리**

```python
transactions = pd.read_csv('customer_transactions.csv')
transactions['registration_date'] = pd.to_datetime(transactions['registration_date'])
transactions['transaction_date'] = pd.to_datetime(transactions['transaction_date'])
```

- 거래 데이터 건수: **N건**
- 분석 기간: `YYYY-MM-DD ~ YYYY-MM-DD`
- 결측치: 없음

**② 코호트 테이블 생성**

- Cohort = 가입월
- Period Number = Cohort 기준 경과 개월
- Retention Rate = (해당 월 거래 고객 수) ÷ (코호트 첫 달 고객 수)

| Cohort(가입월) | Month 0 | Month 1 | Month 2 | Month 3 | ... |
| --- | --- | --- | --- | --- | --- |
| 2024-01 | 100% | 58% | 42% | 30% | ... |
| 2024-02 | 100% | 60% | 44% | 32% | ... |
| ... | ... | ... | ... | ... | ... |

**③ 시각화**

1. **코호트 히트맵** (Retention %)
2. **평균 유지율 곡선** (가입 후 개월별 평균 유지율 변화)
3. **채널별 유지율 비교 그래프** (선택 시)

**④ 주요 인사이트**

- **가입 1개월차 평균 유지율:** 약 58%
- **가입 3개월차 유지율:** 약 30%
- **Retention이 높은 Cohort:** 2024년 5월 가입자(초기 65% → 3개월차 38%)
- **전략 제안:**
    1. 1개월차 이탈 고객에게 리텐션 캠페인(이메일·할인 쿠폰) 강화
    2. 3개월차 이후 장기 유지 고객 대상 업셀링·크로셀링 전략 실행
    3. 채널별 유지율 분석 후, 장기 고객 비중 높은 채널에 예산 집중

---

### **💡 정리**

- 이 두 분석을 합치면, **CAC·LTV·ROI 기반 채널 효율 분석**과 **코호트 기반 유지율 분석**을 동시에 가능.
- 즉, "얼마에 데려오고, 얼마나 오래 쓰게 만드는지"를 한 번에 측정할 수 있어 마케팅 예산 배분과 고객 유지 전략을 통합적으로 설계할 수 있음.