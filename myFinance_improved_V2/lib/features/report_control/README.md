# Report Control Feature

보고서 구독 및 수신 관리 기능

## 📁 구조

```
report_control/
├── data/                    # Data Layer
│   ├── datasources/         # Remote data sources (Supabase RPC)
│   ├── models/              # DTOs (Freezed + json_serializable)
│   └── repositories/        # Repository implementations
├── domain/                  # Domain Layer
│   ├── entities/            # Domain entities (Freezed)
│   ├── exceptions/          # Domain exceptions
│   └── repositories/        # Repository interfaces
└── presentation/            # Presentation Layer
    ├── constants/           # UI constants (strings, icons, etc.)
    ├── pages/               # Pages
    ├── providers/           # Riverpod providers & notifiers
    ├── utils/               # UI utilities
    └── widgets/             # Reusable widgets
```

## 🎯 주요 기능

### 1. Received Reports Tab
- 사용자가 수신한 보고서 목록 조회
- 카테고리, 템플릿, 읽음/안읽음 필터링
- 날짜 범위 필터
- 보고서 상세 내용 조회 (Markdown 렌더링)

### 2. Subscribe to Reports Tab
- 구독 가능한 보고서 템플릿 목록
- 보고서 구독/구독 취소
- 구독 설정 (시간, 요일, 월 발송일 등)

## 🏗️ 아키텍처

### Clean Architecture 3-Layer
1. **Presentation** → 2. **Domain** ← 3. **Data**

### 의존성 방향
- Presentation → Domain ← Data
- Domain은 외부 의존성 없음 (순수 Dart)

### 주요 패턴
- **State Management**: Riverpod (StateNotifier)
- **Immutability**: Freezed
- **Error Handling**: BaseRepository + Custom Exceptions
- **DTO ↔ Entity**: Mapper pattern

## 📊 데이터 흐름

```
User Interaction
    ↓
Widget (ConsumerWidget)
    ↓
ref.read(reportProvider.notifier).method()
    ↓
ReportNotifier (StateNotifier<ReportState>)
    ↓
ReportRepository (interface)
    ↓
ReportRepositoryImpl
    ↓
ReportRemoteDataSource
    ↓
Supabase RPC Functions
```

## 🔑 핵심 파일

### Presentation Layer
- **report_control_page.dart**: 메인 페이지 (2개 탭)
- **report_notifier.dart**: 상태 관리 로직
- **report_state.dart**: 상태 정의 (Freezed)
- **received_reports_tab.dart**: 수신 보고서 탭
- **subscribe_reports_tab.dart**: 구독 관리 탭

### Domain Layer
- **report_notification.dart**: 수신 보고서 엔티티
- **template_with_subscription.dart**: 구독 상태 포함 템플릿 엔티티
- **report_repository.dart**: 리포지토리 인터페이스

### Data Layer
- **report_remote_datasource.dart**: Supabase RPC 호출
- **report_repository_impl.dart**: 리포지토리 구현
- **base_repository.dart**: 공통 에러 처리

## 🛠️ 주요 Supabase RPC Functions

| Function | Purpose |
|----------|---------|
| `report_get_user_received_reports` | 사용자 수신 보고서 조회 |
| `report_get_available_templates_with_status` | 구독 가능 템플릿 + 구독 상태 |
| `report_get_categories_with_stats` | 카테고리 통계 |
| `report_mark_as_read` | 보고서 읽음 표시 |
| `report_subscribe_to_template` | 템플릿 구독 |
| `report_update_subscription` | 구독 설정 업데이트 |
| `report_unsubscribe_from_template` | 구독 취소 |

## 🎨 UI/UX

### Design System
- **Theme**: Toss Design System
- **Colors**: TossColors
- **Spacing**: TossSpacing
- **Border Radius**: TossBorderRadius
- **Typography**: TossTextStyles

