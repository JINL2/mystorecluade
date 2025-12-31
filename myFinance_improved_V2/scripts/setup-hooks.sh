#!/bin/bash
# ===========================================
# Git Hooks 설정 스크립트
# ===========================================
# 사용법: ./scripts/setup-hooks.sh
#
# 이 스크립트는 pre-push hook을 활성화합니다.
# hook이 활성화되면 push 전에 자동으로 코드 검사가 실행됩니다.
# ===========================================

echo "🔧 Git Hooks 설정 중..."

# 프로젝트 루트로 이동
cd "$(dirname "$0")/.." || exit 1

# Git hooks 경로 설정
git config core.hooksPath .githooks

# 실행 권한 부여
chmod +x .githooks/*

echo ""
echo "✅ Git Hooks 설정 완료!"
echo ""
echo "이제 git push 할 때 자동으로 다음 검사가 실행됩니다:"
echo "  1. Flutter Analyze (에러 검사)"
echo "  2. DCM 미사용 코드 검사"
echo "  3. DCM 미사용 파일 검사"
echo ""
echo "검사 실패시 push가 차단됩니다."
echo ""
