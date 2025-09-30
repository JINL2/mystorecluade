# Migration Rules & Guidelines

## 🚫 STRICT RULES - NO EXCEPTIONS

### 1. NO VERSION FILES
```
❌ FORBIDDEN:
- cash_tab_v2.dart
- bank_tab_v3.dart
- cash_ending_page_backup.dart
- denomination_input_old.dart
- anything_test.dart
- anything_temp.dart

✅ CORRECT:
- Direct edits to existing files
- Use git for version control
- Use feature flags for gradual rollout
```

### 2. File Management Rules

#### DO NOT CREATE:
- Test files for trying things out
- Backup copies with suffixes (v1, v2, old, new, backup, temp)
- Duplicate files with slight variations
- Experimental files

#### INSTEAD DO:
- Edit files directly in place
- Use git branches for experiments
- Use git commits for backups
- Use feature flags for A/B testing

### 3. Clean Migration Approach

```dart
// ❌ WRONG - Creating multiple versions
cash_tab.dart
cash_tab_v2.dart
cash_tab_final.dart
cash_tab_working.dart

// ✅ RIGHT - Single file, git history
cash_tab.dart (edit directly)
git commit -m "Refactor cash tab structure"
```

### 4. Feature Flag Pattern (When Needed)

```dart
// Instead of creating new files, use feature flags
class CashEndingPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useRefactoredCode = ref.watch(featureFlagProvider('use_refactored_cash'));
    
    if (useRefactoredCode) {
      return _buildRefactoredVersion(); // New code in SAME file
    } else {
      return _buildOriginalVersion(); // Old code in SAME file
    }
  }
}
```

### 5. Git Workflow for Safety

```bash
# BEFORE making changes
git checkout -b refactor/cash-ending
git status

# DURING changes - commit frequently
git add .
git commit -m "Extract denomination logic"

# IF something breaks
git reset --hard HEAD~1  # Undo last commit

# WHEN complete
git checkout main
git merge refactor/cash-ending
```

## 📋 Migration Checklist with Rules

### Before Starting
- [ ] Create git branch (NOT test files)
- [ ] Verify all tests passing
- [ ] Document current behavior

### During Migration
- [ ] Edit files directly (NO v2, v3 files)
- [ ] Commit after each successful change
- [ ] Use existing file structure
- [ ] NO temporary test files

### After Migration
- [ ] Delete any accidentally created test files
- [ ] Ensure only production files remain
- [ ] Clean git history if needed

## 🎯 File Naming Standards

### Allowed File Names
```
✅ cash_tab.dart
✅ bank_tab.dart
✅ vault_tab.dart
✅ denomination_input.dart
✅ currency_selector.dart
```

### Forbidden Patterns
```
❌ *_v2.dart
❌ *_v3.dart
❌ *_old.dart
❌ *_new.dart
❌ *_backup.dart
❌ *_temp.dart
❌ *_test.dart (except in /test folder)
❌ *_working.dart
❌ *_final.dart
❌ *_copy.dart
```

## 🔧 Correct Migration Example

### Step 1: Start with existing file
```dart
// lib/presentation/pages/cash_ending/presentation/tabs/cash_tab/cash_tab.dart
// This file already exists - we EDIT it, not create new
```

### Step 2: Refactor in place
```dart
// BEFORE (in cash_tab.dart)
class CashTab extends ConsumerStatefulWidget {
  // Old 1000-line implementation
}

// AFTER (in SAME cash_tab.dart file)
class CashTab extends ConsumerStatefulWidget {
  // New clean 200-line implementation
}
```

### Step 3: Use git for versioning
```bash
git add lib/presentation/pages/cash_ending/presentation/tabs/cash_tab/cash_tab.dart
git commit -m "Refactor cash tab to clean architecture"
```

## ⚠️ Cleanup Commands

If test files were accidentally created:
```bash
# Find and remove version files
find . -name "*_v[0-9].dart" -delete
find . -name "*_backup.dart" -delete
find . -name "*_old.dart" -delete
find . -name "*_temp.dart" -delete

# Keep only production files
git clean -fd  # Remove untracked files (careful!)
```

## 📌 Summary

### The Golden Rule
**"One file, one purpose, no versions"**

- Each component has ONE file
- Git manages versions, not file names
- Direct edits, no test copies
- Feature flags for gradual changes
- Clean, professional codebase

### Remember
- Version control is what git is for
- Test files belong in /test folder only
- Production code stays clean
- No temporary files in production folders

---

**ENFORCEMENT**: Any PR with version files (v2, v3, backup, temp) will be rejected.