# 🎯 **DEBT ACCOUNT MAPPING SYSTEM - IMPLEMENTATION PLAN**

## **🔍 What This Page Is For:**
**Page Name**: Debt Account Settings Page (`/debtAccountSettings/:counterpartyId/:counterpartyName`)

**Primary Purpose**: 
- Create and manage **debt account mappings** between internal companies
- Ensure **both sides** of inter-company debt transactions are recorded automatically
- Prevent **data integrity violations** where only one company records a debt transaction

**Business Problem Solved**:
```
❌ BEFORE: Company A lends $1000 to Company B
   - Company A records: Account Receivable $1000 ✅
   - Company B records: NOTHING ❌
   - Result: Unbalanced books, audit failure

✅ AFTER: With Account Mapping
   - Company A records: Account Receivable $1000 (manual)
   - Company B records: Account Payable $1000 (automatic via mapping)
   - Result: Both companies have balanced, consistent records
```

## **🏗️ RPC-ONLY Implementation Strategy**

### **Constraint**: NO Database Schema Changes - Only RPC Functions

### **Phase 1: Foundation Setup (Day 1)**
**Goal**: Understand current structure and create RPC foundation

```yaml
Tasks:
  1.1_analyze_direction_field:
    priority: CRITICAL
    description: "Understand what 'direction' column contains and its purpose"
    method: "Add debug logging to see actual direction values"
    deliverable: "Direction field analysis document"
    
  1.2_create_core_rpc_functions:
    priority: CRITICAL
    description: "Create 3 core RPC functions for account mapping"
    functions:
      - get_account_mappings_with_company(counterparty_id)
      - create_account_mapping(params)
      - find_inter_company_journals(company_id)
    deliverable: "3 tested RPC functions in database"
    
  1.3_test_counterparty_linked_company:
    priority: HIGH
    description: "Verify counterparties.linked_company_id is populated correctly"
    method: "Query existing data to confirm relationship works"
    deliverable: "Data validation report"
    
  1.4_update_provider_to_use_rpc:
    priority: HIGH
    description: "Replace direct queries with RPC function calls"
    files: ["account_mapping_providers.dart"]
    deliverable: "Updated provider using RPC functions"
```

### **Phase 2: Debt Account Filtering (Day 1-2)**
**Goal**: Ensure only debt accounts (payable/receivable) are shown

```yaml
Tasks:
  2.1_analyze_account_categories:
    priority: HIGH
    description: "Understand how debt accounts are identified in accounts table"
    fields_to_check: ["category_tag", "debt_tag", "account_type"]
    method: "Query accounts table to find debt account patterns"
    deliverable: "Debt account identification rules"
    
  2.2_create_debt_accounts_rpc:
    priority: HIGH
    description: "Create RPC to filter debt accounts only"
    function: "get_debt_accounts_for_company(company_id)"
    filter_logic: "category_tag ILIKE '%payable%' OR '%receivable%' OR debt_tag IS NOT NULL"
    deliverable: "Debt accounts filtering RPC function"
    
  2.3_update_form_dropdowns:
    priority: MEDIUM
    description: "Update account dropdowns to use debt-only RPC"
    files: ["account_mapping_providers.dart", "account_mapping_form.dart"]
    deliverable: "Dropdowns showing only debt accounts"
    
  2.4_validate_internal_counterparties:
    priority: MEDIUM
    description: "Ensure only internal counterparties are available"
    validation: "counterparties.is_internal = true AND linked_company_id IS NOT NULL"
    deliverable: "Internal counterparty validation"
```

### **Phase 3: Inter-Company Journal Recognition (Day 2-3)**
**Goal**: Implement the core journal recognition mechanism

