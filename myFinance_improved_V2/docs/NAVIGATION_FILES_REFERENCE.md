# Navigation Files Reference

> 네비게이션 관련 파일 위치 가이드
> Navigation-Related Files Location Guide

이 문서는 프로젝트의 모든 네비게이션 관련 파일 위치를 정리합니다.

---

## 📁 Core Navigation Files (핵심 네비게이션 파일)

### 1. **Central Router Configuration** (중앙 라우터 설정)
```
lib/app/config/app_router.dart
```
- **역할**: 전체 앱의 라우팅 설정 및 관리
- **내용**:
  - 28개의 GoRoute 정의
  - 리다이렉트 로직 (로그인/권한 체크)
  - 전역 네비게이션 키 관리
- **중요도**: ⭐⭐⭐⭐⭐ (최우선)

### 2. **Safe Navigation Utilities** (안전한 네비게이션 유틸리티)
```
lib/core/navigation/safe_navigation.dart
```
- **역할**: context 안전성 체크 및 유틸리티 함수
- **사용처**: 비동기 작업 후 네비게이션 시
- **중요도**: ⭐⭐⭐⭐

---

## 📚 Documentation Files (문서 파일)

### Migration Guides (마이그레이션 가이드)

1. **Complete Migration Guide**
   ```
   docs/NAVIGATION_MIGRATION_GUIDE.md
   ```
   - 754줄 분량의 상세 가이드
   - 프로젝트 분석, 마이그레이션 전략, 트러블슈팅 포함

2. **Quick Start Guide**
   ```
   docs/NAVIGATION_QUICK_START.md
   ```
   - 5분 안에 시작 가능한 퀵스타트 가이드
   - 즉각적인 액션 단계 제공

3. **Navigation Files Reference** (현재 문서)
   ```
   docs/NAVIGATION_FILES_REFERENCE.md
   ```
   - 모든 네비게이션 관련 파일 위치 정리

---

## 🛠️ Migration Scripts (마이그레이션 스크립트)

### Automation Scripts

1. **Phase 1 Migration Script**
   ```
   scripts/migrate_navigation_phase1.sh
   ```
   - 4개의 핵심 파일 자동 마이그레이션
   - 백업 생성 및 안전성 체크 포함

2. **Complete Migration Script**
   ```
   scripts/migrate_all_navigation.sh
   ```
   - 전체 프로젝트 일괄 마이그레이션
   - Git 상태 확인 및 통계 제공

3. **Import Auto-Adder**
   ```
   scripts/add_go_router_imports.py
   ```
   - go_router import 자동 추가 (Python)
   - context.pop() 사용 파일 감지 및 처리

---

## 📄 Page Files Using Navigation (네비게이션 사용 페이지)

### Authentication Feature
```
lib/features/auth/presentation/pages/
├── login_page.dart           → context.go('/home') 사용
├── signup_page.dart          → context.go('/auth/login') 사용
├── choose_role_page.dart     → context.pop() 사용
└── create_store_page.dart    → context.pop() 사용
```

### Homepage Feature
```
lib/features/homepage/presentation/
├── pages/
│   ├── homepage.dart                      → GoRouter 통합
│   └── select_company_store_page.dart     → context.pop() 사용
└── widgets/
    ├── company_store_selector.dart        → context.pop() 사용
    ├── create_company_sheet.dart          → context.pop() 사용
    └── create_store_sheet.dart            → context.pop() 사용
```

### Attendance Feature
```
lib/features/attendance/presentation/
├── pages/
│   ├── attendance_page.dart               → context.pop() 사용
│   ├── employee_attendance_page.dart      → context.pop() 사용
│   ├── qr_code_display_page.dart         → context.pop() 사용
│   └── qr_scanner_page.dart              → context.pop() 사용
└── widgets/
    └── time_selection_dialog.dart         → context.pop() 사용
```

### Register Denomination Feature
```
lib/features/register_denomination/presentation/widgets/
├── create_register_modal.dart             → context.pop() 사용
├── denomination_input_widget.dart         → context.pop() 사용
├── register_amount_modal.dart             → context.pop() 사용
├── register_selection_widget.dart         → context.pop() 사용
└── transfer_drawer.dart                   → context.pop() 사용
```

### Employee Setting Feature
```
lib/features/employee_setting/presentation/widgets/
├── create_employee_modal.dart             → context.pop() 사용
├── edit_employee_modal.dart               → context.pop() 사용
└── employee_detail_modal.dart             → context.pop() 사용
```

### Time Table Feature
```
lib/features/time_table_manage/presentation/widgets/
├── create_timetable_modal.dart            → context.pop() 사용
└── edit_timetable_modal.dart              → context.pop() 사용
```

### Sales Invoice Feature
```
lib/features/sales_invoice/presentation/pages/
├── add_sales_invoice_page.dart            → context.pop() 사용
└── sales_invoice_detail_page.dart         → context.pop() 사용
```

### Journal Input Feature
```
lib/features/journal_input/presentation/pages/
├── journal_entry_create_page.dart         → context.pop() 사용
└── journal_entry_detail_page.dart         → context.pop() 사용
```

---

## 🔄 All 28 GoRouter Routes (전체 라우트 목록)

### Authentication Routes
1. `/auth/login` - 로그인 페이지
2. `/auth/signup` - 회원가입 페이지
3. `/auth/choose-role` - 역할 선택 페이지
4. `/auth/create-store` - 스토어 생성 페이지

