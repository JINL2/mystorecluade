/**
 * BulkMoveProductModal Component
 * Modal for moving multiple selected products between stores
 */

import React, { useState, useEffect, useRef } from 'react';
import { TossButton } from '@/shared/components/toss/TossButton';
import { useAppState } from '@/app/providers/app_state_provider';
import { supabaseService } from '@/core/services/supabase_service';
import type { BulkMoveProductModalProps } from './BulkMoveProductModal.types';
import styles from './BulkMoveProductModal.module.css';

// Store stock info type
interface StoreStockInfo {
  store_id: string;
  store_name: string;
  store_code: string;
  quantity_on_hand: number;
  quantity_available: number;
  quantity_reserved: number;
}

// Variant stock info (v2)
interface VariantStockInfo {
  variant_id: string;
  stores: StoreStockInfo[];
}

// Product with stock info (v2: supports variants)
interface ProductStockInfo {
  product_id: string;
  has_variants?: boolean;
  stores?: StoreStockInfo[]; // For non-variant products
  variants?: VariantStockInfo[]; // For variant products
}

export const BulkMoveProductModal: React.FC<BulkMoveProductModalProps> = ({
  isOpen,
  onClose,
  products,
  sourceStoreId,
  companyId,
  onMove,
}) => {
  const { currentCompany, currentStore } = useAppState();
  const [selectedSourceStoreId, setSelectedSourceStoreId] = useState<string | null>(null);
  const [selectedTargetStoreId, setSelectedTargetStoreId] = useState<string | null>(null);
  const [quantities, setQuantities] = useState<Record<string, string>>({});
  const [notes, setNotes] = useState<string>('');

  // Stock info state
  const [productStockInfo, setProductStockInfo] = useState<ProductStockInfo[]>([]);
  const [isLoadingStock, setIsLoadingStock] = useState(false);

  // Dropdown states
  const [isFromDropdownOpen, setIsFromDropdownOpen] = useState(false);
  const [isToDropdownOpen, setIsToDropdownOpen] = useState(false);
  const fromDropdownRef = useRef<HTMLDivElement>(null);
  const toDropdownRef = useRef<HTMLDivElement>(null);

  // Fetch stock info when modal opens - v2: supports variants
  useEffect(() => {
    const fetchStockInfo = async () => {
      if (!isOpen || !products.length || !companyId) return;

      setIsLoadingStock(true);
      try {
        // Get unique product IDs (variants share the same productId)
        const productIds = [...new Set(products.map(p => p.productId))];
        const { data, error } = await supabaseService.rpc('inventory_product_stock_stores_v2', {
          p_company_id: companyId,
          p_product_ids: productIds
        });

        if (error) {
          console.error('Failed to fetch stock info:', error);
          return;
        }

        // v2: Check different possible response structures
        let productsData: ProductStockInfo[] = [];
        if (data?.success && data?.data?.products) {
          productsData = data.data.products;
        } else if (data?.products) {
          productsData = data.products;
        } else if (Array.isArray(data)) {
          productsData = data;
        }

        setProductStockInfo(productsData);
      } catch (err) {
        console.error('Error fetching stock info:', err);
      } finally {
        setIsLoadingStock(false);
      }
    };

    fetchStockInfo();
  }, [isOpen, products, companyId]);

  // Helper to get unique key for a product (variantId || productId)
  const getProductUniqueKey = (product: { productId: string; variantId?: string | null }): string => {
    return product.variantId || product.productId;
  };

  // Reset form when modal opens - set default from store from app state
  useEffect(() => {
    if (isOpen) {
      // Default to current store from app state, fallback to sourceStoreId prop
      setSelectedSourceStoreId(currentStore?.store_id || sourceStoreId);
      setSelectedTargetStoreId(null);
      setNotes('');
      setIsFromDropdownOpen(false);
      setIsToDropdownOpen(false);

      // Initialize all quantities to 1 (v2: use uniqueKey for variants)
      const initialQuantities: Record<string, string> = {};
      products.forEach(product => {
        const uniqueKey = getProductUniqueKey(product);
        initialQuantities[uniqueKey] = '1';
      });
      setQuantities(initialQuantities);
    }
  }, [isOpen, products, currentStore, sourceStoreId]);

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

  // Get stock for a specific product/variant and store (v2: supports variants)
  const getProductStoreStock = (productId: string, storeId: string, variantId?: string | null): number => {
    const productInfo = productStockInfo.find(p => p.product_id === productId);
    if (!productInfo) return 0;

    // v2: Check if product has variants
    if (productInfo.has_variants && productInfo.variants && variantId) {
      // Find the matching variant
      const variantInfo = productInfo.variants.find(v => v.variant_id === variantId);
      if (!variantInfo) return 0;
      const storeStock = variantInfo.stores?.find(s => s.store_id === storeId);
      return storeStock?.quantity_on_hand ?? 0;
    }

    // For non-variant products, use stores directly
    const storeStock = productInfo.stores?.find(s => s.store_id === storeId);
    return storeStock?.quantity_on_hand ?? 0;
  };

  // Get stock badge class based on quantity
  const getStockBadgeClass = (stock: number): string => {
    if (stock < 0) return `${styles.stockBadge} ${styles.stockNegative}`;
    if (stock === 0) return `${styles.stockBadge} ${styles.stockZero}`;
    return styles.stockBadge; // positive - blue color
  };

  // All stores for From Store selector
  const allStores = currentCompany?.stores || [];

  // Get available stores for To Store (exclude selected source store)
  const availableStores = currentCompany?.stores?.filter(
    (store) => store.store_id !== selectedSourceStoreId
  ) || [];

  const handleQuantityChange = (uniqueKey: string, value: string) => {
    // Only allow positive numbers
    if (value === '' || /^\d+$/.test(value)) {
      setQuantities(prev => ({
        ...prev,
        [uniqueKey]: value
      }));
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
    if (!selectedSourceStoreId || !selectedTargetStoreId || !onMove) return;

    // Build items array with quantities (v4: includes variantId, v2: use uniqueKey)
    const items = products
      .map(product => {
        const uniqueKey = getProductUniqueKey(product);
        const quantity = parseInt(quantities[uniqueKey] || '1', 10);
        if (isNaN(quantity) || quantity <= 0) return null;
        return {
          productId: product.productId,
          variantId: product.variantId, // v4: variant support
          productName: product.productName,
          quantity
        };
      })
      .filter((item): item is { productId: string; variantId?: string | null; productName: string; quantity: number } => item !== null);

    if (items.length === 0) return;

    await onMove(selectedTargetStoreId, items, notes, selectedSourceStoreId);
    onClose();
  };

  // Get selected store names
  const getStoreName = (storeId: string | null): string => {
    if (!storeId) return 'Select';
    const store = allStores.find(s => s.store_id === storeId);
    return store?.store_name || 'Select';
  };

  const isValidMove = selectedSourceStoreId && selectedTargetStoreId && products.every(product => {
    const uniqueKey = getProductUniqueKey(product);
    const qty = quantities[uniqueKey];
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
          {/* From Store Selection - Custom Dropdown (no stock shown here) */}
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
                <svg className={styles.dropdownArrow} fill="currentColor" viewBox="0 0 24 24">
                  <path d="M7.41,8.58L12,13.17L16.59,8.58L18,10L12,16L6,10L7.41,8.58Z" />
                </svg>
              </div>
              {isFromDropdownOpen && (
                <div className={styles.storeDropdownList}>
                  {allStores.map((store) => {
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
                        {isSelected && (
                          <svg className={styles.checkIcon} fill="currentColor" viewBox="0 0 24 24">
                            <path d="M9,20.42L2.79,14.21L5.62,11.38L9,14.77L18.88,4.88L21.71,7.71L9,20.42Z" />
                          </svg>
                        )}
                      </div>
                    );
                  })}
                </div>
              )}
            </div>
          </div>

          {/* To Store Selection - Custom Dropdown (no stock shown here) */}
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
                <svg className={styles.dropdownArrow} fill="currentColor" viewBox="0 0 24 24">
                  <path d="M7.41,8.58L12,13.17L16.59,8.58L18,10L12,16L6,10L7.41,8.58Z" />
                </svg>
              </div>
              {isToDropdownOpen && (
                <div className={styles.storeDropdownList}>
                  {availableStores.length === 0 ? (
                    <div className={styles.loadingText}>No other stores available</div>
                  ) : (
                    availableStores.map((store) => {
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

          {/* Products List with Stock Info */}
          <div className={styles.formGroup}>
            <label className={styles.formLabel}>Products ({products.length})</label>
            <div className={styles.productsList}>
              {products.map(product => {
                // v2: Use unique key and pass variantId for stock lookup
                const uniqueKey = getProductUniqueKey(product);
                const sourceStock = selectedSourceStoreId
                  ? getProductStoreStock(product.productId, selectedSourceStoreId, product.variantId)
                  : 0;
                const targetStock = selectedTargetStoreId
                  ? getProductStoreStock(product.productId, selectedTargetStoreId, product.variantId)
                  : 0;
                const moveQty = parseInt(quantities[uniqueKey] || '0', 10);
                const afterSourceStock = sourceStock - moveQty;

                return (
                  <div key={uniqueKey} className={styles.productItem}>
                    <div className={styles.productInfo}>
                      <span className={styles.productName}>{product.productName}</span>
                      <span className={styles.productCode}>{product.productCode}</span>
                      {/* Current Stock Info */}
                      {!isLoadingStock && (
                        <div className={styles.stockInfoRow}>
                          <span className={styles.stockLabel}>
                            From Store: <span className={getStockBadgeClass(sourceStock)}>{sourceStock}</span>
                          </span>
                          {selectedTargetStoreId && (
                            <span className={styles.stockLabel}>
                              To Store: <span className={getStockBadgeClass(targetStock)}>{targetStock}</span>
                            </span>
                          )}
                        </div>
                      )}
                      {/* After Quantity - separate section */}
                      {!isLoadingStock && moveQty > 0 && (
                        <div className={styles.afterQuantityRow}>
                          <span className={styles.afterLabel}>
                            After: <span className={getStockBadgeClass(afterSourceStock)}>{afterSourceStock}</span>
                          </span>
                        </div>
                      )}
                    </div>
                    <input
                      type="text"
                      inputMode="numeric"
                      className={styles.quantityInput}
                      value={quantities[uniqueKey] || '1'}
                      onChange={(e) => handleQuantityChange(uniqueKey, e.target.value)}
                      placeholder="Qty"
                    />
                  </div>
                );
              })}
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
