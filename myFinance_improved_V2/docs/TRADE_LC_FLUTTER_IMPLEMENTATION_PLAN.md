# L/C Trade Management System - Flutter Implementation Plan

> **Version**: 1.0.0
> **Created**: 2025-12-26
> **Architecture**: Clean Architecture + Riverpod

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [2025 UI/UX Design Trends](#2-2025-uiux-design-trends)
3. [Implementation Order](#3-implementation-order)
4. [Feature Implementation Details](#4-feature-implementation-details)
5. [Shared Components](#5-shared-components)
6. [Folder Structure](#6-folder-structure)
7. [RPC API Integration](#7-rpc-api-integration)
8. [State Management](#8-state-management)
9. [Development Phases](#9-development-phases)

---

## 1. Executive Summary

### 1.1 Project Overview

| Item | Description |
|------|-------------|
| **System** | L/C (Letter of Credit) Trade Management |
| **Features** | 6 features (Dashboard, PI, PO, L/C, Shipment, CI) |
| **Database** | 25 tables deployed to Supabase |
| **API** | RPC-based functions (trade_*) |
| **Architecture** | Clean Architecture + Riverpod |

### 1.2 Key Goals

- **Smart Dashboard**: Real-time overview with actionable insights
- **Workflow Automation**: Status transitions with validation
- **Document Management**: L/C requirement tracking
- **Discrepancy Prevention**: Pre-submission validation

---

## 2. 2025 UI/UX Design Trends

Based on latest fintech design research:

### 2.1 Core Design Principles

| Principle | Implementation |
|-----------|----------------|
| **Smart Dashboards** | Personalized widgets, AI insights, deadline alerts |
| **Simplify Complexity** | Progressive disclosure, step-by-step workflows |
| **Data Visualization** | Charts for amounts, timelines, progress |
| **Security-First** | Clear status indicators, audit trails |
| **Mobile-First** | Responsive, touch-optimized |

### 2.2 UI Components (Toss-style)

```
┌─────────────────────────────────────────────────────────────┐
│  Smart Dashboard Pattern                                     │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │  Active L/C  │  │   Pending    │  │  Expiring    │       │
│  │     $500K    │  │  Shipments   │  │   Soon (3)   │       │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  🔔 Alerts (Urgent First)                               │ │
│  │  ├─ L/C-2025-001 expires in 5 days                     │ │
│  │  ├─ CI-2025-003 discrepancy pending                    │ │
│  │  └─ Shipment SHP-005 ready for document prep           │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  Recent Transactions                                    │ │
│  │  [Timeline view with status chips]                     │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### 2.3 Status Color System

| Status Type | Color | Usage |
|-------------|-------|-------|
| Draft/Pending | `gray` | Initial states |
| In Progress | `blue` | Active processing |
| Warning | `orange` | Attention needed |
| Error/Urgent | `red` | Immediate action |
| Success | `green` | Completed/Approved |

---

## 3. Implementation Order

### 3.1 Recommended Order (Dependency-based)

```
Phase 1: Foundation (Week 1)
├── 1️⃣ Shared Components (entities, models, providers)
├── 2️⃣ Trade Dashboard (overview + alerts)
└── 3️⃣ Master Data Integration (incoterms, payment terms)

Phase 2: Pre-Shipment (Week 2)
├── 4️⃣ Proforma Invoice (PI) - Start point of workflow
└── 5️⃣ Purchase Order (PO) - Derived from PI

Phase 3: L/C Core (Week 3)
├── 6️⃣ Letter of Credit (L/C) - Core feature
└── 7️⃣ Amendment Management

Phase 4: Execution (Week 4)
├── 8️⃣ Shipment - Physical delivery
└── 9️⃣ Commercial Invoice (CI) - Bank submission

Phase 5: Polish (Week 5)
├── 🔟 Document Management
├── 1️⃣1️⃣ Payment Tracking
└── 1️⃣2️⃣ Reports & Analytics
```

### 3.2 Why This Order?

| Order | Feature | Reason |
|-------|---------|--------|
| 1 | **Shared Components** | Foundation for all features |
| 2 | **Trade Dashboard** | Overview + alerts structure |
| 3 | **Proforma Invoice** | Entry point of trade workflow |
| 4 | **Purchase Order** | Depends on PI, triggers L/C |
| 5 | **Letter of Credit** | Core feature, complex status |
| 6 | **Shipment** | Depends on L/C, triggers CI |
| 7 | **Commercial Invoice** | Final step, document validation |

---

## 4. Feature Implementation Details

### 4.1 Trade Dashboard

**Purpose**: Real-time overview of all trade activities

**Key Widgets**:
```dart
// Dashboard widgets
├── TradeSummaryCards          // Active L/C, PO, Shipment counts
├── TradeAlertList             // Urgent alerts sorted by priority
├── TradeTimelineWidget        // Recent activities
├── ExpiryCalendarWidget       // L/C expiry visualization
├── PaymentScheduleWidget      // Upcoming payments
└── QuickActionsWidget         // Create PI, View L/C, etc.
```

**RPC Functions**:
- `trade_dashboard_summary` - Get overview stats
- `trade_dashboard_timeline` - Get recent activities
- `trade_alert_list` - Get active alerts

**Screen Layout**:
```
┌─────────────────────────────────────────┐
│ Trade Dashboard                    [⚙️] │
├─────────────────────────────────────────┤
│ ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐        │
│ │Active│ │ L/C │ │Ship │ │ Due │        │ Summary Cards
│ │ PO:8│ │ :5  │ │ :12 │ │$50K │        │
│ └─────┘ └─────┘ └─────┘ └─────┘        │
├─────────────────────────────────────────┤
│ 🔔 Alerts (3)                           │
│ ├─ 🔴 L/C expires in 3 days            │ Alert Section
│ ├─ 🟡 Document pending                 │ (Priority sorted)
│ └─ 🟢 Payment received                 │
├─────────────────────────────────────────┤
│ Recent Activity                         │
│ ├─ Today: PI-001 created               │ Timeline
│ ├─ Yesterday: L/C-003 advised          │
│ └─ Dec 24: Shipment departed           │
├─────────────────────────────────────────┤
│ Quick Actions                           │
│ [+ New PI] [View L/C] [Documents]      │ Action Buttons
└─────────────────────────────────────────┘
```

---

### 4.2 Proforma Invoice (PI)

**Purpose**: Create and send quotations to buyers

**Key Screens**:
```
proforma_invoice/
├── presentation/
│   ├── pages/
│   │   ├── proforma_invoice_page.dart        # List view
│   │   ├── proforma_invoice_detail_page.dart # Detail view
│   │   └── proforma_invoice_form_page.dart   # Create/Edit
│   ├── widgets/
│   │   ├── pi_list_item.dart
│   │   ├── pi_item_form.dart
│   │   ├── pi_status_chip.dart
│   │   ├── pi_summary_card.dart
│   │   └── buyer_selector.dart
│   └── providers/
│       ├── pi_list_provider.dart
│       └── pi_form_provider.dart
```

**RPC Functions**:
- `trade_pi_list` - List with filters
- `trade_pi_get` - Get detail
- `trade_pi_create` - Create new PI
- `trade_pi_update` - Update existing
- `trade_pi_send` - Change status to SENT
- `trade_pi_convert_to_po` - Convert to PO

**Status Flow**:
```
DRAFT → SENT → ACCEPTED → CONVERTED
          ↓          ↓
     NEGOTIATING   REJECTED
          ↓
       EXPIRED
```

**Form Fields**:
```dart
// PI Form structure
├── Buyer Information
│   ├── Buyer (dropdown with search)
│   └── Contact Person
├── Trade Terms
│   ├── Incoterms (dropdown)
│   ├── Payment Terms (dropdown)
│   └── Currency
├── Shipping
│   ├── Port of Loading
│   ├── Port of Discharge
│   └── Estimated Ship Date
├── Items (repeatable)
│   ├── Product (dropdown/search)
│   ├── Description (L/C wording)
│   ├── Quantity + Unit
│   ├── Unit Price
│   └── HS Code
├── Validity
│   └── Valid Until Date
└── Notes
    ├── Terms & Conditions
    └── Internal Notes
```

---

### 4.3 Purchase Order (PO)

**Purpose**: Confirmed orders from buyers

**Key Screens**:
```
purchase_order/
├── presentation/
│   ├── pages/
│   │   ├── purchase_order_page.dart
│   │   ├── purchase_order_detail_page.dart
│   │   └── purchase_order_form_page.dart
│   ├── widgets/
│   │   ├── po_list_item.dart
│   │   ├── po_status_chip.dart
│   │   ├── po_progress_bar.dart       # Shipped %
│   │   └── linked_pi_card.dart
│   └── providers/
│       ├── po_list_provider.dart
│       └── po_form_provider.dart
```

**RPC Functions**:
- `trade_po_list` - List with filters
- `trade_po_get` - Get detail with shipment summary
- `trade_po_create` - Create (manual or from PI)
- `trade_po_confirm` - Confirm order
- `trade_po_get_shipment_summary` - Get shipment progress

**Status Flow**:
```
DRAFT → CONFIRMED → IN_PRODUCTION → READY_TO_SHIP
                                          ↓
                              PARTIALLY_SHIPPED → SHIPPED → COMPLETED
```

**Special UI Elements**:
```dart
// Shipment Progress visualization
Container(
  child: Column(
    children: [
      LinearProgressIndicator(
        value: shippedPercent / 100,
      ),
      Text('$shippedQuantity / $orderedQuantity shipped'),
    ],
  ),
)
```

---

### 4.4 Letter of Credit (L/C)

**Purpose**: Register and track L/C from banks

**Key Screens**:
```
letter_of_credit/
├── presentation/
│   ├── pages/
│   │   ├── letter_of_credit_page.dart
│   │   ├── letter_of_credit_detail_page.dart
│   │   ├── letter_of_credit_form_page.dart
│   │   └── amendment_history_page.dart
│   ├── widgets/
│   │   ├── lc_list_item.dart
│   │   ├── lc_status_chip.dart
│   │   ├── lc_deadline_card.dart        # Expiry, Shipment dates
│   │   ├── lc_amount_card.dart          # Amount + Tolerance
│   │   ├── required_documents_checklist.dart
│   │   ├── bank_info_card.dart
│   │   └── lc_timeline.dart
│   └── providers/
│       ├── lc_list_provider.dart
│       ├── lc_detail_provider.dart
│       └── lc_form_provider.dart
```

**RPC Functions**:
- `trade_lc_list` - List with expiry filter
- `trade_lc_get` - Get detail with all related data
- `trade_lc_create` - Register L/C
- `trade_lc_update_status` - Status change
- `trade_lc_request_amendment` - Request amendment
- `trade_lc_check_validity` - Check validity
- `trade_lc_calculate_amounts` - Calculate drawable amounts

**Status Flow**:
```
DRAFT → PENDING → ISSUED → ADVISED → [CONFIRMED]
                                 ↓
                          PARTIALLY_SHIPPED → FULLY_SHIPPED
                                                    ↓
                                         DOCUMENTS_PRESENTED
                                                    ↓
                                           UNDER_EXAMINATION
                                            ↓            ↓
                                       ACCEPTED    DISCREPANCY
                                            ↓            ↓
                                    PAYMENT_PENDING → PAID
```

**Critical Dates Display**:
```dart
// Deadline cards with countdown
LCDeadlineCard(
  title: 'Latest Shipment Date',
  date: lc.latestShipmentDate,
  daysRemaining: daysUntilShipment,
  icon: Icons.local_shipping,
  urgency: daysUntilShipment < 7 ? Urgency.high : Urgency.normal,
)

LCDeadlineCard(
  title: 'L/C Expiry Date',
  date: lc.expiryDate,
  daysRemaining: daysUntilExpiry,
  icon: Icons.event_busy,
  urgency: daysUntilExpiry < 7 ? Urgency.high : Urgency.normal,
)
```

---

### 4.5 Shipment

**Purpose**: Register shipments and track delivery

**Key Screens**:
```
shipment/
├── presentation/
│   ├── pages/
│   │   ├── shipment_page.dart
│   │   ├── shipment_detail_page.dart
│   │   └── shipment_form_page.dart
│   ├── widgets/
│   │   ├── shipment_list_item.dart
│   │   ├── shipment_status_chip.dart
│   │   ├── shipment_tracking_timeline.dart
│   │   ├── bl_info_card.dart
│   │   ├── cargo_info_card.dart
│   │   └── linked_po_items_list.dart
│   └── providers/
│       ├── shipment_list_provider.dart
│       └── shipment_form_provider.dart
```

**RPC Functions**:
- `trade_shipment_list` - List with filters
- `trade_shipment_get` - Get detail
- `trade_shipment_create` - Create shipment
- `trade_shipment_update_status` - Update tracking status
- `trade_shipment_update_tracking` - Update B/L info

**Status Flow**:
```
DRAFT → BOOKED → AT_ORIGIN_PORT → LOADED → DEPARTED
                                              ↓
                                         IN_TRANSIT
                                              ↓
                               AT_DESTINATION_PORT → CUSTOMS → DELIVERED
```

**Tracking Timeline UI**:
```dart
// Vertical timeline visualization
ShipmentTrackingTimeline(
  statuses: [
    TrackingStep(status: 'BOOKED', date: bookingDate, completed: true),
    TrackingStep(status: 'LOADED', date: blDate, completed: true),
    TrackingStep(status: 'DEPARTED', date: departedDate, completed: true),
    TrackingStep(status: 'IN_TRANSIT', date: null, completed: false, current: true),
    TrackingStep(status: 'DELIVERED', date: eta, completed: false),
  ],
)
```

---

### 4.6 Commercial Invoice (CI)

**Purpose**: Create bank submission invoices with L/C validation

**Key Screens**:
```
commercial_invoice/
├── presentation/
│   ├── pages/
│   │   ├── commercial_invoice_page.dart
│   │   ├── commercial_invoice_detail_page.dart
│   │   └── commercial_invoice_form_page.dart
│   ├── widgets/
│   │   ├── ci_list_item.dart
│   │   ├── ci_status_chip.dart
│   │   ├── lc_matching_card.dart        # L/C vs CI comparison
│   │   ├── discrepancy_alert.dart
│   │   ├── bank_submission_card.dart
│   │   └── payment_status_card.dart
│   └── providers/
│       ├── ci_list_provider.dart
│       ├── ci_form_provider.dart
│       └── ci_validation_provider.dart
```

**RPC Functions**:
- `trade_ci_list` - List with filters
- `trade_ci_get` - Get detail
- `trade_ci_create` - Create from shipment
- `trade_ci_finalize` - Mark as final
- `trade_ci_submit` - Submit to bank
- `trade_ci_validate_against_lc` - **Critical**: Validate match

**Status Flow**:
```
DRAFT → FINALIZED → SUBMITTED → UNDER_REVIEW
                                    ↓
                    ACCEPTED ← DISCREPANCY → REJECTED
                        ↓           ↓
                PAYMENT_PENDING  DISCREPANCY_RESOLVED
                        ↓
                      PAID
```

**Validation UI** (Most Critical Feature):
```dart
// L/C vs CI validation display
LCMatchingCard(
  validations: [
    ValidationItem(
      field: 'Amount',
      lcValue: '\$100,000',
      ciValue: '\$98,500',
      status: ValidationStatus.ok,  // Within tolerance
      tolerance: '±5%',
    ),
    ValidationItem(
      field: 'Goods Description',
      lcValue: 'Widget Type A',
      ciValue: 'Widget Type-A',  // Hyphen mismatch!
      status: ValidationStatus.error,
      message: 'Description must match exactly',
    ),
    ValidationItem(
      field: 'Shipment Date',
      lcValue: 'Latest: 2025-01-15',
      ciValue: '2025-01-10',
      status: ValidationStatus.ok,
    ),
  ],
)
```

---

## 5. Shared Components

### 5.1 Domain Entities

```dart
// lib/features/trade_shared/domain/entities/
├── trade_counterparty.dart      // Buyer, Bank info
├── trade_item.dart              // Base item with HS code
├── trade_document.dart          // Attached document
├── trade_status.dart            // Status with color
├── trade_alert.dart             // Alert entity
├── trade_amount.dart            // Amount with currency
├── trade_timeline_event.dart    // Activity log
└── trade_discrepancy.dart       // Discrepancy info
```

### 5.2 Shared Widgets

```dart
// lib/features/trade_shared/presentation/widgets/
├── trade_status_chip.dart       // Colored status badge
├── trade_amount_display.dart    // Currency formatted amount
├── trade_deadline_card.dart     // Countdown display
├── trade_timeline_widget.dart   // Activity timeline
├── trade_document_list.dart     // Document checklist
├── trade_filter_bar.dart        // Status + date filters
├── trade_search_bar.dart        // Search with suggestions
├── trade_empty_state.dart       // No data placeholder
├── trade_error_state.dart       // Error display
├── trade_loading_shimmer.dart   // Loading skeleton
├── counterparty_selector.dart   // Buyer/Bank picker
├── port_selector.dart           // Port picker
├── incoterm_selector.dart       // Incoterm picker
└── currency_selector.dart       // Currency picker
```

### 5.3 Shared Providers

```dart
// lib/features/trade_shared/presentation/providers/
├── master_data_provider.dart    // Incoterms, payment terms, etc.
├── counterparty_provider.dart   // Buyers, banks list
├── currency_provider.dart       // Currency list
└── trade_alert_provider.dart    // Active alerts
```

---

## 6. Folder Structure

### 6.1 Complete Structure

```
lib/features/
├── trade_shared/                        # Shared components
│   ├── data/
│   │   ├── datasources/
│   │   │   └── trade_remote_datasource.dart
│   │   ├── models/
│   │   │   ├── trade_status_model.dart
│   │   │   ├── trade_alert_model.dart
│   │   │   └── trade_counterparty_model.dart
│   │   └── repositories/
│   │       └── trade_master_repository_impl.dart
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── trade_status.dart
│   │   │   ├── trade_alert.dart
│   │   │   └── incoterm.dart
│   │   └── repositories/
│   │       └── trade_master_repository.dart
│   ├── presentation/
│   │   ├── widgets/
│   │   │   ├── trade_status_chip.dart
│   │   │   └── ...
│   │   └── providers/
│   │       └── master_data_provider.dart
│   └── di/
│       └── trade_shared_module.dart
│
├── trade_dashboard/
│   ├── data/
│   │   ├── datasources/
│   │   │   └── dashboard_remote_datasource.dart
│   │   ├── models/
│   │   │   ├── dashboard_summary_model.dart
│   │   │   └── dashboard_timeline_model.dart
│   │   └── repositories/
│   │       └── dashboard_repository_impl.dart
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── dashboard_summary.dart
│   │   │   └── timeline_event.dart
│   │   └── repositories/
│   │       └── dashboard_repository.dart
│   ├── presentation/
│   │   ├── pages/
│   │   │   └── trade_dashboard_page.dart
│   │   ├── widgets/
│   │   │   ├── summary_cards.dart
│   │   │   ├── alert_list.dart
│   │   │   └── timeline_widget.dart
│   │   └── providers/
│   │       └── dashboard_provider.dart
│   └── di/
│       └── dashboard_module.dart
│
├── proforma_invoice/
│   ├── data/
│   │   ├── datasources/
│   │   │   └── pi_remote_datasource.dart
│   │   ├── models/
│   │   │   ├── pi_model.dart
│   │   │   ├── pi_model.freezed.dart
│   │   │   ├── pi_model.g.dart
│   │   │   └── pi_item_model.dart
│   │   └── repositories/
│   │       └── pi_repository_impl.dart
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── proforma_invoice.dart
│   │   │   └── pi_item.dart
│   │   └── repositories/
│   │       └── pi_repository.dart
│   ├── presentation/
│   │   ├── pages/
│   │   │   ├── proforma_invoice_page.dart
│   │   │   ├── proforma_invoice_detail_page.dart
│   │   │   └── proforma_invoice_form_page.dart
│   │   ├── widgets/
│   │   │   ├── pi_list_item.dart
│   │   │   └── pi_item_form.dart
│   │   └── providers/
│   │       ├── pi_list_provider.dart
│   │       └── pi_form_provider.dart
│   └── di/
│       └── pi_module.dart
│
├── purchase_order/           # Same structure
├── letter_of_credit/         # Same structure
├── shipment/                 # Same structure
└── commercial_invoice/       # Same structure
```

---

## 7. RPC API Integration

### 7.1 Datasource Pattern

```dart
// Example: PI Remote Datasource
abstract class PIRemoteDatasource {
  Future<PaginatedResponse<PIModel>> list({
    required String companyId,
    String? status,
    String? buyerId,
    DateTime? dateFrom,
    DateTime? dateTo,
    int page = 1,
    int pageSize = 20,
  });

  Future<PIModel> get(String piId);
  Future<PIModel> create(PICreateRequest request);
  Future<PIModel> update(String piId, PIUpdateRequest request);
  Future<void> send(String piId);
  Future<POModel> convertToPO(String piId);
}

class PIRemoteDatasourceImpl implements PIRemoteDatasource {
  final SupabaseClient _supabase;

  @override
  Future<PaginatedResponse<PIModel>> list({...}) async {
    final response = await _supabase.rpc(
      'trade_pi_list',
      params: {
        'p_company_id': companyId,
        'p_status': status != null ? [status] : null,
        'p_counterparty_id': buyerId,
        'p_date_from': dateFrom?.toIso8601String(),
        'p_date_to': dateTo?.toIso8601String(),
        'p_page': page,
        'p_page_size': pageSize,
      },
    );

    return PaginatedResponse.fromJson(
      response,
      (json) => PIModel.fromJson(json),
    );
  }
}
```

### 7.2 Repository Pattern

```dart
// Domain Repository (Abstract)
abstract class PIRepository {
  Future<Either<Failure, PaginatedList<ProformaInvoice>>> getList(PIListParams params);
  Future<Either<Failure, ProformaInvoice>> getById(String id);
  Future<Either<Failure, ProformaInvoice>> create(PICreateParams params);
  Future<Either<Failure, void>> send(String id);
  Future<Either<Failure, PurchaseOrder>> convertToPO(String id);
}

// Data Repository (Implementation)
class PIRepositoryImpl implements PIRepository {
  final PIRemoteDatasource _remoteDatasource;

  @override
  Future<Either<Failure, PaginatedList<ProformaInvoice>>> getList(
    PIListParams params,
  ) async {
    try {
      final response = await _remoteDatasource.list(
        companyId: params.companyId,
        status: params.status,
        buyerId: params.buyerId,
        dateFrom: params.dateFrom,
        dateTo: params.dateTo,
        page: params.page,
        pageSize: params.pageSize,
      );

      return Right(response.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
```

---

## 8. State Management

### 8.1 Provider Structure

```dart
// List Provider (with filters)
@riverpod
class PIListNotifier extends _$PIListNotifier {
  @override
  Future<PaginatedList<ProformaInvoice>> build() async {
    final repository = ref.watch(piRepositoryProvider);
    final filters = ref.watch(piFiltersProvider);

    return repository.getList(filters).then(
      (result) => result.fold(
        (failure) => throw failure,
        (data) => data,
      ),
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<void> loadMore() async {
    // Implement pagination
  }
}

// Detail Provider
@riverpod
Future<ProformaInvoice> piDetail(PIDetailRef ref, String id) async {
  final repository = ref.watch(piRepositoryProvider);

  final result = await repository.getById(id);
  return result.fold(
    (failure) => throw failure,
    (data) => data,
  );
}

// Form Provider (for create/edit)
@riverpod
class PIFormNotifier extends _$PIFormNotifier {
  @override
  PIFormState build() => PIFormState.initial();

  void updateBuyer(String buyerId) {
    state = state.copyWith(buyerId: buyerId);
  }

  void addItem(PIItem item) {
    state = state.copyWith(items: [...state.items, item]);
  }

  Future<bool> save() async {
    // Validate and save
  }
}
```

### 8.2 State Classes (Freezed)

```dart
@freezed
class PIFormState with _$PIFormState {
  const factory PIFormState({
    required String? buyerId,
    required String? incotermCode,
    required String? paymentTermCode,
    required String currency,
    required String? loadingPort,
    required String? dischargePort,
    required DateTime? validUntil,
    required List<PIItemState> items,
    required bool isLoading,
    required String? errorMessage,
  }) = _PIFormState;

  factory PIFormState.initial() => const PIFormState(
    buyerId: null,
    incotermCode: null,
    paymentTermCode: null,
    currency: 'USD',
    loadingPort: null,
    dischargePort: null,
    validUntil: null,
    items: [],
    isLoading: false,
    errorMessage: null,
  );
}
```

---

## 9. Development Phases

### Phase 1: Foundation (Days 1-3)

| Task | Files | Priority |
|------|-------|----------|
| Create `trade_shared` module | entities, widgets, providers | P0 |
| Master data integration | Incoterms, payment terms dropdown | P0 |
| Trade Dashboard skeleton | Page + summary cards | P0 |
| Alert system | Alert list widget | P0 |

### Phase 2: PI & PO (Days 4-7)

| Task | Files | Priority |
|------|-------|----------|
| PI list page | List, filters, search | P0 |
| PI detail page | Info cards, items list | P0 |
| PI form (create/edit) | Form widgets, validation | P0 |
| PI → PO conversion | Convert flow | P0 |
| PO list/detail/form | Same as PI | P0 |

### Phase 3: L/C (Days 8-11)

| Task | Files | Priority |
|------|-------|----------|
| L/C list page | With expiry warnings | P0 |
| L/C detail page | Deadline cards, documents | P0 |
| L/C form | Bank info, conditions | P0 |
| Amendment management | Amendment list, form | P1 |
| Document checklist | Required docs tracking | P0 |

### Phase 4: Shipment & CI (Days 12-15)

| Task | Files | Priority |
|------|-------|----------|
| Shipment list/detail | Tracking timeline | P0 |
| Shipment form | B/L info, cargo details | P0 |
| CI list/detail | Bank status tracking | P0 |
| CI form | Auto-fill from shipment | P0 |
| **L/C validation** | Discrepancy detection | P0 |

### Phase 5: Polish (Days 16-20)

| Task | Files | Priority |
|------|-------|----------|
| Document upload | File attachment | P1 |
| Payment tracking | Payment list, record | P1 |
| Dashboard enhancements | Charts, analytics | P2 |
| Reports | Export, print | P2 |
| Testing & QA | Unit, widget tests | P1 |

---

## Quick Start

### Step 1: Create Shared Module First

```bash
# Create folder structure
mkdir -p lib/features/trade_shared/{data,domain,presentation,di}
mkdir -p lib/features/trade_shared/data/{datasources,models,repositories}
mkdir -p lib/features/trade_shared/domain/{entities,repositories}
mkdir -p lib/features/trade_shared/presentation/{widgets,providers}
```

### Step 2: Start with Dashboard

Update `trade_dashboard_page.dart` with real widgets and connect to RPC.

### Step 3: Implement PI (First CRUD)

Complete the PI feature as a template for other features.

---

## Key Success Factors

1. **L/C Validation is Critical**: The CI validation against L/C must be accurate
2. **Deadline Alerts**: Users must never miss expiry dates
3. **Document Tracking**: All required documents must be tracked
4. **Audit Trail**: Every action must be logged
5. **Mobile-First**: All screens must work on mobile

---

## Sources

- [Finance Dashboard Best Practices](https://www.f9finance.com/dashboard-design-best-practices/)
- [Fintech UX Trends 2025](https://ux4sight.com/blog/fintech-ux-design-strategies)
- [Banking App UX 2025](https://www.purrweb.com/blog/banking-app-design/)
- [HSBC Trade Solutions](https://www.business.hsbc.com/en-gb/solutions/letters-of-credit)
- [Finastra Digital Lending UI](https://www.finastra.com/viewpoints/articles/enhancing-lending-ui-ux-cx)

---

> **Next Steps**: Start with Phase 1 - Create `trade_shared` module and Dashboard skeleton.
