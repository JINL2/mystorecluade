-- ============================================
-- Store Business Hours Table
-- ============================================
-- Purpose: Store operating hours for each day of the week
-- Used for: Shift coverage validation (alert if no shift covers business hours)
--
-- Design Decisions:
-- 1. One row per store per day of week (0=Sunday, 1=Monday, ..., 6=Saturday)
-- 2. is_open flag for closed days (open_time/close_time can be null)
-- 3. Supports cross-midnight hours (e.g., 22:00-02:00)
-- 4. Unique constraint: one entry per store per day
-- ============================================

-- Create table
CREATE TABLE IF NOT EXISTS store_business_hours (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID NOT NULL REFERENCES stores(store_id) ON DELETE CASCADE,
    day_of_week SMALLINT NOT NULL CHECK (day_of_week >= 0 AND day_of_week <= 6),
    -- 0=Sunday, 1=Monday, 2=Tuesday, 3=Wednesday, 4=Thursday, 5=Friday, 6=Saturday
    is_open BOOLEAN NOT NULL DEFAULT true,
    open_time TIME, -- NULL if closed
    close_time TIME, -- NULL if closed (can be < open_time for cross-midnight)
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    -- Each store can only have one entry per day
    CONSTRAINT unique_store_day UNIQUE (store_id, day_of_week)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_store_business_hours_store_id
    ON store_business_hours(store_id);

-- RLS policies
ALTER TABLE store_business_hours ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist (for re-running migration)
DROP POLICY IF EXISTS "Users can view business hours for their stores" ON store_business_hours;
DROP POLICY IF EXISTS "Managers can manage business hours" ON store_business_hours;

-- Allow read access for authenticated users who have access to the store
-- Uses user_stores table (not employees) for store-user relationship
CREATE POLICY "Users can view business hours for their stores"
    ON store_business_hours
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM user_stores us
            WHERE us.store_id = store_business_hours.store_id
            AND us.user_id = auth.uid()
            AND us.is_deleted = false
        )
    );

-- Allow managers/owners to modify business hours
-- Check role via user_roles and roles tables
CREATE POLICY "Managers can manage business hours"
    ON store_business_hours
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM user_stores us
            JOIN stores s ON s.store_id = us.store_id
            JOIN companies c ON c.company_id = s.company_id
            WHERE us.store_id = store_business_hours.store_id
            AND us.user_id = auth.uid()
            AND us.is_deleted = false
            AND (
                -- Owner of the company
                c.owner_id = auth.uid()
                OR
                -- User has manager role
                EXISTS (
                    SELECT 1 FROM user_roles ur
                    JOIN roles r ON r.role_id = ur.role_id
                    WHERE ur.user_id = auth.uid()
                    AND ur.is_deleted = false
                    AND r.company_id = c.company_id
                    AND r.role_type IN ('owner', 'manager')
                )
            )
        )
    );

