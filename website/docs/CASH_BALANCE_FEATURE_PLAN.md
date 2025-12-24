# Cash Balance Feature Implementation Plan

> **Feature**: Cash Balance Tab - 모든 현금 보관 위치를 한눈에 보는 대시보드
> **Target**: Website (React + TypeScript)
> **Date**: 2024-12-24

---

## 1. Feature Overview

### 1.1 목적
여러 가게와 현금 보관 위치(금고, 캐셔, 은행계좌 등)의 잔액을 한눈에 볼 수 있는 스프레드시트 형태의 대시보드

### 1.2 주요 기능
- **날짜별 입출금 매트릭스**: 이미지처럼 날짜 vs 위치별 IN/OUT 표시
- **위치별 현재 잔액 요약**: 각 현금 보관 위치의 현재 잔액
- **통화별 그룹핑**: KRW(₩), VND(₫), CNY(¥), USD($) 등 통화별 분리
- **필터링**: 날짜 범위, 매장, 위치 타입(cash/vault/bank) 필터
- **Excel 내보내기**: 데이터 다운로드 기능

---

## 2. Database Schema (Existing)

### 2.1 `cash_amount_entries` Table
```sql
- entry_id: uuid (PK)
- company_id: uuid
- store_id: uuid
- location_id: uuid (FK → cash_locations)
- entry_type: varchar ('cash', 'vault', 'bank')
- transaction_type: varchar
- currency_id: uuid
- balance_before: numeric
- balance_after: numeric
- net_cash_flow: numeric (+ = IN, - = OUT)
- record_date: date
- description: text
- created_at: timestamp
```

### 2.2 `cash_locations` Table
```sql
- cash_location_id: uuid (PK)
- company_id: uuid
- store_id: uuid
- location_name: text
- location_type: text ('cash', 'vault', 'bank', 'digital_wallet')
- currency_code: text
- currency_id: uuid
- is_deleted: boolean
```

### 2.3 Required RPC Function
```sql
-- get_cash_balance_matrix
-- Parameters: p_company_id, p_start_date, p_end_date, p_store_ids[], p_location_types[]
-- Returns: date, location_id, location_name, currency_code, in_amount, out_amount, balance
```

---

## 3. Directory Structure

```
website/src/features/cash-balance/
├── domain/
│   ├── entities/
│   │   ├── CashBalanceEntry.ts      # 개별 입출금 엔트리
│   │   ├── CashLocation.ts          # 현금 보관 위치
│   │   └── CashBalanceMatrix.ts     # 매트릭스 데이터 구조
│   ├── repositories/
│   │   └── ICashBalanceRepository.ts
│   └── validators/
│       └── CashBalanceValidator.ts
│
├── data/
│   ├── datasources/
│   │   └── CashBalanceDataSource.ts  # Supabase RPC 호출
│   ├── models/
│   │   ├── CashBalanceEntryModel.ts  # DTO + Mapper
│   │   └── CashLocationModel.ts
│   └── repositories/
│       └── CashBalanceRepositoryImpl.ts
│
└── presentation/
    ├── providers/
    │   ├── states/
    │   │   └── cash_balance_state.ts  # Zustand store state
    │   └── cash_balance_provider.ts   # Zustand store
    │
    ├── hooks/
    │   ├── useCashBalanceMatrix.ts    # 매트릭스 데이터 fetch
    │   ├── useCashBalanceFilter.ts    # 필터 상태 관리
    │   └── useCashBalanceExport.ts    # Excel 내보내기
    │
    ├── components/
    │   ├── CashBalanceHeader/
    │   │   ├── CashBalanceHeader.tsx
    │   │   ├── CashBalanceHeader.module.css
    │   │   └── CashBalanceHeader.types.ts
    │   │
    │   ├── CashBalanceMatrix/         # 스프레드시트 형태 테이블
    │   │   ├── CashBalanceMatrix.tsx
    │   │   ├── CashBalanceMatrix.module.css
    │   │   └── CashBalanceMatrix.types.ts
    │   │
    │   ├── CashBalanceSummary/        # 위치별 잔액 요약 카드
    │   │   ├── CashBalanceSummary.tsx
    │   │   ├── CashBalanceSummary.module.css
    │   │   └── CashBalanceSummary.types.ts
    │   │
    │   ├── CashBalanceFilter/         # 날짜/매장/타입 필터
    │   │   ├── CashBalanceFilter.tsx
    │   │   ├── CashBalanceFilter.module.css
    │   │   └── CashBalanceFilter.types.ts
    │   │
    │   └── LocationColumn/            # 개별 위치 컬럼 렌더링
    │       ├── LocationColumn.tsx
    │       └── LocationColumn.types.ts
    │
    └── pages/
        └── CashBalancePage/
            ├── CashBalancePage.tsx
            ├── CashBalancePage.module.css
            └── index.ts
```

