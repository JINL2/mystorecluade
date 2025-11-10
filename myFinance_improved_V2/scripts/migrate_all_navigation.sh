#!/bin/bash

# Complete Navigation Migration Script
# 전체 프로젝트의 Navigator.pop()을 context.pop()으로 변경

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🧭 Complete Navigation Migration${NC}"
echo ""
echo -e "${YELLOW}⚠️  이 스크립트는 전체 프로젝트를 수정합니다!${NC}"
echo -e "${RED}⚠️  실행 전에 반드시 git commit 하세요!${NC}"
echo ""

# Check git status
if ! git diff-index --quiet HEAD --; then
    echo -e "${RED}❌ Uncommitted changes detected!${NC}"
    echo "Please commit or stash your changes first:"
    echo "  git add ."
    echo "  git commit -m \"save: before navigation migration\""
    exit 1
fi

echo -e "${GREEN}✅ Git status clean${NC}"
echo ""

# Statistics
total_files=$(find lib/features -name "*.dart" | wc -l)
files_with_nav=$(grep -r "Navigator\.of(context)\.pop()" lib/features --include="*.dart" -l | wc -l)
total_occurrences=$(grep -r "Navigator\.of(context)\.pop()" lib/features --include="*.dart" | wc -l)

echo "📊 통계:"
echo "   총 파일: $total_files"
echo "   수정 대상 파일: $files_with_nav"
echo "   수정 대상 코드: $total_occurrences"
echo ""

read -p "계속하시겠습니까? (y/n): " confirm
if [ "$confirm" != "y" ]; then
    echo "취소되었습니다."
    exit 0
fi

echo ""
echo -e "${GREEN}🚀 시작합니다...${NC}"
echo ""

# Backup
BACKUP_DIR="backup_navigation_complete_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
echo -e "${BLUE}📦 백업 생성: $BACKUP_DIR${NC}"

# Find and replace
count=0
find lib/features -name "*.dart" -type f | while read file; do
    if grep -q "Navigator\.of(context)\.pop()" "$file"; then
        # Backup
        mkdir -p "$BACKUP_DIR/$(dirname $file)"
        cp "$file" "$BACKUP_DIR/$file"
        
        # Replace
        sed -i '' 's/Navigator\.of(context)\.pop()/context.pop()/g' "$file"
        
        count=$((count + 1))
        echo -e "${GREEN}✅ $(basename $file)${NC}"
    fi
done

echo ""
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ 완료!${NC}"
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo ""
echo "📊 수정 완료"
echo "   백업: $BACKUP_DIR"
echo ""
echo "다음 단계:"
echo "1. ${YELLOW}git diff${NC} - 변경사항 확인"
echo "2. ${YELLOW}dart analyze${NC} - 문법 오류 확인"
echo "3. ${YELLOW}flutter run${NC} - 실행 테스트"
echo "4. ${YELLOW}git add . && git commit -m 'refactor: migrate all Navigator.pop() to context.pop()'${NC}"
echo ""
echo -e "${YELLOW}문제가 있으면:${NC}"
echo "  git reset --hard HEAD"
echo "  또는 백업에서 복원: cp -r $BACKUP_DIR/* ."
echo ""

