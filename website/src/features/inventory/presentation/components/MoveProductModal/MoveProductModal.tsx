/**
 * MoveProductModal Component
 * Modal for moving products between stores
 */

import React, { useState, useEffect } from 'react';
import { TossButton } from '@/shared/components/toss/TossButton';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';
import { useAppState } from '@/app/providers/app_state_provider';
import type { MoveProductModalProps } from './MoveProductModal.types';
import styles from './MoveProductModal.module.css';

export const MoveProductModal: React.FC<MoveProductModalProps> = ({
  isOpen,
  onClose,
  productId,
  productName,
  currentStock,
  sourceStoreId,
  companyId,
  onMove,
}) => {
  const { currentCompany } = useAppState();
  const [selectedTargetStoreId, setSelectedTargetStoreId] = useState<string | null>(null);
  const [moveQuantity, setMoveQuantity] = useState<string>('');
  const [notes, setNotes] = useState<string>('');

  // Reset form when modal opens
  useEffect(() => {
    if (isOpen) {
      setSelectedTargetStoreId(null);
      setMoveQuantity('');
      setNotes('');
    }
  }, [isOpen]);

  if (!isOpen) return null;

  // Get available stores (exclude source store)
  const availableStores = currentCompany?.stores?.filter(
    (store) => store.store_id !== sourceStoreId
  ) || [];

  const handleQuantityChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const value = e.target.value;
    // Only allow positive numbers
    if (value === '' || /^\d+$/.test(value)) {
      setMoveQuantity(value);
    }
  };

  const handleMove = async () => {
    if (!selectedTargetStoreId || !moveQuantity || !onMove) return;

    const quantity = parseInt(moveQuantity, 10);
    if (isNaN(quantity) || quantity <= 0) return;

    await onMove(selectedTargetStoreId, quantity, notes);
    onClose();
  };

  const isValidQuantity = moveQuantity !== '' && parseInt(moveQuantity, 10) > 0;
  const afterStock = moveQuantity !== '' ? currentStock - parseInt(moveQuantity, 10) : currentStock;
  const isNegativeStock = afterStock < 0;

  return (
    <div className={styles.modalOverlay} onClick={onClose}>
      <div className={styles.modalContent} onClick={(e) => e.stopPropagation()}>
        {/* Header */}
        <div className={styles.modalHeader}>
          <h2 className={styles.modalTitle}>Move Product</h2>
          <button className={styles.closeButton} onClick={onClose}>
            <svg width="24" height="24" fill="currentColor" viewBox="0 0 24 24">
              <path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z" />
            </svg>
          </button>
        </div>

        {/* Body */}
        <div className={styles.modalBody}>
          {/* Product Info */}
          <div className={styles.productInfo}>
            <div className={styles.infoRow}>
              <span className={styles.infoLabel}>Product:</span>
              <span className={styles.infoValue}>{productName}</span>
            </div>
            <div className={styles.infoRow}>
              <span className={styles.infoLabel}>Current Stock:</span>
              <span className={styles.infoValue}>{currentStock}</span>
            </div>
          </div>

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

          {/* Move Quantity */}
          <div className={styles.formGroup}>
            <label className={styles.formLabel}>Move Quantity</label>
            <input
              type="text"
              inputMode="numeric"
              className={styles.quantityInput}
              value={moveQuantity}
              onChange={handleQuantityChange}
              placeholder="Enter quantity"
            />
            {moveQuantity !== '' && (
              <div className={`${styles.afterStockText} ${isNegativeStock ? styles.negativeStock : ''}`}>
                After Stock: {afterStock}
              </div>
            )}
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
            disabled={!selectedTargetStoreId || !isValidQuantity}
          >
            Move
          </TossButton>
        </div>
      </div>
    </div>
  );
};
