# Subscription Plan Limits Implementation Plan (v2)

> 작성일: 2026-01-22
> 상태: 승인됨 - 구현 대기

---

## Overview

구독 플랜별 제한(회사/가게/직원 수)을 **하이브리드 방식**으로 구현

- **Single Source of Truth**: `subscription_plans` 테이블
- **2026 Best Practice**: Stale-While-Revalidate + Realtime + Backend 검증
- **다운그레이드 정책**: Soft Limit (기존 데이터 유지 + 추가만 차단)

---

## 현재 DB 제한값 (subscription_plans 테이블)

| Plan | max_companies | max_stores | max_employees | ai_daily_limit |
|------|---------------|------------|---------------|----------------|
| Free | 1 | 1 | 5 | 10 |
| Basic | 1 | 3 | 15 | null (무제한) |
| Pro | null (무제한) | null (무제한) | null (무제한) | null (무제한) |

---

## 하이브리드 아키텍처 (3단계 검증)

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
│  + Realtime (자동 동기화) - 선택사항                        │
│     └─ stores/employees 테이블 변경 시 자동 업데이트         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Implementation Steps

### Step 1: 기존 RPC 수정 - employee_count 추가

**파일**: `get_user_companies_with_subscription` RPC 수정

현재 이미 `store_count`와 `subscription` 정보를 반환 중. `employee_count`만 추가:

```sql
'employee_count', (
  SELECT COUNT(DISTINCT ur.user_id)
  FROM user_roles ur
  JOIN roles r ON r.role_id = ur.role_id
  WHERE r.company_id = c.company_id
    AND ur.is_deleted = false
    AND r.is_deleted = false
)
```

**반환값 예시**:
```json
{
  "companies": [{
    "company_id": "...",
    "subscription": {
      "plan_name": "free",
      "max_stores": 1,
      "max_employees": 5,
      "max_companies": 1
    },
    "store_count": 1,
    "employee_count": 3
  }]
}
```

---

### Step 2: 가벼운 검증 RPC 생성

**파일**: 새 migration (`supabase/migrations/YYYYMMDD_check_subscription_limit.sql`)

생성 시점에 최신 count만 빠르게 확인하는 함수:

