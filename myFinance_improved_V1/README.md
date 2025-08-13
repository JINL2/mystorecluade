# 🚀 MyFinance - AI Quick Navigation Hub

> **AI INSTRUCTION**: Start here. This README routes you to the right documentation for your task.

---

## 🎯 What Are You Trying To Do?

```yaml
CREATE_NEW_PAGE:
  read_first: Section 2 (Critical Rules)
  then_go_to: /docs/DOCUMENTATION_INDEX.md → "CREATE A NEW PAGE"

MODIFY_UI:
  read_first: Section 3 (Component Rules)  
  then_go_to: /docs/DOCUMENTATION_INDEX.md → "MODIFY UI/DESIGN"

WORK_WITH_DATA:
  read_first: Section 4 (Data Rules)
  then_go_to: /docs/DOCUMENTATION_INDEX.md → "WORK WITH DATA/BACKEND"

FIX_ROUTES:
  go_directly_to: /docs/DOCUMENTATION_INDEX.md → "FIX ROUTING ISSUES"

UNDERSTAND_PROJECT:
  go_directly_to: /docs/DOCUMENTATION_INDEX.md → "UNDERSTAND THE PROJECT"
```

**📚 COMPLETE DOC MAP**: `/docs/DOCUMENTATION_INDEX.md`

---

## 🔴 2. Critical Project Rules

```yaml
PROJECT:
  location: /Applications/XAMPP/xamppfiles/htdocs/mysite/mystorecluade/myFinance_improved_V1
  framework: Flutter 3.0+
  state: Riverpod (NO setState)
  backend: Supabase ONLY (NO local SQL)

SUPABASE:
  project: Lux
  id: atkekzwgukdvucqntryo
  
ROUTES:
  source: Supabase features table
  rule: MUST match in app_router.dart
  convention: camelCase (no 'Page' suffix)
```

---

## 🎨 3. Component Reuse Rules

```yaml
COMPONENT_HIERARCHY:
  1. CHECK: /lib/presentation/widgets/toss/
  2. THEN: /lib/presentation/widgets/common/  
  3. LAST: Create in /widgets/specific/

NEVER:
  - Create custom when Toss component exists
  - Hardcode colors (use TossColors)
  - Hardcode spacing (use TossSpacing)
  - Use Material widgets directly

DETAILED_GUIDE: /docs/design-system/COMPONENT_REUSE_GUIDE.md
```

---

## 💾 4. Data & State Rules

```yaml
STATE_MANAGEMENT:
  type: Riverpod
  app_state: /READMEAppState.md
  
DATABASE:
  type: Supabase PostgreSQL
  schema: /docs/database/SUPABASE_datastructure.md
  
PATTERN:
  UI → Provider → Repository → Supabase
```

---

## 📍 5. Quick References

### Design Values
```yaml
Colors:
  primary: "#5B5FCF"
  error: "#EF4444"
  success: "#22C55E"

Spacing:
  space1: 4px
  space2: 8px
  space3: 12px
  space4: 16px

Border: 12-16px radius
Shadow: 2-5% opacity
Font: Inter + JetBrains Mono
```

### File Locations
```yaml
Pages: /lib/presentation/pages/[feature]/
Components: /lib/presentation/widgets/
Themes: /lib/core/themes/
Services: /lib/data/services/
Router: /lib/presentation/app/app_router.dart
```

---

## ✅ 6. Pre-Task Checklist

```yaml
BEFORE_CREATING_PAGE:
  □ Check /docs/ROUTE_MAPPING_TABLE.md (exists already?)
  □ Check /widgets/toss/ (components exist?)
  □ Read task-specific docs in DOCUMENTATION_INDEX

BEFORE_MODIFYING:
  □ Check COMPONENT_REUSE_GUIDE (use existing?)
  □ Check THEME_SYSTEM (correct values?)
  
BEFORE_ADDING_ROUTE:
  □ Check ROUTE_MAPPING_TABLE (duplicate?)
  □ Add to BOTH Supabase AND router
```

---

## 🚀 7. Commands

```bash
# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Run app
flutter run
```

---

## 📖 8. Documentation Structure

```
/docs/
├── DOCUMENTATION_INDEX.md      # 🎯 Complete doc navigation
├── ROUTE_MAPPING_TABLE.md      # All routes inventory
├── ROUTE_SYSTEM_GUIDE.md       # Route sync process
│
├── getting-started/
│   ├── PAGE_SETUP_GUIDE.md     # Page creation steps
│   ├── FEATURE_EXAMPLE.md      # Complete example
│   └── PROJECT_STRUCTURE.md    # File organization
│
├── design-system/
│   ├── COMPONENT_REUSE_GUIDE.md # Component selection
│   ├── THEME_SYSTEM.md         # Colors, spacing, fonts
│   └── TOSS_STYLE_ANALYSIS.md  # Design principles
│
├── components/
│   └── TOSS_COMPONENT_LIBRARY.md # Component catalog
│
├── architecture/
│   ├── STATE_MANAGEMENT.md     # Riverpod patterns
│   └── REPOSITORY_PATTERN.md   # Data access
│
└── database/
    └── SUPABASE_datastructure.md # Schema reference
```

---

**🎯 AI WORKFLOW**:
1. Identify task in Section 1
2. Note critical rules for your task
3. Go to `/docs/DOCUMENTATION_INDEX.md`
4. Read ONLY relevant documents
5. Check existing before creating new