# MyFinance Ontology AI Guide
# MyFinance 온톨로지 AI 가이드
# Hướng dẫn AI Ontology MyFinance

> **Version**: 1.0.0
> **Last Updated**: 2024-12
> **Supported Languages**: 🇰🇷 한국어 | 🇺🇸 English | 🇻🇳 Tiếng Việt

---

## 📌 What is this? | 이게 뭐야? | Đây là gì?

This document is the **"brain map"** that allows AI to understand your company's data structure.
이 문서는 AI가 회사 데이터 구조를 이해할 수 있게 하는 **"두뇌 지도"**입니다.
Tài liệu này là **"bản đồ não"** cho phép AI hiểu cấu trúc dữ liệu công ty của bạn.

---

## 🏗️ Database Statistics | 데이터베이스 통계 | Thống kê cơ sở dữ liệu

| Category | Count | Description |
|----------|-------|-------------|
| Users | 288 | 사용자 / Người dùng |
| Companies | 236 | 회사 / Công ty |
| Stores | 178 | 매장 / Cửa hàng |
| Roles | 470 | 역할 / Vai trò |
| Journal Entries | 4,626 | 거래기록 / Giao dịch |
| Journal Lines | 9,896 | 거래상세 / Chi tiết giao dịch |
| Shift Requests | 5,635 | 근무기록 / Hồ sơ ca làm |
| Accounts | 56 | 계정과목 / Tài khoản |
| Counterparties | 99 | 거래처 / Đối tác |
| Cash Locations | 186 | 현금보관소 / Vị trí tiền mặt |
| Debts/Receivables | 462 | 채권채무 / Công nợ |
| Fixed Assets | 38 | 고정자산 / Tài sản cố định |

---

# 📊 PART 1: Entity Definitions | 엔티티 정의 | Định nghĩa thực thể

## 1.1 Core Entities | 핵심 엔티티 | Thực thể cốt lõi

### 👤 User | 사용자 | Người dùng

| Property | Description |
|----------|-------------|
| **Table** | `users` |
| **🇰🇷** | 앱을 사용하는 모든 사람 (사장, 매니저, 직원) |
| **🇺🇸** | All people using the app (owner, manager, employee) |
| **🇻🇳** | Tất cả người dùng ứng dụng (chủ, quản lý, nhân viên) |
| **Key Columns** | `user_id`, `first_name`, `last_name`, `email` |
| **Row Count** | 288 |

**Synonyms | 동의어 | Từ đồng nghĩa:**
- 🇰🇷: 사용자, 직원, 유저, 스태프, 근무자, 사원
- 🇺🇸: user, employee, staff, worker, member
- 🇻🇳: người dùng, nhân viên, thành viên

---

### 🏢 Company | 회사 | Công ty

| Property | Description |
|----------|-------------|
| **Table** | `companies` |
| **🇰🇷** | 사업체/회사 단위. 한 사용자가 여러 회사를 관리할 수 있음 |
| **🇺🇸** | Business entity. One user can manage multiple companies |
| **🇻🇳** | Đơn vị doanh nghiệp. Một người dùng có thể quản lý nhiều công ty |
| **Key Columns** | `company_id`, `company_name`, `company_code`, `owner_id`, `timezone` |
| **Row Count** | 236 |

**Synonyms | 동의어 | Từ đồng nghĩa:**
- 🇰🇷: 회사, 사업체, 법인, 기업, 업체
- 🇺🇸: company, business, corporation, firm, enterprise
- 🇻🇳: công ty, doanh nghiệp, cơ sở kinh doanh

---

### 🏪 Store | 매장 | Cửa hàng

| Property | Description |
|----------|-------------|
| **Table** | `stores` |
| **🇰🇷** | 회사 안의 매장/지점. 직원들이 여기서 근무함 |
| **🇺🇸** | Store/branch within a company. Employees work here |
| **🇻🇳** | Cửa hàng/chi nhánh trong công ty. Nhân viên làm việc tại đây |
| **Key Columns** | `store_id`, `store_name`, `store_code`, `company_id`, `store_address` |
| **Row Count** | 178 |

**Synonyms | 동의어 | Từ đồng nghĩa:**
- 🇰🇷: 매장, 지점, 스토어, 가게, 점포, 샵
- 🇺🇸: store, branch, shop, outlet, location
- 🇻🇳: cửa hàng, chi nhánh, shop, địa điểm

---

