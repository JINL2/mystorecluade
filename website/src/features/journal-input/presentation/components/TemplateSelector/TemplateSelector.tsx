/**
 * TemplateSelector Component
 * Displays transaction templates as clickable chips above the Excel table
 * Shows detail panel with account info and amount input when template is clicked
 * Includes store selector for filtering templates by store
 */

import React, { useState, useMemo, useEffect } from 'react';
import type { TransactionTemplate } from '../../../domain/repositories/IJournalInputRepository';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';
import styles from './TemplateSelector.module.css';

interface Store {
  store_id: string;
  store_name: string;
}

export interface TemplateSelectorProps {
  templates: TransactionTemplate[];
  loading: boolean;
  accounts: Array<{ accountId: string; accountName: string }>;
  stores: Store[];
  selectedStoreId: string | null;
  onStoreChange: (storeId: string | null) => void;
  onApplyTemplate: (templateData: any, amount: number) => void;
}

interface TemplateLineInfo {
  type: 'debit' | 'credit';
  accountId: string;
  accountName: string;
  description: string;
}

export const TemplateSelector: React.FC<TemplateSelectorProps> = ({
  templates,
  loading,
  accounts,
  stores,
  selectedStoreId,
  onStoreChange,
  onApplyTemplate,
}) => {
  const [selectedTemplate, setSelectedTemplate] = useState<TransactionTemplate | null>(null);
  const [amount, setAmount] = useState<string>('');

  // Reset selected template when store changes
  useEffect(() => {
    setSelectedTemplate(null);
    setAmount('');
  }, [selectedStoreId]);

  // Parse template data to extract line info
  const templateLines = useMemo((): TemplateLineInfo[] => {
    if (!selectedTemplate?.data) return [];

    let lines: any[] = [];
    if (Array.isArray(selectedTemplate.data)) {
      lines = selectedTemplate.data;
    } else if (selectedTemplate.data.lines && Array.isArray(selectedTemplate.data.lines)) {
      lines = selectedTemplate.data.lines;
    }

    return lines.map((line: any) => {
      // Determine type
      let type: 'debit' | 'credit' = 'debit';
      if (line.type === 'credit') {
        type = 'credit';
      } else if (line.credit && Number(line.credit) > 0) {
        type = 'credit';
      }

      // Get account name
      const accountId = line.account_id || '';
      const account = accounts.find((acc) => acc.accountId === accountId);
      const accountName = account?.accountName || line.account_name || 'Unknown Account';

      return {
        type,
        accountId,
        accountName,
        description: line.description || '',
      };
    });
  }, [selectedTemplate, accounts]);

  const handleTemplateClick = (template: TransactionTemplate) => {
    if (selectedTemplate?.templateId === template.templateId) {
      // Toggle off if clicking the same template
      setSelectedTemplate(null);
      setAmount('');
    } else {
      setSelectedTemplate(template);
      setAmount('');
    }
  };

  const handleApply = () => {
    if (!selectedTemplate?.data || !amount) return;

    const numAmount = parseFloat(amount.replace(/,/g, ''));
    if (isNaN(numAmount) || numAmount <= 0) return;

    onApplyTemplate(selectedTemplate.data, numAmount);
    setSelectedTemplate(null);
    setAmount('');
  };

  const handleCancel = () => {
    setSelectedTemplate(null);
    setAmount('');
  };

  const formatNumber = (value: string): string => {
    if (!value) return '';
    const cleaned = value.replace(/[^\d.]/g, '');
    const parts = cleaned.split('.');
    parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    return parts.length > 1 ? parts[0] + '.' + parts[1] : parts[0];
  };

  const handleAmountChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const value = e.target.value.replace(/[^\d.]/g, '');
    setAmount(value);
  };

  if (loading) {
    return (
      <div className={styles.container}>
        <div className={styles.loading}>Loading templates...</div>
      </div>
    );
  }

  if (templates.length === 0) {
    return null;
  }

  // Separate debit and credit lines
  const debitLines = templateLines.filter((l) => l.type === 'debit');
  const creditLines = templateLines.filter((l) => l.type === 'credit');

  return (
    <div className={styles.container}>
      <div className={styles.header}>
        <div className={styles.label}>Templates:</div>
        <StoreSelector
          stores={stores}
          selectedStoreId={selectedStoreId}
          onStoreSelect={onStoreChange}
          showAllStoresOption={false}
          width="160px"
          size="compact"
          className={styles.storeSelector}
        />
      </div>
      <div className={styles.templateList}>
        {templates.map((template) => (
          <button
            key={template.templateId}
            className={`${styles.templateChip} ${
              selectedTemplate?.templateId === template.templateId ? styles.selected : ''
            }`}
            onClick={() => handleTemplateClick(template)}
            title={template.description || template.name}
          >
            <span className={styles.templateName}>{template.name}</span>
          </button>
        ))}
      </div>

      {/* Template Detail Panel */}
      {selectedTemplate && (
        <div className={styles.detailPanel}>
          <div className={styles.detailContent}>
            {/* Debit Account Info */}
            <div className={styles.accountRow}>
              <span className={styles.accountLabel}>Debit:</span>
              <span className={styles.accountValue}>
                {debitLines.length > 0
                  ? debitLines.map((l) => l.accountName).join(', ')
                  : '-'}
              </span>
            </div>

            {/* Credit Account Info */}
            <div className={styles.accountRow}>
              <span className={styles.accountLabel}>Credit:</span>
              <span className={styles.accountValue}>
                {creditLines.length > 0
                  ? creditLines.map((l) => l.accountName).join(', ')
                  : '-'}
              </span>
            </div>

            {/* Amount Input */}
            <div className={styles.amountRow}>
              <span className={styles.amountLabel}>Amount:</span>
              <input
                type="text"
                inputMode="decimal"
                className={styles.amountInput}
                value={formatNumber(amount)}
                onChange={handleAmountChange}
                placeholder="Enter amount..."
                autoFocus
              />
            </div>

            {/* Action Buttons */}
            <div className={styles.actionButtons}>
              <button
                className={styles.cancelButton}
                onClick={handleCancel}
              >
                Cancel
              </button>
              <button
                className={styles.okButton}
                onClick={handleApply}
                disabled={!amount || parseFloat(amount) <= 0}
              >
                OK
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default TemplateSelector;
