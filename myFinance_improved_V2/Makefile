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
