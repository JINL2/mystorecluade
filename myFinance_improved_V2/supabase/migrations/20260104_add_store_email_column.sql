-- Add store_email column to stores table for trade documents (PI/PO)
ALTER TABLE stores
ADD COLUMN IF NOT EXISTS store_email VARCHAR(255);

-- Add comment for documentation
COMMENT ON COLUMN stores.store_email IS 'Store email address used in trade documents (PI/PO) as seller contact info';
