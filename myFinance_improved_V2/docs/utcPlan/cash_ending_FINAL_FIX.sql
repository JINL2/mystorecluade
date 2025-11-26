-- ========================================
-- Cash Ending RPC 함수 - 최종 수정 (원본 복사 + UTC만 변경)
-- ========================================

-- ========================================
-- 1. get_cash_location_balance_summary_v2_utc
-- ========================================

DROP FUNCTION IF EXISTS get_cash_location_balance_summary_v2_utc(uuid);

CREATE OR REPLACE FUNCTION get_cash_location_balance_summary_v2_utc(p_location_id uuid)
 RETURNS json
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
  v_result JSON;
  v_location_exists BOOLEAN;
  v_location_type VARCHAR(20);
  v_location_name VARCHAR(255);
  v_company_id UUID;
  v_base_currency_id UUID;
  v_currency_symbol TEXT;
  v_currency_code TEXT;
  v_total_journal NUMERIC;
  v_total_real NUMERIC;
  v_difference NUMERIC;
BEGIN
  SELECT
    EXISTS(SELECT 1 FROM cash_locations WHERE cash_location_id = p_location_id AND is_deleted = false),
    cl.location_type,
    cl.location_name,
    cl.company_id
  INTO
    v_location_exists,
    v_location_type,
    v_location_name,
    v_company_id
  FROM cash_locations cl
  WHERE cl.cash_location_id = p_location_id;

  IF NOT v_location_exists THEN
    RETURN json_build_object(
      'success', false,
      'error', 'Location not found or deleted',
      'location_id', p_location_id
    );
  END IF;

  SELECT
    c.base_currency_id,
    COALESCE(ct.symbol, '$'),
    COALESCE(ct.currency_code, 'USD')
  INTO
    v_base_currency_id,
    v_currency_symbol,
    v_currency_code
  FROM companies c
  LEFT JOIN currency_types ct ON c.base_currency_id = ct.currency_id
  WHERE c.company_id = v_company_id;

  SELECT COALESCE(SUM(jl.debit) - SUM(jl.credit), 0)
  INTO v_total_journal
  FROM journal_lines jl
  WHERE jl.cash_location_id = p_location_id
    AND jl.is_deleted IS NOT TRUE;

  -- ✅ UTC 변경: created_at → created_at_utc
  SELECT COALESCE(SUM(latest.balance_after), 0)
  INTO v_total_real
  FROM (
    SELECT DISTINCT ON (cae.currency_id)
      cae.balance_after,
      cae.currency_id
    FROM cash_amount_entries cae
    WHERE cae.location_id = p_location_id
      AND cae.entry_type = v_location_type
    ORDER BY cae.currency_id, cae.created_at_utc DESC, cae.entry_id DESC
  ) latest;

  v_total_real := COALESCE(v_total_real, 0);
  v_difference := v_total_real - v_total_journal;

  v_result := json_build_object(
    'success', true,
    'location_id', p_location_id,
    'location_name', v_location_name,
    'location_type', v_location_type,
    'total_journal', v_total_journal,
    'total_real', v_total_real,
    'difference', v_difference,
    'is_balanced', ABS(v_difference) < 0.01,
    'has_shortage', v_difference < -0.01,
    'has_surplus', v_difference > 0.01,
    'currency_symbol', v_currency_symbol,
    'currency_code', v_currency_code,
    'last_updated', NOW()
  );

  RETURN v_result;

EXCEPTION
  WHEN OTHERS THEN
    RETURN json_build_object(
      'success', false,
      'error', SQLERRM,
      'detail', SQLSTATE,
      'location_id', p_location_id
    );
END;
$function$;

-- ========================================
-- 2. get_multiple_locations_balance_summary_utc
-- ========================================

DROP FUNCTION IF EXISTS get_multiple_locations_balance_summary_utc(uuid[]);

CREATE OR REPLACE FUNCTION get_multiple_locations_balance_summary_utc(p_location_ids uuid[])
 RETURNS json
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
  v_result JSON;
