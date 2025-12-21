# 📚 Documentation Index - Transaction Template Module

> **모든 문서의 시작점입니다. 당신의 역할에 맞는 문서를 선택하세요!**

---

## 🎯 나는 누구인가요?

### 👨‍🎨 **UI/UX 디자이너입니다**

**읽어야 할 문서**: [UI_DESIGNER_GUIDE.md](./UI_DESIGNER_GUIDE.md)

**이 문서는 당신을 위한 것입니다!**

✅ 디자인만 수정하고 싶어요
✅ 색상, 폰트, 간격을 바꾸고 싶어요
✅ 버튼 위치나 레이아웃을 조정하고 싶어요
✅ AI를 사용해서 디자인을 수정하고 싶어요
✅ 비즈니스 로직은 건드리고 싶지 않아요

**문서 내용:**
- ✅ 수정 가능한 파일 vs 금지된 파일
- ✅ 디자인 시스템 (색상, 폰트, 간격)
- ✅ 화면별 수정 가이드
- ✅ 컴포넌트 카탈로그
- ✅ AI 프롬프트 예시 50개
- ✅ 안전한 수정 체크리스트

**예상 소요 시간**: 30분
**난이도**: ⭐ (매우 쉬움)

---

### 👨‍💻 **개발자입니다 (백엔드/프론트엔드)**

**읽어야 할 문서**: [ARCHITECTURE_OVERVIEW.md](./ARCHITECTURE_OVERVIEW.md)

**이 문서는 당신을 위한 것입니다!**

✅ 전체 아키텍처를 이해하고 싶어요
✅ 새로운 기능을 추가하고 싶어요
✅ 비즈니스 로직을 수정하고 싶어요
✅ 데이터베이스 연동을 이해하고 싶어요
✅ 파일 구조와 의존성을 파악하고 싶어요

**문서 내용:**
- ✅ Clean Architecture 상세 설명
- ✅ 폴더 구조 (72 files)
- ✅ 데이터 흐름 다이어그램
- ✅ 파일별 책임 매트릭스
- ✅ 작업별 수정 가이드
- ✅ 일반적인 패턴들
- ✅ Integration Points

**예상 소요 시간**: 1시간
**난이도**: ⭐⭐⭐ (중급)

---

### 🤖 **AI Agent입니다**

**읽어야 할 문서**: 모두 다!

**추천 읽는 순서:**

1. **[README.md](./README.md)** (5분) - 전체 개요
2. **[ARCHITECTURE_OVERVIEW.md](./ARCHITECTURE_OVERVIEW.md)** (15분) - 구조 파악
3. **[UI_DESIGNER_GUIDE.md](./UI_DESIGNER_GUIDE.md)** (10분) - UI 레이어 이해

**AI가 자주 하는 작업:**
- ✅ 디자인 수정 요청 처리
- ✅ 새로운 기능 추가
- ✅ 버그 수정
- ✅ 코드 리팩토링
- ✅ 테스트 작성

**AI를 위한 Quick Commands:**

```
# 디자인 변경 요청 시
→ Read: UI_DESIGNER_GUIDE.md
→ Section: "화면별 가이드" + "디자인 시스템"
→ Modify: presentation/ 폴더만 수정
→ Verify: Provider 로직 건드리지 않았는지 확인

# 비즈니스 로직 변경 요청 시
→ Read: ARCHITECTURE_OVERVIEW.md
→ Section: "Modification Guide by Task"
→ Modify: domain/ 폴더 우선, data/ 필요시
→ Verify: Presentation Layer 영향 최소화

# 새 기능 추가 요청 시
→ Read: ARCHITECTURE_OVERVIEW.md
→ Section: "Common Patterns"
→ Follow: Domain → Data → Presentation 순서
→ Test: 각 레이어별로 테스트
```

---

### 🏢 **프로젝트 매니저/아키텍트입니다**

**읽어야 할 문서**: [README.md](./README.md)

**이 문서는 당신을 위한 것입니다!**

✅ 프로젝트 전체 개요를 보고 싶어요
✅ 기능 목록을 확인하고 싶어요
✅ 통계 데이터를 보고 싶어요
✅ Roadmap을 확인하고 싶어요
✅ 코드 품질 점수를 알고 싶어요

**문서 내용:**
- ✅ 프로젝트 개요
- ✅ 핵심 기능 목록
- ✅ 아키텍처 다이어그램
- ✅ 통계 (파일 수, 코드 라인)
- ✅ 디자인 시스템 소개
- ✅ Known Issues
- ✅ Roadmap
- ✅ Changelog

**예상 소요 시간**: 15분
**난이도**: ⭐ (쉬움)

