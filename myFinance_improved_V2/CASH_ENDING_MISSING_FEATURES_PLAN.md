# Cash Ending - 누락된 기능 수정 플랜
## 스크린샷 분석 기반 문제 해결

**작성일**: 2025-11-11
**분석 대상**: Cash Tab Real Section
**참고**: cash_location 모듈 (완성된 구현)

---

## 🔍 발견된 문제점

### 문제 1: Journal 탭 누락 🔴 심각
**스크린샷 분석:**
```
현재: [Real] 탭만 존재
기대: [Journal] [Real] 두 탭 존재
```

**원인:**
- `real_section_widget.dart`에 탭 구조가 없음
- 단일 "Real" 헤더만 존재 (Line 146-154)

**파일:**
- `lib/features/cash_ending/presentation/widgets/real_section_widget.dart:146-154`

**코드 확인:**
```dart
// Line 146-154: 단순 텍스트 헤더 (탭 아님)
child: Center(
  child: Text(
    'Real',  // ❌ 탭이 아닌 단순 텍스트
    style: TossTextStyles.body.copyWith(
      fontWeight: FontWeight.w700,
      fontSize: 17,
      color: TossColors.black87,
    ),
  ),
),
```

---

### 문제 2: Detail 상세보기 미구현 🔴 심각
**스크린샷 분석:**
```
현재: 버튼 클릭 → 아무 반응 없음
기대: 버튼 클릭 → Detail Bottom Sheet 표시
```

**원인:**
- `_showFlowDetails()` 메서드가 TODO로만 존재

**파일:**
- `lib/features/cash_ending/presentation/widgets/tabs/cash_tab.dart:254-256`
- `lib/features/cash_ending/presentation/widgets/tabs/bank_tab.dart:137`
- `lib/features/cash_ending/presentation/widgets/tabs/vault_tab.dart:187`

**코드 확인:**
```dart
// cash_tab.dart:254-256
void _showFlowDetails(ActualFlow flow) {
  // TODO: Implement flow details bottom sheet  ❌ 미구현
}

// bank_tab.dart:137
void _showFlowDetails(ActualFlow flow) {
  // TODO: Implement flow details bottom sheet  ❌ 미구현
}

// vault_tab.dart:187
void _showFlowDetails(ActualFlow flow) {
  // TODO: Implement flow details bottom sheet  ❌ 미구현
}
```

**연결 상태:**
```dart
// real_section_widget.dart:246
onTap: () => widget.onItemTap(flow),  // ✅ 연결됨

// cash_tab.dart:287
onItemTap: _showFlowDetails,  // ✅ 연결됨, ❌ 구현 안 됨
```

---

## 📚 참고 자료: cash_location 모듈

### cash_location은 완벽하게 구현되어 있음

**파일 위치:**
- `lib/features/cash_location/presentation/pages/account_detail_page.dart`
- `lib/features/cash_location/domain/entities/journal_entry.dart`
- `lib/features/cash_location/domain/entities/cash_location_detail.dart`

**구현 내용:**
1. ✅ Journal/Real 탭 구조
2. ✅ Detail Bottom Sheet
3. ✅ Denomination 상세 표시
4. ✅ Balance Before/After 표시

---

## 🎯 수정 플랜

### Phase 1: Journal 탭 추가 (30분)

#### Step 1-1: JournalFlow Entity 추가
**파일**: `domain/entities/stock_flow.dart`

**추가할 내용:**
```dart
/// Domain entity for journal flow
class JournalFlow {
  final String journalId;
  final String createdAt;
  final String recordDate;
  final String description;
  final double amount;
  final String transactionType; // 'debit' or 'credit'
  final CurrencyInfo currency;
  final CreatedBy createdBy;
  final String? referenceNumber;

  const JournalFlow({
    required this.journalId,
    required this.createdAt,
    required this.recordDate,
    required this.description,
    required this.amount,
    required this.transactionType,
    required this.currency,
    required this.createdBy,
    this.referenceNumber,
  });

  String getFormattedDate() {
    // 동일한 로직
  }

  String getFormattedTime() {
    // 동일한 로직
  }
}
```

