# Financial Statements RPC API Specification

> **Version**: 1.0
> **Created**: 2025-12-23
> **Database**: Supabase (atkekzwgukdvucqntryo)

---

## Overview

재무제표 조회를 위한 4개의 RPC 함수입니다. 모든 함수는 `account_code` 기반으로 계정을 분류하며, 회사/가게/기간별 필터링을 지원합니다.

### Account Code 체계

| Code Range | Category | 정상잔액 | 계산 방식 |
|------------|----------|----------|-----------|
| 1000-1499 | Current Assets (유동자산) | 차변 | debit - credit |
| 1500-1999 | Non-Current Assets (비유동자산) | 차변 | debit - credit |
| 2000-2499 | Current Liabilities (유동부채) | 대변 | credit - debit |
| 2500-2999 | Non-Current Liabilities (비유동부채) | 대변 | credit - debit |
| 3000-3999 | Equity (자본) | 대변 | credit - debit |
| 4000-4999 | Revenue (수익) | 대변 | credit - debit |
| 5000-5999 | COGS (매출원가) | 차변 | debit - credit |
| 6000-7999 | Operating Expense (판관비) | 차변 | debit - credit |
| 8000-8999 | Non-Operating (영업외) | 차변 | debit - credit |
| 9000-9999 | OCI/Tax/Error (기타) | - | 제외됨 |

---

## 1. get_pnl()

### 손익계산서 요약 (Income Statement Summary)

특정 기간의 손익을 요약하여 반환합니다. 이전 기간과의 비교가 가능합니다.

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `p_company_id` | UUID | ✅ Yes | - | 회사 ID |
| `p_start_date` | DATE | ✅ Yes | - | 조회 시작일 (YYYY-MM-DD) |
| `p_end_date` | DATE | ✅ Yes | - | 조회 종료일 (YYYY-MM-DD) |
| `p_store_id` | UUID | No | NULL | 가게 ID (NULL = 전체 가게) |
| `p_prev_start_date` | DATE | No | NULL | 비교 기간 시작일 |
| `p_prev_end_date` | DATE | No | NULL | 비교 기간 종료일 |

### Response Schema

```typescript
interface PnlResponse {
  // 현재 기간 금액
  revenue: number;              // 매출 (4xxx)
  cogs: number;                 // 매출원가 (5xxx)
  gross_profit: number;         // 매출총이익 (revenue - cogs)
  operating_expense: number;    // 판관비 (6xxx-7xxx)
  operating_income: number;     // 영업이익 (gross_profit - operating_expense)
  non_operating_expense: number; // 영업외비용 (8xxx)
  net_income: number;           // 순이익 (operating_income - non_operating_expense)

  // 마진율 (%)
  gross_margin: number;         // 매출총이익률
  operating_margin: number;     // 영업이익률
  net_margin: number;           // 순이익률

  // 이전 기간 (비교용, nullable)
  prev_revenue: number | null;
  prev_net_income: number | null;

  // 변화율 (%, nullable)
  revenue_change_pct: number | null;
  net_income_change_pct: number | null;
}
```

### SQL Example

```sql
-- 기본 조회 (비교 없음)
SELECT * FROM get_pnl(
    'ebd66ba7-fde7-4332-b6b5-0d8a7f615497',  -- company_id
    '2025-12-01',                             -- start_date
    '2025-12-23'                              -- end_date
);

-- 특정 가게 + 이전 기간 비교
SELECT * FROM get_pnl(
    'ebd66ba7-fde7-4332-b6b5-0d8a7f615497',
    '2025-12-01',
    '2025-12-23',
    'b895965a-cfc5-4b69-9313-e3c746f67200',  -- store_id (Cameraon Nha Trang)
    '2025-11-01',                             -- prev_start_date
    '2025-11-30'                              -- prev_end_date
);
```

### Flutter/Dart Example