### 🎭 Role | 역할 | Vai trò

| Property | Description |
|----------|-------------|
| **Table** | `roles` |
| **🇰🇷** | 회사 내 역할 (사장, 매니저, 직원 등). ⚠️ **Company와 1:1 관계** |
| **🇺🇸** | Role within company (owner, manager, employee). ⚠️ **1:1 with Company** |
| **🇻🇳** | Vai trò trong công ty (chủ, quản lý, nhân viên). ⚠️ **1:1 với Công ty** |
| **Key Columns** | `role_id`, `role_name`, `role_type`, `company_id`, `parent_role_id` |
| **Row Count** | 470 |

**⚠️ IMPORTANT: Role-Company Relationship is 1:1**
- 🇰🇷: 회사마다 고유한 역할 세트를 가짐. 같은 사용자가 다른 회사에서 다른 역할 가능
- 🇺🇸: Each company has its own unique role set. Same user can have different roles in different companies
- 🇻🇳: Mỗi công ty có bộ vai trò riêng. Cùng người dùng có thể có vai trò khác nhau ở các công ty khác nhau

**Synonyms | 동의어 | Từ đồng nghĩa:**
- 🇰🇷: 역할, 직책, 직급, 포지션
- 🇺🇸: role, position, title, rank
- 🇻🇳: vai trò, chức vụ, vị trí

---

## 1.2 Financial Entities | 재무 엔티티 | Thực thể tài chính

### 📒 Journal Entry | 거래기록 | Giao dịch

| Property | Description |
|----------|-------------|
| **Table** | `journal_entries` |
| **🇰🇷** | 회계 거래 기록의 헤더. 하나의 거래 이벤트를 나타냄 |
| **🇺🇸** | Header of accounting transaction. Represents one transaction event |
| **🇻🇳** | Tiêu đề giao dịch kế toán. Đại diện cho một sự kiện giao dịch |
| **Key Columns** | `journal_id`, `company_id`, `store_id`, `entry_date`, `description`, `journal_type` |
| **Row Count** | 4,626 |

**Synonyms | 동의어 | Từ đồng nghĩa:**
- 🇰🇷: 거래, 분개, 전표, 거래기록, 회계기록
- 🇺🇸: transaction, journal, entry, record
- 🇻🇳: giao dịch, bút toán, phiếu kế toán

---

### 📝 Journal Line | 거래상세 | Chi tiết giao dịch

| Property | Description |
|----------|-------------|
| **Table** | `journal_lines` |
| **🇰🇷** | 거래의 상세 내역. 차변(debit)과 대변(credit)으로 구분 |
| **🇺🇸** | Transaction detail. Divided into debit and credit |
| **🇻🇳** | Chi tiết giao dịch. Chia thành nợ (debit) và có (credit) |
| **Key Columns** | `line_id`, `journal_id`, `account_id`, `debit`, `credit`, `description` |
| **Row Count** | 9,896 |

**Column Meanings | 컬럼 의미 | Ý nghĩa cột:**
| Column | 🇰🇷 | 🇺🇸 | 🇻🇳 |
|--------|------|------|------|
| `debit` | 차변 (자산↑, 비용↑) | Debit (Asset↑, Expense↑) | Nợ (Tài sản↑, Chi phí↑) |
| `credit` | 대변 (수익↑, 부채↑) | Credit (Revenue↑, Liability↑) | Có (Doanh thu↑, Nợ phải trả↑) |

---

### 💰 Account | 계정과목 | Tài khoản

| Property | Description |
|----------|-------------|
| **Table** | `accounts` |
| **🇰🇷** | 계정과목 (현금, 매출, 비용, 자산 등) |
| **🇺🇸** | Chart of accounts (cash, revenue, expense, asset) |
| **🇻🇳** | Hệ thống tài khoản (tiền mặt, doanh thu, chi phí, tài sản) |
| **Key Columns** | `account_id`, `account_name`, `account_type`, `account_code` |
| **Row Count** | 56 |

**Account Types | 계정 유형 | Loại tài khoản:**
| Type | 🇰🇷 | 🇺🇸 | 🇻🇳 |
|------|------|------|------|
| `asset` | 자산 | Asset | Tài sản |
| `liability` | 부채 | Liability | Nợ phải trả |
| `equity` | 자본 | Equity | Vốn chủ sở hữu |
| `income` | 수익/매출 | Income/Revenue | Thu nhập/Doanh thu |
| `expense` | 비용 | Expense | Chi phí |