**이유**: 현재 ActualFlow만 있고 JournalFlow 정의가 없음

---

#### Step 1-2: StockFlowRepository에 Journal 메서드 추가
**파일**: `domain/repositories/stock_flow_repository.dart`

**추가할 메서드:**
```dart
abstract class StockFlowRepository {
  // 기존 메서드
  Future<StockFlowResponse> getLocationStockFlow(...);

  // 🆕 추가 필요
  Future<List<JournalFlow>> getLocationJournalFlow({
    required String companyId,
    required String storeId,
    required String cashLocationId,
    int offset = 0,
    int limit = 20,
  });
}
```

---

#### Step 1-3: DataSource & Repository 구현
**파일**:
- `data/datasources/stock_flow_remote_datasource.dart`
- `data/repositories/stock_flow_repository_impl.dart`
- `data/models/stock_flow_model.dart`

**추가할 코드:**

**1. Model 추가:**
```dart
// stock_flow_model.dart
class JournalFlowModel {
  final String journalId;
  final String createdAt;
  final String recordDate;
  final String description;
  final double amount;
  final String transactionType;
  // ...

  JournalFlow toEntity() {
    return JournalFlow(...);
  }

  factory JournalFlowModel.fromJson(Map<String, dynamic> json) {
    return JournalFlowModel(...);
  }
}
```

**2. DataSource 메서드:**
```dart
// stock_flow_remote_datasource.dart
Future<List<Map<String, dynamic>>> getLocationJournalFlow({
  required String companyId,
  required String storeId,
  required String cashLocationId,
  int offset = 0,
  int limit = 20,
}) async {
  final response = await _client.rpc<List<dynamic>>(
    'get_location_journal_flow',  // RPC 함수명 (DB에 확인 필요)
    params: {
      'p_company_id': companyId,
      'p_store_id': storeId,
      'p_cash_location_id': cashLocationId,
      'p_offset': offset,
      'p_limit': limit,
    },
  );

  return List<Map<String, dynamic>>.from(response);
}
```

**3. Repository 구현:**
```dart
// stock_flow_repository_impl.dart
@override
Future<List<JournalFlow>> getLocationJournalFlow({
  required String companyId,
  required String storeId,
  required String cashLocationId,
  int offset = 0,
  int limit = 20,
}) async {
  final data = await _dataSource.getLocationJournalFlow(
    companyId: companyId,
    storeId: storeId,
    cashLocationId: cashLocationId,
    offset: offset,
    limit: limit,
  );

  return data
      .map((json) => JournalFlowModel.fromJson(json).toEntity())
      .toList();
}
```

---

#### Step 1-4: real_section_widget.dart 탭 구조 추가
**파일**: `presentation/widgets/real_section_widget.dart`

**현재 구조 (Line 129-155):**
```dart
child: Column(
  children: [
    // Header - 단순 텍스트
    Container(
      child: Center(
        child: Text('Real', ...),  // ❌
      ),
    ),
    // Filter Header
    // Content Area
  ],
)
```

**수정 후 구조:**
```dart
class RealSectionWidget extends StatefulWidget {
  // 🆕 추가 필요
  final List<JournalFlow> journalFlows;

  const RealSectionWidget({
    // ...
    required this.journalFlows,  // 🆕
  });
}

class _RealSectionWidgetState extends State<RealSectionWidget>
    with SingleTickerProviderStateMixin {  // 🆕 TabController용

  late TabController _tabController;  // 🆕

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);  // 🆕
  }

  @override
  void dispose() {
    _tabController.dispose();  // 🆕
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Column(
            children: [
              // 🆕 TabBar 추가
              Container(
                height: 48,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: TossColors.gray200,
                      width: 1,
                    ),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Journal'),
                    Tab(text: 'Real'),
                  ],
                  labelColor: TossColors.primary,
                  unselectedLabelColor: TossColors.gray500,
                  indicatorColor: TossColors.primary,
                ),
              ),
              // Filter Header (Real 탭일 때만 표시)
              // ...
              // 🆕 TabBarView 추가
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildJournalTab(),  // 🆕
                    _buildRealTab(),     // 기존 로직
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildJournalTab() {
    // Journal 리스트 표시
  }

  Widget _buildRealTab() {
    // 기존 Real 리스트 (현재 _buildFlowList() 로직)
  }
}
```

