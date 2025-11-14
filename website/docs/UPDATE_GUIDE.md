# Feature Update Guide

> **Purpose**: Enforce dependency rules and ensure correct modification order when updating existing features.

---

## 🔒 Core Rules (Absolute Rules!)

### 1. Layer Responsibilities

```
domain/       → Business rules definition only (entities, validators, repository interfaces)
data/         → RPC calls, data transformation only (datasources, repositories, models)
presentation/ → UI rendering only (pages, components, hooks)
```

### 2. Forbidden Practices (Never Violate!)

```
❌ Direct RPC calls in presentation layer
   → RPC calls must ONLY go through data/datasources

❌ Direct supabase usage in presentation layer
   → Data access must ONLY go through repositories

❌ useState for feature-specific state in components
   → Use Zustand provider in presentation/providers/ instead

❌ Direct provider usage in components
   → Must use custom hook wrapper for selector optimization

❌ Repository calls in presentation/hooks/
   → Repository calls must be in presentation/providers/ actions

❌ Importing data layer in domain layer
   → Violates dependency direction

❌ Importing presentation layer in domain layer
   → Violates dependency direction

❌ Importing presentation layer in data layer
   → Violates dependency direction
```

### 3. Dependency Direction (Unidirectional Only)

```
presentation → data → domain

✅ Allowed:
- presentation → domain (use entities, validators)
- presentation → data (call repositories)
- data → domain (implement entities, interfaces)

❌ Forbidden:
- domain → data
- domain → presentation
- data → presentation
```

---

## 📋 Update Scenarios Guide

### Scenario 1: Adding New State Management (Zustand Provider)

**Order (MUST follow this sequence!):**

```
1️⃣ presentation/providers/states/xxx_state.ts
   → Define state interface

   export interface XxxState {
     // State properties
     data: XxxEntity[];
     loading: boolean;
     error: string | null;

     // Actions
     setData: (data: XxxEntity[]) => void;
     loadData: () => Promise<void>;
     reset: () => void;
   }

2️⃣ presentation/providers/xxx_provider.ts
   → Create Zustand provider

   import { create } from 'zustand';
   import { XxxState } from './states/xxx_state';
   import { XxxRepositoryImpl } from '../../data/repositories/XxxRepositoryImpl';

   const repository = new XxxRepositoryImpl();

   export const useXxxStore = create<XxxState>((set, get) => ({
     // Initial state
     data: [],
     loading: false,
     error: null,

     // Actions
     setData: (data) => set({ data }),

     loadData: async () => {
       set({ loading: true, error: null });
       try {
         const result = await repository.getData();
         set({ data: result, loading: false });
       } catch (error) {
         set({ error: error.message, loading: false });
       }
     },

     reset: () => set({ data: [], loading: false, error: null }),
   }));

3️⃣ presentation/hooks/useXxx.ts
   → Create custom hook wrapper (selector optimization)

   import { useXxxStore } from '../providers/xxx_provider';

   export const useXxx = () => {
     // Select only needed state (prevent unnecessary re-renders)
     const data = useXxxStore((state) => state.data);
     const loading = useXxxStore((state) => state.loading);
     const error = useXxxStore((state) => state.error);
     const loadData = useXxxStore((state) => state.loadData);
     const reset = useXxxStore((state) => state.reset);

     return { data, loading, error, loadData, reset };
   };

4️⃣ presentation/pages/XxxPage/XxxPage.tsx
   → Use hook in component

   import { useXxx } from '../../hooks/useXxx';

   export const XxxPage: React.FC = () => {
     const { data, loading, loadData } = useXxx();

     useEffect(() => {
       loadData();
     }, []);

     if (loading) return <Loading />;

     return <div>{data.map(item => ...)}</div>;
   };
```

**Checklist:**
- [ ] Provider is in presentation/providers/?
- [ ] State types defined in presentation/providers/states/?
- [ ] Repository calls are in provider actions (not in hooks)?
- [ ] Custom hook uses selectors for optimization?
- [ ] No direct provider usage in components (use custom hook)?

---

### Scenario 2: Adding New RPC Function

**Order (MUST follow this sequence!):**

