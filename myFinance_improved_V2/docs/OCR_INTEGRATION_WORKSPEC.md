# Journal Attachments OCR Integration - 작업 명세서

## 개요

Journal(거래) 첨부파일에 OCR 기능을 추가하여 이미지에서 텍스트를 추출하고 메타데이터로 저장합니다.
이를 통해 AI가 이미지 내용을 이해하고 검색 가능하게 만듭니다.

---

## 작업 1: 데이터베이스 스키마 수정

### 1.1 journal_attachments 테이블에 컬럼 추가

```sql
-- Migration: add_ocr_metadata_to_journal_attachments
-- 실행 위치: Supabase SQL Editor 또는 Migration

ALTER TABLE journal_attachments
ADD COLUMN IF NOT EXISTS file_type TEXT,
ADD COLUMN IF NOT EXISTS file_size_bytes BIGINT,
ADD COLUMN IF NOT EXISTS ocr_text TEXT,
ADD COLUMN IF NOT EXISTS ocr_metadata JSONB,
ADD COLUMN IF NOT EXISTS ocr_processed_at TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS ocr_status TEXT DEFAULT 'pending';

-- 컬럼 설명 추가
COMMENT ON COLUMN journal_attachments.file_type IS 'MIME type of the file (e.g., image/jpeg, application/pdf)';
COMMENT ON COLUMN journal_attachments.file_size_bytes IS 'File size in bytes';
COMMENT ON COLUMN journal_attachments.ocr_text IS 'Extracted text from OCR processing';
COMMENT ON COLUMN journal_attachments.ocr_metadata IS 'Full OCR response including coordinates, confidence scores, and parsed results';
COMMENT ON COLUMN journal_attachments.ocr_processed_at IS 'Timestamp when OCR was processed (UTC)';
COMMENT ON COLUMN journal_attachments.ocr_status IS 'OCR processing status: pending, processing, completed, failed, skipped';

-- OCR 텍스트 전문 검색 인덱스 (선택사항)
CREATE INDEX IF NOT EXISTS idx_journal_attachments_ocr_text
ON journal_attachments USING gin(to_tsvector('english', COALESCE(ocr_text, '')));

-- OCR 상태 인덱스 (pending 조회용)
CREATE INDEX IF NOT EXISTS idx_journal_attachments_ocr_status
ON journal_attachments(ocr_status) WHERE ocr_status = 'pending';
```

### 1.2 추가되는 컬럼 상세

| 컬럼명 | 타입 | Nullable | 기본값 | 설명 |
|--------|------|----------|--------|------|
| `file_type` | TEXT | YES | - | MIME 타입 (image/jpeg, image/png, application/pdf 등) |
| `file_size_bytes` | BIGINT | YES | - | 파일 크기 (바이트) |
| `ocr_text` | TEXT | YES | - | OCR로 추출한 전체 텍스트 |
| `ocr_metadata` | JSONB | YES | - | OCR 상세 결과 (좌표, 신뢰도 등) |
| `ocr_processed_at` | TIMESTAMPTZ | YES | - | OCR 처리 완료 시간 |
| `ocr_status` | TEXT | YES | 'pending' | 처리 상태 |

### 1.3 OCR Status 값 정의

| Status | 설명 |
|--------|------|
| `pending` | OCR 대기 중 (새로 업로드된 이미지) |
| `processing` | OCR 처리 중 |
| `completed` | OCR 완료 |
| `failed` | OCR 실패 (재시도 가능) |
| `skipped` | OCR 건너뜀 (PDF, 지원하지 않는 파일 등) |

---

## 작업 2: OCR Edge Function 생성

### 2.1 Edge Function 코드

파일 경로: `supabase/functions/process-ocr/index.ts`

