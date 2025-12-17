-- ================================================================
-- MIGRATION: Fix get_ontology_paths_v2 to include deprecated columns
-- Date: 2025-12-16
-- Problem: RPC excludes deprecated columns, so AI doesn't know what NOT to use
-- Solution: Add separate 'deprecated_columns' section to warn AI
--
-- NOTE: This is NOT hardcoding! It dynamically reads from ontology_columns!
-- When you add/update deprecated columns in ontology_columns,
-- this RPC automatically includes them.
--
-- RUN THIS IN SUPABASE DASHBOARD SQL EDITOR!
-- ================================================================

CREATE OR REPLACE FUNCTION get_ontology_paths_v2(
  p_start_node_names TEXT[],
  p_max_depth INT DEFAULT 3
)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
  v_result JSONB;
BEGIN
  WITH RECURSIVE path_traversal AS (
    -- 시작점에서 정방향 탐색
    SELECT
      e.from_node_type,
      e.from_node_name,
      e.edge_type,
      e.to_node_type,
      e.to_node_name,
      e.metadata,
      1 AS depth,
      ARRAY[e.from_node_name] AS visited
    FROM v_ontology_graph_edges e
    WHERE e.from_node_name = ANY(p_start_node_names)

    UNION ALL

    -- 역방향 탐색 (symmetric 관계용)
    SELECT
      e.to_node_type as from_node_type,
      e.to_node_name as from_node_name,
      e.edge_type,
      e.from_node_type as to_node_type,
      e.from_node_name as to_node_name,
      e.metadata,
      1 AS depth,
      ARRAY[e.to_node_name] AS visited
    FROM v_ontology_graph_edges e
    WHERE e.to_node_name = ANY(p_start_node_names)
      AND e.edge_type IN ('related_to', 'opposite_of', 'used_with', 'same_as')

    UNION ALL

    -- 재귀 탐색
    SELECT
      e.from_node_type,
      e.from_node_name,
      e.edge_type,
      e.to_node_type,
      e.to_node_name,
      e.metadata,
      pt.depth + 1,
      pt.visited || e.from_node_name
    FROM v_ontology_graph_edges e
    JOIN path_traversal pt ON e.from_node_name = pt.to_node_name
    WHERE pt.depth < p_max_depth
      AND NOT (e.from_node_name = ANY(pt.visited))
  ),

  -- Main Tables: LIMIT 7
  main_tables AS (
    SELECT table_name
    FROM (
      SELECT to_node_name AS table_name, MIN(depth) as min_depth
      FROM path_traversal
      WHERE to_node_type = 'table'
        AND edge_type IN ('concept_maps_to_table', 'event_source_table')
      GROUP BY to_node_name
      ORDER BY min_depth, to_node_name
      LIMIT 7
    ) t
  ),

  -- Active columns (not deprecated)
  main_columns AS (
    SELECT DISTINCT
      col.table_name,
      col.column_name,
      col.data_type,
      col.ai_usage_hint,
      col.description_ko
    FROM ontology_columns col
    INNER JOIN main_tables mt ON col.table_name = mt.table_name
    WHERE col.is_active = true
      AND col.is_deprecated = false
    LIMIT 30
  ),

  -- 🆕 NEW: Deprecated columns - AI must know what NOT to use!
  deprecated_columns AS (
    SELECT DISTINCT
      col.table_name,
      col.column_name,
      col.ai_usage_hint
    FROM ontology_columns col
    WHERE col.is_deprecated = true
      AND col.is_active = true
    -- Include all critical deprecated columns, not just from main_tables
    LIMIT 50
  ),

  -- Calculation Rules: LIMIT 7
  related_rules AS (
    SELECT DISTINCT
      to_node_name AS rule_name,
      metadata->>'formula' AS formula
    FROM path_traversal
    WHERE to_node_type = 'rule'
    LIMIT 7
  ),

  -- Join Paths: LIMIT 7
  join_paths AS (
    SELECT DISTINCT
      from_node_name AS from_table,
      to_node_name AS to_table,
      metadata->>'join_hint' AS join_hint,
      metadata->>'from_column' AS from_column,
      metadata->>'to_column' AS to_column
    FROM path_traversal
    WHERE edge_type LIKE 'table_joins_%'
    LIMIT 7
  ),

  all_related_tables AS (
    SELECT table_name FROM main_tables
    UNION
    SELECT to_table AS table_name FROM join_paths
  ),

  -- Constraints: severity 순서, LIMIT 20
  related_constraints AS (
    SELECT constraint_name, validation_rule, severity, ai_hint
    FROM (
      SELECT DISTINCT
        n.node_name AS constraint_name,
        n.metadata->>'validation_rule' AS validation_rule,
        n.metadata->>'severity' AS severity,
        n.metadata->>'ai_usage_hint' AS ai_hint,
        CASE n.metadata->>'severity'
          WHEN 'critical' THEN 1
          WHEN 'error' THEN 2
          WHEN 'warning' THEN 3
          ELSE 4
        END AS severity_order
      FROM v_ontology_graph_nodes n
      WHERE n.node_type = 'constraint'
        AND (
          n.metadata->>'applies_to_table' IN (SELECT table_name FROM all_related_tables)
          OR n.metadata->>'applies_to_table' = 'ALL'
        )
    ) sub
    ORDER BY severity_order
    LIMIT 20
  ),

  -- Concept Relations: LIMIT 7
  concept_relations AS (
    SELECT from_concept, relation_type, to_concept
    FROM (
      SELECT DISTINCT
        from_node_name AS from_concept,
        edge_type AS relation_type,
        to_node_name AS to_concept,
        CASE edge_type
          WHEN 'related_to' THEN 1
          WHEN 'opposite_of' THEN 2
          WHEN 'broader' THEN 3
          ELSE 4
        END AS priority
      FROM path_traversal
      WHERE edge_type IN ('related_to', 'broader', 'narrower', 'opposite_of', 'part_of')
        AND from_node_name NOT LIKE 'domain_%'
    ) sub
    ORDER BY priority
    LIMIT 7
  ),

  -- Domain Context: LIMIT 7
  domain_context AS (
    SELECT DISTINCT
      from_node_name AS concept,
      to_node_name AS domain
    FROM path_traversal
    WHERE edge_type = 'broader'
      AND to_node_name LIKE 'domain_%'
    LIMIT 7
  )

  SELECT jsonb_build_object(
    'start_nodes', to_jsonb(p_start_node_names),
    'main_tables', COALESCE((SELECT jsonb_agg(table_name) FROM main_tables), '[]'::jsonb),
    'main_columns', COALESCE((
      SELECT jsonb_agg(jsonb_build_object(
        'table', table_name,
        'column', column_name,
        'type', data_type,
        'hint', ai_usage_hint,
        'desc', description_ko
      ))
      FROM main_columns
    ), '[]'::jsonb),
    -- 🆕 NEW: deprecated_columns section
    'deprecated_columns', COALESCE((
      SELECT jsonb_agg(jsonb_build_object(
        'table', table_name,
        'column', column_name,
        'warning', ai_usage_hint
      ))
      FROM deprecated_columns
    ), '[]'::jsonb),
    'calculation_rules', COALESCE((SELECT jsonb_agg(jsonb_build_object('rule', rule_name, 'formula', formula)) FROM related_rules), '[]'::jsonb),
    'constraints', COALESCE((SELECT jsonb_agg(jsonb_build_object('name', constraint_name, 'rule', validation_rule, 'severity', severity, 'hint', ai_hint)) FROM related_constraints), '[]'::jsonb),
    'join_paths', COALESCE((SELECT jsonb_agg(jsonb_build_object(
      'from', from_table,
      'to', to_table,
      'join', join_hint,
      'from_col', from_column,
      'to_col', to_column
    )) FROM join_paths), '[]'::jsonb),
    'concept_relations', COALESCE((SELECT jsonb_agg(jsonb_build_object(
      'from', from_concept,
      'relation', relation_type,
      'to', to_concept
    )) FROM concept_relations), '[]'::jsonb),
    'domains', COALESCE((SELECT jsonb_agg(jsonb_build_object(
      'concept', concept,
      'domain', domain
    )) FROM domain_context), '[]'::jsonb)
  ) INTO v_result;

  RETURN v_result;
END;
$$;

-- ================================================================
-- Verify the fix
-- ================================================================
SELECT '=== Test get_ontology_paths_v2 with deprecated columns ===' as info;

-- Test with a simple concept
SELECT
  jsonb_pretty(get_ontology_paths_v2(ARRAY['role', 'expense'])) as result;
