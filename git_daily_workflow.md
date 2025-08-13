# 아침 - 작업 시작
git checkout main
git pull origin main
git checkout -b feature/오늘작업

# 저녁 - PR 생성 전
git checkout main
git pull origin main
git checkout feature/오늘작업
git merge main  # 또는 rebase
# 충돌 해결
git push origin feature/오늘작업
# → GitHub에서 PR 생성 및 병합
