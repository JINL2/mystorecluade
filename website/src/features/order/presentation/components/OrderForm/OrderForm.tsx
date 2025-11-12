/**
 * OrderForm Component
 * New purchase order creation form
 * Uses Clean Architecture: Validator for validation logic
 */

import React, { useState, useEffect, useRef } from 'react';
import { useAppState } from '@/app/providers/app_state_provider';
import { useCounterparties } from '../../hooks/useCounterparties';
import { Counterparty } from '../../../data/models/CounterpartyModel';
import { useProducts } from '../../hooks/useProducts';
import { Product } from '../../../data/models/ProductModel';
import { OrderValidator } from '../../../domain/validators/OrderValidator';
import { OrderItem as DomainOrderItem } from '../../../domain/entities/Order';
import { useErrorMessage } from '@/shared/hooks/useErrorMessage';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import styles from './OrderForm.module.css';

interface OrderFormProps {
  onSuccess?: () => void;
  onCancel?: () => void;
}

interface SupplierInfo {
  name: string;
  contact: string;
  phone: string;
  email: string;
  address: string;
  bank_account: string;
  memo: string;
}

interface OrderItem {
  product_id: string;
  product_name: string;
  sku: string;
  unit: string;
  quantity: number;
  unit_price: number;
  subtotal: number;
}

type SupplierTabType = 'counter-party' | 'others';

