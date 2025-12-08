# Supabase OCR Integration - 작업 명세서

> **담당팀**: Supabase Backend Team
> **작성일**: 2024-12-08
> **우선순위**: High
> **예상 작업시간**: 4-6시간

---

## 목적

Journal(거래) 첨부파일 이미지에서 OCR로 텍스트를 추출하여 메타데이터로 저장합니다.
이를 통해 AI가 영수증/문서 이미지 내용을 이해하고 검색할 수 있게 합니다.

### 사용 시나리오
1. 사용자가 영수증 이미지를 거래에 첨부
2. 시스템이 자동으로 OCR 처리 (배치)
3. 추출된 텍스트가 DB에 저장
4. AI가 "커피 영수증 찾아줘" 요청 시 해당 거래 검색 가능

---

## 아키텍처 개요

```
┌─────────────────────────────────────────────────────────────────┐
│                        Flutter App                               │
│  [이미지 업로드] → journal_attachments INSERT (ocr_status=pending)│
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Supabase Database                            │
│  journal_attachments 테이블 (ocr_status = 'pending')             │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼ (매 5분)
┌─────────────────────────────────────────────────────────────────┐
│                   Supabase Cron Job                              │
│  pg_cron → Edge Function (process-ocr-batch) 호출               │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                   Edge Function: process-ocr-batch               │
│  1. pending 상태 이미지 조회 (LIMIT 10)                          │
│  2. OCR.space API 호출 (다국어: eng+kor+vie+jpn+chi_sim)         │
│  3. 결과를 journal_attachments에 UPDATE                          │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                     OCR.space API                                │
│  POST https://api.ocr.space/parse/image                         │
│  API Key: 730c7f32de88957                                       │
└─────────────────────────────────────────────────────────────────┘
```

---

## 작업 1: 데이터베이스 스키마 수정

### 1.1 Migration SQL

```sql
-- =====================================================
-- Migration: add_ocr_columns_to_journal_attachments
-- Description: OCR 메타데이터 저장을 위한 컬럼 추가
-- =====================================================

-- 1. 컬럼 추가
ALTER TABLE journal_attachments
ADD COLUMN IF NOT EXISTS file_type TEXT,
ADD COLUMN IF NOT EXISTS file_size_bytes BIGINT,
ADD COLUMN IF NOT EXISTS ocr_text TEXT,
ADD COLUMN IF NOT EXISTS ocr_metadata JSONB,
ADD COLUMN IF NOT EXISTS ocr_status TEXT DEFAULT 'pending',
ADD COLUMN IF NOT EXISTS ocr_processed_at TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS ocr_error_count INTEGER DEFAULT 0;

-- 2. 컬럼 설명
COMMENT ON COLUMN journal_attachments.file_type IS 'MIME type (image/jpeg, image/png, application/pdf 등)';
COMMENT ON COLUMN journal_attachments.file_size_bytes IS '파일 크기 (bytes)';
COMMENT ON COLUMN journal_attachments.ocr_text IS 'OCR로 추출한 텍스트 (AI 검색용)';
COMMENT ON COLUMN journal_attachments.ocr_metadata IS 'OCR 상세 결과 (좌표, 신뢰도, 처리시간 등)';
COMMENT ON COLUMN journal_attachments.ocr_status IS 'OCR 상태: pending, processing, completed, failed, skipped';
COMMENT ON COLUMN journal_attachments.ocr_processed_at IS 'OCR 처리 완료 시간 (UTC)';
COMMENT ON COLUMN journal_attachments.ocr_error_count IS 'OCR 실패 횟수 (3회 초과 시 skipped 처리)';

-- 3. 인덱스 생성
-- pending 상태 조회용 (Cron Job에서 사용)
CREATE INDEX IF NOT EXISTS idx_journal_attachments_ocr_pending
ON journal_attachments(ocr_status, uploaded_at_utc)
WHERE ocr_status = 'pending';

-- 전문 검색 인덱스 (AI 검색용)
CREATE INDEX IF NOT EXISTS idx_journal_attachments_ocr_text_search
ON journal_attachments USING gin(to_tsvector('simple', COALESCE(ocr_text, '')));

-- 4. 기존 데이터 초기화 (이미지 파일만 pending, 나머지는 skipped)
UPDATE journal_attachments
SET ocr_status = CASE
    WHEN file_name ILIKE '%.jpg' OR file_name ILIKE '%.jpeg'
         OR file_name ILIKE '%.png' OR file_name ILIKE '%.gif'
         OR file_name ILIKE '%.webp' OR file_name ILIKE '%.bmp'
    THEN 'pending'
    ELSE 'skipped'
END
WHERE ocr_status IS NULL;
```

