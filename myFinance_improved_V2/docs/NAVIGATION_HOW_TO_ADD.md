# 페이지 안에서 네비게이션 추가하는 방법

> 실전 가이드: 언제, 어떻게 네비게이션을 추가하는가?

---

## 📋 빠른 의사결정 트리

```
네비게이션이 필요한가?
│
├─ YES → 어떤 상황?
│   │
│   ├─ 1️⃣ 뒤로 가기 (Dialog/Modal 닫기)
│   │   → context.pop()
│   │
│   ├─ 2️⃣ 다른 페이지로 이동 (히스토리 스택에 추가)
│   │   → context.push('/page')
│   │
│   ├─ 3️⃣ 다른 페이지로 교체 (현재 페이지 제거)
│   │   → context.go('/page')
│   │
│   └─ 4️⃣ 중요한 작업 (로그아웃, 결제, 프로필)
│       → context.safePop() / context.safeGo() / context.safePush()
│
└─ NO → 네비게이션 불필요
```

---

## 1️⃣ 뒤로 가기 (가장 흔한 케이스)

### 상황
- AppBar의 뒤로 가기 버튼
- Dialog/Modal의 닫기 버튼
- 취소 버튼

### ✅ 일반적인 경우

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';  // ← 필수 import

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // ✅ 간단한 뒤로 가기
            context.pop();
          },
        ),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // ✅ Dialog 닫기
              context.pop();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
```

### ⭐ 중요한 페이지인 경우 (결제, 프로필 등)

```dart
import 'package:flutter/material.dart';
import 'package:myfinance_improved/core/navigation/safe_navigation.dart';  // ← safe 사용 시

class ImportantPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Important Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // ✅ 안전한 뒤로 가기 (중복 클릭 방지)
            context.safePop();
          },
        ),
      ),
    );
  }
}
```

### 📌 언제 `safePop()` 사용?
- 결제 페이지
- 프로필 수정 페이지
- 중요한 폼 작성 페이지
- 데이터 손실 우려가 있는 페이지

---

## 2️⃣ 다른 페이지로 이동 (히스토리 유지)

### 상황
- 상세 페이지로 이동
- 설정 페이지로 이동
- 서브 페이지로 이동
- **뒤로 가기로 돌아올 수 있어야 할 때**

### ✅ 일반적인 경우

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // ✅ 상세 페이지로 이동 (히스토리 유지)
              context.push('/product/detail');
            },
            child: Text('상품 상세보기'),
          ),

          ElevatedButton(
            onPressed: () {
              // ✅ 설정 페이지로 이동
              context.push('/settings');
            },
            child: Text('설정'),
          ),
        ],
      ),
    );
  }
}
```

### ⭐ 데이터 전달이 필요한 경우

```dart
// 방법 1: extra로 데이터 전달 (추천)
context.push(
  '/product/detail',
  extra: {
    'productId': '123',
    'productName': 'Apple',
  },
);

// 방법 2: Path Parameter
context.push('/product/detail/123');

// 방법 3: Query Parameter
context.push('/search?keyword=apple&category=fruit');
```

### ⭐ 결과를 받아야 하는 경우

```dart
// 다른 페이지로 이동하고 결과 받기
final result = await context.push<bool>('/confirm-page');

if (result == true) {
  print('사용자가 확인을 눌렀습니다!');
} else {
  print('사용자가 취소했습니다');
}

// 결과 페이지에서는:
// context.pop(true);  // 확인
// context.pop(false); // 취소
```

---

## 3️⃣ 다른 페이지로 교체 (현재 페이지 제거)

### 상황
- 로그인 성공 → 홈으로 이동 (로그인 페이지 제거)
- 회원가입 완료 → 로그인 페이지로 이동 (회원가입 페이지 제거)
- **뒤로 가기로 돌아오면 안 될 때**

