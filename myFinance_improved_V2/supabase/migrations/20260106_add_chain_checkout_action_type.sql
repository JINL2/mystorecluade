-- Add CHAIN_CHECKIN and CHAIN_CHECKOUT to the allowed action_type values for shift_request_audit_log
ALTER TABLE shift_request_audit_log
DROP CONSTRAINT shift_request_audit_log_action_type_check;

ALTER TABLE shift_request_audit_log
ADD CONSTRAINT shift_request_audit_log_action_type_check
CHECK (action_type = ANY (ARRAY[
    'REQUEST',
    'REQUEST_CANCEL',
    'CHECKIN',
    'CHAIN_CHECKIN',   -- 새로 추가
    'CHECKOUT',
    'CHAIN_CHECKOUT',  -- 새로 추가
    'MANAGER_EDIT',
    'REPORT',
    'REPORT_SOLVED',
    'PROBLEM_SOLVED',
    'APPROVAL',
    'DELETE',
    'UPDATE'
]));
