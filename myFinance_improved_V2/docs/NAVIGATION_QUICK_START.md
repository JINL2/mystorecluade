# 🚀 Navigation Migration - Quick Start

> **5분만에 시작하기** - 가장 빠르게 네비게이션 문제 해결하기

---

## ⚡ 지금 당장 해야 할 일

### 1️⃣ 백업 만들기 (30초)
```bash
cd /Applications/XAMPP/xamppfiles/htdocs/mysite/mystorecluade/myFinance_improved_V2
git add .
git commit -m "Before navigation migration"
```

### 2️⃣ 스크립트 실행 (1분)
```bash
./scripts/migrate_navigation_phase1.sh
```

### 3️⃣ 테스트 (3분)
```bash
flutter run
```

**테스트 항목:**
- ✅ 로그인 → 회원가입 → "Sign in" 클릭 → 로그인 페이지로 이동
- ✅ 거래 입력 페이지 열고 닫기
- ✅ 앱이 정상 작동

### 4️⃣ 커밋 (30초)
```bash
git add .
git commit -m "feat: migrate navigation to GoRouter (Phase 1)"
```

**끝! 🎉**

---

## 📋 무엇이 바뀌나요?

### Before (에러 발생)
```dart
// signup_page.dart
Navigator.of(context).pop();  // ❌ 스택 에러!
```

### After (정상 작동)
```dart
// signup_page.dart
context.go('/auth/login');  // ✅ 완벽!
```

---

## 🔍 자세한 내용은?

전체 가이드를 보려면:
👉 [NAVIGATION_MIGRATION_GUIDE.md](./NAVIGATION_MIGRATION_GUIDE.md)

---

## ❓ 문제가 생겼나요?

### 에러: "You have popped the last page"
```bash
# 되돌리기
cp backup_navigation_*/signup_page.dart lib/features/auth/presentation/pages/
```

### 스크립트가 안 돌아가요
```bash
# 권한 설정
chmod +x scripts/migrate_navigation_phase1.sh

# 다시 실행
./scripts/migrate_navigation_phase1.sh
```

### 수동으로 하고 싶어요
1. `lib/features/auth/presentation/pages/signup_page.dart` 열기
2. 라인 769 찾기
3. `Navigator.of(context).pop();` → `context.go('/auth/login');` 변경
4. 저장!

---

**소요 시간**: 5분
**난이도**: ⭐ (쉬움)
**안전도**: ✅ (백업 자동 생성)
