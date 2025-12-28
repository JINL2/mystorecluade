-- Create trade_terms_templates table for Terms & Conditions templates
-- Each company can have multiple templates to choose from when creating PI

CREATE TABLE IF NOT EXISTS trade_terms_templates (
  template_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID NOT NULL REFERENCES companies(company_id),
  template_name VARCHAR(100) NOT NULL,
  content TEXT NOT NULL,
  is_default BOOLEAN DEFAULT false,
  sort_order INT DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_by UUID REFERENCES users(user_id),
  created_at_utc TIMESTAMPTZ DEFAULT NOW(),
  updated_at_utc TIMESTAMPTZ DEFAULT NOW()
);

-- Index for faster lookups
CREATE INDEX idx_trade_terms_templates_company ON trade_terms_templates(company_id);
CREATE INDEX idx_trade_terms_templates_active ON trade_terms_templates(company_id, is_active);

-- Enable RLS
ALTER TABLE trade_terms_templates ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Users can only see templates from their company
CREATE POLICY "Users can view their company templates"
  ON trade_terms_templates FOR SELECT
  USING (company_id IN (
    SELECT uc.company_id FROM user_companies uc WHERE uc.user_id = auth.uid()
  ));

CREATE POLICY "Users can insert templates for their company"
  ON trade_terms_templates FOR INSERT
  WITH CHECK (company_id IN (
    SELECT uc.company_id FROM user_companies uc WHERE uc.user_id = auth.uid()
  ));

CREATE POLICY "Users can update their company templates"
  ON trade_terms_templates FOR UPDATE
  USING (company_id IN (
    SELECT uc.company_id FROM user_companies uc WHERE uc.user_id = auth.uid()
  ));

-- Comment
COMMENT ON TABLE trade_terms_templates IS 'Terms & Conditions templates for trade documents (PI, PO, etc.)';
