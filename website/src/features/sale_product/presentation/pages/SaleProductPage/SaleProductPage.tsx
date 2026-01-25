/**
 * SaleProductPage Component
 * Page for creating new sales invoices with product selection
 * Toss-style mobile-first design
 *
 * Following Clean Architecture:
 * - Uses Zustand Provider for state management
 * - Uses custom hooks for business logic
 * - Presentation layer only (no direct data access)
 */

import React, { useState, useEffect } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { useAppState } from '@/app/providers/app_state_provider';
import { useSaleProducts } from '../../hooks/useSaleProducts';
import { useSaleInvoice } from '../../hooks/useSaleInvoice';
import { PaymentModal } from '../../components/PaymentModal/PaymentModal';
import type { SaleProductPageProps } from './SaleProductPage.types';
import pageStyles from './SaleProductPage.module.css';
import cartStyles from './styles/CartSection.module.css';
import productStyles from './styles/ProductGrid.module.css';
import searchStyles from './styles/SearchBar.module.css';
import paginationStyles from './styles/Pagination.module.css';

// Combine all styles into one object for convenience
const styles = {
  ...pageStyles,
  ...cartStyles,
  ...productStyles,
  ...searchStyles,
  ...paginationStyles,
};

export const SaleProductPage: React.FC<SaleProductPageProps> = () => {
  const { currentCompany, currentStore } = useAppState();
  const [selectedStoreId, setSelectedStoreId] = useState<string | null>(
    currentStore?.store_id || null
  );

  // Sale invoice state (from Zustand)
  const {
    cartItems,
    subtotal,
    itemCount,
    addToCart,
    removeFromCart,
    updateQuantity,
    clearCart,
    openPaymentModal,
    isPaymentModalOpen,
  } = useSaleInvoice();

  // Load products
  const {
    products,
    loading,
    error,
    currencySymbol,
    currentPage,
    totalPages,
    nextPage,
    prevPage,
    searchQuery,
    setSearchQuery,
    convertToDomainProduct,
  } = useSaleProducts(currentCompany?.company_id, selectedStoreId);

  // Handle store selection
  const handleStoreSelect = (storeId: string | null) => {
    setSelectedStoreId(storeId);
    clearCart(); // Clear cart when store changes
  };

  // Handle product click - add to cart
  const handleProductClick = (product: any) => {
    // Convert ProductForSale to Domain Product Entity using hook's converter
    // This follows Clean Architecture - presentation doesn't access data layer directly
    const domainProduct = convertToDomainProduct(product);
    addToCart(domainProduct);
  };

  return (
    <div
      style={{
        height: '100vh',
        overflow: 'hidden',
        display: 'flex',
        flexDirection: 'column',
      }}
    >
      <Navbar activeItem="product" />
      <div className={styles.pageLayout}>
        {!currentCompany || !currentStore ? (
          <div className={styles.message}>
            Please select a company and store first
          </div>
        ) : (
          <div className={styles.mainContainer}>
            {/* Top Section - Cart */}
            <div className={styles.topSection}>
              {/* Cart Items */}
              <div className={styles.selectedItems}>
                {/* v6: Uses uniqueKey for cart item identification (supports variants) */}
                {itemCount === 0 ? (
                  <div className={styles.emptyCart}>No items selected</div>
                ) : (
                  cartItems.map((item, index) => (
                    <div key={item.uniqueKey} className={styles.cartItem}>
                      <div className={styles.cartItemHeader}>
                        <span className={styles.cartItemNumber}>
                          {index + 1}
                        </span>
                        <button
                          className={styles.deleteBtn}
                          onClick={() => removeFromCart(item.uniqueKey)}
                          aria-label="Remove item"
                        >
                          <svg
                            width="16"
                            height="16"
                            viewBox="0 0 24 24"
                            fill="currentColor"
                          >
                            <path d="M19,4H15.5L14.5,3H9.5L8.5,4H5V6H19M6,19A2,2 0 0,0 8,21H16A2,2 0 0,0 18,19V7H6V19Z" />
                          </svg>
                        </button>
                      </div>
                      <div className={styles.cartItemDetails}>
                        <div className={styles.cartItemSku}>{item.sku}</div>
                        <div className={styles.cartItemName}>
                          {item.productName}
                        </div>
                      </div>
                      <div className={styles.cartItemFooter}>
                        <div className={styles.quantityControl}>
                          <button
                            className={styles.quantityBtn}
                            onClick={() =>
                              updateQuantity(item.uniqueKey, item.quantity - 1)
                            }
                            aria-label="Decrease quantity"
                          >
                            <svg
                              width="16"
                              height="16"
                              viewBox="0 0 24 24"
                              fill="currentColor"
                            >
                              <path d="M19,13H5V11H19V13Z" />
                            </svg>
                          </button>
                          <input
                            type="number"
                            className={styles.quantityInput}
                            value={item.quantity}
                            min="1"
                            onChange={(e) =>
                              updateQuantity(
                                item.uniqueKey,
                                parseInt(e.target.value) || 1
                              )
                            }
                          />
                          <button
                            className={styles.quantityBtn}
                            onClick={() =>
                              updateQuantity(item.uniqueKey, item.quantity + 1)
                            }
                            aria-label="Increase quantity"
                          >
                            <svg
                              width="16"
                              height="16"
                              viewBox="0 0 24 24"
                              fill="currentColor"
                            >
                              <path d="M19,13H13V19H11V13H5V11H11V5H13V11H19V13Z" />
                            </svg>
                          </button>
                        </div>
                        <div className={styles.cartItemPrices}>
                          <div className={styles.unitPrice}>
                            {currencySymbol}
                            {item.unitPrice.toLocaleString()}
                          </div>
                          <div className={styles.totalPrice}>
                            {currencySymbol}
                            {item.totalPrice.toLocaleString()}
                          </div>
                        </div>
                      </div>
                    </div>
                  ))
                )}
              </div>

              {/* Bottom Bar */}
              <div className={styles.bottomBar}>
                <div className={styles.subtotalSection}>
                  <div className={styles.subtotalItem}>
                    <span className={styles.subtotalLabel}>Products</span>
                    <span className={styles.subtotalValue}>{itemCount}</span>
                  </div>
                  <div className={styles.subtotalItem}>
                    <span className={styles.subtotalLabel}>Sub-total</span>
                    <span className={styles.subtotalAmount}>
                      {currencySymbol}
                      {subtotal.toLocaleString()}
                    </span>
                  </div>
                </div>
              </div>
            </div>

            {/* Product Grid */}
            <div className={styles.productSection}>
              {/* Search Bar and Store Selector */}
              <div className={styles.searchContainer}>
                <div className={styles.searchBox}>
                  <svg
                    className={styles.searchIcon}
                    width="20"
                    height="20"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                  >
                    <circle cx="11" cy="11" r="8" strokeWidth="2" />
                    <path
                      d="m21 21-4.35-4.35"
                      strokeWidth="2"
                      strokeLinecap="round"
                    />
                  </svg>
                  <input
                    type="text"
                    placeholder="Search products..."
                    className={styles.searchInput}
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                  />
                </div>
                <StoreSelector
                  stores={currentCompany?.stores || []}
                  selectedStoreId={selectedStoreId}
                  onStoreSelect={handleStoreSelect}
                  showAllStoresOption={false}
                />
              </div>

              {/* Products Grid */}
              {loading ? (
                <div className={styles.loadingContainer}>
                  <LoadingAnimation />
                </div>
              ) : error ? (
                <div className={styles.errorContainer}>
                  <p className={styles.errorMessage}>{error}</p>
                </div>
              ) : products.length === 0 ? (
                <div className={styles.emptyState}>
                  <p>No products found</p>
                </div>
              ) : (
                <>
                  {/* v6: Uses unique key (product_id + variant_id) and display_name for variant support */}
                  <div className={styles.productGrid}>
                    {products.map((product) => (
                      <div
                        key={product.variant_id ? `${product.product_id}-${product.variant_id}` : product.product_id}
                        className={styles.productCard}
                        onClick={() => handleProductClick(product)}
                      >
                        <div className={styles.productImage}>
                          {product.image_urls &&
                          product.image_urls.length > 0 ? (
                            <img
                              src={product.image_urls[0]}
                              alt={product.display_name || product.product_name}
                            />
                          ) : (
                            <div className={styles.noImage}>No Image</div>
                          )}
                        </div>
                        <div className={styles.productInfo}>
                          <div className={styles.productBrand}>
                            {product.brand_name}
                          </div>
                          <div className={styles.productName}>
                            {product.display_name || product.product_name}
                          </div>
                          <div className={styles.productPrice}>
                            {currencySymbol}
                            {product.selling_price.toLocaleString()}
                          </div>
                          <div
                            className={
                              product.quantity_available < 0
                                ? styles.productStockNegative
                                : styles.productStock
                            }
                          >
                            Stock: {product.quantity_available}
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>

                  {/* Pagination and Complete Button */}
                  <div className={styles.bottomActions}>
                    <div className={styles.paginationWrapper}>
                      {totalPages > 1 && (
                        <>
                          <button
                            className={styles.paginationBtn}
                            onClick={prevPage}
                            disabled={currentPage === 1}
                          >
                            Previous
                          </button>
                          <span className={styles.paginationInfo}>
                            Page {currentPage} of {totalPages}
                          </span>
                          <button
                            className={styles.paginationBtn}
                            onClick={nextPage}
                            disabled={currentPage === totalPages}
                          >
                            Next
                          </button>
                        </>
                      )}
                    </div>

                    {/* Complete Button */}
                    <button
                      className={styles.completeBtn}
                      onClick={openPaymentModal}
                      disabled={itemCount === 0}
                    >
                      COMPLETE
                    </button>
                  </div>
                </>
              )}
            </div>
          </div>
        )}
      </div>

      {/* Payment Modal */}
      {isPaymentModalOpen && currentCompany && selectedStoreId && (
        <PaymentModal
          companyId={currentCompany.company_id}
          storeId={selectedStoreId}
          currencySymbol={currencySymbol}
        />
      )}
    </div>
  );
};

export default SaleProductPage;
