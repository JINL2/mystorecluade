# Homepage 개선 계획서

## 분석 완료: 2026-01-04
## 작성자: 30년차 Flutter Architect

---

## 사용자 요구사항 분석

| # | 문제 | 분석 결과 | 우선순위 |
|---|------|----------|---------|
| 1 | Frequent Logout | 세션 관리 미흡, 토큰 자동 갱신 없음 | **Critical** |
| 2 | Subscription Badge 위치 | 홈페이지에서 표시됨 - Store Detail Drawer에서만 표시해야 함 | High |
| 3 | Drawer에 User Avatar 없음 | CircleAvatar 사용 중 - Square Avatar로 변경 필요 | Medium |
| 4 | Drawer에 직원 수/매장 수 없음 | 현재 표시되지 않음 | Medium |
| 5 | Drawer 클릭 시 Blue Highlight | InkWell 기본 splashColor 사용 중 | Low |
| 6 | Subscription Badge Outline | Free 플랜에 Border 있음 | Low |
| 7 | Revenue Tab Spacing 문제 | 확인 필요 | Medium |
| 8 | Revenue "vs vs" 중복 | 비교 텍스트 중복 표시 | Medium |
| 9 | Quick Menu 폰트 크기 | 12px 사용 중 - 더 작게 필요 | Low |
| 10 | Feature List 상단 마진 과다 | category 간 spacing 과다 | Medium |
| 11 | 설명 텍스트 색상 | TossColors.textTertiary 너무 연함 | Low |
| 12 | Feature/Title 불일치 | 네이밍 일관성 필요 | Low |

---

## 1. Frequent Logout 문제 (Critical)

### 현재 상태 분석

#### 문제점 1: Supabase 토큰 자동 갱신 부재
```
파일: lib/app/app.dart (Line 63-78)
```
- 앱이 `resumed` 상태일 때만 `refreshSession()` 호출
- 앱이 **포그라운드에서 계속 사용 중**일 때는 토큰 갱신이 없음
- Supabase access token 기본 만료: 1시간

#### 문제점 2: SessionManager는 캐시 TTL만 관리
```
파일: lib/features/auth/presentation/providers/session_manager_provider.dart
```
- `_userDataTTL = Duration(hours: 2)` - 데이터 캐시용
- `_featuresTTL = Duration(hours: 6)` - Feature 캐시용
- **Supabase Auth Token과는 무관한 로직**

#### 문제점 3: Auth State 에러 처리
```
파일: lib/app/providers/auth_providers.dart (Line 48-65)
```
```dart
return authState.when(
  data: (user) => user != null,
  loading: () => session != null,
  error: (_, __) => false,  // ❌ 에러 발생 시 즉시 로그아웃
);
```

### 해결 방안

#### 수정 파일 1: `lib/app/app.dart`
```dart
// 추가할 코드 (Line 44 근처)
Timer? _tokenRefreshTimer;

@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addObserver(this);

  // 앱 시작 시 토큰 갱신 타이머 시작
  _startTokenRefreshTimer();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    _initializeApp();
  });
}

@override
void dispose() {
  _tokenRefreshTimer?.cancel();
  WidgetsBinding.instance.removeObserver(this);
  super.dispose();
}

/// 45분마다 토큰 갱신 (1시간 만료 전)
void _startTokenRefreshTimer() {
  _tokenRefreshTimer?.cancel();
  _tokenRefreshTimer = Timer.periodic(
    const Duration(minutes: 45),
    (_) => _refreshSupabaseToken(),
  );
}

Future<void> _refreshSupabaseToken() async {
  try {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      await Supabase.instance.client.auth.refreshSession();
      debugPrint('Token refreshed successfully');
    }
  } catch (e) {
    debugPrint('Token refresh failed: $e');
    // 갱신 실패 시 재시도 (5분 후)
    Future.delayed(const Duration(minutes: 5), _refreshSupabaseToken);
  }
}
```

