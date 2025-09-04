-- =====================================================
-- SUPABASE DATABASE INSTALLATION SCRIPT (WITHOUT RLS)
-- Finance Management System
-- Version: 1.0
-- =====================================================

-- Disable RLS globally (ensure all tables are accessible at application level)
-- Note: Security will be enforced at the application layer

-- =====================================================
-- WAVE 1: FOUNDATION TABLES (No Dependencies)
-- =====================================================

-- Company Types
CREATE TABLE IF NOT EXISTS company_types (
    company_type_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type_name TEXT NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Currency Types  
CREATE TABLE IF NOT EXISTS currency_types (
    currency_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    currency_code TEXT NOT NULL UNIQUE, -- ISO code: USD, EUR, VND
    currency_name TEXT,
    symbol TEXT, -- $, €, ₫
    flag_emoji TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Categories (for features)
CREATE TABLE IF NOT EXISTS categories (
    category_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_name TEXT NOT NULL UNIQUE,
    description TEXT,
    icon TEXT,
    color TEXT,
    sort_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Depreciation Methods
CREATE TABLE IF NOT EXISTS depreciation_methods (
    method_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    method_name TEXT NOT NULL UNIQUE,
    description TEXT,
    formula_type TEXT, -- 'straight_line', 'declining_balance', 'units_of_production'
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Inventory Categories
CREATE TABLE IF NOT EXISTS inventory_product_categories (
    category_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_name TEXT NOT NULL,
    description TEXT,
    parent_category_id UUID REFERENCES inventory_product_categories(category_id),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Inventory Brands
CREATE TABLE IF NOT EXISTS inventory_brands (
    brand_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    brand_name TEXT NOT NULL,
    description TEXT,
    logo_url TEXT,
    website TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- WAVE 2: USER AND COMPANY FOUNDATION
-- =====================================================

-- Users (extends Supabase auth.users)
CREATE TABLE IF NOT EXISTS users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name TEXT,
    last_name TEXT,
    email TEXT UNIQUE,
    password_hash TEXT, -- encrypted
    profile_image TEXT, -- URL/base64
    fcm_token TEXT, -- Firebase push token
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    is_deleted BOOLEAN DEFAULT false,
    deleted_at TIMESTAMPTZ
);

-- Companies
CREATE TABLE IF NOT EXISTS companies (
    company_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_name TEXT,
    company_code TEXT UNIQUE, -- Auto-generated
    company_type_id UUID REFERENCES company_types(company_type_id),
    owner_id UUID REFERENCES users(user_id),
    base_currency_id UUID REFERENCES currency_types(currency_id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    is_deleted BOOLEAN DEFAULT false,
    deleted_at TIMESTAMPTZ
);

-- Accounts (Chart of Accounts)
CREATE TABLE IF NOT EXISTS accounts (
    account_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    account_name TEXT NOT NULL,
    account_type TEXT NOT NULL CHECK (account_type IN ('asset','liability','equity','income','expense')),
    expense_nature TEXT CHECK (expense_nature IN ('fixed','variable')),
    category_tag TEXT,
    debt_tag TEXT,
    statement_category TEXT,
    statement_detail_category TEXT,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- WAVE 3: BUSINESS STRUCTURE
-- =====================================================

-- Stores
CREATE TABLE IF NOT EXISTS stores (
    store_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_name TEXT,
    store_code TEXT UNIQUE, -- Auto-generated
    store_address TEXT,
    store_phone TEXT,
    store_location GEOGRAPHY, -- PostGIS point for GPS
    store_qrcode TEXT,
    company_id UUID REFERENCES companies(company_id),
    huddle_time INTEGER, -- minutes
    payment_time INTEGER, -- minutes
    allowed_distance INTEGER, -- meters for check-in
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    is_deleted BOOLEAN DEFAULT false,
    deleted_at TIMESTAMPTZ
);

-- Roles
CREATE TABLE IF NOT EXISTS roles (
    role_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_name TEXT NOT NULL,
    role_type TEXT,
    company_id UUID REFERENCES companies(company_id),
    description TEXT,
    is_deletable BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    is_deleted BOOLEAN DEFAULT false,
    deleted_at TIMESTAMPTZ,
    UNIQUE(role_name, company_id)
);

-- Counterparties (customers/vendors)
CREATE TABLE IF NOT EXISTS counterparties (
    counterparty_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    type TEXT CHECK (type IN ('customer','vendor','employee','internal')),
    company_id UUID NOT NULL REFERENCES companies(company_id),
    linked_company_id UUID REFERENCES companies(company_id), -- for internal
    email TEXT,
    phone TEXT,
    address TEXT,
    notes TEXT,
    is_internal BOOLEAN NOT NULL DEFAULT false,
    is_deleted BOOLEAN NOT NULL DEFAULT false,
    created_by UUID REFERENCES users(user_id),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Features
CREATE TABLE IF NOT EXISTS features (
    feature_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    feature_name TEXT NOT NULL UNIQUE,
    category_id UUID REFERENCES categories(category_id),
    description TEXT,
    icon TEXT,
    is_premium BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- WAVE 4: RELATIONSHIPS AND PERMISSIONS
-- =====================================================

-- User-Company relationships
CREATE TABLE IF NOT EXISTS user_companies (
    user_company_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(user_id),
    company_id UUID REFERENCES companies(company_id),
    joined_at TIMESTAMPTZ DEFAULT NOW(),
    is_deleted BOOLEAN DEFAULT false,
    deleted_at TIMESTAMPTZ,
    UNIQUE(user_id, company_id)
);

-- User-Store relationships
CREATE TABLE IF NOT EXISTS user_stores (
    user_store_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(user_id),
    store_id UUID REFERENCES stores(store_id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    is_deleted BOOLEAN DEFAULT false,
    deleted_at TIMESTAMPTZ,
    UNIQUE(user_id, store_id)
);

-- User-Role relationships
CREATE TABLE IF NOT EXISTS user_roles (
    user_role_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(user_id),
    role_id UUID REFERENCES roles(role_id),
    assigned_at TIMESTAMPTZ DEFAULT NOW(),
    is_deleted BOOLEAN DEFAULT false,
    deleted_at TIMESTAMPTZ,
    UNIQUE(user_id, role_id)
);

-- Role Permissions
CREATE TABLE IF NOT EXISTS role_permissions (
    permission_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_id UUID REFERENCES roles(role_id),
    feature_id UUID REFERENCES features(feature_id),
    can_access BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(role_id, feature_id)
);

-- Cash Locations
CREATE TABLE IF NOT EXISTS cash_locations (
    cash_location_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    location_name TEXT NOT NULL,
    location_type TEXT NOT NULL CHECK (location_type IN ('vault','bank','cashier')),
    company_id UUID NOT NULL REFERENCES companies(company_id),
    store_id UUID REFERENCES stores(store_id),
    currency_id UUID REFERENCES currency_types(currency_id),
    currency_code TEXT, -- legacy
    bank_name TEXT,
    bank_account TEXT,
    location_info TEXT,
    icon TEXT,
    main_cash_location BOOLEAN DEFAULT false,
    note TEXT,
    is_deleted BOOLEAN DEFAULT false,
    deleted_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Company Currency relationships
CREATE TABLE IF NOT EXISTS company_currency (
    company_currency_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID REFERENCES companies(company_id),
    currency_id UUID REFERENCES currency_types(currency_id),
    is_primary BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(company_id, currency_id)
);

-- =====================================================
-- WAVE 5: OPERATIONAL TABLES
-- =====================================================

-- Fiscal Years
CREATE TABLE IF NOT EXISTS fiscal_years (
    fiscal_year_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES companies(company_id),
    year_name TEXT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_current BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(company_id, year_name)
);

-- Fiscal Periods
CREATE TABLE IF NOT EXISTS fiscal_periods (
    period_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    fiscal_year_id UUID NOT NULL REFERENCES fiscal_years(fiscal_year_id),
    period_name TEXT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_closed BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Journal Entries
CREATE TABLE IF NOT EXISTS journal_entries (
    journal_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    journal_number TEXT NOT NULL UNIQUE,
    journal_date DATE NOT NULL,
    journal_type TEXT DEFAULT 'manual',
    company_id UUID NOT NULL REFERENCES companies(company_id),
    store_id UUID REFERENCES stores(store_id),
    counterparty_id UUID REFERENCES counterparties(counterparty_id),
    currency_id UUID REFERENCES currency_types(currency_id),
    exchange_rate NUMERIC DEFAULT 1,
    period_id UUID REFERENCES fiscal_periods(period_id),
    description TEXT,
    reference_number TEXT,
    notes TEXT,
    tags JSONB,
    status TEXT DEFAULT 'draft' CHECK (status IN ('draft','posted','cancelled')),
    created_by UUID NOT NULL REFERENCES users(user_id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    approved_by UUID REFERENCES users(user_id),
    approved_at TIMESTAMPTZ
);

-- Journal Lines
CREATE TABLE IF NOT EXISTS journal_lines (
    line_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    journal_id UUID NOT NULL REFERENCES journal_entries(journal_id),
    account_id UUID NOT NULL REFERENCES accounts(account_id),
    debit NUMERIC DEFAULT 0,
    credit NUMERIC DEFAULT 0,
    amount_base NUMERIC, -- base currency amount
    description TEXT,
    store_id UUID REFERENCES stores(store_id),
    counterparty_id UUID REFERENCES counterparties(counterparty_id),
    tax_amount NUMERIC,
    tax_rate NUMERIC,
    line_order INTEGER,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    -- Constraint: either debit or credit must be > 0, not both
    CONSTRAINT check_debit_credit CHECK ((debit > 0 AND credit = 0) OR (credit > 0 AND debit = 0))
);

-- =====================================================
-- NOTIFICATION SYSTEM TABLES
-- =====================================================

-- Notifications
CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id), -- Reference to Supabase auth
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    category VARCHAR(50),
    data JSONB,
    image_url TEXT,
    action_url TEXT,
    is_read BOOLEAN DEFAULT false,
    scheduled_time TIMESTAMPTZ,
    sent_at TIMESTAMPTZ,
    read_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- User Notification Settings
CREATE TABLE IF NOT EXISTS user_notification_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID UNIQUE REFERENCES auth.users(id),
    push_enabled BOOLEAN DEFAULT true,
    email_enabled BOOLEAN DEFAULT true,
    transaction_alerts BOOLEAN DEFAULT true,
    reminders BOOLEAN DEFAULT true,
    marketing_messages BOOLEAN DEFAULT true,
    sound_preference VARCHAR(50) DEFAULT 'default',
    vibration_enabled BOOLEAN DEFAULT true,
    category_preferences JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- FCM Tokens
CREATE TABLE IF NOT EXISTS user_fcm_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id),
    token TEXT NOT NULL UNIQUE,
    platform VARCHAR(20) NOT NULL CHECK (platform IN ('ios','android','web')),
    device_id VARCHAR(255),
    device_model VARCHAR(255),
    app_version VARCHAR(50),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    last_used_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================

-- User and company indexes
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email) WHERE is_deleted = false;
CREATE INDEX IF NOT EXISTS idx_companies_owner ON companies(owner_id) WHERE is_deleted = false;
CREATE INDEX IF NOT EXISTS idx_companies_code ON companies(company_code) WHERE is_deleted = false;
CREATE INDEX IF NOT EXISTS idx_stores_company ON stores(company_id) WHERE is_deleted = false;

-- Journal entry indexes
CREATE INDEX IF NOT EXISTS idx_journal_entries_date ON journal_entries(journal_date, company_id);
CREATE INDEX IF NOT EXISTS idx_journal_entries_company ON journal_entries(company_id, status);
CREATE INDEX IF NOT EXISTS idx_journal_lines_account ON journal_lines(account_id, journal_id);
CREATE INDEX IF NOT EXISTS idx_journal_lines_journal ON journal_lines(journal_id);

-- Relationship indexes
CREATE INDEX IF NOT EXISTS idx_user_companies_user ON user_companies(user_id) WHERE is_deleted = false;
CREATE INDEX IF NOT EXISTS idx_user_companies_company ON user_companies(company_id) WHERE is_deleted = false;
CREATE INDEX IF NOT EXISTS idx_user_stores_user ON user_stores(user_id) WHERE is_deleted = false;
CREATE INDEX IF NOT EXISTS idx_user_roles_user ON user_roles(user_id) WHERE is_deleted = false;

-- Notification indexes
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON notifications(is_read);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_fcm_tokens_user_active ON user_fcm_tokens(user_id, is_active);

-- =====================================================
-- TRIGGERS FOR AUTO-GENERATION
-- =====================================================

-- Company code generation trigger
CREATE OR REPLACE FUNCTION generate_company_code()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.company_code IS NULL THEN
        NEW.company_code := 'COM' || LPAD(FLOOR(RANDOM() * 900000 + 100000)::TEXT, 6, '0');
        
        -- Ensure uniqueness
        WHILE EXISTS (SELECT 1 FROM companies WHERE company_code = NEW.company_code) LOOP
            NEW.company_code := 'COM' || LPAD(FLOOR(RANDOM() * 900000 + 100000)::TEXT, 6, '0');
        END LOOP;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_generate_company_code
    BEFORE INSERT ON companies
    FOR EACH ROW
    EXECUTE FUNCTION generate_company_code();

-- Store code generation trigger
CREATE OR REPLACE FUNCTION generate_store_code()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.store_code IS NULL THEN
        NEW.store_code := 'STO' || LPAD(FLOOR(RANDOM() * 900000 + 100000)::TEXT, 6, '0');
        
        -- Ensure uniqueness
        WHILE EXISTS (SELECT 1 FROM stores WHERE store_code = NEW.store_code) LOOP
            NEW.store_code := 'STO' || LPAD(FLOOR(RANDOM() * 900000 + 100000)::TEXT, 6, '0');
        END LOOP;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_generate_store_code
    BEFORE INSERT ON stores
    FOR EACH ROW
    EXECUTE FUNCTION generate_store_code();

-- Auto-create user_stores relationship when store is created
CREATE OR REPLACE FUNCTION auto_create_user_store()
RETURNS TRIGGER AS $$
DECLARE
    store_owner_id UUID;
BEGIN
    -- Get the company owner
    SELECT owner_id INTO store_owner_id
    FROM companies 
    WHERE company_id = NEW.company_id;
    
    -- Create user_stores entry for the company owner
    IF store_owner_id IS NOT NULL THEN
        INSERT INTO user_stores (user_id, store_id)
        VALUES (store_owner_id, NEW.store_id)
        ON CONFLICT (user_id, store_id) DO NOTHING;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_auto_create_user_store
    AFTER INSERT ON stores
    FOR EACH ROW
    EXECUTE FUNCTION auto_create_user_store();

-- =====================================================
-- INITIAL DATA SEEDING
-- =====================================================

-- Insert default company types
INSERT INTO company_types (type_name, description) VALUES
    ('Sole Proprietorship', 'Single owner business'),
    ('Partnership', 'Multiple owners business'),
    ('Corporation', 'Incorporated business'),
    ('LLC', 'Limited Liability Company'),
    ('Non-Profit', 'Non-profit organization')
ON CONFLICT (type_name) DO NOTHING;

-- Insert common currencies
INSERT INTO currency_types (currency_code, currency_name, symbol, flag_emoji) VALUES
    ('USD', 'US Dollar', '$', '🇺🇸'),
    ('EUR', 'Euro', '€', '🇪🇺'),
    ('GBP', 'British Pound', '£', '🇬🇧'),
    ('JPY', 'Japanese Yen', '¥', '🇯🇵'),
    ('VND', 'Vietnamese Dong', '₫', '🇻🇳'),
    ('CAD', 'Canadian Dollar', 'C$', '🇨🇦'),
    ('AUD', 'Australian Dollar', 'A$', '🇦🇺'),
    ('CHF', 'Swiss Franc', 'CHF', '🇨🇭'),
    ('CNY', 'Chinese Yuan', '¥', '🇨🇳'),
    ('INR', 'Indian Rupee', '₹', '🇮🇳')
ON CONFLICT (currency_code) DO NOTHING;

-- Insert default categories for features
INSERT INTO categories (category_name, description, icon, color, sort_order) VALUES
    ('Financial', 'Financial management features', 'attach_money', '#4CAF50', 1),
    ('Inventory', 'Inventory management features', 'inventory', '#FF9800', 2),
    ('HR', 'Human resources features', 'group', '#2196F3', 3),
    ('Reports', 'Reporting and analytics', 'assessment', '#9C27B0', 4),
    ('Settings', 'System settings', 'settings', '#607D8B', 5)
ON CONFLICT (category_name) DO NOTHING;

-- Insert basic features
INSERT INTO features (feature_name, category_id, description, icon) VALUES
    ('company_management', (SELECT category_id FROM categories WHERE category_name = 'Settings'), 'Manage company settings', 'business'),
    ('store_management', (SELECT category_id FROM categories WHERE category_name = 'Settings'), 'Manage store locations', 'store'),
    ('user_management', (SELECT category_id FROM categories WHERE category_name = 'HR'), 'Manage users and roles', 'people'),
    ('journal_entries', (SELECT category_id FROM categories WHERE category_name = 'Financial'), 'Create and manage journal entries', 'receipt_long'),
    ('cash_management', (SELECT category_id FROM categories WHERE category_name = 'Financial'), 'Manage cash locations and reconciliation', 'account_balance_wallet'),
    ('inventory_management', (SELECT category_id FROM categories WHERE category_name = 'Inventory'), 'Manage product inventory', 'inventory_2'),
    ('financial_reports', (SELECT category_id FROM categories WHERE category_name = 'Reports'), 'View financial reports', 'bar_chart'),
    ('notifications', (SELECT category_id FROM categories WHERE category_name = 'Settings'), 'Manage notifications', 'notifications')
ON CONFLICT (feature_name) DO NOTHING;

-- Insert basic chart of accounts
INSERT INTO accounts (account_name, account_type, category_tag, description) VALUES
    ('Cash', 'asset', 'cash', 'Cash on hand and in bank'),
    ('Accounts Receivable', 'asset', 'receivable', 'Money owed by customers'),
    ('Inventory', 'asset', 'inventory', 'Products for sale'),
    ('Equipment', 'asset', 'fixed_asset', 'Business equipment'),
    ('Accounts Payable', 'liability', 'payable', 'Money owed to suppliers'),
    ('Owners Equity', 'equity', 'equity', 'Owner investment'),
    ('Sales Revenue', 'income', 'revenue', 'Income from sales'),
    ('Cost of Goods Sold', 'expense', 'cogs', 'Direct costs of products sold'),
    ('Operating Expenses', 'expense', 'expense', 'General business expenses')
ON CONFLICT (account_name) DO NOTHING;

-- =====================================================
-- COMPLETION MESSAGE
-- =====================================================

DO $$ 
BEGIN 
    RAISE NOTICE '=========================================';
    RAISE NOTICE 'DATABASE INSTALLATION COMPLETED SUCCESSFULLY';
    RAISE NOTICE '=========================================';
    RAISE NOTICE 'Tables created: %', (
        SELECT COUNT(*) 
        FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_type = 'BASE TABLE'
    );
    RAISE NOTICE 'Installation completed at: %', NOW();
    RAISE NOTICE 'Security: Application-level (RLS disabled)';
    RAISE NOTICE 'Ready for application connection';
END $$;