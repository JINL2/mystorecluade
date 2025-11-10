#!/bin/bash

# Navigation Migration Script - Phase 1: Emergency Fixes
# 긴급 수정: GoRouter 페이지의 Navigator.pop() 제거

set -e  # Exit on error

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🧭 Navigation Migration - Phase 1${NC}"
echo ""
echo "이 스크립트는 다음 파일을 수정합니다:"
echo "1. signup_page.dart"
echo "2. choose_role_page.dart"
echo "3. create_store_page.dart"
echo "4. journal_input_page.dart"
echo ""
echo -e "${RED}⚠️  주의: 실행 전에 git commit 하세요!${NC}"
echo ""

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}❌ Error: pubspec.yaml not found!${NC}"
    echo "프로젝트 루트 디렉토리에서 실행하세요."
    exit 1
fi

# Confirm
read -p "계속하시겠습니까? (y/n): " confirm
if [ "$confirm" != "y" ]; then
    echo "취소되었습니다."
    exit 0
fi

echo ""
echo -e "${GREEN}🚀 시작합니다...${NC}"
echo ""

# Backup
BACKUP_DIR="backup_navigation_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Function to backup and modify file
backup_and_modify() {
    local file=$1
    local search=$2
    local replace=$3
    local description=$4

    if [ ! -f "$file" ]; then
        echo -e "${RED}⚠️  파일을 찾을 수 없습니다: $file${NC}"
        return 1
    fi

    echo -e "${YELLOW}📝 처리 중: $(basename $file)${NC}"

    # Backup
    cp "$file" "$BACKUP_DIR/$(basename $file)"

    # Modify
    if grep -q "$search" "$file"; then
        sed -i '' "s|$search|$replace|g" "$file"
        echo -e "${GREEN}✅ 수정 완료: $description${NC}"
        return 0
    else
        echo -e "${YELLOW}ℹ️  변경 불필요: 패턴을 찾을 수 없습니다${NC}"
        return 0
    fi
}

# 1. signup_page.dart
echo -e "\n${YELLOW}=== 1/4: signup_page.dart ===${NC}"
backup_and_modify \
    "lib/features/auth/presentation/pages/signup_page.dart" \
    "Navigator\.of(context)\.pop();" \
    "context.go('/auth/login');" \
    "Navigator.pop() → context.go('/auth/login')"

# 2. choose_role_page.dart
echo -e "\n${YELLOW}=== 2/4: choose_role_page.dart ===${NC}"
backup_and_modify \
    "lib/features/auth/presentation/pages/choose_role_page.dart" \
    "Navigator\.of(context)\.pop()" \
    "context.pop()" \
    "Navigator.pop() → context.pop()"

# 3. create_store_page.dart
echo -e "\n${YELLOW}=== 3/4: create_store_page.dart ===${NC}"
backup_and_modify \
    "lib/features/auth/presentation/pages/create_store_page.dart" \
    "Navigator\.of(context)\.pop()" \
    "context.pop()" \
    "Navigator.pop() → context.pop()"

# 4. journal_input_page.dart - 확인만 (수동 수정 필요)
echo -e "\n${YELLOW}=== 4/4: journal_input_page.dart ===${NC}"
JOURNAL_FILE="lib/features/journal_input/presentation/pages/journal_input_page.dart"
if [ -f "$JOURNAL_FILE" ]; then
    if grep -q "Navigator\.of(context)\.pop()" "$JOURNAL_FILE"; then
        echo -e "${YELLOW}⚠️  이 파일은 수동 확인이 필요합니다:${NC}"
        echo "   $JOURNAL_FILE"
        echo ""
        echo "   Navigator.pop() 사용 위치:"
        grep -n "Navigator\.of(context)\.pop()" "$JOURNAL_FILE" | head -5
        echo ""
        echo -e "${YELLOW}   → 각 사용처를 확인하고 적절히 수정하세요${NC}"
    else
        echo -e "${GREEN}✅ 문제없음: Navigator.pop() 사용하지 않음${NC}"
    fi
else
    echo -e "${RED}⚠️  파일을 찾을 수 없습니다${NC}"
fi

# Summary
echo ""
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Phase 1 완료!${NC}"
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo ""
echo "백업 위치: $BACKUP_DIR"
echo ""
echo "다음 단계:"
echo "1. git diff로 변경사항 확인"
echo "2. flutter analyze 실행"
echo "3. 앱 실행 및 테스트"
echo "   - 로그인 → 회원가입 → 로그인 플로우 테스트"
echo "   - 거래 입력 페이지 테스트"
echo "4. 문제없으면 git commit"
echo ""
echo "문제가 있으면:"
echo "  cp $BACKUP_DIR/* lib/features/auth/presentation/pages/"
echo ""