---

## 📁 문서 목록 (전체)

| 문서 | 대상 독자 | 길이 | 난이도 | 설명 |
|-----|---------|------|--------|------|
| **[README.md](./README.md)** | 모든 사람 | 짧음 | ⭐ | 프로젝트 개요 및 빠른 시작 |
| **[UI_DESIGNER_GUIDE.md](./UI_DESIGNER_GUIDE.md)** | 디자이너, AI | 매우 김 | ⭐ | UI 수정 완벽 가이드 (100+ 예시) |
| **[ARCHITECTURE_OVERVIEW.md](./ARCHITECTURE_OVERVIEW.md)** | 개발자, AI | 김 | ⭐⭐⭐ | 아키텍처 상세 설명 |
| **[DOCS_INDEX.md](./DOCS_INDEX.md)** | 모든 사람 | 짧음 | ⭐ | 이 문서 (인덱스) |

---

## 🚀 빠른 시작 시나리오

### 시나리오 1: "버튼 색상을 바꾸고 싶어요"

```
1. Read: UI_DESIGNER_GUIDE.md
2. Go to: "디자인 시스템 > 색상"
3. Find: TossColors.primary
4. Change to: TossColors.success (녹색)
5. Location: presentation/pages/transaction_template_page.dart
6. Done! ✅
```

**예상 소요 시간**: 5분

---

### 시나리오 2: "새로운 검증 규칙을 추가하고 싶어요"

```
1. Read: ARCHITECTURE_OVERVIEW.md
2. Go to: "Modification Guide by Task > Task 2"
3. Modify: domain/validators/template_validator.dart
4. Add: 새로운 검증 로직
5. Test: 에러 메시지가 UI에 표시되는지 확인
6. Done! ✅
```

**예상 소요 시간**: 30분

---

### 시나리오 3: "템플릿 복제 기능을 추가하고 싶어요"

```
1. Read: ARCHITECTURE_OVERVIEW.md
2. Go to: "Modification Guide by Task > Task 4"
3. Create: domain/usecases/duplicate_template_usecase.dart
4. Implement: Repository 메서드
5. Add: Provider 메서드
6. Update: UI에 버튼 추가
7. Test: 복제가 잘 되는지 확인
8. Done! ✅
```

**예상 소요 시간**: 2시간

---

### 시나리오 4: "전체 아키텍처를 이해하고 싶어요"

```
1. Read: README.md (15분) - 전체 개요
2. Read: ARCHITECTURE_OVERVIEW.md (1시간) - 상세 구조
3. Browse: 실제 코드 파일들 (2시간)
4. Done! ✅
```

**예상 소요 시간**: 3시간

---

## 📊 문서 통계

| 항목 | 수치 |
|-----|-----|
| **총 문서 수** | 4개 |
| **총 문서 길이** | ~4,000 lines |
| **예시 코드 수** | 150+ 개 |
| **다이어그램 수** | 10+ 개 |
| **작성 시간** | 8시간 |

---

## 🔍 키워드 검색

### 원하는 작업별 문서 찾기

| 키워드 | 문서 | 섹션 |
|-------|-----|-----|
| **색상 변경** | UI_DESIGNER_GUIDE.md | 디자인 시스템 > 색상 |
| **폰트 크기** | UI_DESIGNER_GUIDE.md | 디자인 시스템 > 타이포그래피 |
| **간격 조정** | UI_DESIGNER_GUIDE.md | 디자인 시스템 > 간격 |
| **버튼 스타일** | UI_DESIGNER_GUIDE.md | 화면별 가이드 > 버튼 |
| **검증 규칙** | ARCHITECTURE_OVERVIEW.md | Task 2: 검증 규칙 추가 |
| **새 필드 추가** | ARCHITECTURE_OVERVIEW.md | Task 3: 새로운 필드 추가 |
| **UseCase 추가** | ARCHITECTURE_OVERVIEW.md | Task 4: UseCase 추가 |
| **캐싱 전략** | ARCHITECTURE_OVERVIEW.md | Task 5: 캐싱 전략 변경 |
| **Provider 사용** | ARCHITECTURE_OVERVIEW.md | Common Patterns > Pattern 1 |
| **Entity 검증** | ARCHITECTURE_OVERVIEW.md | Common Patterns > Pattern 2 |
| **Factory 패턴** | ARCHITECTURE_OVERVIEW.md | Common Patterns > Pattern 3 |
| **데이터 흐름** | ARCHITECTURE_OVERVIEW.md | Data Flow |
| **폴더 구조** | ARCHITECTURE_OVERVIEW.md | Folder Structure |

---

