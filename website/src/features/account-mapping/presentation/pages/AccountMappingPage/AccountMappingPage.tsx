/**
 * AccountMappingPage Component
 * Account mapping configuration page
 */

import React, { useState } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { useAppState } from '@/app/providers/app_state_provider';
import { useAccountMapping } from '../../hooks/useAccountMapping';
import { AccountType } from '../../../domain/entities/AccountMapping';
import styles from './AccountMappingPage.module.css';

export const AccountMappingPage: React.FC = () => {
  const { currentCompany } = useAppState();
  const { mappings, loading, error, createMapping, deleteMapping, refresh } = useAccountMapping(
    currentCompany?.company_id || ''
  );

  const [showAddModal, setShowAddModal] = useState(false);
  const [newAccountCode, setNewAccountCode] = useState('');
  const [newAccountName, setNewAccountName] = useState('');
  const [newAccountType, setNewAccountType] = useState<AccountType>('general');
  const [newDescription, setNewDescription] = useState('');

  if (!currentCompany) {
    return (
      <>
        <Navbar activeItem="setting" />
        <div className={styles.container}>
          <div className={styles.emptyState}>
            <p>Please select a company to view account mappings</p>
          </div>
        </div>
      </>
    );
  }

  const handleAddMapping = async () => {
    if (!newAccountCode || !newAccountName) {
      alert('Please fill in all required fields');
      return;
    }

    const result = await createMapping(
      newAccountCode,
      newAccountName,
      newAccountType,
      newDescription || null
    );

    if (result.success) {
      setShowAddModal(false);
      setNewAccountCode('');
      setNewAccountName('');
      setNewAccountType('general');
      setNewDescription('');
    } else {
      alert(result.error || 'Failed to create mapping');
    }
  };

  const handleDeleteMapping = async (mappingId: string) => {
    if (!confirm('Are you sure you want to delete this mapping?')) {
      return;
    }

    const result = await deleteMapping(mappingId);
    if (!result.success) {
      alert(result.error || 'Failed to delete mapping');
    }
  };

  const myMappings = mappings.filter((m) => !m.isReadOnly);
  const readOnlyMappings = mappings.filter((m) => m.isReadOnly);

  if (loading) {
    return (
      <>
        <Navbar activeItem="setting" />
        <div className={styles.container}>
          <div className={styles.loadingSpinner}>
            <div className={styles.spinner} />
          </div>
        </div>
      </>
    );
  }

  if (error) {
    return (
      <>
        <Navbar activeItem="setting" />
        <div className={styles.container}>
          <div className={styles.errorState}>
            <p className={styles.errorMessage}>{error}</p>
            <button onClick={refresh} className={styles.retryButton}>
              Retry
            </button>
          </div>
        </div>
      </>
    );
  }

  return (
    <>
      <Navbar activeItem="setting" />
      <div className={styles.container}>
      <div className={styles.pageHeader}>
        <div>
          <h1 className={styles.pageTitle}>Account Mapping</h1>
          <p className={styles.pageSubtitle}>Configure chart of accounts</p>
        </div>
        <button onClick={() => setShowAddModal(true)} className={styles.addButton}>
          <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
            <path d="M19,13H13V19H11V13H5V11H11V5H13V11H19V13Z" />
          </svg>
          Add Account Mapping
        </button>
      </div>

      {/* My Company Mappings */}
      <div className={styles.section}>
        <h2 className={styles.sectionTitle}>My Company Mappings</h2>
        <p className={styles.sectionSubtitle}>Account mappings created by your company</p>

        {myMappings.length === 0 ? (
          <div className={styles.emptySection}>
            <p>No account mappings yet</p>
          </div>
        ) : (
          <div className={styles.cardsGrid}>
            {myMappings.map((mapping) => (
              <div key={mapping.mappingId} className={styles.card}>
                <div className={styles.cardHeader}>
                  <div className={styles.accountCode}>{mapping.accountCode}</div>
                  <span className={`${styles.typeBadge} ${styles[mapping.accountTypeColor]}`}>
                    {mapping.accountTypeDisplay}
                  </span>
                </div>
                <div className={styles.cardBody}>
                  <div className={styles.accountName}>{mapping.accountName}</div>
                  {mapping.description && (
                    <div className={styles.description}>{mapping.description}</div>
                  )}
                </div>
                <div className={styles.cardFooter}>
                  <span className={styles.createdDate}>{mapping.formattedCreatedDate}</span>
                  {mapping.isDeletable && (
                    <button
                      onClick={() => handleDeleteMapping(mapping.mappingId)}
                      className={styles.deleteButton}
                    >
                      Delete
                    </button>
                  )}
                </div>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Read-Only Mappings */}
      {readOnlyMappings.length > 0 && (
        <div className={styles.section}>
          <h2 className={styles.sectionTitle}>
            System Mappings
            <span className={styles.lockBadge}>
              <svg width="12" height="12" viewBox="0 0 24 24" fill="currentColor">
                <path d="M12,17C10.89,17 10,16.1 10,15C10,13.89 10.89,13 12,13A2,2 0 0,1 14,15A2,2 0 0,1 12,17M18,20V10H6V20H18M18,8A2,2 0 0,1 20,10V20A2,2 0 0,1 18,22H6C4.89,22 4,21.1 4,20V10C4,8.89 4.89,8 6,8H7V6A5,5 0 0,1 12,1A5,5 0 0,1 17,6V8H18M12,3A3,3 0 0,0 9,6V8H15V6A3,3 0 0,0 12,3Z" />
              </svg>
              Read-Only
            </span>
          </h2>
          <p className={styles.sectionSubtitle}>Standard account mappings (cannot be modified)</p>

          <div className={styles.cardsGrid}>
            {readOnlyMappings.map((mapping) => (
              <div key={mapping.mappingId} className={`${styles.card} ${styles.readOnly}`}>
                <div className={styles.cardHeader}>
                  <div className={styles.accountCode}>{mapping.accountCode}</div>
                  <span className={`${styles.typeBadge} ${styles[mapping.accountTypeColor]}`}>
                    {mapping.accountTypeDisplay}
                  </span>
                </div>
                <div className={styles.cardBody}>
                  <div className={styles.accountName}>{mapping.accountName}</div>
                  {mapping.description && (
                    <div className={styles.description}>{mapping.description}</div>
                  )}
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Add Modal */}
      {showAddModal && (
        <div className={styles.modalOverlay} onClick={() => setShowAddModal(false)}>
          <div className={styles.modal} onClick={(e) => e.stopPropagation()}>
            <div className={styles.modalHeader}>
              <h2>Add Account Mapping</h2>
              <button onClick={() => setShowAddModal(false)} className={styles.closeButton}>
                <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z" />
                </svg>
              </button>
            </div>
            <div className={styles.modalBody}>
              <div className={styles.formGroup}>
                <label>Account Code *</label>
                <input
                  type="text"
                  value={newAccountCode}
                  onChange={(e) => setNewAccountCode(e.target.value)}
                  placeholder="e.g., 1000"
                />
              </div>
              <div className={styles.formGroup}>
                <label>Account Name *</label>
                <input
                  type="text"
                  value={newAccountName}
                  onChange={(e) => setNewAccountName(e.target.value)}
                  placeholder="e.g., Cash"
                />
              </div>
              <div className={styles.formGroup}>
                <label>Account Type *</label>
                <select value={newAccountType} onChange={(e) => setNewAccountType(e.target.value as AccountType)}>
                  <option value="general">General</option>
                  <option value="cash">Cash</option>
                  <option value="payable">Payable</option>
                  <option value="receivable">Receivable</option>
                  <option value="contra_asset">Contra Asset</option>
                  <option value="fixed_asset">Fixed Asset</option>
                  <option value="equity">Equity</option>
                </select>
              </div>
              <div className={styles.formGroup}>
                <label>Description</label>
                <textarea
                  value={newDescription}
                  onChange={(e) => setNewDescription(e.target.value)}
                  placeholder="Optional description"
                  rows={3}
                />
              </div>
            </div>
            <div className={styles.modalFooter}>
              <button onClick={() => setShowAddModal(false)} className={styles.cancelButton}>
                Cancel
              </button>
              <button onClick={handleAddMapping} className={styles.saveButton}>
                Add Mapping
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
    </>
  );
};