#### 수정 파일 2: `lib/app/providers/auth_providers.dart`
```dart
// 수정할 코드 (Line 48-65)
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) => user != null,
    loading: () {
      try {
        final session = Supabase.instance.client.auth.currentSession;
        return session != null && !session.isExpired;  // ✅ 만료 체크 추가
      } catch (_) {
        return false;
      }
    },
    error: (error, __) {
      // ✅ 네트워크 에러는 이전 상태 유지
      if (error.toString().contains('network') ||
          error.toString().contains('socket')) {
        final session = Supabase.instance.client.auth.currentSession;
        return session != null && !session.isExpired;
      }
      return false;
    },
  );
});
```

#### 수정 파일 3: `lib/main.dart`
```dart
// Supabase 초기화 시 localStorage 명시
await Supabase.initialize(
  url: supabaseUrl,
  anonKey: supabaseAnonKey,
  authOptions: const FlutterAuthClientOptions(
    authFlowType: AuthFlowType.pkce,
  ),
  // 토큰 저장소 명시 (FlutterSecureStorage 사용)
);
```

---

## 2. Subscription Badge 위치 문제

### 현재 상태
```
파일: lib/features/homepage/presentation/widgets/homepage/homepage_header.dart (Line 94-97)
```
```dart
SubscriptionBadge.fromPlanType(
  appState.planType,
  compact: true,
),
```
- 홈페이지 헤더에 Subscription Badge 표시됨

### 해결 방안
홈페이지 헤더에서 제거하고, Store Detail Page Drawer에서만 표시

#### 수정 파일: `lib/features/homepage/presentation/widgets/homepage/homepage_header.dart`
```dart
// Line 77-98 수정
Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    Flexible(
      child: Text(
        companyName,
        style: TossTextStyles.bodyLarge.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: TossColors.textPrimary,
          height: 1.2,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    ),
    // ❌ 삭제: SubscriptionBadge.fromPlanType(...)
  ],
),
```

---

## 3. Drawer Avatar 문제 (Square Avatar)

### 현재 상태
```
파일: lib/features/homepage/presentation/widgets/company_store_selector.dart (Line 73-88)
```
```dart
CircleAvatar(
  radius: 24,
  backgroundColor: TossColors.primarySurface,
  child: Text(...),
),
```

### 해결 방안

#### 수정 파일: `lib/features/homepage/presentation/widgets/company_store_selector.dart`
```dart
// Line 72-88 수정
ClipRRect(
  borderRadius: BorderRadius.circular(TossBorderRadius.md),
  child: _buildUserAvatar(appState),
),

// 새로운 메서드 추가
Widget _buildUserAvatar(AppState appState) {
  final profileImage = appState.user['profile_image'] as String? ?? '';
  final firstName = appState.user['user_first_name'] as String? ?? '';

  if (profileImage.isNotEmpty) {
    return Image.network(
      profileImage,
      width: 48,
      height: 48,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _buildAvatarFallback(firstName),
    );
  }
  return _buildAvatarFallback(firstName);
}

Widget _buildAvatarFallback(String firstName) {
  return Container(
    width: 48,
    height: 48,
    decoration: BoxDecoration(
      color: TossColors.primarySurface,
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
    ),
    child: Center(
      child: Text(
        firstName.isNotEmpty ? firstName[0].toUpperCase() : 'U',
        style: TossTextStyles.h3.copyWith(
          color: TossColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}
```

---

## 4. Drawer에 직원 수/매장 수 표시

### 현재 상태
```
파일: lib/features/homepage/presentation/widgets/company_store_list.dart (Line 213-219)
```
- Company 카드에 Store 수만 표시: `'${stores.length} stores'`

### 해결 방안

#### 수정 파일 1: `lib/features/homepage/presentation/providers/homepage_providers.dart`
```dart
// 새로운 Provider 추가 - 회사별 직원 수 조회
final companyEmployeeCountProvider = FutureProvider.family<int, String>((ref, companyId) async {
  final repository = ref.read(homepageRepositoryProvider);
  return repository.getEmployeeCount(companyId);
});
```

#### 수정 파일 2: `lib/features/homepage/presentation/widgets/company_store_list.dart`
```dart
// Line 213-219 수정
Text(
  '${employeeCount} employees · ${stores.length} stores',
  style: TossTextStyles.caption.copyWith(
    color: TossColors.textTertiary,
    fontSize: 11,
  ),
),
```