```dart
// Service class
class FinancialStatementService {
  final SupabaseClient _supabase;

  FinancialStatementService(this._supabase);

  /// 손익계산서 요약 조회
  Future<PnlSummary> getPnl({
    required String companyId,
    required DateTime startDate,
    required DateTime endDate,
    String? storeId,
    DateTime? prevStartDate,
    DateTime? prevEndDate,
  }) async {
    final response = await _supabase.rpc('get_pnl', params: {
      'p_company_id': companyId,
      'p_start_date': startDate.toIso8601String().split('T')[0],
      'p_end_date': endDate.toIso8601String().split('T')[0],
      if (storeId != null) 'p_store_id': storeId,
      if (prevStartDate != null)
        'p_prev_start_date': prevStartDate.toIso8601String().split('T')[0],
      if (prevEndDate != null)
        'p_prev_end_date': prevEndDate.toIso8601String().split('T')[0],
    });

    if (response is List && response.isNotEmpty) {
      return PnlSummary.fromJson(response.first);
    }
    throw Exception('No data returned');
  }
}

// Model class
class PnlSummary {
  final double revenue;
  final double cogs;
  final double grossProfit;
  final double operatingExpense;
  final double operatingIncome;
  final double nonOperatingExpense;
  final double netIncome;
  final double grossMargin;
  final double operatingMargin;
  final double netMargin;
  final double? prevRevenue;
  final double? prevNetIncome;
  final double? revenueChangePct;
  final double? netIncomeChangePct;

  PnlSummary({
    required this.revenue,
    required this.cogs,
    required this.grossProfit,
    required this.operatingExpense,
    required this.operatingIncome,
    required this.nonOperatingExpense,
    required this.netIncome,
    required this.grossMargin,
    required this.operatingMargin,
    required this.netMargin,
    this.prevRevenue,
    this.prevNetIncome,
    this.revenueChangePct,
    this.netIncomeChangePct,
  });

  factory PnlSummary.fromJson(Map<String, dynamic> json) {
    return PnlSummary(
      revenue: _toDouble(json['revenue']),
      cogs: _toDouble(json['cogs']),
      grossProfit: _toDouble(json['gross_profit']),
      operatingExpense: _toDouble(json['operating_expense']),
      operatingIncome: _toDouble(json['operating_income']),
      nonOperatingExpense: _toDouble(json['non_operating_expense']),
      netIncome: _toDouble(json['net_income']),
      grossMargin: _toDouble(json['gross_margin']),
      operatingMargin: _toDouble(json['operating_margin']),
      netMargin: _toDouble(json['net_margin']),
      prevRevenue: json['prev_revenue'] != null
          ? _toDouble(json['prev_revenue']) : null,
      prevNetIncome: json['prev_net_income'] != null
          ? _toDouble(json['prev_net_income']) : null,
      revenueChangePct: json['revenue_change_pct'] != null
          ? _toDouble(json['revenue_change_pct']) : null,
      netIncomeChangePct: json['net_income_change_pct'] != null
          ? _toDouble(json['net_income_change_pct']) : null,
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
```

### Sample Response

```json
{
  "revenue": 437700000.00,
  "cogs": 24713000.00,
  "gross_profit": 412987000.00,
  "operating_expense": 236959263.00,
  "operating_income": 176027737.00,
  "non_operating_expense": 0,
  "net_income": 176027737.00,
  "gross_margin": 94.35,
  "operating_margin": 40.22,
  "net_margin": 40.22,
  "prev_revenue": 436760000.00,
  "prev_net_income": -219794119.00,
  "revenue_change_pct": 0.2,
  "net_income_change_pct": 180.1
}
```

---

## 2. get_pnl_detail()

### 손익계산서 상세 (Income Statement Detail)

계정과목별 상세 손익 내역을 반환합니다.

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `p_company_id` | UUID | ✅ Yes | - | 회사 ID |
| `p_start_date` | DATE | ✅ Yes | - | 조회 시작일 |
| `p_end_date` | DATE | ✅ Yes | - | 조회 종료일 |
| `p_store_id` | UUID | No | NULL | 가게 ID |

### Response Schema

```typescript
interface PnlDetailRow {
  section: 'Revenue' | 'COGS' | 'Operating Expense' | 'Non-Operating' | 'Other';
  section_order: number;      // 정렬 순서 (1-5)
  account_code: string;       // 계정코드 (예: "4100")
  account_name: string;       // 계정명 (예: "Sales Revenue")
  amount: number;             // 금액 (양수 = 비용증가/수익, 음수 = 감소)
}
```