```sql
CREATE OR REPLACE FUNCTION check_subscription_limit(
  p_user_id UUID,
  p_check_type TEXT,  -- 'company', 'store', 'employee'
  p_company_id UUID DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql SECURITY DEFINER
AS $$
DECLARE
  v_plan_name TEXT;
  v_max_limit INT;
  v_current_count INT;
  v_can_add BOOLEAN;
BEGIN
  -- check_type에 따라 분기
  IF p_check_type = 'company' THEN
    -- 사용자의 구독 플랜에서 max_companies 조회
    SELECT COALESCE(sp.plan_name, 'free'), sp.max_companies
    INTO v_plan_name, v_max_limit
    FROM subscription_user su
    JOIN subscription_plans sp ON sp.plan_id = su.plan_id
    WHERE su.user_id = p_user_id
      AND su.status IN ('active', 'trialing')
    LIMIT 1;

    -- 기본값 (구독 없으면 free)
    IF v_plan_name IS NULL THEN
      SELECT plan_name, max_companies INTO v_plan_name, v_max_limit
      FROM subscription_plans WHERE plan_name = 'free' LIMIT 1;
    END IF;

    -- 현재 소유 회사 수
    SELECT COUNT(DISTINCT c.company_id) INTO v_current_count
    FROM companies c
    JOIN roles r ON r.company_id = c.company_id AND r.role_type = 'owner'
    JOIN user_roles ur ON ur.role_id = r.role_id AND ur.user_id = p_user_id
    WHERE c.is_deleted = false AND ur.is_deleted = false;

  ELSIF p_check_type = 'store' THEN
    -- 회사의 구독 플랜에서 max_stores 조회
    SELECT COALESCE(sp.plan_name, 'free'), sp.max_stores
    INTO v_plan_name, v_max_limit
    FROM companies c
    LEFT JOIN subscription_plans sp ON sp.plan_id = c.inherited_plan_id
    WHERE c.company_id = p_company_id AND c.is_deleted = false;

    IF v_plan_name IS NULL THEN
      SELECT plan_name, max_stores INTO v_plan_name, v_max_limit
      FROM subscription_plans WHERE plan_name = 'free' LIMIT 1;
    END IF;

    -- 현재 가게 수
    SELECT COUNT(*) INTO v_current_count
    FROM stores WHERE company_id = p_company_id AND is_deleted = false;

  ELSIF p_check_type = 'employee' THEN
    -- 회사의 구독 플랜에서 max_employees 조회
    SELECT COALESCE(sp.plan_name, 'free'), sp.max_employees
    INTO v_plan_name, v_max_limit
    FROM companies c
    LEFT JOIN subscription_plans sp ON sp.plan_id = c.inherited_plan_id
    WHERE c.company_id = p_company_id AND c.is_deleted = false;

    IF v_plan_name IS NULL THEN
      SELECT plan_name, max_employees INTO v_plan_name, v_max_limit
      FROM subscription_plans WHERE plan_name = 'free' LIMIT 1;
    END IF;

    -- 현재 직원 수
    SELECT COUNT(DISTINCT ur.user_id) INTO v_current_count
    FROM user_roles ur
    JOIN roles r ON r.role_id = ur.role_id
    WHERE r.company_id = p_company_id
      AND ur.is_deleted = false AND r.is_deleted = false;
  ELSE
    RETURN jsonb_build_object('success', false, 'error', 'Invalid check_type');
  END IF;

  -- null이면 무제한
  IF v_max_limit IS NULL THEN
    v_can_add := true;
  ELSE
    v_can_add := v_current_count < v_max_limit;
  END IF;

  RETURN jsonb_build_object(
    'success', true,
    'can_add', v_can_add,
    'plan_name', COALESCE(v_plan_name, 'free'),
    'max_limit', v_max_limit,
    'current_count', v_current_count
  );
END;
$$;
```

**반환값**:
```json
{
  "success": true,
  "can_add": false,
  "plan_name": "free",
  "max_limit": 1,
  "current_count": 1
}
```

---

### Step 3: AppState 확장

**파일**: `lib/app/providers/app_state.dart`

현재 사용량 필드 추가:

```dart
@freezed
class AppState with _$AppState {
  const factory AppState({
    // ... 기존 필드들 ...

    // 기존 (제한값)
    @Default(1) int maxStores,
    @Default(5) int maxEmployees,
    @Default(1) int maxCompanies,

    // 신규 (현재 사용량)
    @Default(0) int currentStoreCount,
    @Default(0) int currentEmployeeCount,
    @Default(0) int currentCompanyCount,
  }) = _AppState;
}
```

---

### Step 4: AppStateNotifier 수정

**파일**: `lib/app/providers/app_state_notifier.dart`

회사 선택 시 사용량 정보도 함께 저장:

```dart
void selectCompany(Map<String, dynamic> companyData) {
  final subscription = companyData['subscription'] as Map<String, dynamic>?;

  state = state.copyWith(
    companyChoosen: companyData['company_id'] as String,
    companyName: companyData['company_name'] as String? ?? '',

    // 제한값 (null이면 무제한 = -1로 저장)
    maxStores: subscription?['max_stores'] as int? ?? 1,
    maxEmployees: subscription?['max_employees'] as int? ?? 5,
    maxCompanies: subscription?['max_companies'] as int? ?? 1,

    // 현재 사용량
    currentStoreCount: companyData['store_count'] as int? ?? 0,
    currentEmployeeCount: companyData['employee_count'] as int? ?? 0,
  );
}

// 회사 목록 로드 시 company_count도 저장
void setCompanyCount(int count) {
  state = state.copyWith(currentCompanyCount: count);
}
```

