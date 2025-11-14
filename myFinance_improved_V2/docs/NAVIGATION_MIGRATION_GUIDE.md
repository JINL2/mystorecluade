# 🧭 Navigation Migration Guide

> **목표**: 전체 프로젝트의 네비게이션을 GoRouter로 통일하여 안정성과 유지보수성 향상

**작성일**: 2025-01-10
**상태**: 진행 중
**우선순위**: 높음

---

## 📊 현재 상황 분석

### 전체 통계
```
총 Dart 파일: 765개
Navigator.pop() 사용: 147번 (40개 파일)
Modal/Dialog 사용: 287번
GoRouter 경로: 28개
```

### 문제 심각도 분류

#### 🔴 HIGH (즉시 수정 필요)
**GoRouter 페이지에서 Navigator.pop() 사용 - 4개 파일**
```
1. lib/features/auth/presentation/pages/signup_page.dart (1회)
2. lib/features/auth/presentation/pages/choose_role_page.dart (1회)
3. lib/features/auth/presentation/pages/create_store_page.dart (1회)
4. lib/features/journal_input/presentation/pages/journal_input_page.dart (1회)
```
**문제**: 스택 에러 발생 가능

#### 🟡 MEDIUM (점진적 개선)
**Modal/Dialog에서 Navigator.pop() 사용 - 143번**
```
주요 위치:
- homepage: 26회
- attendance: 15회
- register_denomination: 15회
- delegate_role: 14회
- 기타: 73회
```
**문제**: 없음 (정상 작동), 하지만 통일성을 위해 context.pop()으로 변경 권장

#### 🟢 LOW (현상 유지)
**Dialog 내부의 Navigator.pop() - 대부분**
```
이미 정상 작동 중
변경하지 않아도 문제없음
```

---

## 🎯 마이그레이션 전략

### 3단계 접근법

#### **Phase 1: 긴급 수정 (30분)**
HIGH 우선순위 파일만 수정
- 목표: 에러 제거
- 파일: 4개
- 방법: Navigator.pop() → context.go() 또는 context.pop()

#### **Phase 2: 점진적 통일 (2-3시간)**
MEDIUM 우선순위 파일 수정
- 목표: 코드 통일성
- 파일: 40개
- 방법: Navigator.pop() → context.pop()

#### **Phase 3: 완전 통일 (선택사항)**
모든 Navigator 사용을 GoRouter로 변경
- 목표: 100% GoRouter 사용
- 시간: 4-5시간

---

## 📋 Feature별 분석

### Navigator.pop() 사용 현황

| Feature | 사용 횟수 | 우선순위 | 비고 |
|---------|----------|---------|------|
| homepage | 26 | MEDIUM | Modal 위주 |
| attendance | 15 | MEDIUM | 대부분 Dialog |
| register_denomination | 15 | MEDIUM | Modal 위주 |
| delegate_role | 14 | MEDIUM | Dialog 위주 |
| inventory_management | 11 | MEDIUM | Modal/Dialog |
| journal_input | 11 | HIGH | 메인 페이지 포함 ⚠️ |
| my_page | 10 | MEDIUM | Dialog 위주 |
| counter_party | 8 | MEDIUM | Modal |
| employee_setting | 7 | MEDIUM | Dialog |
| time_table_manage | 7 | MEDIUM | Modal |
| transaction_template | 6 | MEDIUM | Modal |
| auth | 3 | HIGH | GoRouter 페이지 ⚠️ |
| cash_location | 3 | MEDIUM | Modal |

### Modal/Dialog 사용 현황

| Feature | 사용 횟수 | 비고 |
|---------|----------|------|
| inventory_management | 43 | 가장 많음 |
| cash_location | 39 | |
| time_table_manage | 28 | |
| register_denomination | 26 | |
| attendance | 23 | |
| delegate_role | 17 | |
| homepage | 16 | |
| my_page | 14 | |
| store_shift | 13 | |

---

## 🛠️ 수정 가이드

### 규칙 1: GoRouter 페이지 식별

**GoRouter 페이지란?**
```dart
// app_router.dart에 이렇게 정의된 페이지:
GoRoute(
  path: '/auth/login',
  name: 'login',
  builder: (context, state) => const LoginPage(),
)
```