```typescript
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const OCR_API_KEY = Deno.env.get("OCR_SPACE_API_KEY") || "730c7f32de88957";
const OCR_API_URL = "https://api.ocr.space/parse/image";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

interface OcrRequest {
  attachment_id: string;
  file_url: string;
  file_type?: string;
}

interface OcrSpaceResponse {
  OCRExitCode: number;
  IsErroredOnProcessing: boolean;
  ParsedResults?: Array<{
    ParsedText: string;
    FileParseExitCode: number;
    ErrorMessage?: string;
    TextOverlay?: {
      Lines: Array<{
        Words: Array<{
          WordText: string;
          Left: number;
          Top: number;
          Height: number;
          Width: number;
        }>;
        MaxHeight: number;
        MinTop: number;
      }>;
    };
  }>;
  ErrorMessage?: string[];
  ProcessingTimeInMilliseconds: string;
}

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const supabaseClient = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
    );

    const { attachment_id, file_url, file_type }: OcrRequest = await req.json();

    // Validate input
    if (!attachment_id || !file_url) {
      return new Response(
        JSON.stringify({ error: "attachment_id and file_url are required" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Skip non-image files
    const supportedTypes = ["image/jpeg", "image/png", "image/gif", "image/webp", "image/bmp"];
    if (file_type && !supportedTypes.some(t => file_type.startsWith("image/"))) {
      await supabaseClient
        .from("journal_attachments")
        .update({ ocr_status: "skipped" })
        .eq("attachment_id", attachment_id);

      return new Response(
        JSON.stringify({ status: "skipped", reason: "Not an image file" }),
        { headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Update status to processing
    await supabaseClient
      .from("journal_attachments")
      .update({ ocr_status: "processing" })
      .eq("attachment_id", attachment_id);

    // Determine file extension from URL or file_type
    let fileExtension = "jpg";
    if (file_type) {
      const typeMap: Record<string, string> = {
        "image/jpeg": "jpg",
        "image/png": "png",
        "image/gif": "gif",
        "image/webp": "webp",
        "image/bmp": "bmp",
      };
      fileExtension = typeMap[file_type] || "jpg";
    }

    // Convert public URL to authenticated URL for OCR API
    // OCR.space needs a publicly accessible URL, so we need to handle this
    const imageUrl = file_url.replace("/object/public/", "/object/public/");

    // Call OCR.space API
    const formData = new FormData();
    formData.append("url", imageUrl);
    formData.append("language", "eng+kor"); // English + Korean
    formData.append("filetype", fileExtension);
    formData.append("OCREngine", "2"); // Engine 2 is better for receipts
    formData.append("isOverlayRequired", "true"); // Get text coordinates
    formData.append("detectOrientation", "true");
    formData.append("scale", "true");

    const ocrResponse = await fetch(OCR_API_URL, {
      method: "POST",
      headers: {
        "apikey": OCR_API_KEY,
      },
      body: formData,
    });

    const ocrResult: OcrSpaceResponse = await ocrResponse.json();

    // Check for OCR errors
    if (ocrResult.IsErroredOnProcessing || ocrResult.OCRExitCode !== 1) {
      const errorMessage = ocrResult.ErrorMessage?.join(", ") || "OCR processing failed";

      await supabaseClient
        .from("journal_attachments")
        .update({
          ocr_status: "failed",
          ocr_metadata: { error: errorMessage, raw_response: ocrResult },
          ocr_processed_at: new Date().toISOString(),
        })
        .eq("attachment_id", attachment_id);

      return new Response(
        JSON.stringify({ status: "failed", error: errorMessage }),
        { headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Extract text from all parsed results
    const extractedText = ocrResult.ParsedResults
      ?.map(r => r.ParsedText)
      .join("\n")
      .trim() || "";

    // Prepare metadata
    const metadata = {
      ocr_exit_code: ocrResult.OCRExitCode,
      processing_time_ms: ocrResult.ProcessingTimeInMilliseconds,
      parsed_results: ocrResult.ParsedResults?.map(r => ({
        text: r.ParsedText,
        exit_code: r.FileParseExitCode,
        text_overlay: r.TextOverlay,
      })),
      engine_used: 2,
      languages: ["eng", "kor"],
    };

    // Update database with OCR results
    await supabaseClient
      .from("journal_attachments")
      .update({
        ocr_text: extractedText,
        ocr_metadata: metadata,
        ocr_status: "completed",
        ocr_processed_at: new Date().toISOString(),
      })
      .eq("attachment_id", attachment_id);

    return new Response(
      JSON.stringify({
        status: "completed",
        attachment_id,
        text_length: extractedText.length,
        preview: extractedText.substring(0, 200),
      }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );

  } catch (error) {
    console.error("OCR processing error:", error);
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
```