### 주요 위젯
- **ReportNotificationCard**: 보고서 카드 (compact)
- **TemplateSubscriptionCard**: 템플릿 카드
- **SubscriptionDialog**: 구독 설정 다이얼로그
- **TossChipGroup**: 카테고리 필터 칩

## ⚡ 성능 최적화

### 적용된 최적화
1. ✅ **CategoryUtils**: 카테고리 색상 캐싱 (중복 제거)
2. ✅ **정규식 캐싱**: `_bulletPointRegex` static final
3. ✅ **ColoredBox**: Container 대신 사용 (불필요한 레이어 제거)
4. ✅ **Key 사용**: ListView 아이템에 ValueKey
5. ✅ **const 생성자**: 가능한 모든 곳에 적용
6. ✅ **eagerError: false**: 병렬 API 호출 시 격리

### 의도적 보류 (오버엔지니어링 방지)
- 메모이제이션: 데이터 크기가 작아 불필요
- 정렬 최적화: 템플릿 수가 적음
- UTC 변환 캐싱: 사용 빈도 낮음

## 🐛 에러 처리

### 계층별 에러 처리
1. **Data Layer**: PostgrestException, FunctionException → ReportException
2. **Domain Layer**: 순수 예외 (ReportException)
3. **Presentation Layer**: try-catch + 상태 업데이트

### 에러 로깅
```dart
catch (e, stackTrace) {
  print('[ReportDataSource] ❌ Error: $e');
  print('[ReportDataSource] Stack trace: $stackTrace');
  rethrow;
}
```

## 🔐 타입 안정성

### Freezed 사용
- ✅ Immutability 보장
- ✅ copyWith 자동 생성
- ✅ == 연산자 자동 구현
- ✅ Union types (sealed class)

### 강타입화
- ✅ dynamic 사용 최소화
- ✅ 제네릭 타입 명시
- ✅ nullable 최소화

## 📝 명명 규칙

### 파일 네이밍
- `*_page.dart`: 페이지
- `*_notifier.dart`: StateNotifier
- `*_state.dart`: State 클래스
- `*_dto.dart`: Data Transfer Object
- `*_repository.dart`: Repository
- `*_datasource.dart`: Data source

### 변수 네이밍
- `_private`: private 변수
- `isLoading`: boolean
- `errorMessage`: nullable error
- `userId`, `companyId`: ID 타입

## 🧪 테스트

### 테스트 대상
- [ ] ReportNotifier: 상태 관리 로직
- [ ] ReportState: getter 로직
- [ ] ReportRepositoryImpl: DTO → Entity 변환
- [ ] CategoryUtils: 색상 매핑 로직

## 🚀 향후 개선 사항

### 성능
- [ ] 대량 데이터 처리 (가상 스크롤링)
- [ ] 이미지 캐싱 (보고서에 이미지 포함 시)
- [ ] 백그라운드 동기화

### 기능
- [ ] 오프라인 지원
- [ ] 보고서 북마크
- [ ] 보고서 공유
- [ ] 알림 설정

### 개발자 경험
- [ ] print → logger 패키지 마이그레이션
- [ ] User 모델 강타입화 (Map 제거)
- [ ] Result 타입 패턴 도입

## 📚 참고 문서

- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Riverpod Documentation](https://riverpod.dev/)
- [Freezed Documentation](https://pub.dev/packages/freezed)
- [Toss Design System](https://toss.im/tossface)

## 🤝 기여 가이드

### 코드 수정 시 확인사항
1. ✅ Clean Architecture 계층 분리 유지
2. ✅ Freezed 사용 (새 모델/엔티티)
3. ✅ 에러 로깅 추가
4. ✅ 오버엔지니어링 방지 (3번 반복 원칙)
5. ✅ 네이밍 일관성 유지

### PR 체크리스트
- [ ] `flutter analyze` 통과
- [ ] `flutter test` 통과
- [ ] `flutter build apk --debug` 성공
- [ ] 코드 리뷰 완료

---

**Last Updated**: 2025-11-20
**Maintainer**: Development Team