---

### Step 5: SubscriptionLimitCheck Entity

**파일**: 신규 `lib/core/domain/entities/subscription_limit_check.dart`

```dart
/// 구독 제한 체크 결과
///
/// 회사/가게/직원 추가 가능 여부와 현재 사용량 정보를 담음
class SubscriptionLimitCheck {
  const SubscriptionLimitCheck({
    required this.canAdd,
    required this.planName,
    required this.maxLimit,
    required this.currentCount,
  });

  /// RPC 결과에서 생성
  factory SubscriptionLimitCheck.fromJson(Map<String, dynamic> json) {
    return SubscriptionLimitCheck(
      canAdd: json['can_add'] as bool? ?? false,
      planName: json['plan_name'] as String? ?? 'free',
      maxLimit: json['max_limit'] as int?,
      currentCount: json['current_count'] as int? ?? 0,
    );
  }

  final bool canAdd;
  final String planName;
  final int? maxLimit;      // null = unlimited
  final int currentCount;

  /// 무제한인지 확인
  bool get isUnlimited => maxLimit == null;

  /// 제한에 도달했는지 확인
  bool get isAtLimit => !isUnlimited && currentCount >= maxLimit!;

  /// 표시용 텍스트 (예: "3 / 5" 또는 "Unlimited")
  String get limitDisplayText => isUnlimited ? 'Unlimited' : '$currentCount / $maxLimit';

  /// 남은 개수 (무제한이면 -1)
  int get remaining => isUnlimited ? -1 : (maxLimit! - currentCount).clamp(0, maxLimit!);

  /// 업그레이드 권유 메시지
  String get upgradeMessage {
    switch (planName) {
      case 'free':
        return 'Upgrade to Basic or Pro for more capacity';
      case 'basic':
        return 'Upgrade to Pro for unlimited capacity';
      default:
        return '';
    }
  }

  /// 플랜 표시 이름
  String get planDisplayName {
    switch (planName) {
      case 'free': return 'Free';
      case 'basic': return 'Basic';
      case 'pro': return 'Pro';
      default: return planName.toUpperCase();
    }
  }
}
```

---

### Step 6: Subscription Limit Providers

**파일**: 신규 `lib/core/providers/subscription_limit_providers.dart`

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../app/providers/app_state_provider.dart';
import '../domain/entities/subscription_limit_check.dart';

part 'subscription_limit_providers.g.dart';

// ============================================================================
// 캐시 기반 Provider (즉각 반응)
// ============================================================================

/// 회사 추가 제한 (캐시)
@riverpod
SubscriptionLimitCheck companyLimitFromCache(CompanyLimitFromCacheRef ref) {
  final appState = ref.watch(appStateProvider);
  final isUnlimited = appState.maxCompanies == -1 || appState.maxCompanies == null;

  return SubscriptionLimitCheck(
    canAdd: isUnlimited || appState.currentCompanyCount < appState.maxCompanies,
    planName: appState.planType,
    maxLimit: isUnlimited ? null : appState.maxCompanies,
    currentCount: appState.currentCompanyCount,
  );
}

/// 가게 추가 제한 (캐시)
@riverpod
SubscriptionLimitCheck storeLimitFromCache(StoreLimitFromCacheRef ref) {
  final appState = ref.watch(appStateProvider);
  final isUnlimited = appState.maxStores == -1 || appState.hasUnlimitedStores;

  return SubscriptionLimitCheck(
    canAdd: isUnlimited || appState.currentStoreCount < appState.maxStores,
    planName: appState.planType,
    maxLimit: isUnlimited ? null : appState.maxStores,
    currentCount: appState.currentStoreCount,
  );
}