### 1.2 컬럼 상세 명세

| 컬럼명 | 타입 | Nullable | 기본값 | 설명 |
|--------|------|----------|--------|------|
| `file_type` | TEXT | YES | - | MIME 타입 (image/jpeg 등) |
| `file_size_bytes` | BIGINT | YES | - | 파일 크기 (bytes) |
| `ocr_text` | TEXT | YES | - | 추출된 텍스트 전체 |
| `ocr_metadata` | JSONB | YES | - | OCR 상세 결과 |
| `ocr_status` | TEXT | YES | 'pending' | 처리 상태 |
| `ocr_processed_at` | TIMESTAMPTZ | YES | - | 처리 완료 시간 |
| `ocr_error_count` | INTEGER | YES | 0 | 실패 횟수 |

### 1.3 OCR Status 정의

| Status | 설명 | 재처리 |
|--------|------|--------|
| `pending` | 대기 중 | - |
| `processing` | 처리 중 | - |
| `completed` | 완료 | - |
| `failed` | 실패 (재시도 가능) | O (최대 3회) |
| `skipped` | 건너뜀 (PDF, 실패 초과) | X |

---

## 작업 2: Edge Function 생성 (process-ocr-batch)

### 2.1 함수 개요

- **함수명**: `process-ocr-batch`
- **트리거**: Cron Job (매 5분)
- **처리량**: 한 번에 최대 10개
- **다국어**: 영어, 한국어, 베트남어, 일본어, 중국어

### 2.2 Edge Function 코드

파일: `supabase/functions/process-ocr-batch/index.ts`