---

### 👥 Counterparty | 거래처 | Đối tác

| Property | Description |
|----------|-------------|
| **Table** | `counterparties` |
| **🇰🇷** | 거래처 (공급업체, 고객 등) |
| **🇺🇸** | Trading partner (supplier, customer) |
| **🇻🇳** | Đối tác giao dịch (nhà cung cấp, khách hàng) |
| **Key Columns** | `counterparty_id`, `company_id`, `name`, `type`, `email`, `phone` |
| **Row Count** | 99 |

**Synonyms | 동의어 | Từ đồng nghĩa:**
- 🇰🇷: 거래처, 공급업체, 고객, 협력사
- 🇺🇸: counterparty, supplier, vendor, customer, partner
- 🇻🇳: đối tác, nhà cung cấp, khách hàng

---

### 💳 Debt/Receivable | 채권채무 | Công nợ

| Property | Description |
|----------|-------------|
| **Table** | `debts_receivable` |
| **🇰🇷** | 채권/채무 (받을 돈/줄 돈) |
| **🇺🇸** | Accounts receivable/payable |
| **🇻🇳** | Công nợ phải thu/phải trả |
| **Key Columns** | `debt_id`, `company_id`, `counterparty_id`, `direction`, `original_amount`, `remaining_amount` |
| **Row Count** | 462 |

**Direction Values | 방향 값 | Giá trị hướng:**
| Value | 🇰🇷 | 🇺🇸 | 🇻🇳 |
|-------|------|------|------|
| `receivable` | 미수금 (받을 돈) | Receivable (owed to us) | Phải thu (tiền người khác nợ) |
| `payable` | 미지급금 (줄 돈) | Payable (we owe) | Phải trả (tiền ta nợ) |

---

## 1.3 HR Entities | 인사 엔티티 | Thực thể nhân sự

### ⏰ Shift Request | 근무기록 | Hồ sơ ca làm

| Property | Description |
|----------|-------------|
| **Table** | `shift_requests` |
| **🇰🇷** | 직원의 근무 기록 (출퇴근, 지각, 초과근무 등) |
| **🇺🇸** | Employee work records (attendance, late arrival, overtime) |
| **🇻🇳** | Hồ sơ làm việc nhân viên (chấm công, đi muộn, làm thêm giờ) |
| **Key Columns** | `shift_request_id`, `user_id`, `store_id`, `shift_id`, `request_date`, `is_late`, `is_extratime` |
| **Row Count** | 5,635 |

**Key Flags | 주요 플래그 | Cờ quan trọng:**
| Flag | 🇰🇷 | 🇺🇸 | 🇻🇳 |
|------|------|------|------|
| `is_late` | 지각 여부 | Late arrival | Đi muộn |
| `is_extratime` | 초과근무 여부 | Overtime | Làm thêm giờ |
| `is_approved` | 승인 여부 | Approved | Đã duyệt |
| `is_problem` | 문제 발생 | Problem occurred | Có vấn đề |

**Synonyms | 동의어 | Từ đồng nghĩa:**
- 🇰🇷: 근무, 출퇴근, 시프트, 근태, 출근기록
- 🇺🇸: shift, attendance, work record, schedule
- 🇻🇳: ca làm, chấm công, lịch làm việc

---

### 💵 User Salary | 직원급여 | Lương nhân viên

| Property | Description |
|----------|-------------|
| **Table** | `user_salaries` |
| **🇰🇷** | 직원별 급여 정보 |
| **🇺🇸** | Employee salary information |
| **🇻🇳** | Thông tin lương nhân viên |
| **Key Columns** | `salary_id`, `user_id`, `company_id`, `salary_amount`, `salary_type` |
| **Row Count** | 360 |

**Salary Types | 급여 유형 | Loại lương:**
| Type | 🇰🇷 | 🇺🇸 | 🇻🇳 |
|------|------|------|------|
| `monthly` | 월급 | Monthly salary | Lương tháng |
| `hourly` | 시급 | Hourly wage | Lương giờ |

---

## 1.4 Cash Management Entities | 현금관리 엔티티 | Thực thể quản lý tiền mặt

### 🏦 Cash Location | 현금보관소 | Vị trí tiền mặt

