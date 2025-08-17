-- RPC function for getting company users with properly scoped roles
-- Returns users with their roles filtered by the specified company

CREATE OR REPLACE FUNCTION get_company_users_with_roles(p_company_id UUID)
RETURNS TABLE (
  user_id UUID,
  first_name TEXT,
  last_name TEXT,
  email TEXT,
  role_name TEXT
) 
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT DISTINCT ON (u.user_id) 
    u.user_id,
    u.first_name::TEXT,
    u.last_name::TEXT,
    u.email::TEXT,
    COALESCE(r.role_name::TEXT, 'No Role'::TEXT) as role_name
  FROM user_companies uc
  JOIN users u ON uc.user_id = u.user_id
  LEFT JOIN user_roles ur ON u.user_id = ur.user_id 
    AND ur.is_deleted = false
  LEFT JOIN roles r ON ur.role_id = r.role_id 
    AND r.company_id = p_company_id
  WHERE uc.company_id = p_company_id 
    AND uc.is_deleted = false
    AND u.is_deleted = false
  ORDER BY u.user_id, ur.user_role_id DESC NULLS LAST;
END;
$$;