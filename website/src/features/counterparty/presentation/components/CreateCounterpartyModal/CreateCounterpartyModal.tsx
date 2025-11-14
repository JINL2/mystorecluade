/**
 * CreateCounterpartyModal Component
 * Modal for creating new counterparty
 */

import React from 'react';
import { TossSelector } from '@/shared/components/selectors/TossSelector';
import { useCounterparty } from '../../hooks/useCounterparty';
import type { CreateCounterpartyModalProps } from './CreateCounterpartyModal.types';
import styles from './CreateCounterpartyModal.module.css';

const TYPE_OPTIONS = [
  { value: 'My Company', label: 'My Company' },
  { value: 'Team Member', label: 'Team Member' },
  { value: 'Suppliers', label: 'Suppliers' },
  { value: 'Employees', label: 'Employees' },
  { value: 'Customers', label: 'Customers' },
  { value: 'Others', label: 'Others' },
];

export const CreateCounterpartyModal: React.FC<CreateCounterpartyModalProps> = ({
  isOpen,
  onClose,
  onSubmit,
  companyOptions,
}) => {
  const { formData, isFormValid, updateFormField, setFormData } = useCounterparty();

  if (!isOpen) return null;

  const handleSubmit = async () => {
    await onSubmit();
  };

  return (
    <div className={styles.modal} onClick={onClose}>
      <div className={styles.modalContent} onClick={(e) => e.stopPropagation()}>
        <div className={styles.modalHeader}>
          <h2 className={styles.modalTitle}>Create Counterparty</h2>
          <button onClick={onClose} className={styles.modalClose}>
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
              value={formData.name}
              onChange={(e) => updateFormField('name', e.target.value)}
            />
          </div>

          <div className={styles.formGroup}>
            <label className={styles.formLabel}>Organization Type</label>
            <div className={styles.selectionGroup}>
              <div
                className={`${styles.selectionBox} ${!formData.isInternal ? styles.active : ''}`}
                onClick={() => {
                  setFormData({ isInternal: false, linkedCompanyId: null });
                }}
              >
                External Partner
              </div>
              <div
                className={`${styles.selectionBox} ${formData.isInternal ? styles.active : ''}`}
                onClick={() => updateFormField('isInternal', true)}
              >
                Internal Organization
              </div>
            </div>
          </div>

          {formData.isInternal && (
            <div className={styles.formGroup}>
              <TossSelector
                label="Choose Counter Party Company"
                placeholder="Select company..."
                value={formData.linkedCompanyId || ''}
                options={companyOptions}
                onChange={(value) => updateFormField('linkedCompanyId', value)}
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
              value={formData.type}
              options={TYPE_OPTIONS}
              onChange={(value) => updateFormField('type', value as any)}
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
              value={formData.email}
              onChange={(e) => updateFormField('email', e.target.value)}
            />
          </div>

          <div className={styles.formGroup}>
            <label className={styles.formLabel}>Phone Number</label>
            <input
              type="tel"
              className={styles.formInput}
              placeholder="Enter phone number"
              value={formData.phone}
              onChange={(e) => updateFormField('phone', e.target.value)}
            />
          </div>

          <div className={styles.formGroup}>
            <label className={styles.formLabel}>Note</label>
            <textarea
              className={styles.formTextarea}
              placeholder="Add a note..."
              value={formData.notes}
              onChange={(e) => updateFormField('notes', e.target.value)}
            />
          </div>
        </div>

        <div className={styles.modalActions}>
          <button onClick={onClose} className={styles.btnSecondary}>
            Cancel
          </button>
          <button onClick={handleSubmit} className={styles.btnPrimary} disabled={!isFormValid}>
            Create Counterparty
          </button>
        </div>
      </div>
    </div>
  );
};