### SQL Example

```sql
SELECT * FROM get_pnl_detail(
    'ebd66ba7-fde7-4332-b6b5-0d8a7f615497',
    '2025-12-01',
    '2025-12-23'
)
ORDER BY section_order, account_code;
```

### Flutter/Dart Example

```dart
Future<List<PnlDetailRow>> getPnlDetail({
  required String companyId,
  required DateTime startDate,
  required DateTime endDate,
  String? storeId,
}) async {
  final response = await _supabase.rpc('get_pnl_detail', params: {
    'p_company_id': companyId,
    'p_start_date': startDate.toIso8601String().split('T')[0],
    'p_end_date': endDate.toIso8601String().split('T')[0],
    if (storeId != null) 'p_store_id': storeId,
  });

  return (response as List)
      .map((row) => PnlDetailRow.fromJson(row))
      .toList();
}

class PnlDetailRow {
  final String section;
  final int sectionOrder;
  final String accountCode;
  final String accountName;
  final double amount;

  PnlDetailRow({
    required this.section,
    required this.sectionOrder,
    required this.accountCode,
    required this.accountName,
    required this.amount,
  });

  factory PnlDetailRow.fromJson(Map<String, dynamic> json) {
    return PnlDetailRow(
      section: json['section'] ?? '',
      sectionOrder: json['section_order'] ?? 0,
      accountCode: json['account_code'] ?? '',
      accountName: json['account_name'] ?? '',
      amount: _toDouble(json['amount']),
    );
  }
}
```

### Sample Response

```json
[
  {
    "section": "Revenue",
    "section_order": 1,
    "account_code": "4100",
    "account_name": "Sales Revenue",
    "amount": 437700000.00
  },
  {
    "section": "COGS",
    "section_order": 2,
    "account_code": "5100",
    "account_name": "Cost of Goods Sold",
    "amount": 24713000.00
  },
  {
    "section": "Operating Expense",
    "section_order": 3,
    "account_code": "6100",
    "account_name": "Salaries & Wages",
    "amount": 120000000.00
  },
  {
    "section": "Operating Expense",
    "section_order": 3,
    "account_code": "6200",
    "account_name": "Rent Expense",
    "amount": 45000000.00
  }
]
```

---

## 3. get_bs()

### 재무상태표 요약 (Balance Sheet Summary)

특정 시점의 재무상태를 요약하여 반환합니다.

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `p_company_id` | UUID | ✅ Yes | - | 회사 ID |
| `p_as_of_date` | DATE | ✅ Yes | - | 기준일 (해당일까지의 누적) |
| `p_store_id` | UUID | No | NULL | 가게 ID |
| `p_compare_date` | DATE | No | NULL | 비교 기준일 |

### Response Schema

```typescript
interface BsSummary {
  // 현재 시점
  total_assets: number;           // 자산총계
  current_assets: number;         // 유동자산 (1000-1499)
  non_current_assets: number;     // 비유동자산 (1500-1999)
  total_liabilities: number;      // 부채총계
  current_liabilities: number;    // 유동부채 (2000-2499)
  non_current_liabilities: number; // 비유동부채 (2500-2999)
  total_equity: number;           // 자본총계 (3000-3999)

  // 검증
  balance_check: number;          // Assets - Liabilities - Equity (0이면 정상)

  // 비교 (nullable)
  prev_total_assets: number | null;
  prev_total_equity: number | null;
  assets_change_pct: number | null;
  equity_change_pct: number | null;
}
```

### ⚠️ balance_check 필드 설명

`balance_check`는 회계등식 검증용입니다:
- **0**: 정상 (자산 = 부채 + 자본)
- **양수/음수**: 미마감 당기순손익이 포함됨

> 손익계정이 마감되어 이익잉여금으로 대체되면 0이 됩니다.

### SQL Example

```sql
-- 기본 조회
SELECT * FROM get_bs(
    'ebd66ba7-fde7-4332-b6b5-0d8a7f615497',
    '2025-12-23'
);

-- 전월말 대비 비교
SELECT * FROM get_bs(
    'ebd66ba7-fde7-4332-b6b5-0d8a7f615497',
    '2025-12-23',
    NULL,             -- store_id
    '2025-11-30'      -- compare_date
);
```

