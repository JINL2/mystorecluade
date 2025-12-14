import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

// =============================================================================
// AI Respond User v10 - PURE ORCHESTRA PATTERN
// =============================================================================
//
// 핵심 원칙: Edge Function은 오케스트라 (지휘자)
// - 모든 비즈니스 로직 → ontology 테이블에서 동적 로드
// - 하드코딩 금지 (timezone, 테이블명, 카테고리 등)
// - 언어/에러 메시지도 DB에서 가져오거나 AI가 생성
//
// 온톨로지 테이블 (9개):
// 1. ontology_entities     - 테이블/뷰 정보, query_priority
// 2. ontology_columns      - 컬럼 정보, is_deprecated
// 3. ontology_concepts     - 비즈니스 개념, concept_category
// 4. ontology_synonyms     - 동의어 (다국어)
// 5. ontology_relationships - FK 관계, join_hint
// 6. ontology_constraints  - 제약조건, validation_rule
// 7. ontology_calculation_rules - 계산 규칙, sql_template
// 8. ontology_event_types  - 이벤트 유형, timestamp_column_utc
// 9. ontology_kpi_rules    - KPI 이상 탐지 규칙
//
// =============================================================================

const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization',
  'Content-Type': 'text/event-stream',
  'Cache-Control': 'no-cache',
  'Connection': 'keep-alive'
};

// =============================================================================
// UTILITY FUNCTIONS (순수 기술적 함수만 - 비즈니스 로직 없음)
// =============================================================================

// 에러 분류 (기술적 분류만)
function classifyError(errorMsg: string): { type: string; detail: any } {
  const msg = errorMsg.toLowerCase();

  const colMatch = errorMsg.match(/column "([^"]+)" does not exist/i);
  if (colMatch) return { type: 'column_not_found', detail: { column: colMatch[1] } };

  const tableMatch = errorMsg.match(/relation "([^"]+)" does not exist/i);
  if (tableMatch) return { type: 'table_not_found', detail: { table: tableMatch[1] } };

  if (msg.includes('syntax error')) {
    const nearMatch = errorMsg.match(/near "([^"]+)"/i) || errorMsg.match(/at or near "([^"]+)"/i);
    return { type: 'syntax_error', detail: { near: nearMatch?.[1] } };
  }

  if (msg.includes('timeout') || msg.includes('canceling statement')) {
    return { type: 'timeout', detail: {} };
  }

  if (msg.includes('ai error') || msg.includes('openrouter') || msg.includes('failed to generate')) {
    return { type: 'ai_error', detail: {} };
  }

  const ambigMatch = errorMsg.match(/column reference "([^"]+)" is ambiguous/i);
  if (ambigMatch) return { type: 'ambiguous_column', detail: { column: ambigMatch[1] } };

  if (msg.includes('permission denied')) return { type: 'permission_denied', detail: {} };

  return { type: 'unknown', detail: { raw: errorMsg.substring(0, 300) } };
}

// SQL에서 테이블 추출 (기술적)
function extractTables(sql: string): string[] {
  const tables: Set<string> = new Set();
  const patterns = [
    /FROM\s+([a-z_][a-z0-9_]*)/gi,
    /JOIN\s+([a-z_][a-z0-9_]*)/gi,
    /INTO\s+([a-z_][a-z0-9_]*)/gi
  ];

  for (const pattern of patterns) {
    let match;
    while ((match = pattern.exec(sql)) !== null) {
      const table = match[1].toLowerCase();
      if (!['select', 'where', 'and', 'or', 'on', 'as'].includes(table)) {
        tables.add(table);
      }
    }
  }

  return Array.from(tables);
}

// SQL에서 컬럼 추출 (기술적)
function extractColumns(sql: string): Array<{table: string | null, column: string}> {
  const columns: Array<{table: string | null, column: string}> = [];
  const seen = new Set<string>();

  const pattern = /([a-z_][a-z0-9_]*)\.([a-z_][a-z0-9_]*)/gi;
  let match;
  while ((match = pattern.exec(sql)) !== null) {
    const table = match[1].toLowerCase();
    const column = match[2].toLowerCase();
    const key = `${table}.${column}`;

    const skipWords = ['date_trunc', 'time_zone', 'to_char', 'coalesce', 'extract', 'interval', 'case', 'when', 'then', 'else', 'end', 'and', 'or', 'not', 'null', 'true', 'false', 'as', 'on', 'in', 'is'];
    if (skipWords.includes(table) || skipWords.includes(column)) continue;

    if (!seen.has(key)) {
      seen.add(key);
      columns.push({ table, column });
    }
  }

  return columns;
}

// SSE 이벤트 전송
function sendSSE(controller: ReadableStreamDefaultController, data: any) {
  const encoder = new TextEncoder();
  controller.enqueue(encoder.encode(`data: ${JSON.stringify(data)}\n\n`));
}

