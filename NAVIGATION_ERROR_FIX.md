# Navigation Error Fix - 검은 화면 문제 해결

**날짜**: 2025-01-24
**상태**: ✅ 완료

---

## 🔴 발생한 문제

### 사용자 경험
Inventory Management 페이지에서 제품을 테스트하다가 **검은 화면**이 나타남

### 에러 로그
```
Another exception was thrown: You have popped the last page off of the stack, there are no pages left to show
Another exception was thrown: 'package:flutter/src/widgets/navigator.dart': Failed assertion: line 4061 pos 12:
'!_debugLocked': is not true.
```

### FCM 관련 경고 (부차적)
```
flutter: ❌ Reliable token registration failed: Exception: Unable to obtain FCM token after refresh
flutter: ❌ Token registration after auth failed: Exception: Unable to obtain FCM token after refresh
flutter: ✅ Background token recovery successful
```

---

## 🔍 근본 원인 분석

### Navigation Stack 문제

**잘못된 네비게이션 흐름**:

1. **Inventory List Page**
   ↓ `context.go('/inventoryManagement/product/$id')`
2. **Product Detail Page**
   ↓ `context.go('/inventoryManagement/editProduct/$id')`
3. **Edit Product Page**
   ↓ 저장 후 `context.pop()`
4. ❌ **검은 화면** (돌아갈 페이지가 없음!)

### 문제의 핵심

**`context.go()` vs `context.push()`**:

| 메서드 | 동작 | 네비게이션 스택 |
|--------|------|----------------|
| `context.go()` | **전체 스택 교체** | 이전 페이지들 삭제 |
| `context.push()` | **스택에 추가** | 이전 페이지들 유지 |

**잘못된 코드**:
```dart
// ❌ Product List → Product Detail
onTap: () {
  context.go('/inventoryManagement/product/${product.id}');
  // 스택: [Inventory List] → [Product Detail] (List 삭제됨!)
},

// ❌ Product Detail → Edit Product
onPressed: () {
  context.go('/inventoryManagement/editProduct/$productId');
  // 스택: [Product Detail] → [Edit Product] (Detail 삭제됨!)
},

// ❌ Edit Product → Save and Pop
context.pop();
// 스택: [] (비어있음!) → 검은 화면!
```

---

## ✅ 해결 방법

### 1. Product List → Product Detail 수정

**Before** (`inventory_management_page.dart` line 446):
```dart
onTap: () {
  context.go('/inventoryManagement/product/${product.id}');
},
```

**After**:
```dart
onTap: () {
  context.push('/inventoryManagement/product/${product.id}');
},
```

### 2. Product List → Add Product 수정

**Before** (`inventory_management_page.dart` line 95):
```dart
floatingActionButton: FloatingActionButton(
  onPressed: () {
    context.go('/inventoryManagement/addProduct');
  },
),
```

**After**:
```dart
floatingActionButton: FloatingActionButton(
  onPressed: () {
    context.push('/inventoryManagement/addProduct');
  },
),
```

### 3. Product Detail → Edit Product 수정

**Before** (`product_detail_page.dart` line 49):
```dart
IconButton(
  icon: const Icon(Icons.edit),
  onPressed: () {
    context.go('/inventoryManagement/editProduct/$productId');
  },
),
```

**After**:
```dart
IconButton(
  icon: const Icon(Icons.edit),
  onPressed: () {
    context.push('/inventoryManagement/editProduct/$productId');
  },
),
```

### 4. Product Detail의 불필요한 뒤로가기 버튼 제거

**Before** (`product_detail_page.dart` line 33-36):
```dart
appBar: AppBar(
  leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => context.pop(), // 불필요한 커스텀 로직
  ),
  title: Text('Product Details'),
  ...
),
```

**After**:
```dart
appBar: AppBar(
  // leading 제거 → Flutter가 자동으로 뒤로가기 버튼 생성
  title: Text('Product Details'),
  ...
),
```

---

## 📊 수정 전후 비교

