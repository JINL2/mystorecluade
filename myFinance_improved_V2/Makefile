# ============================================
# DCM (Dart Code Metrics) 명령어
# ============================================
# 사용법: make [명령어]
# 예시: make unused-files
# ============================================

.PHONY: unused-files unused-code check-all dcm-install help

# DCM 설치 (처음 한 번만)
dcm-install:
	@echo "DCM 설치 중..."
	dart pub global activate dart_code_metrics
	@echo "설치 완료!"

# 안 쓰는 파일 찾기
unused-files:
	@echo "🔍 안 쓰는 파일 검사 중..."
	@~/.pub-cache/bin/metrics check-unused-files lib --disable-sunset-warning

# 안 쓰는 코드 찾기
unused-code:
	@echo "🔍 안 쓰는 코드 검사 중..."
	@~/.pub-cache/bin/metrics check-unused-code lib --disable-sunset-warning

# 둘 다 실행
check-all:
	@echo "=========================================="
	@echo "📁 안 쓰는 파일 검사"
	@echo "=========================================="
	@~/.pub-cache/bin/metrics check-unused-files lib --disable-sunset-warning
	@echo ""
	@echo "=========================================="
	@echo "📝 안 쓰는 코드 검사"
	@echo "=========================================="
	@~/.pub-cache/bin/metrics check-unused-code lib --disable-sunset-warning

# 결과를 파일로 저장
save-report:
	@echo "리포트 저장 중..."
	@~/.pub-cache/bin/metrics check-unused-files lib --disable-sunset-warning > docs/unused_files_latest.txt 2>&1
	@~/.pub-cache/bin/metrics check-unused-code lib --disable-sunset-warning > docs/unused_code_latest.txt 2>&1
	@echo "저장 완료! docs/ 폴더 확인하세요."

# 도움말
help:
	@echo "============================================"
	@echo "  DCM 명령어 도움말"
	@echo "============================================"
	@echo ""
	@echo "  make dcm-install   : DCM 설치 (처음 한 번만)"
	@echo "  make unused-files  : 안 쓰는 파일 찾기"
	@echo "  make unused-code   : 안 쓰는 코드 찾기"
	@echo "  make check-all     : 둘 다 실행"
	@echo "  make save-report   : 결과를 파일로 저장"
	@echo "  make help          : 이 도움말 보기"
	@echo ""
	@echo "============================================"

# ============================================
# 기타 유용한 명령어
# ============================================

# Flutter 관련
run:
	flutter run

build:
	flutter build apk --release

clean:
	flutter clean && flutter pub get

codegen:
	dart run build_runner build --delete-conflicting-outputs

# ============================================
# Design System 채택률 검사
# ============================================

# 위젯 채택률 리포트
widget-report:
	@echo "📊 Widget Adoption Report"
	@echo "========================="
	@echo ""
	@TF_TOSS=$$(grep -r "TossTextField" lib/features --include="*.dart" 2>/dev/null | wc -l | tr -d ' '); \
	TF_DIRECT=$$(grep -r "TextField(" lib/features --include="*.dart" 2>/dev/null | wc -l | tr -d ' '); \
	TF_TOTAL=$$((TF_TOSS + TF_DIRECT)); \
	if [ $$TF_TOTAL -gt 0 ]; then TF_RATE=$$((TF_TOSS * 100 / TF_TOTAL)); else TF_RATE=0; fi; \
	echo "TextField:  $$TF_TOSS Toss / $$TF_DIRECT Direct = $$TF_RATE%"
	@BTN_TOSS=$$(grep -rE "TossButton|TossPrimaryButton|TossSecondaryButton" lib/features --include="*.dart" 2>/dev/null | wc -l | tr -d ' '); \
	BTN_DIRECT=$$(grep -rE "ElevatedButton|TextButton\(|OutlinedButton" lib/features --include="*.dart" 2>/dev/null | wc -l | tr -d ' '); \
	BTN_TOTAL=$$((BTN_TOSS + BTN_DIRECT)); \
	if [ $$BTN_TOTAL -gt 0 ]; then BTN_RATE=$$((BTN_TOSS * 100 / BTN_TOTAL)); else BTN_RATE=0; fi; \
	echo "Button:     $$BTN_TOSS Toss / $$BTN_DIRECT Direct = $$BTN_RATE%"
	@CARD_TOSS=$$(grep -rE "TossCard|TossExpandableCard" lib/features --include="*.dart" 2>/dev/null | wc -l | tr -d ' '); \
	CARD_DIRECT=$$(grep -r "Card(" lib/features --include="*.dart" 2>/dev/null | wc -l | tr -d ' '); \
	CARD_TOTAL=$$((CARD_TOSS + CARD_DIRECT)); \
	if [ $$CARD_TOTAL -gt 0 ]; then CARD_RATE=$$((CARD_TOSS * 100 / CARD_TOTAL)); else CARD_RATE=0; fi; \
	echo "Card:       $$CARD_TOSS Toss / $$CARD_DIRECT Direct = $$CARD_RATE%"
	@echo ""
	@echo "🎯 Target: 70%"

# custom_lint 실행
lint-custom:
	dart run custom_lint

# Flutter analyze + custom lint
lint-all:
	@echo "🔍 Running Flutter analyze..."
	flutter analyze --no-fatal-infos
	@echo ""
	@echo "🔍 Running custom_lint..."
	dart run custom_lint || true

# ============================================
# ⚠️ DCM 파일 삭제 안전 가이드
# ============================================
# DCM은 data class, enum만 있는 파일을 "unused"로 잘못 판단할 수 있음
# 파일 삭제 전 반드시 아래 절차 따르기:
#
# 1. make unused-files-safe  (빌드 테스트 포함)
# 2. 결과 검토 후 수동으로 삭제
# 3. 삭제 후 make build-check 실행
#
# ❌ 절대 하면 안되는 것:
#    - DCM 결과만 보고 바로 파일 삭제
#    - 빌드 확인 없이 커밋
# ============================================

# 안전한 DCM 검사 (빌드 테스트 포함)
unused-files-safe:
	@echo "🔍 [1/3] 안 쓰는 파일 검사 중..."
	@~/.pub-cache/bin/metrics check-unused-files lib --disable-sunset-warning || true
	@echo ""
	@echo "⚠️  [2/3] 위 파일들 삭제 전 주의사항:"
	@echo "    - data class, enum만 있는 파일은 false positive일 수 있음"
	@echo "    - 파일 삭제 후 반드시 빌드 테스트 필요"
	@echo ""
	@echo "✅ [3/3] 빌드 테스트 실행 중..."
	@flutter build ios --simulator --no-pub 2>&1 | tail -5

# 빌드 확인 (파일 삭제 후 실행)
build-check:
	@echo "🔨 빌드 테스트 중..."
	@flutter build ios --simulator --no-pub 2>&1 | tail -10
	@if [ $$? -eq 0 ]; then \
		echo "✅ 빌드 성공!"; \
	else \
		echo "❌ 빌드 실패! git restore로 삭제된 파일 복원하세요."; \
	fi

# 삭제된 파일 복원
restore-deleted:
	@echo "🔄 삭제된 파일 복원 중..."
	git checkout HEAD -- lib/
	@echo "✅ 복원 완료!"