---

## 4. Implementation Details

### 4.1 Domain Layer

#### CashBalanceEntry Entity
```typescript
// domain/entities/CashBalanceEntry.ts
export class CashBalanceEntry {
  constructor(
    public readonly entryId: string,
    public readonly recordDate: Date,
    public readonly locationId: string,
    public readonly locationName: string,
    public readonly locationType: 'cash' | 'vault' | 'bank' | 'digital_wallet',
    public readonly currencyCode: string,
    public readonly inAmount: number,
    public readonly outAmount: number,
    public readonly balance: number
  ) {}

  get netFlow(): number {
    return this.inAmount - this.outAmount;
  }

  get hasActivity(): boolean {
    return this.inAmount > 0 || this.outAmount > 0;
  }

  formatAmount(amount: number): string {
    const symbols: Record<string, string> = {
      KRW: '₩', VND: '₫', CNY: '¥', USD: '$', JPY: '¥'
    };
    const symbol = symbols[this.currencyCode] || this.currencyCode;
    return `${symbol}${amount.toLocaleString()}`;
  }
}
```

#### CashBalanceMatrix Entity
```typescript
// domain/entities/CashBalanceMatrix.ts
export interface MatrixCell {
  date: string;           // 'YYYY-MM-DD'
  locationId: string;
  inAmount: number;
  outAmount: number;
}

export class CashBalanceMatrix {
  constructor(
    public readonly dates: string[],           // 행 (날짜들)
    public readonly locations: CashLocation[], // 열 (위치들)
    public readonly cells: Map<string, MatrixCell>, // key: 'date|locationId'
    public readonly currencyTotals: Map<string, number> // 통화별 총합
  ) {}

  getCell(date: string, locationId: string): MatrixCell | null {
    return this.cells.get(`${date}|${locationId}`) || null;
  }

  getLocationTotal(locationId: string): { in: number; out: number } {
    let inTotal = 0, outTotal = 0;
    this.dates.forEach(date => {
      const cell = this.getCell(date, locationId);
      if (cell) {
        inTotal += cell.inAmount;
        outTotal += cell.outAmount;
      }
    });
    return { in: inTotal, out: outTotal };
  }
}
```

### 4.2 Data Layer

#### CashBalanceDataSource
```typescript
// data/datasources/CashBalanceDataSource.ts
import { supabase } from '@/core/services/supabase.service';

export interface FetchMatrixParams {
  companyId: string;
  startDate: string;
  endDate: string;
  storeIds?: string[];
  locationTypes?: string[];
}

export class CashBalanceDataSource {
  async fetchMatrixData(params: FetchMatrixParams): Promise<CashBalanceEntryDTO[]> {
    const { data, error } = await supabase.rpc('get_cash_balance_matrix', {
      p_company_id: params.companyId,
      p_start_date: params.startDate,
      p_end_date: params.endDate,
      p_store_ids: params.storeIds || null,
      p_location_types: params.locationTypes || null
    });

    if (error) throw new Error(error.message);
    return data || [];
  }

  async fetchLocations(companyId: string): Promise<CashLocationDTO[]> {
    const { data, error } = await supabase
      .from('cash_locations')
      .select('*')
      .eq('company_id', companyId)
      .or('is_deleted.is.null,is_deleted.eq.false')
      .order('location_name');

    if (error) throw new Error(error.message);
    return data || [];
  }

  async fetchCurrentBalances(companyId: string): Promise<LocationBalanceDTO[]> {
    // 각 위치의 가장 최근 balance_after 조회
    const { data, error } = await supabase.rpc('get_current_cash_balances', {
      p_company_id: companyId
    });

    if (error) throw new Error(error.message);
    return data || [];
  }
}
```

### 4.3 Presentation Layer