---

#### Step 1-5: cash_tab.dart에서 journalFlows 전달
**파일**: `presentation/widgets/tabs/cash_tab.dart`

**추가할 상태:**
```dart
class _CashTabState extends ConsumerState<CashTab> {
  // 기존
  List<ActualFlow> _actualFlows = [];

  // 🆕 추가
  List<JournalFlow> _journalFlows = [];
  bool _isLoadingJournalFlows = false;
  bool _hasMoreJournalFlows = false;
  int _journalFlowsOffset = 0;

  Future<void> _loadJournalFlows({bool loadMore = false}) async {
    // Repository 호출
    final repository = ref.read(stockFlowRepositoryProvider);
    final result = await repository.getLocationJournalFlow(...);

    setState(() {
      _journalFlows = result;
    });
  }
}
```

**RealSectionWidget에 전달:**
```dart
// cash_tab.dart:278 수정
RealSectionWidget(
  actualFlows: _actualFlows,
  journalFlows: _journalFlows,  // 🆕 추가
  locationSummary: _locationSummary,
  isLoading: _isLoadingFlows,
  hasMore: _hasMoreFlows,
  baseCurrencySymbol: state.currencies.first.symbol,
  onLoadMore: _loadMoreFlows,
  onItemTap: _showFlowDetails,
  onJournalItemTap: _showJournalDetails,  // 🆕 추가
),
```

---

### Phase 2: Detail Bottom Sheet 구현 (30분)

#### Step 2-1: FlowDetailBottomSheet Widget 생성
**파일**: `presentation/widgets/sheets/flow_detail_bottom_sheet.dart` (🆕 새 파일)

