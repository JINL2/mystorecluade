# 버전 관리 가이드

## 📊 버전 관리 전략

### 1. 버전 체계 (Semantic Versioning)
```
v주.부.패치
v1.2.3

주(Major): 큰 변경, 호환성 깨짐
부(Minor): 새 기능 추가
패치(Patch): 버그 수정
```

### 예시
- `v1.0.0` - 첫 정식 릴리즈
- `v1.1.0` - 새 기능 추가 (직원 관리)
- `v1.1.1` - 버그 수정
- `v2.0.0` - 대규모 리팩토링

## 🌳 브랜치 전략 (Git Flow)

### 주요 브랜치
```
main (production)
  ↑
develop (개발)
  ↑
feature/* (기능 개발)
hotfix/* (긴급 수정)
release/* (릴리즈 준비)
```

### 브랜치 규칙

#### 1. Main 브랜치
- **용도**: 프로덕션 배포 코드
- **규칙**: 직접 푸시 금지, 태그 사용
- **병합**: PR + 2명 이상 리뷰

#### 2. Develop 브랜치
- **용도**: 개발 통합 브랜치
- **규칙**: feature 브랜치에서만 병합
- **테스트**: 모든 테스트 통과 필수

#### 3. Feature 브랜치
- **명명**: `feature/기능명`
- **예시**: `feature/employee-salary`
- **수명**: 기능 완료 후 삭제

#### 4. Hotfix 브랜치
- **명명**: `hotfix/이슈명`
- **예시**: `hotfix/login-error`
- **용도**: 긴급 버그 수정

## 📝 버전 태그 관리

### 태그 생성
```bash
# 1. 버전 태그 생성
git tag -a v1.0.0 -m "First stable release"

# 2. 태그 푸시
git push origin v1.0.0

# 3. 모든 태그 푸시
git push origin --tags
```

### 태그 조회
```bash
# 모든 태그 보기
git tag

# 특정 패턴 태그 보기
git tag -l "v1.0.*"

# 태그 상세 정보
git show v1.0.0
```

## 🚀 릴리즈 프로세스

### 1. 새 버전 준비
```bash
# develop에서 release 브랜치 생성
git checkout develop
git checkout -b release/v1.1.0
```

### 2. 버전 업데이트
```dart
// pubspec.yaml 수정
version: 1.1.0+11  # 버전+빌드번호
```

### 3. 변경사항 문서화
```markdown
# CHANGELOG.md 업데이트
## [1.1.0] - 2024-01-15
### Added
- 직원 급여 관리 기능
- 역할별 권한 설정

### Fixed
- 로그인 에러 수정
```

### 4. 테스트 및 병합
```bash
# main으로 병합
git checkout main
git merge --no-ff release/v1.1.0
git tag -a v1.1.0 -m "Release version 1.1.0"

# develop으로도 병합
git checkout develop
git merge --no-ff release/v1.1.0
```

### 5. 푸시 및 배포
```bash
git push origin main
git push origin develop
git push origin v1.1.0
```

## 📋 CHANGELOG 작성 규칙

### CHANGELOG.md 구조
```markdown
# Changelog

## [Unreleased]
### Added
- 개발 중인 새 기능

## [1.1.0] - 2024-01-15
### Added
- 새로운 기능 설명

### Changed
- 변경된 기능 설명

### Deprecated
- 곧 제거될 기능

### Removed
- 제거된 기능

### Fixed
- 수정된 버그

### Security
- 보안 이슈 수정
```

## 🔍 버전 확인 방법

### 앱에서 버전 확인
```dart
// lib/core/constants/app_constants.dart
class AppConstants {
  static const String appVersion = '1.1.0';
  static const int buildNumber = 11;
}
```

### Git에서 현재 버전 확인
```bash
# 최신 태그 확인
git describe --tags --abbrev=0

# 현재 커밋의 버전 정보
git describe --tags
```

## 📱 Flutter 버전 관리

### pubspec.yaml
```yaml
name: myfinance_improved
version: 1.1.0+11  # 버전+빌드번호

environment:
  sdk: ">=3.0.0 <4.0.0"
  flutter: ">=3.16.0"
```

### 빌드 번호 규칙
- iOS: 1, 2, 3... (순차 증가)
- Android: 1, 2, 3... (순차 증가)
- 규칙: 버전 변경 시 리셋 가능

## 🏷️ 버전별 브랜치 관리

### 장기 지원 버전 (LTS)
```bash
# LTS 브랜치 생성
git checkout -b support/v1.x main

# 패치 적용
git checkout support/v1.x
git cherry-pick <commit-hash>
```

### 이전 버전 유지보수
```bash
# v1.0.x 패치
git checkout -b hotfix/v1.0.1 v1.0.0
# 수정 작업...
git tag v1.0.1
```

## 📊 버전 히스토리 예시

```
v2.0.0 (2024-02-01) - 메이저 업데이트
├─ 전체 UI 리뉴얼
├─ 새로운 데이터베이스 구조
└─ 성능 최적화

v1.2.0 (2024-01-20) - 기능 추가
├─ 보고서 생성 기능
└─ 데이터 내보내기

v1.1.2 (2024-01-18) - 버그 수정
├─ 로그인 오류 수정
└─ 메모리 누수 해결

v1.1.0 (2024-01-15) - 기능 추가
├─ 직원 관리
└─ 역할 권한

v1.0.0 (2024-01-01) - 첫 릴리즈
└─ 기본 기능 구현
```

## ⚙️ 자동화 도구

### 버전 자동 증가 스크립트
```bash
#!/bin/bash
# scripts/bump_version.sh

TYPE=$1  # major, minor, patch

# 현재 버전 가져오기
CURRENT=$(grep "version:" pubspec.yaml | sed 's/version: //')

# 버전 증가 로직...
# pubspec.yaml 업데이트
# CHANGELOG.md 업데이트
# Git 태그 생성
```

### GitHub Actions 자동 릴리즈
```yaml
# .github/workflows/release.yml
name: Release

on:
  push:
    tags:
      - 'v*'

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Create Release
        uses: actions/create-release@v1
```

## 🎯 베스트 프랙티스

### DO ✅
- 모든 릴리즈에 태그 사용
- CHANGELOG 항상 업데이트
- 버전 규칙 일관성 유지
- 릴리즈 전 테스트 필수

### DON'T ❌
- main에 직접 푸시
- 태그 없이 배포
- 버전 번호 건너뛰기
- CHANGELOG 누락

## 📚 참고 자료

- [Semantic Versioning](https://semver.org/)
- [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/)
- [Keep a Changelog](https://keepachangelog.com/)
- [Conventional Commits](https://www.conventionalcommits.org/)