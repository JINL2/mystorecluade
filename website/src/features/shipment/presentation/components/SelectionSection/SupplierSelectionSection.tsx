/**
 * SupplierSelectionSection Component
 * Supplier selection section for shipment creation (existing or one-time)
 */

import React from 'react';
import { TossSelector } from '@/shared/components/selectors/TossSelector';
import type { SupplierSelectionSectionProps } from './SelectionSection.types';
import styles from './SelectionSection.module.css';

export const SupplierSelectionSection: React.FC<SupplierSelectionSectionProps> = ({
  selectionMode,
  suppliersLoading,
  supplierOptions,
  selectedSupplier,
  supplierType,
  onSupplierTypeChange,
  onSupplierSectionChange,
  onClearSupplierSelection,
  oneTimeSupplier,
  onOneTimeSupplierChange,
}) => {
  return (
    <div className={`${styles.selectionSection} ${selectionMode === 'supplier' ? styles.active : ''} ${selectionMode === 'order' ? styles.disabled : ''}`}>
      <div className={styles.sectionHeader}>
        <div className={styles.sectionTitleWithBadge}>
          <h2 className={styles.sectionTitle}>
            <span className={styles.sectionNumber}>1</span>
            Select Supplier
          </h2>
          <span className={styles.orBadge}>Option B</span>
        </div>
        {selectionMode === 'supplier' && (
          <div className={styles.selectionActions}>
            <div className={styles.selectionIndicator}>
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                <polyline points="20 6 9 17 4 12" />
              </svg>
              Selected
            </div>
            <button
              className={styles.clearSelectionButton}
              onClick={onClearSupplierSelection}
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
        {/* Supplier Type Toggle */}
        <div className={styles.supplierTypeToggle}>
          <button
            className={`${styles.toggleButton} ${supplierType === 'existing' ? styles.active : ''}`}
            onClick={() => onSupplierTypeChange('existing')}
            disabled={selectionMode === 'order'}
          >
            Select Existing Supplier
          </button>
          <button
            className={`${styles.toggleButton} ${supplierType === 'onetime' ? styles.active : ''}`}
            onClick={() => onSupplierTypeChange('onetime')}
            disabled={selectionMode === 'order'}
          >
            One-time Supplier
          </button>
        </div>

        {supplierType === 'existing' ? (
          <div className={styles.existingSupplier}>
            <TossSelector
              placeholder={suppliersLoading ? 'Loading suppliers...' : 'Select a supplier'}
              value={selectionMode === 'supplier' ? selectedSupplier ?? undefined : undefined}
              options={supplierOptions}
              onChange={(value) => onSupplierSectionChange(value || null)}
              searchable
              fullWidth
              disabled={suppliersLoading || selectionMode === 'order'}
              showDescriptions
            />
          </div>
        ) : (
          <div className={styles.oneTimeSupplier}>
            <div className={styles.formGroup}>
              <label className={styles.label}>
                Supplier Name <span className={styles.required}>*</span>
              </label>
              <input
                type="text"
                className={styles.input}
                placeholder="Enter supplier name"
                value={oneTimeSupplier.name}
                onChange={(e) => onOneTimeSupplierChange('name', e.target.value)}
                disabled={selectionMode === 'order'}
              />
            </div>
            <div className={styles.formRow}>
              <div className={styles.formGroup}>
                <label className={styles.label}>Phone</label>
                <input
                  type="tel"
                  className={styles.input}
                  placeholder="Enter phone number"
                  value={oneTimeSupplier.phone}
                  onChange={(e) => onOneTimeSupplierChange('phone', e.target.value)}
                  disabled={selectionMode === 'order'}
                />
              </div>
              <div className={styles.formGroup}>
                <label className={styles.label}>Email</label>
                <input
                  type="email"
                  className={styles.input}
                  placeholder="Enter email address"
                  value={oneTimeSupplier.email}
                  onChange={(e) => onOneTimeSupplierChange('email', e.target.value)}
                  disabled={selectionMode === 'order'}
                />
              </div>
            </div>
            <div className={styles.formGroup}>
              <label className={styles.label}>Address</label>
              <input
                type="text"
                className={styles.input}
                placeholder="Enter address"
                value={oneTimeSupplier.address}
                onChange={(e) => onOneTimeSupplierChange('address', e.target.value)}
                disabled={selectionMode === 'order'}
              />
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default SupplierSelectionSection;
