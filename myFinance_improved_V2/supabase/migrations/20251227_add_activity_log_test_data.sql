-- 테스트용 activity log 데이터 추가
-- Recent Activity 표시를 위한 샘플 데이터

INSERT INTO trade_activity_logs (
    company_id, entity_type, entity_id, entity_number,
    action, action_detail, previous_status, new_status, created_at_utc
) VALUES
-- PI 생성/수정 로그
('b5e3f93b-34ee-4269-b3d1-6e52e76dec71', 'PI', 'a0000001-0000-0000-0000-000000000001', 'PI-2024-001',
 'STATUS_CHANGE', 'PI accepted by buyer', 'sent', 'accepted', NOW() - INTERVAL '2 days'),
('b5e3f93b-34ee-4269-b3d1-6e52e76dec71', 'PI', 'a0000001-0000-0000-0000-000000000002', 'PI-2024-002',
 'STATUS_CHANGE', 'PI accepted by buyer', 'sent', 'accepted', NOW() - INTERVAL '3 days'),
('b5e3f93b-34ee-4269-b3d1-6e52e76dec71', 'PI', 'a0000001-0000-0000-0000-000000000005', 'PI-2024-005',
 'CREATE', 'New Proforma Invoice created', NULL, 'draft', NOW() - INTERVAL '1 day'),
-- PO 로그
('b5e3f93b-34ee-4269-b3d1-6e52e76dec71', 'PO', 'b0000001-0000-0000-0000-000000000001', 'PO-2024-001',
 'CREATE', 'Purchase Order created from PI-2024-001', NULL, 'draft', NOW() - INTERVAL '1 day'),
('b5e3f93b-34ee-4269-b3d1-6e52e76dec71', 'PO', 'b0000001-0000-0000-0000-000000000001', 'PO-2024-001',
 'STATUS_CHANGE', 'PO confirmed', 'draft', 'confirmed', NOW() - INTERVAL '12 hours'),
-- LC 로그
('b5e3f93b-34ee-4269-b3d1-6e52e76dec71', 'LC', 'c0000001-0000-0000-0000-000000000001', 'LC-2024-001',
 'CREATE', 'Letter of Credit opened', NULL, 'draft', NOW() - INTERVAL '6 hours'),
('b5e3f93b-34ee-4269-b3d1-6e52e76dec71', 'LC', 'c0000001-0000-0000-0000-000000000001', 'LC-2024-001',
 'STATUS_CHANGE', 'LC confirmed by advising bank', 'draft', 'confirmed', NOW() - INTERVAL '2 hours'),
-- Shipment 로그
('b5e3f93b-34ee-4269-b3d1-6e52e76dec71', 'SHIPMENT', 'd0000001-0000-0000-0000-000000000001', 'SHP-2024-001',
 'STATUS_CHANGE', 'Shipment departed from port', 'booked', 'in_transit', NOW() - INTERVAL '30 minutes');