BEGIN
  SELECT json_agg(
    json_build_object(
      'location_id', cash_location_id,
      'location_name', location_name,
      'location_type', location_type,
      'total_journal', COALESCE(total_journal_cash_amount, 0),
      'total_real', COALESCE(total_real_cash_amount, 0),
      'difference', COALESCE(cash_difference, 0),
      'is_balanced', ABS(COALESCE(cash_difference, 0)) < 0.01,
      'currency_symbol', primary_currency_symbol,
      'currency_code', primary_currency_code
    )
  )
  INTO v_result
  FROM v_cash_location
  WHERE cash_location_id = ANY(p_location_ids)
    AND is_deleted = false;

  RETURN json_build_object(
    'success', true,
    'count', jsonb_array_length(COALESCE(v_result, '[]'::json)),
    'locations', COALESCE(v_result, '[]'::json)
  );

EXCEPTION
  WHEN OTHERS THEN
    RETURN json_build_object(
      'success', false,
      'error', SQLERRM,
      'detail', SQLSTATE
    );
END;
$function$;

-- ========================================
-- 3. get_company_balance_summary_utc
-- ========================================

DROP FUNCTION IF EXISTS get_company_balance_summary_utc(uuid, text);

CREATE OR REPLACE FUNCTION get_company_balance_summary_utc(p_company_id uuid, p_location_type text DEFAULT NULL::text)
 RETURNS json
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
  v_result JSON;
BEGIN
  SELECT json_build_object(
    'success', true,
    'company_id', p_company_id,
    'location_type_filter', p_location_type,
    'total_journal', COALESCE(SUM(total_journal_cash_amount), 0),
    'total_real', COALESCE(SUM(total_real_cash_amount), 0),
    'total_difference', COALESCE(SUM(cash_difference), 0),
    'location_count', COUNT(*),
    'balanced_count', COUNT(*) FILTER (WHERE ABS(COALESCE(cash_difference, 0)) < 0.01),
    'shortage_count', COUNT(*) FILTER (WHERE cash_difference < -0.01),
    'surplus_count', COUNT(*) FILTER (WHERE cash_difference > 0.01),
    'locations', json_agg(
      json_build_object(
        'location_id', cash_location_id,
        'location_name', location_name,
        'location_type', location_type,
        'total_journal', COALESCE(total_journal_cash_amount, 0),
        'total_real', COALESCE(total_real_cash_amount, 0),
        'difference', COALESCE(cash_difference, 0),
        'is_balanced', ABS(COALESCE(cash_difference, 0)) < 0.01
      )
    )
  )
  INTO v_result
  FROM v_cash_location
  WHERE company_id = p_company_id
    AND is_deleted = false
    AND (p_location_type IS NULL OR location_type = p_location_type);

  RETURN COALESCE(v_result, json_build_object(
    'success', true,
    'company_id', p_company_id,
    'total_journal', 0,
    'total_real', 0,
    'total_difference', 0,
    'location_count', 0,
    'locations', '[]'::json
  ));

EXCEPTION
  WHEN OTHERS THEN
    RETURN json_build_object(
      'success', false,
      'error', SQLERRM,
      'detail', SQLSTATE
    );
END;
$function$;

-- ========================================
-- 4. get_location_stock_flow_utc
-- ✅ UTC 변경: created_at, system_time → _utc 버전
-- ========================================

DROP FUNCTION IF EXISTS get_location_stock_flow_utc(uuid, uuid, uuid, integer, integer);

CREATE OR REPLACE FUNCTION get_location_stock_flow_utc(p_company_id uuid, p_store_id uuid, p_cash_location_id uuid, p_offset integer DEFAULT 0, p_limit integer DEFAULT 20)
 RETURNS json
 LANGUAGE plpgsql
AS $function$DECLARE
    result JSON;
