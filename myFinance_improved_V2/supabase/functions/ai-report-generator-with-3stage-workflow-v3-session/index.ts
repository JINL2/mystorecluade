import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type'
};

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// BASE TOOLS (Always Available) - 7개
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

const BASE_TOOLS = [
  {
    type: "function",
    function: {
      name: "get_table_schema",
      description: "Get actual column names and data types from any table or view. Call this FIRST to understand table structure.",
      parameters: {
        type: "object",
        properties: {
          table_name: {
            type: "string",
            description: "Name of table from template.available_tables"
          }
        },
        required: ["table_name"]
      }
    }
  },
  {
    type: "function",
    function: {
      name: "get_column_meanings",
      description: "Get business meanings, calculation formulas, valid ranges for columns. Call this SECOND to understand business logic.",
      parameters: {
        type: "object",
        properties: {
          table_name: {
            type: "string",
            description: "Name of table to get meanings for"
          }
        },
        required: ["table_name"]
      }
    }
  },
  {
    type: "function",
    function: {
      name: "get_context_info",
      description: "Get company and store information (names, details). Call this to get proper names for the report.",
      parameters: {
        type: "object",
        properties: {
          company_id: {
            type: "string",
            description: "Company ID"
          },
          store_id: {
            type: "string",
            description: "Store ID (optional)"
          }
        },
        required: ["company_id"]
      }
    }
  },
  {
    type: "function",
    function: {
      name: "query_database",
      description: "Execute SQL SELECT query on allowed tables. Use when RPC functions don't provide the data you need.",
      parameters: {
        type: "object",
        properties: {
          query: {
            type: "string",
            description: "SQL SELECT query. Must include company_id filter. No semicolons."
          }
        },
        required: ["query"]
      }
    }
  },
  {
    type: "function",
    function: {
      name: "detect_anomalies",
      description: "Run fraud detection queries based on business rules. Use for fraud detection reports.",
      parameters: {
        type: "object",
        properties: {
          table_name: {
            type: "string",
            description: "Table to check for anomalies"
          },
          detection_type: {
            type: "string",
            enum: ["all", "excessive_overtime", "excessive_late_reduction", "work_without_approval", "impossible_hours"],
            description: "Type of anomaly to detect"
          }
        },
        required: ["table_name", "detection_type"]
      }
    }
  },
  // ━━━ STAGE 2: verify_report ━━━
  {
    type: "function",
    function: {
      name: "verify_report",
      description: "⚠️ MANDATORY STEP 2 - DO NOT SKIP: After writing draft, you MUST call this tool to verify all numbers against actual database. This is required by the workflow system.",
      parameters: {
        type: "object",
        properties: {
          draft_content: {
            type: "string",
            description: "The draft report text to verify"
          },
          claimed_values: {
            type: "array",
            description: "Array of ALL numeric values you claimed in the draft that need verification. Include every number you wrote.",
            items: {
              type: "object",
              properties: {
                field: {
                  type: "string",
                  description: "Field name matching verification_config.rules (e.g., 'total_attendance_count', 'late_count')"
                },
                value: {
                  type: "number",
                  description: "Exact numeric value you wrote in the draft"
                }
              },
              required: ["field", "value"]
            }
          }
        },
        required: ["draft_content", "claimed_values"]
      }
    }
  },
  // ━━━ STAGE 3: format_report ━━━
  {
    type: "function",
    function: {
      name: "format_report",
      description: "⚠️ MANDATORY STEP 3 - DO NOT SKIP: After verification passes, you MUST call this tool to get formatting rules. This is required by the workflow system.",
      parameters: {
        type: "object",
        properties: {
          verified_content: {
            type: "string",
            description: "The verified report content (after hallucination check passed)"
          }
        },
        required: ["verified_content"]
      }
    }
  }
];

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// HELPER: Format Number for Display
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