/// 직원 추가 제한 (캐시)
@riverpod
SubscriptionLimitCheck employeeLimitFromCache(EmployeeLimitFromCacheRef ref) {
  final appState = ref.watch(appStateProvider);
  final isUnlimited = appState.maxEmployees == -1 || appState.hasUnlimitedEmployees;

  return SubscriptionLimitCheck(
    canAdd: isUnlimited || appState.currentEmployeeCount < appState.maxEmployees,
    planName: appState.planType,
    maxLimit: isUnlimited ? null : appState.maxEmployees,
    currentCount: appState.currentEmployeeCount,
  );
}

// ============================================================================
// Fresh Provider (생성 시점 최신 확인)
// ============================================================================

final _supabase = Supabase.instance.client;

/// 회사 추가 제한 (최신 확인)
@riverpod
Future<SubscriptionLimitCheck> companyLimitFresh(CompanyLimitFreshRef ref) async {
  final userId = ref.read(appStateProvider).userId;

  final result = await _supabase.rpc('check_subscription_limit', params: {
    'p_user_id': userId,
    'p_check_type': 'company',
  });

  return SubscriptionLimitCheck.fromJson(result as Map<String, dynamic>);
}

/// 가게 추가 제한 (최신 확인)
@riverpod
Future<SubscriptionLimitCheck> storeLimitFresh(StoreLimitFreshRef ref, String companyId) async {
  final userId = ref.read(appStateProvider).userId;

  final result = await _supabase.rpc('check_subscription_limit', params: {
    'p_user_id': userId,
    'p_check_type': 'store',
    'p_company_id': companyId,
  });

  return SubscriptionLimitCheck.fromJson(result as Map<String, dynamic>);
}

/// 직원 추가 제한 (최신 확인)
@riverpod
Future<SubscriptionLimitCheck> employeeLimitFresh(EmployeeLimitFreshRef ref, String companyId) async {
  final userId = ref.read(appStateProvider).userId;

  final result = await _supabase.rpc('check_subscription_limit', params: {
    'p_user_id': userId,
    'p_check_type': 'employee',
    'p_company_id': companyId,
  });

  return SubscriptionLimitCheck.fromJson(result as Map<String, dynamic>);
}
```

---

### Step 7: SubscriptionUpgradeDialog 위젯

**파일**: 신규 `lib/shared/widgets/dialogs/subscription_upgrade_dialog.dart`

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/domain/entities/subscription_limit_check.dart';
import '../../themes/toss_colors.dart';
import '../../themes/toss_text_styles.dart';
import '../../themes/toss_spacing.dart';
import '../../themes/toss_border_radius.dart';

/// 구독 제한 도달 시 업그레이드 유도 다이얼로그
class SubscriptionUpgradeDialog extends StatelessWidget {
  const SubscriptionUpgradeDialog({
    super.key,
    required this.resourceType,
    required this.limitCheck,
  });

  /// 리소스 타입 ('company', 'store', 'employee')
  final String resourceType;

  /// 제한 체크 결과
  final SubscriptionLimitCheck limitCheck;

  /// 다이얼로그 표시
  static Future<bool?> show(
    BuildContext context, {
    required String resourceType,
    required SubscriptionLimitCheck limitCheck,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => SubscriptionUpgradeDialog(
        resourceType: resourceType,
        limitCheck: limitCheck,
      ),
    );
  }

  String get _resourceLabel {
    switch (resourceType) {
      case 'company': return 'company';
      case 'store': return 'store';
      case 'employee': return 'team member';
      default: return resourceType;
    }
  }

  String get _resourceLabelKo {
    switch (resourceType) {
      case 'company': return '회사';
      case 'store': return '가게';
      case 'employee': return '직원';
      default: return resourceType;
    }
  }

  IconData get _icon {
    switch (resourceType) {
      case 'company': return Icons.business;
      case 'store': return Icons.store;
      case 'employee': return Icons.people;
      default: return Icons.lock;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.dialog),
      ),
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.paddingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 아이콘
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: TossColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _icon,
                size: 32,
                color: TossColors.primary,
              ),
            ),

            const SizedBox(height: TossSpacing.space5),

            // 제목
            Text(
              '${_resourceLabelKo} 제한에 도달했습니다',
              style: TossTextStyles.h4.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: TossSpacing.space3),

            // 설명
            Text(
              '${limitCheck.planDisplayName} 플랜에서는 $_resourceLabel을(를) ${limitCheck.maxLimit}개까지 추가할 수 있습니다.',
              style: TossTextStyles.body.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: TossSpacing.space5),

            // 현재 사용량 카드
            Container(
              padding: const EdgeInsets.all(TossSpacing.paddingMD),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(TossBorderRadius.card),
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    context,
                    'Current Plan',
                    limitCheck.planDisplayName,
                  ),
                  const SizedBox(height: TossSpacing.space2),
                  _buildInfoRow(
                    context,
                    'Usage',
                    limitCheck.limitDisplayText,
                    valueColor: limitCheck.isAtLimit ? TossColors.error : null,
                  ),
                ],
              ),
            ),

            const SizedBox(height: TossSpacing.space4),

            // 업그레이드 메시지
            if (limitCheck.upgradeMessage.isNotEmpty)
              Text(
                limitCheck.upgradeMessage,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.primary,
                ),
                textAlign: TextAlign.center,
              ),

            const SizedBox(height: TossSpacing.space6),

            // 버튼들
            Row(
              children: [
                // Maybe Later
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: TossSpacing.space4,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.button),
                      ),
                    ),
                    child: Text(
                      'Maybe Later',
                      style: TossTextStyles.body.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: TossSpacing.space3),

                // Upgrade
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      context.push('/my-page/subscription');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TossColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: TossSpacing.space4,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.button),
                      ),
                    ),
                    child: Text(
                      'Upgrade Plan',
                      style: TossTextStyles.body.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.body.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor ?? Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
```

