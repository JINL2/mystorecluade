# Subscription Limit Module

구독 플랜별 제한(회사/가게/직원 수) 검증을 위한 모듈입니다.

---

## Quick Start

### Import (단 1줄)

```dart
import 'package:myfinance_improved/core/subscription/index.dart';
```

---

## 폴더 구조

```
lib/core/subscription/
├── index.dart                          # Barrel export
├── entities/
│   └── subscription_limit_check.dart   # Entity (freezed)
├── providers/
│   └── subscription_limit_providers.dart # Cache + Fresh providers
└── widgets/
    ├── limit_aware_option_card.dart    # 공용 옵션 카드
    └── subscription_upgrade_dialog.dart # 업그레이드 다이얼로그
```

---

## 플랜별 제한값

| Plan | max_companies | max_stores | max_employees |
|------|---------------|------------|---------------|
| Free | 1 | 1 | 5 |
| Basic | 1 | 3 | 15 |
| Pro | 무제한 | 무제한 | 무제한 |

---

## 하이브리드 체크 아키텍처

```
┌─────────────────────────────────────────────────────────────┐
│                    3단계 검증 시스템                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1️⃣ UI 레벨 (즉각 반응) - AppState 캐시                     │
│     └─ 앱 시작/회사 선택 시 로드된 데이터로 버튼 상태 표시     │
│     └─ 사용자 경험 향상 (로딩 없이 즉시 반응)                 │
│                                                             │
│  2️⃣ 생성 시점 (최신 확인) - 가벼운 RPC                      │
│     └─ "Create" 버튼 클릭 시 최신 count 확인                 │
│     └─ 다른 기기에서 추가된 경우 감지                        │
│                                                             │
│  3️⃣ Backend 레벨 (보안) - INSERT 전 검증                    │
│     └─ DB에서 최종 검증 후 INSERT                           │
│     └─ API 우회/해킹 방지                                   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 사용 가능한 Providers

| Provider | 용도 | 반환 타입 |
|----------|------|----------|
| `companyLimitFromCacheProvider` | 회사 제한 (캐시) | `SubscriptionLimitCheck` |
| `storeLimitFromCacheProvider` | 가게 제한 (캐시) | `SubscriptionLimitCheck` |
| `employeeLimitFromCacheProvider` | 직원 제한 (캐시) | `SubscriptionLimitCheck` |
| `companyLimitFreshProvider` | 회사 제한 (Fresh RPC) | `Future<SubscriptionLimitCheck>` |
| `storeLimitFreshProvider()` | 가게 제한 (Fresh RPC) | `Future<SubscriptionLimitCheck>` |
| `employeeLimitFreshProvider()` | 직원 제한 (Fresh RPC) | `Future<SubscriptionLimitCheck>` |
| `subscriptionStateNotifierProvider` | 구독 상태 (Realtime) | `AsyncValue<SubscriptionState>` |

> **Note**: Pro 플랜 여부는 `appState.isProPlan` 또는 `subscriptionState.planName == 'pro'`로 직접 확인

---

## SubscriptionLimitCheck 속성

```dart
final limit = ref.watch(storeLimitFromCacheProvider);

limit.canAdd          // bool - 추가 가능 여부
limit.isUnlimited     // bool - 무제한 여부 (Pro 플랜)
limit.planName        // String - 'free', 'basic', 'pro'
limit.currentCount    // int - 현재 사용량
limit.maxLimit        // int? - 최대 제한 (null = 무제한)
limit.limitDisplayText // String - "2 / 3" 또는 "Unlimited"
limit.isCloseToLimit  // bool - 제한에 근접 (80% 이상)
limit.upgradeMessage  // String - 업그레이드 안내 메시지
```

---

## 사용 패턴

### 패턴 A: 버튼/카드 UI (LimitAwareOptionCard 사용)

바텀시트나 선택 카드에서 사용:

```dart
class MyActionSheet extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1️⃣ 캐시로 UI 즉시 반응
    final limit = ref.watch(storeLimitFromCacheProvider);

    return LimitAwareOptionCard(
      icon: Icons.store,
      title: 'Create Store',
      subtitle: limit.canAdd
          ? 'Add a new store'
          : 'Limit reached (${limit.limitDisplayText})',
      canTap: limit.canAdd,
      onTap: () => _handleCreate(context, ref, limit),
    );
  }

  Future<void> _handleCreate(
    BuildContext context,
    WidgetRef ref,
    SubscriptionLimitCheck cachedLimit,
  ) async {
    // 2️⃣ 캐시가 불가면 즉시 업그레이드 다이얼로그
    if (!cachedLimit.canAdd) {
      await SubscriptionUpgradeDialog.show(
        context,
        limitCheck: cachedLimit,
        resourceType: 'store',
      );
      return;
    }

    // 3️⃣ Fresh 체크 (다른 기기에서 추가했을 수 있음)
    try {
      final freshLimit = await ref.read(storeLimitFreshProvider().future);
      if (!context.mounted) return;

      if (freshLimit.canAdd) {
        // ✅ 진행
        Navigator.pop(context);
        _createStore();
      } else {
        // ❌ 업그레이드 필요
        await SubscriptionUpgradeDialog.show(
          context,
          limitCheck: freshLimit,
          resourceType: 'store',
        );
      }
    } catch (e) {
      // 에러 시 캐시 신뢰하고 진행
      if (!context.mounted) return;
      _createStore();
    }
  }
}
```

### 패턴 B: 일반 버튼/아이콘 (직접 구현)

AppBar나 FAB에서 사용:

```dart
class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeLimit = ref.watch(employeeLimitFromCacheProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              employeeLimit.canAdd ? Icons.add : Icons.lock_outline,
              color: employeeLimit.canAdd ? TossColors.primary : TossColors.warning,
            ),
            onPressed: () => _handleAddEmployee(context, ref, employeeLimit),
          ),
        ],
      ),
    );
  }
}
```

### 패턴 C: 제한 정보만 표시

```dart
final limit = ref.watch(storeLimitFromCacheProvider);

