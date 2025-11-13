/**
 * useAccountMapping Hook
 * Manages account mapping validation for internal counterparties
 */

import { useState, useEffect } from 'react';
import type { Account, Counterparty } from '../../../../domain/repositories/IJournalInputRepository';

export type AccountMappingStatus = 'none' | 'checking' | 'valid' | 'invalid';

export interface UseAccountMappingProps {
  selectedAccountId: string;
  selectedAccount: Account | null;
  selectedCounterparty: string;
  selectedCounterpartyData: Counterparty | null;
  companyId: string;
  onCheckAccountMapping?: (companyId: string, counterpartyId: string, accountId: string) => Promise<boolean>;
}

export const useAccountMapping = ({
  selectedAccountId,
  selectedAccount,
  selectedCounterparty,
  selectedCounterpartyData,
  companyId,
  onCheckAccountMapping,
}: UseAccountMappingProps) => {
  const [accountMappingStatus, setAccountMappingStatus] = useState<AccountMappingStatus>('none');
  const [showMappingWarning, setShowMappingWarning] = useState(false);

  // Account mapping validation function
  const checkAccountMapping = async () => {
    // Reset validation state if conditions are not met
    if (!selectedAccountId || !selectedCounterparty || !selectedCounterpartyData || !onCheckAccountMapping) {
      setAccountMappingStatus('none');
      return;
    }

    // Only check mapping for internal counterparties with payable/receivable accounts
    if (!selectedCounterpartyData.isInternal) {
      setAccountMappingStatus('none');
      return;
    }

    const categoryTag = selectedAccount?.categoryTag?.toLowerCase();
    if (categoryTag !== 'payable' && categoryTag !== 'receivable') {
      setAccountMappingStatus('none');
      return;
    }

    // Check account mapping
    setAccountMappingStatus('checking');

    try {
      const hasMapping = await onCheckAccountMapping(companyId, selectedCounterparty, selectedAccountId);

      if (!hasMapping) {
        setAccountMappingStatus('invalid');
        setShowMappingWarning(true);
      } else {
        setAccountMappingStatus('valid');
      }
    } catch (error) {
      console.error('Error checking account mapping:', error);
      setAccountMappingStatus('invalid');
      setShowMappingWarning(true);
    }
  };

  // Run validation when account or counterparty changes
  useEffect(() => {
    checkAccountMapping();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [
    selectedAccountId,
    selectedCounterparty,
    selectedAccount?.categoryTag,
    selectedCounterpartyData?.isInternal,
    companyId,
    onCheckAccountMapping,
  ]);

  // Handle mapping warning dialog close (reset counterparty selection)
  const handleMappingWarningClose = () => {
    setShowMappingWarning(false);
  };

  return {
    accountMappingStatus,
    showMappingWarning,
    setShowMappingWarning,
    handleMappingWarningClose,
  };
};
