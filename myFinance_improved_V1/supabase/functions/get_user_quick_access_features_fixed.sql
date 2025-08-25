-- Fixed RPC function for getting user's quick access features
CREATE OR REPLACE FUNCTION get_user_quick_access_features(
    p_user_id UUID,
    p_company_id TEXT DEFAULT NULL
) RETURNS JSON
LANGUAGE plpgsql
AS $$
DECLARE
    v_top_features JSON;
    v_default_features JSON;
    v_user_feature_count INTEGER;
    v_final_features JSON;
BEGIN
    -- Debug: Log function call
    RAISE NOTICE 'get_user_quick_access_features called with user_id: %, company_id: %', p_user_id, p_company_id;
    
    -- STEP 1: Get user's actual clicked features
    -- Query user_preferences directly instead of relying on view
    IF p_company_id IS NOT NULL AND p_company_id != '' THEN
        SELECT json_agg(
            json_build_object(
                'feature_id', f.feature_id,
                'feature_name', f.feature_name,
                'icon', COALESCE(f.icon, ''),
                'icon_key', COALESCE(f.icon_key, f.feature_id),
                'route', f.route,
                'category_id', f.category_id,
                'click_count', up.click_count,
                'is_show_main', COALESCE(f.is_show_main, true),
                'is_default', false
            ) ORDER BY up.click_count DESC
        ) INTO v_top_features
        FROM user_preferences up
        JOIN features f ON up.feature_id = f.feature_id
        WHERE up.user_id = p_user_id 
          AND up.company_id = p_company_id
          AND up.click_count > 0
          AND f.route IS NOT NULL 
          AND f.route != ''
          AND COALESCE(f.is_show_main, true) = true
        LIMIT 6;
    ELSE
        -- Fallback without company_id for backward compatibility
        SELECT json_agg(
            json_build_object(
                'feature_id', f.feature_id,
                'feature_name', f.feature_name,
                'icon', COALESCE(f.icon, ''),
                'icon_key', COALESCE(f.icon_key, f.feature_id),
                'route', f.route,
                'category_id', f.category_id,
                'click_count', up.click_count,
                'is_show_main', COALESCE(f.is_show_main, true),
                'is_default', false
            ) ORDER BY up.click_count DESC
        ) INTO v_top_features
        FROM user_preferences up
        JOIN features f ON up.feature_id = f.feature_id
        WHERE up.user_id = p_user_id 
          AND up.click_count > 0
          AND f.route IS NOT NULL 
          AND f.route != ''
          AND COALESCE(f.is_show_main, true) = true
        LIMIT 6;
    END IF;
    
    v_user_feature_count := COALESCE(json_array_length(v_top_features), 0);
    
    RAISE NOTICE 'Found % user features', v_user_feature_count;
    
    -- STEP 2: If user has fewer than 3 features (reduced threshold), add defaults
    IF v_user_feature_count < 3 THEN
        -- Get default features that are commonly used
        WITH user_features AS (
            SELECT feature_data->>'feature_id' as feature_id
            FROM json_array_elements(COALESCE(v_top_features, '[]'::json)) AS feature_data
        ),
        default_candidates AS (
            SELECT json_build_object(
                'feature_id', f.feature_id,
                'feature_name', f.feature_name,
                'icon', COALESCE(f.icon, ''),
                'icon_key', COALESCE(f.icon_key, f.feature_id),
                'route', f.route,
                'category_id', f.category_id,
                'click_count', 0,
                'is_show_main', COALESCE(f.is_show_main, true),
                'is_default', true
            ) as feature_obj
            FROM features f
            LEFT JOIN user_features uf ON f.feature_id = uf.feature_id
            WHERE uf.feature_id IS NULL  -- Not in user's current list
                AND f.route IS NOT NULL 
                AND f.route != ''
                AND COALESCE(f.is_show_main, true) = true
            ORDER BY 
                CASE f.feature_id 
                    WHEN 'attendance' THEN 1
                    WHEN 'journal_input' THEN 2
                    WHEN 'cash_ending' THEN 3
                    WHEN 'transactions' THEN 4
                    WHEN 'counterparty' THEN 5
                    WHEN 'employee_setting' THEN 6
                    ELSE 99
                END,
                f.created_at DESC
            LIMIT (6 - v_user_feature_count)
        )
        SELECT json_agg(feature_obj) INTO v_default_features
        FROM default_candidates;
        
        -- Combine user features with defaults
        IF v_user_feature_count > 0 AND v_default_features IS NOT NULL THEN
            SELECT json_agg(feature) INTO v_final_features
            FROM (
                SELECT json_array_elements(v_top_features) AS feature
                UNION ALL
                SELECT json_array_elements(v_default_features) AS feature
            ) combined;
        ELSIF v_default_features IS NOT NULL THEN
            v_final_features := v_default_features;
        END IF;
    ELSE
        v_final_features := v_top_features;
    END IF;
    
    -- STEP 3: Ensure we have at least some features to show
    IF v_final_features IS NULL OR json_array_length(v_final_features) = 0 THEN
        -- Last resort: Get any 6 common features
        SELECT json_agg(
            json_build_object(
                'feature_id', f.feature_id,
                'feature_name', f.feature_name,
                'icon', COALESCE(f.icon, ''),
                'icon_key', COALESCE(f.icon_key, f.feature_id),
                'route', f.route,
                'category_id', f.category_id,
                'click_count', 0,
                'is_show_main', COALESCE(f.is_show_main, true),
                'is_default', true
            )
        ) INTO v_final_features
        FROM features f
        WHERE f.route IS NOT NULL 
          AND f.route != ''
          AND COALESCE(f.is_show_main, true) = true
        ORDER BY 
            CASE f.feature_id 
                WHEN 'attendance' THEN 1
                WHEN 'journal_input' THEN 2
                WHEN 'cash_ending' THEN 3
                WHEN 'transactions' THEN 4
                WHEN 'counterparty' THEN 5
                WHEN 'employee_setting' THEN 6
                ELSE 99
            END,
            f.created_at DESC
        LIMIT 6;
    END IF;
    
    RAISE NOTICE 'Returning % features', COALESCE(json_array_length(v_final_features), 0);
    
    RETURN COALESCE(v_final_features, '[]'::json);
END;
$$;

-- Grant execute permissions
GRANT EXECUTE ON FUNCTION get_user_quick_access_features(UUID, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION get_user_quick_access_features(UUID, TEXT) TO anon;