import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

// =============================================================================
// AI Respond User v28 - Added deprecated_columns to prompt from Knowledge Graph
// =============================================================================

const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization',
  'Content-Type': 'text/event-stream',
  'Cache-Control': 'no-cache',
  'Connection': 'keep-alive'
};

function classifyError(errorMsg: string): { type: string; detail: any } {
  const msg = errorMsg.toLowerCase();
  const colMatch = errorMsg.match(/column "([^"]+)" does not exist/i);
  if (colMatch) return { type: 'column_not_found', detail: { column: colMatch[1] } };
  const tableMatch = errorMsg.match(/relation "([^"]+)" does not exist/i);
  if (tableMatch) return { type: 'table_not_found', detail: { table: tableMatch[1] } };
  if (msg.includes('syntax error')) {
    const nearMatch = errorMsg.match(/at or near "([^"]+)"/i);
    return { type: 'syntax_error', detail: { near: nearMatch?.[1] } };
  }
  if (msg.includes('timeout')) return { type: 'timeout', detail: {} };
  if (msg.includes('group by')) return { type: 'group_by_error', detail: {} };
  if (msg.includes('order by')) return { type: 'order_by_error', detail: {} };
  return { type: 'unknown', detail: { raw: errorMsg.substring(0, 300) } };
}

function extractTables(sql: string): string[] {
  const tables: Set<string> = new Set();
  const patterns = [/FROM\s+([a-z_][a-z0-9_]*)/gi, /JOIN\s+([a-z_][a-z0-9_]*)/gi];
  for (const pattern of patterns) {
    let match;
    while ((match = pattern.exec(sql)) !== null) {
      const table = match[1].toLowerCase();
      if (!['select', 'where', 'and', 'or', 'on', 'as'].includes(table)) tables.add(table);
    }
  }
  return Array.from(tables);
}

function sendSSE(controller: ReadableStreamDefaultController, data: any) {
  const encoder = new TextEncoder();
  controller.enqueue(encoder.encode(`data: ${JSON.stringify(data)}\n\n`));
}

