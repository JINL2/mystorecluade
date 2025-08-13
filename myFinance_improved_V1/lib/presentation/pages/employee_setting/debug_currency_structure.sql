-- Debug Currency Structure
-- Run this in your Supabase SQL editor to check your table structure

-- Check the currency_types table structure
SELECT 'Currency Types Table Structure:' as info;
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'currency_types' 
ORDER BY ordinal_position;

-- Check actual currency data
SELECT 'Actual Currency Data:' as info;
SELECT * FROM currency_types ORDER BY currency_name;

-- Check user_salaries table structure
SELECT 'User Salaries Table Structure:' as info;
SELECT column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'user_salaries' 
ORDER BY ordinal_position;

-- Check what currency_ids are in user_salaries
SELECT 'Currency IDs in User Salaries:' as info;
SELECT DISTINCT currency_id, 
       (SELECT currency_name FROM currency_types ct WHERE ct.id = us.currency_id) as currency_name
FROM user_salaries us
WHERE currency_id IS NOT NULL;