**구조:**
```dart
class FlowDetailBottomSheet extends StatelessWidget {
  final ActualFlow flow;
  final LocationSummary? locationSummary;

  const FlowDetailBottomSheet({
    super.key,
    required this.flow,
    required this.locationSummary,
  });

  static void show({
    required BuildContext context,
    required ActualFlow flow,
    required LocationSummary? locationSummary,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => FlowDetailBottomSheet(
        flow: flow,
        locationSummary: locationSummary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          _buildHandleBar(),

          // Header: Transaction Info
          _buildHeader(),

          // Balance Section
          _buildBalanceSection(),

          // Denominations List
          Expanded(
            child: _buildDenominationsList(),
          ),

          // Close Button
          _buildCloseButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                flow.createdBy.fullName,
                style: TossTextStyles.h3,
              ),
              Text(
                flow.getFormattedTime(),
                style: TossTextStyles.body,
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space2),
          Row(
            children: [
              Icon(
                flow.flowAmount >= 0
                  ? TossIcons.arrowUp
                  : TossIcons.arrowDown,
                color: flow.flowAmount >= 0
                  ? TossColors.success
                  : TossColors.error,
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                '${flow.currency.symbol}${flow.flowAmount.abs().toStringAsFixed(0)}',
                style: TossTextStyles.h2.copyWith(
                  color: flow.flowAmount >= 0
                    ? TossColors.success
                    : TossColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceSection() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        border: Border(
          top: BorderSide(color: TossColors.gray200),
          bottom: BorderSide(color: TossColors.gray200),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBalanceItem('Before', flow.balanceBefore),
          Icon(TossIcons.arrowForward, color: TossColors.gray400),
          _buildBalanceItem('After', flow.balanceAfter),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(String label, double amount) {
    return Column(
      children: [
        Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          '${flow.currency.symbol}${amount.toStringAsFixed(0)}',
          style: TossTextStyles.h4,
        ),
      ],
    );
  }

  Widget _buildDenominationsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(TossSpacing.space5),
      itemCount: flow.currentDenominations.length,
      itemBuilder: (context, index) {
        final denom = flow.currentDenominations[index];
        return _buildDenominationItem(denom);
      },
    );
  }

  Widget _buildDenominationItem(DenominationDetail denom) {
    final hasChange = denom.quantityChange != 0;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: TossSpacing.space3,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: TossColors.gray100,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Denomination Value
          Container(
            width: 80,
            child: Text(
              '${denom.currencySymbol ?? ''}${denom.denominationValue.toStringAsFixed(0)}',
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Quantity Change
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${denom.previousQuantity}',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
                const SizedBox(width: TossSpacing.space2),
                Icon(
                  TossIcons.arrowForward,
                  size: 16,
                  color: TossColors.gray400,
                ),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  '${denom.currentQuantity}',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: hasChange ? TossColors.primary : TossColors.gray900,
                  ),
                ),
                if (hasChange) ...[
                  const SizedBox(width: TossSpacing.space2),
                  Text(
                    '(${denom.quantityChange > 0 ? '+' : ''}${denom.quantityChange})',
                    style: TossTextStyles.caption.copyWith(
                      color: denom.quantityChange > 0
                        ? TossColors.success
                        : TossColors.error,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Subtotal
          Container(
            width: 100,
            alignment: Alignment.centerRight,
            child: Text(
              '${denom.currencySymbol ?? ''}${denom.subtotal.toStringAsFixed(0)}',
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space5),
        child: TossButton1.secondary(
          text: 'Close',
          onPressed: () => Navigator.pop(context),
          fullWidth: true,
        ),
      ),
    );
  }
}
```

---

#### Step 2-2: _showFlowDetails() 구현
**파일**:
- `presentation/widgets/tabs/cash_tab.dart:254-256`
- `presentation/widgets/tabs/bank_tab.dart:137`
- `presentation/widgets/tabs/vault_tab.dart:187`

**Before (현재):**
```dart
void _showFlowDetails(ActualFlow flow) {
  // TODO: Implement flow details bottom sheet  ❌
}
```

**After (수정):**
```dart
void _showFlowDetails(ActualFlow flow) {
  FlowDetailBottomSheet.show(
    context: context,
    flow: flow,
    locationSummary: _locationSummary,
  );
}
```

---

## 🗂️ 파일 변경 요약

### 생성할 파일 (1개)
```
presentation/widgets/sheets/
└── flow_detail_bottom_sheet.dart  🆕 새 파일 (약 200줄)
```

### 수정할 파일 (8개)

| 파일 | 수정 내용 | 예상 줄 수 |
|------|-----------|------------|
| `domain/entities/stock_flow.dart` | JournalFlow entity 추가 | +50줄 |
| `domain/repositories/stock_flow_repository.dart` | getLocationJournalFlow 메서드 추가 | +10줄 |
| `data/models/stock_flow_model.dart` | JournalFlowModel 추가 | +60줄 |
| `data/datasources/stock_flow_remote_datasource.dart` | getLocationJournalFlow 구현 | +20줄 |
| `data/repositories/stock_flow_repository_impl.dart` | getLocationJournalFlow 구현 | +20줄 |
| `presentation/widgets/real_section_widget.dart` | TabBar 구조 추가 | ~100줄 수정 |
| `presentation/widgets/tabs/cash_tab.dart` | Journal 로드 + Detail 구현 | +50줄 |
| `presentation/widgets/tabs/bank_tab.dart` | Detail 구현 | +5줄 |
| `presentation/widgets/tabs/vault_tab.dart` | Detail 구현 | +5줄 |

---

