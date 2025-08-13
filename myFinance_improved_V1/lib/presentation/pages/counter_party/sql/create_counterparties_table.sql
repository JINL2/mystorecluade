-- Create counterparties table if it doesn't exist
CREATE TABLE IF NOT EXISTS counterparties (
    counterparty_id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    company_id UUID NOT NULL REFERENCES companies(company_id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    type TEXT CHECK (type IN ('My Company', 'Team Member', 'Suppliers', 'Employees', 'Customers', 'Others')),
    email TEXT,
    phone TEXT,
    address TEXT,
    notes TEXT,
    is_internal BOOLEAN DEFAULT FALSE,
    is_deleted BOOLEAN DEFAULT FALSE,
    linked_company_id UUID,
    created_by UUID REFERENCES auth.users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_transaction_date TIMESTAMP WITH TIME ZONE,
    total_transactions INTEGER DEFAULT 0,
    balance DECIMAL(15,2) DEFAULT 0.00,
    
    -- Indexes for performance
    INDEX idx_counterparties_company_id (company_id),
    INDEX idx_counterparties_type (type),
    INDEX idx_counterparties_is_deleted (is_deleted)
);

-- Create RLS policies
ALTER TABLE counterparties ENABLE ROW LEVEL SECURITY;

-- Policy to allow users to see counterparties for their companies
CREATE POLICY "Users can view counterparties for their companies" 
ON counterparties 
FOR SELECT 
USING (
    company_id IN (
        SELECT company_id 
        FROM user_companies 
        WHERE user_id = auth.uid()
    )
);

-- Policy to allow users to insert counterparties for their companies
CREATE POLICY "Users can create counterparties for their companies" 
ON counterparties 
FOR INSERT 
WITH CHECK (
    company_id IN (
        SELECT company_id 
        FROM user_companies 
        WHERE user_id = auth.uid()
    )
);

-- Policy to allow users to update counterparties for their companies
CREATE POLICY "Users can update counterparties for their companies" 
ON counterparties 
FOR UPDATE 
USING (
    company_id IN (
        SELECT company_id 
        FROM user_companies 
        WHERE user_id = auth.uid()
    )
);

-- Policy to allow users to delete (soft delete) counterparties for their companies
CREATE POLICY "Users can delete counterparties for their companies" 
ON counterparties 
FOR DELETE 
USING (
    company_id IN (
        SELECT company_id 
        FROM user_companies 
        WHERE user_id = auth.uid()
    )
);

-- Create the RPC function for getting unlinked companies
CREATE OR REPLACE FUNCTION get_unlinked_companies(
    p_user_id UUID,
    p_company_id UUID
)
RETURNS TABLE (
    company_id UUID,
    company_name TEXT
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT
        c.company_id,
        c.company_name
    FROM companies c
    INNER JOIN user_companies uc ON c.company_id = uc.company_id
    WHERE uc.user_id = p_user_id
    AND c.company_id != p_company_id
    AND NOT EXISTS (
        SELECT 1 
        FROM counterparties cp
        WHERE cp.linked_company_id = c.company_id
        AND cp.company_id = p_company_id
        AND cp.is_deleted = FALSE
    );
END;
$$;

-- Create a function to get counterparty statistics
CREATE OR REPLACE FUNCTION get_counterparty_stats(p_company_id UUID)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    result JSON;
BEGIN
    SELECT json_build_object(
        'total', COUNT(*),
        'suppliers', COUNT(*) FILTER (WHERE type = 'Suppliers'),
        'customers', COUNT(*) FILTER (WHERE type = 'Customers'),
        'employees', COUNT(*) FILTER (WHERE type = 'Employees'),
        'teamMembers', COUNT(*) FILTER (WHERE type = 'Team Member'),
        'myCompanies', COUNT(*) FILTER (WHERE type = 'My Company'),
        'others', COUNT(*) FILTER (WHERE type = 'Others'),
        'activeCount', COUNT(*) FILTER (WHERE is_deleted = FALSE),
        'inactiveCount', COUNT(*) FILTER (WHERE is_deleted = TRUE)
    ) INTO result
    FROM counterparties
    WHERE company_id = p_company_id;
    
    RETURN result;
END;
$$;

-- Insert some sample data (optional - comment out if not needed)
/*
INSERT INTO counterparties (company_id, name, type, email, phone, is_internal, is_deleted)
VALUES 
    ('ebd66ba7-fde7-4332-b6b5-0d8a7f615497', 'Sample Supplier', 'Suppliers', 'supplier@example.com', '123-456-7890', false, false),
    ('ebd66ba7-fde7-4332-b6b5-0d8a7f615497', 'Sample Customer', 'Customers', 'customer@example.com', '098-765-4321', false, false),
    ('ebd66ba7-fde7-4332-b6b5-0d8a7f615497', 'Sample Employee', 'Employees', 'employee@example.com', '555-555-5555', false, false);
*/