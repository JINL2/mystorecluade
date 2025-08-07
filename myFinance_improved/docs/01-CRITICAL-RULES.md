# 🚨 절대 규칙 - 반드시 준수

## ❌ 절대 금지 사항

### 1. AppState 기존 필드 수정 금지
- **파일**: `/lib/presentation/providers/app_state_provider.dart`
- 기존 필드의 이름, 타입, 삭제 절대 금지
- 새 필드 추가만 가능

### 2. Theme 직접 수정 금지
- **폴더**: `/lib/core/themes/`
- 직접 색상 코드 사용 금지 `Color(0xFF...)`
- 직접 숫자 패딩 사용 금지 `EdgeInsets.all(16)`

### 3. RPC 함수명 변경 금지
- Supabase RPC 함수는 백엔드와 동기화됨
- 함수명 변경 시 전체 시스템 에러 발생

### 4. Main 브랜치 직접 Push 금지
- 항상 feature 브랜치 생성
- Pull Request 통해서만 머지

## ✅ 필수 사용 규칙

### 1. Theme 시스템 사용
```dart
// ✅ 올바른 사용
Container(
  color: TossColors.gray50,
  padding: EdgeInsets.all(TossSpacing.md),
  child: Text('Hello', style: TossTextStyles.body),
)

// ❌ 잘못된 사용
Container(
  color: Color(0xFFF5F5F5),  // 직접 색상 금지
  padding: EdgeInsets.all(16), // 직접 숫자 금지
)
```

### 2. Repository 패턴 준수
- 모든 데이터 접근은 Repository 통해서만
- 직접 Supabase 호출 금지 (Provider 제외)

### 3. Freezed 모델 사용
- 모든 데이터 모델은 Freezed 사용
- `flutter pub run build_runner build --delete-conflicting-outputs`

### 4. 에러 처리 필수
- try-catch로 모든 API 호출 감싸기
- 사용자 친화적 에러 메시지 표시