## ⚠️ 확인 필요 사항

### 1. Supabase RPC 함수 확인 필요
**질문**: Journal Flow를 가져오는 RPC 함수명이 무엇인가?

**가능한 함수명:**
- `get_location_journal_flow`
- `get_cash_journal_flow`
- `get_journal_flows`

**확인 방법:**
```sql
-- Supabase SQL Editor에서 실행
SELECT routine_name
FROM information_schema.routines
WHERE routine_type = 'FUNCTION'
  AND routine_name LIKE '%journal%';
```

---

### 2. Journal vs Real 차이 확인
**현재 이해:**
- **Real (ActualFlow)**: 실제 현금 계수 기록 (Denomination 포함)
- **Journal (JournalFlow)**: 회계 분개 기록 (입출금 내역)

**cash_location 참고:**
- `lib/features/cash_location/domain/entities/journal_entry.dart`
- Journal은 `description`, `debit`, `credit` 포함

---

### 3. DB 스키마 확인 필요
Journal 데이터를 가져오는 테이블/뷰:
- `journal_entry` 테이블?
- `cash_journal` 뷰?
- RPC 함수 결과?

---

## 📊 우선순위

| Phase | 작업 | 중요도 | 소요 시간 | 의존성 |
|-------|------|--------|-----------|--------|
| Phase 1 | Journal 탭 추가 | 🔴 높음 | 30분 | DB RPC 확인 필요 |
| Phase 2 | Detail Bottom Sheet | 🔴 높음 | 30분 | 없음 (독립적) |

**권장 순서:**
1. Phase 2 먼저 (Detail) - DB 의존성 없음, 바로 구현 가능
2. Phase 1 나중 (Journal) - DB RPC 확인 필요

---

## 🎯 예상 결과

### After Phase 1 (Journal 탭 추가)
```
┌──────────────────────────────────────┐
│  [Journal]  [Real]                    │  ✅ 탭 추가
├──────────────────────────────────────┤
│  Journal 내역 리스트                   │
└──────────────────────────────────────┘
```

### After Phase 2 (Detail 구현)
```
┌──────────────────────────────────────┐
│  Cash Count                          │
│  Minh Ngocc • 03:47     -₫100,000    │  ← 클릭 가능
└──────────────────────────────────────┘
                 ↓ 클릭
┌──────────────────────────────────────┐
│  Flow Detail Bottom Sheet            │
│                                      │
│  Minh Ngocc          03:47           │
│  ↓ -₫100,000                         │
│                                      │
│  Before: ₫15,290,000                 │
│     →                                │
│  After:  ₫15,190,000                 │
│                                      │
│  Denominations:                      │
│  ₫500,000    5 → 4 (-1)    ₫2,000,000│
│  ₫100,000    3 → 3 (0)     ₫300,000  │
│  ...                                 │
│                                      │
│  [Close]                             │
└──────────────────────────────────────┘
```

---

## ✅ 체크리스트

### Phase 1: Journal 탭
- [ ] DB RPC 함수명 확인
- [ ] JournalFlow Entity 생성
- [ ] JournalFlowModel 생성
- [ ] Repository 메서드 추가
- [ ] DataSource 구현
- [ ] real_section_widget.dart TabBar 추가
- [ ] cash_tab.dart Journal 로드 추가
- [ ] 빌드 테스트

### Phase 2: Detail Bottom Sheet
- [ ] flow_detail_bottom_sheet.dart 생성
- [ ] cash_tab.dart _showFlowDetails 구현
- [ ] bank_tab.dart _showFlowDetails 구현
- [ ] vault_tab.dart _showFlowDetails 구현
- [ ] UI 테스트 (클릭 동작)
- [ ] Denomination 표시 확인
- [ ] Balance Before/After 확인

---

**작성자**: 30년차 Flutter 개발자
**다음 단계**: Phase 2 (Detail) 먼저 구현 권장
**예상 총 소요 시간**: 60분
