# 위젯 컴포넌트 가이드

## 위젯 분류 체계

### 📁 `/lib/presentation/widgets/common/`
범용적으로 사용되는 기본 위젯
- `AppLoading` - 로딩 인디케이터
- `AppError` - 에러 표시
- `TossErrorView` - Toss 스타일 에러 뷰

### 📁 `/lib/presentation/widgets/toss/`
Toss 디자인 시스템 컴포넌트
- `TossButton` - 버튼 (primary, secondary, text, danger)
- `TossCard` - 카드 컨테이너
- `TossTextField` - 텍스트 입력
- `TossBottomSheet` - 바텀시트
- `TossCheckbox` - 체크박스
- `TossDropdown` - 드롭다운
- `TossSnackbar` - 스낵바
- `TossLoadingOverlay` - 로딩 오버레이

### 📁 `/lib/presentation/widgets/specific/`
특정 기능에 특화된 위젯
- `RoleFilterChips` - 역할 필터 칩
- `RoleFilterDropdown` - 역할 필터 드롭다운
- `UserRoleListItem` - 사용자 역할 리스트 아이템
- `RoleUpdateModal` - 역할 업데이트 모달

## 위젯 생성 규칙

### 1. 파일명 규칙
- snake_case 사용: `toss_button.dart`
- 기능을 명확히 표현: `employee_card.dart`

### 2. 클래스명 규칙
- PascalCase 사용: `TossButton`
- 위젯 용도 명확히 표현: `EmployeeCard`

### 3. 필수 속성
```dart
class MyWidget extends StatelessWidget {
  // 필수 속성은 required로 표시
  final String title;
  final VoidCallback onTap;
  
  // 선택 속성은 nullable 또는 기본값
  final Color? backgroundColor;
  final bool isLoading;
  
  const MyWidget({
    Key? key,
    required this.title,
    required this.onTap,
    this.backgroundColor,
    this.isLoading = false,
  }) : super(key: key);
}
```

## 위젯 사용 예시

### TossButton 사용
```dart
TossButton(
  text: '저장',
  onPressed: () => _save(),
  type: TossButtonType.primary,
  icon: Icons.save,
  isLoading: _isLoading,
)
```

### TossCard 사용
```dart
TossCard(
  onTap: () => _openDetail(),
  padding: EdgeInsets.all(TossSpacing.md),
  child: Column(
    children: [
      Text('제목', style: TossTextStyles.h3),
      Text('내용', style: TossTextStyles.body),
    ],
  ),
)
```

### TossTextField 사용
```dart
TossTextField(
  label: '이메일',
  hint: 'example@email.com',
  controller: _emailController,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요';
    }
    return null;
  },
  keyboardType: TextInputType.emailAddress,
)
```

## 새 위젯 생성 체크리스트

- [ ] 적절한 폴더 선택 (common/toss/specific)
- [ ] Theme 시스템 사용 (TossColors, TossSpacing 등)
- [ ] const 생성자 사용
- [ ] Key 파라미터 포함
- [ ] required/optional 구분 명확
- [ ] 재사용 가능하도록 설계