```typescript
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// Configuration
const OCR_API_KEY = Deno.env.get("OCR_SPACE_API_KEY") || "730c7f32de88957";
const OCR_API_URL = "https://api.ocr.space/parse/image";
const BATCH_SIZE = 10;
const MAX_ERROR_COUNT = 3;

// 다국어 설정: 영어 + 한국어 + 베트남어 + 일본어 + 중국어(간체)
const OCR_LANGUAGES = "eng+kor+vie+jpn+chi_sim";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

interface Attachment {
  attachment_id: string;
  file_url: string;
  file_name: string;
  file_type: string | null;
}

interface OcrResult {
  attachment_id: string;
  success: boolean;
  text?: string;
  error?: string;
}

serve(async (req) => {
  // CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  const startTime = Date.now();
  const results: OcrResult[] = [];

  try {
    // Initialize Supabase client with service role
    const supabaseClient = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
    );

    // 1. pending 상태 이미지 조회 (오래된 것부터)
    const { data: pendingAttachments, error: fetchError } = await supabaseClient
      .from("journal_attachments")
      .select("attachment_id, file_url, file_name, file_type")
      .eq("ocr_status", "pending")
      .lt("ocr_error_count", MAX_ERROR_COUNT)
      .order("uploaded_at_utc", { ascending: true })
      .limit(BATCH_SIZE);

    if (fetchError) {
      throw new Error(`Failed to fetch pending attachments: ${fetchError.message}`);
    }

    if (!pendingAttachments || pendingAttachments.length === 0) {
      return new Response(
        JSON.stringify({
          message: "No pending attachments to process",
          processed: 0,
          duration_ms: Date.now() - startTime
        }),
        { headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    console.log(`Processing ${pendingAttachments.length} attachments...`);

    // 2. 각 이미지 OCR 처리
    for (const attachment of pendingAttachments as Attachment[]) {
      try {
        const result = await processOcrForAttachment(supabaseClient, attachment);
        results.push(result);
      } catch (error) {
        console.error(`Error processing ${attachment.attachment_id}:`, error);
        results.push({
          attachment_id: attachment.attachment_id,
          success: false,
          error: error.message
        });
      }
    }

    // 3. 결과 반환
    const successCount = results.filter(r => r.success).length;
    const failCount = results.filter(r => !r.success).length;

    return new Response(
      JSON.stringify({
        message: "Batch OCR processing completed",
        processed: results.length,
        success: successCount,
        failed: failCount,
        duration_ms: Date.now() - startTime,
        results: results
      }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );

  } catch (error) {
    console.error("Batch OCR error:", error);
    return new Response(
      JSON.stringify({
        error: error.message,
        duration_ms: Date.now() - startTime
      }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});

async function processOcrForAttachment(
  supabase: any,
  attachment: Attachment
): Promise<OcrResult> {
  const { attachment_id, file_url, file_name, file_type } = attachment;

  // 1. 이미지 파일인지 확인
  const isImage = isImageFile(file_name, file_type);
  if (!isImage) {
    await supabase
      .from("journal_attachments")
      .update({ ocr_status: "skipped" })
      .eq("attachment_id", attachment_id);

    return { attachment_id, success: true, text: "", error: "Not an image file" };
  }

  // 2. processing 상태로 변경
  await supabase
    .from("journal_attachments")
    .update({ ocr_status: "processing" })
    .eq("attachment_id", attachment_id);

  // 3. OCR API 호출
  try {
    const fileExtension = getFileExtension(file_name);

    // Form-Data 파라미터 설정 (n8n 워크플로우 기반)
    const formData = new FormData();
    formData.append("url", file_url);              // 이미지 URL (필수)
    formData.append("language", OCR_LANGUAGES);    // 언어 코드 (필수)
    formData.append("filetype", fileExtension);    // 파일 확장자 (필수)
    formData.append("OCREngine", "2");             // Engine 2 = 영수증 최적 (필수)

    // API 호출 (Timeout: 30초)
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 30000);

    const ocrResponse = await fetch(OCR_API_URL, {
      method: "POST",
      headers: { "apikey": OCR_API_KEY },  // Header에 API Key
      body: formData,
      signal: controller.signal,
    });

    clearTimeout(timeoutId);
    const ocrResult = await ocrResponse.json();

    // 4. OCR 결과 처리 - JSONB 메타데이터 구조
    if (ocrResult.IsErroredOnProcessing || ocrResult.OCRExitCode !== 1) {
      const errorMessage = ocrResult.ErrorMessage?.join(", ") || "OCR failed";

      // 실패 횟수 증가
      await supabase.rpc("increment_ocr_error_count", {
        p_attachment_id: attachment_id
      });

      // 실패 시 JSONB 메타데이터 구조
      const failedMetadata = {
        error: errorMessage,
        error_code: `E${ocrResult.OCRExitCode || 99}`,
        raw_response: {
          IsErroredOnProcessing: ocrResult.IsErroredOnProcessing,
          OCRExitCode: ocrResult.OCRExitCode,
          ErrorMessage: ocrResult.ErrorMessage,
          ErrorDetails: ocrResult.ErrorDetails || null
        },
        attempt: 1,
        processed_at: new Date().toISOString()
      };

      await supabase
        .from("journal_attachments")
        .update({
          ocr_status: "failed",
          ocr_metadata: failedMetadata,
          ocr_processed_at: new Date().toISOString(),
        })
        .eq("attachment_id", attachment_id);

      return { attachment_id, success: false, error: errorMessage };
    }

    // 5. 텍스트 추출 및 저장
    const extractedText = ocrResult.ParsedResults
      ?.map((r: any) => r.ParsedText)
      .join("\n")
      .trim() || "";

    // 성공 시 JSONB 메타데이터 구조
    const successMetadata = {
      ocr_exit_code: ocrResult.OCRExitCode,
      processing_time_ms: parseInt(ocrResult.ProcessingTimeInMilliseconds) || 0,
      engine_used: 2,
      language_requested: OCR_LANGUAGES,
      text_length: extractedText.length,
      file_url: file_url,
      processed_at: new Date().toISOString(),
      api_response: {
        SearchablePDFURL: ocrResult.SearchablePDFURL || null,
        TextOverlay: null  // 요청하지 않음
      }
    };

    await supabase
      .from("journal_attachments")
      .update({
        ocr_text: extractedText,
        ocr_metadata: successMetadata,
        ocr_status: "completed",
        ocr_processed_at: new Date().toISOString(),
      })
      .eq("attachment_id", attachment_id);

    return {
      attachment_id,
      success: true,
      text: extractedText.substring(0, 100) + "..."
    };

  } catch (error) {
    // API 호출 실패 (타임아웃 포함)
    await supabase.rpc("increment_ocr_error_count", {
      p_attachment_id: attachment_id
    });

    // 네트워크 오류 시 JSONB 메타데이터
    const errorMetadata = {
      error: error.message,
      error_code: error.name === "AbortError" ? "TIMEOUT" : "NETWORK_ERROR",
      raw_response: null,
      attempt: 1,
      processed_at: new Date().toISOString()
    };

    await supabase
      .from("journal_attachments")
      .update({
        ocr_status: "failed",
        ocr_metadata: errorMetadata,
        ocr_processed_at: new Date().toISOString(),
      })
      .eq("attachment_id", attachment_id);

    throw error;
  }
}

function isImageFile(fileName: string, fileType: string | null): boolean {
  const imageExtensions = ["jpg", "jpeg", "png", "gif", "webp", "bmp"];
  const extension = getFileExtension(fileName).toLowerCase();

  if (imageExtensions.includes(extension)) return true;
  if (fileType?.startsWith("image/")) return true;

  return false;
}

function getFileExtension(fileName: string): string {
  const parts = fileName.split(".");
  return parts.length > 1 ? parts[parts.length - 1].toLowerCase() : "jpg";
}
```