**전체 GoRouter 경로 목록:**
```
/                          (Homepage)
/auth/login               (LoginPage)
/auth/signup              (SignupPage)
/onboarding/choose-role   (ChooseRolePage)
/onboarding/create-business (CreateBusinessPage)
/onboarding/create-store  (CreateStorePage)
/onboarding/join-business (JoinBusinessPage)
/cashEnding               (CashEndingPage)
/cashLocation             (CashLocationPage)
/registerDenomination     (RegisterDenominationPage)
/journal-input            (JournalInputPage)
/employeeSetting          (EmployeeSettingPage)
/transactionHistory       (TransactionHistoryPage)
/attendance               (AttendanceMainPage)
/my-page                  (MyPage)
/edit-profile             (EditProfilePage)
/notifications-settings   (NotificationsSettingsPage)
/privacy-security         (PrivacySecurityPage)
/delegateRolePage         (DelegateRolePage)
/storeShiftSetting        (StoreShiftPage)
/balanceSheet             (BalanceSheetPage)
/registerCounterparty     (CounterPartyPage)
/addFixAsset              (AddFixAssetPage)
/debtControl              (SmartDebtControlPage)
/saleProduct              (SaleProductPage)
/salesInvoice             (SalesInvoicePage)
/inventoryManagement      (InventoryManagementPage)
```

### 규칙 2: 수정 패턴

#### Pattern A: GoRouter 페이지에서 다른 페이지로 이동

**❌ Before:**
```dart
Navigator.of(context).pop();
```

**✅ After:**
```dart
// 방법 1: 명확한 경로 지정 (추천)
context.go('/auth/login');

// 방법 2: 안전한 pop (뒤로가기)
if (context.canPop()) {
  context.pop();
} else {
  context.go('/');  // 홈으로
}
```

#### Pattern B: Modal/Dialog 닫기

**❌ Before:**
```dart
Navigator.of(context).pop();
```

**✅ After:**
```dart
// GoRouter 방식 (추천)
context.pop();

// 또는 기존 방식 유지 (허용)
Navigator.of(context).pop();
```

#### Pattern C: 결과 값 반환

**❌ Before:**
```dart
Navigator.of(context).pop(true);
```

**✅ After:**
```dart
context.pop(true);
```

---

## 🚀 실행 방법

### Phase 1: 긴급 수정 (지금 바로!)

#### 1. signup_page.dart
```bash
# 파일 위치
lib/features/auth/presentation/pages/signup_page.dart

# 수정 라인: 769
```

**수정 내용:**
```dart
// ❌ Before
Navigator.of(context).pop();

// ✅ After
context.go('/auth/login');
```

#### 2. choose_role_page.dart
```bash
# 파일 위치
lib/features/auth/presentation/pages/choose_role_page.dart

# 수정 라인: 361
```

**수정 내용:**
```dart
// ❌ Before (Dialog 안)
Navigator.of(context).pop();

// ✅ After
context.pop();
```

#### 3. create_store_page.dart
```bash
# 파일 위치
lib/features/auth/presentation/pages/create_store_page.dart

# 수정 라인: 266
```

**확인 필요:**
- Dialog 안인지 확인
- GoRouter 페이지로 돌아가는지 확인

#### 4. journal_input_page.dart
```bash
# 파일 위치
lib/features/journal_input/presentation/pages/journal_input_page.dart
```

**확인 필요:**
- 어떤 상황에서 Navigator.pop()을 사용하는지 확인
- context.pop() 또는 context.go()로 변경

---

### Phase 2: 일괄 수정 스크립트

#### 자동 변경 스크립트 (주의해서 사용!)

```bash
#!/bin/bash

# Modal/Dialog 내부의 Navigator.pop()을 context.pop()으로 변경
# 주의: 테스트 후 사용!

echo "⚠️  이 스크립트는 신중하게 사용하세요!"
echo "변경 전에 git commit 하세요!"
echo ""
read -p "계속하시겠습니까? (y/n): " confirm

if [ "$confirm" != "y" ]; then
    echo "취소되었습니다."
    exit 1
fi

# Modal/Dialog 파일에서만 변경 (안전)
find lib/features -name "*_bottom_sheet.dart" -o -name "*_dialog.dart" | while read file; do
    echo "Processing: $file"
    sed -i '' 's/Navigator\.of(context)\.pop()/context.pop()/g' "$file"
done

echo "✅ 완료!"
echo "⚠️  git diff로 변경사항을 확인하세요!"
```

**실행:**
```bash
chmod +x scripts/migrate_navigation.sh
./scripts/migrate_navigation.sh
```

---

## ✅ 검증 방법

### 1. 컴파일 에러 확인
```bash
flutter analyze
```

### 2. 실행 테스트
```bash
flutter run
```

### 3. 주요 플로우 테스트
```
✓ 로그인 → 회원가입 → 로그인
✓ 홈 → 거래입력 → 홈
✓ Modal 열기 → 닫기
✓ Dialog 열기 → 닫기
```

---

## 📖 개념 이해 (새로운 개발자를 위한)

### Navigator vs GoRouter

#### Navigator (옛날 방식)
```dart
// 직접 스택 관리
Navigator.push(context, MaterialPageRoute(...))
Navigator.pop(context)
```

**단점:**
- 수동 스택 관리
- URL 지원 안 됨
- Deep linking 어려움
- 복잡한 라우팅 로직

