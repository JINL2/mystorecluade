-- Role Tags Data Cleanup Script
-- This script fixes malformed tag data and initializes NULL values

-- Step 1: Fix malformed tags data (convert from wrong format to correct array format)
-- Current wrong format: {"tag1": "[Critical, Support, Management, Operations, Temporary]"}
-- Correct format: ["Critical", "Support", "Management", "Operations", "Temporary"]

UPDATE roles 
SET tags = '["Critical", "Support", "Management", "Operations", "Temporary"]'::jsonb
WHERE role_id = 'd4e9ed36-68e3-48a8-a481-2103888252cc'
  AND tags IS NOT NULL 
  AND tags::text LIKE '%tag1%';

-- Step 2: Initialize NULL tags to empty arrays
UPDATE roles 
SET tags = '[]'::jsonb 
WHERE tags IS NULL;

-- Step 3: Fix any other malformed tags that might exist
-- Convert Map-style tags to Array-style tags
UPDATE roles 
SET tags = '[]'::jsonb 
WHERE tags IS NOT NULL 
  AND jsonb_typeof(tags) = 'object' 
  AND tags ? 'tag1';

-- Step 4: Validate data after cleanup
-- This query should return the cleaned data
SELECT role_id, role_name, tags, 
       jsonb_typeof(tags) as tags_type,
       jsonb_array_length(tags) as tags_count
FROM roles 
WHERE company_id IS NOT NULL
ORDER BY role_name;