#### Zustand Store
```typescript
// presentation/providers/cash_balance_provider.ts
import { create } from 'zustand';

interface CashBalanceState {
  // Data
  matrix: CashBalanceMatrix | null;
  locations: CashLocation[];
  currentBalances: Map<string, number>;

  // Filter
  dateRange: { start: Date; end: Date };
  selectedStores: string[];
  selectedLocationTypes: string[];
  selectedCurrency: string | null;

  // UI State
  isLoading: boolean;
  error: string | null;
  viewMode: 'matrix' | 'summary';

  // Actions
  setDateRange: (start: Date, end: Date) => void;
  setSelectedStores: (storeIds: string[]) => void;
  setSelectedLocationTypes: (types: string[]) => void;
  setSelectedCurrency: (currency: string | null) => void;
  setViewMode: (mode: 'matrix' | 'summary') => void;
  fetchData: () => Promise<void>;
  reset: () => void;
}

export const useCashBalanceStore = create<CashBalanceState>((set, get) => ({
  // ... implementation
}));
```

#### Main Page Component
```typescript
// presentation/pages/CashBalancePage/CashBalancePage.tsx
import { CashBalanceHeader } from '../components/CashBalanceHeader';
import { CashBalanceFilter } from '../components/CashBalanceFilter';
import { CashBalanceMatrix } from '../components/CashBalanceMatrix';
import { CashBalanceSummary } from '../components/CashBalanceSummary';
import { useCashBalanceStore } from '../providers/cash_balance_provider';

export const CashBalancePage: React.FC = () => {
  const { viewMode, isLoading, error, fetchData } = useCashBalanceStore();

  useEffect(() => {
    fetchData();
  }, []);

  return (
    <TossScaffold>
      <CashBalanceHeader />
      <CashBalanceFilter />

      {isLoading && <TossLoadingView />}
      {error && <TossErrorView message={error} />}

      {!isLoading && !error && (
        viewMode === 'matrix'
          ? <CashBalanceMatrix />
          : <CashBalanceSummary />
      )}
    </TossScaffold>
  );
};
```

---

## 5. UI Design

### 5.1 Matrix View (스프레드시트)
```
┌─────────┬──────────────┬──────────────┬──────────────┬─────────────┐
│  DATE   │    LUX 1     │  LUX 2 JEONG │  MAISON JIN  │   WECHAT    │
│         │     ₩        │      ₩       │      ₩       │     ¥       │
├─────────┼──────────────┼──────────────┼──────────────┼─────────────┤
│  12/1   │              │              │              │             │
│  12/1   │   ₩320,000   │              │              │             │
│  12/1   │   ₩970,000   │              │              │             │
├─────────┼──────────────┼──────────────┼──────────────┼─────────────┤
│  12/2   │   ₩69,275    │              │              │             │
│  12/2   │              │              │              │  ¥294,600   │
├─────────┼──────────────┼──────────────┼──────────────┼─────────────┤
│  TOTAL  │ ₩12,345,000  │  ₩5,600,000  │  ₩8,900,000  │  ¥500,000   │
└─────────┴──────────────┴──────────────┴──────────────┴─────────────┘
```