### ✅ 일반적인 경우

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignupPage extends StatelessWidget {
  void _onSignupSuccess(BuildContext context) {
    // ✅ 회원가입 성공 → 로그인 페이지로 교체
    // (뒤로 가기 해도 회원가입 페이지로 안 돌아감)
    context.go('/auth/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        onPressed: () => _onSignupSuccess(context),
        child: Text('가입 완료'),
      ),
    );
  }
}
```

### 실제 프로젝트 예시

```dart
// ✅ lib/features/auth/presentation/pages/signup_page.dart:769
// 회원가입 완료 후 로그인 페이지로 이동
void _onSignupSuccess(BuildContext context) {
  // 회원가입 페이지를 히스토리에서 제거하고 로그인 페이지로 이동
  context.go('/auth/login');
}
```

---

## 4️⃣ 중요한 네비게이션 (안전 장치 필요)

### 상황
- 로그아웃
- 결제 완료
- 프로필 수정 완료
- 중요 데이터 저장
- 사용자가 빠르게 여러 번 클릭할 수 있는 버튼

### ⭐ 중요한 경우

```dart
import 'package:flutter/material.dart';
import 'package:myfinance_improved/core/navigation/safe_navigation.dart';

class MyProfilePage extends StatelessWidget {
  void _logout(BuildContext context) async {
    // 로그아웃 처리
    await AuthService.logout();

    // ✅ 안전한 네비게이션 (중복 클릭 방지)
    if (context.mounted) {
      context.safeGo('/auth/login');
    }
  }

  void _editProfile(BuildContext context) async {
    // ✅ 안전한 네비게이션
    final result = await context.safePush('/edit-profile');

    if (result == true) {
      // 프로필 수정 성공
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('프로필이 수정되었습니다')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => _editProfile(context),
            child: Text('프로필 수정'),
          ),

          ElevatedButton(
            onPressed: () => _logout(context),
            child: Text('로그아웃'),
          ),
        ],
      ),
    );
  }
}
```

---

## 📌 중요한 체크리스트

### ✅ 네비게이션 추가 전 체크

```dart
// 1. import 확인
import 'package:go_router/go_router.dart';  // ← 필수!

// 2. 비동기 작업 후 네비게이션이면 mounted 체크
if (!mounted) return;  // ← StatefulWidget인 경우
if (!context.mounted) return;  // ← 모든 경우

// 3. context.pop() 전에 canPop() 체크 (선택사항)
if (context.canPop()) {
  context.pop();
} else {
  context.go('/');  // 뒤로 갈 곳이 없으면 홈으로
}
```

---

## 🎯 실전 패턴별 예시

### 패턴 1: AppBar 뒤로 가기

```dart
AppBar(
  title: Text('Page Title'),
  leading: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () => context.pop(),  // ✅ 간단
  ),
)
```

### 패턴 2: 리스트 아이템 클릭

```dart
ListView.builder(
  itemBuilder: (context, index) {
    return ListTile(
      title: Text('Item $index'),
      onTap: () {
        // ✅ 상세 페이지로 이동
        context.push('/detail/$index');
      },
    );
  },
)
```

### 패턴 3: Form 저장 후 이동

```dart
void _saveForm(BuildContext context) async {
  // 1. 데이터 저장
  await saveData();

  // 2. mounted 체크
  if (!context.mounted) return;

  // 3. 네비게이션
  context.pop(true);  // 결과와 함께 돌아가기
}
```

### 패턴 4: Dialog에서 선택 후 이동

```dart
void _showConfirmDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) {  // ← 주의: dialogContext 사용
      return AlertDialog(
        title: Text('확인'),
        content: Text('정말 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();  // ← Dialog 닫기
            },
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () {
              context.pop();  // ← Dialog 닫기
              // 실제 삭제 처리...
              context.go('/home');  // ← 페이지 이동
            },
            child: Text('확인'),
          ),
        ],
      );
    },
  );
}
```

### 패턴 5: BottomSheet에서 선택 후 이동

```dart
void _showBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (sheetContext) {
      return Column(
        children: [
          ListTile(
            title: Text('옵션 1'),
            onTap: () {
              context.pop();  // ← BottomSheet 닫기
              context.push('/option1');  // ← 페이지 이동
            },
          ),
          ListTile(
            title: Text('옵션 2'),
            onTap: () {
              context.pop();  // ← BottomSheet 닫기
              context.push('/option2');  // ← 페이지 이동
            },
          ),
        ],
      );
    },
  );
}
```

---

## ⚠️ 흔한 실수와 해결법

### 실수 1: import 누락

```dart
// ❌ 잘못된 코드
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => context.pop(),  // ← 에러! import 없음
      child: Text('Back'),
    );
  }
}

