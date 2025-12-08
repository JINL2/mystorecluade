/**
 * InventoryHeader Component
 * Header section for inventory page with search, filters, and actions
 *
 * Following ARCHITECTURE.md:
 * - Component ≤ 15KB
 * - Clean separation from parent page
 * - All props explicitly defined
 */

import React from 'react';
import { TossButton } from '@/shared/components/toss/TossButton';
import { FilterDropdown } from '../FilterDropdown/FilterDropdown';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import type { InventoryHeaderProps } from './InventoryHeader.types';
import styles from './InventoryHeader.module.css';

export const InventoryHeader: React.FC<InventoryHeaderProps> = ({
  searchQuery,
  onSearchChange,
  selectedCount,
  isExporting,
  isImporting,
  totalItems,
  filterType,
  selectedBrandFilter,
  selectedCategoryFilter,
  brands,
  categories,
  onDelete,
  onMoveSelected,
  onExport,
  onImport,
  onAddProduct,
  onFilterChange,
  onBrandFilterChange,
  onCategoryFilterChange,
  fileInputRef,
  onFileChange,
}) => {
  /**
   * Handle clear search button click
   */
  const handleClearSearch = () => {
    onSearchChange('');
  };

  return (
    <div className={styles.inventoryHeader}>
      {/* Title and Search Section */}
      <div className={styles.inventoryTitleSection}>
        <h2 className={styles.inventoryTitle}>Products</h2>
        <div className={styles.inventorySearchWrapper}>
          <svg className={styles.searchIcon} fill="currentColor" viewBox="0 0 24 24">
            <path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
          </svg>
          <input
            type="text"
            className={styles.inventorySearch}
            placeholder="Search products..."
            value={searchQuery}
            onChange={(e) => onSearchChange(e.target.value)}
          />
          {searchQuery && (
            <button className={styles.searchClear} onClick={handleClearSearch}>
              <svg fill="currentColor" viewBox="0 0 24 24" width="16" height="16">
                <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
              </svg>
            </button>
          )}
        </div>

        {/* Mobile Filter Dropdown - Show only on mobile */}
        <div className={styles.mobileFilterWrapper}>
          <FilterDropdown
            filterType={filterType}
            selectedBrandFilter={selectedBrandFilter}
            selectedCategoryFilter={selectedCategoryFilter}
            brands={brands}
            categories={categories}
            onFilterChange={onFilterChange}
            onBrandFilterChange={onBrandFilterChange}
            onCategoryFilterChange={onCategoryFilterChange}
          />
        </div>
      </div>

      {/* Action Buttons Section */}
      <div className={styles.inventoryActions}>
        <div className={styles.actionButtons}>
          <TossButton
            variant="secondary"
            size="md"
            onClick={onMoveSelected}
            disabled={selectedCount === 0}
            icon={
              <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                <path d="M6,13H14L10.5,16.5L11.92,17.92L17.84,12L11.92,6.08L10.5,7.5L14,11H6V13M20,6V18H11V20H20A2,2 0 0,0 22,18V6A2,2 0 0,0 20,4H11V6H20Z"/>
              </svg>
            }
            iconPosition="left"
          >
            {selectedCount > 0 ? `Move ${selectedCount} Product${selectedCount > 1 ? 's' : ''}` : 'Move Product'}
          </TossButton>

          <TossButton
            variant="error"
            size="md"
            onClick={onDelete}
            disabled={selectedCount === 0}
            icon={
              <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                <path d="M19,4H15.5L14.5,3H9.5L8.5,4H5V6H19M6,19A2,2 0 0,0 8,21H16A2,2 0 0,0 18,19V7H6V19Z"/>
              </svg>
            }
            iconPosition="left"
          >
            {selectedCount > 0 ? `Delete ${selectedCount} Product${selectedCount > 1 ? 's' : ''}` : 'Delete Product'}
          </TossButton>

          <TossButton
            variant="secondary"
            size="md"
            onClick={onExport}
            disabled={isExporting}
            icon={
              isExporting ? (
                <LoadingAnimation size="small" />
              ) : (
                <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M14,2H6A2,2 0 0,0 4,4V20A2,2 0 0,0 6,22H18A2,2 0 0,0 20,20V8L14,2M18,20H6V4H13V9H18V20Z"/>
                </svg>
              )
            }
            iconPosition="left"
          >
            {isExporting ? 'Exporting...' : 'Export Excel'}
          </TossButton>

          <TossButton
            variant="secondary"
            size="md"
            onClick={onImport}
            disabled={isImporting}
            icon={
              isImporting ? (
                <LoadingAnimation size="small" />
              ) : (
                <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M14,2H6A2,2 0 0,0 4,4V20A2,2 0 0,0 6,22H18A2,2 0 0,0 20,20V8L14,2M13,13H11V16H9L12,19L15,16H13V13M13,9V3.5L18.5,9H13Z"/>
                </svg>
              )
            }
            iconPosition="left"
          >
            {isImporting ? 'Importing...' : 'Import Excel'}
          </TossButton>

          {/* Hidden file input for import */}
          <input
            ref={fileInputRef}
            type="file"
            accept=".xlsx,.xls"
            onChange={onFileChange}
            style={{ display: 'none' }}
          />

          <TossButton
            variant="primary"
            size="md"
            onClick={onAddProduct}
            icon={
              <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                <path d="M19,13H13V19H11V13H5V11H11V5H13V11H19V13Z"/>
              </svg>
            }
            iconPosition="left"
          >
            Add Product
          </TossButton>
        </div>
      </div>
    </div>
  );
};
