# Theme 시스템 가이드

## 색상 (TossColors)

### Primary Colors
- `TossColors.primary` - #4184F3 (메인 파란색)
- `TossColors.primaryLight` - #6BA1F5 (밝은 파란색)
- `TossColors.primaryDark` - #2E69D0 (어두운 파란색)

### Gray Scale
- `TossColors.gray50` - #F9FAFB (배경색)
- `TossColors.gray100` - #F3F4F6
- `TossColors.gray200` - #E5E7EB
- `TossColors.gray300` - #D1D5DB
- `TossColors.gray400` - #9CA3AF
- `TossColors.gray500` - #6B7280
- `TossColors.gray600` - #4B5563
- `TossColors.gray700` - #374151
- `TossColors.gray800` - #1F2937
- `TossColors.gray900` - #111827 (텍스트)

### Semantic Colors
- `TossColors.error` - #F04438 (에러/경고)
- `TossColors.success` - #12B76A (성공/완료)
- `TossColors.warning` - #F79009 (주의)
- `TossColors.info` - #2E90FA (정보)

### Special
- `TossColors.border` - #E5E8EB (테두리)
- `TossColors.divider` - #F2F4F7 (구분선)

## 텍스트 스타일 (TossTextStyles)

- `TossTextStyles.display` - 32px, bold
- `TossTextStyles.h1` - 24px, bold
- `TossTextStyles.h2` - 20px, bold
- `TossTextStyles.h3` - 18px, semibold
- `TossTextStyles.bodyLarge` - 16px, medium
- `TossTextStyles.body` - 14px, regular
- `TossTextStyles.bodySmall` - 13px, regular
- `TossTextStyles.caption` - 12px, regular
- `TossTextStyles.labelLarge` - 14px, semibold
- `TossTextStyles.label` - 12px, medium
- `TossTextStyles.labelSmall` - 11px, medium

## 간격 (TossSpacing)

- `TossSpacing.xs` - 4px
- `TossSpacing.sm` - 8px
- `TossSpacing.md` - 16px (기본)
- `TossSpacing.lg` - 24px
- `TossSpacing.xl` - 32px
- `TossSpacing.xxl` - 48px

## 테두리 반경 (TossBorderRadius)

- `TossBorderRadius.sm` - 4px (작은 버튼)
- `TossBorderRadius.md` - 8px (일반 버튼, 입력)
- `TossBorderRadius.lg` - 12px (카드)
- `TossBorderRadius.xl` - 16px (모달)
- `TossBorderRadius.xxl` - 24px (바텀시트)

## 사용 예시

### 컨테이너 스타일링
```dart
Container(
  decoration: BoxDecoration(
    color: TossColors.gray50,
    border: Border.all(color: TossColors.border),
    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
  ),
  padding: EdgeInsets.all(TossSpacing.md),
  margin: EdgeInsets.symmetric(
    horizontal: TossSpacing.lg,
    vertical: TossSpacing.sm,
  ),
)
```

### 텍스트 스타일링
```dart
Text(
  '제목',
  style: TossTextStyles.h2.copyWith(
    color: TossColors.gray900,
  ),
)
```

### 버튼 스타일링
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: TossColors.primary,
    padding: EdgeInsets.symmetric(
      horizontal: TossSpacing.lg,
      vertical: TossSpacing.md,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
    ),
  ),
  onPressed: () {},
  child: Text(
    '확인',
    style: TossTextStyles.labelLarge.copyWith(color: Colors.white),
  ),
)
```