### Flutter/Dart Example

```dart
Future<BsSummary> getBalanceSheet({
  required String companyId,
  required DateTime asOfDate,
  String? storeId,
  DateTime? compareDate,
}) async {
  final response = await _supabase.rpc('get_bs', params: {
    'p_company_id': companyId,
    'p_as_of_date': asOfDate.toIso8601String().split('T')[0],
    if (storeId != null) 'p_store_id': storeId,
    if (compareDate != null)
      'p_compare_date': compareDate.toIso8601String().split('T')[0],
  });

  if (response is List && response.isNotEmpty) {
    return BsSummary.fromJson(response.first);
  }
  throw Exception('No data returned');
}

class BsSummary {
  final double totalAssets;
  final double currentAssets;
  final double nonCurrentAssets;
  final double totalLiabilities;
  final double currentLiabilities;
  final double nonCurrentLiabilities;
  final double totalEquity;
  final double balanceCheck;
  final double? prevTotalAssets;
  final double? prevTotalEquity;
  final double? assetsChangePct;
  final double? equityChangePct;

  BsSummary({
    required this.totalAssets,
    required this.currentAssets,
    required this.nonCurrentAssets,
    required this.totalLiabilities,
    required this.currentLiabilities,
    required this.nonCurrentLiabilities,
    required this.totalEquity,
    required this.balanceCheck,
    this.prevTotalAssets,
    this.prevTotalEquity,
    this.assetsChangePct,
    this.equityChangePct,
  });

  factory BsSummary.fromJson(Map<String, dynamic> json) {
    return BsSummary(
      totalAssets: _toDouble(json['total_assets']),
      currentAssets: _toDouble(json['current_assets']),
      nonCurrentAssets: _toDouble(json['non_current_assets']),
      totalLiabilities: _toDouble(json['total_liabilities']),
      currentLiabilities: _toDouble(json['current_liabilities']),
      nonCurrentLiabilities: _toDouble(json['non_current_liabilities']),
      totalEquity: _toDouble(json['total_equity']),
      balanceCheck: _toDouble(json['balance_check']),
      prevTotalAssets: json['prev_total_assets'] != null
          ? _toDouble(json['prev_total_assets']) : null,
      prevTotalEquity: json['prev_total_equity'] != null
          ? _toDouble(json['prev_total_equity']) : null,
      assetsChangePct: json['assets_change_pct'] != null
          ? _toDouble(json['assets_change_pct']) : null,
      equityChangePct: json['equity_change_pct'] != null
          ? _toDouble(json['equity_change_pct']) : null,
    );
  }

  /// 회계등식 검증 여부
  bool get isBalanced => balanceCheck.abs() < 0.01;
}
```

### Sample Response

```json
{
  "total_assets": 9784467356.00,
  "current_assets": 6539105017.00,
  "non_current_assets": 3245362339.00,
  "total_liabilities": 4814901132.00,
  "current_liabilities": 4814901132.00,
  "non_current_liabilities": 0,
  "total_equity": 3861525596.00,
  "balance_check": 1108040628.00,
  "prev_total_assets": 11917659825.00,
  "prev_total_equity": 3861525596.00,
  "assets_change_pct": -17.9,
  "equity_change_pct": 0.0
}
```

---

## 4. get_bs_detail()

### 재무상태표 상세 (Balance Sheet Detail)

계정과목별 상세 잔액을 반환합니다.

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `p_company_id` | UUID | ✅ Yes | - | 회사 ID |
| `p_as_of_date` | DATE | ✅ Yes | - | 기준일 |
| `p_store_id` | UUID | No | NULL | 가게 ID |

### Response Schema

```typescript
interface BsDetailRow {
  section: 'Current Assets' | 'Non-Current Assets' |
           'Current Liabilities' | 'Non-Current Liabilities' | 'Equity';
  section_order: number;      // 정렬 순서 (1-5)
  account_code: string;       // 계정코드
  account_name: string;       // 계정명
  balance: number;            // 잔액 (양수 = 정상잔액 방향)
}
```

### SQL Example