-- ============================================
-- RPC: Get Business Hours for a Store
-- ============================================
CREATE OR REPLACE FUNCTION get_store_business_hours(
    p_store_id UUID
)
RETURNS TABLE (
    day_of_week SMALLINT,
    day_name TEXT,
    is_open BOOLEAN,
    open_time TIME,
    close_time TIME
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    RETURN QUERY
    SELECT
        bh.day_of_week,
        CASE bh.day_of_week
            WHEN 0 THEN 'Sunday'
            WHEN 1 THEN 'Monday'
            WHEN 2 THEN 'Tuesday'
            WHEN 3 THEN 'Wednesday'
            WHEN 4 THEN 'Thursday'
            WHEN 5 THEN 'Friday'
            WHEN 6 THEN 'Saturday'
        END AS day_name,
        bh.is_open,
        bh.open_time,
        bh.close_time
    FROM store_business_hours bh
    WHERE bh.store_id = p_store_id
    ORDER BY bh.day_of_week;
END;
$$;

-- ============================================
-- RPC: Upsert Business Hours (batch update)
-- ============================================
-- Input: JSON array of business hours
-- Example: [
--   {"day_of_week": 1, "is_open": true, "open_time": "09:00", "close_time": "22:00"},
--   {"day_of_week": 0, "is_open": false, "open_time": null, "close_time": null}
-- ]
CREATE OR REPLACE FUNCTION upsert_store_business_hours(
    p_store_id UUID,
    p_hours JSONB
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_hour JSONB;
    v_count INT := 0;
BEGIN
    -- Validate input
    IF p_hours IS NULL OR jsonb_array_length(p_hours) = 0 THEN
        RETURN jsonb_build_object(
            'success', false,
            'message', 'Hours array is required'
        );
    END IF;

    -- Loop through each day and upsert
    FOR v_hour IN SELECT * FROM jsonb_array_elements(p_hours)
    LOOP
        INSERT INTO store_business_hours (
            store_id,
            day_of_week,
            is_open,
            open_time,
            close_time,
            updated_at
        )
        VALUES (
            p_store_id,
            (v_hour->>'day_of_week')::SMALLINT,
            COALESCE((v_hour->>'is_open')::BOOLEAN, true),
            (v_hour->>'open_time')::TIME,
            (v_hour->>'close_time')::TIME,
            now()
        )
        ON CONFLICT (store_id, day_of_week)
        DO UPDATE SET
            is_open = COALESCE((v_hour->>'is_open')::BOOLEAN, true),
            open_time = (v_hour->>'open_time')::TIME,
            close_time = (v_hour->>'close_time')::TIME,
            updated_at = now();

        v_count := v_count + 1;
    END LOOP;

    RETURN jsonb_build_object(
        'success', true,
        'message', format('Updated %s day(s)', v_count),
        'updated_count', v_count
    );
END;
$$;

-- ============================================
-- RPC: Check Shift Coverage Gaps
-- ============================================
-- Purpose: Find time gaps where business is open but no shift covers
-- Returns: List of gaps per day (for alert display)
--
-- Logic:
-- 1. For each day, get business hours (open_time to close_time)
-- 2. Get all active shifts for the store
-- 3. Calculate which time ranges are not covered
-- 4. Return gaps as array
CREATE OR REPLACE FUNCTION check_shift_coverage_gaps(
    p_store_id UUID,
    p_target_date DATE DEFAULT CURRENT_DATE
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_day_of_week SMALLINT;
    v_business_open TIME;
    v_business_close TIME;
    v_is_open BOOLEAN;
    v_gaps JSONB := '[]'::JSONB;
    v_shift RECORD;
    v_covered_ranges JSONB := '[]'::JSONB;
    v_has_gap BOOLEAN := false;
BEGIN
    -- Get day of week (0=Sunday in PostgreSQL's EXTRACT)
    v_day_of_week := EXTRACT(DOW FROM p_target_date)::SMALLINT;

    -- Get business hours for this day
    SELECT
        bh.is_open,
        bh.open_time,
        bh.close_time
    INTO v_is_open, v_business_open, v_business_close
    FROM store_business_hours bh
    WHERE bh.store_id = p_store_id
    AND bh.day_of_week = v_day_of_week;

    -- If no business hours set or closed, no gap
    IF NOT FOUND OR v_is_open = false THEN
        RETURN jsonb_build_object(
            'date', p_target_date,
            'day_of_week', v_day_of_week,
            'is_open', COALESCE(v_is_open, false),
            'has_gap', false,
            'gaps', '[]'::JSONB,
            'message', 'Closed or no business hours configured'
        );
    END IF;

    -- Get all active shifts' time ranges
    FOR v_shift IN
        SELECT
            s.shift_id,
            s.shift_name,
            s.shift_start_time::TIME as start_time,
            s.shift_end_time::TIME as end_time
        FROM store_shifts s
        WHERE s.store_id = p_store_id
        AND s.is_active = true
    LOOP
        v_covered_ranges := v_covered_ranges || jsonb_build_object(
            'shift_id', v_shift.shift_id,
            'shift_name', v_shift.shift_name,
            'start', v_shift.start_time::TEXT,
            'end', v_shift.end_time::TEXT
        );
    END LOOP;

    -- Simple gap detection: check if business start time is covered
    -- and if business end time is covered
    -- (Full gap analysis would require interval arithmetic - this is a simplified version)

    -- Check if any shift covers business open time
    IF NOT EXISTS (
        SELECT 1 FROM store_shifts s
        WHERE s.store_id = p_store_id
        AND s.is_active = true
        AND s.shift_start_time::TIME <= v_business_open
        AND s.shift_end_time::TIME >= v_business_open
    ) THEN
        v_has_gap := true;
        v_gaps := v_gaps || jsonb_build_object(
            'type', 'opening_gap',
            'time', v_business_open::TEXT,
            'message', 'No shift covers opening time'
        );
    END IF;

    -- Check if any shift covers business close time (for non-overnight)
    IF v_business_close > v_business_open THEN
        IF NOT EXISTS (
            SELECT 1 FROM store_shifts s
            WHERE s.store_id = p_store_id
            AND s.is_active = true
            AND s.shift_start_time::TIME <= v_business_close
            AND s.shift_end_time::TIME >= v_business_close
        ) THEN
            v_has_gap := true;
            v_gaps := v_gaps || jsonb_build_object(
                'type', 'closing_gap',
                'time', v_business_close::TEXT,
                'message', 'No shift covers closing time'
            );
        END IF;
    END IF;

    RETURN jsonb_build_object(
        'date', p_target_date,
        'day_of_week', v_day_of_week,
        'is_open', v_is_open,
        'business_hours', jsonb_build_object(
            'open', v_business_open::TEXT,
            'close', v_business_close::TEXT
        ),
        'has_gap', v_has_gap,
        'gaps', v_gaps,
        'shifts', v_covered_ranges
    );
END;
$$;

-- ============================================
-- Initialize default business hours for existing stores
-- ============================================
-- Uncomment if you want to initialize all stores with default hours
-- DO $$
-- DECLARE
--     v_store_id UUID;
-- BEGIN
--     FOR v_store_id IN SELECT store_id FROM stores
--     LOOP
--         -- Insert default hours for each day (Mon-Sat: 9-22, Sun: 10-21)
--         INSERT INTO store_business_hours (store_id, day_of_week, is_open, open_time, close_time)
--         VALUES
--             (v_store_id, 0, true, '10:00', '21:00'),  -- Sunday
--             (v_store_id, 1, true, '09:00', '22:00'),  -- Monday
--             (v_store_id, 2, true, '09:00', '22:00'),  -- Tuesday
--             (v_store_id, 3, true, '09:00', '22:00'),  -- Wednesday
--             (v_store_id, 4, true, '09:00', '22:00'),  -- Thursday
--             (v_store_id, 5, true, '09:00', '23:00'),  -- Friday
--             (v_store_id, 6, true, '10:00', '23:00')   -- Saturday
--         ON CONFLICT (store_id, day_of_week) DO NOTHING;
--     END LOOP;
-- END;
-- $$;

COMMENT ON TABLE store_business_hours IS 'Store operating hours per day of week. Used for shift coverage validation.';
COMMENT ON COLUMN store_business_hours.day_of_week IS '0=Sunday, 1=Monday, ..., 6=Saturday (PostgreSQL DOW convention)';
COMMENT ON COLUMN store_business_hours.is_open IS 'Whether the store is open on this day';
COMMENT ON COLUMN store_business_hours.open_time IS 'Opening time (NULL if closed)';
COMMENT ON COLUMN store_business_hours.close_time IS 'Closing time (NULL if closed). Can be < open_time for cross-midnight hours.';