### Navigation Flow - Before (❌ 잘못됨)

```
[Inventory List]
       ↓ context.go() - 스택 교체
[Product Detail] (List 삭제됨)
       ↓ context.go() - 스택 교체
[Edit Product] (Detail 삭제됨)
       ↓ context.pop()
[ ] 빈 스택 → 검은 화면!
```

### Navigation Flow - After (✅ 올바름)

```
[Inventory List]
       ↓ context.push() - 스택에 추가
[Inventory List, Product Detail]
       ↓ context.push() - 스택에 추가
[Inventory List, Product Detail, Edit Product]
       ↓ context.pop()
[Inventory List, Product Detail] ✅ 정상 동작!
       ↓ context.pop()
[Inventory List] ✅ 정상 동작!
```

---

## 🎯 Go Router 사용 가이드

### context.go() 사용 시기

✅ **Top-level navigation** (탭 간 이동, 메인 메뉴 변경)
```dart
// 예: 홈 → 설정
context.go('/settings');

// 예: 제품 → 판매
context.go('/sales');
```

### context.push() 사용 시기

✅ **Hierarchical navigation** (상세보기, 추가/수정, 모달)
```dart
// 예: 목록 → 상세
context.push('/product/$id');

// 예: 목록 → 추가
context.push('/addProduct');

// 예: 상세 → 수정
context.push('/editProduct/$id');
```

### 핵심 원칙

| 상황 | 메서드 | 이유 |
|------|--------|------|
| **새로운 섹션으로 이동** | `context.go()` | 이전 섹션은 필요 없음 |
| **상세/추가/수정 보기** | `context.push()` | 뒤로가기 시 원래 화면 필요 |
| **뒤로가기** | `context.pop()` | 스택에서 제거 |

---

## 🔧 FCM 토큰 경고 (부차적 이슈)

### 경고 내용
```
❌ Reliable token registration failed: Exception: Unable to obtain FCM token after refresh
❌ Token registration after auth failed
✅ Background token recovery successful
```

### 분석
- FCM 토큰 갱신 실패 (푸시 알림 기능에 영향)
- 하지만 Background token recovery가 성공하므로 실제 기능은 정상 작동
- **검은 화면 문제와는 무관** (navigation 문제가 주 원인)

### 조치
- 현재는 문제 없음 (background recovery 성공)
- 필요시 FCM 설정 점검 (추후 작업)

---

## ✅ 최종 검증

### 수정된 파일 (3개)
1. ✅ `inventory_management_page.dart` (2곳 수정)
   - Product tap: `context.go()` → `context.push()`
   - Add button: `context.go()` → `context.push()`

2. ✅ `product_detail_page.dart` (2곳 수정)
   - Edit button: `context.go()` → `context.push()`
   - AppBar leading 제거 (자동 뒤로가기)

3. ✅ `edit_product_page.dart` (변경 없음)
   - 이미 `context.pop()` 사용중 - 올바름

### 테스트 시나리오

1. **Add Product Flow** ✅
   ```
   List → Add → Save → List (정상)
   List → Add → Cancel → List (정상)
   ```

2. **View Product Flow** ✅
   ```
   List → Detail → Back → List (정상)
   List → Detail → Edit → Save → Detail → List (정상)
   ```

3. **Navigation Stack** ✅
   ```
   모든 페이지에서 뒤로가기 정상 작동
   검은 화면 발생 안함
   ```

---

## 📝 결론

### 수정 내용
- ✅ Navigation 오류 수정 (context.go → context.push)
- ✅ 불필요한 커스텀 뒤로가기 버튼 제거
- ✅ 모든 페이지 간 네비게이션 정상화

### 결과
**검은 화면 문제 완전 해결!** 🎉

사용자는 이제 Inventory Management의 모든 기능을 정상적으로 사용할 수 있습니다:
- 제품 목록 보기
- 제품 추가
- 제품 상세 보기
- 제품 수정
- 모든 페이지에서 뒤로가기
