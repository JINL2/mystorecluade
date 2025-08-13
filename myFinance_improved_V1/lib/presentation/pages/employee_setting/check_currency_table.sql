-- Check the actual structure of your currency_types table
-- Run this in Supabase SQL Editor

-- First, check what columns exist in currency_types
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'currency_types'
ORDER BY ordinal_position;

-- Check the actual data in currency_types
SELECT * FROM currency_types LIMIT 10;

-- Check what the primary key is
SELECT kcu.column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
  ON tc.constraint_name = kcu.constraint_name
WHERE tc.table_name = 'currency_types'
  AND tc.constraint_type = 'PRIMARY KEY';

-- Check what currency matches the UUID in your user_salaries
SELECT * FROM currency_types 
WHERE currency_id = 'USD' OR currency_name LIKE '%Dollar%' OR symbol = '$';