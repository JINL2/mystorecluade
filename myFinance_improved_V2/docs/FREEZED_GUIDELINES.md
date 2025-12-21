# Freezed Usage Guidelines

## 📌 Quick Rule

**"If it has 3+ fields, use Freezed."**

---

## ✅ MUST Use Freezed

### 1. All Data Models (100%)
JSON 직렬화가 필요한 모든 Model 클래스

```dart
@freezed
class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    @JsonKey(name: 'user_id') required String id,
    @JsonKey(name: 'user_name') required String name,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  // Domain 변환
  User toEntity() => User(id: id, name: name);
}
```

### 2. All UI States (100%)
StateNotifier의 모든 state 클래스

```dart
@freezed
class LoadingState<T> with _$LoadingState<T> {
  const factory LoadingState.initial() = _Initial;
  const factory LoadingState.loading() = _Loading;
  const factory LoadingState.success(T data) = _Success;
  const factory LoadingState.error(String message) = _Error;
}
```

### 3. Complex Domain Entities
비즈니스 로직이 있어도 Freezed 사용 가능!

```dart
@freezed
class Revenue with _$Revenue {
  const Revenue._();  // ← 이거 필수!

  const factory Revenue({
    required double amount,
    required double previousAmount,
  }) = _Revenue;

  // ✅ 비즈니스 로직 추가 가능
  double get growthPercentage {
    if (previousAmount <= 0) return 0.0;
    return ((amount - previousAmount) / previousAmount) * 100;
  }
}
```

---

## ❌ DON'T Use Freezed

### 1. Very Simple Classes (2 fields 이하)
```dart
// ❌ Freezed 오버킬
@freezed class Point {...}

// ✅ 그냥 일반 클래스
class Point {
  const Point(this.x, this.y);
  final double x;
  final double y;
}
```

---

## 🔧 Build Runner Commands

```bash
# 코드 생성
flutter pub run build_runner build --delete-conflicting-outputs

# Watch 모드 (개발 중)
flutter pub run build_runner watch --delete-conflicting-outputs

# 클린 빌드
flutter clean && flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 📋 Commit Checklist

- [ ] 모든 Data Model이 Freezed 사용
- [ ] 모든 UI State가 Freezed 사용
- [ ] `.freezed.dart` 파일 git에 커밋
- [ ] `.g.dart` 파일 git에 커밋 (JSON 직렬화 있는 경우)
- [ ] `flutter analyze` 통과

---

## 🎁 Freezed Benefits

```dart
final revenue = Revenue(amount: 1000, previousAmount: 900);

// ✅ copyWith (자동 생성!)
final updated = revenue.copyWith(amount: 1100);

// ✅ Equality (자동 생성!)
revenue == revenue2;  // works!

// ✅ toString (자동 생성!)
print(revenue);  // Revenue(amount: 1000, previousAmount: 900)

// ✅ Pattern Matching (Union types)
state.when(
  initial: () => CircularProgressIndicator(),
  loading: () => LoadingWidget(),
  success: (data) => DataWidget(data),
  error: (msg) => ErrorWidget(msg),
);
```

---

## 📚 Examples in Codebase

### Data Models
- `lib/features/homepage/data/models/company_model.dart`
- `lib/features/homepage/data/models/revenue_model.dart`

### Domain Entities
- `lib/features/homepage/domain/entities/revenue.dart`

### UI States
- `lib/features/homepage/presentation/providers/states/company_state.dart`

---

**Last Updated:** 2025-11-13