```yaml
Tasks:
  3.1_journal_recognition_logic:
    priority: CRITICAL
    description: "Implement how Company B finds journals from Company A"
    method: "Use reference_number as linking mechanism"
    key_insight: "Same reference_number = same transaction across companies"
    deliverable: "Journal recognition algorithm"
    
  3.2_create_journal_detection_rpc:
    priority: CRITICAL
    description: "RPC to find journals that need corresponding entries"
    function: "find_pending_inter_company_journals(target_company_id)"
    logic: "Find journals with internal counterparty pointing to target company"
    deliverable: "Journal detection RPC function"
    
  3.3_mapping_lookup_algorithm:
    priority: HIGH
    description: "Algorithm to find correct account mapping for journal"
    input: "journal_entry + counterparty_id + account_id"
    output: "corresponding account in target company"
    deliverable: "Mapping lookup logic"
    
  3.4_test_recognition_flow:
    priority: HIGH
    description: "Test complete recognition flow with sample data"
    scenario: "Company A → Company B debt transaction"
    validation: "Company B can find and process Company A's journal"
    deliverable: "End-to-end recognition test"
```

### **Phase 4: Auto-Journal Creation (Day 3-4)**
**Goal**: Automatically create corresponding journal entries

```yaml
Tasks:
  4.1_design_auto_journal_structure:
    priority: HIGH
    description: "Design structure of auto-generated journal entries"
    considerations:
      - "How to mark as auto-generated (use description or reference)"
      - "How to link back to source journal"
      - "How to prevent duplicate creation"
    deliverable: "Auto-journal design specification"
    
  4.2_create_auto_journal_rpc:
    priority: HIGH
    description: "RPC to create corresponding journal entry"
    function: "create_corresponding_journal(source_entry_id, mapping_id)"
    logic: "Use account mapping to create reverse entry"
    deliverable: "Auto-journal creation RPC"
    
  4.3_implement_debit_credit_logic:
    priority: MEDIUM
    description: "Implement correct debit/credit logic for debt mapping"
    rules:
      - "Company A: Debit Receivable → Company B: Credit Payable"
      - "Company A: Credit Cash → Company B: Debit Expense/Asset"
    deliverable: "Debit/Credit mapping logic"
    
  4.4_add_duplicate_prevention:
    priority: HIGH
    description: "Prevent creating duplicate corresponding entries"
    method: "Check reference_number + company_id combination"
    deliverable: "Duplicate prevention logic"
```

### **Phase 5: UI/UX Enhancement (Day 4-5)**
**Goal**: Polish user interface and experience

```yaml
Tasks:
  5.1_enhance_form_validation:
    priority: MEDIUM
    description: "Add real-time validation for debt mapping rules"
    validations:
      - "Both accounts must be debt accounts"
      - "Counterparty must be internal"
      - "No duplicate mappings"
      - "Accounts cannot be the same"
    deliverable: "Enhanced form validation"
    
  5.2_improve_explanations:
    priority: LOW
    description: "Add better explanations and examples"
    additions:
      - "What happens when mapping is used"
      - "Example scenarios"
      - "Visual indicators for debt accounts"
    deliverable: "Improved user guidance"
    
  5.3_add_mapping_preview:
    priority: LOW
    description: "Show preview of what will happen"
    preview: "When you record X, they will record Y"
    deliverable: "Mapping preview feature"
    
  5.4_error_handling_improvement:
    priority: MEDIUM
    description: "Better error messages and recovery"
    scenarios: "RPC failures, validation errors, duplicate attempts"
    deliverable: "Robust error handling"
```

### **Phase 6: Testing & Documentation (Day 5)**
**Goal**: Comprehensive testing and documentation