// ✅ 올바른 코드
import 'package:go_router/go_router.dart';  // ← 추가!

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => context.pop(),  // ← 정상 작동
      child: Text('Back'),
    );
  }
}
```

### 실수 2: 비동기 후 mounted 체크 누락

```dart
// ❌ 잘못된 코드
void _loadData(BuildContext context) async {
  await Future.delayed(Duration(seconds: 2));
  context.pop();  // ← 위험! Widget이 이미 dispose될 수 있음
}

// ✅ 올바른 코드
void _loadData(BuildContext context) async {
  await Future.delayed(Duration(seconds: 2));

  if (!context.mounted) return;  // ← mounted 체크 필수!

  context.pop();
}
```

### 실수 3: Dialog context 혼동

```dart
// ❌ 잘못된 코드
void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        actions: [
          TextButton(
            onPressed: () {
              // dialogContext로 페이지 이동 시도 → 작동 안 할 수 있음
              dialogContext.push('/page');
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

// ✅ 올바른 코드
void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        actions: [
          TextButton(
            onPressed: () {
              context.pop();  // ← Dialog 닫기
              context.push('/page');  // ← 페이지 이동 (원래 context 사용)
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
```

### 실수 4: Navigator.pop() 사용

```dart
// ❌ 잘못된 코드 (구식)
Navigator.of(context).pop();
Navigator.push(context, MaterialPageRoute(...));

// ✅ 올바른 코드 (현재 프로젝트 방식)
context.pop();
context.push('/page');
```

---

## 🎓 학습용 전체 예시

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/core/navigation/safe_navigation.dart';

class ExamplePage extends StatefulWidget {
  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {

  // 1️⃣ 간단한 뒤로 가기
  void _goBack() {
    context.pop();
  }

  // 2️⃣ 다른 페이지로 이동 (히스토리 유지)
  void _goToDetail() {
    context.push('/detail');
  }

  // 3️⃣ 페이지 교체 (히스토리 제거)
  void _goToHome() {
    context.go('/');
  }

  // 4️⃣ 안전한 네비게이션 (중요한 작업)
  void _safeNavigate() {
    context.safeGo('/important-page');
  }

  // 5️⃣ 데이터와 함께 이동
  void _goWithData() {
    context.push(
      '/product/detail',
      extra: {
        'id': '123',
        'name': 'Product',
      },
    );
  }

  // 6️⃣ 결과를 받아오는 네비게이션
  Future<void> _goAndGetResult() async {
    final result = await context.push<bool>('/confirm');

    if (!mounted) return;  // ← mounted 체크 필수!

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('확인되었습니다')),
      );
    }
  }

  // 7️⃣ 비동기 작업 후 네비게이션
  Future<void> _saveAndNavigate() async {
    // 데이터 저장
    await saveData();

    // mounted 체크 필수!
    if (!mounted) return;

    // 네비게이션
    context.pop(true);
  }

  // 8️⃣ Dialog 띄우고 네비게이션
  void _showDialogAndNavigate() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('확인'),
          content: Text('이동하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();  // Dialog 닫기
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                context.pop();  // Dialog 닫기
                context.push('/target');  // 페이지 이동
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _goBack,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _goBack,
              child: Text('1️⃣ 뒤로 가기'),
            ),
            SizedBox(height: 8),

            ElevatedButton(
              onPressed: _goToDetail,
              child: Text('2️⃣ 상세 페이지로 이동'),
            ),
            SizedBox(height: 8),

            ElevatedButton(
              onPressed: _goToHome,
              child: Text('3️⃣ 홈으로 교체'),
            ),
            SizedBox(height: 8),

            ElevatedButton(
              onPressed: _safeNavigate,
              child: Text('4️⃣ 안전한 네비게이션'),
            ),
            SizedBox(height: 8),

            ElevatedButton(
              onPressed: _goWithData,
              child: Text('5️⃣ 데이터와 함께 이동'),
            ),
            SizedBox(height: 8),

            ElevatedButton(
              onPressed: _goAndGetResult,
              child: Text('6️⃣ 결과 받아오기'),
            ),
            SizedBox(height: 8),

            ElevatedButton(
              onPressed: _saveAndNavigate,
              child: Text('7️⃣ 저장 후 이동'),
            ),
            SizedBox(height: 8),

            ElevatedButton(
              onPressed: _showDialogAndNavigate,
              child: Text('8️⃣ Dialog 후 이동'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 📊 빠른 참조표

| 상황 | 사용할 메소드 | 예시 |
|------|-------------|------|
| 뒤로 가기 | `context.pop()` | AppBar 버튼 |
| Dialog 닫기 | `context.pop()` | Dialog 취소 버튼 |
| 다른 페이지 이동 | `context.push('/page')` | 상세보기 |
| 페이지 교체 | `context.go('/page')` | 로그인 성공 |
| 결과 받기 | `await context.push<T>('/page')` | 확인 Dialog |
| 중요 작업 | `context.safeGo()` | 로그아웃 |
| 데이터 전달 | `context.push('/page', extra: data)` | 상품 정보 |

---

## 🔧 디버깅 팁

### 네비게이션이 안 될 때 체크리스트

```dart
// 1. import 확인
import 'package:go_router/go_router.dart';  // ← 있나?

// 2. 경로가 app_router.dart에 등록되어 있나?
// lib/app/config/app_router.dart 확인

// 3. context가 올바른가?
// Dialog/BottomSheet에서는 원래 context 사용

// 4. mounted 체크했나?
if (!context.mounted) return;

// 5. 디버그 로그 추가
debugPrint('Navigation to: /my-page');
context.push('/my-page');
```

---

## 📚 추가 참고 자료

- [docs/NAVIGATION_MIGRATION_GUIDE.md](NAVIGATION_MIGRATION_GUIDE.md) - 전체 마이그레이션 가이드
- [docs/NAVIGATION_QUICK_START.md](NAVIGATION_QUICK_START.md) - 5분 빠른 시작
- [docs/NAVIGATION_FILES_REFERENCE.md](NAVIGATION_FILES_REFERENCE.md) - 파일 위치 참조
- [lib/app/config/app_router.dart](../lib/app/config/app_router.dart) - 라우트 정의
- [lib/core/navigation/safe_navigation.dart](../lib/core/navigation/safe_navigation.dart) - 안전 네비게이션

---

## ✅ 마지막 체크리스트

새 페이지에 네비게이션 추가할 때:

- [ ] `import 'package:go_router/go_router.dart';` 추가
- [ ] 경로가 `app_router.dart`에 등록되어 있는지 확인
- [ ] 비동기 작업 후에는 `mounted` 체크
- [ ] 일반 네비게이션은 `context.pop/push/go` 사용
- [ ] 중요한 네비게이션은 `context.safePop/safePush/safeGo` 사용
- [ ] Dialog/BottomSheet에서는 원래 context 주의
- [ ] 디버그 로그로 네비게이션 확인

---

**생성일**: 2025-11-10
**버전**: 1.0
**프로젝트**: myFinance_improved_V2