| Property | Description |
|----------|-------------|
| **Table** | `cash_locations` |
| **🇰🇷** | 현금 보관 장소 (금고, 캐셔, 은행 등) |
| **🇺🇸** | Cash storage location (safe, cashier, bank) |
| **🇻🇳** | Vị trí lưu trữ tiền mặt (két sắt, quầy thu ngân, ngân hàng) |
| **Key Columns** | `cash_location_id`, `company_id`, `store_id`, `location_name`, `location_type` |
| **Row Count** | 186 |

**Location Types | 위치 유형 | Loại vị trí:**
| Type | 🇰🇷 | 🇺🇸 | 🇻🇳 |
|------|------|------|------|
| `SAFE` | 금고 | Safe/Vault | Két sắt |
| `CASHIER` | 캐셔/계산대 | Cashier | Quầy thu ngân |
| `BANK` | 은행 | Bank | Ngân hàng |

---

# 🔗 PART 2: Relationships | 관계 정의 | Định nghĩa quan hệ

## 2.1 Core Relationships Diagram | 핵심 관계도

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   👤 User                                                       │
│     │                                                           │
│     ├──[owns]──────────> 🏢 Company (1:N via owner_id)         │
│     │                        │                                  │
│     ├──[belongs_to]───────>  │  (M:N via user_companies)       │
│     │                        │                                  │
│     ├──[works_at]──────> 🏪 Store (M:N via user_stores)        │
│     │                        │                                  │
│     └──[has_role]──────> 🎭 Role (M:N via user_roles)          │
│                              │                                  │
│                              └── ⚠️ 1:1 with Company            │
│                                                                 │
│   🏢 Company                                                    │
│     │                                                           │
│     ├──[has]──────────> 🏪 Store (1:N)                         │
│     ├──[has]──────────> 🎭 Role (1:1, unique per company)      │
│     ├──[has]──────────> 📒 JournalEntry (1:N)                  │
│     ├──[has]──────────> 💰 Account (1:N)                       │
│     └──[has]──────────> 👥 Counterparty (1:N)                  │
│                                                                 │
│   📒 JournalEntry                                               │
│     │                                                           │
│     └──[has]──────────> 📝 JournalLine (1:N)                   │
│                              │                                  │
│                              └──[uses]──> 💰 Account (N:1)     │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## 2.2 Relationship Details | 관계 상세 | Chi tiết quan hệ

| Relationship | Type | Join Path |
|--------------|------|-----------|
| User ↔ Company | M:N | `user_companies` |
| User ↔ Store | M:N | `user_stores` |
| User ↔ Role | M:N | `user_roles` |
| **Company ↔ Role** | **1:1** | `roles.company_id` ⚠️ |
| Company → Store | 1:N | `stores.company_id` |
| JournalEntry → JournalLine | 1:N | `journal_lines.journal_id` |
| JournalLine → Account | N:1 | `journal_lines.account_id` |

---

# 📖 PART 3: Business Dictionary | 비즈니스 용어 사전 | Từ điển kinh doanh

## 3.1 Financial Terms | 재무 용어 | Thuật ngữ tài chính

### 💵 Revenue | 매출 | Doanh thu

| Language | Terms |
|----------|-------|
| 🇰🇷 | 매출, 수익, 판매, 매출액, 판매액, 수입 |
| 🇺🇸 | revenue, sales, income, earnings, turnover |
| 🇻🇳 | doanh thu, doanh số, thu nhập |

**SQL Pattern:**
```sql
SELECT SUM(jl.credit) as revenue
FROM journal_lines jl
JOIN accounts a ON jl.account_id = a.account_id
JOIN journal_entries je ON jl.journal_id = je.journal_id
WHERE a.account_type = 'income'
  AND je.company_id = $company_id
  AND je.is_deleted = false
```

---

### 💸 Expense | 비용 | Chi phí

| Language | Terms |
|----------|-------|
| 🇰🇷 | 비용, 지출, 경비, 원가, 지출액 |
| 🇺🇸 | expense, cost, spending, expenditure |
| 🇻🇳 | chi phí, phí tổn, tiền chi |

**SQL Pattern:**
```sql
SELECT SUM(jl.debit) as expense
FROM journal_lines jl
JOIN accounts a ON jl.account_id = a.account_id
JOIN journal_entries je ON jl.journal_id = je.journal_id
WHERE a.account_type = 'expense'
  AND je.company_id = $company_id
  AND je.is_deleted = false
```

---

### 📈 Profit | 이익 | Lợi nhuận

