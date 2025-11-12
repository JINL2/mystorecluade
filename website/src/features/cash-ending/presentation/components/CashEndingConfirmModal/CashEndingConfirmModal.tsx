/**
 * CashEndingConfirmModal Component
 * Confirmation modal for Make Error and Foreign Currency Translation
 */

import React from 'react';
import { formatCurrencyVND } from '@/core/utils/formatters';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import styles from './CashEndingConfirmModal.module.css';
import type { CashEndingConfirmModalProps } from './CashEndingConfirmModal.types';

export const CashEndingConfirmModal: React.FC<CashEndingConfirmModalProps> = ({
  isOpen,
  onClose,
  onConfirm,
  title,
  locationName,
  variance,
  type,
  isLoading = false,
}) => {
  if (!isOpen) return null;

  const handleBackdropClick = (e: React.MouseEvent<HTMLDivElement>) => {
    if (e.target === e.currentTarget && !isLoading) {
      onClose();
    }
  };

  const handleConfirm = () => {
    if (!isLoading) {
      onConfirm();
    }
  };

  const handleCancel = () => {
    if (!isLoading) {
      onClose();
    }
  };

  return (
    <div className={styles.modalOverlay} onClick={handleBackdropClick}>
      <div className={styles.modalContainer}>
        {/* Modal Header */}
        <div className={styles.modalHeader}>
          <div className={styles.headerIcon}>
            {type === 'error' ? (
              <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                <path d="M12,2L1,21H23M12,6L19.53,19H4.47M11,10V14H13V10M11,16V18H13V16" />
              </svg>
            ) : (
              <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                <path d="M12,2A7,7 0 0,1 19,9C19,11.38 17.81,13.47 16,14.74V17A1,1 0 0,1 15,18H9A1,1 0 0,1 8,17V14.74C6.19,13.47 5,11.38 5,9A7,7 0 0,1 12,2M9,21V20H15V21A1,1 0 0,1 14,22H10A1,1 0 0,1 9,21M12,4A5,5 0 0,0 7,9C7,11.05 8.23,12.81 10,13.58V16H14V13.58C15.77,12.81 17,11.05 17,9A5,5 0 0,0 12,4Z" />
              </svg>
            )}
          </div>
          <div className={styles.headerContent}>
            <h2 className={styles.modalTitle}>{title}</h2>
          </div>
        </div>

        {/* Modal Body */}
        <div className={styles.modalBody}>
          <div className={styles.warningSection}>
            <div className={styles.warningIcon}>⚠️</div>
            <div className={styles.warningContent}>
              <div className={styles.warningText}>
                Are you sure you want to create this journal entry?
              </div>
            </div>
          </div>

          <div className={styles.infoSection}>
            <div className={styles.infoRow}>
              <span className={styles.infoLabel}>Location:</span>
              <span className={styles.infoValue}>{locationName}</span>
            </div>
            <div className={styles.infoRow}>
              <span className={styles.infoLabel}>Variance:</span>
              <span className={`${styles.infoValue} ${styles.varianceAmount}`}>
                {formatCurrencyVND(Math.abs(variance))}
              </span>
            </div>
          </div>
        </div>

        {/* Modal Footer */}
        <div className={styles.modalFooter}>
          <button
            className={styles.cancelButton}
            onClick={handleCancel}
            disabled={isLoading}
          >
            Cancel
          </button>
          <button
            className={styles.confirmButton}
            onClick={handleConfirm}
            disabled={isLoading}
          >
            {isLoading ? (
              <LoadingAnimation size="small" />
            ) : (
              <>
                <svg width="20" height="20" viewBox="0 0 24 24" fill="white">
                  <path d="M9,20.42L2.79,14.21L5.62,11.38L9,14.77L18.88,4.88L21.71,7.71L9,20.42Z" />
                </svg>
                OK
              </>
            )}
          </button>
        </div>
      </div>
    </div>
  );
};

export default CashEndingConfirmModal;
