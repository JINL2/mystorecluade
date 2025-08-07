# GitHub 작업 가이드

## Repository 정보
- **URL**: https://github.com/JINL2/mystorecluade
- **Access Token**: [환경 변수에 저장됨]

## 초기 설정 (1회만)

```bash
# Git 사용자 정보 설정
git config --global user.name "JINL2"
git config --global user.email "your-email@example.com"

# 원격 저장소 설정
git remote add origin https://github.com/JINL2/mystorecluade.git

# 토큰 인증 설정 (토큰은 별도 보안 파일에서 관리)
# git remote set-url origin https://[TOKEN]@github.com/JINL2/mystorecluade.git
```

## 일일 작업 플로우

### 1. 작업 시작
```bash
git pull origin main
git checkout -b feature/기능이름
```

### 2. 작업 후 커밋
```bash
git add .
git commit -m "feat: 새 기능 추가"
git push origin feature/기능이름
```

### 3. Pull Request 생성
1. GitHub 웹사이트 접속
2. "Compare & pull request" 클릭
3. PR 내용 작성
4. "Create pull request" 클릭

### 4. 머지 후 정리
```bash
git checkout main
git pull origin main
git branch -d feature/기능이름
```

## 커밋 메시지 규칙

- `feat:` 새로운 기능 추가
- `fix:` 버그 수정
- `docs:` 문서 수정
- `style:` 코드 포맷팅
- `refactor:` 코드 리팩토링
- `test:` 테스트 추가
- `chore:` 빌드/패키지 수정

### 예시
```bash
git commit -m "feat: 직원 급여 관리 기능 추가"
git commit -m "fix: 로그인 시 null 에러 수정"
git commit -m "docs: README 업데이트"
```

## 충돌 해결

```bash
# 1. 최신 코드 가져오기
git pull origin main

# 2. 충돌 파일 수정
# VS Code에서 충돌 마커 확인 및 수정

# 3. 해결 후 커밋
git add .
git commit -m "fix: merge conflict 해결"
git push origin feature/브랜치명
```

## 긴급 수정 (Hotfix)

```bash
git checkout main
git pull origin main
git checkout -b hotfix/긴급수정

# 수정 작업...

git add .
git commit -m "hotfix: 긴급 버그 수정"
git push origin hotfix/긴급수정
```

## 브랜치 명명 규칙

- `feature/` - 새 기능
- `fix/` - 버그 수정
- `hotfix/` - 긴급 수정
- `docs/` - 문서 작업
- `refactor/` - 리팩토링

## 인증 관리

Git 토큰은 보안상 별도 파일이나 환경 변수로 관리해야 합니다:
1. `.env` 파일에 저장 (gitignore에 추가)
2. 또는 macOS Keychain / Windows Credential Manager 사용