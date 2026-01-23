/**
 * AddAccountMappingModal Component
 * Modal for creating new account mappings with searchable dropdowns
 */

import React, { useState, useEffect, useMemo } from 'react';
import { useAppState } from '@/app/providers/app_state_provider';
import { TossSelector } from '@/shared/components/selectors/TossSelector/TossSelector';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import type { TossSelectorOption } from '@/shared/components/selectors/TossSelector/TossSelector.types';
import type { AccountOption, CompanyOption } from '../../../domain/repositories/IAccountMappingRepository';
import styles from './AddAccountMappingModal.module.css';

interface AddAccountMappingModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSubmit: (
    counterpartyCompanyId: string,
    myAccountId: string,
    linkedAccountId: string,
    direction: string,
    createdBy: string
  ) => Promise<{ success: boolean; error?: string }>;
  getCompanyAccounts: (companyId: string) => Promise<{ success: boolean; data?: AccountOption[]; error?: string }>;
  availableCompanies: CompanyOption[];
  availableAccounts: AccountOption[];
}

export const AddAccountMappingModal: React.FC<AddAccountMappingModalProps> = ({
  isOpen,
  onClose,
  onSubmit,
  getCompanyAccounts,
  availableCompanies,
  availableAccounts,
}) => {
  const { currentCompany, currentUser } = useAppState();

  const [selectedMyAccountId, setSelectedMyAccountId] = useState('');
  const [selectedCompanyId, setSelectedCompanyId] = useState('');
  const [selectedCounterAccountId, setSelectedCounterAccountId] = useState('');

  const [counterAccounts, setCounterAccounts] = useState<AccountOption[]>([]);
  const [loadingCounterAccounts, setLoadingCounterAccounts] = useState(false);

  const [isSubmitting, setIsSubmitting] = useState(false);

  // Error message state
  const [showErrorMessage, setShowErrorMessage] = useState(false);
  const [errorMessageText, setErrorMessageText] = useState('');

  // Reset form when modal opens/closes
  useEffect(() => {
    if (!isOpen) {
      setSelectedMyAccountId('');
      setSelectedCompanyId('');
      setSelectedCounterAccountId('');
      setCounterAccounts([]);
      setShowErrorMessage(false);
      setErrorMessageText('');
    }
  }, [isOpen]);

  // Helper functions for category colors
  const getCategoryBadgeColor = (tag: string): string => {
    switch (tag?.toLowerCase()) {
      case 'payable': return 'rgba(239, 68, 68, 0.15)';
      case 'receivable': return 'rgba(59, 130, 246, 0.15)';
      case 'contra_asset': return 'rgba(107, 114, 128, 0.15)';
      case 'cash': return 'rgba(34, 197, 94, 0.15)';
      case 'general': return 'rgba(107, 114, 128, 0.15)';
      case 'fixed_asset': return 'rgba(168, 85, 247, 0.15)';
      case 'equity': return 'rgba(14, 165, 233, 0.15)';
      default: return 'rgba(107, 114, 128, 0.15)';
    }
  };

  const getCategoryTextColor = (tag: string): string => {
    switch (tag?.toLowerCase()) {
      case 'payable': return 'rgb(239, 68, 68)';
      case 'receivable': return 'rgb(59, 130, 246)';
      case 'contra_asset': return 'rgb(107, 114, 128)';
      case 'cash': return 'rgb(34, 197, 94)';
      case 'general': return 'rgb(107, 114, 128)';
      case 'fixed_asset': return 'rgb(168, 85, 247)';
      case 'equity': return 'rgb(14, 165, 233)';
      default: return 'rgb(107, 114, 128)';
    }
  };

  const getCategoryTagLabel = (tag: string): string => {
    if (!tag) return 'General';
    return tag.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase());
  };

  // Helper function to get account initials
  const getAccountInitials = (name: string): string => {
    if (!name) return '??';
    const words = name.trim().split(' ');
    if (words.length === 1) {
      return name.substring(0, 2).toUpperCase();
    }
    return words.slice(0, 2).map(w => w[0]).join('').toUpperCase();
  };

  // Transform data to TossSelector format
  const myAccountOptions = useMemo((): TossSelectorOption[] => {
    return availableAccounts.map(account => ({
      value: account.account_id,
      label: account.account_name,
      badge: getAccountInitials(account.account_name),
      description: account.category_tag && account.category_tag.toLowerCase() !== 'general'
        ? getCategoryTagLabel(account.category_tag)
        : undefined,
      descriptionBgColor: account.category_tag ? getCategoryBadgeColor(account.category_tag) : undefined,
      descriptionColor: account.category_tag ? getCategoryTextColor(account.category_tag) : undefined,
    }));
  }, [availableAccounts]);

  const companyOptions = useMemo((): TossSelectorOption[] => {
    return availableCompanies.map(company => ({
      value: company.company_id,
      label: company.company_name,
      badge: getAccountInitials(company.company_name),
    }));
  }, [availableCompanies]);

  const counterAccountOptions = useMemo((): TossSelectorOption[] => {
    return counterAccounts.map(account => ({
      value: account.account_id,
      label: account.account_name,
      badge: getAccountInitials(account.account_name),
      description: account.category_tag && account.category_tag.toLowerCase() !== 'general'
        ? getCategoryTagLabel(account.category_tag)
        : undefined,
      descriptionBgColor: account.category_tag ? getCategoryBadgeColor(account.category_tag) : undefined,
      descriptionColor: account.category_tag ? getCategoryTextColor(account.category_tag) : undefined,
    }));
  }, [counterAccounts]);

  // Load counter company accounts when company is selected
  const handleCompanyChange = async (value: string) => {
    setSelectedCompanyId(value);
    setSelectedCounterAccountId('');

    setLoadingCounterAccounts(true);
    try {
      const result = await getCompanyAccounts(value);
      if (result.success && result.data) {
        setCounterAccounts(result.data);
      } else {
        setCounterAccounts([]);
      }
    } catch (error) {
      console.error('Error loading counter accounts:', error);
      setCounterAccounts([]);
    } finally {
      setLoadingCounterAccounts(false);
    }
  };

  const handleSubmit = async () => {
    if (!selectedMyAccountId || !selectedCompanyId || !selectedCounterAccountId) {
      return;
    }

    if (!currentCompany || !currentUser) {
      setErrorMessageText('Missing company or user data');
      setShowErrorMessage(true);
      return;
    }

    setIsSubmitting(true);
    try {
      const selectedAccount = availableAccounts.find(a => a.account_id === selectedMyAccountId);
      const direction = selectedAccount?.category_tag || 'both';

      const result = await onSubmit(
        selectedCompanyId,
        selectedMyAccountId,
        selectedCounterAccountId,
        direction,
        currentUser.user_id
      );

      if (result.success) {
        onClose();
      } else {
        setErrorMessageText(result.error || 'Failed to create mapping');
        setShowErrorMessage(true);
      }
    } catch (error) {
      console.error('Error creating mapping:', error);
      setErrorMessageText('Failed to create mapping');
      setShowErrorMessage(true);
    } finally {
      setIsSubmitting(false);
    }
  };

  const isFormValid = selectedMyAccountId && selectedCompanyId && selectedCounterAccountId;

  if (!isOpen) return null;

  return (
    <div className={styles.modalOverlay} onClick={onClose}>
      <div className={styles.modal} onClick={(e) => e.stopPropagation()}>
        <div className={styles.modalHeader}>
          <h2>Add Account Mapping</h2>
          <button onClick={onClose} className={styles.closeButton}>
            <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
              <path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z" />
            </svg>
          </button>
        </div>

        <div className={styles.modalBody}>
          {/* My Company (Display Only) */}
          <div className={styles.formGroup}>
            <label className={styles.formLabel}>My Company</label>
            <div className={styles.companyDisplay}>{currentCompany?.company_name}</div>
          </div>

          {/* My Account Selection */}
          <div className={styles.formGroup}>
            <TossSelector
              label="My Account"
              placeholder="Select Account"
              value={selectedMyAccountId}
              options={myAccountOptions}
              onChange={(value) => setSelectedMyAccountId(value)}
              searchable={true}
              showBadges={false}
              showDescriptions={true}
              required={true}
              fullWidth={true}
            />
          </div>

          {/* Company Selection */}
          <div className={styles.formGroup}>
            <TossSelector
              label="Company"
              placeholder="Select Company"
              value={selectedCompanyId}
              options={companyOptions}
              onChange={handleCompanyChange}
              searchable={true}
              showBadges={false}
              required={true}
              fullWidth={true}
            />
          </div>

          {/* Counter Account Selection */}
          <div className={styles.formGroup}>
            <TossSelector
              label="Account"
              placeholder={!selectedCompanyId ? "Select Company First" : "Select Account"}
              value={selectedCounterAccountId}
              options={counterAccountOptions}
              onChange={(value) => setSelectedCounterAccountId(value)}
              searchable={true}
              showBadges={false}
              showDescriptions={true}
              required={true}
              fullWidth={true}
              disabled={!selectedCompanyId || loadingCounterAccounts}
              loading={loadingCounterAccounts}
            />
          </div>
        </div>

        <div className={styles.modalFooter}>
          <button onClick={onClose} className={styles.cancelButton}>
            Cancel
          </button>
          <button
            onClick={handleSubmit}
            className={styles.saveButton}
            disabled={!isFormValid || isSubmitting}
          >
            {isSubmitting ? 'Creating...' : 'Create Mapping'}
          </button>
        </div>

        {/* Error Message */}
        <ErrorMessage
          variant="error"
          isOpen={showErrorMessage}
          onClose={() => setShowErrorMessage(false)}
          message={errorMessageText}
          zIndex={10001}
        />
      </div>
    </div>
  );
};