### 2.3 Helper RPC 함수

```sql
-- OCR 에러 카운트 증가 함수
CREATE OR REPLACE FUNCTION increment_ocr_error_count(p_attachment_id UUID)
RETURNS VOID AS $$
BEGIN
  UPDATE journal_attachments
  SET
    ocr_error_count = COALESCE(ocr_error_count, 0) + 1,
    ocr_status = CASE
      WHEN COALESCE(ocr_error_count, 0) + 1 >= 3 THEN 'skipped'
      ELSE 'failed'
    END
  WHERE attachment_id = p_attachment_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

### 2.4 환경 변수 설정

Supabase Dashboard > Edge Functions > Settings:

```
OCR_SPACE_API_KEY=730c7f32de88957
```

---

## 작업 3: Cron Job 설정

### 3.1 pg_cron 활성화

Supabase Dashboard > Database > Extensions에서 `pg_cron` 활성화

### 3.2 Cron Job 생성

```sql
-- Cron Job: 매 5분마다 OCR 배치 처리
SELECT cron.schedule(
  'process-ocr-batch',           -- job name
  '*/5 * * * *',                 -- every 5 minutes
  $$
  SELECT net.http_post(
    url := 'https://YOUR_PROJECT_REF.supabase.co/functions/v1/process-ocr-batch',
    headers := jsonb_build_object(
      'Authorization', 'Bearer ' || current_setting('app.settings.service_role_key'),
      'Content-Type', 'application/json'
    ),
    body := '{}'::jsonb
  );
  $$
);

-- 또는 Supabase의 내장 Edge Function 스케줄러 사용
-- (Dashboard > Edge Functions > process-ocr-batch > Schedule)
```

### 3.3 Cron Job 확인

```sql
-- 등록된 Cron Job 확인
SELECT * FROM cron.job;

-- 실행 기록 확인
SELECT * FROM cron.job_run_details
ORDER BY start_time DESC
LIMIT 20;
```

---

## 작업 4: RPC 함수 수정

### 4.1 get_transaction_history_utc 수정

attachments 반환 부분에 새 컬럼 추가:

```sql
-- 기존
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

