-- Update test activity logs with store_id
UPDATE trade_activity_logs
SET store_id = '55c8f23e-53e8-4fc7-ab93-bc51d13d553a'
WHERE company_id = 'b5e3f93b-34ee-4269-b3d1-6e52e76dec71'
  AND store_id IS NULL;
