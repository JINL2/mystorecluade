/**
 * DeleteConfirmModal Component
 * Confirmation modal for deleting counterparty
 */

import React from 'react';
import type { DeleteConfirmModalProps } from './DeleteConfirmModal.types';
import styles from './DeleteConfirmModal.module.css';

export const DeleteConfirmModal: React.FC<DeleteConfirmModalProps> = ({
  isOpen,
  onClose,
  onConfirm,
}) => {
  if (!isOpen) return null;

  const handleConfirm = async () => {
    await onConfirm();
  };

  return (
    <div className={styles.modal} onClick={onClose}>
      <div className={styles.modalContent} onClick={(e) => e.stopPropagation()}>
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
          <button onClick={onClose} className={styles.btnSecondary}>
            Cancel
          </button>
          <button onClick={handleConfirm} className={styles.btnDanger}>
            Delete
          </button>
        </div>
      </div>
    </div>
  );
};