-- 수정 (새 컬럼 추가)
'attachments', COALESCE(
    (
        SELECT json_agg(
            json_build_object(
                'attachment_id', ja.attachment_id::text,
                'file_url', ja.file_url,
                'file_name', ja.file_name,
                'file_type', ja.file_type,
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

## 작업 5: 모니터링 쿼리

### 5.1 OCR 상태 대시보드

```sql
-- OCR 처리 현황 요약
SELECT
    ocr_status,
    COUNT(*) as count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) as percentage
FROM journal_attachments
GROUP BY ocr_status
ORDER BY count DESC;

-- pending 상태 오래된 것 (처리 안 되는 것 확인)
SELECT
    attachment_id,
    file_name,
    uploaded_at_utc,
    ocr_error_count
FROM journal_attachments
WHERE ocr_status = 'pending'
ORDER BY uploaded_at_utc ASC
LIMIT 20;

-- 최근 OCR 처리 결과
SELECT
    attachment_id,
    file_name,
    ocr_status,
    ocr_processed_at,
    LEFT(ocr_text, 100) as text_preview
FROM journal_attachments
WHERE ocr_processed_at IS NOT NULL
ORDER BY ocr_processed_at DESC
LIMIT 20;

-- 실패한 OCR 확인
SELECT
    attachment_id,
    file_name,
    ocr_error_count,
    ocr_metadata->>'error' as error_message,
    ocr_processed_at
FROM journal_attachments
WHERE ocr_status IN ('failed', 'skipped')
AND ocr_error_count > 0
ORDER BY ocr_processed_at DESC
LIMIT 20;
```

### 5.2 OCR 텍스트 검색 테스트

```sql
-- 특정 텍스트 검색 (예: "커피" 포함된 영수증)
SELECT
    ja.attachment_id,
    ja.file_name,
    je.description as journal_description,
    LEFT(ja.ocr_text, 200) as text_preview
FROM journal_attachments ja
JOIN journal_entries je ON ja.journal_id = je.journal_id
WHERE ja.ocr_text ILIKE '%커피%'
ORDER BY ja.uploaded_at_utc DESC;

-- 전문 검색 (tsvector)
SELECT
    attachment_id,
    file_name,
    ts_headline('simple', ocr_text, plainto_tsquery('simple', 'coffee')) as highlight
FROM journal_attachments
WHERE to_tsvector('simple', COALESCE(ocr_text, '')) @@ plainto_tsquery('simple', 'coffee');
```

---

## OCR.space API 정보

### API 엔드포인트
```
Method: POST
URL: https://api.ocr.space/parse/image
Authentication: None (API Key in header)
Timeout: 30000ms (30초)
```

### API Key (Header)
```
Header Name: apikey
Header Value: 730c7f32de88957
```

### Request Body (Form-Data)

| 파라미터 | 타입 | 값 | 필수 | 설명 |
|----------|------|-----|------|------|
| `url` | Form Data | `{{ image_url }}` | ✅ | Supabase Storage 이미지 URL |
| `language` | Form Data | `eng` | ✅ | OCR 언어 코드 |
| `filetype` | Form Data | `jpg` | ✅ | 파일 확장자 (jpg, png, gif 등) |
| `OCREngine` | Form Data | `2` | ✅ | OCR 엔진 (2 = 영수증 최적) |

### Edge Function에서 사용할 전체 파라미터

```typescript
const formData = new FormData();
formData.append("url", imageUrl);           // Supabase Storage URL
formData.append("language", "eng");         // 언어 (다국어: eng+kor+vie)
formData.append("filetype", "jpg");         // 파일 확장자
formData.append("OCREngine", "2");          // Engine 2 = 영수증 최적
```

### 언어 코드

| 언어 | 코드 | 다국어 조합 |
|------|------|-------------|
| 영어 | `eng` | 기본 |
| 한국어 | `kor` | `eng+kor` |
| 베트남어 | `vie` | `eng+vie` |
| 일본어 | `jpn` | `eng+jpn` |
| 중국어(간체) | `chi_sim` | `eng+chi_sim` |
| 중국어(번체) | `chi_tra` | `eng+chi_tra` |
| **전체 다국어** | - | `eng+kor+vie+jpn+chi_sim` |

### API 제한

- 무료 플랜: 25,000 requests/month
- 파일 크기: 최대 1MB (무료)
- Rate Limit: 500 requests/day (무료)
- Timeout: 30초 권장

---

## JSONB 메타데이터 구조 (ocr_metadata)

### 성공 시 저장할 메타데이터

```jsonb
{
  "ocr_exit_code": 1,
  "processing_time_ms": 1234,
  "engine_used": 2,
  "language_requested": "eng",
  "text_length": 456,
  "file_url": "https://xxx.supabase.co/storage/v1/object/...",
  "processed_at": "2024-12-08T10:30:00.000Z",
  "api_response": {
    "SearchablePDFURL": null,
    "TextOverlay": null
  }
}
```

### 실패 시 저장할 메타데이터

```jsonb
{
  "error": "OCR processing failed",
  "error_code": "E101",
  "raw_response": {
    "IsErroredOnProcessing": true,
    "OCRExitCode": 99,
    "ErrorMessage": ["Unable to recognize text"],
    "ErrorDetails": "..."
  },
  "attempt": 1,
  "processed_at": "2024-12-08T10:30:00.000Z"
}
```

### OCR API 응답 구조 (참고용)

```json
{
  "ParsedResults": [
    {
      "TextOverlay": null,
      "TextOrientation": "0",
      "FileParseExitCode": 1,
      "ParsedText": "추출된 텍스트가 여기에...",
      "ErrorMessage": "",
      "ErrorDetails": ""
    }
  ],
  "OCRExitCode": 1,
  "IsErroredOnProcessing": false,
  "ProcessingTimeInMilliseconds": "1234",
  "SearchablePDFURL": null
}
```

### Exit Code 정의

| OCRExitCode | 의미 |
|-------------|------|
| 1 | 성공 |
| 2 | 부분 성공 (일부 페이지 실패) |
| 3 | 완전 실패 |
| 4 | 치명적 오류 |

---

## 테스트 체크리스트

### 기능 테스트
- [ ] Migration 실행 후 컬럼 생성 확인
- [ ] Edge Function 배포 성공
- [ ] Cron Job 등록 및 실행 확인
- [ ] 새 이미지 업로드 → pending 상태 확인
- [ ] 5분 후 OCR 처리 → completed 상태 확인
- [ ] ocr_text에 텍스트 저장 확인
- [ ] RPC에서 새 필드 반환 확인

### 다국어 테스트
- [ ] 영어 영수증 OCR
- [ ] 한국어 영수증 OCR
- [ ] 베트남어 영수증 OCR
- [ ] 영어+한국어 혼합 OCR

### 에러 처리 테스트
- [ ] 잘못된 이미지 URL → failed 상태
- [ ] PDF 파일 → skipped 상태
- [ ] 3회 실패 → skipped 상태 전환
- [ ] API Key 오류 처리

### 성능 테스트
- [ ] 10개 동시 처리 시간 확인
- [ ] 대용량 이미지 처리 확인

---

## 롤백 계획

문제 발생 시 롤백:

```sql
-- 1. Cron Job 비활성화
SELECT cron.unschedule('process-ocr-batch');

-- 2. 컬럼 삭제 (필요시)
ALTER TABLE journal_attachments
DROP COLUMN IF EXISTS file_type,
DROP COLUMN IF EXISTS file_size_bytes,
DROP COLUMN IF EXISTS ocr_text,
DROP COLUMN IF EXISTS ocr_metadata,
DROP COLUMN IF EXISTS ocr_status,
DROP COLUMN IF EXISTS ocr_processed_at,
DROP COLUMN IF EXISTS ocr_error_count;

-- 3. 인덱스 삭제
DROP INDEX IF EXISTS idx_journal_attachments_ocr_pending;
DROP INDEX IF EXISTS idx_journal_attachments_ocr_text_search;

-- 4. Edge Function 삭제
-- Dashboard에서 수동 삭제
```

---

## 작업 순서 요약

1. **[DB]** Migration 실행 (컬럼 추가)
2. **[DB]** Helper RPC 함수 생성
3. **[Edge]** process-ocr-batch 함수 배포
4. **[Edge]** 환경 변수 설정
5. **[DB]** Cron Job 등록
6. **[DB]** RPC 수정 (get_transaction_history_utc)
7. **[Test]** 테스트 실행
8. **[Monitor]** 모니터링 쿼리로 확인

---

## 문의사항

작업 중 문의: [담당자 연락처]

**작성일**: 2024-12-08
**버전**: 1.0
