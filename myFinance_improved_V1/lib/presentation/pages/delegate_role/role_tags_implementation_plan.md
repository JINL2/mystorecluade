# Role Tags Implementation Plan

## 📊 데이터베이스 현황 분석

### 1. 테이블 구조
- **roles 테이블**
  - `tags` 컬럼: JSONB 타입 (이미 존재)
  - `description` 컬럼: TEXT 타입
  - `icon` 컬럼: TEXT 타입 (사용 가능)

### 2. 현재 tags 데이터 상태
```json
// 현재 잘못된 형식 (dfgghh role)
{"tag1": "[Critical, Support, Management, Operations, Temporary]"}

// 수정 필요한 올바른 형식
["Critical", "Support", "Management", "Operations", "Temporary"]
```

### 3. 기존 RPC 함수
- `create_role`: 역할 생성
- `update_role`: 역할 업데이트
- `delete_role`: 역할 삭제

---

## 🎯 구현 목표

1. **역할 생성 시 태그 추가**
2. **역할 목록에서 description 대신 태그 표시**
3. **역할 수정 시 태그 편집**
4. **태그 데이터 형식 표준화**

---

## 🔧 구현 계획

### Phase 1: 데이터베이스 상호작용 (RPC 함수)

#### A. 새로운 RPC 함수 필요성 검토
**결론: 새 RPC 함수 불필요**
- 기존 Supabase SDK의 INSERT/UPDATE로 충분
- JSONB 타입은 자동으로 변환됨

#### B. 데이터 정리 (한 번만 실행)
```sql
-- 잘못된 형식의 태그 수정
UPDATE roles 
SET tags = '["Critical", "Support", "Management", "Operations", "Temporary"]'::jsonb
WHERE role_id = 'd4e9ed36-68e3-48a8-a481-2103888252cc';

-- NULL 값을 빈 배열로 초기화
UPDATE roles 
SET tags = '[]'::jsonb 
WHERE tags IS NULL;
```

### Phase 2: Provider 함수 수정

#### A. delegate_role_providers.dart

##### 1. createRole 함수 수정
```dart
// 파라미터 추가
Future<String> createRole({
  required String companyId,
  required String roleName,
  String? description,
  required String roleType,
  List<String>? tags,  // 추가
})

// 구현
await supabase.from('roles').insert({
  'role_name': roleName,
  'role_type': roleType,
  'company_id': companyId,
  'description': description,
  'tags': tags ?? [],  // JSONB로 자동 변환
  'is_deletable': true,
});
```

##### 2. updateRoleDetails 함수 수정
```dart
Future<void> updateRoleDetails({
  required String roleId,
  required String roleName,
  String? description,
  List<String>? tags,  // 추가
})

await supabase.from('roles').update({
  'role_name': roleName,
  'description': description,
  'tags': tags,
  'updated_at': DateTime.now().toIso8601String(),
}).eq('role_id', roleId);
```

##### 3. allCompanyRolesProvider 수정
```dart
// 반환 데이터에 tags 추가
{
  'roleId': role['role_id'],
  'roleName': role['role_name'],
  'tags': _parseTags(role['tags']),  // 추가
  'description': role['description'],
  'permissions': permissions,
  'memberCount': memberCount,
  'canEdit': true,
  'canDelegate': true,
}

// 태그 파싱 헬퍼 함수
List<String> _parseTags(dynamic tagsData) {
  if (tagsData == null) return [];
  if (tagsData is List) {
    return tagsData.map((e) => e.toString()).toList();
  }
  // 잘못된 형식 처리
  if (tagsData is Map && tagsData.containsKey('tag1')) {
    // 레거시 데이터 처리
    String tagString = tagsData['tag1'].toString();
    tagString = tagString.replaceAll('[', '').replaceAll(']', '');
    return tagString.split(',').map((e) => e.trim()).toList();
  }
  return [];
}
```

### Phase 3: UI 구현

#### A. delegate_role_page.dart 수정

##### 1. Create Role 모달에 태그 입력 추가
```dart
class _CreateRoleBottomSheetState {
  List<String> _selectedTags = [];
  
  // 미리 정의된 태그
  static const List<String> _suggestedTags = [
    'Critical', 'Support', 'Management', 'Operations', 
    'Temporary', 'Finance', 'Sales', 'Marketing',
    'Technical', 'Customer Service', 'Admin', 'Restricted'
  ];
  
  // 태그 색상 매핑
  static final Map<String, Color> _tagColors = {
    'Critical': TossColors.error,
    'Support': TossColors.info,
    'Management': TossColors.primary,
    'Operations': TossColors.success,
    'Temporary': TossColors.warning,
    // ...
  };
}
```

