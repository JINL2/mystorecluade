# GitHub 협업 및 인증 가이드

## 🔐 토큰 관리 방식

### 중요: 토큰은 절대 코드에 포함되지 않습니다
- GitHub Personal Access Token은 개인 비밀번호와 같습니다
- 각 개발자는 자신만의 토큰을 발급받아야 합니다
- 토큰은 `.git-credentials` 또는 환경변수로 관리합니다

## 📥 프로젝트 클론 및 설정 (새 개발자용)

### 1단계: 프로젝트 클론
```bash
# HTTPS로 클론 (토큰 필요)
git clone https://github.com/JINL2/mystorecluade.git

# 또는 SSH로 클론 (SSH 키 설정 필요)
git clone git@github.com:JINL2/mystorecluade.git
```

### 2단계: 자신의 GitHub Personal Access Token 발급
1. GitHub.com 로그인
2. Settings → Developer settings → Personal access tokens → Tokens (classic)
3. "Generate new token" 클릭
4. 권한 선택:
   - `repo` (전체 선택)
   - `workflow` (선택)
5. "Generate token" 클릭
6. **토큰을 안전한 곳에 복사 저장** (다시 볼 수 없음!)

### 3단계: 토큰 설정 방법 (택 1)

#### 방법 A: Git Credential Manager 사용 (추천)
```bash
# macOS
brew install git-credential-manager

# Windows (Git for Windows에 포함됨)
# 별도 설치 불필요

# 설정
git config --global credential.helper manager
```
첫 push/pull 시 자동으로 토큰 입력 창이 나타남

#### 방법 B: 환경 변수 사용
```bash
# ~/.bashrc 또는 ~/.zshrc에 추가
export GITHUB_TOKEN="ghp_여기에_당신의_토큰_입력"

# Git 설정
git remote set-url origin https://${GITHUB_TOKEN}@github.com/JINL2/mystorecluade.git
```

#### 방법 C: .git-credentials 파일 사용
```bash
# 1. 파일 생성
touch ~/.git-credentials

# 2. 파일에 추가 (에디터로 열어서)
https://YOUR_USERNAME:YOUR_TOKEN@github.com

# 3. Git 설정
git config --global credential.helper store
```

#### 방법 D: 매번 입력
```bash
# 토큰을 저장하지 않고 매번 입력
git push origin main
# Username: YOUR_GITHUB_USERNAME
# Password: YOUR_PERSONAL_ACCESS_TOKEN
```

## 📤 Push/Pull 작업

### Pull (코드 받기)
```bash
# 최신 코드 받기
git pull origin main

# 충돌 발생 시
git stash        # 현재 작업 임시 저장
git pull origin main
git stash pop    # 임시 저장한 작업 복원
```

### Push (코드 올리기)
```bash
# 1. 변경사항 확인
git status

# 2. 스테이징
git add .

# 3. 커밋
git commit -m "feat: 새 기능 추가"

# 4. 푸시
git push origin main
# 토큰 설정이 안 되어 있다면 Username과 Password(토큰) 입력
```

## 🔄 토큰 없이 작업하는 방법

### SSH 키 사용 (토큰 불필요)
```bash
# 1. SSH 키 생성
ssh-keygen -t ed25519 -C "your_email@example.com"

# 2. SSH 키 복사
cat ~/.ssh/id_ed25519.pub

# 3. GitHub에 SSH 키 등록
# GitHub → Settings → SSH and GPG keys → New SSH key

# 4. 원격 URL을 SSH로 변경
git remote set-url origin git@github.com:JINL2/mystorecluade.git
```

## ⚠️ 보안 주의사항

### 절대 하지 말아야 할 것
- ❌ 토큰을 코드에 직접 작성
- ❌ 토큰을 공개 저장소에 커밋
- ❌ 다른 사람과 토큰 공유
- ❌ 스크린샷에 토큰 노출

### 토큰이 노출되었을 때
1. GitHub에서 즉시 토큰 revoke
2. 새 토큰 발급
3. 모든 로컬 설정 업데이트

## 🤝 팀 협업 시나리오

### 시나리오 1: 새 팀원이 합류
```bash
# 1. 프로젝트 클론
git clone https://github.com/JINL2/mystorecluade.git

# 2. 자신의 토큰 발급 (GitHub에서)

# 3. 토큰 설정 (위 방법 중 선택)

# 4. 작업 시작
git checkout -b feature/my-feature
```

### 시나리오 2: 다른 컴퓨터에서 작업
```bash
# 1. 프로젝트 클론
git clone https://github.com/JINL2/mystorecluade.git

# 2. 기존 토큰 사용 또는 새 토큰 발급

# 3. 해당 컴퓨터에 토큰 설정
```

## 📁 프로젝트 구조와 토큰

```
myFinance_improved/
├── .git/                  # Git 메타데이터 (자동 생성)
├── .gitignore            # 무시할 파일 목록 (토큰 파일 포함)
├── .git-credentials      # 🔒 로컬에만 존재 (절대 커밋 안됨)
├── README.md             # 프로젝트 문서
└── lib/                  # 소스 코드
```

### .gitignore에 포함된 보안 파일
```
.git-credentials
.env
*.token
.env.local
```

## 💡 FAQ

**Q: 왜 토큰을 코드에 포함하면 안 되나요?**
A: GitHub이 자동으로 감지하고 푸시를 차단합니다. 또한 누구나 토큰을 사용해 당신의 권한으로 작업할 수 있게 됩니다.

**Q: 토큰 없이도 코드를 받을 수 있나요?**
A: Public 저장소는 clone과 pull은 가능하지만, push는 인증이 필요합니다.

**Q: 토큰 유효기간은?**
A: 설정에 따라 다르며, 7일, 30일, 60일, 90일, 무제한 중 선택 가능합니다.

**Q: SSH와 HTTPS 중 뭐가 좋나요?**
A: SSH는 초기 설정이 복잡하지만 이후 편리합니다. HTTPS는 설정이 간단하지만 토큰 관리가 필요합니다.

## 📞 문제 해결

### "Authentication failed" 에러
```bash
# 토큰 재설정
git remote set-url origin https://YOUR_TOKEN@github.com/JINL2/mystorecluade.git
```

### "Permission denied" 에러
- 토큰 권한 확인 (repo 권한 필요)
- 토큰 만료 여부 확인

### 토큰 입력창이 안 나올 때
```bash
# Credential helper 재설정
git config --global --unset credential.helper
git config --global credential.helper manager
```

---

**📌 핵심 요약**: 각 개발자는 자신의 GitHub 토큰을 발급받아 로컬에 설정해야 합니다. 토큰은 절대 코드에 포함되지 않습니다.