/**
 * OrderForm Component
 * New purchase order creation form
 * Following 2025 Best Practice: Uses Zustand provider for state management
 */

import React, { useEffect, useRef } from 'react';
import { useAppState } from '@/app/providers/app_state_provider';
import { useCounterparties } from '../../hooks/useCounterparties';
import { useProducts } from '../../hooks/useProducts';
import { useOrderForm } from '../../hooks/useOrderForm';
import { useErrorMessage } from '@/shared/hooks/useErrorMessage';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import styles from './OrderForm.module.css';

interface OrderFormProps {
  onSuccess?: () => void;
  onCancel?: () => void;
}

export const OrderForm: React.FC<OrderFormProps> = ({ onCancel }) => {
  const { currentCompany } = useAppState();
  const { counterparties, loading: loadingCounterparties, error: counterpartiesError } = useCounterparties(currentCompany?.company_id || null);
  const { products, currencySymbol, error: productsError } = useProducts(currentCompany?.company_id || null);
  const { messageState, closeMessage, showError } = useErrorMessage();
  const dropdownRef = useRef<HTMLDivElement>(null);
  const searchRef = useRef<HTMLDivElement>(null);

  // Use order form hook with Zustand provider
  const {
    orderDate,
    notes,
    supplierTab,
    selectedSupplier,
    supplierInfo,
    orderItems,
    isDropdownOpen,
    searchTerm,
    showSuggestions,
    searchResults,
    isCreating,
    validationErrors,
    summary,
    isValid,
    setOrderDate,
    setNotes,
    setSupplierTab,
    setSelectedSupplier,
    setSupplierInfo,
    setIsDropdownOpen,
    setSearchTerm,
    setShowSuggestions,
    addOrderItem,
    updateOrderItemQuantity,
    updateOrderItemPrice,
    removeOrderItem,
    searchProducts,
    clearSearch,
    validateForm,
    resetForm,
  } = useOrderForm();

  // Handle products error
  useEffect(() => {
    if (productsError) {
      showError({
        title: 'Failed to Load Products',
        message: productsError,
      });
    }
  }, [productsError, showError]);

  // Handle counterparties error
  useEffect(() => {
    if (counterpartiesError) {
      showError({
        title: 'Failed to Load Suppliers',
        message: counterpartiesError,
      });
    }
  }, [counterpartiesError, showError]);

  // Handle click outside dropdown and search suggestions
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsDropdownOpen(false);
      }
      if (searchRef.current && !searchRef.current.contains(event.target as Node)) {
        setShowSuggestions(false);
      }
    };

    if (isDropdownOpen || showSuggestions) {
      document.addEventListener('mousedown', handleClickOutside);
    }

    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
    };
  }, [isDropdownOpen, showSuggestions, setIsDropdownOpen, setShowSuggestions]);

  // Handle supplier tab change
  const handleSupplierTabChange = (tab: 'counter-party' | 'others') => {
    setSupplierTab(tab);
  };

  // Handle product search
  const handleSearchChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const value = e.target.value;
    setSearchTerm(value);
    searchProducts(value, products);
  };

  // Add product to order items
  const handleAddProduct = (product: any) => {
    addOrderItem(product);
    clearSearch();
  };

  // Format number with thousand separators (integer only, following backup pattern)
  const formatNumber = (value: number): string => {
    return Math.round(value).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
  };

  // Update order item quantity
  const handleQuantityChange = (productId: string, value: string) => {
    const quantity = parseInt(value.replace(/,/g, '')) || 0;
    updateOrderItemQuantity(productId, quantity);
  };

  // Update order item unit price
  const handlePriceChange = (productId: string, value: string) => {
    const unitPrice = parseFloat(value.replace(/,/g, '')) || 0;
    updateOrderItemPrice(productId, unitPrice);
  };

  // Handle create order
  const handleCreateOrder = async () => {
    if (!currentCompany) return;

    // Validate form
    if (!validateForm()) {
      const errorMessage = Object.values(validationErrors).join('\n');
      showError({
        title: 'Validation Failed',
        message: errorMessage,
      });
      return;
    }

    // TODO: Implement order creation
    showError({
      title: 'Not Implemented',
      message: 'Order creation is not yet implemented',
    });
  };

  // Handle cancel
  const handleCancel = () => {
    resetForm();
    if (onCancel) {
      onCancel();
    }
  };

  return (
    <div className={styles.orderFormContainer}>
      <div className={styles.orderFormMain}>
        {/* Order Information Section */}
        <div className={styles.formSection}>
          <h2 className={styles.sectionTitle}>Order Information</h2>
          <div className={styles.formRow}>
            <div className={styles.formGroup}>
              <label className={styles.formLabel}>Order Date</label>
              <input
                type="date"
                className={styles.formInput}
                value={orderDate}
                onChange={(e) => setOrderDate(e.target.value)}
              />
            </div>
            <div className={styles.formGroup}>
              <label className={styles.formLabel}>Notes</label>
              <textarea
                className={styles.formInput}
                rows={1}
                placeholder="Optional notes..."
                value={notes}
                onChange={(e) => setNotes(e.target.value)}
              />
            </div>
          </div>
        </div>

        {/* Supplier Selection Section */}
        <div className={styles.formSection}>
          <h2 className={styles.sectionTitle}>Supplier Details</h2>

          {/* Supplier Tabs */}
          <div className={styles.supplierTabs}>
            <button
              className={`${styles.supplierTab} ${supplierTab === 'counter-party' ? styles.active : ''}`}
              onClick={() => handleSupplierTabChange('counter-party')}
            >
              Counter Party
            </button>
            <button
              className={`${styles.supplierTab} ${supplierTab === 'others' ? styles.active : ''}`}
              onClick={() => handleSupplierTabChange('others')}
            >
              Others
            </button>
          </div>

          {/* Counter Party Tab Content */}
          {supplierTab === 'counter-party' && (
            <div className={styles.supplierTabContent}>
              <div className={styles.formRow}>
                <div className={styles.formGroup} style={{ gridColumn: '1 / -1' }}>
                  <label className={styles.formLabel}>Select Supplier</label>
                  <div className={styles.customDropdown} ref={dropdownRef}>
                    <div
                      className={styles.dropdownHeader}
                      onClick={() => setIsDropdownOpen(!isDropdownOpen)}
                    >
                      <div className={styles.dropdownSelected}>
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                          <circle cx="11" cy="11" r="8" />
                          <path d="m21 21-4.35-4.35" />
                        </svg>
                        <span>{selectedSupplier ? selectedSupplier.name : 'Choose a supplier...'}</span>
                      </div>
                      <svg
                        className={`${styles.dropdownArrow} ${isDropdownOpen ? styles.open : ''}`}
                        width="16"
                        height="16"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="currentColor"
                        strokeWidth="2"
                      >
                        <polyline points="6 9 12 15 18 9" />
                      </svg>
                    </div>
                    {isDropdownOpen && (
                      <div className={styles.dropdownList}>
                        {loadingCounterparties ? (
                          <div className={styles.dropdownOption}>
                            <LoadingAnimation size="small" />
                          </div>
                        ) : counterparties.length === 0 ? (
                          <div className={styles.dropdownOption}>
                            <span>No suppliers found</span>
                          </div>
                        ) : (
                          counterparties.map((supplier) => (
                            <div
                              key={supplier.counterparty_id}
                              className={`${styles.dropdownOption} ${
                                selectedSupplier?.counterparty_id === supplier.counterparty_id ? styles.selected : ''
                              }`}
                              onClick={() => {
                                setSelectedSupplier(supplier);
                                setIsDropdownOpen(false);
                              }}
                            >
                              <div className={styles.supplierInfo}>
                                <div className={styles.supplierName}>{supplier.name}</div>
                                {supplier.phone && <div className={styles.supplierDetail}>{supplier.phone}</div>}
                              </div>
                            </div>
                          ))
                        )}
                      </div>
                    )}
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* Others Tab Content */}
          {supplierTab === 'others' && (
            <div className={styles.supplierTabContent}>
              <div className={styles.formRow}>
                <div className={styles.formGroup}>
                  <label className={styles.formLabel}>Supplier Name</label>
                  <input
                    type="text"
                    className={styles.formInput}
                    placeholder="Enter supplier name"
                    value={supplierInfo.name}
                    onChange={(e) => setSupplierInfo({ name: e.target.value })}
                  />
                </div>
                <div className={styles.formGroup}>
                  <label className={styles.formLabel}>Contact Person</label>
                  <input
                    type="text"
                    className={styles.formInput}
                    placeholder="Enter contact name"
                    value={supplierInfo.contact}
                    onChange={(e) => setSupplierInfo({ contact: e.target.value })}
                  />
                </div>
              </div>
              <div className={styles.formRow}>
                <div className={styles.formGroup}>
                  <label className={styles.formLabel}>Phone</label>
                  <input
                    type="tel"
                    className={styles.formInput}
                    placeholder="Enter phone number"
                    value={supplierInfo.phone}
                    onChange={(e) => setSupplierInfo({ phone: e.target.value })}
                  />
                </div>
                <div className={styles.formGroup}>
                  <label className={styles.formLabel}>Email</label>
                  <input
                    type="email"
                    className={styles.formInput}
                    placeholder="Enter email address"
                    value={supplierInfo.email}
                    onChange={(e) => setSupplierInfo({ email: e.target.value })}
                  />
                </div>
              </div>
              <div className={styles.formRow}>
                <div className={styles.formGroup} style={{ gridColumn: '1 / -1' }}>
                  <label className={styles.formLabel}>Address</label>
                  <input
                    type="text"
                    className={styles.formInput}
                    placeholder="Enter supplier address"
                    value={supplierInfo.address}
                    onChange={(e) => setSupplierInfo({ address: e.target.value })}
                  />
                </div>
              </div>
              <div className={styles.formRow}>
                <div className={styles.formGroup}>
                  <label className={styles.formLabel}>Bank Account</label>
                  <input
                    type="text"
                    className={styles.formInput}
                    placeholder="Enter bank account information"
                    value={supplierInfo.bank_account}
                    onChange={(e) => setSupplierInfo({ bank_account: e.target.value })}
                  />
                </div>
                <div className={styles.formGroup}>
                  <label className={styles.formLabel}>Memo</label>
                  <textarea
                    className={styles.formInput}
                    rows={2}
                    placeholder="Enter any additional notes..."
                    value={supplierInfo.memo}
                    onChange={(e) => setSupplierInfo({ memo: e.target.value })}
                  />
                </div>
              </div>
            </div>
          )}
        </div>

        {/* Order Items Section */}
        <div className={styles.formSection}>
          <div className={styles.sectionHeader}>
            <h2 className={styles.sectionTitle}>Order Items</h2>
            <div className={styles.sectionActions}>
              <div className={styles.productSearch} ref={searchRef}>
                <svg className={styles.productSearchIcon} width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <circle cx="11" cy="11" r="8" />
                  <path d="m21 21-4.35-4.35" />
                </svg>
                <input
                  type="text"
                  placeholder="Search products..."
                  className={styles.productSearchInput}
                  value={searchTerm}
                  onChange={handleSearchChange}
                />
                {showSuggestions && searchResults.length > 0 && (
                  <div className={styles.searchSuggestions}>
                    {searchResults.map((product) => {
                      const price = product.selling_price || 0;
                      const stock = product.quantity_on_hand || 0;
                      return (
                        <div
                          key={product.product_id}
                          className={styles.searchSuggestionItem}
                          onClick={() => handleAddProduct(product)}
                        >
                          <div className={styles.searchSuggestionContent}>
                            <div className={styles.searchSuggestionName}>{product.product_name}</div>
                            <div className={styles.searchSuggestionDetails}>
                              <span className={styles.searchSuggestionSku}>SKU: {product.sku || 'N/A'}</span>
                              <span>Stock: {stock}</span>
                              <span className={styles.searchSuggestionPrice}>
                                {currencySymbol}{formatNumber(price)}
                              </span>
                            </div>
                          </div>
                        </div>
                      );
                    })}
                  </div>
                )}
                {showSuggestions && searchTerm && searchResults.length === 0 && (
                  <div className={styles.searchSuggestions}>
                    <div className={styles.searchNoResults}>
                      No products found matching "{searchTerm}"
                    </div>
                  </div>
                )}
              </div>
              <button className={styles.btnSecondary}>
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                  <polyline points="14 2 14 8 20 8" />
                  <line x1="16" y1="13" x2="8" y2="13" />
                  <line x1="16" y1="17" x2="8" y2="17" />
                </svg>
                Import Excel
              </button>
              <button className={styles.btnSecondary}>
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                  <polyline points="7 10 12 15 17 10" />
                  <line x1="12" y1="15" x2="12" y2="3" />
                </svg>
                Export Template & Product List
              </button>
            </div>
          </div>
          <div className={styles.productsTableContainer}>
            <table className={styles.productsTable}>
              <thead>
                <tr>
                  <th>Product Name</th>
                  <th>SKU</th>
                  <th>Unit</th>
                  <th>Quantity</th>
                  <th>Unit Price</th>
                  <th>Subtotal</th>
                  <th>Action</th>
                </tr>
              </thead>
              <tbody>
                {orderItems.length === 0 ? (
                  <tr>
                    <td colSpan={7} className={styles.emptyMessage}>
                      No items added yet. Search for products above to add them.
                    </td>
                  </tr>
                ) : (
                  orderItems.map((item) => (
                    <tr key={item.product_id}>
                      <td>{item.product_name}</td>
                      <td>{item.sku || '-'}</td>
                      <td>{item.unit}</td>
                      <td>
                        <input
                          type="text"
                          inputMode="numeric"
                          className={styles.quantityInput}
                          value={formatNumber(item.quantity)}
                          onChange={(e) => handleQuantityChange(item.product_id, e.target.value)}
                        />
                      </td>
                      <td>
                        <input
                          type="text"
                          inputMode="decimal"
                          className={styles.priceInput}
                          value={formatNumber(item.unit_price)}
                          onChange={(e) => handlePriceChange(item.product_id, e.target.value)}
                        />
                      </td>
                      <td className={styles.subtotalCell}>
                        {currencySymbol}{formatNumber(item.subtotal)}
                      </td>
                      <td>
                        <button
                          className={styles.btnDelete}
                          onClick={() => removeOrderItem(item.product_id)}
                          type="button"
                        >
                          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                            <path d="M3 6h18M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2" />
                          </svg>
                        </button>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>

        {/* Action Buttons */}
        <div className={styles.formActions}>
          <button
            className={styles.btnSecondary}
            onClick={handleCancel}
            disabled={isCreating}
          >
            Cancel
          </button>
          <button
            className={styles.btnPrimary}
            onClick={handleCreateOrder}
            disabled={!isValid || isCreating}
          >
            {isCreating ? 'Creating Order...' : 'Create Order'}
          </button>
        </div>
      </div>

      {/* Order Summary Sidebar */}
      <div className={styles.orderSummary}>
        <h3 className={styles.summaryTitle}>Order Summary</h3>
        <div className={styles.summaryItem}>
          <span className={styles.summaryLabel}>Items</span>
          <span className={styles.summaryValue}>{summary.items}</span>
        </div>
        <div className={styles.summaryItem}>
          <span className={styles.summaryLabel}>Total Quantity</span>
          <span className={styles.summaryValue}>{summary.totalQuantity}</span>
        </div>
        <div className={styles.summaryItem}>
          <span className={styles.summaryLabel}>Subtotal</span>
          <span className={`${styles.summaryValue} ${styles.currencyAmount}`}>
            {currencySymbol}{formatNumber(summary.subtotal)}
          </span>
        </div>
        <div className={styles.summaryDivider} />
        <div className={styles.summaryTotal}>
          <span className={styles.summaryTotalLabel}>Total Amount</span>
          <span className={`${styles.summaryTotalValue} ${styles.currencyAmount}`}>
            {currencySymbol}{formatNumber(summary.subtotal)}
          </span>
        </div>
      </div>

      {/* ErrorMessage Component */}
      <ErrorMessage
        variant={messageState.variant}
        title={messageState.title}
        message={messageState.message}
        isOpen={messageState.isOpen}
        onClose={closeMessage}
      />
    </div>
  );
};