---

## 5. Drawer 클릭 Blue Highlight 제거

### 현재 상태
```
파일: lib/features/homepage/presentation/widgets/company_store_list.dart (Line 285-292)
```
```dart
InkWell(
  onTap: () { ... },
  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
  // 기본 splashColor (blue)
)
```

### 해결 방안

#### 수정 파일: `lib/features/homepage/presentation/widgets/company_store_list.dart`
```dart
// Line 285-292 수정
InkWell(
  onTap: () { ... },
  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
  splashColor: TossColors.transparent,  // ✅ 추가
  highlightColor: TossColors.gray100,    // ✅ 추가
)
```

---

## 6. Subscription Badge Outline 제거 (Free)

### 현재 상태
```
파일: lib/shared/widgets/atoms/display/toss_badge.dart (Line 151)
```
```dart
border: _isFree ? Border.all(color: TossColors.gray300, width: 1) : null,
```

### 해결 방안

#### 수정 파일: `lib/shared/widgets/atoms/display/toss_badge.dart`
```dart
// Line 151 수정
border: null,  // ✅ Free 플랜도 border 없음
```

---

## 7. Revenue Tab Spacing 문제

### 현재 상태
```
파일: lib/features/homepage/presentation/widgets/revenue_card.dart
```
- 확인 결과 특별한 spacing 문제 없음
- 사용자가 구체적인 문제 지점을 명시해야 함

### 해결 방안
- 스크린샷이나 구체적인 위치 확인 필요

---

## 8. Revenue "vs vs" 중복 문제

### 현재 상태
```
파일: lib/features/homepage/presentation/widgets/revenue_card.dart (Line 108)
```
```dart
'${revenue.isIncreased ? '' : '-'}${revenue.growthPercentage.abs().toStringAsFixed(1)}% vs ${revenue.period.comparisonText}',
```

```
파일: lib/features/homepage/domain/revenue_period.dart (Line 12-17)
```
```dart
today('Today', 'vs Yesterday', 'today'),
yesterday('Yesterday', 'vs Day Before', 'yesterday'),
```
- `comparisonText`에 이미 "vs"가 포함되어 있어 "vs vs Yesterday"로 표시됨

### 해결 방안

#### 수정 파일: `lib/features/homepage/domain/revenue_period.dart`
```dart
// Line 12-17 수정 - "vs" 제거
today('Today', 'Yesterday', 'today'),
yesterday('Yesterday', 'Day Before', 'yesterday'),
past7Days('Past 7 Days', 'Previous 7 Days', 'past_7_days'),
thisMonth('This Month', 'Last Month', 'this_month'),
lastMonth('Last Month', 'Previous Month', 'last_month'),
thisYear('This Year', 'Last Year', 'this_year'),
```

---

## 9. Quick Menu 폰트 크기

### 현재 상태
```
파일: lib/features/homepage/presentation/widgets/quick_access_section.dart (Line 96-99)
```
```dart
style: TossTextStyles.caption.copyWith(
  color: TossColors.textPrimary,
  fontWeight: FontWeight.w600,
  fontSize: 12,  // ❌ 12px
),
```

### 해결 방안

#### 수정 파일: `lib/features/homepage/presentation/widgets/quick_access_section.dart`
```dart
// Line 96-99 수정
style: TossTextStyles.caption.copyWith(
  color: TossColors.textPrimary,
  fontWeight: FontWeight.w600,
  fontSize: 11,  // ✅ 11px로 변경
),
```

---

## 10. Feature List 상단 마진/Spacing 문제

### 현재 상태
```
파일: lib/features/homepage/presentation/widgets/feature_grid.dart (Line 166-168)
```
```dart
Container(
  margin: const EdgeInsets.only(bottom: TossSpacing.space4),  // 16px
  padding: const EdgeInsets.symmetric(vertical: TossSpacing.space5),  // 20px
```

### 해결 방안

