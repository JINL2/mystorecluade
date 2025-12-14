# MyFinance App - Feature & Route Mapping for AI Training

> This document maps all app features to their routes and functionalities for AI assistant training.

---

## Quick Reference Table

| Category | Feature | Route | Description (EN) | Description (KR) |
|----------|---------|-------|------------------|------------------|
| **Auth** | Welcome | `/auth` | Authentication welcome page | 인증 시작 페이지 |
| **Auth** | Login | `/auth/login` | User login | 로그인 |
| **Auth** | Signup | `/auth/signup` | New user registration | 회원가입 |
| **Auth** | Verify Email | `/auth/verify-email` | Email OTP verification | 이메일 인증 |
| **Auth** | Forgot Password | `/auth/forgot-password` | Password recovery | 비밀번호 찾기 |
| **Auth** | Verify OTP | `/auth/verify-otp` | OTP verification for password reset | 비밀번호 재설정 OTP 인증 |
| **Auth** | Reset Password | `/auth/reset-password` | Set new password | 새 비밀번호 설정 |
| **Auth** | Complete Profile | `/auth/complete-profile` | Complete profile after social login | 프로필 완성 (소셜 로그인 후) |
| **Onboarding** | Choose Role | `/onboarding/choose-role` | Select owner or employee role | 역할 선택 (사장/직원) |
| **Onboarding** | Create Business | `/onboarding/create-business` | Create new company | 새 회사 생성 |
| **Onboarding** | Create Store | `/onboarding/create-store` | Create new store | 새 매장 생성 |
| **Onboarding** | Join Business | `/onboarding/join-business` | Join existing company via QR | QR로 기존 회사 참여 |
| **Home** | Homepage | `/` | Main dashboard | 메인 대시보드 |
| **Cash** | Cash Ending | `/cashEnding` | Daily cash closing/reconciliation | 일일 마감 |
| **Cash** | Cash Location | `/cashLocation` | View cash/bank account balances | 자금 현황 (금고/은행 잔액) |
| **Cash** | Account Detail | `/cashLocation/account/:name` | Detailed account transactions | 계좌 상세 내역 |
| **Cash** | Register Denomination | `/registerDenomination` | Register cash denominations | 현금 권종 등록 |
| **Finance** | Journal Input | `/journal-input` | Record financial transactions | 전표 입력 (거래 기록) |
| **Finance** | Transaction History | `/transactionHistory` | View all transaction records | 거래 내역 조회 |
| **Finance** | Transaction Template | `/transactionTemplate` | Manage transaction templates | 전표 템플릿 관리 |
| **Finance** | Balance Sheet | `/balanceSheet` | View balance sheet report | 재무상태표 |
| **Finance** | Report Control | `/reportControl` | Financial reports dashboard | 재무 보고서 |
| **Debt** | Debt Control | `/debtControl` | Manage debts/receivables | 채권/채무 관리 |
| **Debt** | Counter Party | `/registerCounterparty` | Manage vendors/customers | 거래처 관리 |
| **Debt** | Debt Account Settings | `/debtAccountSettings/:id/:name` | Configure debt accounts | 채무 계정 설정 |
| **Asset** | Add Fixed Asset | `/addFixAsset` | Register fixed assets | 고정자산 등록 |
| **Inventory** | Inventory Management | `/inventoryManagement` | Manage products | 상품 관리 |
| **Inventory** | Add Product | `/inventoryManagement/addProduct` | Add new product | 상품 추가 |
| **Inventory** | Product Detail | `/inventoryManagement/product/:id` | View product details | 상품 상세 |
| **Inventory** | Edit Product | `/inventoryManagement/editProduct/:id` | Edit product info | 상품 수정 |
| **Sales** | Sale Product | `/saleProduct` | POS / Record sales | 상품 판매 (POS) |
| **Sales** | Sales Invoice | `/salesInvoice` | View/manage sales invoices | 판매 송장 |
| **Session** | Session Home | `/session` | Inventory counting session hub | 재고 세션 홈 |
| **Session** | Session Action | `/session/action/:type` | Create or join session | 세션 생성/참여 |
| **Session** | Session List | `/session/list/:type` | View available sessions | 참여 가능한 세션 목록 |
| **Session** | Session Detail | `/session/detail/:id` | Active session counting | 세션 상세 (실사 진행) |
| **Session** | Session Review | `/session/review/:id` | Review counted items | 실사 결과 검토 |
| **Session** | Session History | `/session/history` | View past sessions | 과거 세션 내역 |
| **Session** | Session History Detail | `/session/history/detail` | Past session details | 과거 세션 상세 |
| **HR** | Employee Setting | `/employeeSetting` | Manage employees | 직원 관리 |
| **HR** | Store Shift | `/storeShiftSetting` | Configure store shifts | 근무 시프트 설정 |
| **HR** | Timetable Manage | `/timetableManage` | Manage work schedules | 근무 시간표 관리 |
| **HR** | Delegate Role | `/delegateRolePage` | Assign permissions | 권한 위임 |
| **HR** | Attendance | `/attendance` | Check-in/out system | 출퇴근 관리 |
| **HR** | QR Scanner | `/attendance/qr-scanner` | Scan QR for attendance | 출퇴근 QR 스캔 |
| **Profile** | My Page | `/my-page` | User profile | 마이페이지 |
| **Profile** | Edit Profile | `/edit-profile` | Edit user info | 프로필 수정 |
| **Profile** | Notifications | `/notifications` | View notifications | 알림 목록 |
| **Profile** | Notification Settings | `/notifications-settings` | Configure notifications | 알림 설정 |
| **Profile** | Privacy Security | `/privacy-security` | Security settings | 개인정보/보안 |
| **Profile** | Language Settings | `/language-settings` | Change language | 언어 설정 |
| **Profile** | Subscription | `/subscription` | Manage subscription plan | 구독 관리 |
| **Dev** | Theme Library | `/library` | UI component library | 테마 라이브러리 |

