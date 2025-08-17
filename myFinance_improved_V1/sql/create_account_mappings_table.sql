-- =====================================================
-- CREATE ACCOUNT MAPPINGS TABLE
-- For managing account mappings between internal companies
-- =====================================================

-- Create account_mappings table if it doesn't exist
CREATE TABLE IF NOT EXISTS account_mappings (
    mapping_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    my_company_id UUID NOT NULL REFERENCES companies(company_id),
    my_account_id UUID NOT NULL REFERENCES accounts(account_id),
    counterparty_id UUID NOT NULL REFERENCES counterparties(counterparty_id),
    linked_company_id UUID NOT NULL REFERENCES companies(company_id),
    linked_account_id UUID NOT NULL REFERENCES accounts(account_id),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_account_mappings_counterparty ON account_mappings(counterparty_id);
CREATE INDEX IF NOT EXISTS idx_account_mappings_my_company ON account_mappings(my_company_id);
CREATE INDEX IF NOT EXISTS idx_account_mappings_linked_company ON account_mappings(linked_company_id);
CREATE INDEX IF NOT EXISTS idx_account_mappings_active ON account_mappings(is_active) WHERE is_active = true;

-- Add unique constraint to prevent duplicate mappings
CREATE UNIQUE INDEX IF NOT EXISTS idx_account_mappings_unique 
ON account_mappings(my_company_id, my_account_id, counterparty_id, linked_company_id, linked_account_id) 
WHERE is_active = true;

-- Enable Row Level Security
ALTER TABLE account_mappings ENABLE ROW LEVEL SECURITY;

-- Create policy for account mappings access
-- Users can only access mappings for companies they belong to
CREATE POLICY account_mappings_policy ON account_mappings
FOR ALL
TO authenticated
USING (
    my_company_id IN (
        SELECT uc.company_id 
        FROM user_companies uc 
        WHERE uc.user_id = auth.uid() 
        AND uc.is_deleted = false
    )
    OR
    linked_company_id IN (
        SELECT uc.company_id 
        FROM user_companies uc 
        WHERE uc.user_id = auth.uid() 
        AND uc.is_deleted = false
    )
);

-- Grant permissions
GRANT ALL ON account_mappings TO authenticated;

-- Add comments for documentation
COMMENT ON TABLE account_mappings IS 'Account mappings for internal company transactions';
COMMENT ON COLUMN account_mappings.mapping_id IS 'Unique identifier for the mapping';
COMMENT ON COLUMN account_mappings.my_company_id IS 'The company creating the mapping';
COMMENT ON COLUMN account_mappings.my_account_id IS 'The account in my company';
COMMENT ON COLUMN account_mappings.counterparty_id IS 'The counterparty (internal company)';
COMMENT ON COLUMN account_mappings.linked_company_id IS 'The linked internal company';
COMMENT ON COLUMN account_mappings.linked_account_id IS 'The corresponding account in the linked company';
COMMENT ON COLUMN account_mappings.is_active IS 'Whether this mapping is active';