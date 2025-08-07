# 프로젝트 구조

## 폴더 구조

```
lib/
├── core/                      # 핵심 공유 리소스
│   ├── themes/               # 테마 파일 (수정 주의)
│   ├── error/                # 에러 처리
│   └── utils/                # 유틸리티 함수
│
├── data/                     # 데이터 레이어
│   ├── models/              # Freezed 데이터 모델
│   ├── repositories/        # Repository 구현체
│   └── services/           # 외부 서비스 연동
│
├── domain/                   # 도메인 레이어
│   ├── entities/            # 비즈니스 엔티티
│   ├── repositories/        # Repository 인터페이스
│   └── usecases/           # 비즈니스 로직
│
├── presentation/            # 프레젠테이션 레이어
│   ├── app/                # 앱 설정 및 라우팅
│   ├── pages/              # 화면 페이지
│   ├── providers/          # 상태 관리 (Riverpod)
│   └── widgets/            # 재사용 위젯
│       ├── common/         # 공통 위젯
│       ├── toss/          # Toss 디자인 위젯
│       └── specific/      # 특정 기능 위젯
│
└── main.dart               # 앱 진입점
```

## 주요 파일 위치

### 상태 관리
- `/lib/presentation/providers/app_state_provider.dart` - 앱 전역 상태
- `/lib/presentation/providers/auth_provider.dart` - 인증 상태
- `/lib/presentation/providers/supabase_provider.dart` - Supabase 클라이언트

### 테마
- `/lib/core/themes/app_theme.dart` - 메인 테마 설정
- `/lib/core/themes/toss_colors.dart` - 색상 정의
- `/lib/core/themes/toss_text_styles.dart` - 텍스트 스타일
- `/lib/core/themes/toss_spacing.dart` - 간격 정의

### 라우팅
- `/lib/presentation/app/app_router.dart` - 라우터 설정
- `/lib/presentation/app/app_routes.dart` - 라우트 정의

## 페이지 구조

### 인증
- `/lib/presentation/pages/auth/login_page.dart`
- `/lib/presentation/pages/auth/signup_page.dart`
- `/lib/presentation/pages/auth/forgot_password_page.dart`

### 메인 기능
- `/lib/presentation/pages/homepage/` - 홈페이지
- `/lib/presentation/pages/employee_settings/` - 직원 설정
- `/lib/presentation/pages/rolepermissionpage/` - 역할 권한
- `/lib/presentation/pages/delegaterolepage/` - 역할 위임

## 명명 규칙

### 파일명
- snake_case: `employee_card.dart`
- 페이지: `_page` 접미사
- 위젯: 기능 설명적 이름

### 클래스명
- PascalCase: `EmployeeCard`
- Provider: `Provider` 접미사
- Repository: `Repository` 접미사

### 변수명
- camelCase: `employeeList`
- Private: `_` 접두사
- 상수: `UPPER_SNAKE_CASE`