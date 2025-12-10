/**
 * FinalChoiceModal Component
 * Modal for selecting partial or complete receiving
 */

import React from 'react';
import styles from './FinalChoiceModal.module.css';

interface FinalChoiceModalProps {
  isOpen: boolean;
  isSubmitting: boolean;
  submitError: string | null;
  submitSuccess: boolean;
  onClose: () => void;
  onSubmit: (isFinal: boolean) => void;
}

export const FinalChoiceModal: React.FC<FinalChoiceModalProps> = ({
  isOpen,
  isSubmitting,
  submitError,
  submitSuccess,
  onClose,
  onSubmit,
}) => {
  if (!isOpen) return null;

  return (
    <div className={styles.finalChoiceOverlay} onClick={onClose}>
      <div className={styles.finalChoiceModalContainer} onClick={(e) => e.stopPropagation()}>
        {/* Modal Header */}
        <div className={styles.finalChoiceHeader}>
          <div className={styles.finalChoiceIcon}>
            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <circle cx="12" cy="12" r="10" />
              <path d="M12 8v4M12 16h.01" />
            </svg>
          </div>
          <h2 className={styles.finalChoiceTitle}>Shipment Completion Status</h2>
          <button className={styles.finalChoiceCloseBtn} onClick={onClose} disabled={isSubmitting}>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M18 6L6 18M6 6l12 12" />
            </svg>
          </button>
        </div>

        {/* Modal Body */}
        <div className={styles.finalChoiceBody}>
          {submitError && (
            <div className={styles.finalChoiceError}>
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                <circle cx="12" cy="12" r="10" />
                <path d="M15 9l-6 6M9 9l6 6" />
              </svg>
              {submitError}
            </div>
          )}

          {submitSuccess ? (
            <div className={styles.finalChoiceSuccess}>
              <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#10B981" strokeWidth="2">
                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
                <polyline points="22 4 12 14.01 9 11.01" />
              </svg>
              <p>Session submitted successfully!</p>
              <span>Redirecting...</span>
            </div>
          ) : (
            <>
              <p className={styles.finalChoiceQuestion}>
                Have all items from this shipment been received?
              </p>

              <div className={styles.finalChoiceOptions}>
                {/* Partial Receiving Option */}
                <button
                  className={styles.finalChoiceOption}
                  onClick={() => onSubmit(false)}
                  disabled={isSubmitting}
                >
                  <div className={styles.optionIconWrapper} style={{ background: '#FEF3C7' }}>
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#D97706" strokeWidth="2">
                      <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
                      <polyline points="3.27 6.96 12 12.01 20.73 6.96" />
                      <line x1="12" y1="22.08" x2="12" y2="12" />
                    </svg>
                  </div>
                  <div className={styles.optionContent}>
                    <span className={styles.optionTitle}>Partial Receiving</span>
                    <span className={styles.optionDesc}>More items will arrive later</span>
                  </div>
                  {isSubmitting && (
                    <div className={styles.optionSpinner} />
                  )}
                </button>

                {/* Complete Receiving Option */}
                <button
                  className={`${styles.finalChoiceOption} ${styles.finalChoiceOptionComplete}`}
                  onClick={() => onSubmit(true)}
                  disabled={isSubmitting}
                >
                  <div className={styles.optionIconWrapper} style={{ background: '#DCFCE7' }}>
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#16A34A" strokeWidth="2">
                      <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
                      <polyline points="22 4 12 14.01 9 11.01" />
                    </svg>
                  </div>
                  <div className={styles.optionContent}>
                    <span className={styles.optionTitle}>Complete Receiving</span>
                    <span className={styles.optionDesc}>All items have been received</span>
                  </div>
                  {isSubmitting && (
                    <div className={styles.optionSpinner} />
                  )}
                </button>
              </div>

              <p className={styles.finalChoiceNote}>
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <circle cx="12" cy="12" r="10" />
                  <path d="M12 16v-4M12 8h.01" />
                </svg>
                Once submitted, the session will be closed and inventory will be updated.
              </p>
            </>
          )}
        </div>
      </div>
    </div>
  );
};