```
1️⃣ data/datasources/XxxDataSource.ts
   → Add new RPC function

   async getNewData(companyId: string) {
     const supabase = supabaseService.getClient();
     const { data, error } = await supabase.rpc('new_rpc_function', {
       p_company_id: companyId
     });
     if (error) throw new Error(error.message);
     return data || [];
   }

2️⃣ data/models/XxxModel.ts (if needed)
   → Add DTO Mapper

   static fromJson(json: any) {
     return { /* field mapping */ };
   }

3️⃣ domain/repositories/IXxxRepository.ts
   → Add method to interface

   getNewData(companyId: string): Promise<NewDataType[]>;

4️⃣ data/repositories/XxxRepositoryImpl.ts
   → Implement interface

   async getNewData(companyId: string): Promise<NewDataType[]> {
     const data = await this.dataSource.getNewData(companyId);
     return data.map(XxxModel.fromJson);
   }

5️⃣ presentation/hooks/useXxx.ts
   → Call repository from hook

   const [newData, setNewData] = useState([]);
   const loadNewData = async () => {
     const result = await repository.getNewData(companyId);
     setNewData(result);
   };

6️⃣ presentation/pages/XxxPage/XxxPage.tsx
   → Use hook

   const { newData } = useXxx(companyId);
```

**Checklist:**
- [ ] RPC calls are only in datasource?
- [ ] No direct supabase usage in presentation?
- [ ] Repository interface defined first?
- [ ] Dependency direction maintained? (presentation → data → domain)

---

### Scenario 2: Modifying RPC Parameters

**Order:**

```
1️⃣ data/datasources/XxxDataSource.ts
   → Change RPC call parameters

   const { data, error } = await supabase.rpc('function_name', {
     p_company_id: companyId,
     p_new_param: newParam  // New parameter added
   });

2️⃣ domain/repositories/IXxxRepository.ts
   → Change interface method signature

   getData(companyId: string, newParam: string): Promise<DataType[]>;

3️⃣ data/repositories/XxxRepositoryImpl.ts
   → Pass parameters in implementation

   async getData(companyId: string, newParam: string) {
     return await this.dataSource.getData(companyId, newParam);
   }

4️⃣ presentation/hooks/useXxx.ts
   → Pass new parameter from hook

   const result = await repository.getData(companyId, newParam);

5️⃣ presentation/pages/XxxPage/XxxPage.tsx
   → Pass new parameter value

   const { data } = useXxx(companyId, newParam);
```

---

### Scenario 3: Adding Validation Rules

**Order:**

```
1️⃣ domain/validators/XxxValidator.ts
   → Define validation rules (static methods only!)

   export class XxxValidator {
     static validateNewRule(data: any): ValidationError[] {
       const errors: ValidationError[] = [];
       if (!data.field) {
         errors.push({ field: 'field', message: 'Required' });
       }
       return errors;
     }
   }

2️⃣ presentation/hooks/useXxx.ts
   → Execute validation by calling Validator

   const handleSubmit = async (data: any) => {
     // 1. Call Validator (execute validation)
     const errors = XxxValidator.validateNewRule(data);
     if (errors.length > 0) {
       setErrors(errors);
       return { success: false };
     }

     // 2. Call Repository (process data)
     const result = await repository.save(data);
     return result;
   };

3️⃣ presentation/pages/XxxPage/XxxPage.tsx
   → Handle error UI

   {errors.length > 0 && (
     <ErrorMessage errors={errors} />
   )}
```

**Checklist:**
- [ ] Validator is in domain/validators/?
- [ ] Validator is defined with static methods only?
- [ ] Validation execution is in presentation/hooks/?
- [ ] Validator doesn't call repository or RPC?

---

### Scenario 4: UI Changes (Buttons, Layout, etc.)

**Modification Location:**

```
✅ presentation/pages/XxxPage/XxxPage.tsx
   → Change component structure

✅ presentation/pages/XxxPage/XxxPage.module.css
   → Change styles

✅ presentation/components/XxxComponent/XxxComponent.tsx
   → Modify sub-components

❌ domain/ - No modification needed
❌ data/ - No modification needed
```

**Checklist:**
- [ ] Only UI changes?
- [ ] Business logic is in hooks?
- [ ] No direct RPC calls?

---

### Scenario 5: Adding Entity Fields

**Order:**

```
1️⃣ domain/entities/XxxEntity.ts
   → Add new field to class

   export class XxxEntity {
     constructor(
       public readonly id: string,
       public readonly newField: string  // New field
     ) {}
   }

2️⃣ data/models/XxxModel.ts
   → Map new field in DTO Mapper

   static fromJson(json: any): XxxEntity {
     return new XxxEntity(
       json.id,
       json.new_field  // DB column name mapping
     );
   }

3️⃣ data/datasources/XxxDataSource.ts
   → Receive new field from RPC response (only if RPC changed)

4️⃣ presentation/hooks/useXxx.ts
   → Process new field logic (if needed)

5️⃣ presentation/pages/XxxPage/XxxPage.tsx
   → Display new field in UI

   <div>{item.newField}</div>
```

---

## 🔍 Pre-Modification Checklist

