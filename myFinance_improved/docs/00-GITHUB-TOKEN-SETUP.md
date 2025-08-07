# GitHub Token 설정 가이드 (팀원용)

## 🚀 빠른 시작 (3분 설정)

### 1. GitHub Token 발급
1. [GitHub.com](https://github.com) 로그인
2. 우측 상단 프로필 → Settings
3. 좌측 메뉴 최하단 → Developer settings
4. Personal access tokens → Tokens (classic)
5. Generate new token (classic)
6. 설정:
   - Note: `myfinance-dev`
   - Expiration: `90 days` (또는 원하는 기간)
   - Scopes: ✅ `repo` (전체 체크)
7. Generate token 클릭
8. **⚠️ 토큰 복사** (다시 볼 수 없음!)

### 2. 프로젝트 클론 및 토큰 설정

#### 옵션 A: 간단한 방법 (추천)
```bash
# 1. 프로젝트 클론
git clone https://github.com/JINL2/mystorecluade.git
cd mystorecluade

# 2. 토큰을 포함한 URL로 설정
git remote set-url origin https://YOUR_GITHUB_USERNAME:YOUR_TOKEN@github.com/JINL2/mystorecluade.git

# 예시 (실제 토큰으로 교체)
# git remote set-url origin https://johndoe:ghp_abcd1234efgh5678@github.com/JINL2/mystorecluade.git
```

#### 옵션 B: 보안 강화 방법
```bash
# 1. 환경변수 설정 (.zshrc 또는 .bashrc에 추가)
echo 'export GITHUB_TOKEN="ghp_여기에_토큰_입력"' >> ~/.zshrc
source ~/.zshrc

# 2. Git 설정
git remote set-url origin https://${GITHUB_TOKEN}@github.com/JINL2/mystorecluade.git
```

### 3. 테스트
```bash
# Pull 테스트
git pull origin main

# 작은 변경 후 Push 테스트
echo "# Test" >> test.md
git add test.md
git commit -m "test: token setup"
git push origin main
```

## ❓ 자주 묻는 질문

### "왜 내 토큰이 필요한가요?"
- 보안: 각자의 토큰으로 누가 어떤 작업을 했는지 추적 가능
- GitHub 정책: 토큰을 코드에 포함하면 자동 차단

### "토큰이 만료되면?"
1. GitHub에서 새 토큰 발급
2. `git remote set-url` 명령으로 업데이트

### "토큰을 잊어버렸어요"
- GitHub에서 새로 발급 (기존 토큰 revoke 후)

### "Permission denied 에러가 나요"
- 토큰에 `repo` 권한이 있는지 확인
- 토큰이 만료되지 않았는지 확인

## 🔒 보안 수칙

### DO ✅
- 토큰을 비밀번호처럼 관리
- 정기적으로 토큰 갱신
- 작업 완료 후 불필요한 토큰 삭제

### DON'T ❌
- 토큰을 다른 사람과 공유
- 토큰을 코드에 직접 작성
- 토큰을 메신저/이메일로 전송

## 📱 다른 컴퓨터에서 작업하기

같은 토큰을 여러 컴퓨터에서 사용 가능:
1. 기존 토큰 사용 또는 새 토큰 발급
2. 해당 컴퓨터에서 동일한 설정 과정 진행

---

**도움이 필요하면 팀 리더에게 문의하세요!**