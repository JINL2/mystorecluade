# Invoice List Enhancement - 상품명 & AI Description 추가

## 1. 목적

Invoice 리스트에서 **어떤 상품을 팔았는지 빠르게 식별**하고, 특이 케이스(원화 결제, 다른 은행 등)를 **보조 정보**로 표시.

### 핵심 원칙
- 상품명이 **주요 정보** (필수 표시)
- AI description은 **보조 정보** (있을 때만, 작게)
- 하루 매출 현황을 **한눈에** 파악 가능해야 함

## 2. UI/UX 디자인

### Before
```
16:15    IN2025100021              ₫4,900,000      ✓
         testreal testreal • 1 products
```

### After
```
16:15    IN2025100021              ₫4,900,000      ✓
         루이비통 벨트 외 1건
         💬 원화 50만원 결제, 환율 적용...           ← 작게, 회색, 있을때만
```

### 디자인 규칙
| 요소 | 스타일 |
|-----|-------|
| 상품명 | `TossTextStyles.caption`, `gray600`, 1줄 |
| AI description | `fontSize: 11`, `gray400`, 1줄, maxLines: 1 |
| AI 아이콘 | `Icons.auto_awesome`, 12px, `gray400` |

## 3. 데이터 구조

### 3.1 RPC 추가 필드

`get_invoice_page_v2` 응답에 추가:

```json
{
  "invoices": [
    {
      // ... 기존 필드 ...
      "items_summary": {
        "item_count": 2,
        "total_quantity": 3,
        "first_product_name": "루이비통 벨트"  // NEW
      },
      "ai_description": "원화 50만원 결제, 환율 1:25 적용"  // NEW (nullable)
    }
  ]
}
```

### 3.2 성능 고려사항
- `first_product_name`: 이미 인덱스 있음 (`idx_inventory_invoice_items_invoice_id`)
- `ai_description`: 인덱스 추가 필요 (`idx_journal_entries_invoice_id`)
- 총 추가 시간: ~19ms (체감 불가)

## 4. 수정 파일 목록

### RPC Migration
| 파일 | 변경 내용 |
|-----|---------|
| `supabase/migrations/20251218_enhance_invoice_page_v2.sql` | first_product_name, ai_description 추가 |

### Flutter - Domain Layer
| 파일 | 변경 내용 |
|-----|---------|
| `domain/entities/items_summary.dart` | `firstProductName` 필드 추가 |
| `domain/entities/invoice.dart` | `aiDescription` 필드 추가 |

### Flutter - Data Layer
| 파일 | 변경 내용 |
|-----|---------|
| `data/models/invoice_model.dart` | 새 필드 파싱 |

### Flutter - Presentation Layer
| 파일 | 변경 내용 |
|-----|---------|
| `presentation/widgets/invoice_list/invoice_list_item.dart` | UI 업데이트 |

## 5. 표시 로직

### 상품명 표시
```dart
String get productDisplayName {
  final name = itemsSummary.firstProductName;
  if (name == null || name.isEmpty) return '${itemsSummary.itemCount} products';

  final otherCount = itemsSummary.itemCount - 1;
  if (otherCount > 0) {
    return '$name 외 $otherCount건';
  }
  return name;
}
```

### AI Description 표시 조건
- `aiDescription != null && aiDescription!.isNotEmpty`
- 최대 1줄, overflow: ellipsis

## 6. 인덱스 추가 (권장)

```sql
CREATE INDEX idx_journal_entries_invoice_id
ON journal_entries(invoice_id)
WHERE invoice_id IS NOT NULL AND is_deleted = false;
```

## 7. 테스트 체크리스트

- [ ] 상품 1개 invoice - 상품명만 표시
- [ ] 상품 N개 invoice - "상품명 외 N-1건" 표시
- [ ] AI description 있는 invoice - 아이콘 + 텍스트 표시
- [ ] AI description 없는 invoice - 해당 줄 숨김
- [ ] 성능 체크 - 로딩 속도 체감 변화 없음
