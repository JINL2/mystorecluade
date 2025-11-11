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

// Helper function to get account initials
const getAccountInitials = (name: string): string => {
  if (!name) return '??';
  const words = name.trim().split(' ');
  if (words.length === 1) {
    return name.substring(0, 2).toUpperCase();
  }
  return words.slice(0, 2).map(w => w[0]).join('').toUpperCase();
};

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

  // Separate outgoing and incoming mappings
  const outgoingMappings = mappings.filter((m) => !m.isReadOnly);
  const incomingMappings = mappings.filter((m) => m.isReadOnly);

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

      {/* My Company Mappings (Outgoing) */}
      <div className={styles.section}>
        <h2 className={styles.sectionTitle}>My Company Mappings</h2>
        <p className={styles.sectionSubtitle}>Account mappings created by your company</p>

        {outgoingMappings.length === 0 ? (
          <div className={styles.emptySection}>
            <p>No account mappings yet</p>
          </div>
        ) : (
          <div className={styles.cardsGrid}>
            {outgoingMappings.map((mapping) => (
              <div key={mapping.mappingId} className={styles.card}>
                <div className={styles.cardHeader}>
                  <span className={styles.directionBadge}>{mapping.directionDisplay}</span>
                  {mapping.isDeletable && (
                    <button
                      onClick={() => handleDeleteMapping(mapping.mappingId)}
                      className={styles.deleteButton}
                      title="Delete"
                    >
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/>
                      </svg>
                    </button>
                  )}
                </div>
                <div className={styles.accountDetails}>
                  {/* My Account */}
                  <div className={styles.mappingItem}>
                    <div className={styles.accountIcon}>{getAccountInitials(mapping.myAccountName)}</div>
                    <div className={styles.accountInfo}>
                      <div className={styles.accountName}>{mapping.myAccountName}</div>
                      <div className={styles.accountCode}>{mapping.getCategoryDisplay(mapping.myCategoryTag)}</div>
                    </div>
                  </div>

                  {/* Connection Arrow */}
                  <div className={styles.mappingConnection}>
                    <div className={styles.mappingArrow}>
                      <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M12 4l-1.41 1.41L16.17 11H4v2h12.17l-5.58 5.59L12 20l8-8z"/>
                      </svg>
                      <span>{mapping.linkedCompanyName || 'Direct Link'}</span>
                    </div>
                  </div>

                  {/* Linked Account */}
                  <div className={styles.mappingItem}>
                    <div className={styles.accountIcon}>{getAccountInitials(mapping.linkedAccountName)}</div>
                    <div className={styles.accountInfo}>
                      <div className={styles.accountName}>{mapping.linkedAccountName}</div>
                      <div className={styles.accountCode}>
                        {mapping.getCategoryDisplay(mapping.linkedCategoryTag)}
                        <span className={styles.companyBadge}>{mapping.linkedCompanyName}</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Incoming Mappings (Read-Only) */}
      {incomingMappings.length > 0 && (
        <div className={styles.section}>
          <h2 className={styles.sectionTitle}>
            Reverse Mappings
            <span className={styles.lockBadge}>
              <svg width="12" height="12" viewBox="0 0 24 24" fill="currentColor">
                <path d="M12,17C10.89,17 10,16.1 10,15C10,13.89 10.89,13 12,13A2,2 0 0,1 14,15A2,2 0 0,1 12,17M18,20V10H6V20H18M18,8A2,2 0 0,1 20,10V20A2,2 0 0,1 18,22H6C4.89,22 4,21.1 4,20V10C4,8.89 4.89,8 6,8H7V6A5,5 0 0,1 12,1A5,5 0 0,1 17,6V8H18M12,3A3,3 0 0,0 9,6V8H15V6A3,3 0 0,0 12,3Z" />
              </svg>
              Read-Only
            </span>
          </h2>
          <p className={styles.sectionSubtitle}>Mappings created by other companies (cannot be modified)</p>

          <div className={styles.cardsGrid}>
            {incomingMappings.map((mapping) => (
              <div key={mapping.mappingId} className={`${styles.card} ${styles.readOnly}`}>
                <div className={styles.cardHeader}>
                  <span className={styles.directionBadge}>{mapping.directionDisplay}</span>
                  <div className={styles.readOnlyIndicator} title={`Created by ${mapping.linkedCompanyName}. Cannot be edited from here.`}>
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="var(--toss-gray-400)">
                      <path d="M12 17c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zm6-9h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zM8.9 6c0-1.71 1.39-3.1 3.1-3.1s3.1 1.39 3.1 3.1v2H8.9V6zM18 20H6V10h12v10z"/>
                    </svg>
                  </div>
                </div>
                <div className={styles.accountDetails}>
                  {/* My Account */}
                  <div className={styles.mappingItem}>
                    <div className={styles.accountIcon}>{getAccountInitials(mapping.myAccountName)}</div>
                    <div className={styles.accountInfo}>
                      <div className={styles.accountName}>{mapping.myAccountName}</div>
                      <div className={styles.accountCode}>{mapping.getCategoryDisplay(mapping.myCategoryTag)}</div>
                    </div>
                  </div>

                  {/* Connection Arrow */}
                  <div className={styles.mappingConnection}>
                    <div className={styles.mappingArrow}>
                      <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/>
                      </svg>
                      <span>{mapping.linkedCompanyName || 'Direct Link'}</span>
                    </div>
                  </div>

                  {/* Linked Account */}
                  <div className={styles.mappingItem}>
                    <div className={styles.accountIcon}>{getAccountInitials(mapping.linkedAccountName)}</div>
                    <div className={styles.accountInfo}>
                      <div className={styles.accountName}>{mapping.linkedAccountName}</div>
                      <div className={styles.accountCode}>
                        {mapping.getCategoryDisplay(mapping.linkedCategoryTag)}
                        <span className={styles.companyBadge}>{mapping.linkedCompanyName}</span>
                      </div>
                    </div>
                  </div>
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
