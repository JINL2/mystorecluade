# ConfirmModal Component

Toss Design System 기반의 범용 확인 모달 컴포넌트입니다. 비동기 작업, 커스텀 콘텐츠, 다양한 스타일 변형을 지원합니다.

## Features

- ✅ **비동기 작업 지원**: Promise 기반 onConfirm 핸들러
- ✅ **로딩 상태**: 비동기 작업 중 자동 로딩 표시
- ✅ **4가지 변형**: info, warning, error, success
- ✅ **커스텀 콘텐츠**: children prop으로 자유로운 레이아웃
- ✅ **완전히 커스터마이징 가능**: 색상, 아이콘, 텍스트 등 모든 요소 변경 가능
- ✅ **Toss 디자인 시스템 준수**: 색상, 타이포그래피, 스페이싱 모두 준수
- ✅ **반응형 디자인**: 모바일/태블릿/데스크톱 지원
- ✅ **접근성**: ESC 키, 키보드 네비게이션 지원

## Import

```typescript
import { ConfirmModal } from '@/shared/components/common/ConfirmModal';
```

## Basic Usage

### 기본 확인 모달

```tsx
const [isOpen, setIsOpen] = useState(false);

<ConfirmModal
  isOpen={isOpen}
  onClose={() => setIsOpen(false)}
  onConfirm={() => {
    console.log('Confirmed!');
    setIsOpen(false);
  }}
  title="Delete Item"
  message="Are you sure you want to delete this item?"
/>
```

### 비동기 작업 (RPC 호출 등)

```tsx
const [isOpen, setIsOpen] = useState(false);

const handleConfirm = async () => {
  // RPC 호출
  const { data, error } = await supabase.rpc('delete_item', { id: itemId });

  if (error) {
    alert('Failed to delete');
    return false;
  }

  alert('Deleted successfully');
  setIsOpen(false);
  return true;
};

<ConfirmModal
  isOpen={isOpen}
  onClose={() => setIsOpen(false)}
  onConfirm={handleConfirm}
  title="Delete Item"
  message="This action cannot be undone."
  variant="error"
  confirmButtonVariant="error"
/>
```

## Props Reference

### Required Props

| Prop | Type | Description |
|------|------|-------------|
| `isOpen` | `boolean` | 모달 열림/닫힘 상태 |
| `onClose` | `() => void` | 모달 닫기/취소 콜백 |
| `onConfirm` | `() => void \| Promise<void \| boolean>` | 확인 버튼 클릭 콜백 (동기/비동기 지원) |
| `title` | `string` | 모달 헤더 제목 |

### Optional Props - Styling

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `variant` | `'info' \| 'warning' \| 'error' \| 'success'` | `'info'` | 모달 변형 (헤더 색상 결정) |
| `headerBackground` | `string` | varies | 헤더 배경색 (variant 기본값 오버라이드) |
| `width` | `string` | `'500px'` | 모달 최대 너비 |
| `className` | `string` | `''` | 추가 CSS 클래스 |
| `zIndex` | `number` | `1000` | z-index 값 |

**Variant별 기본 헤더 색상:**
- `info`: `#4169E1` (파란색)
- `warning`: `#FF9500` (주황색)
- `error`: `#FF5847` (빨간색)
- `success`: `#00C896` (초록색)

### Optional Props - Header

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `headerIcon` | `React.ReactNode` | variant icon | 헤더 아이콘 (variant 기본 아이콘 오버라이드) |

### Optional Props - Warning Section

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `message` | `string` | - | 경고 메시지 (제공 시 경고 섹션 자동 표시) |
| `messageIcon` | `React.ReactNode` | warning icon | 경고 섹션 아이콘 |
| `showWarningSection` | `boolean` | `true` if message | 경고 섹션 표시 여부 |
| `warningSectionBackground` | `string` | `'#FFF9E6'` | 경고 섹션 배경색 |
| `warningSectionBorder` | `string` | `'#FFE5B4'` | 경고 섹션 테두리 색상 |

### Optional Props - Content

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `React.ReactNode` | - | 커스텀 콘텐츠 (자유로운 레이아웃) |