// =============================================================================
// MAIN HANDLER
// =============================================================================

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

      try {
        // =====================================================================
        // STEP 1: 요청 파싱
        // =====================================================================
        const body = await req.json();
        const {
          question: rawQuestion,
          company_id,
          user_id,
          store_id,
          session_id,
          client_info,
          page_context: rawPageContext
        } = body;

        if (!company_id || !user_id || !rawQuestion) {
          throw new Error('company_id, user_id, question required');
        }

        let question = rawQuestion;
        let pageContext: { page_name?: string; [key: string]: any } = rawPageContext || {};

        // 페이지 컨텍스트 파싱
        const pageNameMatch = rawQuestion.match(/^\[([^\]]+)\]\s*/);
        if (pageNameMatch) {
          pageContext.page_name = pageContext.page_name || pageNameMatch[1];
          question = rawQuestion.replace(pageNameMatch[0], '');
        }

        const pageCtxMatch = question.match(/\nPage Context:\s*(\{[^}]+\})\s*$/);
        if (pageCtxMatch) {
          try {
            const parsed = JSON.parse(pageCtxMatch[1].replace(/(\w+):/g, '"$1":').replace(/'/g, '"'));
            pageContext = { ...pageContext, ...parsed };
          } catch {}
          question = question.replace(pageCtxMatch[0], '').trim();
        }

        sessionId = session_id || crypto.randomUUID();
        const hasPageContext = Object.keys(pageContext).length > 0;

        console.log(`[ai_respond_user v10] Q: ${question} | Session: ${sessionId.slice(0,8)}...`);

        // =====================================================================
        // STEP 2: 사용자 컨텍스트 + 회사 정보 로드 (timezone 동적)
        // =====================================================================
        const userContextResult = await supabase.rpc('execute_sql', {
          query_text: `
            SELECT
              COALESCE(u.first_name, '') || ' ' || COALESCE(u.last_name, '') as display_name,
              COALESCE(l.language_code, 'en') as user_language,
              COALESCE(u.preferred_timezone, c.timezone, 'UTC') as timezone,
              COALESCE(r.role_type, 'employee') as role_type,
              c.timezone as company_timezone
            FROM users u
            LEFT JOIN languages l ON l.language_id = u.user_language
            LEFT JOIN user_roles ur ON ur.user_id = u.user_id AND (ur.is_deleted = false OR ur.is_deleted IS NULL)
            LEFT JOIN roles r ON r.role_id = ur.role_id AND r.company_id = '${company_id}'
            LEFT JOIN companies c ON c.company_id = '${company_id}'
            WHERE u.user_id = '${user_id}'
            ORDER BY CASE r.role_type WHEN 'owner' THEN 1 WHEN 'admin' THEN 2 WHEN 'store_manager' THEN 3 ELSE 4 END
            LIMIT 1
          `
        });

        const userContext = userContextResult.data?.[0] || {
          display_name: 'User',
          user_language: 'en',
          timezone: 'UTC',
          role_type: 'employee',
          company_timezone: 'UTC'
        };

        userLanguage = userContext.user_language;
        const timezone = userContext.timezone;
        const companyTimezone = userContext.company_timezone || 'UTC';
        const roleType = userContext.role_type;
        const displayName = userContext.display_name?.trim() || 'User';

        // =====================================================================
        // STEP 3: 세션 히스토리 로드
        // =====================================================================
        const historyResult = await supabase
          .from('ai_chat_history')
          .select('message')
          .eq('session_id', sessionId)
          .order('created_at', { ascending: true })
          .limit(20);

        const chatHistory = historyResult.data?.map(h => ({
          role: h.message.role as string,
          content: h.message.content as string
        })) || [];

        // =====================================================================
        // STEP 4: 🎼 온톨로지 전체 로드 (9개 테이블 - 완전 동적)
        // =====================================================================
        const contextStart = Date.now();
        const langSuffix = userLanguage === 'ko' ? 'ko' : userLanguage === 'vi' ? 'vi' : 'en';

        // 모든 온톨로지 테이블을 병렬로 로드
        const [
          entitiesResult,
          columnsResult,
          conceptsResult,
          synonymsResult,
          relationshipsResult,
          constraintsResult,
          calculationRulesResult,
          eventTypesResult,
          kpiRulesResult,
          featuresResult
        ] = await Promise.all([
          // 1. ontology_entities - 테이블/뷰 정보
          supabase.rpc('execute_sql', {
            query_text: `
              SELECT table_name, entity_name, entity_type, ai_usage_hint,
                     query_priority, required_filters, is_soft_delete
              FROM ontology_entities
              WHERE (is_active = true OR is_active IS NULL)
              ORDER BY query_priority DESC
            `
          }),

          // 2. ontology_columns - 컬럼 정보 (deprecated 제외)
          supabase.rpc('execute_sql', {
            query_text: `
              SELECT table_name, column_name, data_type, ai_usage_hint,
                     is_utc, timezone_hint,
                     COALESCE(display_name_${langSuffix}, display_name_en, column_name) as display_name
              FROM ontology_columns
              WHERE (is_active = true OR is_active IS NULL)
                AND (is_deprecated = false OR is_deprecated IS NULL)
              ORDER BY table_name, column_name
            `
          }),

          // 3. ontology_concepts - 비즈니스 개념 (모든 카테고리 동적 로드)
          supabase.rpc('execute_sql', {
            query_text: `
              SELECT concept_id, concept_name, concept_category,
                     ai_usage_hint, mapped_table, mapped_column, calculation_rule,
                     COALESCE(definition_${langSuffix}, definition_en) as definition
              FROM ontology_concepts
              WHERE (is_active = true OR is_active IS NULL)
              ORDER BY concept_category, concept_name
            `
          }),

          // 4. ontology_synonyms - 동의어 (다국어)
          supabase.rpc('execute_sql', {
            query_text: `
              SELECT s.synonym_text, s.language_code, s.search_weight,
                     c.concept_name, c.concept_category
              FROM ontology_synonyms s
              JOIN ontology_concepts c ON s.concept_id = c.concept_id
              WHERE (s.is_active = true OR s.is_active IS NULL)
                AND (c.is_active = true OR c.is_active IS NULL)
              ORDER BY s.search_weight DESC
            `
          }),

          // 5. ontology_relationships - 테이블 관계
          supabase.rpc('execute_sql', {
            query_text: `
              SELECT from_table, from_column, to_table, to_column,
                     relationship_type, join_hint, is_required, ai_usage_hint
              FROM ontology_relationships
              WHERE (is_active = true OR is_active IS NULL)
            `
          }),

          // 6. ontology_constraints - 제약조건 (비즈니스 규칙)
          supabase.rpc('execute_sql', {
            query_text: `
              SELECT constraint_name, constraint_type, applies_to_table, applies_to_column,
                     validation_rule, severity, ai_usage_hint,
                     COALESCE(description_${langSuffix}, description_en) as description
              FROM ontology_constraints
              WHERE (is_active = true OR is_active IS NULL)
              ORDER BY severity DESC, constraint_name
            `
          }),

          // 7. ontology_calculation_rules - 계산 규칙 (SQL 템플릿)
          supabase.rpc('execute_sql', {
            query_text: `
              SELECT rule_name, rule_type, formula, sql_template, ai_usage_hint,
                     input_columns, output_type, output_unit, applies_to_tables,
                     COALESCE(description_${langSuffix}, description_en) as description
              FROM ontology_calculation_rules
              WHERE (is_active = true OR is_active IS NULL)
              ORDER BY rule_name
            `
          }),

          // 8. ontology_event_types - 이벤트 유형
          supabase.rpc('execute_sql', {
            query_text: `
              SELECT event_name, source_table, event_category, event_subcategory,
                     timestamp_column_utc, status_column, valid_statuses, ai_usage_hint,
                     COALESCE(description_${langSuffix}, description_en) as description
              FROM ontology_event_types
              WHERE (is_active = true OR is_active IS NULL)
              ORDER BY event_category, event_name
            `
          }),

          // 9. ontology_kpi_rules - KPI 이상 탐지 규칙
          supabase.rpc('execute_sql', {
            query_text: `
              SELECT rule_name, rule_category, detection_query,
                     threshold_type, threshold_value, severity,
                     COALESCE(description_${langSuffix}, description_ko) as description
              FROM ontology_kpi_rules
              WHERE (is_active = true OR is_active IS NULL)
              ORDER BY severity DESC, rule_category
            `
          }),

          // 10. features - 앱 네비게이션 (추가)
          supabase.rpc('execute_sql', {
            query_text: `
              SELECT
                f.feature_name, f.route,
                c.name as category_name,
                COALESCE(
                  f.feature_ai_description_${langSuffix},
                  f.feature_ai_description_en,
                  f.feature_ai_description_ko
                ) as ai_description
              FROM features f
              LEFT JOIN categories c ON c.category_id = f.category_id
              WHERE (
                f.feature_ai_description_ko IS NOT NULL
                OR f.feature_ai_description_en IS NOT NULL
                OR f.feature_ai_description_vi IS NOT NULL
              )
              ORDER BY c.name, f.feature_name
            `
          })
        ]);

        const contextLoadTime = Date.now() - contextStart;

        // 데이터 추출
        const entities = entitiesResult.data || [];
        const columns = columnsResult.data || [];
        const concepts = conceptsResult.data || [];
        const synonyms = synonymsResult.data || [];
        const relationships = relationshipsResult.data || [];
        const constraints = constraintsResult.data || [];
        const calculationRules = calculationRulesResult.data || [];
        const eventTypes = eventTypesResult.data || [];
        const kpiRules = kpiRulesResult.data || [];
        const features = featuresResult.data || [];

        // =====================================================================
        // STEP 5: 🎼 프롬프트 구성 (모든 데이터를 동적으로 포맷)
        // =====================================================================

        // 엔티티 포맷
        const formatEntities = () => {
          if (entities.length === 0) return '';
          let result = '\n## 📊 DATABASE ENTITIES\n';

          // query_priority 순서대로 그룹화
          const highPriority = entities.filter((e: any) => e.query_priority >= 90);
          const medPriority = entities.filter((e: any) => e.query_priority >= 50 && e.query_priority < 90);

          if (highPriority.length > 0) {
            result += '\n### ⭐ Primary Tables/Views (use these first)\n';
            for (const e of highPriority) {
              result += `#### ${e.table_name} ${e.entity_type === 'view' ? '(VIEW)' : ''}\n`;
              if (e.ai_usage_hint) result += `${e.ai_usage_hint}\n`;
              if (e.required_filters) result += `Required filters: ${JSON.stringify(e.required_filters)}\n`;
              if (e.is_soft_delete === false) result += `⚠️ No is_deleted column - skip soft delete filter\n`;
              result += '\n';
            }
          }

          if (medPriority.length > 0) {
            result += '\n### Secondary Tables\n';
            for (const e of medPriority) {
              result += `- ${e.table_name}: ${e.ai_usage_hint?.substring(0, 100) || 'No hint'}...\n`;
            }
          }

          return result;
        };

        // 컬럼 포맷 (중요한 것만)
        const formatColumns = () => {
          if (columns.length === 0) return '';
          let result = '\n## 📋 IMPORTANT COLUMNS\n';

          // 테이블별로 그룹화
          const byTable: Record<string, any[]> = {};
          for (const col of columns) {
            if (!byTable[col.table_name]) byTable[col.table_name] = [];
            byTable[col.table_name].push(col);
          }

          // ai_usage_hint가 있는 컬럼만 표시
          for (const [tableName, cols] of Object.entries(byTable)) {
            const importantCols = cols.filter((c: any) => c.ai_usage_hint);
            if (importantCols.length > 0) {
              result += `\n### ${tableName}\n`;
              for (const col of importantCols) {
                result += `- ${col.column_name} (${col.data_type}): ${col.ai_usage_hint}\n`;
                if (col.is_utc) result += `  ⏰ UTC timestamp - use AT TIME ZONE for local time\n`;
              }
            }
          }

          return result;
        };

        // 컨셉 포맷 (카테고리별)
        const formatConcepts = () => {
          if (concepts.length === 0) return '';
          let result = '\n## 💡 BUSINESS CONCEPTS\n';

          // 카테고리별 그룹화
          const byCategory: Record<string, any[]> = {};
          for (const c of concepts) {
            const cat = c.concept_category || 'other';
            if (!byCategory[cat]) byCategory[cat] = [];
            byCategory[cat].push(c);
          }

          for (const [category, items] of Object.entries(byCategory)) {
            result += `\n### ${category.toUpperCase()}\n`;
            for (const c of items) {
              result += `#### ${c.concept_name}\n`;
              if (c.ai_usage_hint) result += `${c.ai_usage_hint}\n`;
              if (c.mapped_table) result += `Table: ${c.mapped_table}`;
              if (c.mapped_column) result += ` | Column: ${c.mapped_column}`;
              if (c.calculation_rule) result += `\nCalculation: ${c.calculation_rule}`;
              result += '\n\n';
            }
          }

          return result;
        };

        // 동의어 포맷 (키워드 매핑용)
        const formatSynonyms = () => {
          if (synonyms.length === 0) return '';
          let result = '\n## 🔤 KEYWORD SYNONYMS\n';
          result += 'Map user keywords to concepts:\n\n';

          // 카테고리별 그룹화
          const byCategory: Record<string, any[]> = {};
          for (const s of synonyms) {
            const cat = s.concept_category || 'other';
            if (!byCategory[cat]) byCategory[cat] = [];
            byCategory[cat].push(s);
          }

          for (const [category, items] of Object.entries(byCategory)) {
            const uniqueConcepts = [...new Set(items.map((s: any) => s.concept_name))];
            result += `**${category}**: `;

            // 각 컨셉의 동의어 나열
            const parts: string[] = [];
            for (const concept of uniqueConcepts.slice(0, 5)) {
              const syns = items.filter((s: any) => s.concept_name === concept).map((s: any) => s.synonym_text);
              parts.push(`${concept} (${syns.slice(0, 3).join(', ')})`);
            }
            result += parts.join(' | ') + '\n';
          }

          return result;
        };

        // 관계 포맷
        const formatRelationships = () => {
          if (relationships.length === 0) return '';
          let result = '\n## 🔗 TABLE RELATIONSHIPS\n';
          result += '| From | Column | → | To | Column | Join Hint |\n';
          result += '|------|--------|---|-----|--------|----------|\n';

          for (const r of relationships) {
            result += `| ${r.from_table} | ${r.from_column} | → | ${r.to_table} | ${r.to_column} | ${r.join_hint || 'JOIN'} |\n`;
          }

          return result;
        };

        // 제약조건 포맷 (중요!)
        const formatConstraints = () => {
          if (constraints.length === 0) return '';
          let result = '\n## ⚠️ CRITICAL CONSTRAINTS (MUST FOLLOW)\n';

          // severity별 정렬
          const critical = constraints.filter((c: any) => c.severity === 'error' || c.severity === 'critical');
          const warnings = constraints.filter((c: any) => c.severity === 'warning');

          if (critical.length > 0) {
            result += '\n### 🔴 CRITICAL (will cause errors if violated)\n';
            for (const c of critical) {
              result += `#### ${c.constraint_name}\n`;
              if (c.ai_usage_hint) result += `${c.ai_usage_hint}\n`;
              if (c.validation_rule) result += `Rule: \`${c.validation_rule}\`\n`;
              result += '\n';
            }
          }

          if (warnings.length > 0) {
            result += '\n### 🟡 WARNINGS\n';
            for (const c of warnings) {
              result += `- ${c.constraint_name}: ${c.ai_usage_hint || c.description || ''}\n`;
            }
          }

          return result;
        };

        // 계산 규칙 포맷
        const formatCalculationRules = () => {
          if (calculationRules.length === 0) return '';
          let result = '\n## 📐 CALCULATION RULES & SQL TEMPLATES\n';

          for (const r of calculationRules) {
            result += `\n### ${r.rule_name} (${r.rule_type})\n`;
            if (r.ai_usage_hint) result += `${r.ai_usage_hint}\n`;
            if (r.formula) result += `Formula: \`${r.formula}\`\n`;
            if (r.sql_template) {
              result += `SQL Template:\n\`\`\`sql\n${r.sql_template.replace(/\{company_id\}/g, '$company_id')}\n\`\`\`\n`;
            }
          }

          return result;
        };

        // 이벤트 타입 포맷
        const formatEventTypes = () => {
          if (eventTypes.length === 0) return '';
          let result = '\n## 📅 EVENT TYPES\n';

          // 카테고리별 그룹화
          const byCategory: Record<string, any[]> = {};
          for (const e of eventTypes) {
            const cat = e.event_category || 'other';
            if (!byCategory[cat]) byCategory[cat] = [];
            byCategory[cat].push(e);
          }

          for (const [category, items] of Object.entries(byCategory)) {
            result += `\n### ${category.toUpperCase()}\n`;
            for (const e of items) {
              result += `- **${e.event_name}** (${e.source_table})\n`;
              if (e.ai_usage_hint) result += `  ${e.ai_usage_hint}\n`;
              if (e.timestamp_column_utc) result += `  Timestamp: ${e.timestamp_column_utc} (UTC)\n`;
            }
          }

          return result;
        };

        // KPI 규칙 포맷
        const formatKpiRules = () => {
          if (kpiRules.length === 0) return '';
          let result = '\n## 📈 KPI & ANOMALY DETECTION\n';
          result += 'Use these rules to detect potential issues:\n';

          for (const k of kpiRules) {
            result += `\n### ${k.rule_name} (${k.rule_category})\n`;
            result += `${k.description || ''}\n`;
            result += `Threshold: ${k.threshold_type} ${k.threshold_value || ''}\n`;
          }

          return result;
        };

        // 앱 네비게이션 포맷
        const formatFeatures = () => {
          if (features.length === 0) return '';
          let result = '\n## 📱 APP NAVIGATION\n';
          result += 'For "where to find X?" questions, guide user to these features:\n\n';

          for (const f of features) {
            if (f.ai_description) {
              result += `${f.ai_description}\n\n`;
            }
          }

          return result;
        };

        // 페이지 컨텍스트 포맷
        const formatPageContext = () => {
          if (!hasPageContext) return '';
          let result = '\n## 📍 CURRENT PAGE CONTEXT\n';
          result += 'User is viewing this page (may or may not be relevant to question):\n';
          for (const [key, value] of Object.entries(pageContext)) {
            result += `- ${key}: ${value}\n`;
          }
          return result;
        };

        // =====================================================================
        // STEP 6: 🎼 최종 시스템 프롬프트 조립
        // =====================================================================

        const sqlSystemPrompt = `You are an expert PostgreSQL generator and business assistant.

## YOUR ROLE
1. For DATA questions → Generate accurate SQL query
2. For NAVIGATION questions → Guide user to the right app feature
3. For ANALYSIS questions → Use calculation rules and KPI rules

## USER CONTEXT
- company_id: '${company_id}'
- user_id: '${user_id}'
- role_type: ${roleType}
- store_id: ${store_id ? `'${store_id}'` : 'null'}
- language: ${userLanguage}
- timezone: '${companyTimezone}' (from companies table)
${formatPageContext()}

## ⭐⭐⭐ TIMEZONE RULE (CRITICAL!)
NEVER hardcode timezone! Always use:
\`\`\`sql
AT TIME ZONE (SELECT timezone FROM companies WHERE company_id = '${company_id}')
\`\`\`

Example for "today":
\`\`\`sql
WHERE (column_utc AT TIME ZONE (SELECT timezone FROM companies WHERE company_id = '${company_id}'))::date =
      (NOW() AT TIME ZONE (SELECT timezone FROM companies WHERE company_id = '${company_id}'))::date
\`\`\`
${formatConstraints()}
${formatEntities()}
${formatColumns()}
${formatRelationships()}
${formatCalculationRules()}
${formatEventTypes()}
${formatConcepts()}
${formatSynonyms()}
${formatKpiRules()}
${formatFeatures()}

## SQL GENERATION RULES
1. ALWAYS filter: company_id = '${company_id}'
2. ALWAYS filter: (is_deleted = false OR is_deleted IS NULL) - EXCEPT for VIEWs (v_ prefix)
3. Use timezone from companies table - NEVER hardcode
4. ⛔ NEVER use CROSS JOIN or FULL OUTER JOIN
5. ⛔ Generate ONLY ONE SELECT statement (no semicolons)
6. ⭐ USE ONLY columns documented above. Do NOT guess column names.
7. Use ::integer cast for EXTRACT in MAKE_DATE

## OUTPUT FORMAT (JSON only)
For DATA queries:
{"type": "sql", "sql": "SELECT ...", "explanation": "brief explanation"}

For NAVIGATION queries:
{"type": "navigation", "feature": "feature_name", "route": "/route", "guide": "step-by-step guide in ${userLanguage}"}`;

        const sqlMessages = [
          { role: 'system', content: sqlSystemPrompt },
          ...chatHistory.slice(-10).map(h => ({
            role: h.role === 'user' ? 'user' : 'assistant',
            content: h.content
          })),
          { role: 'user', content: question }
        ];

        // =====================================================================
        // STEP 7: AI 호출 (SQL 생성)
        // =====================================================================
        const aiStart = Date.now();

        const sqlAiResponse = await fetch('https://openrouter.ai/api/v1/chat/completions', {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${Deno.env.get('OPENROUTER_API_KEY')}`,
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            model: 'x-ai/grok-4-fast',
            messages: sqlMessages,
            max_tokens: 2048,
            temperature: 0.1
          })
        });

        const sqlAiJson = await sqlAiResponse.json();
        const aiCallTime = Date.now() - aiStart;

        if (!sqlAiResponse.ok || sqlAiJson.error) {
          throw new Error(`AI Error: ${sqlAiJson.error?.message || sqlAiResponse.statusText}`);
        }

        let content = sqlAiJson.choices?.[0]?.message?.content || '';
        let responseType = 'sql';
        let generatedSql = '';
        let interpretation = '';
        let navigationGuide = '';
        let featureName = '';
        let featureRoute = '';

        try {
          content = content.replace(/```json\n?/g, '').replace(/```\n?/g, '').trim();
          const parsed = JSON.parse(content);

          responseType = parsed.type || 'sql';

          if (responseType === 'navigation') {
            featureName = parsed.feature || '';
            featureRoute = parsed.route || '';
            navigationGuide = parsed.guide || '';
            interpretation = `Navigation: ${featureName}`;
          } else {
            generatedSql = parsed.sql?.replace(/;+\s*$/g, '').trim() || '';
            interpretation = parsed.explanation || '';
          }
        } catch {
          const sqlMatch = content.match(/SELECT[\s\S]+?(?=;|$)/i);
          generatedSql = sqlMatch ? sqlMatch[0].trim() : '';
          interpretation = 'Extracted from raw response';
        }

        // =====================================================================
        // STEP 8: 네비게이션 응답 처리
        // =====================================================================
        if (responseType === 'navigation') {
          const navLogData = {
            company_id,
            user_id,
            store_id: store_id || null,
            role_type: roleType,
            timezone: companyTimezone,
            question,
            question_length: question.length,
            question_language: userLanguage,
            question_category: 'navigation',
            session_id: sessionId,
            ai_model: 'grok-4-fast',
            ai_tokens_used: sqlAiJson.usage?.total_tokens || null,
            ai_raw_response: content.substring(0, 2000),
            generated_sql: null,
            interpretation: `Navigation: ${featureName} (${featureRoute})`,
            success: true,
            row_count: 0,
            execution_time_ms: Date.now() - startTime,
            context_load_time_ms: contextLoadTime,
            ai_call_time_ms: aiCallTime,
            response_type: 'navigation'
          };

          const { data: navLogResult } = await supabase.from('ai_sql_logs').insert(navLogData).select('log_id').single();
          const navLogId = navLogResult?.log_id || null;

          await supabase.from('ai_chat_history').insert([
            { session_id: sessionId, message: { role: 'user', content: question }, sql_log_id: navLogId },
            { session_id: sessionId, message: { role: 'assistant', content: navigationGuide }, sql_log_id: navLogId }
          ]);

          sendSSE(controller, { type: 'result', data: { guide: navigationGuide, feature: featureName, route: featureRoute }, responseType: 'navigation' });
          sendSSE(controller, { type: 'stream', content: navigationGuide });
          sendSSE(controller, { type: 'done', session_id: sessionId, log_id: navLogId });
          controller.close();
          return;
        }

        // =====================================================================
        // STEP 9: SQL 검증
        // =====================================================================
        if (!generatedSql) throw new Error('Failed to generate SQL');

        const upperSQL = generatedSql.toUpperCase();
        if (/\b(INSERT|UPDATE|DELETE|DROP|TRUNCATE|ALTER)\b/.test(upperSQL)) {
          throw new Error('Only SELECT queries allowed');
        }

        // 컬럼 사전 검증
        const usedTables = extractTables(generatedSql);
        const usedColumns = extractColumns(generatedSql);

        if (usedTables.length > 0 && usedColumns.length > 0) {
          const schemaQuery = `
            SELECT table_name, column_name
            FROM information_schema.columns
            WHERE table_name IN (${usedTables.map(t => `'${t}'`).join(',')})
          `;
          const schemaResult = await supabase.rpc('execute_sql', { query_text: schemaQuery });

          if (schemaResult.data && Array.isArray(schemaResult.data)) {
            const validColumnSet = new Set(
              schemaResult.data.map((r: any) => `${r.table_name}.${r.column_name}`.toLowerCase())
            );

            const invalidCols: string[] = [];
            for (const { table, column } of usedColumns) {
              if (!table || table.length <= 3) continue;
              const key = `${table}.${column}`.toLowerCase();
              if (!validColumnSet.has(key)) {
                invalidCols.push(`${table}.${column}`);
              }
            }

            if (invalidCols.length > 0) {
              console.log(`[ai_respond_user] Invalid columns: ${invalidCols.join(', ')}`);
              throw new Error(`Column validation failed: ${invalidCols.join(', ')} do not exist`);
            }
          }
        }

        // =====================================================================
        // STEP 10: SQL 실행
        // =====================================================================
        const sqlStart = Date.now();
        const execResult = await supabase.rpc('execute_sql', { query_text: generatedSql });
        const sqlExecTime = Date.now() - sqlStart;

        const sqlSuccess = !execResult.error;
        const sqlResult = execResult.data || [];
        const rowCount = sqlResult.length;
        const errorMessage = execResult.error?.message || null;
        const errorInfo = errorMessage ? classifyError(errorMessage) : null;

        // =====================================================================
        // STEP 11: 로그 저장
        // =====================================================================
        const now = new Date();
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
          ai_raw_response: content.substring(0, 2000),
          generated_sql: generatedSql,
          sql_length: generatedSql.length,
          interpretation,
          tables_used: usedTables,
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
          matched_concepts: concepts.slice(0, 20).map((c: any) => c.concept_name),
          matched_entities: entities.slice(0, 10).map((e: any) => e.table_name),
          client_info: client_info || null,
          local_date: now.toISOString().split('T')[0],
          day_of_week: now.getUTCDay()
        };

        const logInsert = await supabase
          .from('ai_sql_logs')
          .insert(logData)
          .select('log_id')
          .single();

        sqlLogId = logInsert.data?.log_id || null;

        // =====================================================================
        // STEP 12: 결과 전송 (SSE)
        // =====================================================================
        if (sqlSuccess) {
          sendSSE(controller, {
            type: 'result',
            success: true,
            data: sqlResult,
            row_count: rowCount,
            sql_log_id: sqlLogId
          });
        } else {
          sendSSE(controller, {
            type: 'error',
            success: false,
            message: errorMessage,
            error_type: errorInfo?.type || 'unknown',
            sql_log_id: sqlLogId
          });
        }

        // =====================================================================
        // STEP 13: 자연어 응답 생성 (스트리밍)
        // =====================================================================
        const currentTime = new Date().toLocaleString('en-US', {
          timeZone: companyTimezone,
          dateStyle: 'full',
          timeStyle: 'short'
        });

        const languageMap: Record<string, string> = {
          ko: 'Korean', en: 'English', vi: 'Vietnamese'
        };

        const naturalLanguagePrompt = sqlSuccess
          ? `You are a helpful business assistant. Respond in ${languageMap[userLanguage] || 'English'}.

Current time: ${currentTime}
User: ${displayName} (${roleType})

User asked: "${question}"
SQL Result (${rowCount} rows): ${JSON.stringify(sqlResult)}
Context: ${interpretation}

Instructions:
- Respond naturally and concisely
- Use appropriate currency format (₫ for VND with thousands separators)
- Format numbers with commas (1,234,567)
- If empty/zero result, explain kindly
- Never mention SQL or technical details
- Be conversational`
          : `You are a helpful assistant. Respond in ${languageMap[userLanguage] || 'English'}.

User: ${displayName}
Question: "${question}"
Error occurred: ${errorInfo?.type}

Instructions:
- Apologize briefly
- Suggest rephrasing the question
- Be helpful`;

        const streamResponse = await fetch('https://openrouter.ai/api/v1/chat/completions', {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${Deno.env.get('OPENROUTER_API_KEY')}`,
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            model: 'x-ai/grok-4-fast',
            messages: [{ role: 'user', content: naturalLanguagePrompt }],
            max_tokens: 1024,
            temperature: 0.7,
            stream: true
          })
        });

        let fullResponse = '';
        const reader = streamResponse.body?.getReader();
        const decoder = new TextDecoder();

        if (reader) {
          while (true) {
            const { done, value } = await reader.read();
            if (done) break;

            const chunk = decoder.decode(value);
            const lines = chunk.split('\n').filter(line => line.trim().startsWith('data:'));

            for (const line of lines) {
              const data = line.replace('data: ', '').trim();
              if (data === '[DONE]') continue;

              try {
                const parsed = JSON.parse(data);
                const content = parsed.choices?.[0]?.delta?.content || '';
                if (content) {
                  fullResponse += content;
                  sendSSE(controller, { type: 'stream', content });
                }
              } catch {}
            }
          }
        }

        if (!fullResponse) {
          fullResponse = interpretation || 'Unable to process request';
          sendSSE(controller, { type: 'stream', content: fullResponse });
        }

        // =====================================================================
        // STEP 14: 채팅 히스토리 저장
        // =====================================================================
        const timestamp = new Date().toISOString();

        await supabase.from('ai_chat_history').insert({
          session_id: sessionId,
          message: { role: 'user', content: question, timestamp, company_id, store_id: store_id || null },
          sql_log_id: sqlLogId
        });

        await supabase.from('ai_chat_history').insert({
          session_id: sessionId,
          message: { role: 'assistant', content: fullResponse, timestamp: new Date().toISOString(), company_id, store_id: store_id || null, sql_success: sqlSuccess, row_count: rowCount },
          sql_log_id: sqlLogId
        });

        // =====================================================================
        // STEP 15: 완료
        // =====================================================================
        const totalTime = Date.now() - startTime;

        sendSSE(controller, {
          type: 'done',
          session_id: sessionId,
          execution_time_ms: totalTime
        });

        console.log(`[ai_respond_user v10] ✅ ${totalTime}ms | Rows: ${rowCount}`);

      } catch (error: any) {
        const totalTime = Date.now() - startTime;
        const errorInfo = classifyError(error.message || 'Unknown error');

        console.error(`[ai_respond_user v10] ❌ ${errorInfo.type}: ${error.message}`);

        if (sqlLogId === null) {
          try {
            const body = await req.clone().json().catch(() => ({}));
            await supabase.from('ai_sql_logs').insert({
              company_id: body.company_id || '00000000-0000-0000-0000-000000000000',
              user_id: body.user_id || '00000000-0000-0000-0000-000000000000',
              question: body.question || 'Unknown',
              session_id: sessionId || null,
              success: false,
              error_message: error.message,
              error_type: errorInfo.type,
              execution_time_ms: totalTime
            });
          } catch {}
        }

        sendSSE(controller, {
          type: 'error',
          success: false,
          message: error.message,
          error_type: errorInfo.type,
          sql_log_id: sqlLogId
        });

        sendSSE(controller, {
          type: 'done',
          session_id: sessionId,
          error: true,
          execution_time_ms: totalTime
        });
      }

      controller.close();
    }
  });

  return new Response(stream, { headers: CORS_HEADERS });
});