```
[ ] RPC call needed?
    → YES: Call only from data/datasources/
    → NO: Next step

[ ] Business logic addition needed?
    → YES: Handle in presentation/hooks/
    → NO: Next step

[ ] Validation rules addition needed?
    → YES: Define in domain/validators/
    → NO: Next step

[ ] UI-only changes?
    → YES: Modify only presentation/pages/ or components/
```

---

## 🚨 Post-Modification Verification

### 1. State Management Verification

```bash
# Check if components use useState for feature state (should use Zustand instead)
grep -r "useState" src/features/*/presentation/pages/
grep -r "useState" src/features/*/presentation/components/
# Review results - useState should ONLY be used for UI-only state (not feature state)

# Check if components use provider directly (should use custom hook wrapper)
grep -r "useXxxStore" src/features/*/presentation/pages/
grep -r "useXxxStore" src/features/*/presentation/components/
# Should return nothing! Must use custom hook wrapper

# Check if hooks call repositories directly (should be in provider actions)
grep -r "repository\." src/features/*/presentation/hooks/
# Should return nothing! Repository calls must be in provider actions
```

### 2. Dependency Direction Verification

```bash
# Check if domain imports data/presentation
grep -r "from.*data/" src/features/*/domain/
grep -r "from.*presentation/" src/features/*/domain/
# Should return nothing!

# Check if data imports presentation
grep -r "from.*presentation/" src/features/*/data/
# Should return nothing!

# Check if presentation uses supabase directly
grep -r "supabase.rpc\|supabase.from" src/features/*/presentation/
# Should return nothing!
```

### 3. File Size Verification

```bash
# TSX files: Check for files over 15KB
find src/features -name "*.tsx" -size +15k

# TS files: Check for files over 30KB
find src/features -name "*.ts" ! -name "*.types.ts" -size +30k

# CSS Module: Check for files over 20KB
find src/features -name "*.module.css" -size +20k

# Should return nothing!
```

### 4. Import Order Verification

```typescript
// Correct order:
// 1. External libraries
import React from 'react';

// 2. shared (UI components, global hooks)
import { TossButton } from '@/shared/components/toss/TossButton';

// 3. core (services, utilities)
import { formatCurrency } from '@/core/utils/formatters';

// 4. domain (entities, validators)
import { XxxEntity } from '../../domain/entities/XxxEntity';

// 5. data (repositories)
import { XxxRepositoryImpl } from '../../data/repositories/XxxRepositoryImpl';

// 6. presentation (hooks, components)
import { useXxx } from '../../hooks/useXxx';
```

---

## 📌 Quick Reference

### State Management Location (2025 Best Practice - Zustand)
```
✅ presentation/providers/xxx_provider.ts (Zustand provider definition)
   → State + Actions + Repository calls

✅ presentation/providers/states/xxx_state.ts (TypeScript interfaces)
   → State interface definitions

✅ presentation/hooks/useXxx.ts (Custom hook wrapper)
   → Selector optimization + Provider usage

✅ presentation/pages/XxxPage.tsx (Component)
   → Use custom hook, NOT direct provider

❌ presentation/pages/XxxPage.tsx (NEVER!)
   → No useState for feature state
   → No direct useXxxStore() usage
   → Must use custom hook wrapper
```

### RPC Call Location
```
✅ data/datasources/XxxDataSource.ts (ONLY here!)
❌ presentation/hooks/useXxx.ts (NEVER!)
❌ presentation/pages/XxxPage.tsx (NEVER!)
```

### Validation Rules Location
```
✅ domain/validators/XxxValidator.ts (definition only, static methods)
✅ presentation/hooks/useXxx.ts (execution here)
❌ domain/validators/ must NOT call repository!
```

### Business Logic Location
```
✅ presentation/providers/xxx_provider.ts
   → State management + Repository calls + Async actions

✅ presentation/hooks/useXxx.ts
   → Call Validator + Use Provider (custom hook wrapper)

❌ presentation/pages/XxxPage.tsx
   → UI rendering only!
```

### Dependency Direction
```
presentation → data → domain (unidirectional only!)
```

---

## 🎯 Golden Rules

1. **State Management: Zustand provider in presentation/providers/, custom hook wrapper required**
2. **RPC calls ONLY in data/datasources/**
3. **Repository calls in presentation/providers/ actions (NOT in presentation/hooks/)**
4. **Validation definition in domain/validators/, execution in presentation/hooks/**
5. **UI in presentation/, logic separated into hooks**
6. **Dependency direction: presentation → data → domain (reverse forbidden!)**
7. **File size: TSX ≤15KB, TS ≤30KB, CSS ≤20KB**

---

**Last Updated**: 2025-11-13
**Version**: 2.0 (Added Zustand State Management Guide)
