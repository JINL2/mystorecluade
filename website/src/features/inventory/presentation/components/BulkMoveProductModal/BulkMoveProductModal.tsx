/**
 * BulkMoveProductModal Component
 * Modal for moving multiple selected products between stores
 */

import React, { useState, useEffect } from 'react';
import { TossButton } from '@/shared/components/toss/TossButton';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';
import { useAppState } from '@/app/providers/app_state_provider';
import type { BulkMoveProductModalProps } from './BulkMoveProductModal.types';
import styles from './BulkMoveProductModal.module.css';

export const BulkMoveProductModal: React.FC<BulkMoveProductModalProps> = ({
  isOpen,
  onClose,
  products,
  sourceStoreId,
  companyId,
  onMove,
}) => {
  const { currentCompany } = useAppState();
  const [selectedTargetStoreId, setSelectedTargetStoreId] = useState<string | null>(null);
  const [quantities, setQuantities] = useState<Record<string, string>>({});
  const [notes, setNotes] = useState<string>('');

  // Reset form when modal opens
  useEffect(() => {
    if (isOpen) {
      setSelectedTargetStoreId(null);
      setNotes('');

      // Initialize all quantities to 1
      const initialQuantities: Record<string, string> = {};
      products.forEach(product => {
        initialQuantities[product.productId] = '1';
      });
      setQuantities(initialQuantities);
    }
  }, [isOpen, products]);

  if (!isOpen) return null;

  // Get available stores (exclude source store)
  const availableStores = currentCompany?.stores?.filter(
    (store) => store.store_id !== sourceStoreId
  ) || [];

  const handleQuantityChange = (productId: string, value: string) => {
    // Only allow positive numbers
    if (value === '' || /^\d+$/.test(value)) {
      setQuantities(prev => ({
        ...prev,
        [productId]: value
      }));
    }
  };

  const handleMove = async () => {
    if (!selectedTargetStoreId || !onMove) return;

    // Build items array with quantities
    const items = products
      .map(product => {
        const quantity = parseInt(quantities[product.productId] || '1', 10);
        if (isNaN(quantity) || quantity <= 0) return null;
        return {
          productId: product.productId,
          quantity
        };
      })
      .filter((item): item is { productId: string; quantity: number } => item !== null);

    if (items.length === 0) return;

    await onMove(selectedTargetStoreId, items, notes);
    onClose();
  };

  const isValidMove = selectedTargetStoreId && products.every(product => {
    const qty = quantities[product.productId];
    return qty && parseInt(qty, 10) > 0;
  });

  return (
    <div className={styles.modalOverlay} onClick={onClose}>
      <div className={styles.modalContent} onClick={(e) => e.stopPropagation()}>
        {/* Header */}
        <div className={styles.modalHeader}>
          <h2 className={styles.modalTitle}>Move Products</h2>
          <button className={styles.closeButton} onClick={onClose}>
            <svg width="24" height="24" fill="currentColor" viewBox="0 0 24 24">
              <path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z" />
            </svg>
          </button>
        </div>

        {/* Body */}
        <div className={styles.modalBody}>
          {/* Store Selection */}
          <div className={styles.formGroup}>
            <label className={styles.formLabel}>To Store</label>
            <StoreSelector
              stores={availableStores}
              selectedStoreId={selectedTargetStoreId}
              onStoreSelect={setSelectedTargetStoreId}
              companyId={companyId}
              showAllStoresOption={false}
              allStoresLabel="Select"
              width="100%"
            />
          </div>

          {/* Products List */}
          <div className={styles.formGroup}>
            <label className={styles.formLabel}>Products ({products.length})</label>
            <div className={styles.productsList}>
              {products.map(product => (
                <div key={product.productId} className={styles.productItem}>
                  <div className={styles.productInfo}>
                    <span className={styles.productName}>{product.productName}</span>
                    <span className={styles.productCode}>{product.productCode}</span>
                  </div>
                  <input
                    type="text"
                    inputMode="numeric"
                    className={styles.quantityInput}
                    value={quantities[product.productId] || '1'}
                    onChange={(e) => handleQuantityChange(product.productId, e.target.value)}
                    placeholder="Qty"
                  />
                </div>
              ))}
            </div>
          </div>

          {/* Notes */}
          <div className={styles.formGroup}>
            <label className={styles.formLabel}>Notes</label>
            <textarea
              className={styles.notesInput}
              value={notes}
              onChange={(e) => setNotes(e.target.value)}
              placeholder="Add notes (optional)"
              rows={3}
            />
          </div>
        </div>

        {/* Footer */}
        <div className={styles.modalFooter}>
          <TossButton
            variant="outline"
            size="md"
            onClick={onClose}
          >
            Cancel
          </TossButton>
          <TossButton
            variant="primary"
            size="md"
            onClick={handleMove}
            disabled={!isValidMove}
          >
            Move
          </TossButton>
        </div>
      </div>
    </div>
  );
};
