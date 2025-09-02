# 📊 Supply Chain Analytics Dashboard - UI/UX Design Guide

## 🎯 시스템 목적 (System Purpose)

### 핵심 목표
**"공급망의 병목 지점을 한눈에 파악하고, 우선순위에 따라 문제를 해결할 수 있도록 돕는 대시보드"**

### 비즈니스 가치
- ⏱️ **시간 절약**: 문제 파악에 걸리는 시간을 90% 단축
- 📈 **효율성 증대**: 가장 큰 문제부터 해결하여 ROI 극대화
- 💰 **비용 절감**: 재고 적체 및 기회 손실 최소화

---

## 🔑 핵심 개념 (Key Concepts)

### 적분값 (Integral Value)
```
적분값 = (수량 갭) × (시간)
```
- **의미**: 문제의 크기와 지속 시간을 곱한 값
- **예시**: 30개 미배송 × 50일 = 1,500 (적분값)
- **해석**: 적분값이 클수록 더 심각하고 오래된 문제

### 공급망 4단계
1. **Order (주문)** → 2. **Ship (배송)** → 3. **Receive (입고)** → 4. **Sale (판매)**

### 병목 구간 3가지
- **Order→Ship**: 공급업체 문제 (재고 부족, 생산 지연)
- **Ship→Receive**: 물류 문제 (배송 지연, 운송 사고)
- **Receive→Sale**: 판매 문제 (수요 부족, 재고 과다)

---

## 📱 페이지 구조 (Page Structure)

### 1. Header Section
```
┌──────────────────────────────────────────────────────┐
│ 🏢 [회사명] Supply Chain Analytics                    │
│ 📅 기간: [2025.01.01 - 2025.01.31] [변경]            │
│ 🏪 매장: [전체 ▼] 📦 제품: [전체 ▼]                  │
└──────────────────────────────────────────────────────┘
```

### 2. Summary Cards (KPI)
```
┌─────────────┬─────────────┬─────────────┬─────────────┐
│ 🔴 긴급     │ 🟡 주의     │ 🟢 정상     │ 💵 위험금액  │
│    3건      │    8건      │   45건      │ ₩15.2M      │
└─────────────┴─────────────┴─────────────┴─────────────┘
```

### 3. Problem Priority List
```
┌──────────────────────────────────────────────────────┐
│ 📊 우선순위별 문제 제품                               │
├──────────────────────────────────────────────────────┤
│ #1 🔴 [95점] 지갑C - GOYARD                          │
│    └ 주문→배송: 15,000 (50일째 미배송)               │
│                                                       │
│ #2 🟡 [78점] 가방A - LV                              │
│    └ 배송→입고: 8,500 (운송 지연 20일)               │
│                                                       │
│ #3 🟡 [65점] 벨트G - HERMES                          │
│    └ 입고→판매: 5,200 (재고 적체 30일)               │
└──────────────────────────────────────────────────────┘
```

### 4. Visualization Area
```
┌──────────────────────────────────────────────────────┐
│ 📈 적분 차트 (Integral Chart)                        │
│                                                       │
│  수량 ↑                                               │
│   30 |     ████████████ Order                        │
│   20 |     ████████ Ship                             │
│   10 |     ████ Receive                              │
│    0 |_____|___________|___________|___→ 시간        │
│      1월   2월         3월         4월                │
│                                                       │
│  [면적 = 적분값 = 문제의 크기]                        │
└──────────────────────────────────────────────────────┘
```

---

## 🎨 UI Components 상세

### 1. Filter Panel (필터 패널)
```yaml
Company Selector:
  - Type: Dropdown
  - Default: Current company
  - Required: Yes

Store Selector:
  - Type: Multi-select dropdown
  - Options: [전체, Store1, Store2, ...]
  - Default: 전체

Product Selector:
  - Type: Searchable multi-select
  - Features: 
    - Search by name/SKU
    - Category grouping
    - Select all/none

Date Range:
  - Type: Date range picker
  - Presets: [오늘, 이번주, 이번달, 지난달, 최근 90일, 올해]
  - Custom range: Available
```