### 2.2 Edge Function 환경 변수 설정

Supabase Dashboard > Edge Functions > process-ocr > Settings에서 설정:

```
OCR_SPACE_API_KEY=730c7f32de88957
```

### 2.3 Edge Function 배포 명령어

```bash
supabase functions deploy process-ocr
```

---

## 작업 3: RPC 함수 수정 (get_transaction_history_utc)

### 3.1 attachments 반환 부분 수정

현재 RPC에서 attachments를 반환하는 부분을 수정하여 새 컬럼들을 포함:

```sql
-- 기존 코드 (attachments 부분)
'attachments', COALESCE(
    (
        SELECT json_agg(
            json_build_object(
                'attachment_id', ja.attachment_id::text,
                'file_url', ja.file_url,
                'file_name', ja.file_name,
                'uploaded_by', ja.uploaded_by::text,
                'uploaded_at_utc', ja.uploaded_at_utc
            ) ORDER BY ja.uploaded_at_utc
        )
        FROM journal_attachments ja
        WHERE ja.journal_id = ewl.journal_id
    ),
    '[]'::json
)

-- 수정된 코드 (새 컬럼 추가)
'attachments', COALESCE(
    (
        SELECT json_agg(
            json_build_object(
                'attachment_id', ja.attachment_id::text,
                'file_url', ja.file_url,
                'file_name', ja.file_name,
                'file_type', ja.file_type,
                'file_size_bytes', ja.file_size_bytes,
                'ocr_text', ja.ocr_text,
                'ocr_status', ja.ocr_status,
                'uploaded_by', ja.uploaded_by::text,
                'uploaded_at_utc', ja.uploaded_at_utc
            ) ORDER BY ja.uploaded_at_utc
        )
        FROM journal_attachments ja
        WHERE ja.journal_id = ewl.journal_id
    ),
    '[]'::json
)
```

---

## 작업 4: Flutter 앱 수정

### 4.1 TransactionAttachmentModel 수정

파일: `lib/features/transaction_history/data/models/transaction_model.dart`

```dart
/// Transaction attachment model
@freezed
class TransactionAttachmentModel with _$TransactionAttachmentModel {
  const TransactionAttachmentModel._();

  const factory TransactionAttachmentModel({
    @JsonKey(name: 'attachment_id') required String attachmentId,
    @JsonKey(name: 'file_name') required String fileName,
    @JsonKey(name: 'file_type') required String fileType,
    @JsonKey(name: 'file_url') String? fileUrl,
    @JsonKey(name: 'file_size_bytes') int? fileSizeBytes,
    @JsonKey(name: 'ocr_text') String? ocrText,
    @JsonKey(name: 'ocr_status') String? ocrStatus,
  }) = _TransactionAttachmentModel;

  factory TransactionAttachmentModel.fromJson(Map<String, dynamic> json) {
    final fileName = json['file_name']?.toString() ?? '';
    final fileType = json['file_type']?.toString() ?? _inferMimeType(fileName);

    return TransactionAttachmentModel(
      attachmentId: json['attachment_id']?.toString() ?? '',
      fileName: fileName,
      fileType: fileType,
      fileUrl: json['file_url']?.toString(),
      fileSizeBytes: json['file_size_bytes'] as int?,
      ocrText: json['ocr_text']?.toString(),
      ocrStatus: json['ocr_status']?.toString() ?? 'pending',
    );
  }

  // ... 기존 메서드들

  /// Check if OCR is available
  bool get hasOcrText => ocrText != null && ocrText!.isNotEmpty;

  /// Check if OCR is completed
  bool get isOcrCompleted => ocrStatus == 'completed';
}
```

