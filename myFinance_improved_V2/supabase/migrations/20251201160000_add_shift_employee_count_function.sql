-- Create function to get shift metadata with employee count
-- This function returns shift information along with the count of employees assigned to each shift
CREATE OR REPLACE FUNCTION public.get_shift_metadata_with_employee_count(
  p_store_id uuid,
  p_timezone text DEFAULT 'Asia/Ho_Chi_Minh'
)
RETURNS TABLE(
  shift_id uuid,
  store_id uuid,
  shift_name text,
  start_time text,
  end_time text,
  number_shift integer,
  is_active boolean,
  is_can_overtime boolean,
  shift_bonus numeric,
  employee_count bigint,
  created_at timestamptz,
  updated_at timestamptz
)
LANGUAGE sql
STABLE
AS $$
  SELECT
    ss.shift_id,
    ss.store_id,
    ss.shift_name,
    to_char((ss.start_time_utc AT TIME ZONE 'UTC' AT TIME ZONE p_timezone)::time, 'HH24:MI') as start_time,
    to_char((ss.end_time_utc AT TIME ZONE 'UTC' AT TIME ZONE p_timezone)::time, 'HH24:MI') as end_time,
    ss.number_shift,
    ss.is_active,
    ss.is_can_overtime,
    ss.shift_bonus,
    COALESCE(COUNT(DISTINCT sr.user_id) FILTER (WHERE sr.is_approved = true), 0) as employee_count,
    ss.created_at,
    ss.updated_at
  FROM store_shifts ss
  LEFT JOIN shift_requests sr ON ss.shift_id = sr.shift_id
  WHERE ss.store_id = p_store_id
    AND ss.is_active = true
  GROUP BY ss.shift_id, ss.store_id, ss.shift_name, ss.start_time_utc,
           ss.end_time_utc, ss.number_shift, ss.is_active, ss.is_can_overtime,
           ss.shift_bonus, ss.created_at, ss.updated_at
  ORDER BY ss.start_time_utc;
$$;

-- Add comment
COMMENT ON FUNCTION public.get_shift_metadata_with_employee_count(uuid, text) IS
'Returns shift metadata with employee count for a specific store. Employee count includes only approved shift requests.';