### 2. Problem Score Indicator
```yaml
Score Display:
  90-100: 
    - Color: #FF0000 (Red)
    - Icon: 🔴
    - Label: "CRITICAL"
    - Animation: Pulse
  
  70-89:
    - Color: #FFA500 (Orange)
    - Icon: 🟡
    - Label: "HIGH"
    - Animation: None
  
  50-69:
    - Color: #FFD700 (Yellow)
    - Icon: 🟠
    - Label: "MEDIUM"
    - Animation: None
  
  0-49:
    - Color: #00FF00 (Green)
    - Icon: 🟢
    - Label: "LOW"
    - Animation: None
```

### 3. Product Card (제품 카드)
```yaml
Card Structure:
  Header:
    - Problem Score (big, bold)
    - Product Name
    - SKU
    - Category/Brand badge
  
  Body:
    - Bottleneck Stage (highlighted)
    - Integral Value
    - Current Gap
    - Days Accumulated
    - Mini sparkline chart
  
  Footer:
    - Action buttons: [상세보기] [리포트] [액션]
    - Last updated timestamp
```

### 4. Integral Visualization (적분 시각화)
```yaml
Chart Type: Area Chart (Stacked)
Axes:
  X-axis: Time (days/weeks/months)
  Y-axis: Quantity

Layers:
  1. Order Line (cumulative)
  2. Ship Line (cumulative)
  3. Receive Line (cumulative)
  4. Sale Line (cumulative)

Features:
  - Hover: Show exact values
  - Click: Drill down to daily view
  - Zoom: Pinch/scroll to zoom
  - Legend: Interactive (show/hide layers)

Visual Encoding:
  - Gap area: Filled with gradient (red→yellow→green)
  - Current position: Vertical line marker
  - Problem zones: Highlighted with pattern
```

---

## 🔄 User Interactions (사용자 인터랙션)

### 1. 초기 로딩
```
1. 페이지 로드 → 스켈레톤 UI 표시
2. 데이터 로딩 (1-2초)
3. 애니메이션과 함께 데이터 표시
4. 가장 심각한 문제 자동 하이라이트
```

### 2. 필터 변경
```
1. 필터 선택 → 즉시 "적용" 버튼 활성화
2. 적용 클릭 → 로딩 스피너
3. 새 데이터로 부드럽게 전환 (fade transition)
4. 변경된 항목 하이라이트 (2초간)
```

### 3. 제품 상세 보기
```
1. 제품 카드 클릭
2. 사이드 패널 슬라이드 인
3. 상세 정보 표시:
   - 일별 적분값 추이
   - 각 단계별 상세 메트릭
   - 관련 문서 (주문서, 배송장 등)
   - 액션 히스토리
4. ESC 또는 X 클릭으로 닫기
```

### 4. 차트 인터랙션
```
- Hover: 툴팁으로 상세 값 표시
- Click & Drag: 특정 기간 선택
- Double Click: 줌 리셋
- Right Click: 컨텍스트 메뉴 (내보내기, 전체화면)
```

---

## 💼 사용 시나리오 (Use Cases)

### Scenario 1: CEO 대시보드
```
목적: 전체 공급망 건강도 파악
보기: 회사 전체, 모든 제품, 월별 뷰
관심: Problem Score 상위 5개
액션: 담당자 지정, 리포트 요청
```

### Scenario 2: 구매 담당자
```
목적: 공급업체 문제 파악
보기: Order→Ship 구간 필터
관심: 미배송 제품 리스트
액션: 공급업체 연락, 대체 공급처 찾기
```

### Scenario 3: 매장 관리자
```
목적: 재고 최적화
보기: 특정 매장, Receive→Sale 구간
관심: 재고 회전율 낮은 제품
액션: 프로모션 기획, 반품 처리
```

