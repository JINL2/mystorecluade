-- Fix existing users by populating names from auth metadata
-- This migration will update existing users in the users table with data from auth.users

-- Update existing users with names from auth metadata
UPDATE users 
SET 
    first_name = COALESCE(
        auth_users.raw_user_meta_data->>'first_name',
        -- Fallback: try to extract first name from full_name
        CASE 
            WHEN auth_users.raw_user_meta_data->>'full_name' IS NOT NULL THEN
                SPLIT_PART(auth_users.raw_user_meta_data->>'full_name', ' ', 1)
            ELSE NULL
        END
    ),
    last_name = COALESCE(
        auth_users.raw_user_meta_data->>'last_name',
        -- Fallback: try to extract last name from full_name
        CASE 
            WHEN auth_users.raw_user_meta_data->>'full_name' IS NOT NULL AND
                 ARRAY_LENGTH(STRING_TO_ARRAY(auth_users.raw_user_meta_data->>'full_name', ' '), 1) > 1 THEN
                SPLIT_PART(auth_users.raw_user_meta_data->>'full_name', ' ', 2)
            ELSE NULL
        END
    ),
    updated_at = NOW()
FROM auth.users AS auth_users
WHERE users.user_id = auth_users.id
  AND (users.first_name IS NULL OR users.last_name IS NULL);

-- Insert missing user records for auth users that don't have profiles yet
INSERT INTO users (
    user_id,
    first_name,
    last_name,
    email,
    created_at,
    updated_at
)
SELECT 
    auth_users.id,
    COALESCE(
        auth_users.raw_user_meta_data->>'first_name',
        CASE 
            WHEN auth_users.raw_user_meta_data->>'full_name' IS NOT NULL THEN
                SPLIT_PART(auth_users.raw_user_meta_data->>'full_name', ' ', 1)
            ELSE NULL
        END
    ),
    COALESCE(
        auth_users.raw_user_meta_data->>'last_name',
        CASE 
            WHEN auth_users.raw_user_meta_data->>'full_name' IS NOT NULL AND
                 ARRAY_LENGTH(STRING_TO_ARRAY(auth_users.raw_user_meta_data->>'full_name', ' '), 1) > 1 THEN
                SPLIT_PART(auth_users.raw_user_meta_data->>'full_name', ' ', 2)
            ELSE NULL
        END
    ),
    auth_users.email,
    auth_users.created_at,
    NOW()
FROM auth.users AS auth_users
LEFT JOIN users ON users.user_id = auth_users.id
WHERE users.user_id IS NULL
  AND auth_users.email IS NOT NULL;

-- Log the results
DO $$
DECLARE
    updated_count INTEGER;
    inserted_count INTEGER;
BEGIN
    GET DIAGNOSTICS updated_count = ROW_COUNT;
    RAISE NOTICE 'Updated % existing user records with names from auth metadata', updated_count;
    
    -- Count newly inserted records (this is approximate)
    SELECT COUNT(*) INTO inserted_count
    FROM users 
    WHERE updated_at = created_at 
      AND updated_at > NOW() - INTERVAL '1 minute';
    
    RAISE NOTICE 'Inserted % new user records from auth users', inserted_count;
END
$$;