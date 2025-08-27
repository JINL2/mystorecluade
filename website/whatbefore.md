# Cash Ending 스토어 필터링 문제 수정

## 문제 상황
Cash Ending 페이지에서 스토어 필터 선택 시 해당 스토어에 속한 캐시 로케이션만 표시되어야 하는데, 모든 캐시 로케이션이 표시되는 문제가 있었음.

## 문제 원인
Supabase RPC 함수 `get_cash_balance_amounts`에서:
1. `cash_locations` 테이블 조회 시 `store_id` 필드를 반환하지 않음
2. 스토어별 필터링이 제대로 적용되지 않음
3. 프론트엔드에서 받은 데이터에 `store_id: undefined`로 표시됨

## 수정 내용

### 1. Supabase RPC 함수 수정
파일: `database migration`
- `get_cash_balance_amounts` 함수 업데이트
- `cash_locations` 테이블 조회 시 `store_id` 필드 추가
- `balance_locations` CTE에 `cl.store_id` 추가
- `actual_locations` CTE에 `cl.store_id` 추가
- JSON 응답에 `store_id` 필드 포함
- 스토어별 필터링 조건 강화: `AND (p_store_id IS NULL OR cl.store_id = p_store_id)`

### 2. 수정된 부분
```sql
-- BEFORE (문제)
SELECT 
    cl.cash_location_id,
    cl.location_name,
    -- store_id 누락
FROM cash_locations cl
WHERE cl.company_id = p_company_id
-- 스토어별 필터링 누락

-- AFTER (수정)
SELECT 
    cl.cash_location_id,
    cl.location_name,
    cl.store_id,  -- ADDED: Include store_id
FROM cash_locations cl
WHERE cl.company_id = p_company_id
AND (p_store_id IS NULL OR cl.store_id = p_store_id)  -- ADDED: Store filtering
```

## 테스트 결과
### Before (수정 전)
- "test1" 스토어 선택 시: 9개 캐시 로케이션 (모든 스토어의 로케이션)
- "Hongdae Branch" 선택 시: 9개 캐시 로케이션 (모든 스토어의 로케이션)
- `store_id: undefined`

### After (수정 후)
- "test1" 스토어 선택 시: 4개 캐시 로케이션 (Bank, Cashier, throng, Vault)
- "Hongdae Branch" 선택 시: 1개 캐시 로케이션 (Test Nghia UI 2)
- `store_id: d3dfa42c-9c18-46ed-8dbc-a6d67a2ab7ff` (올바른 값)

## 영향범위
- Cash Ending 페이지의 스토어 필터링 기능
- 스토어별 캐시 로케이션 표시
- 캐시 데이터 정확성 향상

## 후속 작업 필요사항
없음. 수정 완료.

## 추가 수정 내용 (2025-08-20 19:03)
### Cash Ending 모달 크기 및 탭 문제 해결

**문제:**
- Cash Ending 버튼을 누르면 나타나는 팝업 크기가 너무 컸음 (fullscreen)
- Vault Ending과 Bank Ending 탭이 불필요하게 표시됨

**해결방법:**
1. **TossModal에서 커스텀 HTML 모달로 변경**
   - `initializeCashEndingModal()` 함수를 완전히 재작성
   - TossModal 대신 직접 HTML로 모달 구조 생성
   - 탭 시스템 제거하고 Cash Ending 콘텐츠만 표시

2. **모달 크기 조정**
   - 800px 고정 폭으로 설정 (데스크톱)
   - 반응형 디자인: 모바일에서는 100vw
   - 최대 높이 90vh로 제한

3. **CSS 스타일 추가**
   - `cash-ending.css`에 모달 전용 스타일 추가
   - `.cash-ending-modal` 클래스로 크기 제어
   - 애니메이션 및 전환 효과 추가

**수정된 파일:**
- `/pages/finance/cash-ending/index.html` - 모달 초기화 로직 변경
- `/pages/finance/cash-ending/cash-ending.css` - 모달 스타일 추가

**결과:**
- ✅ 모달 크기가 적절하게 조정됨 (800px)
- ✅ 불필요한 Vault/Bank Ending 탭 제거
- ✅ 깔끔하고 사용자 친화적인 모달 디자인
- ✅ 반응형 디자인으로 모바일 호환성 확보

## 수정 완료 일시
2025-08-20 19:03 (KST)

## 수정자
Claude AI Assistant

---

## AI 가이드라인
이 문서를 읽는 AI는 다음 사항을 참고하세요:

1. **Supabase RPC 함수**: `get_cash_balance_amounts` 함수가 스토어별 필터링을 지원하도록 업데이트됨
2. **필터링 로직**: 프론트엔드에서 스토어 ID를 전달하면 해당 스토어의 캐시 로케이션만 반환됨
3. **데이터 구조**: 응답 데이터에 `store_id` 필드가 포함되어 각 캐시 로케이션의 소속 스토어를 식별 가능
4. **테스트 확인**: test1 스토어와 Hongdae Branch 스토어로 필터링 테스트 완료

추가 수정이 필요한 경우, 이 문서의 수정 내용을 참고하여 작업을 진행하시기 바랍니다.