function formatNumber(value: number): string {
  if (value >= 100000000) {
    return `${(value / 100000000).toFixed(1)}억`;
  }
  if (value >= 10000) {
    return `${(value / 10000).toFixed(1)}만`;
  }
  return value.toLocaleString('ko-KR');
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// HELPER: Determine Current Stage from Session
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

function determineCurrentStage(session: any): string {
  if (!session.draft_completed_at) {
    return 'draft';
  }
  if (!session.verification_completed_at) {
    return 'verify';
  }
  if (!session.formatting_completed_at) {
    return 'format';
  }
  return 'output';
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// HELPER: Build Stage-Specific Prompt
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

function buildStagePrompt(session: any, template: any): string {
  const stage = determineCurrentStage(session);

  if (stage === 'draft') {
    // Build dynamic RPC list from template
    const availableRPCs = template.available_rpc_functions || [];
    const rpcList = availableRPCs.length > 0
      ? availableRPCs.map((rpc: string, i: number) => `${i + 1}. ${rpc}`).join('\n')
      : '(No RPC functions available - use query_database instead)';

    return `
⚠️⚠️⚠️ CURRENT WORKFLOW STAGE: DRAFT ⚠️⚠️⚠️

YOU ARE IN DATA COLLECTION & DRAFT WRITING STAGE.

🚫🚫🚫 STOP! READ THIS BEFORE DOING ANYTHING! 🚫🚫🚫

THE USER SAYS: "Data provided: (Data will be collected via tools)"
THIS MEANS: NO DATA HAS BEEN PROVIDED YET!
YOU MUST COLLECT THE DATA YOURSELF!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚨 MANDATORY STEP 1: CALL ALL RPC FUNCTIONS (NO EXCEPTIONS)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Available RPC functions for this template:
${rpcList}

⚠️ YOU MUST CALL ALL ${availableRPCs.length} RPC FUNCTIONS ABOVE!
⚠️ IF YOU SKIP ANY RPC CALLS, YOUR REPORT WILL FAIL VERIFICATION!
⚠️ DO NOT proceed to writing until you have called ALL RPCs!
⚠️ DO NOT invent ANY data - use ONLY data returned from these RPCs!

Check the template's system prompt for detailed instructions on:
- What each RPC function does
- What parameters to pass
- How to use the returned data

MANDATORY STEP 2: WRITE DRAFT USING ONLY REAL DATA
After collecting data from RPC functions:
1. Use ONLY the exact data returned from tool calls
2. Use ONLY employee names that appear in the actual data
3. Use ONLY transaction amounts from the actual data
4. Note ALL numeric values you include in the report

MANDATORY STEP 3: CALL verify_report
When you have collected all necessary data and written your draft:
→ You MUST call verify_report tool with:
  - draft_content: Your complete draft text (using ONLY real data)
  - claimed_values: Array of ALL numbers you wrote (must match verification rules)

⚠️ VERIFICATION RULES - Your claimed_values MUST include these fields:
- total_transaction_count: Total number of transactions
- total_transaction_amount: Total transaction amount
- high_value_transaction_count: Number of high-value transactions (≥10,000,000)

Any other fields will cause verification to FAIL.

DO NOT output any final text yet. The workflow requires verification first.

Session Status:
✗ Draft: NOT COMPLETED
✗ Verification: NOT STARTED
✗ Formatting: NOT STARTED
✗ Output: NOT ALLOWED
`;
  }

  if (stage === 'verify') {
    return `
⚠️⚠️⚠️ CURRENT WORKFLOW STAGE: VERIFY (MANDATORY) ⚠️⚠️⚠️

YOU MUST CALL verify_report TOOL NOW. NO EXCEPTIONS.

The workflow system requires verification before proceeding.
You CANNOT skip this step.
You CANNOT output any text until verification passes.

Draft was completed at: ${session.draft_completed_at}
Draft content stored in session.

REQUIRED ACTION: Call verify_report tool with your draft content and claimed values.

If verification returns status='failed':
  - Read the issues carefully
  - Rewrite your draft with correct actual_value
  - Call verify_report again

Only after status='passed' can you proceed to FORMAT stage.

Session Status:
✓ Draft: COMPLETED (${session.draft_completed_at})
⚠️ Verification: YOU MUST DO THIS NOW
✗ Formatting: WAITING
✗ Output: NOT ALLOWED
`;
  }

  if (stage === 'format') {
    return `
⚠️⚠️⚠️ CURRENT WORKFLOW STAGE: FORMAT (MANDATORY) ⚠️⚠️⚠️

YOU MUST CALL format_report TOOL NOW. NO EXCEPTIONS.

Verification passed successfully.
Verified content is ready in the session.

REQUIRED ACTION: Call format_report tool with the verified content.

The tool will return formatting requirements including:
- Required JSON fields for structured_data
- Required sections for markdown_report
- Style, max_length, number format rules

DO NOT output the final JSON yet. Wait for formatting rules first.

Session Status:
✓ Draft: COMPLETED (${session.draft_completed_at})
✓ Verification: PASSED (${session.verification_completed_at})
⚠️ Formatting: YOU MUST DO THIS NOW
✗ Output: WAITING
`;
  }

  if (stage === 'output') {
    return `
⚠️⚠️⚠️ CURRENT WORKFLOW STAGE: OUTPUT (FINAL) ⚠️⚠️⚠️

ALL WORKFLOW STAGES COMPLETED. YOU MAY NOW OUTPUT THE FINAL JSON.

Session Status:
✓ Draft: COMPLETED (${session.draft_completed_at})
✓ Verification: PASSED (${session.verification_completed_at})
✓ Formatting: COMPLETED (${session.formatting_completed_at})
✓ Output: YOU MUST DO THIS NOW

REQUIRED ACTION:
Generate and output the final JSON object with this EXACT structure:

{
  "structured_data": {
    // Extract all required fields from format_metadata in session
    // Use exact field names specified in format_config
  },
  "markdown_report": "..."
    // Format according to requirements in format_metadata
    // Follow style, sections, number_format rules
    // Maximum 3500 characters - USE ALL AVAILABLE SPACE
    // Include ALL data from your draft - do NOT truncate or omit
}

CRITICAL OUTPUT RULES:
- Output ONLY the JSON object
- NO explanation text before or after
- NO markdown code blocks (\`\`\`json)
- Just pure JSON starting with { and ending with }
- markdown_report MUST include ALL details from verified_content
- Do NOT shorten the report to save space

This is your FINAL response. After this, the report generation is complete.
`;
  }

  return '';
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// SYSTEM PROMPT (Base Instructions)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

const BASE_SYSTEM_PROMPT = `You are Storebase AI Report Generator.

⚠️⚠️⚠️ WORKFLOW SYSTEM ENABLED ⚠️⚠️⚠️

This report generation follows a strict 3-stage workflow managed by a session tracking system:

STAGE 1 - DRAFT: Collect data and write draft
STAGE 2 - VERIFY: Verify draft for hallucinations (MANDATORY)
STAGE 3 - FORMAT: Get formatting rules (MANDATORY)
STAGE 4 - OUTPUT: Generate final JSON

Your current stage is shown at the top of each iteration.
You MUST follow the stage instructions. The system will reject any attempts to skip stages.

🎯 THINKING PROCESS:

Before generating the report, analyze:
1. What data do I need? (Check template requirements)
2. Are RPC functions available? (Use them first - they're optimized)
3. If no RPC, which tables should I query? (Check available_tables)
4. What columns exist? (Call get_table_schema)
5. What do these columns mean? (Call get_column_meanings)

🔧 AVAILABLE TOOLS:

**For Understanding:**
- get_context_info: Company/store names and info
- get_table_schema: Table structure (columns, types)
- get_column_meanings: Business meanings and rules

**For Data Collection:**
- [RPC Functions]: Pre-built analysis (USE FIRST if available)
- query_database: Direct SQL query (when RPC doesn't exist)
- detect_anomalies: Fraud detection patterns

**For Workflow Stages:**
- verify_report: Stage 2 - Verify draft for hallucinations
- format_report: Stage 3 - Get formatting requirements

⚠️ CRITICAL DATA ACCURACY RULES:

**NEVER FABRICATE OR HALLUCINATE DATA:**
- Use ONLY the exact data returned from tool calls
- If a tool returns 27 records, report 27 - NOT 1,250
- If total is 55,428,000, report 55.4 million - NOT 4.5 billion
- NEVER invent numbers, names, or details for "better storytelling"

**DATA INTEGRITY:**
- Report exact figures from tool responses
- Do NOT round excessively or exaggerate
- Do NOT invent comparisons without actual comparison data
- Do NOT fabricate entity names, IDs, or specific details
- If data is missing, explicitly state it rather than guessing

**INCLUDE ALL RETRIEVED DATA:**
- If you called get_account_summary_by_period, INCLUDE the account breakdown
- If you called get_cpa_audit_report, INCLUDE the anomalies and store breakdown
- Do NOT summarize away important details from tool responses
- Show ALL items from tool responses, not just top items
- Include ALL employee transactions, ALL stores, ALL account details
- Maximum report length is 3500 characters - use all available space
- NEVER truncate or omit data to save space

**CURRENCY FORMATTING:**
- Always call get_context_info FIRST to get currency information
- Use the currency symbol and name from context (e.g., ₫ for VND)
- Never hardcode currency - always use from context

⚠️ CRITICAL RULES:

**Data Collection:**
- Try RPC functions FIRST (faster, optimized)
- Only query tables if RPC doesn't exist or insufficient
- ALWAYS filter by company_id
- Include date range filters
- Don't fetch more data than needed

**SQL Queries:**
- Use proper JOIN conditions
- Filter by company_id ALWAYS
- Use date filters appropriately
- No ; at the end
- Format: YYYY-MM-DD for dates

**Report Generation:**
- Language: Match template language (Korean/English/Vietnamese)
- Format: Clean markdown (headers, lists, bold)
- Include: Specific numbers, comparisons, trends
- NO: Raw SQL, technical terms, placeholders

Remember: The workflow system tracks your progress. Follow stage instructions precisely.`;

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// HELPER FUNCTIONS
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

function calculateDateRange(frequency: string, timezone: string, scheduledTime: string) {
  const now = new Date(scheduledTime);
  const userNow = new Date(now.toLocaleString("en-US", { timeZone: timezone }));

  if (frequency === 'daily') {
    const yesterday = new Date(userNow);
    yesterday.setDate(yesterday.getDate() - 1);
    const dateStr = yesterday.toISOString().split('T')[0];
    return { start_date: dateStr, end_date: dateStr, display: dateStr };
  } else if (frequency === 'weekly') {
    const lastSunday = new Date(userNow);
    lastSunday.setDate(lastSunday.getDate() - userNow.getDay() - 7);
    const lastSaturday = new Date(lastSunday);
    lastSaturday.setDate(lastSaturday.getDate() + 6);
    return {
      start_date: lastSunday.toISOString().split('T')[0],
      end_date: lastSaturday.toISOString().split('T')[0],
      display: `${lastSunday.toISOString().split('T')[0]} ~ ${lastSaturday.toISOString().split('T')[0]}`
    };
  } else if (frequency === 'monthly') {
    const lastMonth = new Date(userNow.getFullYear(), userNow.getMonth() - 1, 1);
    const lastMonthEnd = new Date(userNow.getFullYear(), userNow.getMonth(), 0);
    return {
      start_date: lastMonth.toISOString().split('T')[0],
      end_date: lastMonthEnd.toISOString().split('T')[0],
      display: `${lastMonth.getFullYear()}년 ${lastMonth.getMonth() + 1}월`
    };
  }

  const yesterday = new Date(userNow);
  yesterday.setDate(yesterday.getDate() - 1);
  const dateStr = yesterday.toISOString().split('T')[0];
  return { start_date: dateStr, end_date: dateStr, display: dateStr };
}

function replaceTemplateVariables(template: string, data: any) {
  let result = template;
  result = result.replace(/\{\{date\}\}/g, data.date || '');
  result = result.replace(/\{\{data\}\}/g, '(Data will be collected via tools)');
  result = result.replace(/\{\{store_name\}\}/g, data.store_name || '전체 매장');
  result = result.replace(/\{\{company_name\}\}/g, data.company_name || '');
  return result;
}

function extractTablesFromQuery(query: string): string[] {
  const tables: string[] = [];
  const fromRegex = /FROM\s+(\w+)/gi;
  const joinRegex = /JOIN\s+(\w+)/gi;

  let match;
  while ((match = fromRegex.exec(query)) !== null) {
    tables.push(match[1].toLowerCase());
  }
  while ((match = joinRegex.exec(query)) !== null) {
    tables.push(match[1].toLowerCase());
  }

  return [...new Set(tables)];
}

async function callOpenRouter(messages: any[], tools: any[], temperature = 0.3) {
  const response = await fetch('https://openrouter.ai/api/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${Deno.env.get('OPENROUTER_API_KEY')}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      model: 'x-ai/grok-code-fast-1',
      messages,
      tools,
      temperature,
      max_tokens: 6000
    })
  });

  const json = await response.json();

  if (!response.ok || json.error) {
    console.error('[Report] OpenRouter Error:', JSON.stringify(json, null, 2));
    throw new Error(`OpenRouter API Error: ${json.error?.message || response.statusText}`);
  }

  if (!json.choices || json.choices.length === 0) {
    console.error('[Report] Invalid Response:', JSON.stringify(json, null, 2));
    throw new Error('Invalid response from OpenRouter: no choices returned');
  }

  return json;
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// HELPER: Add Log Entry to Session
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

async function addLogEntry(supabase: any, sessionId: string, logEntry: any) {
  try {
    // Get current logs
    const { data: session } = await supabase
      .from('report_generation_sessions')
      .select('execution_logs')
      .eq('session_id', sessionId)
      .single();

    const currentLogs = session?.execution_logs || [];
    const updatedLogs = [...currentLogs, { ...logEntry, timestamp: new Date().toISOString() }];

    // Update logs
    await supabase
      .from('report_generation_sessions')
      .update({ execution_logs: updatedLogs })
      .eq('session_id', sessionId);
  } catch (error) {
    console.error('[Log] Failed to add log entry:', error);
    // Don't throw - logging failure shouldn't break execution
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// TOOL EXECUTION (with Session Updates)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

async function executeToolCall(toolCall: any, supabase: any, template: any, context: any) {
  const toolName = toolCall.function.name;
  const args = JSON.parse(toolCall.function.arguments);
  const startTime = Date.now();

  console.log(`[Report] Tool: ${toolName}`);

  try {
    // ━━━ Basic Tools (no session updates) ━━━

    if (toolName === 'get_table_schema') {
      const tableName = args.table_name;
      if (!template.available_tables?.includes(tableName)) {
        throw new Error(`Table '${tableName}' is not allowed. Available tables: ${template.available_tables?.join(', ')}`);
      }
      console.log(`[Report] Getting schema for: ${tableName}`);
      const result = await supabase.rpc('execute_sql', {
        query_text: `SELECT column_name, data_type, is_nullable FROM information_schema.columns WHERE table_name = '${tableName}' ORDER BY ordinal_position`
      });
      if (!result || result.error) throw result?.error || new Error('Failed to get table schema');
      console.log(`[Report] Found ${result.data.length} columns`);
      return result.data;
    }

    else if (toolName === 'get_column_meanings') {
      const tableName = args.table_name;
      console.log(`[Report] Getting meanings for: ${tableName}`);
      const rulesResult = await supabase.rpc('execute_sql', {
        query_text: `SELECT description, workflow, calculation_logic, fraud_rules FROM table_business_rules WHERE table_name = '${tableName}'`
      });
      const metaResult = await supabase.rpc('execute_sql', {
        query_text: `SELECT column_name, meaning, calculation_formula, normal_range, business_rules, fraud_detection_rules, severity FROM table_metadata WHERE table_name = '${tableName}' ORDER BY column_name`
      });
      if (!metaResult || metaResult.error) throw metaResult?.error || new Error('Failed to get column meanings');
      const data = {
        table_name: tableName,
        table_rules: rulesResult.data?.[0] || null,
        column_meanings: metaResult.data || [],
        total_columns_documented: metaResult.data?.length || 0
      };
      console.log(`[Report] Found ${data.total_columns_documented} documented columns`);
      return data;
    }

    else if (toolName === 'get_context_info') {
      const company_id = args.company_id;
      const store_id = args.store_id;
      console.log(`[Report] Getting context: company=${company_id}, store=${store_id || 'ALL'}`);
      const companyResult = await supabase.rpc('execute_sql', {
        query_text: `SELECT company_id, company_name, company_code FROM companies WHERE company_id = '${company_id}'`
      });
      let storeResult = null;
      if (store_id) {
        storeResult = await supabase.rpc('execute_sql', {
          query_text: `SELECT store_id, store_name, store_code, store_address FROM stores WHERE store_id = '${store_id}'`
        });
      }
      const allStoresResult = await supabase.rpc('execute_sql', {
        query_text: `SELECT store_id, store_name, store_code FROM stores WHERE company_id = '${company_id}' AND (is_deleted = false OR is_deleted IS NULL) ORDER BY store_name`
      });
      const data = {
        company: companyResult.data?.[0] || null,
        store: storeResult?.data?.[0] || null,
        all_stores: allStoresResult.data || [],
        scope: store_id ? 'single_store' : 'all_stores'
      };
      console.log(`[Report] Context: ${data.company?.company_name}, ${data.scope}`);
      return data;
    }

    else if (toolName === 'query_database') {
      let query = args.query.replace(/;+\s*$/g, '').trim();
      console.log(`[Report] Query: ${query.substring(0, 100)}...`);
      const requestedTables = extractTablesFromQuery(query);
      const unauthorized = requestedTables.filter(t => !template.available_tables?.includes(t));
      if (unauthorized.length > 0) {
        throw new Error(`Unauthorized tables: ${unauthorized.join(', ')}. Only these tables are allowed: ${template.available_tables?.join(', ')}`);
      }
      const result = await supabase.rpc('execute_sql', { query_text: query });
      if (!result || result.error) throw result?.error || new Error('Failed to query database');
      console.log(`[Report] Returned ${result.data?.length || 0} rows`);
      return result.data;
    }

    else if (toolName === 'detect_anomalies') {
      const tableName = args.table_name;
      const detectionType = args.detection_type;
      console.log(`[Report] Detecting ${detectionType} in ${tableName}`);
      const rulesResult = await supabase.rpc('execute_sql', {
        query_text: `SELECT column_name, fraud_detection_rules, severity FROM table_metadata WHERE table_name = '${tableName}' AND fraud_detection_rules IS NOT NULL AND ('${detectionType}' = 'all' OR fraud_detection_rules->>'type' = '${detectionType}')`
      });
      if (!rulesResult || rulesResult.error) throw rulesResult?.error || new Error('Failed to detect anomalies');
      const data = {
        table_name: tableName,
        detection_type: detectionType,
        rules_found: rulesResult.data || [],
        note: 'Use these rules to construct anomaly detection queries'
      };
      console.log(`[Report] Found ${data.rules_found.length} fraud rules`);
      return data;
    }

    // ━━━ STAGE 2: verify_report (Updates Session) ━━━
    else if (toolName === 'verify_report') {
      const draftContent = args.draft_content;
      const claimedValues = args.claimed_values;

      console.log(`[Verify] ⚠️ VERIFICATION STAGE - Verifying draft with ${claimedValues.length} claimed values...`);

      // Check if AI collected data from required RPCs
      // Read RPC calls from execution_logs in the session
      const { data: sessionData } = await supabase
        .from('report_generation_sessions')
        .select('execution_logs')
        .eq('session_id', context.sessionId)
        .single();

      const executionLogs = sessionData?.execution_logs || [];
      const rpcCallsTracked = executionLogs
        .filter((log: any) => log.action === 'tool_success' && template.available_rpc_functions?.includes(log.tool_name))
        .map((log: any) => log.tool_name);

      const uniqueRPCsCalled = [...new Set(rpcCallsTracked)];
      console.log(`[Verify] RPCs called so far: ${uniqueRPCsCalled.join(', ')}`);

      const rpcCallsRequired = template.available_rpc_functions || [];
      const missingRPCs = rpcCallsRequired.filter((rpc: string) => !uniqueRPCsCalled.includes(rpc));

      if (missingRPCs.length > 0) {
        console.log(`[Verify] ❌ Missing required RPC calls: ${missingRPCs.join(', ')}`);

        // Update session: verification failed due to missing data collection
        await supabase
          .from('report_generation_sessions')
          .update({
            status: 'verifying',
            verification_started_at: new Date().toISOString(),
            verification_result: { status: 'failed', reason: 'missing_data_collection' },
            verification_issues: [{
              error: 'missing_data_collection',
              missing_rpcs: missingRPCs,
              message: `You did not call required RPC functions: ${missingRPCs.join(', ')}`
            }],
            verification_error: `Missing ${missingRPCs.length} required RPC calls`
          })
          .eq('session_id', context.sessionId);

        return {
          status: 'failed',
          verified: false,
          issues: [{
            error: 'missing_data_collection',
            missing_rpcs: missingRPCs,
            message: `CRITICAL ERROR: You did not collect actual data before writing the draft.`
          }],
          instruction: `CRITICAL: You skipped the data collection step!

You did NOT call these required RPC functions:
${missingRPCs.map((rpc: string) => `❌ ${rpc}`).join('\n')}

This means your draft is based on INVENTED DATA, not actual database data.

REQUIRED ACTIONS:
1. Go back to DRAFT stage
2. Call ALL required RPC functions:
${rpcCallsRequired.map((rpc: string, i: number) => `   ${i + 1}. ${rpc}`).join('\n')}
3. Use ONLY the data returned from these RPCs
4. Rewrite your draft with REAL data
5. Call verify_report again

DO NOT proceed until you have called ALL required RPCs.`
        };
      }

      // Update session: verification started
      await supabase
        .from('report_generation_sessions')
        .update({
          status: 'verifying',  // ✅ Update status
          verification_started_at: new Date().toISOString(),
          draft_content: draftContent,  // Save draft content
          draft_data: { claimed_values: claimedValues }  // ✅ Fixed: Use correct variable name
        })
        .eq('session_id', context.sessionId);

      // Get verification rules from template (already loaded in main function)
      const verificationConfig = template.verification_config;

      if (!verificationConfig?.enabled || !verificationConfig?.rules) {
        console.log('[Verify] Verification disabled or no rules configured');

        // Update session: verification skipped but mark as completed
        await supabase
          .from('report_generation_sessions')
          .update({
            status: 'draft_completed',  // ✅ Update status
            verification_result: { status: 'skipped', message: 'Verification disabled' },
            verified_content: draftContent,
            verification_completed_at: new Date().toISOString(),
            draft_completed_at: new Date().toISOString()  // Mark draft as completed
          })
          .eq('session_id', context.sessionId);

        return {
          status: 'skipped',
          message: 'Verification disabled or no rules configured. Proceeding to FORMAT stage.',
          verified: true
        };
      }

      const issues = [];
      const fieldsWithoutRules = [];

      // ✅ ProCo: Calculate verification attempts for progressive tolerance
      const verifyAttempts = executionLogs.filter((log: any) =>
        log.tool_name === 'verify_report'
      ).length;

      console.log(`[Verify] 📊 Verification attempt: ${verifyAttempts}`);

      // ✅ Max attempts check (prevent infinite loops)
      if (verifyAttempts >= 4) {
        console.log(`[Verify] 🚨 CRITICAL: Maximum verification attempts (4) exceeded`);

        await supabase
          .from('report_generation_sessions')
          .update({
            verification_result: { status: 'failed', reason: 'max_attempts_exceeded' },
            verification_issues: [{
              error: 'max_attempts_exceeded',
              attempts: verifyAttempts,
              message: 'AI failed to verify report after 4 attempts. Unable to use correct data from RPC functions.'
            }],
            verification_error: 'Maximum verification attempts (4) exceeded'
          })
          .eq('session_id', context.sessionId);

        return {
          status: 'failed',
          verified: false,
          max_attempts_exceeded: true,
          issues: [{
            error: 'max_attempts_exceeded',
            message: 'CRITICAL: 4번의 검증 시도가 모두 실패했습니다.'
          }],
          instruction: `🚨 치명적 오류: 4번의 검증 시도가 모두 실패했습니다.

이는 AI가 RPC 함수의 결과를 올바르게 읽지 못하고 있다는 의미입니다.
리포트 생성을 중단합니다.

마지막으로 제공된 정확한 값:
${claimedValues.map((c: any) => `- ${c.field}: 확인 필요`).join('\n')}`
        };
      }

      // Verify each claimed value against DB
      for (const claimed of claimedValues) {
        const rule = verificationConfig.rules.find((r: any) => r.field === claimed.field);
        if (!rule) {
          console.warn(`[Verify] ❌ No rule found for field: ${claimed.field}`);
          fieldsWithoutRules.push(claimed.field);
          continue;
        }

        let query = '';
        if (rule.type === 'sum_check') {
          query = `SELECT COALESCE(SUM(${rule.source_column}), 0) as actual_value FROM ${rule.source_table} WHERE company_id = '${context.company_id}'`;
        } else if (rule.type === 'count_check') {
          query = `SELECT COUNT(*) as actual_value FROM ${rule.source_table} WHERE company_id = '${context.company_id}'`;
        }

        if (rule.filter) {
          // verification_config already has quotes around {{start_date}} and {{end_date}}
          // Just replace the placeholders with the actual date values
          query += " " + rule.filter
            .replace(/\{\{start_date\}\}/g, context.dateRange.start_date)
            .replace(/\{\{end_date\}\}/g, context.dateRange.end_date);
        }

        console.log(`[Verify] Executing verification query for '${claimed.field}': ${query}`);
        const result = await supabase.rpc('execute_sql', { query_text: query });
        if (!result || result.error) {
          console.error(`[Verify] Database query failed for field ${claimed.field}:`, result?.error);
          throw result?.error || new Error(`Failed to verify field: ${claimed.field}`);
        }
        const dbResult = result.data;
        const actualValue = parseFloat(dbResult?.[0]?.actual_value || 0);
        const claimedValue = claimed.value;
        const deviation = actualValue === 0 ? (claimedValue === 0 ? 0 : 1) : Math.abs((claimedValue - actualValue) / actualValue);

        // ✅ ProCo: Progressive tolerance based on attempt number
        let tolerance = rule.tolerance || 0.01;
        if (verifyAttempts === 2) tolerance = 0.05;  // 2nd attempt: 5%
        if (verifyAttempts >= 3) tolerance = 0.10;   // 3rd attempt: 10%

        console.log(`[Verify] Field '${claimed.field}': claimed=${formatNumber(claimedValue)}, actual=${formatNumber(actualValue)}, deviation=${(deviation * 100).toFixed(2)}%, tolerance=${(tolerance * 100).toFixed(0)}%`);

        if (deviation > tolerance) {
          // ✅ Source Tracing: Find which RPC should provide this data
          let rpcHint = '';
          let rpcSourceName = '';

          // Map fields to their source RPC functions
          if (rule.field.includes('transaction')) {
            rpcSourceName = 'get_cpa_audit_report';
          } else if (rule.field.includes('account') || rule.field.includes('amount')) {
            rpcSourceName = 'get_account_summary_by_period';
          }

          if (rpcSourceName) {
            const rpcLog = executionLogs.find((log: any) =>
              log.tool_name === rpcSourceName && log.action === 'tool_success'
            );
            if (rpcLog) {
              rpcHint = `\n\n💡 데이터 출처: RPC 함수 '${rpcSourceName}'의 반환 결과를 사용하세요. 그 결과에 실제 값 ${formatNumber(actualValue)}이(가) 있습니다. 다른 값을 만들어내지 마세요!`;
              console.log(`[Verify] 💡 Source hint added for '${claimed.field}': Use RPC '${rpcSourceName}'`);
            } else {
              console.warn(`[Verify] ⚠️ RPC '${rpcSourceName}' was not called but is needed for '${claimed.field}'`);
            }
          }

          // ✅ Progressive feedback based on attempt number
          let attemptMessage = '';
          if (verifyAttempts === 1) {
            attemptMessage = `\n⚠️ 첫 번째 검증 실패 (허용 오차: ${(tolerance * 100).toFixed(0)}%)`;
          } else if (verifyAttempts === 2) {
            attemptMessage = `\n⚠️⚠️ 두 번째 검증 실패 (허용 오차를 ${(tolerance * 100).toFixed(0)}%로 완화했지만 여전히 초과)`;
          } else if (verifyAttempts >= 3) {
            attemptMessage = `\n🚨🚨🚨 세 번째 검증 실패 (허용 오차를 ${(tolerance * 100).toFixed(0)}%로 완화했지만 여전히 초과) - 이번이 마지막 기회입니다!`;
          }

          console.log(`[Verify] ❌ Verification failed for '${claimed.field}': deviation ${(deviation * 100).toFixed(2)}% > tolerance ${(tolerance * 100).toFixed(0)}%`);

          issues.push({
            field: rule.field,
            field_label: rule.field_label,
            claimed_value: claimedValue,
            actual_value: actualValue,
            deviation_percent: (deviation * 100).toFixed(2),
            attempt_number: verifyAttempts,
            tolerance_used: (tolerance * 100).toFixed(0) + '%',
            rpc_source: rpcSourceName || 'unknown',
            message: `${rule.field_label}: You wrote "${formatNumber(claimedValue)}" but actual DB value is "${formatNumber(actualValue)}".${attemptMessage}${rpcHint}\n\n✅ 정확히 이 값으로 수정하세요: ${formatNumber(actualValue)}`
          });
        } else {
          console.log(`[Verify] ✅ Verification passed for '${claimed.field}'`);
        }
      }

      // Check if there are fields without rules - this indicates AI is using unverifiable data
      if (fieldsWithoutRules.length > 0) {
        console.log(`[Verify] ❌ Found ${fieldsWithoutRules.length} fields without verification rules`);

        // Update session: verification failed due to unverifiable fields
        await supabase
          .from('report_generation_sessions')
          .update({
            verification_result: { status: 'failed', reason: 'unverifiable_fields' },
            verification_issues: [{
              error: 'unverifiable_fields',
              fields: fieldsWithoutRules,
              message: `You used ${fieldsWithoutRules.length} fields that cannot be verified: ${fieldsWithoutRules.slice(0, 10).join(', ')}${fieldsWithoutRules.length > 10 ? '...' : ''}`
            }],
            verification_error: `Found ${fieldsWithoutRules.length} unverifiable fields`
          })
          .eq('session_id', context.sessionId);

        return {
          status: 'failed',
          verified: false,
          issues: [{
            error: 'unverifiable_fields',
            fields_without_rules: fieldsWithoutRules,
            message: `CRITICAL ERROR: You claimed ${fieldsWithoutRules.length} values that cannot be verified against the database.`
          }],
          instruction: `CRITICAL: Your draft contains ${fieldsWithoutRules.length} unverifiable fields. This usually means you are INVENTING DATA instead of using actual database data.

REQUIRED ACTIONS:
1. You MUST call the available RPC functions FIRST:
   - get_account_summary_by_period: Get actual financial data
   - get_cpa_audit_report: Get actual transaction details
2. Use ONLY the data returned from these functions
3. Do NOT invent employee names, transaction amounts, or any other data
4. Only use fields that have verification rules: ${verificationConfig.rules.map((r: any) => r.field).join(', ')}

Invalid fields you used: ${fieldsWithoutRules.slice(0, 20).join(', ')}${fieldsWithoutRules.length > 20 ? ` and ${fieldsWithoutRules.length - 20} more` : ''}

Start over from DRAFT stage and collect REAL data.`
        };
      }

      if (issues.length > 0) {
        console.log(`[Verify] ❌ Found ${issues.length} discrepancies (Attempt ${verifyAttempts})`);
        console.log(`[Verify] Issues details:`);
        issues.forEach((issue: any, index: number) => {
          console.log(`[Verify]   ${index + 1}. ${issue.field}: claimed=${formatNumber(issue.claimed_value)}, actual=${formatNumber(issue.actual_value)}, deviation=${issue.deviation_percent}%, tolerance=${issue.tolerance_used}`);
        });

        // Update session: verification failed
        await supabase
          .from('report_generation_sessions')
          .update({
            verification_result: {
              status: 'failed',
              attempt: verifyAttempts,
              total_issues: issues.length
            },
            verification_issues: issues,
            verification_error: `Attempt ${verifyAttempts}: Found ${issues.length} hallucinations`
          })
          .eq('session_id', context.sessionId);

        return {
          status: 'failed',
          verified: false,
          attempt: verifyAttempts,
          issues: issues,
          instruction: `CRITICAL: Your draft contains ${issues.length} incorrect value(s). This is attempt ${verifyAttempts}/4.

You MUST rewrite the draft with the EXACT values shown below. Do NOT round or modify these values.

${issues.map((issue: any, i: number) => `${i + 1}. ${issue.message}`).join('\n\n')}

Call verify_report again with corrected values. Do NOT proceed to format_report until verification passes.`
        };
      }

      console.log(`[Verify] ✅ All values verified - PROCEED TO FORMAT STAGE`);

      // Update session: verification passed
      await supabase
        .from('report_generation_sessions')
        .update({
          status: 'verified',  // ✅ Update status
          verification_result: { status: 'passed', verified_count: claimedValues.length },
          verification_issues: null,  // ✅ Clear previous issues when verification passes
          verification_error: null,   // ✅ Clear previous error when verification passes
          verified_content: draftContent,
          verification_completed_at: new Date().toISOString(),
          draft_completed_at: new Date().toISOString()  // Mark draft as completed
        })
        .eq('session_id', context.sessionId);

      return {
        status: 'passed',
        verified: true,
        message: 'All claimed values match actual database values. You MUST now call format_report tool.'
      };
    }

    // ━━━ STAGE 3: format_report (Updates Session) ━━━
    else if (toolName === 'format_report') {
      const verifiedContent = args.verified_content;

      console.log(`[Format] ⚠️ FORMATTING STAGE - Formatting report (${verifiedContent.length} chars)...`);

      // Update session: formatting started
      await supabase
        .from('report_generation_sessions')
        .update({
          status: 'formatting',  // ✅ Update status
          formatting_started_at: new Date().toISOString()
        })
        .eq('session_id', context.sessionId);

      // Get format config from template (already loaded in main function)
      const formatConfig = template.format_config || {};
      const templateName = template.template_name || '';
      const jsonFields = formatConfig.output_structure?.json_fields || [];
      const sections = formatConfig.sections || [];
      const maxLength = 3500;  // Always allow 3500 characters
      const numberFormat = formatConfig.number_format || 'korean_abbreviated';
      const style = formatConfig.style || 'mobile_friendly';

      console.log(`[Format] Required JSON fields: ${jsonFields.join(', ')}`);
      console.log(`[Format] Required sections: ${sections.join(', ')}`);

      // Update session: formatting completed
      await supabase
        .from('report_generation_sessions')
        .update({
          format_metadata: {
            json_fields: jsonFields,
            sections: sections,
            max_length: maxLength,
            number_format: numberFormat,
            style: style,
            template_name: templateName,
            template_header: formatConfig.output_structure?.markdown_template || `📊 ${templateName}`
          },
          formatting_completed_at: new Date().toISOString()
        })
        .eq('session_id', context.sessionId);

      return {
        instruction: '⚠️ FINAL STEP: The workflow system has updated your session to OUTPUT stage. Your NEXT response MUST be ONLY the JSON output (no explanation, no markdown code blocks).',
        requirements: {
          output_format: {
            type: 'object',
            required_fields: ['structured_data', 'markdown_report'],
            description: 'You MUST output a JSON object with exactly two fields'
          },
          structured_data: {
            required_fields: jsonFields,
            description: 'Extract key metrics as JSON object. Include all fields listed.',
            example: jsonFields.reduce((obj: any, field: string) => {
              obj[field] = field.includes('count') ? 150 : 48000000;
              return obj;
            }, {})
          },
          markdown_report: {
            style: style,
            max_length: maxLength,
            sections: sections,
            number_format: numberFormat,
            template_header: formatConfig.output_structure?.markdown_template || `📊 ${templateName}`,
            formatting_rules: [
              `Maximum ${maxLength} characters - USE ALL AVAILABLE SPACE`,
              `Include sections: ${sections.join(', ')}`,
              `Number format: ${numberFormat}`,
              `INCLUDE ALL DATA from verified_content - do NOT truncate`,
              `Show ALL employee transactions, ALL stores, ALL details`,
              style === 'mobile_friendly' ? 'Use short paragraphs, bullet points' : '',
              style === 'alert' ? 'Emphasize urgency, use warning emoji' : ''
            ].filter(Boolean)
          }
        },
        context: {
          date: context.dateRange.display,
          template_name: templateName
        },
        next_step: '⚠️ YOUR NEXT MESSAGE MUST BE: JSON object with structured_data and markdown_report fields. Output ONLY the JSON, no explanation, no markdown code blocks. Include ALL details from your verified draft.'
      };
    }

    // ━━━ RPC Functions ━━━
    else if (template.available_rpc_functions?.includes(toolName)) {
      console.log(`[Report] Calling RPC: ${toolName}`);

      const rpcParams: any = {};
      for (const [key, value] of Object.entries(args)) {
        rpcParams[`p_${key}`] = value;
      }
      const result = await supabase.rpc(toolName, rpcParams);
      if (!result || result.error) throw result?.error || new Error(`Failed to execute RPC: ${toolName}`);
      console.log(`[Report] RPC ${toolName} returned ${Array.isArray(result.data) ? result.data.length : 1} record(s)`);
      return result.data;
    }

    else {
      throw new Error(`Unknown tool: ${toolName}`);
    }
  } catch (error: any) {
    console.error(`[Report] Tool error:`, error);
    throw error;
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MAIN FUNCTION
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  const startTime = Date.now();

  try {
    const { subscription_id, template_id, company_id, store_id, user_id, timezone, scheduled_time } = await req.json();

    console.log(`[Report] ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`);
    console.log(`[Report] Starting report generation with SESSION-BASED 3-Stage Workflow`);
    console.log(`[Report] Subscription: ${subscription_id}`);
    console.log(`[Report] Template: ${template_id}`);
    console.log(`[Report] Company: ${company_id}`);
    console.log(`[Report] Store: ${store_id || 'ALL'}`);
    console.log(`[Report] User: ${user_id}`);
    console.log(`[Report] Timezone: ${timezone}`);

    if (!subscription_id || !template_id || !company_id || !user_id) {
      throw new Error('Missing required fields: subscription_id, template_id, company_id, user_id');
    }

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    );

    // ━━━ 1. Load Template ━━━
    console.log(`[Report] Loading template...`);
    const { data: template, error: templateError } = await supabase
      .from('report_templates')
      .select(`
        template_id, template_name, template_code, description, frequency,
        ai_prompt_template, ai_system_prompt, available_rpc_functions, available_tables,
        verification_config, format_config
      `)
      .eq('template_id', template_id)
      .eq('is_active', true)
      .single();

    if (templateError || !template) {
      throw new Error(`Template not found or inactive: ${template_id}`);
    }

    console.log(`[Report] Template loaded: ${template.template_name}`);
    console.log(`[Report] Frequency: ${template.frequency}`);
    console.log(`[Report] Available RPCs: ${template.available_rpc_functions?.length || 0}`);
    console.log(`[Report] Available Tables: ${template.available_tables?.length || 0}`);

    // ━━━ 2. Load User Language ━━━
    console.log(`[Report] Loading user language...`);
    const { data: userData } = await supabase
      .from('users')
      .select(`
        user_id,
        user_language:languages!users_user_language_fkey (language_code, language_name, native_name)
      `)
      .eq('user_id', user_id)
      .single();

    const userLanguage = userData?.user_language?.language_code || 'en';
    const languageName = userData?.user_language?.native_name || 'English';
    console.log(`[Report] User language: ${userLanguage} (${languageName})`);

    // ━━━ 3. Calculate Date Range ━━━
    const dateRange = calculateDateRange(template.frequency, timezone, scheduled_time);
    console.log(`[Report] Date range: ${dateRange.display}`);

    // ━━━ 4. Create Session Record ━━━
    console.log(`[Report] Creating session record...`);
    const { data: session, error: sessionError } = await supabase
      .from('report_generation_sessions')
      .insert({
        company_id,
        store_id,
        template_id,
        report_date: dateRange.start_date,
        status: 'drafting',  // ✅ Fixed: Use 'drafting' instead of 'in_progress'
        draft_started_at: new Date().toISOString()
      })
      .select()
      .single();

    if (sessionError || !session) {
      throw new Error(`Failed to create session: ${sessionError?.message}`);
    }

    const sessionId = session.session_id;
    console.log(`[Report] ✅ Session created: ${sessionId}`);

    // ━━━ 5. Build Dynamic Tools ━━━
    let DYNAMIC_TOOLS = [...BASE_TOOLS];

    if (template.available_rpc_functions && Array.isArray(template.available_rpc_functions) && template.available_rpc_functions.length > 0) {
      console.log(`[Report] Loading RPC metadata for ${template.available_rpc_functions.length} functions...`);
      const { data: rpcMetadata } = await supabase
        .from('rpc_function_metadata')
        .select('rpc_name, description, parameters')
        .in('rpc_name', template.available_rpc_functions);

      if (rpcMetadata && rpcMetadata.length > 0) {
        for (const rpc of rpcMetadata) {
          DYNAMIC_TOOLS.push({
            type: "function",
            function: {
              name: rpc.rpc_name,
              description: rpc.description,
              parameters: rpc.parameters
            }
          });
          console.log(`[Report] Added RPC tool: ${rpc.rpc_name}`);
        }
      }
    }

    console.log(`[Report] Total tools available: ${DYNAMIC_TOOLS.length}`);

    // ━━━ 6. Build System Prompt ━━━
    const rpcList = template.available_rpc_functions?.map((f: string) => `- ${f}`).join('\n') || '(None)';
    const tableList = template.available_tables?.map((t: string) => `- ${t}`).join('\n') || '(None)';

    const FULL_SYSTEM_PROMPT = `${BASE_SYSTEM_PROMPT}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 TEMPLATE CONFIGURATION:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Template: ${template.template_name}
Frequency: ${template.frequency}
Report Period: ${dateRange.display}

Available RPC Functions:
${rpcList}

Available Tables:
${tableList}

⚠️ IMPORTANT:
- You can ONLY use the RPC functions listed above
- You can ONLY query the tables listed above
- ALWAYS include company_id filter in queries
- Include store_id filter if provided: ${store_id || 'N/A (all stores)'}

${template.ai_system_prompt || ''}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
`;

    // ━━━ 7. Build User Prompt ━━━
    const userPrompt = replaceTemplateVariables(template.ai_prompt_template, {
      date: dateRange.display,
      store_name: store_id ? 'specific store' : '전체 매장',
      company_name: ''
    });

    const contextString = `
Context:
- company_id: ${company_id}
- store_id: ${store_id || 'NULL (all stores)'}
- date_range: ${dateRange.start_date} to ${dateRange.end_date}
- timezone: ${timezone}
- user_language: ${userLanguage}
- session_id: ${sessionId}

CRITICAL: Write the ENTIRE report in "${userLanguage}" language (${languageName}).
${userLanguage === 'en' ? 'Use English for ALL text in the report.' : ''}
${userLanguage === 'ko' ? 'Use Korean (한국어) for ALL text in the report.' : ''}
${userLanguage === 'vi' ? 'Use Vietnamese (Tiếng Việt) for ALL text in the report.' : ''}
`;

    console.log(`[Report] User prompt: ${userPrompt.substring(0, 100)}...`);

    // ━━━ 8. AI Iteration Loop with Session Tracking ━━━
    const messages: any[] = [
      {
        role: 'user',
        content: userPrompt + '\n\n' + contextString
      }
    ];

    let iterationCount = 0;
    const maxIterations = 20;  // Increased for session-based workflow
    let finalReport = '';

    while (iterationCount < maxIterations) {
      iterationCount++;

      // Read current session state
      const { data: currentSession } = await supabase
        .from('report_generation_sessions')
        .select('*')
        .eq('session_id', sessionId)
        .single();

      const currentStage = determineCurrentStage(currentSession);

      console.log(`[Report] ━━━ Iteration ${iterationCount}/${maxIterations} - Stage: ${currentStage.toUpperCase()} ━━━`);

      // Log iteration start
      await addLogEntry(supabase, sessionId, {
        iteration: iterationCount,
        stage: currentStage,
        action: 'iteration_start',
        details: `Starting iteration ${iterationCount}, stage: ${currentStage}`
      });

      // Build stage-specific prompt
      const stagePrompt = buildStagePrompt(currentSession, template);

      const response = await callOpenRouter(
        [
          { role: 'system', content: FULL_SYSTEM_PROMPT + '\n\n' + stagePrompt },
          ...messages
        ],
        DYNAMIC_TOOLS,
        0.3
      );

      const choice = response.choices[0];

      // No tool calls = AI is trying to output text
      if (!choice.message.tool_calls) {
        const outputText = choice.message.content;

        // Check if current stage allows text output
        if (currentStage === 'output') {
          // ✅ Allowed: All stages completed
          finalReport = outputText;
          console.log(`[Report] ✅ Final JSON output received (${finalReport.length} chars)`);

          // Log final output received
          await addLogEntry(supabase, sessionId, {
            iteration: iterationCount,
            stage: currentStage,
            action: 'final_output_received',
            details: `Final JSON output received (${finalReport.length} chars)`
          });

          break;
        } else {
          // ❌ Rejected: Premature output attempt
          console.log(`[Report] ⚠️ REJECTED: AI tried to output text in ${currentStage} stage`);

          messages.push(choice.message);
          messages.push({
            role: 'user',
            content: `
❌ ERROR: Workflow Violation Detected

You attempted to output text while in ${currentStage.toUpperCase()} stage.
The workflow system does NOT allow text output until ALL stages are completed.

Current Session Status:
- Draft: ${currentSession.draft_completed_at ? '✓ COMPLETED' : '✗ NOT COMPLETED'}
- Verification: ${currentSession.verification_completed_at ? '✓ COMPLETED' : '✗ NOT COMPLETED'}
- Formatting: ${currentSession.formatting_completed_at ? '✓ COMPLETED' : '✗ NOT COMPLETED'}

REQUIRED ACTION:
${currentStage === 'draft' ? '→ Call verify_report tool with your draft content and claimed values' : ''}
${currentStage === 'verify' ? '→ Call verify_report tool NOW (this is mandatory)' : ''}
${currentStage === 'format' ? '→ Call format_report tool NOW (this is mandatory)' : ''}

You CANNOT skip workflow stages. Follow the stage instructions.
            `.trim()
          });
          continue;
        }
      }

      // Execute tool
      const toolCall = choice.message.tool_calls[0];
      const toolName = toolCall.function.name;
      let toolResult;
      let toolError = null;

      // Log tool execution
      await addLogEntry(supabase, sessionId, {
        iteration: iterationCount,
        stage: currentStage,
        action: 'tool_execution',
        tool_name: toolName,
        details: `Executing ${toolName}`
      });

      try {
        toolResult = await executeToolCall(toolCall, supabase, template, {
          company_id,
          store_id,
          dateRange,
          template_id,
          sessionId,
          iteration: iterationCount,
          currentStage
        });

        // Log tool success
        await addLogEntry(supabase, sessionId, {
          iteration: iterationCount,
          stage: currentStage,
          action: 'tool_success',
          tool_name: toolName,
          details: `${toolName} completed successfully`
        });
      } catch (error: any) {
        toolError = error.message;
        console.error(`[Report] Tool error:`, toolError);

        // Log tool error
        await addLogEntry(supabase, sessionId, {
          iteration: iterationCount,
          stage: currentStage,
          action: 'tool_error',
          tool_name: toolName,
          details: `${toolName} failed: ${toolError}`,
          error: toolError
        });
      }

      // Add to conversation
      messages.push(choice.message);

      if (toolError) {
        messages.push({
          role: 'tool',
          tool_call_id: toolCall.id,
          name: toolCall.function.name,
          content: JSON.stringify({
            error: toolError,
            hint: 'Check your query and try again. Use get_table_schema and get_column_meanings to understand structure.'
          })
        });
      } else {
        messages.push({
          role: 'tool',
          tool_call_id: toolCall.id,
          name: toolCall.function.name,
          content: JSON.stringify(toolResult || [])
        });
      }
    }

    if (!finalReport) {
      throw new Error(`Failed to generate report after ${maxIterations} iterations`);
    }

    const processingTime = Date.now() - startTime;

    // ━━━ 9. Parse Final Report (JSON + Markdown) ━━━
    let structuredData = {};
    let markdownReport = finalReport;

    try {
      const parsed = JSON.parse(finalReport);
      if (parsed.structured_data && parsed.markdown_report) {
        structuredData = parsed.structured_data;
        markdownReport = parsed.markdown_report;
        console.log(`[Report] ✅ Parsed structured output`);
        console.log(`[Report] JSON fields: ${Object.keys(structuredData).join(', ')}`);
      }
    } catch (e) {
      console.log(`[Report] ⚠️ Plain markdown output (no structured data)`);
    }

    const summary = markdownReport.substring(0, 200).trim() + (markdownReport.length > 200 ? '...' : '');
    const reportTitle = `${template.template_name} - ${dateRange.display}`;

    console.log(`[Report] Processing completed in ${processingTime}ms`);
    console.log(`[Report] Report length: ${markdownReport.length} chars`);

    // ━━━ 10. Update Session - Final ━━━
    console.log(`[Report] Updating session to completed...`);
    const { error: sessionUpdateError } = await supabase
      .from('report_generation_sessions')
      .update({
        final_content: markdownReport,
        final_title: reportTitle,
        status: 'completed',
        completed_at: new Date().toISOString()
        // total_processing_time_ms는 GENERATED COLUMN이므로 자동 계산됨
      })
      .eq('session_id', sessionId);

    if (sessionUpdateError) {
      console.error(`[Report] Failed to update session:`, sessionUpdateError);
      // Don't throw - continue to save log even if session update fails
    } else {
      console.log(`[Report] ✅ Session updated to completed`);
    }

    // ━━━ 11. Save Log ━━━
    console.log(`[Report] Saving log...`);
    const { error: logError } = await supabase
      .from('report_notification_logs')
      .insert({
        subscription_id,
        user_id,
        scheduled_time: scheduled_time || new Date().toISOString(),
        sent_at: new Date().toISOString(),
        report_title: reportTitle,
        report_content: markdownReport,
        report_data: {
          template_id,
          company_id,
          store_id,
          date_range: dateRange,
          iterations: iterationCount,
          user_language: userLanguage,
          structured_data: structuredData,
          session_id: sessionId
        },
        status: 'sent',
        ai_model: 'x-ai/grok-code-fast-1',
        processing_time_ms: processingTime,
        delivery_channels: ['push']
      });

    if (logError) {
      console.error(`[Report] Failed to save log:`, logError);
      // Don't throw - continue to send notification even if log fails
    } else {
      console.log(`[Report] ✅ Log saved`);
    }

    // ━━━ 12. Send FCM Notification ━━━
    console.log(`[Report] Sending FCM notification...`);
    try {
      const { data: notification } = await supabase
        .from('notifications')
        .insert({
          user_id,
          title: reportTitle,
          body: summary,
          category: 'report',
          data: {
            subscription_id,
            template_id,
            report_date: dateRange.start_date,
            session_id: sessionId
          }
        })
        .select()
        .single();

      console.log(`[Report] Notification created: ${notification.id}`);

      const fcmResponse = await fetch(
        `${Deno.env.get('SUPABASE_URL')}/functions/v1/fcm-native`,
        {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')}`,
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({ record: notification })
        }
      );

      if (fcmResponse.ok) {
        const fcmResult = await fcmResponse.json();
        console.log('[Report] ✅ FCM notification sent:', fcmResult);
      }
    } catch (fcmError) {
      console.error('[Report] FCM error:', fcmError);
    }

    console.log(`[Report] ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`);

    // ━━━ 13. Return Response ━━━
    return new Response(
      JSON.stringify({
        success: true,
        session_id: sessionId,
        report: {
          title: reportTitle,
          content: markdownReport,
          summary,
          period: dateRange,
          language: userLanguage,
          structured_data: structuredData
        },
        metadata: {
          subscription_id,
          template_id,
          iterations: iterationCount,
          processing_time_ms: processingTime,
          ai_model: 'x-ai/grok-code-fast-1',
          user_language: userLanguage,
          session_id: sessionId
        }
      }),
      {
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      }
    );
  } catch (error: any) {
    console.error('[Report] ❌ Fatal error:', error);

    return new Response(
      JSON.stringify({
        success: false,
        error: error.message
      }),
      {
        status: 500,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      }
    );
  }
});
