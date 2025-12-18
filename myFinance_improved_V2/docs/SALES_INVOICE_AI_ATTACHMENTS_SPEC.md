# Sales Invoice - AI Description & Attachments 기능 명세서

## 1. 개요

Sales Invoice Detail에 AI description과 첨부파일(이미지) 표시 기능을 추가합니다.
Transaction History와 Cash Location의 Journal Detail Sheet와 동일한 UX를 제공합니다.

## 2. 데이터베이스 구조

### 2.1 테이블 관계
```
inventory_invoice (invoice_id)
       ↓ (invoice_id)
journal_entries (journal_id, ai_description)
       ↓ (journal_id)
journal_attachments (file_url, file_name, file_type)
```

### 2.2 연결 방식
- `journal_entries.invoice_id` = `inventory_invoice.invoice_id`
- `journal_attachments.journal_id` = `journal_entries.journal_id`

## 3. RPC 수정 사항

### 3.1 `get_invoice_detail` RPC 수정

**추가 필드:**
```json
{
  "data": {
    // ... 기존 필드 ...

    "journal": {
      "journal_id": "uuid",
      "ai_description": "AI가 분석한 거래 요약",
      "attachments": [
        {
          "attachment_id": "uuid",
          "file_url": "https://...",
          "file_name": "receipt.jpg",
          "file_type": "image/jpeg"
        }
      ]
    }
  }
}
```

### 3.2 효율성 고려사항
- OCR text는 UI에서 사용하지 않으므로 제외 (데이터 전송량 감소)
- 단일 쿼리로 journal + attachments 조회 (N+1 방지)
- LEFT JOIN으로 journal이 없는 invoice도 정상 처리

## 4. Flutter 수정 사항

### 4.1 Domain Layer

**`invoice_detail.dart` 엔티티 수정:**
```dart
class InvoiceDetail extends Equatable {
  // ... 기존 필드 ...

  // 추가 필드
  final String? journalId;
  final String? aiDescription;
  final List<InvoiceAttachment> attachments;
}

class InvoiceAttachment extends Equatable {
  final String attachmentId;
  final String fileName;
  final String fileType;
  final String? fileUrl;

  bool get isImage => fileType.startsWith('image/');
  bool get isPdf => fileType == 'application/pdf';
}
```

### 4.2 Data Layer

**`invoice_detail_model.dart` 수정:**
```dart
factory InvoiceDetailModel.fromJson(Map<String, dynamic> json) {
  final journal = json['journal'] as Map<String, dynamic>?;
  final attachmentsList = journal?['attachments'] as List<dynamic>? ?? [];

  return InvoiceDetailModel(
    // ... 기존 필드 ...
    journalId: journal?['journal_id']?.toString(),
    aiDescription: journal?['ai_description']?.toString(),
    attachments: attachmentsList.map((e) =>
      InvoiceAttachmentModel.fromJson(e as Map<String, dynamic>)
    ).toList(),
  );
}
```

### 4.3 Presentation Layer

**`invoice_detail_modal.dart` UI 추가:**

1. **AI Description 섹션** (Description Box 아래)
   - 아이콘: `Icons.auto_awesome` (amber 색상)
   - 레이블: "AI Summary"
   - journal.ai_description이 있을 때만 표시

2. **Attachments 섹션** (하단)
   - 이미지 갤러리: 첫 번째 이미지 크게, 나머지 썸네일
   - PDF 등 파일: 아이콘 + 파일명 리스트
   - 풀스크린 뷰어 지원 (AttachmentFullscreenViewer 재사용)

## 5. UI/UX 디자인

### 5.1 AI Description Box
```
┌─────────────────────────────────────┐
│ ✨ AI Summary                       │
│ ─────────────────────────────────── │
│ 루이비통 벨트 2개와 고야드 가방 1개를   │
│ 현금으로 판매. 총 490만원 결제 완료.   │
└─────────────────────────────────────┘
```

### 5.2 Attachments Section
```
┌─────────────────────────────────────┐
│ 📎 Attachments (2)                  │
├─────────────────────────────────────┤
│ ┌─────────────────────────────────┐ │
│ │                                 │ │
│ │      [첫 번째 이미지 - 크게]      │ │
│ │       (BoxFit.contain)          │ │
│ │                                 │ │
│ └─────────────────────────────────┘ │
│                                     │
│ [썸네일1] [썸네일2] [+3]            │
└─────────────────────────────────────┘
```

## 6. 구현 순서

### Phase 1: RPC 수정
1. `get_invoice_detail` RPC에 journal 정보 추가
2. 마이그레이션 파일 생성 및 배포

### Phase 2: Flutter 엔티티/모델
1. `InvoiceAttachment` 클래스 생성
2. `InvoiceDetail` 엔티티에 필드 추가
3. `InvoiceDetailModel` 파싱 로직 추가

### Phase 3: UI 구현
1. `invoice_detail_modal.dart`에 AI Description 섹션 추가
2. Attachments 섹션 추가 (이미지 갤러리)
3. 풀스크린 뷰어 연동

## 7. 파일 목록

### 수정 파일
| 파일 | 변경 내용 |
|------|----------|
| `supabase/migrations/20251218_update_invoice_detail_rpc.sql` | RPC에 journal 정보 추가 |
| `domain/entities/invoice_detail.dart` | InvoiceAttachment, aiDescription 추가 |
| `data/models/invoice_detail_model.dart` | 파싱 로직 추가 |
| `presentation/modals/invoice_detail_modal.dart` | UI 섹션 추가 |

### 재사용 컴포넌트
- `AttachmentFullscreenViewer` (transaction_history에서)
- `StorageUrlHelper` (인증된 URL 생성)
- `CachedNetworkImage` (이미지 로딩)

## 8. 테스트 체크리스트

- [ ] Journal이 있는 invoice - AI description, attachments 표시
- [ ] Journal이 없는 invoice - 정상 동작 (빈 섹션)
- [ ] Attachments가 없는 경우 - 섹션 숨김
- [ ] 이미지 탭 시 풀스크린 뷰어 오픈
- [ ] PDF 파일 표시
- [ ] 로딩/에러 상태 처리