##### 2. Team Roles 리스트에서 태그 표시
```dart
Widget _buildRoleItem(Map<String, dynamic> role) {
  // description 대신 tags 표시
  subtitle: role['tags'] != null && (role['tags'] as List).isNotEmpty
    ? _buildTagsRow(role['tags'])
    : Text('Custom role with specific permissions'),
}

Widget _buildTagsRow(List<dynamic> tags) {
  final tagList = tags.take(3).toList();  // 최대 3개만 표시
  final remaining = tags.length - 3;
  
  return Wrap(
    spacing: 4,
    children: [
      ...tagList.map((tag) => Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: _getTagColor(tag).withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: _getTagColor(tag).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          tag,
          style: TossTextStyles.caption.copyWith(
            color: _getTagColor(tag),
            fontWeight: FontWeight.w500,
          ),
        ),
      )),
      if (remaining > 0)
        Text(
          '+$remaining',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
          ),
        ),
    ],
  );
}
```

#### B. role_management_sheet.dart 수정

##### Details 탭에 태그 편집 기능 추가
```dart
Widget _buildDetailsTab() {
  return Column(
    children: [
      // Role name
      // ...
      
      // Tags section
      Text('Tags'),
      _buildTagsEditor(),
      
      // Description (optional)
      // ...
    ],
  );
}

Widget _buildTagsEditor() {
  return Column(
    children: [
      Wrap(
        children: [
          ..._selectedTags.map((tag) => Chip(
            label: Text(tag),
            deleteIcon: Icon(Icons.close, size: 16),
            onDeleted: widget.canEdit ? () => _removeTag(tag) : null,
          )),
          if (widget.canEdit && _selectedTags.length < 5)
            ActionChip(
              label: Text('+ Add'),
              onPressed: _showAddTagDialog,
            ),
        ],
      ),
    ],
  );
}
```

### Phase 4: 데이터 검증

#### A. 태그 제약사항
```dart
class TagValidator {
  static const int MAX_TAGS = 5;
  static const int MAX_TAG_LENGTH = 20;
  
  static bool isValid(String tag) {
    return tag.isNotEmpty && 
           tag.length <= MAX_TAG_LENGTH &&
           !tag.contains(',') &&
           !tag.contains('"');
  }
  
  static String? validateTag(String tag) {
    if (tag.isEmpty) return 'Tag cannot be empty';
    if (tag.length > MAX_TAG_LENGTH) return 'Tag too long (max 20 chars)';
    if (tag.contains(',')) return 'Tag cannot contain commas';
    if (tag.contains('"')) return 'Tag cannot contain quotes';
    return null;
  }
}
```

#### B. 에러 처리
```dart
try {
  await createRole(
    companyId: companyId,
    roleName: roleName,
    tags: _selectedTags,
  );
} catch (e) {
  // JSONB 변환 실패 등 처리
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Failed to save tags: $e')),
  );
}
```

---

## 📝 구현 순서

### Step 1: 데이터 정리 (5분)
1. 기존 잘못된 태그 데이터 수정
2. NULL 값을 빈 배열로 초기화

### Step 2: Provider 수정 (30분)
1. `delegate_role_providers.dart` 수정
   - createRole에 tags 파라미터 추가
   - updateRoleDetails에 tags 파라미터 추가
   - allCompanyRolesProvider에 tags 반환 추가
   - 태그 파싱 헬퍼 함수 추가

### Step 3: Create Role UI (45분)
1. `delegate_role_page.dart`의 `_CreateRoleBottomSheet` 수정
   - 태그 입력 UI 추가
   - 태그 선택/삭제 기능
   - 제안 태그 표시

### Step 4: Team Roles 리스트 UI (30분)
1. `delegate_role_page.dart`의 `_buildRoleItem` 수정
   - description 대신 tags 표시
   - 태그 칩 디자인
   - 색상 매핑

### Step 5: Role Management UI (30분)
1. `role_management_sheet.dart`의 Details 탭 수정
   - 태그 편집 기능
   - 태그 저장

### Step 6: 테스트 (30분)
1. 역할 생성 테스트
2. 태그 표시 테스트
3. 태그 수정 테스트
4. 에러 케이스 테스트

---

## 🎨 UI/UX 디자인

디자인은 항상  /Applications/XAMPP/xamppfiles/htdocs/mysite/mystorecluade/myFinance_improved_V1/README.md 를 읽고 일관된 디자인 사용. 절대 하드코딩된 디자인 사용 금지 



## ⚠️ 주의사항

1. **데이터 마이그레이션**
   - 기존 데이터 손실 방지
   - 백업 후 진행

2. **JSONB 타입 처리**
   - Dart List<String> ↔ PostgreSQL JSONB 자동 변환
   - 잘못된 형식 방어 코드 필요

3. **태그 제한**
   - 최대 20자
   - 특수문자 제한

4. **성능 고려**
   - 태그 검색은 현재 미구현
   - 향후 인덱스 추가 고려

---


## ✅ 체크리스트

- [ ] 데이터베이스 태그 데이터 정리
- [ ] Provider 함수 수정
- [ ] Create Role UI 구현
- [ ] Team Roles 리스트 UI 구현
- [ ] Role Management UI 구현
- [ ] 태그 검증 로직 구현
- [ ] 에러 처리 구현
- [ ] 테스트 완료
- [ ] 문서 업데이트
