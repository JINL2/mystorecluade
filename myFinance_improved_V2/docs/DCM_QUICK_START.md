# DCM 빠른 시작 가이드

> 15살도 이해할 수 있는 DCM 사용법!

---

## DCM이 뭐야?

**DCM (Dart Code Metrics)** = 코드 청소 도우미

집에 안 쓰는 물건이 쌓이면 정리해야 하잖아?
코드도 마찬가지야. 안 쓰는 코드가 쌓이면:
- 앱이 느려지고
- 버그 찾기 어렵고
- 팀원들이 헷갈려해

DCM은 **"이 코드 안 쓰고 있어요!"** 라고 알려주는 도구야.

---

## 1단계: 설치하기 (한 번만 하면 됨)

터미널을 열고 이 명령어를 복사해서 붙여넣어:

```bash
dart pub global activate dart_code_metrics
```

설치 완료 메시지가 나오면 성공!

---

## 2단계: 사용하기

### 프로젝트 폴더로 이동
```bash
cd myFinance_improved_V2
```

### 안 쓰는 파일 찾기
```bash
~/.pub-cache/bin/metrics check-unused-files lib --disable-sunset-warning
```

### 안 쓰는 코드 찾기
```bash
~/.pub-cache/bin/metrics check-unused-code lib --disable-sunset-warning
```

---

## 3단계: 결과 읽는 법

### 안 쓰는 파일 결과 예시:
```
⚠ unused file: lib/core/utils/old_helper.dart
⚠ unused file: lib/features/test/debug_page.dart
```
→ 이 파일들은 아무도 import 안 하고 있어서 삭제해도 돼!

### 안 쓰는 코드 결과 예시:
```
lib/app/providers/app_state_provider.dart:
    ⚠ unused top level variable userFullNameProvider
      at line 55
```
→ `userFullNameProvider`라는 변수를 만들어놨는데 아무도 안 쓰고 있어!

---

## 쉬운 사용법 (npm scripts처럼)

매번 긴 명령어 치기 귀찮지?
아래처럼 하면 간단해져!

### Makefile 만들기

프로젝트 루트에 `Makefile` 파일을 만들어:

```makefile
# 안 쓰는 파일 찾기
unused-files:
	~/.pub-cache/bin/metrics check-unused-files lib --disable-sunset-warning

# 안 쓰는 코드 찾기
unused-code:
	~/.pub-cache/bin/metrics check-unused-code lib --disable-sunset-warning

# 둘 다 실행
check-all:
	@echo "=== 안 쓰는 파일 검사 ==="
	~/.pub-cache/bin/metrics check-unused-files lib --disable-sunset-warning
	@echo ""
	@echo "=== 안 쓰는 코드 검사 ==="
	~/.pub-cache/bin/metrics check-unused-code lib --disable-sunset-warning
```

이제 터미널에서:
```bash
make unused-files    # 안 쓰는 파일만
make unused-code     # 안 쓰는 코드만
make check-all       # 둘 다
```

---

## 실제 워크플로우

### 언제 DCM을 돌려야 해?

1. **새 기능 개발 완료 후**
   - PR 올리기 전에 한 번 돌려봐
   - 실수로 테스트 코드 남겨뒀을 수도 있으니까

2. **리팩토링 후**
   - 코드 구조 바꾸면 안 쓰는 파일 생기기 쉬워

3. **매주 한 번 정기 점검**
   - 팀에서 정해서 월요일마다 돌리기

### 작업 순서

```
1. DCM 실행
      ↓
2. 결과 확인
      ↓
3. 정말 안 쓰는지 파일 열어서 확인
      ↓
4. 안 쓰면 삭제, 쓰면 놔두기
      ↓
5. 커밋!
```

---

## 주의사항

### 삭제하면 안 되는 것들:

1. **라우터에서 동적으로 로드하는 파일**
   - 코드에서 직접 import 안 해도 라우터가 쓸 수 있어

2. **테스트 파일**
   - test/ 폴더는 검사 안 해도 돼

3. **진행 중인 기능 파일**
   - 아직 연결 안 했을 뿐이지 필요한 파일일 수 있어

### 삭제해도 되는 것들:

1. **dev_tools/ 폴더 파일들** - 개발용 디버깅 도구
2. **_old, _backup, _deprecated** 붙은 파일들
3. **6개월 이상 안 건드린 파일들** (git log로 확인)

---

## 친구에게 알려주기

친구가 프로젝트에 참여하면:

```bash
# 1. DCM 설치 (한 번만)
dart pub global activate dart_code_metrics

# 2. 프로젝트 폴더로 이동
cd myFinance_improved_V2

# 3. 검사 실행
make check-all
```

끝! 3줄이면 됨.

---

## 자주 묻는 질문

### Q: 무료야?
A: 응! 기본 기능은 완전 무료야.

### Q: 얼마나 걸려?
A: 우리 프로젝트(2400개 파일) 기준 약 15-30초

### Q: 결과가 너무 많아서 어디서부터 해야 할지 모르겠어
A: dev_tools/ 폴더부터 시작해. 거기는 삭제해도 앱에 영향 없어.

### Q: 실수로 필요한 파일 지우면?
A: git으로 복구하면 돼! `git checkout -- 파일경로`

---

## 한 줄 요약

```bash
# 이것만 기억해!
~/.pub-cache/bin/metrics check-unused-files lib --disable-sunset-warning
```

안 쓰는 파일 찾아서 → 확인하고 → 삭제하고 → 커밋!

---

**문서 버전:** 1.0
**작성일:** 2025-12-30