#### GoRouter (새 방식)
```dart
// 선언적 라우팅
context.go('/auth/login')
context.push('/detail')
context.pop()
```

**장점:**
- ✅ URL 기반 네비게이션
- ✅ Deep linking 자동 지원
- ✅ 브라우저 뒤로가기 지원
- ✅ 타입 안전한 라우팅
- ✅ Redirect 로직 중앙 관리

### 왜 통일해야 하나?

#### 통일 전 (현재)
```dart
// 어떤 곳에서는
Navigator.pop(context)

// 어떤 곳에서는
context.pop()

// 혼란스러움! 😵
```

#### 통일 후 (목표)
```dart
// 모든 곳에서
context.pop()       // 뒤로가기
context.go('/경로')  // 페이지 이동

// 명확함! ✅
```

---

## 🎓 Best Practices

### DO ✅

```dart
// GoRouter 페이지 간 이동
context.go('/auth/login')
context.push('/detail')

// 뒤로가기
context.pop()

// 안전한 뒤로가기
if (context.canPop()) {
  context.pop();
} else {
  context.go('/');
}

// Named route 사용
context.goNamed('login')
```

### DON'T ❌

```dart
// GoRouter 페이지에서 Navigator 직접 사용
Navigator.of(context).pop()  // ❌ 에러 발생 가능!

// 하드코딩된 경로
context.go('/auth/login')  // ⚠️ 오타 위험
// 대신:
context.goNamed('login')   // ✅ 타입 안전
```

---

## 🐛 문제 해결 (Troubleshooting)

### 에러 1: "You have popped the last page"
```
원인: GoRouter 페이지에서 Navigator.pop() 사용
해결: context.go() 또는 context.pop() 사용
```

### 에러 2: "GoRouter not found"
```
원인: BuildContext가 GoRouter 범위 밖
해결: MaterialApp.router가 제대로 설정되어 있는지 확인
```

### 에러 3: Dialog가 안 닫힘
```
원인: context.pop()이 GoRouter 페이지를 닫으려고 함
해결: Navigator.pop(context) 사용 (Dialog는 예외)
```

---

## 📈 진행 상황 추적

### Checklist

#### Phase 1: 긴급 수정
- [ ] signup_page.dart 수정
- [ ] choose_role_page.dart 수정
- [ ] create_store_page.dart 확인 및 수정
- [ ] journal_input_page.dart 확인 및 수정
- [ ] 테스트 완료

#### Phase 2: 점진적 통일 (선택)
- [ ] homepage 모듈 (26회)
- [ ] attendance 모듈 (15회)
- [ ] register_denomination 모듈 (15회)
- [ ] delegate_role 모듈 (14회)
- [ ] 기타 모듈 (77회)

#### Phase 3: 완전 통일 (선택)
- [ ] 모든 Navigator 참조 제거
- [ ] 문서 업데이트
- [ ] 팀 교육

---

## 📚 참고 자료

### GoRouter 공식 문서
- https://pub.dev/packages/go_router

### Flutter Navigation 가이드
- https://docs.flutter.dev/ui/navigation

### 프로젝트 내부 파일
- `lib/app/config/app_router.dart` - 라우팅 정의
- `lib/core/navigation/safe_navigation.dart` - 안전한 네비게이션 헬퍼

---

## 💡 팁

### 빠른 확인 방법
```bash
# GoRouter 페이지에서 Navigator.pop() 찾기
grep -r "Navigator\.of(context)\.pop()" lib/features/*/presentation/pages --include="*.dart"

# Modal/Dialog 파일 찾기
find lib/features -name "*_bottom_sheet.dart" -o -name "*_dialog.dart"
```

### VSCode 설정
```json
{
  "search.exclude": {
    "**/_bottom_sheet.dart": false,
    "**/_dialog.dart": false
  }
}
```

---

## ❓ FAQ

### Q: 모든 Navigator를 없애야 하나요?
A: 아니요! Modal/Dialog에서는 Navigator.pop()을 사용해도 괜찮습니다. GoRouter 페이지에서만 context.go/pop을 사용하세요.

### Q: 언제까지 마이그레이션해야 하나요?
A: Phase 1 (긴급 수정)은 즉시 필요합니다. Phase 2-3은 시간 날 때 점진적으로 진행하세요.

### Q: 테스트는 어떻게 하나요?
A: 주요 사용자 플로우를 실제로 실행해보세요. 특히 로그인/회원가입 플로우는 필수입니다.

### Q: 에러가 나면 어떻게 하나요?
A: 이 문서의 "문제 해결" 섹션을 참고하거나, git revert로 되돌리세요.

---

**마지막 업데이트**: 2025-01-10
**작성자**: Claude (AI Assistant)
**리뷰어**: 프로젝트 팀
