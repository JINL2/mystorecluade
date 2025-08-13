# 📄 Page Setup Guide - Complete Process

> **PURPOSE**: Step-by-step guide to create a new page. Follow EXACTLY in order.

---

## 🚨 CRITICAL: Before You Start

```yaml
CHECK_FIRST:
  1. Route exists? → Check /docs/ROUTE_MAPPING_TABLE.md
  2. Similar page exists? → Check /lib/presentation/pages/
  3. Components exist? → Check /lib/presentation/widgets/toss/
  
IF_ALL_NO: Proceed with this guide
```

---

## 📋 Complete Page Creation Process

### 🔴 Step 1: Register Route (MANDATORY)

#### 1A. Add to Supabase
```sql
-- Run this in Supabase SQL editor
INSERT INTO features (
  feature_id,
  feature_name,
  route,
  icon,
  category_id
) VALUES (
  gen_random_uuid(),
  'Your Feature Name',     -- Display name in Korean/English
  'yourFeatureRoute',      -- camelCase, no 'Page' suffix
  'https://icon-url.png',  -- Icon URL
  'category-uuid-here'     -- Get from categories table
);
```

#### 1B. Add to Router
```dart
// File: /lib/presentation/app/app_router.dart

// 1. Add import at top
import '../pages/your_feature/your_feature_page.dart';

// 2. Add route in routes array (find the right section)
GoRoute(
  path: 'yourFeatureRoute',  // MUST match Supabase exactly
  builder: (context, state) => const YourFeaturePage(),
),
```

---

### 📁 Step 2: Create Folder Structure

```bash
# Create these folders
/lib/presentation/pages/your_feature/
├── your_feature_page.dart        # Main page
├── models/                        # If needed
│   └── your_feature_models.dart
├── providers/                     # State management
│   └── your_feature_providers.dart
└── widgets/                       # Page-specific widgets
    └── your_feature_widgets.dart
```

---

### 📝 Step 3: Create Main Page File

```dart
// File: /lib/presentation/pages/your_feature/your_feature_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../widgets/common/toss_loading_view.dart';
import '../../widgets/common/toss_error_view.dart';
import '../../widgets/common/toss_empty_view.dart';
import 'providers/your_feature_providers.dart';

class YourFeaturePage extends ConsumerWidget {
  const YourFeaturePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch your data provider
    final dataAsync = ref.watch(yourFeatureProvider);
    
    return Scaffold(
      backgroundColor: TossColors.background,
      appBar: AppBar(
        title: Text('페이지 제목'),  // Korean title
        backgroundColor: TossColors.background,
        foregroundColor: TossColors.gray900,
        elevation: 0,
      ),
      body: dataAsync.when(
        data: (data) => _buildContent(context, ref, data),
        loading: () => const TossLoadingView(),
        error: (error, stack) => TossErrorView(
          message: error.toString(),
          onRetry: () => ref.refresh(yourFeatureProvider),
        ),
      ),
    );
  }
  
  Widget _buildContent(BuildContext context, WidgetRef ref, List<dynamic> data) {
    if (data.isEmpty) {
      return const TossEmptyView(
        message: '데이터가 없습니다',
        icon: Icons.inbox_outlined,
      );
    }
    
    return ListView.builder(
      padding: EdgeInsets.all(TossSpacing.space4),
      itemCount: data.length,
      itemBuilder: (context, index) {
        // Use Toss components here
        return Container(); // Replace with actual content
      },
    );
  }
}
```

---

### 💾 Step 4: Create Provider

```dart
// File: /lib/presentation/pages/your_feature/providers/your_feature_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../providers/app_state_provider.dart';

part 'your_feature_providers.g.dart';

@riverpod
class YourFeature extends _$YourFeature {
  @override
  Future<List<dynamic>> build() async {
    // Get Supabase client
    final supabase = Supabase.instance.client;
    
    // Get current company/store from app state
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;
    
    // Fetch data from Supabase
    try {
      final response = await supabase
          .from('your_table')
          .select()
          .eq('company_id', companyId)
          .eq('store_id', storeId);
      
      return response as List<dynamic>;
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
  
  // Add methods for CRUD operations
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
  
  Future<void> create(Map<String, dynamic> data) async {
    final supabase = Supabase.instance.client;
    await supabase.from('your_table').insert(data);
    ref.invalidateSelf();
  }
  
  Future<void> update(String id, Map<String, dynamic> data) async {
    final supabase = Supabase.instance.client;
    await supabase.from('your_table').update(data).eq('id', id);
    ref.invalidateSelf();
  }
  
  Future<void> delete(String id) async {
    final supabase = Supabase.instance.client;
    await supabase.from('your_table').delete().eq('id', id);
    ref.invalidateSelf();
  }
}
```

