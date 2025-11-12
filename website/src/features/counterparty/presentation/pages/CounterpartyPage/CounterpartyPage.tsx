/**
 * CounterpartyPage Component
 */

import React, { useState, useMemo, useEffect } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { useAppState } from '@/app/providers/app_state_provider';
import { useCounterparty } from '../../hooks/useCounterparty';
import { CounterpartyTypeValue } from '../../../domain/entities/Counterparty';
import { TossSelector } from '@/shared/components/selectors/TossSelector';
import type { TossSelectorOption } from '@/shared/components/selectors/TossSelector/TossSelector.types';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { useErrorMessage } from '@/shared/hooks/useErrorMessage';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import styles from './CounterpartyPage.module.css';

const TYPE_OPTIONS: TossSelectorOption[] = [
  { value: 'My Company', label: 'My Company' },
  { value: 'Team Member', label: 'Team Member' },
  { value: 'Suppliers', label: 'Suppliers' },
  { value: 'Employees', label: 'Employees' },
  { value: 'Customers', label: 'Customers' },
  { value: 'Others', label: 'Others' },
];

export const CounterpartyPage: React.FC = () => {
  const { currentCompany, companies } = useAppState();
  const { counterparties, loading, error, createCounterparty, deleteCounterparty } = useCounterparty(currentCompany?.company_id || '');
  const { messageState, closeMessage, showError, showSuccess } = useErrorMessage();

  const [showModal, setShowModal] = useState(false);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [deleteId, setDeleteId] = useState<string | null>(null);

  const [name, setName] = useState('');
  const [isInternal, setIsInternal] = useState(false);
  const [linkedCompanyId, setLinkedCompanyId] = useState<string | null>(null);
  const [type, setType] = useState<CounterpartyTypeValue | ''>('');
  const [email, setEmail] = useState('');
  const [phone, setPhone] = useState('');
  const [notes, setNotes] = useState('');

  const companyOptions: TossSelectorOption[] = useMemo(() => {
    return (companies || []).map(company => ({
      value: company.company_id,
      label: company.company_name,
      badge: company.company_name.substring(0, 2).toUpperCase(),
    }));
  }, [companies]);

  // Monitor hook error state and display in ErrorMessage
  useEffect(() => {
    if (error) {
      showError({
        title: 'Failed to Load',
        message: error,
      });
    }
  }, [error, showError]);

  const handleAdd = async () => {
    if (!name.trim() || !type) return;
    const result = await createCounterparty(
      name.trim(),
      type as CounterpartyTypeValue,
      isInternal,
      linkedCompanyId,
      email || null,
      phone || null,
      notes || null
    );
    if (result.success) {
      showSuccess({
        message: 'Counterparty created successfully',
        autoCloseDuration: 2000,
      });
      setShowModal(false);
      resetForm();
    } else {
      showError({
        title: 'Failed to Create',
        message: result.error || 'Unable to create counterparty. Please try again.',
      });
    }
  };

  const resetForm = () => {
    setName('');
    setIsInternal(false);
    setLinkedCompanyId(null);
    setType('');
    setEmail('');
    setPhone('');
    setNotes('');
  };

  const handleDelete = (id: string) => {
    setDeleteId(id);
    setShowDeleteModal(true);
  };

  const confirmDelete = async () => {
    if (deleteId) {
      const result = await deleteCounterparty(deleteId);
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
      setShowDeleteModal(false);
      setDeleteId(null);
    }
  };

  const internal = counterparties.filter(c => c.isInternal);
  const external = counterparties.filter(c => !c.isInternal);

  const isFormValid = name.trim() && type && (!isInternal || linkedCompanyId);

  if (loading) {
    return (
      <>
        <Navbar activeItem="setting" />
        <div className={styles.container}>
          <LoadingAnimation size="large" fullscreen />
        </div>
      </>
    );
  }

  if (!currentCompany) {
    return (
      <>
        <Navbar activeItem="setting" />
        <div className={styles.container}>
          <p>Select company</p>
        </div>
      </>
    );
  }

  return (
    <>
      <Navbar activeItem="setting" />
      <div className={styles.container}>
        <div className={styles.header}>
          <div>
            <h1 className={styles.title}>Counterparty</h1>
            <p className={styles.subtitle}>Manage business partners and relationships</p>
          </div>
          <button onClick={() => setShowModal(true)} className={styles.addBtn}>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
              <path d="M19,13H13V19H11V13H5V11H11V5H13V11H19V13Z" />
            </svg>
            Add Counterparty
          </button>
        </div>

        {internal.length > 0 && (
          <div className={`${styles.section} ${styles.internalSection}`}>
            <div className={styles.sectionHeader}>
              <div className={styles.sectionTitle}>
                <svg className={styles.sectionIcon} viewBox="0 0 24 24" fill="currentColor">
                  <path d="M10,20V14H14V20H19V12H22L12,3L2,12H5V20H10Z" />
                </svg>
                <h2>Internal Organizations</h2>
                <span className={styles.sectionCount}>{internal.length}</span>
              </div>
              <p className={styles.sectionSubtitle}>Your internal company structures and departments</p>
            </div>
            <div className={styles.grid}>
              {internal.map(c => {
                const linkedCompany = c.linkedCompanyId ? companies?.find(co => co.company_id === c.linkedCompanyId) : null;
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
                        <button onClick={() => handleDelete(c.counterpartyId)} className={styles.deleteBtn}>
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

        {external.length > 0 && (
          <div className={styles.section}>
            <div className={styles.sectionHeader}>
              <div className={styles.sectionTitle}>
                <svg className={styles.sectionIcon} viewBox="0 0 24 24" fill="currentColor">
                  <path d="M12,5.5A3.5,3.5 0 0,1 15.5,9A3.5,3.5 0 0,1 12,12.5A3.5,3.5 0 0,1 8.5,9A3.5,3.5 0 0,1 12,5.5M5,8C5.56,8 6.08,8.15 6.53,8.42C6.38,9.85 6.8,11.27 7.66,12.38C7.16,13.34 6.16,14 5,14A3,3 0 0,1 2,11A3,3 0 0,1 5,8M19,8A3,3 0 0,1 22,11A3,3 0 0,1 19,14C17.84,14 16.84,13.34 16.34,12.38C17.2,11.27 17.62,9.85 17.47,8.42C17.92,8.15 18.44,8 19,8M5.5,18.25C5.5,16.18 8.41,14.5 12,14.5C15.59,14.5 18.5,16.18 18.5,18.25V20H5.5V18.25M0,20V18.5C0,17.11 1.89,15.94 4.45,15.6C3.86,16.28 3.5,17.22 3.5,18.25V20H0M24,20H20.5V18.25C20.5,17.22 20.14,16.28 19.55,15.6C22.11,15.94 24,17.11 24,18.5V20Z" />
                </svg>
                <h2>External Partners</h2>
                <span className={styles.sectionCount}>{external.length}</span>
              </div>
              <p className={styles.sectionSubtitle}>Customers, suppliers, and business partners</p>
            </div>
            <div className={styles.grid}>
              {external.map(c => (
                <div key={c.counterpartyId} className={styles.card}>
                  <div className={styles.cardHeader}>
                    <div className={styles.cardInfo}>
                      <h3 className={styles.cardName}>{c.name}</h3>
                      <p className={styles.cardType}>Type: {c.type}</p>
                    </div>
                    <div className={styles.cardActions}>
                      <span className={styles.typeBadge}>{c.type}</span>
                      <button onClick={() => handleDelete(c.counterpartyId)} className={styles.deleteBtn}>
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

        {counterparties.length === 0 && (
          <div className={styles.empty}>
            <svg className={styles.emptyIcon} width="120" height="120" viewBox="0 0 120 120" fill="none">
              {/* Background Circle */}
              <circle cx="60" cy="60" r="50" fill="#F0F6FF"/>

              {/* Business Card Stack */}
              <rect x="30" y="45" width="60" height="40" rx="4" fill="white" stroke="#0064FF" strokeWidth="2"/>
              <rect x="35" y="40" width="60" height="40" rx="4" fill="white" stroke="#0064FF" strokeWidth="2"/>

              {/* Card Details - Lines */}
              <line x1="43" y1="48" x2="58" y2="48" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round"/>
              <line x1="43" y1="54" x2="75" y2="54" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round"/>
              <line x1="43" y1="60" x2="70" y2="60" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round"/>

              {/* Person Icon */}
              <circle cx="83" cy="55" r="8" fill="#0064FF"/>
              <circle cx="83" cy="53" r="3" fill="white"/>
              <path d="M78 59 Q78 56 83 56 Q88 56 88 59" stroke="white" strokeWidth="1.5" fill="none" strokeLinecap="round"/>

              {/* Add Symbol */}
              <circle cx="60" cy="85" r="15" fill="#0064FF"/>
              <line x1="60" y1="77" x2="60" y2="93" stroke="white" strokeWidth="3" strokeLinecap="round"/>
              <line x1="52" y1="85" x2="68" y2="85" stroke="white" strokeWidth="3" strokeLinecap="round"/>
            </svg>
            <h2 className={styles.emptyTitle}>No Counterparties Found</h2>
            <p className={styles.emptyText}>Start by adding your first counterparty to manage business relationships.</p>
            <button onClick={() => setShowModal(true)} className={styles.addBtn}>
              <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                <path d="M19,13H13V19H11V13H5V11H11V5H13V11H19V13Z" />
              </svg>
              Add Your First Counterparty
            </button>
          </div>
        )}

        {showModal && (
          <div className={styles.modal} onClick={() => setShowModal(false)}>
            <div className={styles.modalContent} onClick={e => e.stopPropagation()}>
              <div className={styles.modalHeader}>
                <h2 className={styles.modalTitle}>Create Counterparty</h2>
                <button onClick={() => setShowModal(false)} className={styles.modalClose}>
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z" />
                  </svg>
                </button>
              </div>

              <div className={styles.modalBody}>
                <div className={styles.formGroup}>
                  <label className={styles.formLabel}>Counterparty Name *</label>
                  <input
                    className={styles.formInput}
                    placeholder="Enter counterparty name"
                    value={name}
                    onChange={e => setName(e.target.value)}
                  />
                </div>

                <div className={styles.formGroup}>
                  <label className={styles.formLabel}>Organization Type</label>
                  <div className={styles.selectionGroup}>
                    <div
                      className={`${styles.selectionBox} ${!isInternal ? styles.active : ''}`}
                      onClick={() => { setIsInternal(false); setLinkedCompanyId(null); }}
                    >
                      External Partner
                    </div>
                    <div
                      className={`${styles.selectionBox} ${isInternal ? styles.active : ''}`}
                      onClick={() => setIsInternal(true)}
                    >
                      Internal Organization
                    </div>
                  </div>
                </div>

                {isInternal && (
                  <div className={styles.formGroup}>
                    <TossSelector
                      label="Choose Counter Party Company"
                      placeholder="Select company..."
                      value={linkedCompanyId || ''}
                      options={companyOptions}
                      onChange={(value) => setLinkedCompanyId(value)}
                      searchable
                      showBadges
                      required
                      fullWidth
                    />
                  </div>
                )}

                <div className={styles.formGroup}>
                  <TossSelector
                    label="Type *"
                    placeholder="Select type..."
                    value={type}
                    options={TYPE_OPTIONS}
                    onChange={(value) => setType(value as CounterpartyTypeValue)}
                    searchable
                    required
                    fullWidth
                  />
                </div>

                <div className={styles.formGroup}>
                  <label className={styles.formLabel}>Email</label>
                  <input
                    type="email"
                    className={styles.formInput}
                    placeholder="example@email.com"
                    value={email}
                    onChange={e => setEmail(e.target.value)}
                  />
                </div>

                <div className={styles.formGroup}>
                  <label className={styles.formLabel}>Phone Number</label>
                  <input
                    type="tel"
                    className={styles.formInput}
                    placeholder="Enter phone number"
                    value={phone}
                    onChange={e => setPhone(e.target.value)}
                  />
                </div>

                <div className={styles.formGroup}>
                  <label className={styles.formLabel}>Note</label>
                  <textarea
                    className={styles.formTextarea}
                    placeholder="Add a note..."
                    value={notes}
                    onChange={e => setNotes(e.target.value)}
                  />
                </div>
              </div>

              <div className={styles.modalActions}>
                <button onClick={() => setShowModal(false)} className={styles.btnSecondary}>
                  Cancel
                </button>
                <button onClick={handleAdd} className={styles.btnPrimary} disabled={!isFormValid}>
                  Create Counterparty
                </button>
              </div>
            </div>
          </div>
        )}

        {showDeleteModal && (
          <div className={styles.modal} onClick={() => setShowDeleteModal(false)}>
            <div className={styles.modalContent} onClick={e => e.stopPropagation()}>
              <div className={styles.modalHeader}>
                <h2 className={styles.modalTitle}>Delete Counterparty</h2>
              </div>
              <div className={styles.confirmIcon}>
                <svg width="40" height="40" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M12,2C17.53,2 22,6.47 22,12C22,17.53 17.53,22 12,22C6.47,22 2,17.53 2,12C2,6.47 6.47,2 12,2M15.59,7L12,10.59L8.41,7L7,8.41L10.59,12L7,15.59L8.41,17L12,13.41L15.59,17L17,15.59L13.41,12L17,8.41L15.59,7Z" />
                </svg>
              </div>
              <div className={styles.confirmMessage}>
                <p className={styles.confirmText}>Are you sure you want to delete this counterparty?</p>
                <p className={styles.confirmSubtext}>This action cannot be undone.</p>
              </div>
              <div className={styles.modalActions}>
                <button onClick={() => setShowDeleteModal(false)} className={styles.btnSecondary}>
                  Cancel
                </button>
                <button onClick={confirmDelete} className={styles.btnDanger}>
                  Delete
                </button>
              </div>
            </div>
          </div>
        )}

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
    </>
  );
};
