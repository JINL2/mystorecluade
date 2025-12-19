/**
 * OrderSelectionSection Component
 * Order selection section for shipment creation
 */

import React from 'react';
import { TossSelector } from '@/shared/components/selectors/TossSelector';
import type { OrderSelectionSectionProps } from './SelectionSection.types';
import styles from './SelectionSection.module.css';

export const OrderSelectionSection: React.FC<OrderSelectionSectionProps> = ({
  selectionMode,
  ordersLoading,
  orderOptions,
  selectedOrder,
  onOrderChange,
}) => {
  return (
    <div className={`${styles.selectionSection} ${selectionMode === 'order' ? styles.active : ''} ${selectionMode === 'supplier' ? styles.disabled : ''}`}>
      <div className={styles.sectionHeader}>
        <div className={styles.sectionTitleWithBadge}>
          <h2 className={styles.sectionTitle}>
            <span className={styles.sectionNumber}>2</span>
            Select Order
          </h2>
          <span className={styles.orBadge}>Option A</span>
        </div>
        {selectionMode === 'order' && (
          <div className={styles.selectionActions}>
            <div className={styles.selectionIndicator}>
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                <polyline points="20 6 9 17 4 12" />
              </svg>
              Selected
            </div>
            <button
              className={styles.clearSelectionButton}
              onClick={() => onOrderChange(null)}
              title="Clear selection"
            >
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                <line x1="18" y1="6" x2="6" y2="18" />
                <line x1="6" y1="6" x2="18" y2="18" />
              </svg>
            </button>
          </div>
        )}
      </div>
      <div className={styles.sectionContent}>
        <div className={styles.selectGroup}>
          <label className={styles.label}>
            Order <span className={styles.required}>*</span>
          </label>
          <TossSelector
            placeholder={ordersLoading ? 'Loading orders...' : 'Select an order'}
            value={selectedOrder ?? undefined}
            options={orderOptions}
            onChange={(value) => onOrderChange(value || null)}
            searchable
            fullWidth
            disabled={ordersLoading || selectionMode === 'supplier'}
          />
        </div>
      </div>
    </div>
  );
};

export default OrderSelectionSection;
