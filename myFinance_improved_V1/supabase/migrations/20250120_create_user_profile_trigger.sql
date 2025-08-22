-- Create function to automatically create user profile on auth signup
CREATE OR REPLACE FUNCTION create_user_profile()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Insert into our custom users table when a new user signs up
    INSERT INTO users (
        user_id,
        first_name,
        last_name,
        email,
        created_at,
        updated_at
    ) VALUES (
        NEW.id,
        NEW.raw_user_meta_data->>'first_name',
        NEW.raw_user_meta_data->>'last_name',
        NEW.email,
        NOW(),
        NOW()
    );
    
    RETURN NEW;
EXCEPTION
    WHEN OTHERS THEN
        -- Log error but don't fail the auth signup
        RAISE WARNING 'Failed to create user profile: %', SQLERRM;
        RETURN NEW;
END;
$$;

-- Create trigger on auth.users table
DROP TRIGGER IF EXISTS create_user_profile_trigger ON auth.users;
CREATE TRIGGER create_user_profile_trigger
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION create_user_profile();

-- Grant necessary permissions
GRANT USAGE ON SCHEMA auth TO postgres;
GRANT ALL ON auth.users TO postgres;

-- Optional: Create function to handle user profile updates
CREATE OR REPLACE FUNCTION update_user_profile()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Update our custom users table when auth user is updated
    UPDATE users SET
        first_name = NEW.raw_user_meta_data->>'first_name',
        last_name = NEW.raw_user_meta_data->>'last_name',
        email = NEW.email,
        updated_at = NOW()
    WHERE user_id = NEW.id;
    
    RETURN NEW;
EXCEPTION
    WHEN OTHERS THEN
        -- Log error but don't fail the auth update
        RAISE WARNING 'Failed to update user profile: %', SQLERRM;
        RETURN NEW;
END;
$$;

-- Create update trigger on auth.users table
DROP TRIGGER IF EXISTS update_user_profile_trigger ON auth.users;
CREATE TRIGGER update_user_profile_trigger
    AFTER UPDATE ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION update_user_profile();

-- Grant execute permissions
GRANT EXECUTE ON FUNCTION create_user_profile() TO authenticated;
GRANT EXECUTE ON FUNCTION update_user_profile() TO authenticated;