// 현재 사용량 표시
Text('Stores: ${limit.limitDisplayText}');  // "2 / 3" 또는 "Unlimited"

// 제한 근접 경고
if (limit.isCloseToLimit) {
  Text('Almost at limit!', style: TextStyle(color: TossColors.warning));
}
```

---

## 플로우차트

```
사용자가 "추가" 버튼 클릭
         │
         ▼
┌─────────────────────────┐
│ ref.watch(xxxLimitFromCacheProvider)
│ → 캐시 기반 UI 표시     │
└───────────┬─────────────┘
            │
            ▼
      canAdd == true?
       /          \
      No           Yes
      │             │
      ▼             ▼
┌──────────┐  ┌─────────────────────┐
│ 업그레이드 │  │ ref.read(xxxLimitFreshProvider)
│ 다이얼로그 │  │ → Fresh RPC 체크   │
└──────────┘  └──────────┬──────────┘
                         │
                         ▼
                   canAdd == true?
                    /          \
                   No           Yes
                   │             │
                   ▼             ▼
             ┌──────────┐   ┌─────────┐
             │ 업그레이드 │   │ 생성 진행 │
             │ 다이얼로그 │   └─────────┘
             └──────────┘
```

---

## 적용된 UI 파일

| 파일 | 검증 대상 |
|------|----------|
| `company_actions_sheet.dart` | 회사 생성 |
| `store_actions_sheet.dart` | 가게 생성 |
| `members_tab.dart` | 직원 추가 |

---

## 테스트 방법

### 시나리오별 테스트

| 테스트 | 방법 | 예상 결과 |
|--------|------|----------|
| Free 플랜 - 회사 제한 | 회사 1개 있는 상태에서 "Create Company" 클릭 | 업그레이드 다이얼로그 표시 |
| Free 플랜 - 가게 제한 | 가게 1개 있는 상태에서 "Create Store" 클릭 | 업그레이드 다이얼로그 표시 |
| Free 플랜 - 직원 제한 | 직원 5명 있는 상태에서 "Add Member" 클릭 | 업그레이드 다이얼로그 표시 |
| Pro 플랜 | 아무거나 추가 시도 | 제한 없이 진행 |
| 다중 기기 시나리오 | 기기A에서 가게 추가 → 기기B에서 "Create Store" 클릭 | Fresh 체크로 제한 감지 |

### DB에서 직접 테스트 데이터 조작

```sql
-- 테스트용: Free 플랜으로 변경
UPDATE user_subscriptions
SET plan_id = (SELECT plan_id FROM subscription_plans WHERE plan_name = 'free')
WHERE user_id = 'YOUR_USER_ID';

-- 테스트용: Pro 플랜으로 변경
UPDATE user_subscriptions
SET plan_id = (SELECT plan_id FROM subscription_plans WHERE plan_name = 'pro')
WHERE user_id = 'YOUR_USER_ID';
```

---

## 다운그레이드 정책 (Grandfather Policy)

**기존 데이터 유지 + 추가만 차단**

```
Pro 플랜 (가게 5개 운영 중)
    ↓
구독 취소 → Free 플랜 (max_stores: 1)
    ↓
┌─────────────────────────────────────────┐
│  기존 가게 5개: ✅ 계속 사용 가능        │
│  새 가게 추가:  ❌ 차단 + 업그레이드 유도 │
│  가게 삭제 후:  1개 이하일 때만 추가 가능 │
└─────────────────────────────────────────┘
```

---

## 요약

새로운 기능에서 구독 제한이 필요할 때:

1. `import 'package:myfinance_improved/core/subscription/index.dart';` 추가
2. `ref.watch(xxxLimitFromCacheProvider)` 로 UI 표시
3. 생성 전 `ref.read(xxxLimitFreshProvider().future)` 로 최신 확인
4. 제한 시 `SubscriptionUpgradeDialog.show()` 호출