| Language | Terms |
|----------|-------|
| 🇰🇷 | 이익, 순이익, 마진, 영업이익 |
| 🇺🇸 | profit, net income, margin |
| 🇻🇳 | lợi nhuận, lãi, thu nhập ròng |

**Formula:** `Revenue - Expense = Profit`

---

### 💳 Receivable | 미수금 | Phải thu

| Language | Terms |
|----------|-------|
| 🇰🇷 | 미수금, 받을 돈, 외상매출, 채권 |
| 🇺🇸 | receivable, accounts receivable, owed to us |
| 🇻🇳 | phải thu, tiền phải thu, công nợ phải thu |

**SQL Pattern:**
```sql
SELECT SUM(remaining_amount) as receivable
FROM debts_receivable
WHERE direction = 'receivable'
  AND company_id = $company_id
  AND is_active = true
```

---

### 💳 Payable | 미지급금 | Phải trả

| Language | Terms |
|----------|-------|
| 🇰🇷 | 미지급금, 줄 돈, 외상매입, 채무 |
| 🇺🇸 | payable, accounts payable, we owe |
| 🇻🇳 | phải trả, tiền phải trả, công nợ phải trả |

**SQL Pattern:**
```sql
SELECT SUM(remaining_amount) as payable
FROM debts_receivable
WHERE direction = 'payable'
  AND company_id = $company_id
  AND is_active = true
```

---

## 3.2 HR Terms | 인사 용어 | Thuật ngữ nhân sự

### ⏰ Late Arrival | 지각 | Đi muộn

| Language | Terms |
|----------|-------|
| 🇰🇷 | 지각, 늦음, 지각자, 늦게 출근 |
| 🇺🇸 | late, tardy, late arrival |
| 🇻🇳 | đi muộn, trễ, đến muộn |

**SQL Pattern:**
```sql
SELECT user_id, COUNT(*) as late_count
FROM shift_requests
WHERE is_late = true
  AND store_id IN (SELECT store_id FROM stores WHERE company_id = $company_id)
GROUP BY user_id
ORDER BY late_count DESC
```

---

### ⏱️ Overtime | 초과근무 | Làm thêm giờ

| Language | Terms |
|----------|-------|
| 🇰🇷 | 초과근무, OT, 오버타임, 잔업, 야근 |
| 🇺🇸 | overtime, OT, extra hours |
| 🇻🇳 | làm thêm giờ, OT, tăng ca |

**SQL Pattern:**
```sql
SELECT user_id, SUM(overtime_amount) as total_ot
FROM shift_requests
WHERE is_extratime = true
  AND store_id IN (SELECT store_id FROM stores WHERE company_id = $company_id)
GROUP BY user_id
```

---

### 💰 Salary | 급여 | Lương

| Language | Terms |
|----------|-------|
| 🇰🇷 | 급여, 월급, 인건비, 임금 |
| 🇺🇸 | salary, payroll, wage, pay |
| 🇻🇳 | lương, tiền lương, chi phí nhân công |

---

## 3.3 Time Expressions | 시간 표현 | Biểu thức thời gian

| Concept | 🇰🇷 | 🇺🇸 | 🇻🇳 |
|---------|------|------|------|
| Today | 오늘, 금일 | today | hôm nay |
| Yesterday | 어제 | yesterday | hôm qua |
| This week | 이번 주, 금주 | this week | tuần này |
| Last week | 지난 주 | last week | tuần trước |
| This month | 이번 달, 금월 | this month | tháng này |
| Last month | 지난 달 | last month | tháng trước |
| This year | 올해 | this year | năm nay |
| Last year | 작년 | last year | năm ngoái |

---

# 🔧 PART 4: SQL Patterns | SQL 패턴 | Mẫu SQL

## 4.1 Monthly Revenue by Store

```sql
SELECT
    s.store_name,
    DATE_TRUNC('month', je.entry_date) as month,
    SUM(jl.credit) as revenue
FROM journal_entries je
JOIN journal_lines jl ON je.journal_id = jl.journal_id
JOIN accounts a ON jl.account_id = a.account_id
JOIN stores s ON je.store_id = s.store_id
WHERE a.account_type = 'income'
  AND je.company_id = $company_id
  AND je.is_deleted = false
GROUP BY s.store_name, DATE_TRUNC('month', je.entry_date)
ORDER BY month DESC, revenue DESC
```

## 4.2 Employee Late Count