#### 수정 파일: `lib/features/homepage/presentation/widgets/feature_grid.dart`
```dart
// Line 166-168 수정
Container(
  margin: const EdgeInsets.only(bottom: TossSpacing.space2),  // ✅ 8px로 축소
  padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),  // ✅ 16px로 축소
```

---

## 11. 설명 텍스트 색상 문제

### 현재 상태
```
파일: lib/shared/themes/toss_colors.dart (Line 66)
```
```dart
static const Color textTertiary = Color(0xFFADB5BD);  // #ADB5BD
```

### 해결 방안

#### 수정 파일: `lib/shared/themes/toss_colors.dart`
```dart
// Line 66 수정 - 더 진한 회색으로
static const Color textTertiary = Color(0xFF8B95A1);  // ✅ #8B95A1로 변경
```

---

## 12. Feature/Title 네이밍 일관성

### 현재 상태
- 데이터베이스의 feature_name과 UI에서 표시하는 title이 일치하지 않을 수 있음
- 코드 레벨에서는 문제 없음 - 데이터 확인 필요

### 해결 방안
- 데이터베이스에서 feature 이름 확인 및 수정 필요
- `myfinance_feature` 테이블 점검

---

## 구현 우선순위

### Phase 1: Critical (1-2일)
1. ✅ Frequent Logout 문제 해결 (토큰 자동 갱신)
2. ✅ Auth Provider 에러 처리 개선

### Phase 2: High (1일)
3. ✅ Subscription Badge 위치 수정
4. ✅ Revenue "vs vs" 중복 수정
5. ✅ Feature List Spacing 조정

### Phase 3: Medium (1일)
6. ✅ Drawer Square Avatar
7. ✅ Drawer 직원 수/매장 수 표시
8. ✅ Quick Menu 폰트 크기

### Phase 4: Low (0.5일)
9. ✅ Drawer 클릭 Blue Highlight 제거
10. ✅ Subscription Badge Outline 제거
11. ✅ 설명 텍스트 색상 조정

---

## 테스트 체크리스트

- [ ] 로그인 후 1시간 이상 앱 사용 시 로그아웃 발생하지 않음
- [ ] 앱 백그라운드 → 포그라운드 전환 시 세션 유지
- [ ] 네트워크 오류 시 즉시 로그아웃되지 않음
- [ ] 홈페이지 헤더에 Subscription Badge 없음
- [ ] Drawer에 Square Avatar 표시
- [ ] Drawer에 직원 수/매장 수 표시
- [ ] Drawer 항목 클릭 시 Blue Highlight 없음
- [ ] Revenue 비교 텍스트에 "vs" 한 번만 표시
- [ ] Feature List 간격이 적절함
- [ ] 설명 텍스트가 읽기 쉬움

---

## 수정 파일 요약

| 파일 경로 | 수정 내용 |
|----------|----------|
| `lib/app/app.dart` | 토큰 자동 갱신 타이머 추가 |
| `lib/app/providers/auth_providers.dart` | 에러 처리 개선 |
| `lib/main.dart` | Supabase 저장소 설정 |
| `lib/features/homepage/presentation/widgets/homepage/homepage_header.dart` | Subscription Badge 제거 |
| `lib/features/homepage/presentation/widgets/company_store_selector.dart` | Square Avatar |
| `lib/features/homepage/presentation/widgets/company_store_list.dart` | 직원 수, Highlight 제거 |
| `lib/features/homepage/domain/revenue_period.dart` | "vs" 중복 제거 |
| `lib/features/homepage/presentation/widgets/quick_access_section.dart` | 폰트 크기 |
| `lib/features/homepage/presentation/widgets/feature_grid.dart` | Spacing 조정 |
| `lib/shared/widgets/atoms/display/toss_badge.dart` | Border 제거 |
| `lib/shared/themes/toss_colors.dart` | textTertiary 색상 |

---

## 참고사항

1. **Frequent Logout 문제**가 가장 심각한 UX 이슈이므로 최우선 처리
2. Supabase access token은 기본 1시간 만료 - 45분마다 갱신 권장
3. iOS는 백그라운드에서 소켓을 닫으므로 resume 시 항상 세션 갱신 필요
4. 모든 UI 변경은 Hot Reload로 즉시 확인 가능