BEGIN
    WITH
    location_info AS (
        SELECT
            cl.cash_location_id,
            cl.location_name,
            cl.location_type,
            cl.bank_name,
            cl.bank_account,
            COALESCE(cl.currency_id,
                (SELECT currency_id FROM cash_amount_stock_flow
                 WHERE cash_location_id = cl.cash_location_id
                 AND company_id = p_company_id
                 ORDER BY system_time_utc DESC  -- ✅ UTC
                 LIMIT 1)
            ) as currency_id,
            COALESCE(ct.currency_code,
                (SELECT ct2.currency_code FROM cash_amount_stock_flow c2
                 JOIN currency_types ct2 ON c2.currency_id = ct2.currency_id
                 WHERE c2.cash_location_id = cl.cash_location_id
                 AND c2.company_id = p_company_id
                 ORDER BY c2.system_time_utc DESC  -- ✅ UTC
                 LIMIT 1)
            ) as currency_code,
            COALESCE(ct.currency_name,
                (SELECT ct2.currency_name FROM cash_amount_stock_flow c2
                 JOIN currency_types ct2 ON c2.currency_id = ct2.currency_id
                 WHERE c2.cash_location_id = cl.cash_location_id
                 AND c2.company_id = p_company_id
                 ORDER BY c2.system_time_utc DESC  -- ✅ UTC
                 LIMIT 1)
            ) as currency_name,
            c.base_currency_id,
            bct.currency_code as base_currency_code,
            bct.currency_name as base_currency_name,
            bct.symbol as base_currency_symbol
        FROM cash_locations cl
        LEFT JOIN currency_types ct ON cl.currency_id = ct.currency_id
        LEFT JOIN companies c ON c.company_id = p_company_id
        LEFT JOIN currency_types bct ON c.base_currency_id = bct.currency_id
        WHERE cl.cash_location_id = p_cash_location_id
        AND cl.company_id = p_company_id
        AND cl.is_deleted = false
        LIMIT 1
    ),

    journal_flows_data AS (
        SELECT
            j.flow_id,
            j.created_at_utc as created_at,  -- ✅ UTC
            j.system_time_utc as system_time,  -- ✅ UTC
            j.balance_before,
            j.flow_amount,
            j.balance_after,
            j.journal_id,
            je.description as journal_description,
            je.journal_type,
            j.account_id,
            a.account_name,
            j.created_by,
            CONCAT(u.first_name, ' ', u.last_name) as created_by_name,
            (
                SELECT json_build_object(
                    'account_id', jl2.account_id,
                    'account_name', a2.account_name,
                    'account_type', a2.account_type,
                    'debit', jl2.debit,
                    'credit', jl2.credit,
                    'description', jl2.description,
                    'cash_location_id', jl2.cash_location_id,
                    'cash_location_name', cl2.location_name
                )
                FROM journal_lines jl2
                LEFT JOIN accounts a2 ON jl2.account_id = a2.account_id
                LEFT JOIN cash_locations cl2 ON jl2.cash_location_id = cl2.cash_location_id
                WHERE jl2.journal_id = j.journal_id
                AND (jl2.cash_location_id IS NULL OR jl2.cash_location_id != j.cash_location_id)
                AND jl2.is_deleted = false
                ORDER BY GREATEST(jl2.debit, jl2.credit) DESC
                LIMIT 1
            ) as counter_account
        FROM journal_amount_stock_flow j
        LEFT JOIN journal_entries je ON j.journal_id = je.journal_id
        LEFT JOIN accounts a ON j.account_id = a.account_id
        LEFT JOIN users u ON j.created_by = u.user_id
        WHERE j.company_id = p_company_id
        AND j.store_id = p_store_id
        AND j.cash_location_id = p_cash_location_id
        ORDER BY j.system_time_utc DESC  -- ✅ UTC
        OFFSET p_offset
        LIMIT p_limit
    ),

    actual_flows_data AS (
        SELECT
            c.flow_id,
            c.created_at_utc as created_at,  -- ✅ UTC
            c.system_time_utc as system_time,  -- ✅ UTC
            c.balance_before,
            c.flow_amount,
            c.balance_after,
            c.currency_id,
            ct.currency_code,
            ct.currency_name,
            ct.symbol as currency_symbol,
            c.denomination_details,
            c.created_by,
            c.location_type,
            CONCAT(u.first_name, ' ', u.last_name) as created_by_name
        FROM cash_amount_stock_flow c
        LEFT JOIN currency_types ct ON c.currency_id = ct.currency_id
        LEFT JOIN users u ON c.created_by = u.user_id
        WHERE c.company_id = p_company_id
        AND c.store_id = p_store_id
        AND c.cash_location_id = p_cash_location_id
        ORDER BY c.system_time_utc DESC  -- ✅ UTC
        OFFSET p_offset
        LIMIT p_limit
    ),

    total_counts AS (
        SELECT
            (SELECT COUNT(*) FROM journal_amount_stock_flow
             WHERE company_id = p_company_id
             AND store_id = p_store_id
             AND cash_location_id = p_cash_location_id) as total_journal_flows,
            (SELECT COUNT(*) FROM cash_amount_stock_flow
             WHERE company_id = p_company_id
             AND store_id = p_store_id
             AND cash_location_id = p_cash_location_id) as total_actual_flows
    )

    SELECT json_build_object(
        'success', true,
        'data', json_build_object(
            'location_summary', (
                SELECT json_build_object(
                    'cash_location_id', cash_location_id,
                    'location_name', location_name,
                    'location_type', location_type,
                    'bank_name', bank_name,
                    'bank_account', bank_account,
                    'currency_id', currency_id,
                    'currency_code', currency_code,
                    'currency_name', currency_name,
                    'base_currency_id', base_currency_id,
                    'base_currency_code', base_currency_code,
                    'base_currency_name', base_currency_name,
                    'base_currency_symbol', base_currency_symbol
                )
                FROM location_info
            ),

            'journal_flows', COALESCE(
                (SELECT json_agg(
                    json_build_object(
                        'flow_id', flow_id,
                        'created_at', created_at,
                        'system_time', system_time,
                        'balance_before', balance_before,
                        'flow_amount', flow_amount,
                        'balance_after', balance_after,
                        'journal_id', journal_id,
                        'journal_description', journal_description,
                        'journal_type', journal_type,
                        'account_id', account_id,
                        'account_name', account_name,
                        'created_by', json_build_object(
                            'user_id', created_by,
                            'full_name', created_by_name
                        ),
                        'counter_account', counter_account
                    )
                    ORDER BY system_time DESC
                ) FROM journal_flows_data),
                '[]'::json
            ),

            'actual_flows', COALESCE(
                (SELECT json_agg(
                    json_build_object(
                        'flow_id', flow_id,
                        'created_at', created_at,
                        'system_time', system_time,
                        'balance_before', balance_before,
                        'flow_amount', flow_amount,
                        'balance_after', balance_after,
                        'currency', json_build_object(
                            'currency_id', currency_id,
                            'currency_code', currency_code,
                            'currency_name', currency_name,
                            'symbol', currency_symbol
                        ),
                        'created_by', json_build_object(
                            'user_id', created_by,
                            'full_name', created_by_name
                        ),
                        'current_denominations',
                        CASE
                            WHEN location_type = 'bank' THEN
                                CASE
                                    WHEN denomination_details IS NOT NULL
                                    AND denomination_details->>'bank_total_amount' IS NOT NULL
                                    THEN json_build_array(
                                        json_build_object(
                                            'bank_total_amount', (denomination_details->>'bank_total_amount')::numeric,
                                            'is_bank_type', true
                                        )
                                    )
                                    ELSE '[]'::json
                                END
                            WHEN location_type = 'vault'
                            AND denomination_details IS NOT NULL
                            AND denomination_details->'items' IS NOT NULL
                            THEN (
                                SELECT json_agg(denomination_obj)
                                FROM (
                                    SELECT
                                        json_build_object(
                                            'denomination_id', item->>'denomination_id',
                                            'denomination_value', (item->>'denomination_value')::numeric,
                                            'denomination_type', cd.type,
                                            'previous_quantity', (item->>'previous_quantity')::int,
                                            'current_quantity', (item->>'current_quantity')::int,
                                            'quantity_change', (item->>'quantity')::int,
                                            'subtotal', (item->>'current_quantity')::int * (item->>'denomination_value')::numeric,
                                            'currency_id', COALESCE(item->>'currency_id', cd.currency_id::text),
                                            'currency_code', ct.currency_code,
                                            'currency_name', ct.currency_name,
                                            'currency_symbol', ct.symbol
                                        ) as denomination_obj
                                    FROM jsonb_array_elements(denomination_details->'items') AS item
                                    LEFT JOIN currency_denominations cd ON cd.denomination_id = (item->>'denomination_id')::uuid
                                    LEFT JOIN currency_types ct ON ct.currency_id = COALESCE((item->>'currency_id')::uuid, cd.currency_id)
                                    ORDER BY (item->>'denomination_value')::numeric DESC
                                ) sorted_denoms
                            )
                            WHEN location_type = 'vault'
                            AND denomination_details IS NOT NULL
                            AND denomination_details->'current_holdings' IS NOT NULL
                            THEN (
                                SELECT json_agg(denomination_obj)
                                FROM (
                                    SELECT
                                        json_build_object(
                                            'denomination_id', denom_id,
                                            'denomination_value', cd.value,
                                            'denomination_type', cd.type,
                                            'current_quantity', (denomination_details->'current_holdings'->>denom_id)::int,
                                            'transaction_quantity', COALESCE(
                                                (SELECT (item->>'net_quantity')::int
                                                 FROM jsonb_array_elements(denomination_details->'transaction_items') AS item
                                                 WHERE item->>'denomination_id' = denom_id),
                                                0
                                            ),
                                            'subtotal', (denomination_details->'current_holdings'->>denom_id)::numeric * cd.value,
                                            'currency_id', cd.currency_id,
                                            'currency_code', (SELECT currency_code FROM currency_types WHERE currency_id = cd.currency_id),
                                            'currency_name', (SELECT currency_name FROM currency_types WHERE currency_id = cd.currency_id),
                                            'currency_symbol', (SELECT symbol FROM currency_types WHERE currency_id = cd.currency_id)
                                        ) as denomination_obj,
                                        cd.value
                                    FROM jsonb_object_keys(denomination_details->'current_holdings') AS denom_id
                                    LEFT JOIN currency_denominations cd ON cd.denomination_id = denom_id::uuid
                                    ORDER BY cd.value DESC
                                ) sorted_denoms
                            )
                            WHEN location_type = 'cash'
                            AND denomination_details IS NOT NULL
                            AND denomination_details->'items' IS NOT NULL
                            THEN (
                                SELECT json_agg(denomination_obj)
                                FROM (
                                    SELECT
                                        json_build_object(
                                            'denomination_id', item->>'denomination_id',
                                            'denomination_value', (item->>'denomination_value')::numeric,
                                            'denomination_type', cd.type,
                                            'previous_quantity', (item->>'previous_quantity')::int,
                                            'current_quantity', (item->>'current_quantity')::int,
                                            'quantity_change', (item->>'current_quantity')::int - (item->>'previous_quantity')::int,
                                            'subtotal', (item->>'current_quantity')::int * (item->>'denomination_value')::numeric,
                                            'currency_id', COALESCE(item->>'currency_id', cd.currency_id::text),
                                            'currency_code', ct.currency_code,
                                            'currency_name', ct.currency_name,
                                            'currency_symbol', ct.symbol
                                        ) as denomination_obj
                                    FROM jsonb_array_elements(denomination_details->'items') AS item
                                    LEFT JOIN currency_denominations cd ON cd.denomination_id = (item->>'denomination_id')::uuid
                                    LEFT JOIN currency_types ct ON ct.currency_id = COALESCE((item->>'currency_id')::uuid, cd.currency_id)
                                    ORDER BY (item->>'denomination_value')::numeric DESC
                                ) sorted_denoms
                            )
                            ELSE '[]'::json
                        END
                    )
                    ORDER BY system_time DESC
                ) FROM actual_flows_data),
                '[]'::json
            )
        ),
        'pagination', json_build_object(
            'offset', p_offset,
            'limit', p_limit,
            'total_journal_flows', (SELECT total_journal_flows FROM total_counts),
            'total_actual_flows', (SELECT total_actual_flows FROM total_counts),
            'has_more', (
                (SELECT total_journal_flows FROM total_counts) > (p_offset + p_limit) OR
                (SELECT total_actual_flows FROM total_counts) > (p_offset + p_limit)
            )
        )
    ) INTO result;

    RETURN result;
END;$function$;