### Optional Props - Buttons

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `confirmText` | `string` | `'OK'` | 확인 버튼 텍스트 |
| `cancelText` | `string` | `'Cancel'` | 취소 버튼 텍스트 |
| `confirmButtonVariant` | `'primary' \| 'error' \| 'success' \| 'warning'` | `'error'` | 확인 버튼 색상 변형 |
| `showConfirmIcon` | `boolean` | `true` | 확인 버튼 아이콘 표시 여부 |
| `confirmIcon` | `React.ReactNode` | checkmark | 확인 버튼 커스텀 아이콘 |

**Confirm Button Variant 색상:**
- `primary`: `#0064FF` (Toss Blue)
- `error`: `#dc3545` (Red)
- `success`: `#00C896` (Toss Green)
- `warning`: `#FF9500` (Toss Orange)

### Optional Props - Behavior

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `isLoading` | `boolean` | `false` | 로딩 상태 (비동기 작업 중) |
| `closeOnBackdropClick` | `boolean` | `false` | 배경 클릭 시 닫기 |
| `closeOnEscape` | `boolean` | `true` | ESC 키로 닫기 |

## Usage Examples

### 1. Simple Delete Confirmation

```tsx
<ConfirmModal
  isOpen={isDeleteOpen}
  onClose={() => setIsDeleteOpen(false)}
  onConfirm={handleDelete}
  variant="error"
  title="Delete Item"
  message="Are you sure you want to delete this item? This action cannot be undone."
  confirmText="Delete"
  confirmButtonVariant="error"
/>
```

### 2. Custom Content (Location + Variance)

```tsx
<ConfirmModal
  isOpen={isOpen}
  onClose={() => setIsOpen(false)}
  onConfirm={handleCreateJournal}
  variant="info"
  title="Make Error"
  message="Are you sure you want to create this journal entry?"
>
  {/* Custom content */}
  <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
    <div style={{ display: 'flex', justifyContent: 'space-between' }}>
      <span style={{ fontWeight: 600, color: '#6C757D' }}>Location:</span>
      <span style={{ fontWeight: 600, color: '#212529' }}>Cashier</span>
    </div>
    <div style={{ display: 'flex', justifyContent: 'space-between' }}>
      <span style={{ fontWeight: 600, color: '#6C757D' }}>Variance:</span>
      <span style={{ fontFamily: 'JetBrains Mono', fontWeight: 700, color: '#FF5847' }}>
        100,000 ₫
      </span>
    </div>
  </div>
</ConfirmModal>
```

### 3. Async Action with Loading State

```tsx
const [isLoading, setIsLoading] = useState(false);

const handleConfirm = async () => {
  setIsLoading(true);

  try {
    const { error } = await supabase.rpc('complex_operation', params);

    if (error) throw error;

    alert('Success!');
    setIsOpen(false);
  } catch (error) {
    alert('Failed: ' + error.message);
  } finally {
    setIsLoading(false);
  }
};

<ConfirmModal
  isOpen={isOpen}
  onClose={() => setIsOpen(false)}
  onConfirm={handleConfirm}
  isLoading={isLoading}
  title="Process Transaction"
  message="This will process the transaction immediately."
/>
```

### 4. Success Confirmation

```tsx
<ConfirmModal
  isOpen={isSuccessOpen}
  onClose={() => setIsSuccessOpen(false)}
  onConfirm={() => setIsSuccessOpen(false)}
  variant="success"
  title="Success"
  message="Operation completed successfully!"
  confirmText="OK"
  confirmButtonVariant="success"
  showConfirmIcon={false}
  cancelText="Close"
/>
```

### 5. Custom Header Color

```tsx
<ConfirmModal
  isOpen={isOpen}
  onClose={() => setIsOpen(false)}
  onConfirm={handleConfirm}
  title="Custom Modal"
  headerBackground="#8B5CF6" // Purple
  message="This modal has a custom purple header."
/>
```

### 6. No Warning Section

```tsx
<ConfirmModal
  isOpen={isOpen}
  onClose={() => setIsOpen(false)}
  onConfirm={handleConfirm}
  title="Simple Confirmation"
  showWarningSection={false}
>
  <p>This is custom content without a warning section.</p>
</ConfirmModal>
```

