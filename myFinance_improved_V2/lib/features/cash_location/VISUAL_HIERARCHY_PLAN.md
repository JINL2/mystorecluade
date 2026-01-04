# Cash Location Visual Hierarchy 수정 계획서

## 1. 문제 정의

현재 Balance Card(Overview)와 Transaction List(Detail)의 폰트 크기가 역전되어 있음.

| 구분 | 현재 상태 | 문제점 |
|------|-----------|--------|
| Balance Card (Overview) | 14px (`body`, `bodyMedium`) | 너무 작음 |
| Transaction List (Detail) | 16px (`subtitle`) | Overview보다 큼 |

**디자인 원칙 위반**: Overview(요약)는 Detail(상세)보다 시각적으로 더 강조되어야 함.

---

## 2. 수정 방향

### 목표
- Balance Card: 14px → 16px (더 크게, 강조)
- Transaction List: 16px → 14px (더 작게, 덜 강조)

### 사용할 TossTextStyles
| 용도 | 현재 스타일 | 변경 스타일 |
|------|-------------|-------------|
| Balance Card 금액 | `body` (14px, w400) | `subtitle` (16px, w600) |
| Balance Card 라벨 | `body` (14px, w400) | `bodyMedium` (14px, w600) |
| Transaction 제목 | `subtitle` (16px, w600) | `bodyMedium` (14px, w600) |
| Transaction 금액 | `bodyMedium` (14px, w600) | `body` (14px, w400) |

---

## 3. 수정 대상 파일

### 3.1 Balance Card 수정 (더 크게)

**파일**: `account_balance_card_widget.dart`

```dart
// 변경 전
_buildBalanceRow(
  'Total Journal',
  formatCurrency(totalJournal.toDouble(), currencySymbol),
);

Widget _buildBalanceRow(String label, String amount) {
  return Row(
    children: [
      Text(label, style: TossTextStyles.body.copyWith(color: TossColors.gray700)),
      Text(amount, style: TossTextStyles.body.copyWith(color: TossColors.gray900)),
    ],
  );
}

// 변경 후
Widget _buildBalanceRow(String label, String amount) {
  return Row(
    children: [
      Text(label, style: TossTextStyles.bodyMedium.copyWith(color: TossColors.gray700)),
      Text(amount, style: TossTextStyles.subtitle.copyWith(color: TossColors.gray900)),
    ],
  );
}
```

**Error 행 수정**:
```dart
// 변경 전
Text('Error', style: TossTextStyles.body.copyWith(color: TossColors.gray900)),
Text(amount, style: TossTextStyles.bodyMedium.copyWith(color: TossColors.error)),

// 변경 후
Text('Error', style: TossTextStyles.bodyMedium.copyWith(color: TossColors.gray900)),
Text(amount, style: TossTextStyles.subtitle.copyWith(color: TossColors.error)),
```

### 3.2 Transaction List 수정 (더 작게)

**파일**: `journal_flow_item.dart`

```dart
// 변경 전
Text(
  getJournalDisplayText(flow),
  style: TossTextStyles.subtitle.copyWith(color: TossColors.gray900),
);

// 변경 후
Text(
  getJournalDisplayText(flow),
  style: TossTextStyles.bodyMedium.copyWith(color: TossColors.gray900),
);
```

**파일**: `actual_flow_item.dart` (Real 탭도 동일하게 수정 필요)

```dart
// 변경 전
Text(title, style: TossTextStyles.subtitle.copyWith(color: TossColors.gray900));
Text(amount, style: TossTextStyles.subtitle.copyWith(color: ...));

// 변경 후
Text(title, style: TossTextStyles.bodyMedium.copyWith(color: TossColors.gray900));
Text(amount, style: TossTextStyles.body.copyWith(color: ...));
```

---

## 4. 변경 전후 비교

### Balance Card (Overview)
| 요소 | 변경 전 | 변경 후 |
|------|---------|---------|
| "Balance" 타이틀 | bodyMedium (14px, w600) | bodyMedium (14px, w600) - 유지 |
| "Total Journal" 라벨 | body (14px, w400) | bodyMedium (14px, w600) |
| 금액 값 | body (14px, w400) | **subtitle (16px, w600)** |
| "Error" 라벨 | body (14px, w400) | bodyMedium (14px, w600) |
| Error 금액 | bodyMedium (14px, w600) | **subtitle (16px, w600)** |

### Transaction List (Detail)
| 요소 | 변경 전 | 변경 후 |
|------|---------|---------|
| 거래 제목 | subtitle (16px, w600) | **bodyMedium (14px, w600)** |
| 거래 금액 | bodyMedium (14px, w600) | body (14px, w400) |
| 잔액 | bodySmall (12px) | bodySmall (12px) - 유지 |

---

## 5. 롤백 방법

### 방법 1: Git Stash (권장)
```bash
# 수정 전에 실행
git stash push -m "before visual hierarchy change"

# 롤백하려면
git stash pop
```

### 방법 2: Git Checkout (특정 파일만)
```bash
# 특정 파일만 롤백
git checkout HEAD -- lib/features/cash_location/presentation/widgets/account_balance_card_widget.dart
git checkout HEAD -- lib/features/cash_location/presentation/widgets/journal_flow_item.dart
```

### 방법 3: 전체 롤백
```bash
# 모든 변경사항 되돌리기
git checkout HEAD -- lib/features/cash_location/
```

---

## 6. 테스트 체크리스트

- [ ] Balance Card 금액이 16px로 표시되는지 확인
- [ ] Transaction List 제목이 14px로 표시되는지 확인
- [ ] Journal 탭에서 정상 동작 확인
- [ ] Real 탭에서 정상 동작 확인
- [ ] 다크모드에서 색상 정상 확인
- [ ] 다양한 화면 크기에서 레이아웃 확인

---

## 7. 실행 순서

1. `git stash push -m "before visual hierarchy change"` 실행
2. `account_balance_card_widget.dart` 수정
3. `journal_flow_item.dart` 수정
4. `actual_flow_item.dart` 수정 (있다면)
5. 앱 실행 및 테스트
6. 문제 발생시 `git stash pop`으로 롤백

---

## 8. 예상 결과

수정 후 화면 계층구조:
```
┌─────────────────────────────────────┐
│ Balance Card (Overview)             │
│   금액: 16px, bold ← 강조           │
│   라벨: 14px, semi-bold             │
└─────────────────────────────────────┘
          ↓ 시각적 계층
┌─────────────────────────────────────┐
│ Transaction List (Detail)           │
│   제목: 14px, semi-bold ← 덜 강조   │
│   금액: 14px, regular               │
│   부가정보: 12px                     │
└─────────────────────────────────────┘
```

이 구조가 일반적인 UI 디자인 원칙에 부합함.