### Main Routes
5. `/` (redirect) - 홈 리다이렉트
6. `/home` - 홈페이지
7. `/select-company-store` - 회사/스토어 선택

### Feature Routes
8. `/attendance` - 출퇴근 관리
9. `/employee-attendance` - 직원 출퇴근
10. `/qr-display` - QR 코드 표시
11. `/qr-scan` - QR 스캔
12. `/register-denomination` - 레지스터 관리
13. `/employee-setting` - 직원 설정
14. `/time-table` - 시간표 관리
15. `/sales-invoice` - 판매 송장
16. `/sales-invoice/add` - 송장 추가
17. `/sales-invoice/:id` - 송장 상세
18. `/journal-input` - 분개 입력
19. `/journal-entry/create` - 분개 생성
20. `/journal-entry/:id` - 분개 상세
21. `/transaction-template` - 거래 템플릿
22. `/chart-of-accounts` - 계정과목표
23. `/balance-sheet` - 재무상태표
24. `/income-statement` - 손익계산서
25. `/cash-flow` - 현금흐름표
26. `/trial-balance` - 시산표
27. `/settings` - 설정
28. `/profile` - 프로필

---

## 📊 Migration Statistics (마이그레이션 통계)

### Before Migration (마이그레이션 전)
- **Total Dart Files**: 765개
- **Navigator.pop() Usage**: 147개 (40개 파일)
- **GoRouter Usage**: 28개 라우트
- **Modal/Dialog Usage**: 287개

### After Migration (마이그레이션 후)
- **All Navigation**: context.pop() 통합 ✅
- **Files Modified**: 40개
- **Imports Added**: 29개 파일
- **Consistency**: 100% GoRouter 패턴

---

## 🎯 Key Navigation Patterns (주요 네비게이션 패턴)

### 1. Page Navigation (페이지 이동)
```dart
// ✅ Correct
context.go('/target-route');
context.push('/target-route');

// ❌ Avoid
Navigator.of(context).push(...);
```

### 2. Going Back (뒤로 가기)
```dart
// ✅ Correct (Works for both pages and dialogs)
context.pop();

// ❌ Old way
Navigator.of(context).pop();
```

### 3. With Result Return (결과 반환)
```dart
// ✅ Correct
context.pop(result);

// Usage
final result = await context.push('/some-page');
```

### 4. Replace Current Route (현재 라우트 교체)
```dart
// ✅ Correct
context.replace('/new-route');

// ❌ Old way
Navigator.of(context).pushReplacement(...);
```

---

## 🚨 Important Notes (중요 참고사항)

### Must Import (필수 임포트)
모든 네비게이션 사용 파일에는 다음 임포트 필요:
```dart
import 'package:go_router/go_router.dart';
```

### Dialog/Modal Navigation (다이얼로그/모달 네비게이션)
- `context.pop()`은 **페이지와 다이얼로그 모두에서 작동**
- 별도의 `Navigator.pop()` 사용 불필요

### Async Navigation (비동기 네비게이션)
비동기 작업 후 네비게이션 시 context 체크:
```dart
if (!mounted || !context.mounted) return;
context.pop();
```

---

## 🔍 Finding Navigation Code (네비게이션 코드 찾기)

### Search Commands (검색 명령어)

1. **Find all context.pop() usage**
   ```bash
   grep -r "context.pop()" lib/features --include="*.dart"
   ```

2. **Find all context.go() usage**
   ```bash
   grep -r "context.go(" lib/features --include="*.dart"
   ```

3. **Find all context.push() usage**
   ```bash
   grep -r "context.push(" lib/features --include="*.dart"
   ```

4. **Find missing go_router imports**
   ```bash
   python3 scripts/add_go_router_imports.py
   ```

---

## 📞 Support (지원)

### 문제 발생 시
1. [NAVIGATION_MIGRATION_GUIDE.md](NAVIGATION_MIGRATION_GUIDE.md) 트러블슈팅 섹션 참조
2. [NAVIGATION_QUICK_START.md](NAVIGATION_QUICK_START.md) 빠른 해결 방법 확인
3. `dart analyze` 실행하여 오류 확인

### 새로운 개발자 온보딩
1. 먼저 [NAVIGATION_QUICK_START.md](NAVIGATION_QUICK_START.md) 읽기 (5분)
2. 그 다음 [NAVIGATION_MIGRATION_GUIDE.md](NAVIGATION_MIGRATION_GUIDE.md) 정독 (30분)
3. 현재 문서로 파일 위치 파악 (10분)

---

## ✅ Checklist for New Navigation Code (새 네비게이션 코드 체크리스트)

새로운 페이지나 기능 추가 시:

- [ ] `import 'package:go_router/go_router.dart';` 임포트 확인
- [ ] `context.pop()` 사용 (Navigator.pop() ❌)
- [ ] `context.go()` 또는 `context.push()` 사용
- [ ] 비동기 작업 후에는 `mounted` 체크
- [ ] app_router.dart에 라우트 등록
- [ ] dart analyze 통과 확인

---

## 📅 Last Updated (최종 업데이트)

- **Date**: 2025-11-10
- **Migration Status**: ✅ Complete
- **Total Routes**: 28
- **Pattern**: 100% GoRouter

---

**유지보수 담당자에게:**
이 문서는 프로젝트의 네비게이션 구조를 한눈에 파악할 수 있도록 작성되었습니다.
새로운 기능 추가 시 이 문서와 함께 app_router.dart를 업데이트해주세요.