## 🎓 학습 경로

### 초급 (입문자)

```
Day 1: README.md → 프로젝트 개요 이해
Day 2: UI_DESIGNER_GUIDE.md → UI 수정 연습
Day 3: 실제 색상/폰트 변경해보기
```

**소요 시간**: 3일
**목표**: UI 수정할 수 있는 수준

---

### 중급 (개발자)

```
Week 1: ARCHITECTURE_OVERVIEW.md → 아키텍처 이해
Week 2: 코드 읽기 (domain/ 폴더)
Week 3: 간단한 기능 추가 (검증 규칙)
Week 4: 복잡한 기능 추가 (UseCase)
```

**소요 시간**: 4주
**목표**: 새로운 기능 추가할 수 있는 수준

---

### 고급 (아키텍트)

```
Month 1: 모든 문서 + 전체 코드 분석
Month 2: Clean Architecture 리팩토링
Month 3: 테스트 커버리지 100% 달성
```

**소요 시간**: 3개월
**목표**: 아키텍처 전체 설계 변경 가능

---

## 💡 Tips

### For Designers

1. **작은 변경부터 시작하세요** - 색상 하나부터
2. **자주 테스트하세요** - 매번 앱 실행해서 확인
3. **Git을 활용하세요** - 변경 전 커밋
4. **AI에게 물어보세요** - 확신이 없으면 물어보기

### For Developers

1. **문서를 먼저 읽으세요** - 코드 보기 전에 구조 파악
2. **Clean Architecture를 준수하세요** - 의존성 방향 지키기
3. **테스트를 작성하세요** - 새 기능은 항상 테스트와 함께
4. **리뷰를 요청하세요** - 큰 변경은 동료에게 리뷰

### For AI

1. **문서를 먼저 읽으세요** - 사용자 요청 처리 전
2. **레이어를 구분하세요** - UI는 Presentation만
3. **검증하세요** - Provider 로직 안 건드렸는지 확인
4. **설명하세요** - 무엇을 어떻게 변경했는지 명확히

---

## 🆘 FAQ

### Q1: 어떤 문서부터 읽어야 하나요?

**A**: 당신의 역할에 따라:
- 디자이너 → UI_DESIGNER_GUIDE.md
- 개발자 → ARCHITECTURE_OVERVIEW.md
- 매니저 → README.md

---

### Q2: UI만 수정하고 싶은데 어떤 파일을 건드려야 하나요?

**A**: `presentation/` 폴더만 수정하세요. 상세 내용은 UI_DESIGNER_GUIDE.md 참고.

---

### Q3: 비즈니스 로직을 변경하고 싶은데 어디서 시작하나요?

**A**: ARCHITECTURE_OVERVIEW.md의 "Modification Guide by Task" 섹션 참고.

---

### Q4: 테스트는 어떻게 작성하나요?

**A**: 현재 테스트가 없습니다 (TODO). Roadmap에 추가 예정.

---

### Q5: 새로운 화면을 추가하고 싶은데 어떻게 하나요?

**A**:
1. `presentation/pages/` 에 새 파일 생성
2. Provider 생성
3. UseCase 필요시 domain에 추가
4. Repository 필요시 data에 추가

---

## 📞 Support

### 질문이 있으신가요?

1. **문서를 먼저 검색하세요** - Ctrl+F로 키워드 검색
2. **관련 섹션을 읽으세요** - 해당 부분만 집중
3. **AI에게 물어보세요** - 이 문서를 참고하라고 알려주기
4. **팀에게 물어보세요** - Slack/Discord에 질문

### 버그를 발견하셨나요?

1. **문서 버그**: GitHub Issues에 "docs:" 라벨로 리포트
2. **코드 버그**: GitHub Issues에 "bug:" 라벨로 리포트

---

## 📝 문서 업데이트 이력

| 날짜 | 버전 | 변경 내용 |
|-----|------|---------|
| 2025-10-13 | 1.0.0 | 초기 문서 작성 (4개 문서) |

---

## 🎉 마지막으로

이 문서들은 **당신의 생산성을 극대화**하기 위해 작성되었습니다.

- ✅ 디자이너는 안전하게 디자인을 수정할 수 있습니다
- ✅ 개발자는 빠르게 구조를 파악할 수 있습니다
- ✅ AI는 정확하게 코드를 수정할 수 있습니다
- ✅ 매니저는 프로젝트 상태를 이해할 수 있습니다

**행복한 코딩 되세요! 🚀**

---

**Last Updated**: 2025-10-13
**Total Pages**: 4 documents
**Total Lines**: ~4,000 lines
**Estimated Reading Time**: 2 hours (all docs)
