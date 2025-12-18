/**
 * MoveProductModal Component
 * Modal for moving products between stores
 */

import React, { useState, useEffect, useRef } from 'react';
import { TossButton } from '@/shared/components/toss/TossButton';
import { useAppState } from '@/app/providers/app_state_provider';
import { supabaseService } from '@/core/services/supabase_service';
import type { MoveProductModalProps } from './MoveProductModal.types';
import styles from './MoveProductModal.module.css';

// Store stock info type
interface StoreStockInfo {
  store_id: string;
  store_name: string;
  store_code: string;
  quantity_on_hand: number;
  quantity_available: number;
  quantity_reserved: number;
}

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
  const { currentCompany, currentStore } = useAppState();
  const [selectedSourceStoreId, setSelectedSourceStoreId] = useState<string | null>(null);
  const [selectedTargetStoreId, setSelectedTargetStoreId] = useState<string | null>(null);
  const [moveQuantity, setMoveQuantity] = useState<string>('');
  const [notes, setNotes] = useState<string>('');

  // Stock info state
  const [storeStockInfo, setStoreStockInfo] = useState<StoreStockInfo[]>([]);
  const [isLoadingStock, setIsLoadingStock] = useState(false);

  // Dropdown states
  const [isFromDropdownOpen, setIsFromDropdownOpen] = useState(false);
  const [isToDropdownOpen, setIsToDropdownOpen] = useState(false);
  const fromDropdownRef = useRef<HTMLDivElement>(null);
  const toDropdownRef = useRef<HTMLDivElement>(null);

  // Fetch stock info when modal opens
  useEffect(() => {
    const fetchStockInfo = async () => {
      if (!isOpen || !productId || !companyId) return;

      setIsLoadingStock(true);
      try {
        console.log('🔍 Fetching stock info for product:', productId);
        const { data, error } = await supabaseService.rpc('inventory_product_stock_stores', {
          p_company_id: companyId,
          p_product_ids: [productId]
        });

        console.log('📦 RPC Response:', JSON.stringify(data, null, 2));
        console.log('❌ RPC Error:', error);

        if (error) {
          console.error('Failed to fetch stock info:', error);
          return;
        }

        // Check different possible response structures
        if (data?.success && data?.data?.products?.[0]?.stores) {
          console.log('✅ Found stores in data.data.products[0].stores');
          setStoreStockInfo(data.data.products[0].stores);
        } else if (data?.products?.[0]?.stores) {
          console.log('✅ Found stores in data.products[0].stores');
          setStoreStockInfo(data.products[0].stores);
        } else if (Array.isArray(data) && data[0]?.stores) {
          console.log('✅ Found stores in data[0].stores');
          setStoreStockInfo(data[0].stores);
        } else {
          console.log('⚠️ Could not find stores in response. Data structure:', typeof data, Object.keys(data || {}));
        }
      } catch (err) {
        console.error('Error fetching stock info:', err);
      } finally {
        setIsLoadingStock(false);
      }
    };

    fetchStockInfo();
  }, [isOpen, productId, companyId]);

  // Reset form when modal opens - set default from store from app state
  useEffect(() => {
    if (isOpen) {
      // Default to current store from app state, fallback to sourceStoreId prop
      setSelectedSourceStoreId(currentStore?.store_id || sourceStoreId);
      setSelectedTargetStoreId(null);
      setMoveQuantity('');
      setNotes('');
      setIsFromDropdownOpen(false);
      setIsToDropdownOpen(false);
    }
  }, [isOpen, currentStore, sourceStoreId]);

  // Close dropdowns when clicking outside
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (fromDropdownRef.current && !fromDropdownRef.current.contains(event.target as Node)) {
        setIsFromDropdownOpen(false);
      }
      if (toDropdownRef.current && !toDropdownRef.current.contains(event.target as Node)) {
        setIsToDropdownOpen(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  if (!isOpen) return null;

  // Get stock for a specific store
  const getStoreStock = (storeId: string): number => {
    const stockInfo = storeStockInfo.find(s => s.store_id === storeId);
    return stockInfo?.quantity_on_hand ?? 0;
  };

  // Get stock badge class based on quantity
  const getStockBadgeClass = (stock: number): string => {
    if (stock < 0) return `${styles.stockBadge} ${styles.stockNegative}`;
    if (stock === 0) return `${styles.stockBadge} ${styles.stockZero}`;
    return styles.stockBadge; // positive - blue color
  };

  // All stores for From Store selector (with stock info)
  const allStores = currentCompany?.stores || [];

  // Get available stores for To Store (exclude selected source store)
  const availableStores = currentCompany?.stores?.filter(
    (store) => store.store_id !== selectedSourceStoreId
  ) || [];

  // Get selected source store stock
  const sourceStoreStock = selectedSourceStoreId ? getStoreStock(selectedSourceStoreId) : 0;

  const handleQuantityChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const value = e.target.value;
    // Only allow positive numbers
    if (value === '' || /^\d+$/.test(value)) {
      setMoveQuantity(value);
    }
  };

  const handleSourceStoreChange = (storeId: string | null) => {
    setSelectedSourceStoreId(storeId);
    setIsFromDropdownOpen(false);
    // Reset target store if it's the same as the new source
    if (storeId === selectedTargetStoreId) {
      setSelectedTargetStoreId(null);
    }
  };

  const handleTargetStoreChange = (storeId: string | null) => {
    setSelectedTargetStoreId(storeId);
    setIsToDropdownOpen(false);
  };

  const handleMove = async () => {
    if (!selectedSourceStoreId || !selectedTargetStoreId || !moveQuantity || !onMove) return;

    const quantity = parseInt(moveQuantity, 10);
    if (isNaN(quantity) || quantity <= 0) return;

    await onMove(selectedTargetStoreId, quantity, notes, selectedSourceStoreId);
    onClose();
  };

  // Get selected store names
  const getStoreName = (storeId: string | null): string => {
    if (!storeId) return 'Select';
    const store = allStores.find(s => s.store_id === storeId);
    return store?.store_name || 'Select';
  };

  const isValidQuantity = moveQuantity !== '' && parseInt(moveQuantity, 10) > 0;
  const afterStock = moveQuantity !== '' ? sourceStoreStock - parseInt(moveQuantity, 10) : sourceStoreStock;
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
          </div>

          {/* From Store Selection - Custom Dropdown with Stock */}
          <div className={styles.formGroup}>
            <label className={styles.formLabel}>From Store</label>
            <div className={styles.storeDropdownContainer} ref={fromDropdownRef}>
              <div
                className={`${styles.storeDropdownControl} ${isFromDropdownOpen ? styles.open : ''}`}
                onClick={() => setIsFromDropdownOpen(!isFromDropdownOpen)}
              >
                <svg className={styles.storeIcon} fill="currentColor" viewBox="0 0 24 24">
                  <path d="M10,20V14H14V20H19V12H22L12,3L2,12H5V20H10Z" />
                </svg>
                <span className={styles.storeLabel}>{getStoreName(selectedSourceStoreId)}</span>
                {selectedSourceStoreId && !isLoadingStock && (
                  <span className={getStockBadgeClass(sourceStoreStock)}>
                    {sourceStoreStock}
                  </span>
                )}
                <svg className={styles.dropdownArrow} fill="currentColor" viewBox="0 0 24 24">
                  <path d="M7.41,8.58L12,13.17L16.59,8.58L18,10L12,16L6,10L7.41,8.58Z" />
                </svg>
              </div>
              {isFromDropdownOpen && (
                <div className={styles.storeDropdownList}>
                  {isLoadingStock ? (
                    <div className={styles.loadingText}>Loading stock info...</div>
                  ) : (
                    allStores.map((store) => {
                      const stock = getStoreStock(store.store_id);
                      const isSelected = selectedSourceStoreId === store.store_id;
                      return (
                        <div
                          key={store.store_id}
                          className={`${styles.storeOption} ${isSelected ? styles.selected : ''}`}
                          onClick={() => handleSourceStoreChange(store.store_id)}
                        >
                          <svg className={styles.storeIcon} fill="currentColor" viewBox="0 0 24 24">
                            <path d="M10,20V14H14V20H19V12H22L12,3L2,12H5V20H10Z" />
                          </svg>
                          <span className={styles.storeOptionName}>{store.store_name}</span>
                          <span className={getStockBadgeClass(stock)}>
                            {stock}
                          </span>
                          {isSelected && (
                            <svg className={styles.checkIcon} fill="currentColor" viewBox="0 0 24 24">
                              <path d="M9,20.42L2.79,14.21L5.62,11.38L9,14.77L18.88,4.88L21.71,7.71L9,20.42Z" />
                            </svg>
                          )}
                        </div>
                      );
                    })
                  )}
                </div>
              )}
            </div>
          </div>

          {/* To Store Selection - Custom Dropdown with Stock */}
          <div className={styles.formGroup}>
            <label className={styles.formLabel}>To Store</label>
            <div className={styles.storeDropdownContainer} ref={toDropdownRef}>
              <div
                className={`${styles.storeDropdownControl} ${isToDropdownOpen ? styles.open : ''}`}
                onClick={() => setIsToDropdownOpen(!isToDropdownOpen)}
              >
                <svg className={styles.storeIcon} fill="currentColor" viewBox="0 0 24 24">
                  <path d="M10,20V14H14V20H19V12H22L12,3L2,12H5V20H10Z" />
                </svg>
                <span className={styles.storeLabel}>{getStoreName(selectedTargetStoreId)}</span>
                {selectedTargetStoreId && !isLoadingStock && (
                  <span className={getStockBadgeClass(getStoreStock(selectedTargetStoreId))}>
                    {getStoreStock(selectedTargetStoreId)}
                  </span>
                )}
                <svg className={styles.dropdownArrow} fill="currentColor" viewBox="0 0 24 24">
                  <path d="M7.41,8.58L12,13.17L16.59,8.58L18,10L12,16L6,10L7.41,8.58Z" />
                </svg>
              </div>
              {isToDropdownOpen && (
                <div className={styles.storeDropdownList}>
                  {isLoadingStock ? (
                    <div className={styles.loadingText}>Loading stock info...</div>
                  ) : availableStores.length === 0 ? (
                    <div className={styles.loadingText}>No other stores available</div>
                  ) : (
                    availableStores.map((store) => {
                      const stock = getStoreStock(store.store_id);
                      const isSelected = selectedTargetStoreId === store.store_id;
                      return (
                        <div
                          key={store.store_id}
                          className={`${styles.storeOption} ${isSelected ? styles.selected : ''}`}
                          onClick={() => handleTargetStoreChange(store.store_id)}
                        >
                          <svg className={styles.storeIcon} fill="currentColor" viewBox="0 0 24 24">
                            <path d="M10,20V14H14V20H19V12H22L12,3L2,12H5V20H10Z" />
                          </svg>
                          <span className={styles.storeOptionName}>{store.store_name}</span>
                          <span className={getStockBadgeClass(stock)}>
                            {stock}
                          </span>
                          {isSelected && (
                            <svg className={styles.checkIcon} fill="currentColor" viewBox="0 0 24 24">
                              <path d="M9,20.42L2.79,14.21L5.62,11.38L9,14.77L18.88,4.88L21.71,7.71L9,20.42Z" />
                            </svg>
                          )}
                        </div>
                      );
                    })
                  )}
                </div>
              )}
            </div>
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