---

## Feature Details by Category

### 1. Authentication (인증)

| Question (User might ask) | Answer | Route |
|---------------------------|--------|-------|
| How do I login? / 어떻게 로그인해? | Go to Login page | `/auth/login` |
| How do I create an account? / 회원가입은? | Go to Signup page | `/auth/signup` |
| I forgot my password / 비밀번호를 잊어버렸어 | Use Forgot Password | `/auth/forgot-password` |
| How to verify my email? / 이메일 인증은? | Check Verify Email page | `/auth/verify-email` |

### 2. Cash Management (자금 관리)

| Question | Answer | Route |
|----------|--------|-------|
| Where can I close the day? / 마감은 어디서? | Cash Ending page | `/cashEnding` |
| Where to check account balances? / 잔액 확인은? | Cash Location page | `/cashLocation` |
| How to register cash counts? / 현금 실사는? | Register Denomination | `/registerDenomination` |
| Where to see bank accounts? / 은행 계좌는? | Cash Location → Account Detail | `/cashLocation/account/:name` |

### 3. Financial Records (재무 기록)

| Question | Answer | Route |
|----------|--------|-------|
| How to record a transaction? / 거래 기록은? | Journal Input | `/journal-input` |
| Where to see all transactions? / 거래 내역은? | Transaction History | `/transactionHistory` |
| Where is the balance sheet? / 재무상태표는? | Balance Sheet page | `/balanceSheet` |
| Where are financial reports? / 재무 보고서는? | Report Control | `/reportControl` |
| How to create transaction templates? / 전표 템플릿은? | Transaction Template | `/transactionTemplate` |

### 4. Debt Management (채권/채무 관리)

| Question | Answer | Route |
|----------|--------|-------|
| Where to manage debts? / 채무 관리는? | Debt Control | `/debtControl` |
| Where to add vendors/customers? / 거래처 등록은? | Counter Party | `/registerCounterparty` |
| Where to see who owes me? / 받을 돈 확인은? | Debt Control (Receivables tab) | `/debtControl` |
| Where to see what I owe? / 줄 돈 확인은? | Debt Control (Payables tab) | `/debtControl` |

### 5. Inventory (재고 관리)

| Question | Answer | Route |
|----------|--------|-------|
| Where to manage products? / 상품 관리는? | Inventory Management | `/inventoryManagement` |
| How to add a new product? / 상품 추가는? | Add Product | `/inventoryManagement/addProduct` |
| Where to do inventory count? / 재고 실사는? | Session page | `/session` |
| Where to see past inventory counts? / 과거 실사 내역은? | Session History | `/session/history` |

