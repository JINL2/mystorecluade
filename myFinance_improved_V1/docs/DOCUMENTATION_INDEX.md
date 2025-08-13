# 📚 Documentation Index - AI Navigation Guide

> **AI INSTRUCTION**: This index explains WHAT each document does and WHEN to read it. Match your task to the correct document.

---

## 🎯 Task-to-Document Mapping

### "I need to CREATE A NEW PAGE"
```yaml
READ_IN_ORDER:
  1. /docs/ROUTE_MAPPING_TABLE.md
     WHY: Check if route already exists
     
  2. /docs/getting-started/PAGE_SETUP_GUIDE.md
     WHY: Step-by-step page creation process
     
  3. /docs/design-system/COMPONENT_REUSE_GUIDE.md
     WHY: Use existing components, don't create new
     
  4. /docs/ROUTE_SYSTEM_GUIDE.md
     WHY: Add route to Supabase and router

OPTIONAL_IF_NEEDED:
  - /docs/getting-started/FEATURE_EXAMPLE.md (see complete example)
  - /docs/components/TOSS_COMPONENT_LIBRARY.md (component details)
```

### "I need to MODIFY UI/DESIGN"
```yaml
MUST_READ:
  1. /docs/design-system/COMPONENT_REUSE_GUIDE.md
     WHY: Find existing components to use
     
  2. /docs/design-system/THEME_SYSTEM.md
     WHY: Use correct colors, spacing, typography

REFERENCE:
  - /docs/components/TOSS_COMPONENT_LIBRARY.md (component catalog)
  - /docs/design-system/DESIGN_TOKENS.md (design values)
```

### "I need to WORK WITH DATA/BACKEND"
```yaml
MUST_READ:
  1. /docs/database/SUPABASE_datastructure.md
     WHY: Understand database schema
     
  2. /docs/architecture/STATE_MANAGEMENT.md
     WHY: Manage data with Riverpod
     
  3. /docs/architecture/REPOSITORY_PATTERN.md
     WHY: Implement data access correctly
```

### "I need to FIX ROUTING ISSUES"
```yaml
READ:
  1. /docs/ROUTE_MAPPING_TABLE.md
     WHY: See all route mappings
     
  2. /docs/ROUTE_SYSTEM_GUIDE.md
     WHY: Understand route sync requirements
```

### "I need to UNDERSTAND THE PROJECT"
```yaml
START_WITH:
  1. /docs/architecture/ARCHITECTURE.md
     WHY: Overall system design
     
  2. /docs/getting-started/PROJECT_STRUCTURE.md
     WHY: File organization
     
  3. /docs/getting-started/QUICK_START.md
     WHY: Setup and run project
```

---

## 📂 Document Categories & Purpose

### 🚀 GETTING STARTED
Essential guides for beginning development

| Document | Purpose | When to Read |
|----------|---------|--------------|
| **PAGE_SETUP_GUIDE.md** | Step-by-step page creation | Creating any new page |
| **FEATURE_EXAMPLE.md** | Complete feature implementation example | Need to see full example |
| **PROJECT_STRUCTURE.md** | Understand folder organization | First time in project |
| **QUICK_START.md** | Setup and run the app | Initial setup |

### 🎨 DESIGN SYSTEM
Ensuring UI consistency and coherency

| Document | Purpose | When to Read |
|----------|---------|--------------|
| **COMPONENT_REUSE_GUIDE.md** | Component selection flowchart | Before creating ANY UI |
| **THEME_SYSTEM.md** | Colors, spacing, typography rules | Styling any component |
| **TOSS_STYLE_ANALYSIS.md** | Toss design principles | Understanding design philosophy |
| **DESIGN_TOKENS.md** | All design values reference | Need specific values |

### 🧩 COMPONENTS
Component documentation and catalogs

