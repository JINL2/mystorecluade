-- Fix any existing data with incorrect type values
UPDATE counterparties 
SET type = 'Others' 
WHERE LOWER(type) = 'other';

UPDATE counterparties 
SET type = 'Suppliers' 
WHERE LOWER(type) = 'supplier';

UPDATE counterparties 
SET type = 'Employees' 
WHERE LOWER(type) = 'employee';

UPDATE counterparties 
SET type = 'Customers' 
WHERE LOWER(type) = 'customer';

UPDATE counterparties 
SET type = 'Team Member' 
WHERE LOWER(type) IN ('team member', 'teammember');

UPDATE counterparties 
SET type = 'My Company' 
WHERE LOWER(type) IN ('my company', 'mycompany');

-- If the check constraint is causing issues, you can drop and recreate it
-- First, drop the existing constraint (the name might be different in your database)
ALTER TABLE counterparties DROP CONSTRAINT IF EXISTS counterparties_type_check;

-- Then add it back with the correct values
ALTER TABLE counterparties 
ADD CONSTRAINT counterparties_type_check 
CHECK (type IN ('My Company', 'Team Member', 'Suppliers', 'Employees', 'Customers', 'Others'));