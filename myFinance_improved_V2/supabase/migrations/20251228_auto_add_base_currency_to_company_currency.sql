-- Trigger to automatically add base_currency to company_currency when company is created
-- This fixes the issue where base_currency_id is set but company_currency is empty
--
-- ROOT CAUSE: When a company is created with base_currency_id, it was not automatically
-- added to company_currency table, causing Currency dropdown to show empty.

-- 1. Create trigger function for INSERT
CREATE OR REPLACE FUNCTION auto_add_base_currency_to_company_currency()
RETURNS TRIGGER AS $$
BEGIN
  -- Only proceed if base_currency_id is set
  IF NEW.base_currency_id IS NOT NULL THEN
    -- Insert into company_currency if not exists
    INSERT INTO company_currency (company_currency_id, company_id, currency_id, is_deleted, created_at)
    VALUES (gen_random_uuid(), NEW.company_id, NEW.base_currency_id, false, now())
    ON CONFLICT DO NOTHING;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. Create trigger on companies table for INSERT
DROP TRIGGER IF EXISTS trg_auto_add_base_currency ON companies;
CREATE TRIGGER trg_auto_add_base_currency
  AFTER INSERT ON companies
  FOR EACH ROW
  EXECUTE FUNCTION auto_add_base_currency_to_company_currency();

-- 3. Create trigger function for UPDATE (when base_currency_id changes)
CREATE OR REPLACE FUNCTION auto_add_base_currency_on_update()
RETURNS TRIGGER AS $$
BEGIN
  -- Only proceed if base_currency_id changed and is not null
  IF NEW.base_currency_id IS NOT NULL AND
     (OLD.base_currency_id IS NULL OR OLD.base_currency_id != NEW.base_currency_id) THEN
    -- Insert into company_currency if not exists
    INSERT INTO company_currency (company_currency_id, company_id, currency_id, is_deleted, created_at)
    VALUES (gen_random_uuid(), NEW.company_id, NEW.base_currency_id, false, now())
    ON CONFLICT DO NOTHING;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_auto_add_base_currency_on_update ON companies;
CREATE TRIGGER trg_auto_add_base_currency_on_update
  AFTER UPDATE OF base_currency_id ON companies
  FOR EACH ROW
  EXECUTE FUNCTION auto_add_base_currency_on_update();

-- 4. Fix existing companies that have base_currency_id but no company_currency entry
INSERT INTO company_currency (company_currency_id, company_id, currency_id, is_deleted, created_at)
SELECT gen_random_uuid(), c.company_id, c.base_currency_id, false, now()
FROM companies c
WHERE c.base_currency_id IS NOT NULL
  AND c.is_deleted = false
  AND NOT EXISTS (
    SELECT 1 FROM company_currency cc
    WHERE cc.company_id = c.company_id
      AND cc.currency_id = c.base_currency_id
      AND cc.is_deleted = false
  );

-- 5. Add comments
COMMENT ON FUNCTION auto_add_base_currency_to_company_currency() IS
'Automatically adds base_currency to company_currency table when a company is created';

COMMENT ON FUNCTION auto_add_base_currency_on_update() IS
'Automatically adds new base_currency to company_currency table when base_currency_id is updated';
