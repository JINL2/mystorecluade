/**
 * NeedsDisplayModal Component
 * Modal showing products that need to be displayed after receiving
 */

import React from 'react';
import styles from './NeedsDisplayModal.module.css';

interface NeedsDisplayItem {
  productId: string;
  variantId: string | null;
  sku: string;
  productName: string;
  variantName: string | null;
  displayName: string;
  quantityReceived: number;
}

interface SubmitResultData {
  receivingNumber?: string;
  itemsCount?: number;
  totalQuantity?: number;
}

interface NeedsDisplayModalProps {
  isOpen: boolean;
  items: NeedsDisplayItem[];
  submitResultData: SubmitResultData | null;
  onClose: () => void;
}

export const NeedsDisplayModal: React.FC<NeedsDisplayModalProps> = ({
  isOpen,
  items,
  submitResultData,
  onClose,
}) => {
  if (!isOpen || items.length === 0) return null;

  return (
    <div className={styles.modalBackdrop}>
      <div className={styles.needsDisplayModal}>
        <div className={styles.needsDisplayHeader}>
          <h3>New Products Need Display</h3>
          <p className={styles.needsDisplaySubtext}>
            {items.length} product{items.length > 1 ? 's' : ''} had zero stock. Please display on shelf.
          </p>
        </div>
        <div className={styles.needsDisplayContent}>
          <table className={styles.needsDisplayTable}>
            <thead>
              <tr>
                <th>SKU</th>
                <th>Product</th>
                <th className={styles.thNumber}>Qty</th>
              </tr>
            </thead>
            <tbody>
              {items.map((item) => (
                <tr key={`${item.productId}-${item.variantId || 'base'}`}>
                  <td className={styles.needsDisplaySku}>{item.sku}</td>
                  <td className={styles.needsDisplayProduct}>{item.displayName}</td>
                  <td className={styles.needsDisplayQuantity}>
                    <span className={styles.quantityBadge}>{item.quantityReceived}</span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        {submitResultData && (
          <div className={styles.needsDisplaySummary}>
            <div className={styles.summaryItem}>
              <span className={styles.summaryLabel}>Receiving #</span>
              <span className={styles.summaryValue}>{submitResultData.receivingNumber}</span>
            </div>
            <div className={styles.summaryItem}>
              <span className={styles.summaryLabel}>Items</span>
              <span className={styles.summaryValue}>{submitResultData.itemsCount}</span>
            </div>
            <div className={styles.summaryItem}>
              <span className={styles.summaryLabel}>Total Qty</span>
              <span className={styles.summaryValue}>{submitResultData.totalQuantity}</span>
            </div>
          </div>
        )}
        <div className={styles.needsDisplayActions}>
          <button
            className={styles.needsDisplayConfirmButton}
            onClick={onClose}
          >
            OK
          </button>
        </div>
      </div>
    </div>
  );
};

export default NeedsDisplayModal;
