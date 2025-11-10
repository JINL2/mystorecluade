# ErrorMessage Component

Toss 스타일의 공용 에러/알림 메시지 컴포넌트입니다.

## 특징

- ✅ **Toss 디자인 시스템** 기반의 깔끔한 디자인
- ✅ **4가지 변형** (error, warning, info, success)
- ✅ **유연한 위치 설정** (9가지 위치)
- ✅ **자동 닫기** 기능
- ✅ **백드롭 오버레이** 지원
- ✅ **커스텀 액션 버튼**
- ✅ **완전히 커스터마이징 가능**
- ✅ **React Hook** 지원 (useErrorMessage)
- ✅ **반응형** 디자인
- ✅ **다크모드** 지원
- ✅ **키보드 접근성** (ESC로 닫기)

## 기본 사용법

### 1. Hook을 사용한 방법 (권장)

```tsx
import { useErrorMessage } from '@/shared/hooks/useErrorMessage';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';

function MyComponent() {
  const { messageState, closeMessage, showError, showWarning, showInfo, showSuccess } = useErrorMessage();

  const handlePermissionDenied = () => {
    showError({
      title: '접근 권한 없음',
      message: '이 페이지에 접근할 권한이 없습니다.',
      details: '필요한 권한: journal_input',
    });
  };

  return (
    <>
      <button onClick={handlePermissionDenied}>테스트</button>

      <ErrorMessage
        variant={messageState.variant}
        title={messageState.title}
        message={messageState.message}
        details={messageState.details}
        isOpen={messageState.isOpen}
        onClose={closeMessage}
        position={messageState.position}
        autoCloseDuration={messageState.autoCloseDuration}
      />
    </>
  );
}
```

### 2. 직접 사용하는 방법

```tsx
import { useState } from 'react';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';

function MyComponent() {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <ErrorMessage
      variant="error"
      title="오류 발생"
      message="요청을 처리할 수 없습니다."
      isOpen={isOpen}
      onClose={() => setIsOpen(false)}
    />
  );
}
```

## 사용 예제

### 1. 권한 거부 에러

```tsx
showError({
  title: '접근 권한 없음',
  message: '이 페이지에 접근할 권한이 없습니다.',
  details: 'Required permission: journal_input',
  actionText: '대시보드로 이동',
  onAction: () => navigate('/dashboard'),
});
```

### 2. 경고 메시지

```tsx
showWarning({
  title: '저장되지 않은 변경사항',
  message: '변경사항이 저장되지 않았습니다. 계속하시겠습니까?',
  actionText: '저장하지 않고 나가기',
  onAction: () => navigate('/'),
});
```

### 3. 정보 메시지

```tsx
showInfo({
  title: '업데이트 안내',
  message: '새로운 기능이 추가되었습니다.',
  autoCloseDuration: 5000, // 5초 후 자동 닫기
  position: 'top-right',
});
```

### 4. 성공 메시지

```tsx
showSuccess({
  title: '저장 완료',
  message: '변경사항이 성공적으로 저장되었습니다.',
  autoCloseDuration: 3000,
  position: 'bottom-center',
});
```

### 5. 커스텀 아이콘

```tsx
<ErrorMessage
  variant="error"
  message="커스텀 아이콘 예제"
  icon={<CustomIcon />}
  isOpen={isOpen}
  onClose={() => setIsOpen(false)}
/>
```

### 6. 백드롭 없이 표시

```tsx
showInfo({
  message: '백그라운드 알림',
  showBackdrop: false,
  position: 'top-right',
  autoCloseDuration: 4000,
});
```

## Props

### ErrorMessageProps

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `variant` | `'error' \| 'warning' \| 'info' \| 'success'` | `'error'` | 메시지 타입 |
| `title` | `string?` | - | 제목 (선택) |
| `message` | `string` | **required** | 메시지 내용 |
| `details` | `string?` | - | 상세 정보 (선택) |
| `isOpen` | `boolean` | **required** | 표시 상태 |
| `onClose` | `() => void` | **required** | 닫기 콜백 |
| `autoCloseDuration` | `number` | `0` | 자동 닫기 시간 (ms), 0이면 비활성화 |
| `position` | `ErrorMessagePosition` | `'center'` | 화면 위치 |
| `icon` | `ReactNode?` | - | 커스텀 아이콘 |
| `showCloseButton` | `boolean` | `true` | 닫기 버튼 표시 |
| `actionText` | `string?` | - | 액션 버튼 텍스트 |
| `onAction` | `() => void?` | - | 액션 버튼 콜백 |
| `className` | `string` | `''` | 추가 CSS 클래스 |
| `zIndex` | `number?` | - | z-index 오버라이드 |
| `showBackdrop` | `boolean` | `true` | 백드롭 표시 |
| `closeOnBackdropClick` | `boolean` | `true` | 백드롭 클릭으로 닫기 |

### ErrorMessagePosition

```typescript
type ErrorMessagePosition =
  | 'top-center'
  | 'top-right'
  | 'top-left'
  | 'bottom-center'
  | 'bottom-right'
  | 'bottom-left'
  | 'center';
```

## Hook API

### useErrorMessage()

```typescript
const {
  messageState,    // 현재 메시지 상태
  closeMessage,    // 메시지 닫기 함수
  showError,       // 에러 메시지 표시
  showWarning,     // 경고 메시지 표시
  showInfo,        // 정보 메시지 표시
  showSuccess,     // 성공 메시지 표시
} = useErrorMessage();
```

## 스타일 커스터마이징

CSS Module을 사용하여 스타일을 오버라이드할 수 있습니다:

```tsx
import customStyles from './MyCustomStyles.module.css';

<ErrorMessage
  className={customStyles.myCustomMessage}
  // ...
/>
```

## 접근성

- `role="alert"` 속성으로 스크린 리더 지원
- `aria-live="assertive"` 속성으로 즉시 알림
- ESC 키로 닫기 가능
- 키보드 포커스 관리

## 디자인 토큰

컴포넌트는 다음의 Toss 디자인 토큰을 사용합니다:

- `--toss-error`: #FF5847
- `--toss-warning`: #FF9500
- `--toss-info`: #0064FF
- `--toss-success`: #00C896
- `--toss-overlay`: rgba(0, 0, 0, 0.54)
- `--shadow-modal`: 0 8px 24px rgba(0, 0, 0, 0.08)
- `--radius-dialog`: 16px
- `--z-modal-backdrop`: 400
- `--z-toast`: 800

## 권장 사용 사례

### 1. 권한 체크 실패
```tsx
showError({
  title: '접근 권한 없음',
  message: '이 기능을 사용할 권한이 없습니다.',
  details: `Required: ${requiredPermission}`,
});
```

### 2. API 에러
```tsx
showError({
  title: '요청 실패',
  message: error.message,
  details: error.code,
});
```

### 3. 폼 검증 실패
```tsx
showWarning({
  title: '입력 확인',
  message: '필수 항목을 모두 입력해주세요.',
});
```

### 4. 성공적인 작업 완료
```tsx
showSuccess({
  message: '저장되었습니다.',
  autoCloseDuration: 2000,
  position: 'top-center',
});
```
