/**
 * AccountMappingPage Component
 * Account mapping configuration page
 *
 * Following 2025 Best Practice:
 * - Uses Zustand store for state management
 * - Clean separation of concerns
 * - Optimized re-renders with selector pattern
 */

import React, { useEffect } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { useAppState } from '@/app/providers/app_state_provider';
import { useAccountMapping } from '../../hooks/useAccountMapping';
import { AddAccountMappingModal } from '../../components/AddAccountMappingModal/AddAccountMappingModal';
import { ConfirmModal } from '@/shared/components/common/ConfirmModal';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
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
  const { currentCompany, companies } = useAppState();

  // ============================================
  // STATE FROM ZUSTAND STORE (via hook)
  // ============================================
  const {
    // Data state
    outgoingMappings,
    incomingMappings,
    availableAccounts,
    availableCompanies,

    // Loading state
    loading,
    isDeleting,

    // Error state
    error,
    showErrorMessage,
    errorMessageText,

    // Modal state
    showAddModal,
    showDeleteConfirm,
    deletingMappingId,
    deletingMappingInfo,

    // Actions
    createMapping,
    deleteMapping,
    getCompanyAccounts,
    loadModalData,
    refresh,

    // UI actions
    openAddModal,
    closeAddModal,
    openDeleteConfirm,
    closeDeleteConfirm,
    showError,
    hideError,
  } = useAccountMapping(currentCompany?.company_id || '');

  // ============================================
  // EFFECTS
  // ============================================

  /**
   * Load modal data when modal opens
   *
   * Following ARCHITECTURE.md Best Practice:
   * - Only include primitive/stable dependencies
   * - Use currentCompany.company_id instead of object reference
   * - Zustand actions are stable, no need in dependency array
   * - Prevents infinite loop from function/array reference changes
   */
  useEffect(() => {
    if (showAddModal && currentCompany) {
      loadModalData(companies);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [showAddModal, currentCompany?.company_id]);

  // ============================================
  // EVENT HANDLERS
  // ============================================

  /**
   * Handle delete button click
   */
  const handleDeleteClick = (mappingId: string, myAccountName: string, linkedAccountName: string) => {
    openDeleteConfirm(mappingId, myAccountName, linkedAccountName);
  };

  /**
   * Handle delete confirmation
   */
  const handleConfirmDelete = async () => {
    if (!deletingMappingId) return;

    const result = await deleteMapping(deletingMappingId);

    if (result.success) {
      closeDeleteConfirm();
    } else {
      closeDeleteConfirm();
      showError(result.error || 'Failed to delete mapping');
    }
  };

  /**
   * Handle delete cancellation
   */
  const handleCancelDelete = () => {
    closeDeleteConfirm();
  };

  // ============================================
  // RENDER CONDITIONS
  // ============================================

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

  if (loading) {
    return (
      <>
        <Navbar activeItem="setting" />
        <div className={styles.container}>
          <LoadingAnimation fullscreen />
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

  // ============================================
  // MAIN RENDER
  // ============================================

  return (
    <>
      <Navbar activeItem="setting" />
      <div className={styles.container}>
        <div className={styles.pageHeader}>
          <div>
            <h1 className={styles.pageTitle}>Account Mapping</h1>
            <p className={styles.pageSubtitle}>Configure chart of accounts</p>
          </div>
          <button onClick={openAddModal} className={styles.addButton}>
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
                        onClick={() => handleDeleteClick(mapping.mappingId, mapping.myAccountName, mapping.linkedAccountName)}
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
        <AddAccountMappingModal
          isOpen={showAddModal}
          onClose={closeAddModal}
          onSubmit={createMapping}
          getCompanyAccounts={getCompanyAccounts}
          availableCompanies={availableCompanies}
          availableAccounts={availableAccounts}
        />

        {/* Delete Confirmation Modal */}
        <ConfirmModal
          isOpen={showDeleteConfirm}
          onClose={handleCancelDelete}
          onConfirm={handleConfirmDelete}
          variant="error"
          title="Delete Account Mapping"
          message="Are you sure you want to delete this account mapping?"
          confirmText="Delete"
          cancelText="Cancel"
          confirmButtonVariant="error"
          isLoading={isDeleting}
          closeOnBackdropClick={!isDeleting}
          closeOnEscape={!isDeleting}
        >
          {deletingMappingInfo && (
            <div style={{
              display: 'flex',
              flexDirection: 'column',
              gap: 'var(--space-3)',
              padding: 'var(--space-4)',
              background: 'var(--toss-gray-50)',
              borderRadius: 'var(--radius-md)',
              fontSize: 'var(--font-small)'
            }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 'var(--space-2)' }}>
                <svg width="16" height="16" viewBox="0 0 24 24" fill="var(--text-tertiary)">
                  <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
                </svg>
                <span>Your Account: <strong>{deletingMappingInfo.myAccount}</strong></span>
              </div>
              <div style={{ display: 'flex', alignItems: 'center', gap: 'var(--space-2)' }}>
                <svg width="16" height="16" viewBox="0 0 24 24" fill="var(--text-tertiary)">
                  <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
                </svg>
                <span>Linked Account: <strong>{deletingMappingInfo.linkedAccount}</strong></span>
              </div>
              <div style={{
                color: 'var(--toss-error)',
                fontSize: 'var(--font-small)',
                marginTop: 'var(--space-2)',
                fontWeight: 500
              }}>
                This action cannot be undone.
              </div>
            </div>
          )}
        </ConfirmModal>

        {/* Error Message */}
        <ErrorMessage
          variant="error"
          isOpen={showErrorMessage}
          onClose={hideError}
          message={errorMessageText}
          zIndex={10000}
        />
      </div>
    </>
  );
};