```sql
SELECT * FROM get_bs_detail(
    'ebd66ba7-fde7-4332-b6b5-0d8a7f615497',
    '2025-12-23'
)
ORDER BY section_order, account_code;
```

### Flutter/Dart Example

```dart
Future<List<BsDetailRow>> getBalanceSheetDetail({
  required String companyId,
  required DateTime asOfDate,
  String? storeId,
}) async {
  final response = await _supabase.rpc('get_bs_detail', params: {
    'p_company_id': companyId,
    'p_as_of_date': asOfDate.toIso8601String().split('T')[0],
    if (storeId != null) 'p_store_id': storeId,
  });

  return (response as List)
      .map((row) => BsDetailRow.fromJson(row))
      .toList();
}

class BsDetailRow {
  final String section;
  final int sectionOrder;
  final String accountCode;
  final String accountName;
  final double balance;

  BsDetailRow({
    required this.section,
    required this.sectionOrder,
    required this.accountCode,
    required this.accountName,
    required this.balance,
  });

  factory BsDetailRow.fromJson(Map<String, dynamic> json) {
    return BsDetailRow(
      section: json['section'] ?? '',
      sectionOrder: json['section_order'] ?? 0,
      accountCode: json['account_code'] ?? '',
      accountName: json['account_name'] ?? '',
      balance: _toDouble(json['balance']),
    );
  }
}
```

### Sample Response

```json
[
  {
    "section": "Current Assets",
    "section_order": 1,
    "account_code": "1000",
    "account_name": "Cash",
    "balance": 1119061454.00
  },
  {
    "section": "Current Assets",
    "section_order": 1,
    "account_code": "1110",
    "account_name": "Note Receivable",
    "balance": 4386046098.00
  },
  {
    "section": "Non-Current Assets",
    "section_order": 2,
    "account_code": "1520",
    "account_name": "Interior",
    "balance": 1313139329.00
  },
  {
    "section": "Current Liabilities",
    "section_order": 3,
    "account_code": "2010",
    "account_name": "Notes Payable",
    "balance": 4814901132.00
  },
  {
    "section": "Equity",
    "section_order": 5,
    "account_code": "3010",
    "account_name": "Owner's Investment",
    "balance": 5097685058.00
  }
]
```

---

## Period Helper (Flutter)

### 기간 계산 유틸리티

```dart
class PeriodHelper {
  /// 기간 키로 날짜 범위 계산
  static DateRange getPeriodDates(String periodKey) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (periodKey) {
      case 'today':
        return DateRange(start: today, end: today);

      case 'yesterday':
        final yesterday = today.subtract(const Duration(days: 1));
        return DateRange(start: yesterday, end: yesterday);

      case 'last_7_days':
        return DateRange(
          start: today.subtract(const Duration(days: 6)),
          end: today,
        );

      case 'this_week':
        // 월요일 시작
        final weekStart = today.subtract(Duration(days: today.weekday - 1));
        return DateRange(start: weekStart, end: today);

      case 'this_month':
        return DateRange(
          start: DateTime(now.year, now.month, 1),
          end: today,
        );

      case 'last_month':
        final lastMonthStart = DateTime(now.year, now.month - 1, 1);
        final lastMonthEnd = DateTime(now.year, now.month, 0);
        return DateRange(start: lastMonthStart, end: lastMonthEnd);

      case 'this_year':
        return DateRange(
          start: DateTime(now.year, 1, 1),
          end: today,
        );

      case 'last_year':
        return DateRange(
          start: DateTime(now.year - 1, 1, 1),
          end: DateTime(now.year - 1, 12, 31),
        );

      default:
        return DateRange(start: today, end: today);
    }
  }

  /// 비교 기간 계산 (동일 길이의 이전 기간)
  static DateRange getPrevPeriodDates(String periodKey) {
    final current = getPeriodDates(periodKey);
    final duration = current.end.difference(current.start);

    return DateRange(
      start: current.start.subtract(duration + const Duration(days: 1)),
      end: current.start.subtract(const Duration(days: 1)),
    );
  }

  /// 지원되는 기간 키 목록
  static const List<String> periodKeys = [
    'today',
    'yesterday',
    'last_7_days',
    'this_week',
    'this_month',
    'last_month',
    'this_year',
    'last_year',
  ];

  /// 기간 키 → 표시 라벨
  static String getPeriodLabel(String periodKey) {
    const labels = {
      'today': 'Today',
      'yesterday': 'Yesterday',
      'last_7_days': 'Last 7 Days',
      'this_week': 'This Week',
      'this_month': 'This Month',
      'last_month': 'Last Month',
      'this_year': 'This Year',
      'last_year': 'Last Year',
    };
    return labels[periodKey] ?? periodKey;
  }
}

class DateRange {
  final DateTime start;
  final DateTime end;

  DateRange({required this.start, required this.end});

  String get startString => start.toIso8601String().split('T')[0];
  String get endString => end.toIso8601String().split('T')[0];
}
```

