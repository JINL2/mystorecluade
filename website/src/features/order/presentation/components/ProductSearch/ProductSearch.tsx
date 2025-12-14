/**
 * ProductSearch Component
 * Search dropdown for adding products to order
 */

import React, { RefObject } from 'react';
import type { InventoryProduct } from '../../pages/OrderCreatePage/OrderCreatePage.types';
import styles from './ProductSearch.module.css';

interface ProductSearchProps {
  searchInputRef: RefObject<HTMLInputElement | null>;
  dropdownRef: RefObject<HTMLDivElement | null>;
  searchQuery: string;
  onSearchChange: (value: string) => void;
  searchResults: InventoryProduct[];
  isSearching: boolean;
  showDropdown: boolean;
  onShowDropdown: (show: boolean) => void;
  onAddProduct: (product: InventoryProduct) => void;
  formatPrice: (price: number) => string;
}

export const ProductSearch: React.FC<ProductSearchProps> = ({
  searchInputRef,
  dropdownRef,
  searchQuery,
  onSearchChange,
  searchResults,
  isSearching,
  showDropdown,
  onShowDropdown,
  onAddProduct,
  formatPrice,
}) => {
  return (
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
          onChange={(e) => onSearchChange(e.target.value)}
          onFocus={() => searchQuery && searchResults.length > 0 && onShowDropdown(true)}
        />
        {isSearching && (
          <div className={styles.searchSpinner} />
        )}
      </div>

      {/* Search Results Dropdown */}
      {showDropdown && searchResults.length > 0 && (
        <div ref={dropdownRef} className={styles.searchDropdown}>
          {searchResults.map((product) => (
            <div
              key={product.product_id}
              className={styles.searchResultItem}
              onClick={() => onAddProduct(product)}
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
                  {product.sku} • Selling price: {formatPrice(product.price.selling)}
                </span>
                <span className={styles.searchResultStock}>
                  OnHand: {product.stock.quantity_on_hand} • Customer ordered: {product.stock.quantity_reserved}
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
  );
};

export default ProductSearch;