---

### Step 8: UI 수정 - 하이브리드 체크 적용

#### 8.1 CompanyActionsSheet

**파일**: `lib/features/homepage/presentation/widgets/bottom_sheets/company_actions_sheet.dart`

```dart
// 변경 사항:
// 1. companyLimitFromCacheProvider 구독
// 2. 제한 도달 시 subtitle 변경 + 클릭 시 UpgradeDialog

@override
Widget build(BuildContext context, WidgetRef ref) {
  final limitCache = ref.watch(companyLimitFromCacheProvider);

  // ... 기존 UI 코드 ...

  // Create Company 옵션
  _buildOptionCard(
    context,
    icon: Icons.business,
    title: 'Create Company',
    subtitle: limitCache.canAdd
        ? 'Start a new company and invite others'
        : 'Limit reached (${limitCache.limitDisplayText})',
    isDisabled: !limitCache.canAdd,
    onTap: () async {
      if (!limitCache.canAdd) {
        Navigator.pop(context);
        SubscriptionUpgradeDialog.show(
          context,
          resourceType: 'company',
          limitCheck: limitCache,
        );
        return;
      }

      // 최신 확인
      final freshLimit = await ref.read(companyLimitFreshProvider.future);
      if (!freshLimit.canAdd) {
        Navigator.pop(context);
        SubscriptionUpgradeDialog.show(
          context,
          resourceType: 'company',
          limitCheck: freshLimit,
        );
        return;
      }

      onCreateCompany();
    },
  ),
}
```

#### 8.2 StoreActionsSheet

**파일**: `lib/features/homepage/presentation/widgets/bottom_sheets/store_actions_sheet.dart`

동일한 패턴으로 `storeLimitFromCacheProvider` 적용

#### 8.3 MembersTab

**파일**: `lib/features/delegate_role/presentation/widgets/role_management/members_tab.dart`

"+" 버튼에 `employeeLimitFromCacheProvider` 적용

---

## Files Summary

### 신규 파일 (4개)