```yaml
Tasks:
  6.1_create_test_scenarios:
    priority: HIGH
    description: "Create comprehensive test scenarios"
    scenarios:
      - "Simple debt mapping creation"
      - "Journal recognition flow"
      - "Auto-journal creation"
      - "Error handling cases"
      - "Edge cases and validation"
    deliverable: "Test scenario documentation"
    
  6.2_test_with_real_data:
    priority: HIGH
    description: "Test with actual company data"
    method: "Use existing companies and create sample mappings"
    validation: "End-to-end flow works correctly"
    deliverable: "Real data test results"
    
  6.3_performance_testing:
    priority: MEDIUM
    description: "Test performance with larger datasets"
    metrics: "RPC response times, form load times, query efficiency"
    target: "<500ms for all operations"
    deliverable: "Performance test report"
    
  6.4_update_documentation:
    priority: LOW
    description: "Update all documentation"
    docs: "API docs, user guide, troubleshooting guide"
    deliverable: "Complete documentation set"
```

## **🎯 Success Criteria**

### **Functional Requirements**
```yaml
✅ Core Functionality:
  - Can create debt account mappings between internal companies
  - Only debt accounts (payable/receivable) appear in dropdowns
  - Only internal counterparties can be selected
  - Mappings prevent duplicate creation
  
✅ Journal Recognition:
  - Company B can find journals from Company A that affect them
  - Recognition works via counterparty relationships
  - Uses reference_number to link related transactions
  
✅ Data Integrity:
  - No unmatched debt transactions between internal companies
  - Corresponding entries maintain accounting equation balance
  - Audit trail shows both manual and auto-generated entries
```

### **Technical Requirements**
```yaml
✅ Performance:
  - All RPC functions respond in <500ms
  - Form loads in <1 second
  - Handles 100+ mappings efficiently
  
✅ Reliability:
  - No data corruption or loss
  - Graceful error handling
  - Recovery from RPC failures
  
✅ User Experience:
  - Clear explanations of what mappings do
  - Real-time validation feedback
  - Easy to understand error messages
```

## **🚨 Critical Dependencies & Risks**

### **Dependencies**
```yaml
Database_Structure:
  - counterparties.linked_company_id must be populated
  - accounts table must have debt identification fields
  - journal_entries.reference_number must be unique per transaction
  
Business_Logic:
  - Direction field purpose must be understood
  - Debit/Credit mapping rules must be defined
  - Duplicate prevention strategy must be agreed upon
```

### **Risks & Mitigations**
```yaml
High_Risk:
  direction_field_unknown:
    risk: "Don't understand purpose of direction field"
    mitigation: "Analyze existing data and consult stakeholders"
    
  counterparty_data_incomplete:
    risk: "linked_company_id not properly populated"
    mitigation: "Validate data and create data fix scripts if needed"
    
Medium_Risk:
  rpc_performance:
    risk: "RPC functions may be slow with large datasets"
    mitigation: "Add proper indexing and query optimization"
    
  user_confusion:
    risk: "Users don't understand debt mapping concept"
    mitigation: "Clear explanations, examples, and validation"
```

## **📋 Daily Execution Plan**

### **Day 1: Foundation**
```
Morning:
├── Analyze direction field and current data structure
├── Create first RPC function: get_account_mappings_with_company
└── Test with existing counterparty data

Afternoon:
├── Create debt accounts filtering RPC
├── Update providers to use RPC functions
└── Test form with new debt-only filtering
```

### **Day 2: Recognition Logic** 
```
Morning:
├── Implement journal recognition algorithm
├── Create find_inter_company_journals RPC
└── Test recognition with sample data

Afternoon:
├── Create mapping lookup logic
├── Test complete recognition flow
└── Document recognition mechanism
```

### **Day 3: Auto-Journal Creation**
```
Morning:
├── Design auto-journal entry structure
├── Create auto-journal creation RPC
└── Implement debit/credit logic

Afternoon:
├── Add duplicate prevention
├── Test auto-creation flow
└── Validate accounting equation balance
```

### **Day 4: UI Enhancement**
```
Morning:
├── Enhance form validation
├── Improve error handling
└── Add mapping preview feature

Afternoon:
├── Polish user interface
├── Add better explanations
└── Test user experience flow
```