### 7. Custom Icons

```tsx
<ConfirmModal
  isOpen={isOpen}
  onClose={() => setIsOpen(false)}
  onConfirm={handleConfirm}
  title="Transfer Money"
  headerIcon={
    <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
      <path d="M12,8A4,4 0 0,1 16,12A4,4 0 0,1 12,16A4,4 0 0,1 8,12A4,4 0 0,1 12,8M12,10A2,2 0 0,0 10,12A2,2 0 0,0 12,14A2,2 0 0,0 14,12A2,2 0 0,0 12,10Z" />
    </svg>
  }
  message="Confirm money transfer"
/>
```

## Design System Compliance

### Colors
- **Toss Blue**: `#0064FF` (Primary)
- **Toss Red**: `#FF5847` (Error)
- **Toss Green**: `#00C896` (Success)
- **Toss Orange**: `#FF9500` (Warning)
- **Gray Scale**: `#212529`, `#6C757D`, `#ADB5BD`, `#DEE2E6`, `#F8F9FA`

### Typography
- **Title**: 20px, Bold (700)
- **Message**: 14px, Medium (500)
- **Button**: 16px, Medium (500)

### Spacing
- **Padding**: 16px, 20px, 24px (Toss 4px grid system)
- **Gap**: 8px, 12px, 16px
- **Border Radius**: 8px (buttons), 12px (modal)

### Shadows
- **Modal**: `0 8px 24px rgba(0, 0, 0, 0.08)` (Level 4)

### Transitions
- **Fast**: `150ms ease`
- **Base**: `250ms ease`

## Best Practices

### ✅ Do
- ✅ 비동기 작업에는 `isLoading` 상태 사용
- ✅ 파괴적 작업에는 `variant="error"` + `confirmButtonVariant="error"` 사용
- ✅ 명확한 메시지 제공
- ✅ 커스텀 콘텐츠는 `children` 사용

### ❌ Don't
- ❌ `closeOnBackdropClick={true}`를 파괴적 작업에 사용하지 말 것
- ❌ 너무 긴 메시지 사용하지 말 것
- ❌ 여러 모달 동시에 열지 말 것

## Accessibility

- ✅ ESC 키로 닫기 (기본값)
- ✅ 키보드 네비게이션 지원
- ✅ 로딩 중 버튼 비활성화
- ✅ ARIA attributes 적용

## File Structure

```
ConfirmModal/
├── ConfirmModal.tsx          # 메인 컴포넌트
├── ConfirmModal.types.ts     # TypeScript 타입 정의
├── ConfirmModal.module.css   # 스타일
├── index.ts                  # Barrel export
└── README.md                 # 이 문서
```

## Migration from CashEndingConfirmModal

기존 `CashEndingConfirmModal`을 `ConfirmModal`로 교체:

**Before:**
```tsx
<CashEndingConfirmModal
  isOpen={isOpen}
  onClose={onClose}
  onConfirm={onConfirm}
  title="Make Error"
  locationName="Cashier"
  variance={100000}
  type="error"
  isLoading={isLoading}
/>
```

**After:**
```tsx
<ConfirmModal
  isOpen={isOpen}
  onClose={onClose}
  onConfirm={onConfirm}
  title="Make Error"
  message="Are you sure you want to create this journal entry?"
  variant="info"
  confirmButtonVariant="error"
  isLoading={isLoading}
>
  <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
    <div style={{ display: 'flex', justifyContent: 'space-between' }}>
      <span style={{ fontWeight: 600, color: '#6C757D' }}>Location:</span>
      <span style={{ fontWeight: 600, color: '#212529' }}>Cashier</span>
    </div>
    <div style={{ display: 'flex', justifyContent: 'space-between' }}>
      <span style={{ fontWeight: 600, color: '#6C757D' }}>Variance:</span>
      <span style={{ fontFamily: 'JetBrains Mono', fontWeight: 700, color: '#FF5847' }}>
        100,000 ₫
      </span>
    </div>
  </div>
</ConfirmModal>
```