| Document | Purpose | When to Read |
|----------|---------|--------------|
| **TOSS_COMPONENT_LIBRARY.md** | All Toss components with examples | Finding specific component |
| **COMPONENT_GUIDE.md** | How to build components | Creating new component |
| **COMPONENT_LIBRARY.md** | General component catalog | Browsing available components |

### 🏛 ARCHITECTURE
System design and patterns

| Document | Purpose | When to Read |
|----------|---------|--------------|
| **ARCHITECTURE.md** | Clean architecture overview | Understanding system design |
| **STATE_MANAGEMENT.md** | Riverpod patterns and usage | Managing application state |
| **REPOSITORY_PATTERN.md** | Data access patterns | Implementing data layer |
| **company-store-design.md** | Multi-tenant architecture | Understanding company/store logic |

### 💾 DATABASE
Backend and data structure

| Document | Purpose | When to Read |
|----------|---------|--------------|
| **SUPABASE_datastructure.md** | Complete database schema | Working with any data |

### 🗺 ROUTING
Route management and synchronization

| Document | Purpose | When to Read |
|----------|---------|--------------|
| **ROUTE_MAPPING_TABLE.md** | All routes inventory | Before adding new route |
| **ROUTE_SYSTEM_GUIDE.md** | Route sync process | Adding/fixing routes |

### 🔧 IMPLEMENTATION
Development workflows and patterns

| Document | Purpose | When to Read |
|----------|---------|--------------|
| **PROMPT_TEMPLATE_FOR_NEW_PAGES.md** | AI prompt template | Asking AI for help |
| **COMPLETE_CLICK_TRACKING_INTEGRATION.md** | Analytics implementation | Adding tracking |

---

## 🎯 Quick Decision Tree

```
What are you doing?
│
├─ Creating new feature?
│  ├─ Page? → PAGE_SETUP_GUIDE + ROUTE guides
│  ├─ Component? → COMPONENT_REUSE_GUIDE first
│  └─ Data layer? → REPOSITORY_PATTERN + STATE_MANAGEMENT
│
├─ Fixing something?
│  ├─ Route error? → ROUTE_MAPPING_TABLE + ROUTE_SYSTEM_GUIDE
│  ├─ UI issue? → THEME_SYSTEM + COMPONENT_REUSE_GUIDE
│  └─ Data issue? → SUPABASE_datastructure + STATE_MANAGEMENT
│
├─ Modifying existing?
│  ├─ UI? → COMPONENT_REUSE_GUIDE (use existing!)
│  ├─ Logic? → STATE_MANAGEMENT patterns
│  └─ Data? → SUPABASE_datastructure schema
│
└─ Understanding project?
   ├─ Architecture? → ARCHITECTURE.md
   ├─ Structure? → PROJECT_STRUCTURE.md
   └─ Design? → TOSS_STYLE_ANALYSIS.md
```

---

## 📋 Document Reading Priority

### For ANY Task:
1. **ALWAYS START**: Check if similar thing exists
2. **THEN READ**: Relevant guide for your task
3. **REFERENCE**: Specific details as needed
4. **NEVER SKIP**: Component reuse check

### Priority Levels:
- **🔴 CRITICAL**: Must read before starting
- **🟡 IMPORTANT**: Should read for context
- **🟢 REFERENCE**: Read when needed

---

## 🚨 Common AI Mistakes & Which Doc Fixes It

| Mistake | Fix By Reading |
|---------|----------------|
| Creating duplicate route | ROUTE_MAPPING_TABLE.md |
| Creating custom component | COMPONENT_REUSE_GUIDE.md |
| Hardcoding colors/spacing | THEME_SYSTEM.md |
| Wrong file location | PROJECT_STRUCTURE.md |
| Route not working | ROUTE_SYSTEM_GUIDE.md |
| Using setState | STATE_MANAGEMENT.md |
| Creating new button | TOSS_COMPONENT_LIBRARY.md |

---

**REMEMBER**: 
1. Check existing before creating new
2. Read the right doc for your task
3. Follow patterns exactly
4. Reuse components for coherency