### **Day 5: Testing & Documentation**
```
Morning:
├── Comprehensive testing scenarios
├── Performance testing
└── Real data validation

Afternoon:
├── Documentation updates
├── Final bug fixes
└── Deployment preparation
```

## **🎯 Final Deliverable**

**A complete Debt Account Mapping System that:**
- ✅ Prevents data integrity violations in inter-company transactions
- ✅ Uses only RPC functions (no database schema changes)
- ✅ Provides intuitive user interface for debt mapping management
- ✅ Automatically handles journal recognition and corresponding entry creation
- ✅ Maintains full audit trail and data consistency
- ✅ Scales to handle multiple internal companies efficiently

**This system ensures that when Company A records a debt transaction, Company B automatically gets the corresponding entry, maintaining perfect data integrity across all internal companies.**

---

## **📊 RPC Functions Design**

### **1. Get Account Mappings with Company Info**
```sql
CREATE OR REPLACE FUNCTION get_account_mappings_with_company(
    p_counterparty_id UUID
) RETURNS TABLE (
    mapping_id UUID,
    my_company_id UUID,
    my_account_id UUID,
    counterparty_id UUID,
    linked_account_id UUID,
    direction TEXT,
    created_by UUID,
    created_at TIMESTAMP,
    -- DERIVED FIELDS
    linked_company_id UUID,
    linked_company_name TEXT,
    my_account_name TEXT,
    linked_account_name TEXT
) LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT 
        am.mapping_id,
        am.my_company_id,
        am.my_account_id,
        am.counterparty_id,
        am.linked_account_id,
        am.direction,
        am.created_by,
        am.created_at,
        -- Derive linked company from counterparty
        cp.linked_company_id,
        lc.company_name as linked_company_name,
        ma.account_name as my_account_name,
        la.account_name as linked_account_name
    FROM account_mappings am
    JOIN counterparties cp ON am.counterparty_id = cp.counterparty_id
    LEFT JOIN companies lc ON cp.linked_company_id = lc.company_id
    LEFT JOIN accounts ma ON am.my_account_id = ma.account_id
    LEFT JOIN accounts la ON am.linked_account_id = la.account_id
    WHERE am.counterparty_id = p_counterparty_id
    ORDER BY am.created_at DESC;
END;
$$;
```

### **2. Find Inter-Company Journals**
```sql
CREATE OR REPLACE FUNCTION find_inter_company_journals(
    p_target_company_id UUID
) RETURNS TABLE (
    source_entry_id UUID,
    source_company_id UUID,
    counterparty_id UUID,
    account_mappings JSON
) LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT 
        je.entry_id,
        je.company_id,
        je.counterparty_id,
        JSON_AGG(
            JSON_BUILD_OBJECT(
                'mapping_id', am.mapping_id,
                'my_account_id', am.my_account_id,
                'linked_account_id', am.linked_account_id,
                'direction', am.direction
            )
        ) as account_mappings
    FROM journal_entries je
    JOIN counterparties cp ON je.counterparty_id = cp.counterparty_id
    JOIN account_mappings am ON am.counterparty_id = cp.counterparty_id
    WHERE cp.is_internal = true
    AND cp.linked_company_id = p_target_company_id
    AND NOT EXISTS (
        -- Check if corresponding entry already exists
        SELECT 1 FROM journal_entries existing
        WHERE existing.reference_number = je.reference_number
        AND existing.company_id = p_target_company_id
    )
    GROUP BY je.entry_id, je.company_id, je.counterparty_id;
END;
$$;
```

---

## **📝 Notes for Tomorrow**

1. **First Priority**: Analyze the `direction` field to understand its purpose
2. **Check Data**: Verify `counterparties.linked_company_id` is populated
3. **Test RPC**: Create and test the first RPC function
4. **Debug Mode**: Keep debug logging active to understand data flow
5. **Document Findings**: Record all discoveries about the database structure

**Start Time**: Begin with Phase 1.1 - Direction field analysis
**End Goal**: Complete foundation setup and have working RPC functions