---

### 🧩 Step 5: Use Existing Components

#### ALWAYS Check These First:

```dart
// 1. Toss Components (USE THESE FIRST)
import '../../widgets/toss/toss_primary_button.dart';
import '../../widgets/toss/toss_card.dart';
import '../../widgets/toss/toss_text_field.dart';
import '../../widgets/toss/toss_bottom_sheet.dart';
import '../../widgets/toss/toss_dropdown.dart';

// 2. Common Components (USE IF TOSS DOESN'T HAVE)
import '../../widgets/common/toss_app_bar.dart';
import '../../widgets/common/toss_loading_view.dart';
import '../../widgets/common/toss_error_view.dart';
import '../../widgets/common/toss_empty_view.dart';

// 3. ONLY create new if absolutely necessary
// Create in: /lib/presentation/widgets/specific/your_feature/
```

---

### ⚙️ Step 6: Generate Code

```bash
# After creating providers with @riverpod annotation
flutter pub run build_runner build --delete-conflicting-outputs
```

---

### ✅ Step 7: Test Your Page

```yaml
TEST_CHECKLIST:
  □ Feature appears in homepage menu?
  □ Click navigates to your page?
  □ Data loads correctly?
  □ Loading state shows?
  □ Error state works (disconnect internet)?
  □ Empty state shows (no data)?
  □ All buttons/interactions work?
  □ Uses Toss components (not custom)?
  □ Follows theme colors/spacing?
```

---

## 🎨 UI Patterns to Follow

### List Page Pattern
```dart
ListView.separated(
  padding: EdgeInsets.all(TossSpacing.space4),
  itemBuilder: (context, index) => TossCard(
    child: YourListItem(data[index]),
    onTap: () => navigateToDetail(data[index]),
  ),
  separatorBuilder: (_, __) => SizedBox(height: TossSpacing.space2),
  itemCount: data.length,
)
```

### Form Page Pattern
```dart
Column(
  children: [
    TossTextField(
      label: '이름',
      controller: _nameController,
    ),
    SizedBox(height: TossSpacing.space4),
    TossDropdown(
      label: '선택',
      items: options,
      onChanged: (value) {},
    ),
    Spacer(),
    TossPrimaryButton(
      text: '저장',
      onPressed: _handleSubmit,
    ),
  ],
)
```

### Detail Page Pattern
```dart
SingleChildScrollView(
  padding: EdgeInsets.all(TossSpacing.space4),
  child: Column(
    children: [
      TossCard(child: MainInfo()),
      SizedBox(height: TossSpacing.space3),
      TossCard(child: DetailInfo()),
      SizedBox(height: TossSpacing.space6),
      TossPrimaryButton(text: '수정'),
    ],
  ),
)
```

---

## 🚫 Common Mistakes

| Mistake | Solution |
|---------|----------|
| Route not in Supabase | Add to features table first |
| Route mismatch | Ensure exact match (case-sensitive) |
| Custom button created | Use TossPrimaryButton |
| Hardcoded colors | Use TossColors.primary |
| Hardcoded spacing | Use TossSpacing.space4 |
| setState used | Use Riverpod provider |
| No error handling | Add error state in .when() |

---

## 📋 Final Checklist

```yaml
BEFORE_COMMITTING:
  □ Route in Supabase features table?
  □ Route in app_router.dart?
  □ Routes match exactly?
  □ Import added in router?
  □ Using Toss components?
  □ No hardcoded values?
  □ All states handled (loading/error/empty)?
  □ Provider uses Supabase?
  □ Code generated (build_runner)?
  □ Page tested and working?
```

---

**REMEMBER**: Follow this guide EXACTLY. Don't skip steps. Check existing components first.