---

## 🎯 핵심 기능 (Key Features)

### 1. Smart Sorting (스마트 정렬)
```javascript
정렬 옵션:
- Problem Score (기본)
- Total Integral (적분값)
- Current Gap (현재 갭)
- Days Accumulated (누적 일수)
- Product Name (제품명)
- Recent Change (최근 변화율)
```

### 2. Export & Report (내보내기)
```javascript
내보내기 형식:
- PDF Report (차트 포함)
- Excel (raw data)
- CSV (simplified)
- Image (차트만)
- Share Link (7일 유효)
```

### 3. Alerts & Notifications (알림)
```javascript
알림 조건:
- Problem Score > 90
- Integral 급증 (전일 대비 50%↑)
- 새로운 병목 발생
- 목표 미달성

알림 방법:
- In-app notification
- Email digest (daily/weekly)
- SMS (critical only)
- Slack integration
```

### 4. Quick Actions (빠른 액션)
```javascript
각 제품 카드에서:
- 📞 공급업체 연락
- 📧 리포트 전송
- 📋 태스크 생성
- 🔄 상태 업데이트
- 💬 코멘트 추가
```

---

## 🎨 Visual Design Guidelines

### Color Palette
```css
Primary:
  - Critical: #FF0000 (Red)
  - Warning: #FFA500 (Orange)
  - Caution: #FFD700 (Yellow)
  - Normal: #00FF00 (Green)
  - Background: #F8F9FA
  - Text: #212529

Chart Colors:
  - Order: #4A90E2 (Blue)
  - Ship: #7B68EE (Purple)
  - Receive: #50C878 (Emerald)
  - Sale: #FFB347 (Peach)
```

### Typography
```css
Headings:
  - H1: 24px, Bold
  - H2: 20px, Semi-bold
  - H3: 16px, Medium

Body:
  - Normal: 14px, Regular
  - Small: 12px, Regular
  - Caption: 11px, Light

Numbers:
  - Score: 36px, Bold
  - Metrics: 18px, Medium
  - Table: 14px, Mono
```

### Spacing
```css
- Card padding: 16px
- Section margin: 24px
- Element spacing: 8px
- Grid gap: 16px
```

---

## 📱 Responsive Design

### Desktop (1920x1080)
- 3-column layout for cards
- Side-by-side chart and list
- Full feature set

### Tablet (768x1024)
- 2-column layout for cards
- Stacked chart and list
- Collapsible filters

### Mobile (375x812)
- Single column layout
- Swipeable cards
- Bottom sheet for details
- Simplified charts

---

## 🚀 Performance Requirements

### Loading Times
- Initial load: < 2 seconds
- Filter apply: < 1 second
- Chart render: < 500ms
- Export: < 5 seconds

### Data Limits
- Max products displayed: 100 (with pagination)
- Chart data points: 365 days max
- Real-time update: Every 5 minutes

---

## 📝 Additional Notes for Designer

1. **Accessibility**: Ensure WCAG 2.1 AA compliance
2. **Dark Mode**: Prepare alternative color scheme
3. **Animations**: Keep subtle, < 300ms duration
4. **Empty States**: Design for no data scenarios
5. **Error States**: User-friendly error messages
6. **Loading States**: Skeleton screens preferred
7. **Tooltips**: Provide context on hover
8. **Keyboard Navigation**: Full keyboard support

---

## 🔗 Related Documents
- Database Schema: `inventory_tables.md`
- API Specification: `api_endpoints.md`
- Business Logic: `supply_chain_logic.md`

---

**Document Version**: 1.0  
**Created Date**: 2025-01-31  
**Target Audience**: UI/UX Designer, Frontend Developer  
**Status**: Ready for Design

---

## 📞 Contact for Questions
- Backend: Backend Team
- Business Logic: Product Owner
- Data Structure: Database Administrator
