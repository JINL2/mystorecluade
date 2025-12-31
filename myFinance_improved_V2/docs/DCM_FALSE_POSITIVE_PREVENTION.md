# DCM False Positive 예방 가이드

## 문제 상황

DCM(Dart Code Metrics)이 실제로 사용되는 파일을 "unused"로 잘못 판단하는 경우가 있음.

### 왜 이런 일이 발생하나? (15살도 이해할 수 있는 설명)

**도서관 비유:**

1. 📚 `attention_card.dart` 파일 = 책 한 권
2. 이 책에는 3개의 챕터가 있음:
   - `AttentionType` (enum) - 1장
   - `AttentionItemData` (data class) - 2장
   - `AttentionCard` (widget) - 3장

3. DCM은 이렇게 판단함:
   - "AttentionCard 위젯이 어디서도 안 쓰이네!"
   - "이 책 전체를 버려야겠다!" ❌

4. 하지만 실제로는:
   - `AttentionType`과 `AttentionItemData`는 다른 파일에서 사용 중! ✅
   - DCM이 "위젯만 안 쓰임"을 "책 전체가 안 쓰임"으로 오해한 것

### 실제 발생한 케이스

```
lib/features/time_table_manage/presentation/widgets/overview/
├── attention_card.dart        <- DCM이 삭제함 ❌
└── attention_items_builder.dart  <- AttentionItemData를 사용 중이었음!
```

---

## 예방 방법

### 1. 데이터 클래스 분리 (권장)

**Before (위험):**
```dart
// attention_card.dart - 한 파일에 모든 것이 섞여 있음
enum AttentionType { late, overtime, ... }
class AttentionItemData { ... }
class AttentionCard extends StatelessWidget { ... }
```

**After (안전):**
```dart
// domain/entities/attention_item_data.dart - 데이터만
enum AttentionType { late, overtime, ... }
class AttentionItemData { ... }

// widgets/attention_card.dart - 위젯만
import 'attention_item_data.dart';
export 'attention_item_data.dart'; // 하위호환성 유지
class AttentionCard extends StatelessWidget { ... }
```

### 2. 파일 구조 원칙

```
feature/
├── domain/
│   └── entities/           <- 데이터 클래스/enum은 여기!
│       ├── attention_type.dart
│       └── attention_item_data.dart
├── data/
│   └── models/             <- 서버 응답 모델은 여기!
│       └── attention_response.dart
└── presentation/
    └── widgets/            <- 위젯만!
        └── attention_card.dart
```

### 3. 안전한 DCM 실행 절차

```bash
# 1. 안전 모드로 검사 (빌드 테스트 포함)
make unused-files-safe

# 2. 파일 삭제 후 반드시 빌드 확인
make build-check

# 3. 문제 발생 시 복원
make restore-deleted
```

---

## DCM 사용 시 체크리스트

파일 삭제 전 확인할 것:

- [ ] 해당 파일에 enum, data class가 있나?
- [ ] 다른 파일에서 import 하고 있나? (`grep -r "import.*파일명"`)
- [ ] `flutter build` 성공하나?

### 삭제하면 안 되는 파일 패턴

| 파일 패턴 | 이유 |
|-----------|------|
| `*_data.dart` | Data class 포함 가능성 높음 |
| `*_type.dart` | Enum 포함 가능성 높음 |
| `*_model.dart` | 서버 응답 모델일 가능성 |
| `freezed.dart` | Freezed 생성 파일 |
| `*.g.dart` | 코드 생성 파일 |

---

## 발생 시 복구 방법

```bash
# 특정 파일 복원
git checkout HEAD~1 -- lib/path/to/file.dart

# 전체 lib 폴더 복원
git checkout HEAD -- lib/

# 커밋 전이라면
git restore lib/path/to/file.dart
```

---

## Makefile 명령어 요약

```makefile
make unused-files      # DCM 검사 (기본)
make unused-files-safe # DCM 검사 + 빌드 테스트
make build-check       # 삭제 후 빌드 확인
make restore-deleted   # 삭제된 파일 복원
```

---

## 결론

**핵심 원칙:**
1. **위젯과 데이터 클래스를 분리**하여 DCM이 혼동하지 않도록 함
2. **삭제 전 반드시 빌드 테스트** 실행
3. **문제 발생 시 git으로 즉시 복원**

DCM은 유용한 도구이지만, 맹목적으로 결과를 따르면 안 됨!
