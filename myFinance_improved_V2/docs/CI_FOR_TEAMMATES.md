# 친구들을 위한 CI 가이드

> "나도 뭐 설치해야 해?" → ❌ 아니! 그냥 코드만 올려!

---

## 한 줄 요약

```
코드 올리면 → GitHub가 자동 검사 → 통과하면 합쳐짐
```

---

## 이게 뭔데?

우리 프로젝트에 **자동 채점기**가 붙었어!

```
┌─────────────────────────────────────────┐
│           GitHub Actions (CI)            │
│                                          │
│   🤖 "코드 올라왔네? 검사해볼게"          │
│                                          │
│   ✅ 미사용 파일 검사                     │
│   ✅ 미사용 코드 검사                     │
│   ✅ Flutter analyze                     │
│   ✅ 빌드 테스트                          │
│                                          │
└─────────────────────────────────────────┘
```

---

## 친구가 할 일

### 평소처럼 코딩하면 됨!

```bash
git add .
git commit -m "새 기능 추가"
git push
```

### PR 올리면 자동으로 검사됨

GitHub에서 이렇게 보여:

```
✅ DCM Analysis — Passed
✅ Flutter Analyze — Passed
✅ Build Test — Passed
```

또는

```
❌ Flutter Analyze — Failed
   → "line 42: unused variable 'oldValue'"
```

---

## 실패하면 어떻게 해?

### 1. GitHub에서 "Details" 클릭

```
❌ Flutter Analyze — Failed
                      [Details] ← 이거 클릭!
```

### 2. 에러 메시지 확인

```
lib/features/my_feature/page.dart:42:5
  info • The value of the local variable 'oldValue' isn't used
```

### 3. 고치고 다시 push

```bash
# 문제 고친 후
git add .
git commit -m "fix: 미사용 변수 제거"
git push
```

### 4. 자동으로 다시 검사됨!

---

## 자주 보는 에러와 해결법

| 에러 | 의미 | 해결 |
|------|------|------|
| `unused variable` | 변수 만들고 안 씀 | 삭제하거나 사용하기 |
| `unused import` | import 했는데 안 씀 | import 문 삭제 |
| `unused file` | 파일 만들고 아무도 안 씀 | 파일 삭제 |
| `build failed` | 빌드 에러 | 코드 문법 확인 |

---

## FAQ

### Q: 나도 DCM 설치해야 해?
**A: 아니!** GitHub가 알아서 해.
원하면 설치해도 되지만 필수 아님.

### Q: 검사 얼마나 걸려?
**A:** 보통 2-5분

### Q: 검사 안 통과하면 코드 못 합쳐?
**A:** 맞아. 통과해야 merge 가능.
이게 우리 코드 품질 지키는 방법이야!

### Q: 급하면 무시할 수 있어?
**A:** 가능은 하지만... 안 하는 게 좋아.
나중에 더 큰 문제 됨.

---

## 내가 미리 검사해보고 싶으면?

(선택사항 - 안 해도 됨!)

```bash
# DCM 설치 (한 번만)
make dcm-install

# 검사 실행
make check-all
```

---

## 요약

| 질문 | 답 |
|------|-----|
| 뭐 설치해야 해? | ❌ 없음 |
| 뭐 공부해야 해? | ❌ 없음 |
| 뭐 해야 해? | ✅ 그냥 코드 올려! |

```
            평소처럼
              코딩
               │
               ▼
        git push / PR
               │
               ▼
    ┌──────────────────┐
    │  GitHub가 검사   │ ← 자동!
    └────────┬─────────┘
             │
      ┌──────┴──────┐
      ▼             ▼
    통과 ✅      실패 ❌
      │             │
      ▼             ▼
   합쳐짐!      고치고
               다시 push
```

---

**끝! 질문 있으면 물어봐!** 🚀
