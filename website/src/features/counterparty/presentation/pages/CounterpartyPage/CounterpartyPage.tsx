/**
 * CounterpartyPage Component
 * Refactored to use Zustand Provider (2025 Best Practice)
 */

import React, { useMemo, useEffect } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { useAppState } from '@/app/providers/app_state_provider';
import { useCounterparty } from '../../hooks/useCounterparty';
import type { TossSelectorOption } from '@/shared/components/selectors/TossSelector/TossSelector.types';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { useErrorMessage } from '@/shared/hooks/useErrorMessage';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { CreateCounterpartyModal } from '../../components/CreateCounterpartyModal';
import { DeleteConfirmModal } from '../../components/DeleteConfirmModal';
import styles from './CounterpartyPage.module.css';

export const CounterpartyPage: React.FC = () => {
  const { currentCompany, companies } = useAppState();
  const {
    loading,
    error,
    showModal,
    showDeleteModal,
    internalCounterparties,
    externalCounterparties,
    loadCounterparties,
    openCreateModal,
    closeCreateModal,
    closeDeleteModal,
    openDeleteModal,
    submitCounterparty,
    confirmDelete,
  } = useCounterparty();

  const { messageState, closeMessage, showError, showSuccess } = useErrorMessage();

  // Company options for selector
  const companyOptions: TossSelectorOption[] = useMemo(() => {
    return (companies || []).map((company) => ({
      value: company.company_id,
      label: company.company_name,
      badge: company.company_name.substring(0, 2).toUpperCase(),
    }));
  }, [companies]);

  // Load counterparties on mount and when company changes
  useEffect(() => {
    if (currentCompany?.company_id) {
      loadCounterparties(currentCompany.company_id);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [currentCompany?.company_id]); // Remove loadCounterparties from deps to prevent infinite loop

  // Monitor error state and display in ErrorMessage
  useEffect(() => {
    if (error) {
      showError({
        title: 'Failed to Load',
        message: error,
      });
    }
  }, [error, showError]);

  // Handle submit with success/error messages
  const handleSubmit = async () => {
    if (!currentCompany?.company_id) return;

    const result = await submitCounterparty(currentCompany.company_id);

    if (result.success) {
      showSuccess({
        message: 'Counterparty created successfully',
        autoCloseDuration: 2000,
      });
    } else {
      showError({
        title: 'Failed to Create',
        message: result.error || 'Unable to create counterparty. Please try again.',
      });
    }
  };

  // Handle delete with success/error messages
  const handleDelete = async () => {
    if (!currentCompany?.company_id) return;

    const result = await confirmDelete(currentCompany.company_id);

    if (result.success) {
      showSuccess({
        message: 'Counterparty deleted successfully',
        autoCloseDuration: 2000,
      });
    } else {
      showError({
        title: 'Failed to Delete',
        message: result.error || 'Unable to delete counterparty. Please try again.',
      });
    }
  };

  // Loading state
  if (loading && internalCounterparties.length === 0 && externalCounterparties.length === 0) {
    return (
      <>
        <Navbar activeItem="setting" />
        <div className={styles.pageLayout}>
          <div className={styles.container}>
            <LoadingAnimation size="large" fullscreen />
          </div>
        </div>
      </>
    );
  }

  // No company selected
  if (!currentCompany) {
    return (
      <>
        <Navbar activeItem="setting" />
        <div className={styles.pageLayout}>
          <div className={styles.container}>
            <p>Select company</p>
          </div>
        </div>
      </>
    );
  }

  const totalCounterparties = internalCounterparties.length + externalCounterparties.length;

  return (
    <>
      <Navbar activeItem="setting" />
      <div className={styles.pageLayout}>
        <div className={styles.container}>
          <div className={styles.header}>
            <div>
              <h1 className={styles.title}>Counterparty</h1>
              <p className={styles.subtitle}>Manage business partners and relationships</p>
            </div>
            <button onClick={openCreateModal} className={styles.addBtn}>
              <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                <path d="M19,13H13V19H11V13H5V11H11V5H13V11H19V13Z" />
              </svg>
              Add Counterparty
            </button>
          </div>

        {/* Internal Organizations Section */}
        {internalCounterparties.length > 0 && (
          <div className={`${styles.section} ${styles.internalSection}`}>
            <div className={styles.sectionHeader}>
              <div className={styles.sectionTitle}>
                <svg className={styles.sectionIcon} viewBox="0 0 24 24" fill="currentColor">
                  <path d="M10,20V14H14V20H19V12H22L12,3L2,12H5V20H10Z" />
                </svg>
                <h2>Internal Organizations</h2>
                <span className={styles.sectionCount}>{internalCounterparties.length}</span>
              </div>
              <p className={styles.sectionSubtitle}>Your internal company structures and departments</p>
            </div>
            <div className={styles.grid}>
              {internalCounterparties.map((c) => {
                const linkedCompany = c.linkedCompanyId
                  ? companies?.find((co) => co.company_id === c.linkedCompanyId)
                  : null;
                return (
                  <div key={c.counterpartyId} className={`${styles.card} ${styles.internalCard}`}>
                    <div className={styles.cardHeader}>
                      <div className={styles.cardInfo}>
                        <h3 className={styles.cardName}>{c.name}</h3>
                        <div className={styles.cardMeta}>
                          <span className={styles.internalBadge}>
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
                              <path d="M10,20V14H14V20H19V12H22L12,3L2,12H5V20H10Z" />
                            </svg>
                            Internal
                          </span>
                          {linkedCompany && (
                            <span className={styles.linkedCompany}>{linkedCompany.company_name}</span>
                          )}
                        </div>
                      </div>
                      <div className={styles.cardActions}>
                        <span className={styles.typeBadge}>{c.type}</span>
                        <button onClick={() => openDeleteModal(c.counterpartyId)} className={styles.deleteBtn}>
                          <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M9,3V4H4V6H5V19A2,2 0 0,0 7,21H17A2,2 0 0,0 19,19V6H20V4H15V3H9M7,6H17V19H7V6M9,8V17H11V8H9M13,8V17H15V8H13Z" />
                          </svg>
                        </button>
                      </div>
                    </div>
                    {(c.email || c.phone) && (
                      <div className={styles.cardDetails}>
                        {c.email && (
                          <div className={styles.detailRow}>
                            <svg className={styles.detailIcon} viewBox="0 0 24 24" fill="currentColor">
                              <path d="M20,8L12,13L4,8V6L12,11L20,6M20,4H4C2.89,4 2,4.89 2,6V18A2,2 0 0,0 4,20H20A2,2 0 0,0 22,18V6C22,4.89 21.1,4 20,4Z" />
                            </svg>
                            <span>{c.email}</span>
                          </div>
                        )}
                        {c.phone && (
                          <div className={styles.detailRow}>
                            <svg className={styles.detailIcon} viewBox="0 0 24 24" fill="currentColor">
                              <path d="M6.62,10.79C8.06,13.62 10.38,15.94 13.21,17.38L15.41,15.18C15.69,14.9 16.08,14.82 16.43,14.93C17.55,15.3 18.75,15.5 20,15.5A1,1 0 0,1 21,16.5V20A1,1 0 0,1 20,21A17,17 0 0,1 3,4A1,1 0 0,1 4,3H7.5A1,1 0 0,1 8.5,4C8.5,5.25 8.7,6.45 9.07,7.57C9.18,7.92 9.1,8.31 8.82,8.59L6.62,10.79Z" />
                            </svg>
                            <span>{c.phone}</span>
                          </div>
                        )}
                      </div>
                    )}
                  </div>
                );
              })}
            </div>
          </div>
        )}

        {/* External Partners Section */}
        {externalCounterparties.length > 0 && (
          <div className={styles.section}>
            <div className={styles.sectionHeader}>
              <div className={styles.sectionTitle}>
                <svg className={styles.sectionIcon} viewBox="0 0 24 24" fill="currentColor">
                  <path d="M12,5.5A3.5,3.5 0 0,1 15.5,9A3.5,3.5 0 0,1 12,12.5A3.5,3.5 0 0,1 8.5,9A3.5,3.5 0 0,1 12,5.5M5,8C5.56,8 6.08,8.15 6.53,8.42C6.38,9.85 6.8,11.27 7.66,12.38C7.16,13.34 6.16,14 5,14A3,3 0 0,1 2,11A3,3 0 0,1 5,8M19,8A3,3 0 0,1 22,11A3,3 0 0,1 19,14C17.84,14 16.84,13.34 16.34,12.38C17.2,11.27 17.62,9.85 17.47,8.42C17.92,8.15 18.44,8 19,8M5.5,18.25C5.5,16.18 8.41,14.5 12,14.5C15.59,14.5 18.5,16.18 18.5,18.25V20H5.5V18.25M0,20V18.5C0,17.11 1.89,15.94 4.45,15.6C3.86,16.28 3.5,17.22 3.5,18.25V20H0M24,20H20.5V18.25C20.5,17.22 20.14,16.28 19.55,15.6C22.11,15.94 24,17.11 24,18.5V20Z" />
                </svg>
                <h2>External Partners</h2>
                <span className={styles.sectionCount}>{externalCounterparties.length}</span>
              </div>
              <p className={styles.sectionSubtitle}>Customers, suppliers, and business partners</p>
            </div>
            <div className={styles.grid}>
              {externalCounterparties.map((c) => (
                <div key={c.counterpartyId} className={styles.card}>
                  <div className={styles.cardHeader}>
                    <div className={styles.cardInfo}>
                      <h3 className={styles.cardName}>{c.name}</h3>
                      <p className={styles.cardType}>Type: {c.type}</p>
                    </div>
                    <div className={styles.cardActions}>
                      <span className={styles.typeBadge}>{c.type}</span>
                      <button onClick={() => openDeleteModal(c.counterpartyId)} className={styles.deleteBtn}>
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                          <path d="M9,3V4H4V6H5V19A2,2 0 0,0 7,21H17A2,2 0 0,0 19,19V6H20V4H15V3H9M7,6H17V19H7V6M9,8V17H11V8H9M13,8V17H15V8H13Z" />
                        </svg>
                      </button>
                    </div>
                  </div>
                  {(c.email || c.phone) && (
                    <div className={styles.cardDetails}>
                      {c.email && (
                        <div className={styles.detailRow}>
                          <svg className={styles.detailIcon} viewBox="0 0 24 24" fill="currentColor">
                            <path d="M20,8L12,13L4,8V6L12,11L20,6M20,4H4C2.89,4 2,4.89 2,6V18A2,2 0 0,0 4,20H20A2,2 0 0,0 22,18V6C22,4.89 21.1,4 20,4Z" />
                          </svg>
                          <span>{c.email}</span>
                        </div>
                      )}
                      {c.phone && (
                        <div className={styles.detailRow}>
                          <svg className={styles.detailIcon} viewBox="0 0 24 24" fill="currentColor">
                            <path d="M6.62,10.79C8.06,13.62 10.38,15.94 13.21,17.38L15.41,15.18C15.69,14.9 16.08,14.82 16.43,14.93C17.55,15.3 18.75,15.5 20,15.5A1,1 0 0,1 21,16.5V20A1,1 0 0,1 20,21A17,17 0 0,1 3,4A1,1 0 0,1 4,3H7.5A1,1 0 0,1 8.5,4C8.5,5.25 8.7,6.45 9.07,7.57C9.18,7.92 9.1,8.31 8.82,8.59L6.62,10.79Z" />
                          </svg>
                          <span>{c.phone}</span>
                        </div>
                      )}
                    </div>
                  )}
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Empty State */}
        {totalCounterparties === 0 && (
          <div className={styles.empty}>
            <svg className={styles.emptyIcon} width="120" height="120" viewBox="0 0 120 120" fill="none">
              <circle cx="60" cy="60" r="50" fill="#F0F6FF" />
              <rect x="30" y="45" width="60" height="40" rx="4" fill="white" stroke="#0064FF" strokeWidth="2" />
              <rect x="35" y="40" width="60" height="40" rx="4" fill="white" stroke="#0064FF" strokeWidth="2" />
              <line x1="43" y1="48" x2="58" y2="48" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round" />
              <line x1="43" y1="54" x2="75" y2="54" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round" />
              <line x1="43" y1="60" x2="70" y2="60" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round" />
              <circle cx="83" cy="55" r="8" fill="#0064FF" />
              <circle cx="83" cy="53" r="3" fill="white" />
              <path d="M78 59 Q78 56 83 56 Q88 56 88 59" stroke="white" strokeWidth="1.5" fill="none" strokeLinecap="round" />
              <circle cx="60" cy="85" r="15" fill="#0064FF" />
              <line x1="60" y1="77" x2="60" y2="93" stroke="white" strokeWidth="3" strokeLinecap="round" />
              <line x1="52" y1="85" x2="68" y2="85" stroke="white" strokeWidth="3" strokeLinecap="round" />
            </svg>
            <h2 className={styles.emptyTitle}>No Counterparties Found</h2>
            <p className={styles.emptyText}>
              Start by adding your first counterparty to manage business relationships.
            </p>
            <button onClick={openCreateModal} className={styles.addBtn}>
              <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                <path d="M19,13H13V19H11V13H5V11H11V5H13V11H19V13Z" />
              </svg>
              Add Your First Counterparty
            </button>
          </div>
        )}

        {/* Create Modal */}
        <CreateCounterpartyModal
          isOpen={showModal}
          onClose={closeCreateModal}
          onSubmit={handleSubmit}
          companyOptions={companyOptions}
        />

        {/* Delete Confirm Modal */}
        <DeleteConfirmModal isOpen={showDeleteModal} onClose={closeDeleteModal} onConfirm={handleDelete} />

          {/* ErrorMessage Component */}
          <ErrorMessage
            isOpen={messageState.isOpen}
            variant={messageState.variant}
            title={messageState.title}
            message={messageState.message}
            onClose={closeMessage}
            autoCloseDuration={messageState.autoCloseDuration}
            closeOnBackdropClick={messageState.closeOnBackdropClick}
          />
        </div>
      </div>
    </>
  );
};
