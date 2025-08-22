-- Function to generate a unique company code
CREATE OR REPLACE FUNCTION generate_company_code(p_company_name TEXT)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    v_code TEXT;
    v_prefix TEXT;
    v_random TEXT;
    v_exists BOOLEAN;
    v_attempts INTEGER := 0;
    v_max_attempts INTEGER := 100;
BEGIN
    -- Clean the company name to get a prefix (remove spaces and special chars)
    v_prefix := UPPER(REGEXP_REPLACE(p_company_name, '[^A-Za-z0-9]', '', 'g'));
    
    -- If prefix is too long, take first 3 characters
    IF LENGTH(v_prefix) > 3 THEN
        v_prefix := SUBSTRING(v_prefix FROM 1 FOR 3);
    -- If prefix is empty, use 'COM' as default
    ELSIF LENGTH(v_prefix) = 0 THEN
        v_prefix := 'COM';
    END IF;
    
    -- Generate unique code with retry logic
    LOOP
        -- Generate 3 random alphanumeric characters
        v_random := UPPER(
            SUBSTRING(MD5(RANDOM()::TEXT || CLOCK_TIMESTAMP()::TEXT) FROM 1 FOR 3)
        );
        
        -- Combine prefix with random to create 6-character code
        IF LENGTH(v_prefix) = 3 THEN
            v_code := v_prefix || v_random;
        ELSIF LENGTH(v_prefix) = 2 THEN
            v_code := v_prefix || SUBSTRING(v_random FROM 1 FOR 1) || v_random;
        ELSIF LENGTH(v_prefix) = 1 THEN
            v_code := v_prefix || v_random || SUBSTRING(MD5(RANDOM()::TEXT) FROM 1 FOR 2);
        ELSE
            v_code := 'COM' || v_random;
        END IF;
        
        -- Ensure code is exactly 6 characters and uppercase
        v_code := UPPER(SUBSTRING(v_code FROM 1 FOR 6));
        
        -- Pad with random characters if needed
        WHILE LENGTH(v_code) < 6 LOOP
            v_code := v_code || UPPER(SUBSTRING(MD5(RANDOM()::TEXT) FROM 1 FOR 1));
        END LOOP;
        
        -- Check if code already exists
        SELECT EXISTS(
            SELECT 1 FROM companies 
            WHERE company_code = v_code 
            AND is_deleted = false
        ) INTO v_exists;
        
        -- If code doesn't exist, we found a unique one
        IF NOT v_exists THEN
            EXIT;
        END IF;
        
        -- Increment attempts counter
        v_attempts := v_attempts + 1;
        
        -- Prevent infinite loop
        IF v_attempts >= v_max_attempts THEN
            -- If we can't find a unique code after max attempts, 
            -- generate a completely random 6-character code
            v_code := UPPER(SUBSTRING(MD5(RANDOM()::TEXT || NOW()::TEXT) FROM 1 FOR 6));
            EXIT;
        END IF;
    END LOOP;
    
    RETURN v_code;
END;
$$;

-- Trigger function to automatically generate company code on insert
CREATE OR REPLACE FUNCTION set_company_code()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Only generate code if not provided or empty
    IF NEW.company_code IS NULL OR NEW.company_code = '' THEN
        NEW.company_code := generate_company_code(NEW.company_name);
    END IF;
    RETURN NEW;
END;
$$;

-- Create trigger to auto-generate company code before insert
DROP TRIGGER IF EXISTS companies_generate_code_trigger ON companies;
CREATE TRIGGER companies_generate_code_trigger
    BEFORE INSERT ON companies
    FOR EACH ROW
    EXECUTE FUNCTION set_company_code();

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION generate_company_code(TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION set_company_code() TO authenticated;

-- Test the function (optional - can be commented out in production)
-- SELECT generate_company_code('My Test Company');