# MyFinance App - AI 개발 가이드

> **AI 에이전트를 위한 프로젝트 인덱싱 문서**  
> 필요한 정보만 선택적으로 참조하세요.

## 🚀 빠른 시작

### 🔑 첫 번째 단계: GitHub 인증 설정
**[→ GitHub Token 설정 가이드](./docs/00-GITHUB-TOKEN-SETUP.md)** (필수, 3분 소요)

프로젝트 정보:

```yaml
프로젝트: MyFinance (Flutter)
상태관리: Riverpod
데이터베이스: Supabase
디자인시스템: Toss Design System
GitHub: https://github.com/JINL2/mystorecluade
인증: 각 개발자가 자신의 GitHub Token 사용 (문서 참조)
```

## 📍 필수 확인 사항

### ⚠️ 절대 규칙
**[→ 상세 규칙 보기](./docs/01-CRITICAL-RULES.md)**
- AppState 기존 필드 수정 금지 (추가만 가능)
- Theme 파일 직접 수정 금지
- 직접 색상 코드 사용 금지

## 🗂️ 개발 가이드 인덱스

### 1. 상태 관리가 필요할 때
**[→ AppState 가이드](./docs/02-APP-STATE.md)**
- AppState 구조 확인
- 새 필드 추가 방법
- Provider 사용법

### 2. UI 컴포넌트를 만들 때
**[→ 위젯 컴포넌트 가이드](./docs/03-WIDGET-COMPONENTS.md)**
- 위젯 분류 체계 (common/toss/specific)
- 컴포넌트 생성 규칙
- 재사용 패턴

### 3. 스타일링이 필요할 때
**[→ Theme 시스템 가이드](./docs/04-THEME-SYSTEM.md)**
- TossColors 색상 팔레트
- TossTextStyles 텍스트 스타일
- TossSpacing 간격 시스템

### 4. 데이터베이스 작업할 때
**[→ 데이터베이스 구조](./docs/05-DATABASE-STRUCTURE.md)**
- 테이블 구조
- RPC 함수 목록
- RLS 정책

### 5. Git 작업할 때
**[→ Git 워크플로우](./docs/06-GIT-WORKFLOW.md)**
- 브랜치 전략
- 커밋 규칙
- PR 프로세스

### 6. 프로젝트 구조를 파악할 때
**[→ 프로젝트 구조](./docs/07-PROJECT-STRUCTURE.md)**
- 폴더 구조
- 파일 위치
- 명명 규칙

### 7. 버전 관리가 필요할 때
**[→ 버전 관리 가이드](./docs/08-VERSION-CONTROL.md)**
- Semantic Versioning
- 브랜치 전략
- 릴리즈 프로세스
- CHANGELOG 관리

## ⚡ 빠른 명령어

```bash
# 의존성 설치
flutter pub get

# 코드 생성 (Freezed)
flutter pub run build_runner build --delete-conflicting-outputs

# 앱 실행
flutter run

# 분석
flutter analyze
```

## 🔍 주요 파일 위치

| 목적 | 파일 경로 |
|------|----------|
| **AppState** | `/lib/presentation/providers/app_state_provider.dart` |
| **Theme** | `/lib/core/themes/` |
| **Supabase** | `/lib/presentation/providers/supabase_provider.dart` |
| **Router** | `/lib/presentation/app/app_router.dart` |
| **위젯** | `/lib/presentation/widgets/` |

## 🎯 개발 시나리오별 가이드

### "새 페이지를 만들어야 해"
1. [프로젝트 구조](./docs/07-PROJECT-STRUCTURE.md) 확인
2. [Theme 시스템](./docs/04-THEME-SYSTEM.md) 적용
3. [위젯 컴포넌트](./docs/03-WIDGET-COMPONENTS.md) 활용

### "상태 관리를 추가해야 해"
1. [AppState 가이드](./docs/02-APP-STATE.md) 확인
2. 새 필드 추가 (기존 필드 수정 금지!)
3. Provider 생성

### "API 연동이 필요해"
1. [데이터베이스 구조](./docs/05-DATABASE-STRUCTURE.md) 확인
2. Repository 패턴 사용
3. RPC 함수 호출

### "커밋을 해야 해"
1. [Git 워크플로우](./docs/06-GIT-WORKFLOW.md) 확인
2. feature 브랜치 생성
3. 커밋 메시지 규칙 준수

## 📋 AI 체크리스트

### 시작 전
- [ ] [필수 규칙](./docs/01-CRITICAL-RULES.md) 읽기
- [ ] 필요한 문서만 선택적으로 읽기

### 개발 중
- [ ] TossColors 사용 (직접 색상 X)
- [ ] TossSpacing 사용 (직접 숫자 X)
- [ ] AppState 기존 필드 수정 안함
- [ ] Repository 패턴 준수

### 완료 전
- [ ] `flutter analyze` 에러 없음
- [ ] 불필요한 import 제거
- [ ] 커밋 메시지 규칙 준수

---

**💡 Tip**: 모든 정보를 읽을 필요 없습니다. 필요한 섹션만 링크를 통해 참조하세요.

**📌 Version**: 3.0  
**📅 Updated**: 2024-01-15