### 4.2 TransactionAttachment Entity 수정

파일: `lib/features/transaction_history/domain/entities/transaction.dart`

```dart
/// Transaction attachment entity
class TransactionAttachment {
  final String attachmentId;
  final String fileName;
  final String fileType;
  final String? fileUrl;
  final int? fileSizeBytes;
  final String? ocrText;
  final String? ocrStatus;

  const TransactionAttachment({
    required this.attachmentId,
    required this.fileName,
    required this.fileType,
    this.fileUrl,
    this.fileSizeBytes,
    this.ocrText,
    this.ocrStatus,
  });

  bool get isImage => fileType.startsWith('image/');
  bool get isPdf => fileType == 'application/pdf';
  String get fileExtension => fileName.split('.').last.toLowerCase();
  bool get hasOcrText => ocrText != null && ocrText!.isNotEmpty;
  bool get isOcrCompleted => ocrStatus == 'completed';
}
```

### 4.3 이미지 업로드 시 OCR 트리거

이미지 업로드 후 Edge Function 호출하는 로직 추가:

```dart
/// Call OCR Edge Function after image upload
Future<void> triggerOcrProcessing({
  required String attachmentId,
  required String fileUrl,
  String? fileType,
}) async {
  try {
    await Supabase.instance.client.functions.invoke(
      'process-ocr',
      body: {
        'attachment_id': attachmentId,
        'file_url': fileUrl,
        'file_type': fileType,
      },
    );
  } catch (e) {
    // OCR 실패해도 업로드는 성공으로 처리
    debugPrint('OCR trigger failed: $e');
  }
}
```

---

## 작업 5: 이미지 업로드 프로세스 수정

### 5.1 업로드 시 file_type, file_size_bytes 저장

현재 이미지 업로드 코드를 수정하여 새 컬럼들도 저장:

```dart
// 기존 INSERT
await supabase.from('journal_attachments').insert({
  'journal_id': journalId,
  'file_url': fileUrl,
  'file_name': fileName,
  'uploaded_by': userId,
  'uploaded_at_utc': DateTime.now().toUtc().toIso8601String(),
});

// 수정된 INSERT
await supabase.from('journal_attachments').insert({
  'journal_id': journalId,
  'file_url': fileUrl,
  'file_name': fileName,
  'file_type': mimeType, // 예: 'image/jpeg'
  'file_size_bytes': fileSizeBytes,
  'uploaded_by': userId,
  'uploaded_at_utc': DateTime.now().toUtc().toIso8601String(),
  'ocr_status': 'pending',
});

// 업로드 후 OCR 트리거
await triggerOcrProcessing(
  attachmentId: insertedId,
  fileUrl: fileUrl,
  fileType: mimeType,
);
```

---

## 작업 6: OCR 텍스트 표시 UI (선택사항)

### 6.1 첨부파일 상세에서 OCR 텍스트 표시

```dart
Widget _buildOcrTextSection(TransactionAttachment attachment) {
  if (!attachment.hasOcrText) {
    if (attachment.ocrStatus == 'pending') {
      return Text('OCR 처리 대기 중...', style: TextStyle(color: Colors.grey));
    } else if (attachment.ocrStatus == 'processing') {
      return Row(
        children: [
          SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
          SizedBox(width: 8),
          Text('OCR 처리 중...'),
        ],
      );
    } else if (attachment.ocrStatus == 'failed') {
      return Text('OCR 처리 실패', style: TextStyle(color: Colors.red));
    }
    return SizedBox.shrink();
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('추출된 텍스트', style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 8),
      Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: SelectableText(
          attachment.ocrText!,
          style: TextStyle(fontSize: 12),
        ),
      ),
    ],
  );
}
```