| 파일 | 목적 |
|------|------|
| `supabase/migrations/YYYYMMDD_check_subscription_limit.sql` | 가벼운 검증 RPC |
| `lib/core/domain/entities/subscription_limit_check.dart` | Entity |
| `lib/core/providers/subscription_limit_providers.dart` | Cache + Fresh Providers |
| `lib/shared/widgets/dialogs/subscription_upgrade_dialog.dart` | 업그레이드 다이얼로그 |

### 수정 파일 (5개)

| 파일 | 변경 내용 |
|------|----------|
| `get_user_companies_with_subscription` RPC | employee_count 추가 |
| `lib/app/providers/app_state.dart` | currentStoreCount, currentEmployeeCount, currentCompanyCount 추가 |
| `lib/app/providers/app_state_notifier.dart` | 사용량 저장 로직 |
| `company_actions_sheet.dart` | 하이브리드 체크 적용 |
| `store_actions_sheet.dart` | 하이브리드 체크 적용 |
| `members_tab.dart` | 하이브리드 체크 적용 |

---

## 데이터 흐름도

```
┌─────────────────────────────────────────────────────────────┐
│                     앱 시작 / 회사 선택                       │
└─────────────────────────┬───────────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────────┐
│  get_user_companies_with_subscription RPC                    │
│  → subscription (max_stores, max_employees, max_companies)   │
│  → store_count, employee_count                               │
│  → company_count                                             │
└─────────────────────────┬───────────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                      AppState 저장                           │
│  maxStores, maxEmployees, maxCompanies                      │
│  currentStoreCount, currentEmployeeCount, currentCompanyCount│
└─────────────────────────┬───────────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                    UI 즉시 반응                              │
│  xxxLimitFromCacheProvider → 버튼 활성화/비활성화            │
└─────────────────────────┬───────────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────────┐
│               사용자가 "Create" 버튼 클릭                    │
└─────────────────────────┬───────────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────────┐
│  xxxLimitFreshProvider → check_subscription_limit RPC        │
│  (최신 count 확인 - 다른 기기 동기화 대응)                    │
└─────────────────────────┬───────────────────────────────────┘
                          ▼
              ┌───────────┴───────────┐
              ▼                       ▼
        can_add = true          can_add = false
              ▼                       ▼
        생성 Sheet 열기         UpgradeDialog 표시
              ▼
┌─────────────────────────────────────────────────────────────┐
│  Backend INSERT 시 최종 검증 (보안 - 선택사항)               │
└─────────────────────────────────────────────────────────────┘
```

---

## 구독 다운그레이드/취소 처리 (Soft Limit)

### 정책
**기존 데이터 유지 + 추가만 차단** (Grandfather Policy)

### 시나리오 예시

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

### 장점

| 항목 | 설명 |
|------|------|
| 사용자 데이터 보호 | 갑자기 데이터 접근 불가 방지 |
| 구현 단순 | 추가 로직만 체크, 기존 데이터 처리 불필요 |
| 업계 표준 | Slack, Notion, GitHub 등 대부분 SaaS 방식 |
| 업그레이드 유도 | 자연스럽게 유료 전환 유도 |

---

## Verification Plan

1. **RPC 테스트**:
   - `get_user_companies_with_subscription`에서 employee_count 정상 반환 확인
   - `check_subscription_limit`에서 정확한 can_add 반환 확인

2. **캐시 동작 테스트**:
   - 앱 시작 시 AppState에 사용량 정보 저장 확인
   - UI에서 캐시 기반 즉시 반응 확인

3. **최신 확인 테스트**:
   - 다른 기기에서 가게 추가 후, 원래 기기에서 "Create Store" 클릭 시 제한 감지 확인

4. **E2E 테스트**:
   - Free 플랜: 가게 1개 후 추가 시 → 업그레이드 다이얼로그
   - Basic 플랜: 가게 3개 후 추가 시 → 업그레이드 다이얼로그
   - Pro 플랜: 무제한 추가 가능 확인

5. **다운그레이드 테스트**:
   - Pro → Free 전환 후 기존 데이터 접근 가능 확인
   - 추가 생성만 차단되는지 확인