### 5.2 Summary View (카드)
```
┌─────────────────────────────────────────────────────────────────────┐
│  💰 Cash Balance Summary                           Total: ₩45,678,900│
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐ │
│  │ 💵 LUX 1    │  │ 💵 LUX 2    │  │ 🏦 SHINHAN  │  │ 📱 WECHAT   │ │
│  │ ₩12,345,000 │  │ ₩8,765,000  │  │ ₩15,000,000 │  │ ¥500,000    │ │
│  │ +₩320,000 ↑ │  │ -₩150,000 ↓ │  │ +₩1,000,000 │  │ +¥50,000    │ │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘ │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### 5.3 Color Coding
- **IN (입금)**: `TossColors.blue500` - 파란색
- **OUT (출금)**: `TossColors.red500` - 빨간색
- **Balance 증가**: `TossColors.green500` - 초록색
- **Balance 감소**: `TossColors.orange500` - 주황색

---

## 6. Required Supabase RPC Functions

### 6.1 `get_cash_balance_matrix`
```sql
CREATE OR REPLACE FUNCTION get_cash_balance_matrix(
  p_company_id UUID,
  p_start_date DATE,
  p_end_date DATE,
  p_store_ids UUID[] DEFAULT NULL,
  p_location_types TEXT[] DEFAULT NULL
)
RETURNS TABLE (
  record_date DATE,
  location_id UUID,
  location_name TEXT,
  location_type TEXT,
  currency_code TEXT,
  in_amount NUMERIC,
  out_amount NUMERIC,
  daily_balance NUMERIC
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    e.record_date,
    e.location_id,
    l.location_name,
    l.location_type,
    COALESCE(l.currency_code, 'VND') as currency_code,
    SUM(CASE WHEN e.net_cash_flow > 0 THEN e.net_cash_flow ELSE 0 END) as in_amount,
    SUM(CASE WHEN e.net_cash_flow < 0 THEN ABS(e.net_cash_flow) ELSE 0 END) as out_amount,
    MAX(e.balance_after) as daily_balance
  FROM cash_amount_entries e
  JOIN cash_locations l ON e.location_id = l.cash_location_id
  WHERE e.company_id = p_company_id
    AND e.record_date BETWEEN p_start_date AND p_end_date
    AND (p_store_ids IS NULL OR e.store_id = ANY(p_store_ids))
    AND (p_location_types IS NULL OR l.location_type = ANY(p_location_types))
  GROUP BY e.record_date, e.location_id, l.location_name, l.location_type, l.currency_code
  ORDER BY e.record_date, l.location_name;
END;
$$ LANGUAGE plpgsql;
```

### 6.2 `get_current_cash_balances`
```sql
CREATE OR REPLACE FUNCTION get_current_cash_balances(
  p_company_id UUID
)
RETURNS TABLE (
  location_id UUID,
  location_name TEXT,
  location_type TEXT,
  currency_code TEXT,
  current_balance NUMERIC,
  last_updated DATE
) AS $$
BEGIN
  RETURN QUERY
  WITH latest_entries AS (
    SELECT DISTINCT ON (e.location_id)
      e.location_id,
      e.balance_after,
      e.record_date
    FROM cash_amount_entries e
    WHERE e.company_id = p_company_id
    ORDER BY e.location_id, e.record_date DESC, e.created_at DESC
  )
  SELECT
    l.cash_location_id as location_id,
    l.location_name,
    l.location_type,
    COALESCE(l.currency_code, 'VND') as currency_code,
    COALESCE(le.balance_after, 0) as current_balance,
    le.record_date as last_updated
  FROM cash_locations l
  LEFT JOIN latest_entries le ON l.cash_location_id = le.location_id
  WHERE l.company_id = p_company_id
    AND (l.is_deleted IS NULL OR l.is_deleted = false)
  ORDER BY l.location_type, l.location_name;
END;
$$ LANGUAGE plpgsql;
```

---

## 7. Implementation Steps

### Phase 1: Backend (Supabase)
- [ ] `get_cash_balance_matrix` RPC 함수 생성
- [ ] `get_current_cash_balances` RPC 함수 생성
- [ ] RPC 함수 테스트

### Phase 2: Domain Layer
- [ ] `CashBalanceEntry` Entity 생성
- [ ] `CashLocation` Entity 생성
- [ ] `CashBalanceMatrix` Entity 생성
- [ ] `ICashBalanceRepository` Interface 생성

### Phase 3: Data Layer
- [ ] `CashBalanceEntryModel` DTO + Mapper 생성
- [ ] `CashLocationModel` DTO + Mapper 생성
- [ ] `CashBalanceDataSource` 구현
- [ ] `CashBalanceRepositoryImpl` 구현

### Phase 4: Presentation Layer
- [ ] Zustand Store 구현 (`cash_balance_provider.ts`)
- [ ] `useCashBalanceMatrix` Hook 구현
- [ ] `useCashBalanceFilter` Hook 구현
- [ ] `useCashBalanceExport` Hook 구현

### Phase 5: UI Components
- [ ] `CashBalanceHeader` 컴포넌트
- [ ] `CashBalanceFilter` 컴포넌트
- [ ] `CashBalanceMatrix` 컴포넌트 (스프레드시트)
- [ ] `CashBalanceSummary` 컴포넌트 (카드뷰)
- [ ] `LocationColumn` 컴포넌트

### Phase 6: Page & Routing
- [ ] `CashBalancePage` 구현
- [ ] Route 등록 (`/cash-balance`)
- [ ] Navigation 메뉴에 추가

### Phase 7: Polish
- [ ] Excel 내보내기 기능
- [ ] 반응형 디자인
- [ ] 로딩/에러 상태 처리
- [ ] 테스트

---

## 8. Dependencies

### New Packages (if needed)
```json
{
  "xlsx": "^0.18.5",          // Excel 내보내기
  "date-fns": "^3.0.0"        // 날짜 처리 (이미 있을 수 있음)
}
```

---

## 9. Notes

### 9.1 Performance Considerations
- 날짜 범위가 클 경우 페이지네이션 또는 가상 스크롤 적용
- 위치가 많을 경우 가로 스크롤 with 고정 헤더

### 9.2 Future Enhancements
- 차트 뷰 추가 (통화별 추이 그래프)
- 위치 간 이체 내역 하이라이트
- 알림 설정 (특정 잔액 이하 시)

---

**작성자**: Claude
**마지막 수정**: 2024-12-24