---

## 작업 7: 기존 이미지 OCR 처리 (배치)

### 7.1 기존 이미지들 OCR 처리하는 스크립트

Supabase SQL Editor에서 실행하거나 별도 스크립트로:

```sql
-- 기존 이미지들 중 OCR 미처리된 것 조회
SELECT
    attachment_id,
    file_url,
    file_name
FROM journal_attachments
WHERE ocr_status IS NULL OR ocr_status = 'pending'
AND (
    file_name ILIKE '%.jpg'
    OR file_name ILIKE '%.jpeg'
    OR file_name ILIKE '%.png'
    OR file_name ILIKE '%.gif'
    OR file_name ILIKE '%.webp'
);
```

이 결과를 반복하며 Edge Function 호출하는 스크립트 작성 필요.

---

## OCR.space API 정보

### API 엔드포인트
```
POST https://api.ocr.space/parse/image
```

### 사용 중인 API Key
```
730c7f32de88957
```

### 주요 파라미터

| 파라미터 | 값 | 설명 |
|----------|-----|------|
| `url` | 이미지 URL | 처리할 이미지 URL |
| `language` | `eng+kor` | 영어 + 한국어 |
| `filetype` | `jpg`, `png` 등 | 파일 확장자 |
| `OCREngine` | `2` | Engine 2가 영수증에 더 적합 |
| `isOverlayRequired` | `true` | 텍스트 좌표 정보 포함 |
| `detectOrientation` | `true` | 이미지 방향 자동 감지 |
| `scale` | `true` | 이미지 스케일링 |

### API 응답 예시

```json
{
  "OCRExitCode": 1,
  "IsErroredOnProcessing": false,
  "ParsedResults": [
    {
      "ParsedText": "영수증\n상품명: 커피\n금액: 5,000원\n",
      "FileParseExitCode": 1,
      "TextOverlay": {
        "Lines": [
          {
            "Words": [
              { "WordText": "영수증", "Left": 100, "Top": 50, "Height": 20, "Width": 60 }
            ]
          }
        ]
      }
    }
  ],
  "ProcessingTimeInMilliseconds": "1234"
}
```

### API 제한 사항

- 무료 플랜: 25,000 requests/month
- 파일 크기: 최대 1MB (무료), 5MB (유료)
- 지원 언어: 영어, 한국어, 일본어, 중국어 등

---

## 작업 순서 요약

1. **DB 마이그레이션**: 테이블에 컬럼 추가
2. **Edge Function 배포**: OCR 처리 함수
3. **RPC 수정**: 새 컬럼 반환하도록
4. **Flutter 모델 수정**: 새 필드 추가
5. **업로드 로직 수정**: OCR 트리거 추가
6. **UI 수정** (선택): OCR 텍스트 표시
7. **기존 데이터 처리** (선택): 배치 OCR

---

## 테스트 체크리스트

- [ ] 새 이미지 업로드 시 OCR 자동 실행되는지
- [ ] OCR 결과가 DB에 저장되는지
- [ ] 한글/영어 혼합 이미지 OCR 정확도
- [ ] 영수증 이미지 OCR 정확도
- [ ] OCR 실패 시 에러 처리 정상 동작
- [ ] PDF 파일은 OCR 건너뛰는지
- [ ] 기존 이미지 배치 OCR 동작

---

## 추가 고려사항

### 보안
- OCR API Key는 Edge Function 환경변수로만 관리
- 클라이언트에 API Key 노출 금지

### 비용
- OCR.space 무료 플랜 제한 확인
- 필요시 유료 플랜 또는 대안 API 검토

### 대안 API
- Google Cloud Vision API
- AWS Textract
- Azure Computer Vision
- Tesseract (자체 호스팅)

---

## 문의사항

작업 중 문의사항이 있으면 연락주세요.

**작성일**: 2024-12-06
**작성자**: Claude Assistant
