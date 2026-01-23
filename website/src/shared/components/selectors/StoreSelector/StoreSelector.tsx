/**
 * StoreSelector Component
 * Reusable store selector dropdown with configurable options
 *
 * @example
 * ```tsx
 * <StoreSelector
 *   stores={company.stores}
 *   selectedStoreId={selectedStoreId}
 *   onStoreSelect={handleStoreSelect}
 *   width="300px"
 *   maxHeight="400px"
 * />
 * ```
 */

import { useState, useEffect, useRef } from 'react';
import type { StoreSelectorProps } from './StoreSelector.types';
import styles from './StoreSelector.module.css';

export const StoreSelector = ({
  stores,
  selectedStoreId,
  onStoreSelect,
  companyId,
  width = '280px', // Default: 280px
  maxHeight = '380px', // Default: 380px
  className = '',
  showAllStoresOption = true,
  allStoresLabel = 'All Stores',
  disabled = false,
  size = 'default',
}: StoreSelectorProps) => {
  const [isOpen, setIsOpen] = useState(false);
  const containerRef = useRef<HTMLDivElement>(null);

  // Close dropdown when clicking outside
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (containerRef.current && !containerRef.current.contains(event.target as Node)) {
        setIsOpen(false);
      }
    };

    if (isOpen) {
      document.addEventListener('mousedown', handleClickOutside);
    }

    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
    };
  }, [isOpen]);

  // Handle store selection
  const handleStoreSelect = (storeId: string | null, e?: React.MouseEvent) => {
    e?.stopPropagation();
    onStoreSelect(storeId);
    setIsOpen(false);
  };

  // Toggle dropdown
  const toggleDropdown = () => {
    if (!disabled) {
      setIsOpen(!isOpen);
    }
  };

  // Get display label for selected store
  const getSelectedLabel = (): string => {
    if (!selectedStoreId) {
      return allStoresLabel;
    }
    if (!stores || stores.length === 0) {
      return allStoresLabel;
    }
    const selectedStore = stores.find((s) => s.store_id === selectedStoreId);
    return selectedStore?.store_name || allStoresLabel;
  };

  // Check if there are any stores
  const hasStores = stores && stores.length > 0;

  return (
    <div
      ref={containerRef}
      className={`${styles.storeSelector} ${disabled ? styles.disabled : ''} ${size === 'compact' ? styles.compact : ''} ${className}`}
      style={
        {
          '--store-selector-width': width,
          '--store-selector-max-height': maxHeight,
        } as React.CSSProperties
      }
    >
      {/* Control Section */}
      <div
        className={`${styles.control} ${isOpen ? styles.open : ''}`}
        onClick={toggleDropdown}
      >
        {/* Home Icon */}
        <svg className={styles.controlIcon} fill="currentColor" viewBox="0 0 24 24">
          <path d="M10,20V14H14V20H19V12H22L12,3L2,12H5V20H10Z" />
        </svg>

        {/* Selected Store Label */}
        <span className={styles.controlLabel}>{getSelectedLabel()}</span>

        {/* Dropdown Arrow */}
        <svg className={styles.controlArrow} fill="currentColor" viewBox="0 0 24 24">
          <path d="M7.41,8.58L12,13.17L16.59,8.58L18,10L12,16L6,10L7.41,8.58Z" />
        </svg>
      </div>

      {/* Dropdown Section */}
      <div className={`${styles.dropdown} ${isOpen ? styles.active : ''}`}>
        {!hasStores && (
          <div className={styles.emptyState}>No stores available</div>
        )}

        {hasStores && (
          <>
            {/* All Stores Option */}
            {showAllStoresOption && (
              <div
                className={`${styles.option} ${!selectedStoreId ? styles.selected : ''}`}
                onClick={(e) => handleStoreSelect(null, e)}
              >
                {/* Home Icon */}
                <svg className={styles.optionIcon} fill="currentColor" viewBox="0 0 24 24">
                  <path d="M10,20V14H14V20H19V12H22L12,3L2,12H5V20H10Z" />
                </svg>

                {/* Label */}
                <span className={styles.optionText}>{allStoresLabel}</span>

                {/* Checkmark Icon (visible when selected) */}
                {!selectedStoreId && (
                  <svg className={styles.checkmarkIcon} fill="currentColor" viewBox="0 0 24 24">
                    <path d="M9,20.42L2.79,14.21L5.62,11.38L9,14.77L18.88,4.88L21.71,7.71L9,20.42Z" />
                  </svg>
                )}
              </div>
            )}

            {/* Individual Store Options */}
            {stores.map((store) => {
              const isSelected = selectedStoreId === store.store_id;
              return (
                <div
                  key={store.store_id}
                  className={`${styles.option} ${isSelected ? styles.selected : ''}`}
                  onClick={(e) => handleStoreSelect(store.store_id, e)}
                >
                  {/* Home Icon */}
                  <svg className={styles.optionIcon} fill="currentColor" viewBox="0 0 24 24">
                    <path d="M10,20V14H14V20H19V12H22L12,3L2,12H5V20H10Z" />
                  </svg>

                  {/* Store Name */}
                  <span className={styles.optionText}>{store.store_name}</span>

                  {/* Checkmark Icon (visible when selected) */}
                  {isSelected && (
                    <svg className={styles.checkmarkIcon} fill="currentColor" viewBox="0 0 24 24">
                      <path d="M9,20.42L2.79,14.21L5.62,11.38L9,14.77L18.88,4.88L21.71,7.71L9,20.42Z" />
                    </svg>
                  )}
                </div>
              );
            })}
          </>
        )}
      </div>
    </div>
  );
};