```sql
SELECT
    u.first_name || ' ' || u.last_name as employee_name,
    COUNT(*) as late_count
FROM shift_requests sr
JOIN users u ON sr.user_id = u.user_id
JOIN stores s ON sr.store_id = s.store_id
WHERE sr.is_late = true
  AND s.company_id = $company_id
GROUP BY u.user_id, u.first_name, u.last_name
ORDER BY late_count DESC
```

## 4.3 Required Filters | 필수 필터

| Filter | Reason |
|--------|--------|
| `company_id = $company_id` | 모든 쿼리에 회사 필터 필수 |
| `is_deleted = false` | 삭제된 데이터 제외 |
| `is_active = true` | 활성 데이터만 조회 |

---

# ⚠️ PART 5: Constraints | 제약조건

## 5.1 Business Rules

1. **Journal Balance**: SUM(debit) = SUM(credit) per journal_entry
2. **Role-Company 1:1**: Each company has unique role set
3. **Store-Company**: Store belongs to exactly one company

## 5.2 Valid JOIN Paths

```
✅ Valid:
journal_entries → journal_lines (journal_id)
journal_lines → accounts (account_id)
stores → companies (company_id)
shift_requests → users (user_id)
users → user_companies → companies

❌ Invalid:
users → journal_entries (직접 연결 금지)
roles → stores (관계 없음)
```

---

# 🎯 PART 6: Sample Questions | 예시 질문

| 🇰🇷 | 🇺🇸 | 🇻🇳 |
|------|------|------|
| 이번 달 매출 얼마야? | What's this month's revenue? | Doanh thu tháng này? |
| 지각 많이 한 직원 누구야? | Who has most late arrivals? | Ai đi muộn nhiều nhất? |
| 매장별 매출 비교해줘 | Compare revenue by store | So sánh doanh thu theo cửa hàng |
| 순이익이 얼마야? | What's the net profit? | Lợi nhuận ròng là bao nhiêu? |
| 이번 달 OT 현황 | This month's overtime status | Tình trạng OT tháng này |
| 금고에 현금 얼마? | Cash in safe? | Tiền trong két sắt? |
| 미수금 현황 | Receivables status | Tình trạng công nợ phải thu |

---

# 📝 PART 7: AI System Prompt

```
You are a financial data analysis AI for MyFinance app.

## Database Structure
- users: App users (288 rows)
- companies: Business entities (236 rows)
- stores: Branches (178 rows) - belongs to company
- roles: User roles (470 rows) - 1:1 with company
- journal_entries: Transactions (4,626 rows)
- journal_lines: Transaction details (9,896 rows)
- accounts: Chart of accounts (56 rows)
- shift_requests: Attendance records (5,635 rows)

## Key Rules
- Revenue = SUM(credit) WHERE account_type = 'income'
- Expense = SUM(debit) WHERE account_type = 'expense'
- Always filter by company_id
- Role is 1:1 with Company

## Languages
Respond in user's language: Korean, English, Vietnamese
```

---

# 🗂️ PART 8: Existing Metadata | 기존 메타데이터 | Metadata hiện có

## 8.1 table_metadata Table | 테이블 메타데이터

**⭐ 이미 데이터베이스에 풍부한 메타데이터가 존재합니다!**

| Column | 🇰🇷 | 🇺🇸 | 🇻🇳 |
|--------|------|------|------|
| `table_name` | 테이블명 | Table name | Tên bảng |
| `column_name` | 컬럼명 | Column name | Tên cột |
| `meaning` | 컬럼 의미 | Column meaning | Ý nghĩa cột |
| `calculation_formula` | 계산 공식 | Calculation formula | Công thức tính |
| `normal_range` | 정상 범위 | Normal range | Phạm vi bình thường |
| `business_rules` | 비즈니스 규칙 | Business rules | Quy tắc kinh doanh |
| `fraud_detection_rules` | 부정탐지 규칙 | Fraud detection rules | Quy tắc phát hiện gian lận |
| `severity` | 심각도 | Severity | Mức độ nghiêm trọng |

### 메타데이터가 정의된 테이블들:
- `accounts` - 계정과목 (account_code, account_type, normal_balance 등)
- `bank_amount` - 은행 잔액
- `cash_amount_entries` - 현금 입출금
- `cash_amount_stock_flow` - 현금 재고 흐름
- `cash_control` - 현금 관리
- `cashier_amount_lines` - 캐셔 금액 내역
- `cash_locations` - 현금 보관소
- `journal_entries` - 거래기록
- `journal_lines` - 거래상세
- `currency_denominations` - 화폐 단위
- `company_financial_metrics` - 회사 재무지표
- `store_financial_metrics` - 매장 재무지표
- `vault_amount_line` - 금고 금액 내역