---

## Complete Usage Example

### Dashboard Widget

```dart
class FinancialDashboard extends StatefulWidget {
  final String companyId;

  const FinancialDashboard({required this.companyId});

  @override
  State<FinancialDashboard> createState() => _FinancialDashboardState();
}

class _FinancialDashboardState extends State<FinancialDashboard> {
  final _service = FinancialStatementService(Supabase.instance.client);

  String _selectedPeriod = 'this_month';
  String? _selectedStoreId;

  PnlSummary? _pnl;
  BsSummary? _bs;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);

    try {
      final period = PeriodHelper.getPeriodDates(_selectedPeriod);
      final prevPeriod = PeriodHelper.getPrevPeriodDates(_selectedPeriod);

      // 손익계산서
      final pnl = await _service.getPnl(
        companyId: widget.companyId,
        startDate: period.start,
        endDate: period.end,
        storeId: _selectedStoreId,
        prevStartDate: prevPeriod.start,
        prevEndDate: prevPeriod.end,
      );

      // 재무상태표 (기간 종료일 기준)
      final bs = await _service.getBalanceSheet(
        companyId: widget.companyId,
        asOfDate: period.end,
        storeId: _selectedStoreId,
        compareDate: prevPeriod.end,
      );

      setState(() {
        _pnl = pnl;
        _bs = bs;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 필터 영역
        Row(
          children: [
            // 기간 선택
            DropdownButton<String>(
              value: _selectedPeriod,
              items: PeriodHelper.periodKeys.map((key) {
                return DropdownMenuItem(
                  value: key,
                  child: Text(PeriodHelper.getPeriodLabel(key)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedPeriod = value!);
                _loadData();
              },
            ),

            // 가게 선택 (별도 구현)
            StoreDropdown(
              companyId: widget.companyId,
              selectedStoreId: _selectedStoreId,
              onChanged: (storeId) {
                setState(() => _selectedStoreId = storeId);
                _loadData();
              },
            ),
          ],
        ),

        // 데이터 표시
        if (_loading)
          const CircularProgressIndicator()
        else if (_pnl != null && _bs != null)
          Column(
            children: [
              // 손익 요약 카드
              PnlSummaryCard(pnl: _pnl!),

              // 재무상태 요약 카드
              BsSummaryCard(bs: _bs!),
            ],
          ),
      ],
    );
  }
}
```

---

## Error Handling

### 예외 처리 권장사항

```dart
try {
  final response = await supabase.rpc('get_pnl', params: {...});
  // ...
} on PostgrestException catch (e) {
  // Supabase/Postgres 에러
  print('Database error: ${e.message}');
  print('Error code: ${e.code}');
} on SocketException catch (e) {
  // 네트워크 에러
  print('Network error: $e');
} catch (e) {
  // 기타 에러
  print('Unknown error: $e');
}
```

### 빈 데이터 처리

```dart
// 응답이 빈 배열일 경우 기본값 반환
if (response is List && response.isEmpty) {
  return PnlSummary.empty(); // 모든 값이 0인 객체
}
```

---

## Performance Notes

1. **인덱스**: `journal_entries.entry_date`, `journal_lines.account_id`에 인덱스 존재
2. **현재 데이터량**: ~11,000 journal_lines → 실시간 계산 충분
3. **권장 임계값**: 100,000 rows 이상 시 materialized view 고려
4. **Store 필터**: `journal_lines.store_id` 인덱스 추가 권장

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-12-23 | Initial release - 4 RPC functions |
