/**
 * ShipmentItemsTable Component
 * Table component for managing shipment items with search and import functionality
 */

import React from 'react';
import type { ShipmentItemsTableProps } from './ShipmentItemsTable.types';
import styles from './ShipmentItemsTable.module.css';

export const ShipmentItemsTable: React.FC<ShipmentItemsTableProps> = ({
  items,
  currency,
  totalAmount,
  onRemoveItem,
  onQuantityChange,
  onCostChange,
  formatPrice,
  searchInputRef,
  dropdownRef,
  searchQuery,
  onSearchQueryChange,
  searchResults,
  isSearching,
  showDropdown,
  onShowDropdownChange,
  onAddProductFromSearch,
  fileInputRef,
  isImporting,
  onImportClick,
  onFileChange,
  onExportSample,
}) => {
  return (
    <>
      {/* Search Bar and Action Buttons */}
      <div className={styles.itemActions}>
        <div className={styles.productSearchContainer}>
          <div className={styles.productSearchWrapper}>
            <svg className={styles.searchIcon} width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <circle cx="11" cy="11" r="8" />
              <path d="m21 21-4.35-4.35" />
            </svg>
            <input
              ref={searchInputRef}
              type="text"
              className={styles.productSearchInput}
              placeholder="Search products by name, SKU, or barcode..."
              value={searchQuery}
              onChange={(e) => onSearchQueryChange(e.target.value)}
              onFocus={() => searchQuery && searchResults.length > 0 && onShowDropdownChange(true)}
            />
            {isSearching && <div className={styles.searchSpinner} />}
          </div>

          {/* Search Results Dropdown */}
          {showDropdown && searchResults.length > 0 && (
            <div ref={dropdownRef} className={styles.searchDropdown}>
              {searchResults.map((product) => (
                <div
                  key={product.product_id}
                  className={styles.searchResultItem}
                  onClick={() => onAddProductFromSearch(product)}
                >
                  <div className={styles.searchResultImage}>
                    {product.image_urls && product.image_urls.length > 0 ? (
                      <img src={product.image_urls[0]} alt={product.product_name} />
                    ) : (
                      <div className={styles.noImage}>
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                          <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                          <circle cx="8.5" cy="8.5" r="1.5" />
                          <polyline points="21 15 16 10 5 21" />
                        </svg>
                      </div>
                    )}
                  </div>
                  <div className={styles.searchResultInfo}>
                    <span className={styles.searchResultName}>{product.product_name}</span>
                    <span className={styles.searchResultMeta}>
                      {product.sku} • Cost: {formatPrice(product.price.cost)}
                    </span>
                    <span className={styles.searchResultStock}>
                      OnHand: {product.stock.quantity_on_hand} • Available: {product.stock.quantity_available}
                    </span>
                  </div>
                </div>
              ))}
            </div>
          )}

          {/* No results message */}
          {showDropdown && searchQuery && searchResults.length === 0 && !isSearching && (
            <div ref={dropdownRef} className={styles.searchDropdown}>
              <div className={styles.noResults}>
                No products found for "{searchQuery}"
              </div>
            </div>
          )}
        </div>

        <div className={styles.importExportButtons}>
          <button
            className={styles.importButton}
            onClick={onImportClick}
            disabled={isImporting}
          >
            {isImporting ? (
              <>
                <div className={styles.buttonSpinner} />
                Importing...
              </>
            ) : (
              <>
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                  <polyline points="17 8 12 3 7 8" />
                  <line x1="12" y1="3" x2="12" y2="15" />
                </svg>
                Import Excel
              </>
            )}
          </button>
          <button className={styles.exportSampleButton} onClick={onExportSample}>
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
              <polyline points="7 10 12 15 17 10" />
              <line x1="12" y1="15" x2="12" y2="3" />
            </svg>
            Export Sample
          </button>
          <input
            ref={fileInputRef}
            type="file"
            accept=".xlsx,.xls"
            onChange={onFileChange}
            style={{ display: 'none' }}
          />
        </div>
      </div>

      {/* Items Table or Empty State */}
      {items.length === 0 ? (
        <div className={styles.emptyItems}>
          <svg className={styles.emptyIcon} width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
            <path d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" />
          </svg>
          <p>No items added yet</p>
          <span>Search for products above or use "Import Excel" to add items</span>
        </div>
      ) : (
        <div className={styles.tableContainer}>
          <table className={styles.itemsTable}>
            <thead>
              <tr>
                <th>Product Name</th>
                <th>SKU</th>
                <th>Cost</th>
                <th>Quantity</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {items.map((item, index) => (
                <tr key={item.orderItemId}>
                  <td className={styles.productName}>{item.productName}</td>
                  <td className={styles.sku}>{item.sku}</td>
                  <td>
                    <div className={styles.costInputWrapper}>
                      <input
                        type="number"
                        className={styles.costInput}
                        value={item.unitPrice}
                        onChange={(e) => onCostChange(index, parseFloat(e.target.value) || 0)}
                        min="0"
                        step="100"
                      />
                      <span className={styles.currencySymbol}>{currency.symbol}</span>
                    </div>
                  </td>
                  <td>
                    <input
                      type="number"
                      className={styles.quantityInputCell}
                      value={item.quantity || ''}
                      onChange={(e) => onQuantityChange(item.orderItemId, parseInt(e.target.value) || 0)}
                      min="0"
                    />
                  </td>
                  <td>
                    <button
                      className={styles.removeButton}
                      onClick={() => onRemoveItem(item.orderItemId)}
                    >
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                        <line x1="18" y1="6" x2="6" y2="18" />
                        <line x1="6" y1="6" x2="18" y2="18" />
                      </svg>
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
            <tfoot>
              <tr>
                <td colSpan={2} className={styles.totalLabel}>Total Amount</td>
                <td className={styles.grandTotal}>{formatPrice(totalAmount)}</td>
                <td colSpan={2}></td>
              </tr>
            </tfoot>
          </table>
        </div>
      )}
    </>
  );
};

export default ShipmentItemsTable;