### 메타데이터 활용 예시:

```sql
-- 특정 테이블의 모든 컬럼 의미 조회
SELECT column_name, meaning, business_rules
FROM table_metadata
WHERE table_name = 'accounts';

-- 부정탐지 규칙이 있는 컬럼 조회
SELECT table_name, column_name, fraud_detection_rules
FROM table_metadata
WHERE fraud_detection_rules IS NOT NULL;
```

---

# 🔗 PART 9: Complete FK Relationships | 전체 FK 관계 | Quan hệ FK đầy đủ

## 9.1 Core Entity Relationships | 핵심 엔티티 관계

```
                    ┌────────────────┐
                    │     users      │
                    │   (288 rows)   │
                    └───────┬────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
        ▼                   ▼                   ▼
┌───────────────┐   ┌───────────────┐   ┌───────────────┐
│ user_companies│   │  user_stores  │   │  user_roles   │
│     (M:N)     │   │     (M:N)     │   │     (M:N)     │
└───────┬───────┘   └───────┬───────┘   └───────┬───────┘
        │                   │                   │
        ▼                   ▼                   ▼
┌───────────────┐   ┌───────────────┐   ┌───────────────┐
│   companies   │◄──│    stores     │   │    roles      │
│  (236 rows)   │   │  (178 rows)   │   │  (470 rows)   │
└───────────────┘   └───────────────┘   └───────┬───────┘
        │                                       │
        └───────────────────────────────────────┘
                     (1:1 관계 ⚠️)
```

## 9.2 All Foreign Key Relationships | 전체 FK 관계

### Users & Access Control | 사용자 및 접근제어
| From Table | From Column | To Table | To Column |
|------------|-------------|----------|-----------|
| `users` | `current_subscription_id` | `user_subscriptions` | `subscription_id` |
| `users` | `user_language` | `languages` | `language_id` |
| `user_roles` | `user_id` | `users` | `user_id` |
| `user_roles` | `role_id` | `roles` | `role_id` |
| `user_companies` | `user_id` | `users` | `user_id` |
| `user_companies` | `company_id` | `companies` | `company_id` |
| `user_stores` | `user_id` | `users` | `user_id` |
| `user_stores` | `store_id` | `stores` | `store_id` |

### Companies & Stores | 회사 및 매장
| From Table | From Column | To Table | To Column |
|------------|-------------|----------|-----------|
| `companies` | `owner_id` | `users` | `user_id` |
| `companies` | `base_currency_id` | `currency_types` | `currency_id` |
| `companies` | `company_type_id` | `company_types` | `company_type_id` |
| `stores` | `company_id` | `companies` | `company_id` |
| `roles` | `company_id` | `companies` | `company_id` |
| `roles` | `parent_role_id` | `roles` | `role_id` |

### Journal & Accounting | 분개 및 회계
| From Table | From Column | To Table | To Column |
|------------|-------------|----------|-----------|
| `journal_entries` | `company_id` | `companies` | `company_id` |
| `journal_entries` | `store_id` | `stores` | `store_id` |
| `journal_entries` | `created_by` | `users` | `user_id` |
| `journal_entries` | `approved_by` | `users` | `user_id` |
| `journal_entries` | `counterparty_id` | `counterparties` | `counterparty_id` |
| `journal_entries` | `currency_id` | `currency_types` | `currency_id` |
| `journal_entries` | `period_id` | `fiscal_periods` | `period_id` |
| `journal_lines` | `journal_id` | `journal_entries` | `journal_id` |
| `journal_lines` | `account_id` | `accounts` | `account_id` |
| `journal_lines` | `store_id` | `stores` | `store_id` |
| `journal_lines` | `counterparty_id` | `counterparties` | `counterparty_id` |
| `journal_lines` | `cash_location_id` | `cash_locations` | `cash_location_id` |
| `accounts` | `company_id` | `companies` | `company_id` |