### 6. Sales (판매)

| Question | Answer | Route |
|----------|--------|-------|
| Where is POS? / POS는 어디야? | Sale Product | `/saleProduct` |
| How to record a sale? / 판매 기록은? | Sale Product page | `/saleProduct` |
| Where to see sales invoices? / 판매 송장은? | Sales Invoice | `/salesInvoice` |

### 7. HR & Attendance (인사/출퇴근)

| Question | Answer | Route |
|----------|--------|-------|
| Where to manage employees? / 직원 관리는? | Employee Setting | `/employeeSetting` |
| How to check in/out? / 출퇴근은? | Attendance page | `/attendance` |
| Where to set work schedules? / 근무 일정은? | Timetable Manage | `/timetableManage` |
| How to set up shifts? / 시프트 설정은? | Store Shift | `/storeShiftSetting` |
| How to assign permissions? / 권한 부여는? | Delegate Role | `/delegateRolePage` |

### 8. Profile & Settings (프로필/설정)

| Question | Answer | Route |
|----------|--------|-------|
| Where is my profile? / 내 프로필은? | My Page | `/my-page` |
| How to edit my info? / 정보 수정은? | Edit Profile | `/edit-profile` |
| Where are notifications? / 알림은? | Notifications | `/notifications` |
| How to change language? / 언어 변경은? | Language Settings | `/language-settings` |
| Where to manage subscription? / 구독 관리는? | Subscription | `/subscription` |

---

## Session Types (세션 유형)

| Type | Description (EN) | Description (KR) | Route Pattern |
|------|------------------|------------------|---------------|
| `counting` | Physical inventory count | 재고 실사 | `/session/action/counting` |
| `receiving` | Goods receiving | 입고 | `/session/action/receiving` |

---

## Navigation Flow Examples

### Daily Operations Flow
```
Homepage (/)
  → Cash Ending (/cashEnding) - Daily closing
  → Cash Location (/cashLocation) - Check balances
  → Journal Input (/journal-input) - Record transactions
```

### Inventory Count Flow
```
Homepage (/)
  → Session (/session) - Start counting
  → Session Action (/session/action/counting) - Create session
  → Session Detail (/session/detail/:id) - Count items
  → Session Review (/session/review/:id) - Review results
```

### Employee Management Flow
```
Homepage (/)
  → Employee Setting (/employeeSetting) - View employees
  → Delegate Role (/delegateRolePage) - Assign permissions
  → Store Shift (/storeShiftSetting) - Set shifts
  → Timetable Manage (/timetableManage) - Manage schedules
```

---

## Feature Access by Role

| Feature | Owner | Manager | Staff |
|---------|-------|---------|-------|
| Cash Ending | ✅ | ✅ | ❌ |
| Cash Location | ✅ | ✅ | View Only |
| Journal Input | ✅ | ✅ | ❌ |
| Employee Setting | ✅ | ❌ | ❌ |
| Delegate Role | ✅ | ❌ | ❌ |
| Balance Sheet | ✅ | ✅ | ❌ |
| Inventory Management | ✅ | ✅ | View Only |
| Sale Product | ✅ | ✅ | ✅ |
| Attendance | ✅ | ✅ | ✅ |
| Session (Counting) | ✅ | ✅ | ✅ |

---

## AI Response Guidelines

When user asks about a feature:

1. **Identify the intent** - What does the user want to do?
2. **Map to feature** - Which feature handles this?
3. **Provide route** - Give the navigation path
4. **Add context** - Explain briefly what they can do there

### Example Responses:

**User**: "Where can I see my cash balance?"
**AI**: "You can check your cash balance in **Cash Location** (`/cashLocation`). This page shows all your cash locations (safe, register) and bank accounts with their current balances."

**User**: "재고 실사는 어디서 해?"
**AI**: "재고 실사는 **Session** 페이지(`/session`)에서 할 수 있습니다. 'Start Counting' 버튼을 눌러 새 세션을 시작하거나, 기존 세션에 참여할 수 있습니다."

**User**: "How do I add a new employee?"
**AI**: "Go to **Employee Setting** (`/employeeSetting`). There you can add new employees, manage their roles, and configure their access permissions."