export const OrderForm: React.FC<OrderFormProps> = ({ onSuccess, onCancel }) => {
  const { currentCompany } = useAppState();
  const { counterparties, loading: loadingCounterparties, error: counterpartiesError } = useCounterparties(currentCompany?.company_id || null);
  const { products, loading: loadingProducts, currencySymbol, searchProducts, getProductById, error: productsError } = useProducts(currentCompany?.company_id || null);
  const { messageState, closeMessage, showError, showSuccess } = useErrorMessage();
  const dropdownRef = useRef<HTMLDivElement>(null);
  const searchRef = useRef<HTMLDivElement>(null);

  // Form state
  const [orderDate, setOrderDate] = useState<string>('');
  const [notes, setNotes] = useState<string>('');
  const [supplierTab, setSupplierTab] = useState<SupplierTabType>('counter-party');
  const [selectedSupplier, setSelectedSupplier] = useState<Counterparty | null>(null);
  const [isDropdownOpen, setIsDropdownOpen] = useState(false);
  const [supplierInfo, setSupplierInfo] = useState<SupplierInfo>({
    name: '',
    contact: '',
    phone: '',
    email: '',
    address: '',
    bank_account: '',
    memo: '',
  });
  const [orderItems, setOrderItems] = useState<OrderItem[]>([]);
  const [isCreating, setIsCreating] = useState(false);

  // Product search state
  const [searchTerm, setSearchTerm] = useState<string>('');
  const [showSuggestions, setShowSuggestions] = useState(false);
  const [searchResults, setSearchResults] = useState<Product[]>([]);

  // Initialize order date to today
  useEffect(() => {
    const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const day = String(today.getDate()).padStart(2, '0');
    setOrderDate(`${year}-${month}-${day}`);
  }, []);

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
  }, [isDropdownOpen, showSuggestions]);

  // Handle supplier selection
  const handleSupplierSelect = (supplier: Counterparty) => {
    setSelectedSupplier(supplier);
    setIsDropdownOpen(false);
  };

  // Handle supplier tab change
  const handleSupplierTabChange = (tab: SupplierTabType) => {
    setSupplierTab(tab);
    if (tab === 'others') {
      setSelectedSupplier(null);
    } else {
      setSupplierInfo({
        name: '',
        contact: '',
        phone: '',
        email: '',
        address: '',
        bank_account: '',
        memo: '',
      });
    }
  };

  // Handle product search
  const handleSearchChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const value = e.target.value;
    setSearchTerm(value);

    if (value.length >= 1) {
      const results = searchProducts(value).slice(0, 10); // Limit to 10 results
      setSearchResults(results);
      setShowSuggestions(true);
    } else {
      setSearchResults([]);
      setShowSuggestions(false);
    }
  };

  // Add product to order items
  const handleAddProduct = (product: Product) => {
    // Check if product already exists in order items
    const existingItem = orderItems.find((item) => item.product_id === product.product_id);

    if (existingItem) {
      // If exists, increment quantity
      setOrderItems((items) =>
        items.map((item) =>
          item.product_id === product.product_id
            ? { ...item, quantity: item.quantity + 1, subtotal: (item.quantity + 1) * item.unit_price }
            : item
        )
      );
    } else {
      // If not exists, add new item
      const newItem: OrderItem = {
        product_id: product.product_id,
        product_name: product.product_name,
        sku: product.sku || '',
        unit: product.unit_of_measure || 'Unit',
        quantity: 1,
        unit_price: product.pricing?.selling_price || 0,
        subtotal: product.pricing?.selling_price || 0,
      };
      setOrderItems((items) => [...items, newItem]);
    }

    // Clear search
    setSearchTerm('');
    setShowSuggestions(false);
  };

  // Format number with thousand separators (integer only, following backup pattern)
  const formatNumber = (value: number): string => {
    return Math.round(value).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
  };

  // Parse formatted number string to number
  const parseFormattedNumber = (value: string): number => {
    const cleaned = value.replace(/,/g, '');
    return parseFloat(cleaned) || 0;
  };

  // Update order item quantity
  const handleQuantityChange = (productId: string, value: string) => {
    const quantity = parseInt(value.replace(/,/g, '')) || 0;
    setOrderItems((items) =>
      items.map((item) =>
        item.product_id === productId
          ? { ...item, quantity, subtotal: quantity * item.unit_price }
          : item
      )
    );
  };

  // Update order item unit price
  const handlePriceChange = (productId: string, value: string) => {
    const unitPrice = parseFloat(value.replace(/,/g, '')) || 0;
    setOrderItems((items) =>
      items.map((item) =>
        item.product_id === productId
          ? { ...item, unit_price: unitPrice, subtotal: item.quantity * unitPrice }
          : item
      )
    );
  };

  // Remove order item
  const handleRemoveItem = (productId: string) => {
    setOrderItems((items) => items.filter((item) => item.product_id !== productId));
  };

  // Calculate summary
  const summary = {
    items: orderItems.length,
    totalQuantity: orderItems.reduce((sum, item) => sum + item.quantity, 0),
    subtotal: orderItems.reduce((sum, item) => sum + item.subtotal, 0),
  };

  // Validate form using OrderValidator
  const isValid = () => {
    // Convert orderItems to DomainOrderItem format for validation
    const domainItems: DomainOrderItem[] = orderItems.map(item => ({
      product_id: item.product_id,
      product_name: item.product_name,
      sku: item.sku,
      barcode: undefined,
      quantity_ordered: item.quantity,
      quantity_received_total: undefined,
      quantity_remaining: undefined,
      unit_price: item.unit_price,
      total_amount: item.subtotal,
    }));

    return OrderValidator.isValidOrderForm(
      orderDate,
      supplierTab,
      selectedSupplier?.counterparty_id || null,
      supplierTab === 'others' ? supplierInfo : null,
      domainItems
    );
  };

  // Handle create order
  const handleCreateOrder = async () => {
    if (!currentCompany) return;

    // Validate form
    const domainItems: DomainOrderItem[] = orderItems.map(item => ({
      product_id: item.product_id,
      product_name: item.product_name,
      sku: item.sku,
      barcode: undefined,
      quantity_ordered: item.quantity,
      quantity_received_total: undefined,
      quantity_remaining: undefined,
      unit_price: item.unit_price,
      total_amount: item.subtotal,
    }));

    const validationErrors = OrderValidator.validateOrderForm(
      orderDate,
      supplierTab,
      selectedSupplier?.counterparty_id || null,
      supplierTab === 'others' ? supplierInfo : null,
      domainItems
    );

    if (validationErrors.length > 0) {
      // Show validation errors to user using ErrorMessage
      const errorMessage = validationErrors.map(err => err.message).join('\n');
      showError({
        title: 'Validation Failed',
        message: errorMessage,
      });
      return;
    }

    setIsCreating(true);
    // TODO: Implement RPC call
    setIsCreating(false);
  };

  // Handle cancel
  const handleCancel = () => {
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
                              onClick={() => handleSupplierSelect(supplier)}
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
                    onChange={(e) => setSupplierInfo({ ...supplierInfo, name: e.target.value })}
                  />
                </div>
                <div className={styles.formGroup}>
                  <label className={styles.formLabel}>Contact Person</label>
                  <input
                    type="text"
                    className={styles.formInput}
                    placeholder="Enter contact name"
                    value={supplierInfo.contact}
                    onChange={(e) => setSupplierInfo({ ...supplierInfo, contact: e.target.value })}
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
                    onChange={(e) => setSupplierInfo({ ...supplierInfo, phone: e.target.value })}
                  />
                </div>
                <div className={styles.formGroup}>
                  <label className={styles.formLabel}>Email</label>
                  <input
                    type="email"
                    className={styles.formInput}
                    placeholder="Enter email address"
                    value={supplierInfo.email}
                    onChange={(e) => setSupplierInfo({ ...supplierInfo, email: e.target.value })}
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
                    onChange={(e) => setSupplierInfo({ ...supplierInfo, address: e.target.value })}
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
                    onChange={(e) => setSupplierInfo({ ...supplierInfo, bank_account: e.target.value })}
                  />
                </div>
                <div className={styles.formGroup}>
                  <label className={styles.formLabel}>Memo</label>
                  <textarea
                    className={styles.formInput}
                    rows={2}
                    placeholder="Enter any additional notes..."
                    value={supplierInfo.memo}
                    onChange={(e) => setSupplierInfo({ ...supplierInfo, memo: e.target.value })}
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
                      const price = product.pricing?.selling_price || 0;
                      const stock = product.total_stock_summary?.total_quantity_on_hand || 0;
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
                          onClick={() => handleRemoveItem(item.product_id)}
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
            disabled={!isValid() || isCreating}
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