### Cash Management | 현금 관리
| From Table | From Column | To Table | To Column |
|------------|-------------|----------|-----------|
| `cash_locations` | `company_id` | `companies` | `company_id` |
| `cash_locations` | `store_id` | `stores` | `store_id` |
| `cash_locations` | `currency_id` | `currency_types` | `currency_id` |
| `cash_control` | `location_id` | `cash_locations` | `cash_location_id` |
| `cash_control` | `store_id` | `stores` | `store_id` |
| `cash_control` | `company_id` | `companies` | `company_id` |
| `cashier_amount_lines` | `location_id` | `cash_locations` | `cash_location_id` |
| `cashier_amount_lines` | `denomination_id` | `currency_denominations` | `denomination_id` |
| `bank_amount` | `location_id` | `cash_locations` | `cash_location_id` |
| `vault_amount_line` | `location_id` | `cash_locations` | `cash_location_id` |

### Shift & HR | 근무 및 인사
| From Table | From Column | To Table | To Column |
|------------|-------------|----------|-----------|
| `shift_requests` | `user_id` | `users` | `user_id` |
| `shift_requests` | `store_id` | `stores` | `store_id` |
| `shift_requests` | `shift_id` | `store_shifts` | `shift_id` |
| `shift_requests` | `approved_by` | `users` | `user_id` |
| `store_shifts` | `store_id` | `stores` | `store_id` |
| `user_salaries` | `user_id` | `users` | `user_id` |
| `user_salaries` | `company_id` | `companies` | `company_id` |
| `user_salaries` | `account_id` | `accounts` | `account_id` |

### Debts & Receivables | 채권채무
| From Table | From Column | To Table | To Column |
|------------|-------------|----------|-----------|
| `debts_receivable` | `company_id` | `companies` | `company_id` |
| `debts_receivable` | `counterparty_id` | `counterparties` | `counterparty_id` |
| `debts_receivable` | `account_id` | `accounts` | `account_id` |
| `debts_receivable` | `store_id` | `stores` | `store_id` |
| `debt_payments` | `debt_id` | `debts_receivable` | `debt_id` |
| `debt_payments` | `journal_id` | `journal_entries` | `journal_id` |

### Fixed Assets | 고정자산
| From Table | From Column | To Table | To Column |
|------------|-------------|----------|-----------|
| `fixed_assets` | `company_id` | `companies` | `company_id` |
| `fixed_assets` | `store_id` | `stores` | `store_id` |
| `fixed_assets` | `account_id` | `accounts` | `account_id` |
| `fixed_assets` | `depreciation_method_id` | `depreciation_methods` | `method_id` |

### Inventory | 재고관리
| From Table | From Column | To Table | To Column |
|------------|-------------|----------|-----------|
| `inventory_products` | `company_id` | `companies` | `company_id` |
| `inventory_products` | `category_id` | `inventory_product_categories` | `category_id` |
| `inventory_products` | `brand_id` | `inventory_brands` | `brand_id` |
| `inventory_current_stock` | `product_id` | `inventory_products` | `product_id` |
| `inventory_current_stock` | `store_id` | `stores` | `store_id` |
| `inventory_invoice` | `store_id` | `stores` | `store_id` |
| `inventory_invoice` | `customer_id` | `counterparties` | `counterparty_id` |
| `inventory_flow` | `product_id` | `inventory_products` | `product_id` |

---

## 9.3 Recommended JOIN Paths | 권장 JOIN 경로

### 매출 조회 (Revenue Query)
```sql
journal_entries je
  → journal_lines jl (ON je.journal_id = jl.journal_id)
  → accounts a (ON jl.account_id = a.account_id)
  → stores s (ON je.store_id = s.store_id)
```

### 직원 근무 조회 (Employee Shift Query)
```sql
shift_requests sr
  → users u (ON sr.user_id = u.user_id)
  → stores s (ON sr.store_id = s.store_id)
  → companies c (ON s.company_id = c.company_id)
```

### 현금 잔액 조회 (Cash Balance Query)
```sql
cash_locations cl
  → cash_control cc (ON cl.cash_location_id = cc.location_id)
  → cashier_amount_lines cal (ON cl.cash_location_id = cal.location_id)
  → stores s (ON cl.store_id = s.store_id)
```

### 재고 조회 (Inventory Query)
```sql
inventory_products ip
  → inventory_current_stock ics (ON ip.product_id = ics.product_id)
  → stores s (ON ics.store_id = s.store_id)
  → inventory_flow if (ON ip.product_id = if.product_id)
```

---

**Last Updated**: 2024-12