async function getEmbedding(text: string, apiKey: string): Promise<number[]> {
  const response = await fetch('https://api.openai.com/v1/embeddings', {
    method: 'POST',
    headers: { 'Authorization': `Bearer ${apiKey}`, 'Content-Type': 'application/json' },
    body: JSON.stringify({ model: 'text-embedding-3-small', input: text })
  });
  if (!response.ok) throw new Error(`OpenAI Embedding Error: ${response.statusText}`);
  const data = await response.json();
  return data.data[0].embedding;
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: CORS_HEADERS });
  }

  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  );

  const stream = new ReadableStream({
    async start(controller) {
      const startTime = Date.now();
      let sqlLogId: string | null = null;
      let sessionId: string = '';
      let userLanguage = 'en';
      let companyTimezone = 'UTC';

      try {
        const body = await req.json();
        const { question: rawQuestion, company_id, user_id, store_id, session_id, client_info } = body;
        if (!company_id || !user_id || !rawQuestion) throw new Error('company_id, user_id, question required');

        const question = rawQuestion.trim();
        sessionId = session_id || crypto.randomUUID();
        console.log(`[ai_respond_user v28] Q: ${question.substring(0, 50)}...`);

        // User context
        const userContextResult = await supabase.rpc('execute_sql', {
          query_text: `SELECT COALESCE(u.first_name, '') || ' ' || COALESCE(u.last_name, '') as display_name,
                       COALESCE(l.language_code, 'en') as user_language, COALESCE(r.role_type, 'employee') as role_type,
                       c.timezone as company_timezone FROM users u
                       LEFT JOIN languages l ON l.language_id = u.user_language
                       LEFT JOIN user_roles ur ON ur.user_id = u.user_id AND (ur.is_deleted = false OR ur.is_deleted IS NULL)
                       LEFT JOIN roles r ON r.role_id = ur.role_id AND r.company_id = '${company_id}'
                       LEFT JOIN companies c ON c.company_id = '${company_id}'
                       WHERE u.user_id = '${user_id}' LIMIT 1`
        });
        const userContext = userContextResult.data?.[0] || { display_name: 'User', user_language: 'en', role_type: 'employee', company_timezone: 'UTC' };
        userLanguage = userContext.user_language || 'en';
        companyTimezone = userContext.company_timezone || 'UTC';
        const roleType = userContext.role_type;
        const displayName = userContext.display_name?.trim() || 'User';

        // Chat history
        const historyResult = await supabase.from('ai_chat_history').select('message').eq('session_id', sessionId).order('created_at', { ascending: true }).limit(10);
        const chatHistory = historyResult.data?.map(h => ({ role: h.message.role as string, content: h.message.content as string })) || [];

        // =====================================================================
        // PHASE 1: EMBEDDING SEARCH
        // =====================================================================
        const contextStart = Date.now();
        const openaiKey = Deno.env.get('chatgptAPIKey');
        let matchedConcepts: string[] = [];
        let startNodes: string[] = [];

        if (openaiKey) {
          try {
            const questionEmbedding = await getEmbedding(question, openaiKey);
            const vectorStr = '[' + questionEmbedding.join(',') + ']';

            const searchResult = await supabase.rpc('execute_sql', {
              query_text: `SELECT embedding_id, source_type, source_id, text_content, concept_id,
                           1 - (embedding <=> '${vectorStr}'::vector) AS similarity
                           FROM ontology_embeddings
                           WHERE is_active = true AND embedding IS NOT NULL
                             AND 1 - (embedding <=> '${vectorStr}'::vector) >= 0.3
                           ORDER BY similarity DESC LIMIT 10`
            });

            if (searchResult.data && !searchResult.error) {
              matchedConcepts = searchResult.data.map((r: any) => r.text_content);

              startNodes = searchResult.data
                .filter((r: any) => r.source_type === 'concept' || r.source_type === 'synonym')
                .map((r: any) => {
                  if (r.source_type === 'synonym') {
                    return r.text_content;
                  } else {
                    const colonIndex = r.text_content.indexOf(':');
                    if (colonIndex > 0) {
                      return r.text_content.substring(0, colonIndex).trim();
                    }
                    return r.text_content;
                  }
                })
                .slice(0, 5);
              console.log(`[v28] Embedding matched: ${matchedConcepts.slice(0, 3).map(s => s.substring(0, 30)).join(', ')}`);
              console.log(`[v28] Start nodes: ${startNodes.join(', ')}`);
            }
          } catch (err: any) {
            console.error(`[v28] Embedding error: ${err.message}`);
          }
        }

        // =====================================================================
        // PHASE 2: KNOWLEDGE GRAPH TRAVERSAL
        // =====================================================================
        let graphPaths: any = null;

        if (startNodes.length > 0) {
          try {
            const pathResult = await supabase.rpc('get_ontology_paths_v2', {
              p_start_node_names: startNodes,
              p_max_depth: 3
            });
            if (pathResult.data && !pathResult.error) {
              graphPaths = pathResult.data;
              // v28: Now also logging deprecated_columns count
              console.log(`[v28] Graph: tables=${graphPaths.main_tables?.length || 0}, deprecated=${graphPaths.deprecated_columns?.length || 0}, constraints=${graphPaths.constraints?.length || 0}`);
            }
          } catch (err: any) {
            console.error(`[v28] Graph error: ${err.message}`);
          }
        }

        const contextLoadTime = Date.now() - contextStart;

        // =====================================================================
        // PHASE 3: BUILD CONTEXT (v28: Added deprecated_columns)
        // =====================================================================
        const formatGraphContext = () => {
          if (!graphPaths) return '';
          let result = '\n## KNOWLEDGE GRAPH CONTEXT (MUST FOLLOW!)\n';

          if (graphPaths.main_tables?.length > 0) {
            result += `### Primary Tables: ${graphPaths.main_tables.join(', ')}\n`;
          }

          // v28: DEPRECATED COLUMNS FIRST - Most critical for preventing errors!
          if (graphPaths.deprecated_columns?.length > 0) {
            result += `\n### ⛔⛔⛔ DEPRECATED COLUMNS - NEVER USE THESE! ⛔⛔⛔\n`;
            for (const col of graphPaths.deprecated_columns) {
              result += `- ${col.table}.${col.column}: ${col.warning}\n`;
            }
          }

          if (graphPaths.main_columns?.length > 0) {
            result += `\n### Available Columns (USE THESE):\n`;
            for (const col of graphPaths.main_columns.slice(0, 20)) {
              result += `- ${col.table}.${col.column} (${col.type})${col.hint ? `: ${col.hint.substring(0, 150)}` : ''}\n`;
            }
          }

          if (graphPaths.calculation_rules?.length > 0) {
            result += `\n### Calculation Rules:\n`;
            for (const calc of graphPaths.calculation_rules) {
              result += `- ${calc.rule}${calc.formula ? ` (${calc.formula})` : ''}\n`;
            }
          }

          if (graphPaths.join_paths?.length > 0) {
            result += `\n### Join Paths:\n`;
            for (const jp of graphPaths.join_paths.slice(0, 5)) {
              if (jp.from_col && jp.to_col) {
                result += `- ${jp.from}.${jp.from_col} = ${jp.to}.${jp.to_col}\n`;
              }
            }
          }

          if (graphPaths.constraints?.length > 0) {
            result += `\n### Constraints (CRITICAL!):\n`;
            for (const c of graphPaths.constraints.slice(0, 10)) {
              result += `- ${c.name}: ${c.hint?.substring(0, 300) || c.rule}\n`;
            }
          }

          return result;
        };

        // Load essential columns (fallback)
        const essentialColumnsRes = await supabase.rpc('execute_sql', {
          query_text: `SELECT column_name, data_type, ai_usage_hint, is_deprecated
                       FROM ontology_columns WHERE table_name = 'v_shift_request_ai' AND is_active = true
                       ORDER BY is_deprecated ASC, column_name LIMIT 20`
        });
        const essentialColumns = essentialColumnsRes.data || [];

        const formatColumns = () => {
          let result = '\n## v_shift_request_ai COLUMNS\n';
          const active = essentialColumns.filter((c: any) => !c.is_deprecated);
          const deprecated = essentialColumns.filter((c: any) => c.is_deprecated);

          const keyColumns = ['user_name', 'user_id', 'store_name', 'start_time_utc', 'actual_start_time_utc',
                              'problem_details_v2', 'is_approved', 'salary_amount', 'total_pay_with_bonus_v2'];
          result += '### Key:\n';
          for (const col of active.filter((c: any) => keyColumns.includes(c.column_name)).slice(0, 8)) {
            result += `- ${col.column_name} (${col.data_type})`;
            if (col.ai_usage_hint) {
              result += `: ${col.ai_usage_hint.substring(0, 200)}`;
            }
            result += '\n';
          }
          if (deprecated.length > 0) {
            result += '### DEPRECATED (NEVER USE!):\n';
            for (const col of deprecated.slice(0, 3)) {
              result += `- ${col.column_name}\n`;
            }
          }
          return result;
        };

        const sqlSystemPrompt = `You are an expert PostgreSQL generator for LuxApp.

## USER CONTEXT
- company_id: '${company_id}'
- user_id: '${user_id}'
- role_type: ${roleType}
- store_id: ${store_id ? `'${store_id}'` : 'null'}
- language: ${userLanguage}
- timezone: '${companyTimezone}'

## TIMEZONE RULE (CRITICAL)
ALWAYS use dynamic timezone:
AT TIME ZONE (SELECT timezone FROM companies WHERE company_id = '${company_id}')

NEVER hardcode 'Asia/Ho_Chi_Minh'!
${formatGraphContext()}
${formatColumns()}

## SQL RULES
1. ALWAYS filter: company_id = '${company_id}'
2. For v_shift_request_ai: NO is_deleted filter
3. Use user_name from v_shift_request_ai directly (DO NOT join users table for names)
4. FOLLOW the Required Columns and Calculation Rules from KNOWLEDGE GRAPH exactly!
5. When joining, use EXACT columns from Join Paths
6. Return SINGLE SELECT statement
7. ALWAYS apply month filter if no period specified
8. ⛔⛔⛔ NEVER use columns from DEPRECATED COLUMNS section!

## OUTPUT FORMAT (JSON only)
{"type": "sql", "sql": "SELECT ...", "explanation": "brief"}`;

        // =====================================================================
        // AI CALL
        // =====================================================================
        const aiStart = Date.now();
        const sqlAiResponse = await fetch('https://openrouter.ai/api/v1/chat/completions', {
          method: 'POST',
          headers: { 'Authorization': `Bearer ${Deno.env.get('OPENROUTER_API_KEY')}`, 'Content-Type': 'application/json' },
          body: JSON.stringify({
            model: 'x-ai/grok-4-fast',
            messages: [
              { role: 'system', content: sqlSystemPrompt },
              ...chatHistory.slice(-4).map(h => ({ role: h.role === 'user' ? 'user' : 'assistant', content: h.content })),
              { role: 'user', content: question }
            ],
            max_tokens: 1024,
            temperature: 0.1
          })
        });

        const sqlAiJson = await sqlAiResponse.json();
        const aiCallTime = Date.now() - aiStart;
        if (!sqlAiResponse.ok || sqlAiJson.error) throw new Error(`AI Error: ${sqlAiJson.error?.message || sqlAiResponse.statusText}`);

        let aiRawContent = sqlAiJson.choices?.[0]?.message?.content || '';
        let generatedSql = '';
        let interpretation = '';

        try {
          const cleanContent = aiRawContent.replace(/```json\n?/g, '').replace(/```\n?/g, '').trim();
          const parsed = JSON.parse(cleanContent);
          generatedSql = parsed.sql?.replace(/;+\s*$/g, '').trim() || '';
          interpretation = parsed.explanation || '';
        } catch {
          const sqlMatch = aiRawContent.match(/SELECT[\s\S]+?(?=;|$)/i);
          generatedSql = sqlMatch ? sqlMatch[0].trim() : '';
        }
        if (!generatedSql) throw new Error('Failed to generate SQL');

        // =====================================================================
        // SQL EXECUTION (with retry)
        // =====================================================================
        let sqlStart = Date.now();
        let execResult = await supabase.rpc('execute_sql', { query_text: generatedSql });
        let sqlExecTime = Date.now() - sqlStart;
        let sqlSuccess = !execResult.error;
        let sqlResult = execResult.data || [];
        let rowCount = sqlResult.length;
        let errorMessage = execResult.error?.message || null;
        let errorInfo = errorMessage ? classifyError(errorMessage) : null;
        let didRetry = false;

        // RETRY on syntax_error or column_not_found
        if (!sqlSuccess && errorInfo && ['syntax_error', 'column_not_found', 'group_by_error'].includes(errorInfo.type)) {
          console.log(`[v28] Retry due to ${errorInfo.type}: ${errorMessage?.substring(0, 100)}`);
          didRetry = true;

          const retryResponse = await fetch('https://openrouter.ai/api/v1/chat/completions', {
            method: 'POST',
            headers: { 'Authorization': `Bearer ${Deno.env.get('OPENROUTER_API_KEY')}`, 'Content-Type': 'application/json' },
            body: JSON.stringify({
              model: 'x-ai/grok-4-fast',
              messages: [
                { role: 'system', content: sqlSystemPrompt },
                ...chatHistory.slice(-4).map(h => ({ role: h.role === 'user' ? 'user' : 'assistant', content: h.content })),
                { role: 'user', content: question },
                { role: 'assistant', content: JSON.stringify({ type: 'sql', sql: generatedSql, explanation: interpretation }) },
                { role: 'user', content: `SQL execution failed with error: "${errorMessage}"
Please fix the SQL and try again. Check column names, syntax, and GROUP BY clauses.
Return JSON format: {"type": "sql", "sql": "SELECT ...", "explanation": "..."}` }
              ],
              max_tokens: 1024,
              temperature: 0.1
            })
          });

          const retryJson = await retryResponse.json();
          if (retryResponse.ok && !retryJson.error) {
            const retryContent = retryJson.choices?.[0]?.message?.content || '';
            try {
              const cleanRetry = retryContent.replace(/```json\n?/g, '').replace(/```\n?/g, '').trim();
              const parsedRetry = JSON.parse(cleanRetry);
              const retrySql = parsedRetry.sql?.replace(/;+\s*$/g, '').trim() || '';

              if (retrySql && retrySql !== generatedSql) {
                generatedSql = retrySql;
                interpretation = parsedRetry.explanation || interpretation;

                sqlStart = Date.now();
                execResult = await supabase.rpc('execute_sql', { query_text: generatedSql });
                sqlExecTime = Date.now() - sqlStart;
                sqlSuccess = !execResult.error;
                sqlResult = execResult.data || [];
                rowCount = sqlResult.length;
                errorMessage = execResult.error?.message || null;
                errorInfo = errorMessage ? classifyError(errorMessage) : null;

                console.log(`[v28] Retry ${sqlSuccess ? 'SUCCESS' : 'FAILED'}`);
              }
            } catch (e) {
              console.log(`[v28] Retry parse failed`);
            }
          }
        }

        // =====================================================================
        // LOGGING
        // =====================================================================
        const logData = {
          company_id,
          user_id,
          store_id: store_id || null,
          role_type: roleType,
          timezone: companyTimezone,
          question,
          question_length: question.length,
          question_language: userLanguage,
          session_id: sessionId,
          ai_model: 'grok-4-fast',
          ai_tokens_used: sqlAiJson.usage?.total_tokens || null,
          ai_prompt_tokens: sqlAiJson.usage?.prompt_tokens || null,
          ai_completion_tokens: sqlAiJson.usage?.completion_tokens || null,
          ai_raw_response: aiRawContent.substring(0, 3000),
          generated_sql: generatedSql,
          sql_length: generatedSql.length,
          interpretation,
          tables_used: extractTables(generatedSql),
          success: sqlSuccess,
          row_count: rowCount,
          result_sample: sqlResult.slice(0, 5),
          result_columns: sqlResult.length > 0 ? Object.keys(sqlResult[0]) : [],
          execution_time_ms: Date.now() - startTime,
          context_load_time_ms: contextLoadTime,
          ai_call_time_ms: aiCallTime,
          sql_execution_time_ms: sqlExecTime,
          error_message: errorMessage,
          error_type: errorInfo?.type || null,
          error_detail: errorInfo?.detail || null,
          matched_concepts: matchedConcepts.slice(0, 10),
          graph_paths: graphPaths,
          client_info: client_info || null,
          local_date: new Date().toISOString().split('T')[0],
          day_of_week: new Date().getUTCDay()
        };

        const logInsert = await supabase.from('ai_sql_logs').insert(logData).select('log_id').single();
        sqlLogId = logInsert.data?.log_id || null;

        // SSE result
        if (sqlSuccess) {
          sendSSE(controller, { type: 'result', success: true, data: sqlResult, row_count: rowCount, sql_log_id: sqlLogId });
        } else {
          sendSSE(controller, { type: 'error', success: false, error_type: errorInfo?.type || 'unknown', sql_log_id: sqlLogId });
        }

        // Natural response (streaming)
        const naturalPrompt = sqlSuccess
          ? `User language: ${userLanguage}. User: ${displayName}. Question: "${question}". SQL Result (${rowCount} rows): ${JSON.stringify(sqlResult.slice(0, 10))}. Respond naturally in ${userLanguage}. Never mention SQL.`
          : `User language: ${userLanguage}. Question: "${question}". Error: ${errorInfo?.type}. Apologize briefly in ${userLanguage}.`;

        const streamResponse = await fetch('https://openrouter.ai/api/v1/chat/completions', {
          method: 'POST',
          headers: { 'Authorization': `Bearer ${Deno.env.get('OPENROUTER_API_KEY')}`, 'Content-Type': 'application/json' },
          body: JSON.stringify({ model: 'x-ai/grok-4-fast', messages: [{ role: 'user', content: naturalPrompt }], max_tokens: 512, temperature: 0.7, stream: true })
        });

        let fullResponse = '';
        const reader = streamResponse.body?.getReader();
        const decoder = new TextDecoder();
        if (reader) {
          while (true) {
            const { done, value } = await reader.read();
            if (done) break;
            const chunk = decoder.decode(value);
            for (const line of chunk.split('\n').filter(l => l.trim().startsWith('data:'))) {
              const data = line.replace('data: ', '').trim();
              if (data === '[DONE]') continue;
              try {
                const parsed = JSON.parse(data);
                const c = parsed.choices?.[0]?.delta?.content || '';
                if (c) { fullResponse += c; sendSSE(controller, { type: 'stream', content: c }); }
              } catch {}
            }
          }
        }

        // Save history
        await supabase.from('ai_chat_history').insert([
          { session_id: sessionId, message: { role: 'user', content: question }, sql_log_id: sqlLogId },
          { session_id: sessionId, message: { role: 'assistant', content: fullResponse || interpretation }, sql_log_id: sqlLogId }
        ]);

        sendSSE(controller, { type: 'done', session_id: sessionId, execution_time_ms: Date.now() - startTime });
        console.log(`[v28] OK ${Date.now() - startTime}ms | Rows: ${rowCount}${didRetry ? ' (retried)' : ''}`);

      } catch (error: any) {
        console.error(`[v28] ERR: ${error.message}`);
        sendSSE(controller, { type: 'error', success: false, message: error.message, error_type: classifyError(error.message).type });
        sendSSE(controller, { type: 'done', session_id: sessionId, error: true, execution_time_ms: Date.now() - startTime });
      }
      controller.close();
    }
  });

  return new Response(stream, { headers: CORS_HEADERS });
});
