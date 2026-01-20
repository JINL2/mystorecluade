/**
 * SubmitReviewModal Component
 * Modal for reviewing session items before submission
 */

import React from 'react';
import type { SessionItem } from '../../../../domain/entities';
import type { EditableItem } from '../../../providers/states/receiving_session_state';
import styles from './SubmitReviewModal.module.css';

interface SubmitReviewModalProps {
  isOpen: boolean;
  isLoading: boolean;
  submitError: string | null;
  editableItems: EditableItem[];
  sessionItems: SessionItem[];
  editableTotalQuantity: number;
  editableTotalRejected: number;
  onClose: () => void;
  onConfirm: () => void;
  onQuantityChange: (productId: string, variantId: string | null, field: 'quantity' | 'quantityRejected', value: number) => void;
  onFinalSubmit: () => void;
}

export const SubmitReviewModal: React.FC<SubmitReviewModalProps> = ({
  isOpen,
  isLoading,
  submitError,
  editableItems,
  sessionItems,
  editableTotalQuantity,
  editableTotalRejected,
  onClose,
  onConfirm,
  onQuantityChange,
  onFinalSubmit,
}) => {
  if (!isOpen) return null;

  return (
    <div className={styles.reviewModalOverlay} onClick={onClose}>
      <div className={styles.reviewModalContainer} onClick={(e) => e.stopPropagation()}>
        {/* Modal Header */}
        <div className={styles.reviewModalHeader}>
          <div className={styles.reviewModalHeaderIcon}>
            <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
              <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41L9 16.17z" />
            </svg>
          </div>
          <h2 className={styles.reviewModalTitle}>Review Session Items</h2>
          <button className={styles.reviewModalClose} onClick={onClose}>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M18 6L6 18M6 6l12 12" />
            </svg>
          </button>
        </div>

        {/* Modal Body */}
        <div className={styles.reviewModalBody}>
          {isLoading ? (
            <div className={styles.reviewModalLoading}>
              <div className={styles.reviewSpinner} />
              <p>Loading session items...</p>
            </div>
          ) : submitError ? (
            <div className={styles.reviewModalError}>
              <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#DC2626" strokeWidth="1.5">
                <circle cx="12" cy="12" r="10" />
                <path d="M15 9l-6 6M9 9l6 6" />
              </svg>
              <p>{submitError}</p>
              <button className={styles.retryButton} onClick={onConfirm}>
                Retry
              </button>
            </div>
          ) : editableItems.length === 0 ? (
            <div className={styles.reviewModalEmpty}>
              <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="#CBD5E1" strokeWidth="1.5">
                <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
                <polyline points="3.27 6.96 12 12.01 20.73 6.96" />
                <line x1="12" y1="22.08" x2="12" y2="12" />
              </svg>
              <p>No items in session</p>
              <span>Save items before submitting the session</span>
            </div>
          ) : (
            <>
              {/* Summary Section */}
              <div className={styles.reviewSummary}>
                <div className={styles.summaryItem}>
                  <span className={styles.summaryLabel}>Total Products</span>
                  <span className={styles.summaryValue}>{editableItems.length}</span>
                </div>
                <div className={styles.summaryItem}>
                  <span className={styles.summaryLabel}>Total Quantity</span>
                  <span className={styles.summaryValueBlue}>{editableTotalQuantity}</span>
                </div>
                <div className={styles.summaryItem}>
                  <span className={styles.summaryLabel}>Total Rejected</span>
                  <span className={styles.summaryValueRed}>{editableTotalRejected}</span>
                </div>
                <div className={styles.summaryItem}>
                  <span className={styles.summaryLabel}>Net Accepted</span>
                  <span className={styles.summaryValueGreen}>{editableTotalQuantity - editableTotalRejected}</span>
                </div>
              </div>

              {/* Items Table */}
              <div className={styles.reviewItemsContainer}>
                <table className={styles.reviewItemsTable}>
                  <thead>
                    <tr>
                      <th className={styles.thReviewProduct}>Product</th>
                      <th className={styles.thReviewQty}>Quantity</th>
                      <th className={styles.thReviewRejected}>Rejected</th>
                      <th className={styles.thReviewContributors}>Employees</th>
                    </tr>
                  </thead>
                  <tbody>
                    {editableItems.map((item) => {
                      // Match by both productId and variantId to handle variants correctly
                      const originalItem = sessionItems.find(
                        si => si.productId === item.productId && si.variantId === item.variantId
                      );
                      // Use displayName from sessionItems (includes variant name) or fallback to productName
                      const displayName = originalItem?.displayName || item.productName;
                      return (
                        <tr key={`${item.productId}-${item.variantId || 'base'}`}>
                          <td className={styles.tdReviewProduct}>
                            <span className={styles.reviewProductName}>{displayName}</span>
                          </td>
                          <td className={styles.tdReviewQty}>
                            <div className={styles.reviewQtyControl}>
                              <button
                                className={styles.reviewQtyButton}
                                onClick={() => onQuantityChange(item.productId, item.variantId, 'quantity', item.quantity - 1)}
                              >
                                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                  <path d="M5 12h14" />
                                </svg>
                              </button>
                              <input
                                type="number"
                                className={styles.reviewQtyInput}
                                value={item.quantity}
                                min="0"
                                onChange={(e) => onQuantityChange(item.productId, item.variantId, 'quantity', parseInt(e.target.value) || 0)}
                              />
                              <button
                                className={styles.reviewQtyButton}
                                onClick={() => onQuantityChange(item.productId, item.variantId, 'quantity', item.quantity + 1)}
                              >
                                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                  <path d="M12 5v14M5 12h14" />
                                </svg>
                              </button>
                            </div>
                          </td>
                          <td className={styles.tdReviewRejected}>
                            <div className={styles.reviewQtyControl}>
                              <button
                                className={styles.reviewQtyButton}
                                onClick={() => onQuantityChange(item.productId, item.variantId, 'quantityRejected', item.quantityRejected - 1)}
                              >
                                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                  <path d="M5 12h14" />
                                </svg>
                              </button>
                              <input
                                type="number"
                                className={styles.reviewQtyInputRed}
                                value={item.quantityRejected}
                                min="0"
                                onChange={(e) => onQuantityChange(item.productId, item.variantId, 'quantityRejected', parseInt(e.target.value) || 0)}
                              />
                              <button
                                className={styles.reviewQtyButton}
                                onClick={() => onQuantityChange(item.productId, item.variantId, 'quantityRejected', item.quantityRejected + 1)}
                              >
                                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                  <path d="M12 5v14M5 12h14" />
                                </svg>
                              </button>
                            </div>
                          </td>
                          <td className={styles.tdReviewContributors}>
                            {originalItem?.scannedBy && originalItem.scannedBy.length > 0 ? (
                              <div className={styles.employeesList}>
                                {originalItem.scannedBy.map((user) => (
                                  <div key={user.userId} className={styles.employeeRow}>
                                    <span className={styles.employeeName}>{user.userName}</span>
                                    <div className={styles.employeeCounts}>
                                      <span className={styles.employeeAccepted}>{user.quantity}</span>
                                      {user.quantityRejected > 0 && (
                                        <span className={styles.employeeRejected}>{user.quantityRejected}</span>
                                      )}
                                    </div>
                                  </div>
                                ))}
                              </div>
                            ) : (
                              <span className={styles.noContributors}>-</span>
                            )}
                          </td>
                        </tr>
                      );
                    })}
                  </tbody>
                </table>
              </div>
            </>
          )}
        </div>

        {/* Modal Footer */}
        <div className={styles.reviewModalFooter}>
          <button className={styles.reviewCancelButton} onClick={onClose}>
            Cancel
          </button>
          <button
            className={styles.reviewSubmitButton}
            onClick={onFinalSubmit}
            disabled={editableItems.length === 0 || isLoading}
          >
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M22 2L11 13" />
              <path d="M22 2l-7 20-4-9-9-4 20-7z" />
            </svg>
            Submit Session
          </button>
        </div>
      </div>
    </div>
  );
};
