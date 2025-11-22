/**
 * PaymentModal Component
 * Modal for completing sale invoice with payment details
 */

import React, { useEffect } from 'react';
import { useSaleInvoice } from '../../hooks/useSaleInvoice';
import { TossSelector } from '../../../../../shared/components/selectors/TossSelector/TossSelector';
import { LoadingAnimation } from '../../../../../shared/components/common/LoadingAnimation/LoadingAnimation';
import { PaymentModalProps } from './PaymentModal.types';
import styles from './PaymentModal.module.css';

export const PaymentModal: React.FC<PaymentModalProps> = ({
  companyId,
  storeId,
  currencySymbol,
}) => {
  // Get state and actions from Zustand store
  const {
    cartItems,
    subtotal,
    discountType,
    discountValue,
    discountAmount,
    total,
    exchangeRates,
    cashLocations,
    loadingRates,
    loadingLocations,
    submitting,
    error,
    selectedCashLocationId,
    setDiscountType,
    setDiscountValue,
    setSelectedCashLocation,
    closePaymentModal,
    submitInvoice,
    loadModalData,
  } = useSaleInvoice();

  // Load modal data on mount
  useEffect(() => {
    loadModalData(companyId, storeId);
  }, [companyId, storeId, loadModalData]);

  // Handle discount type toggle
  const handleDiscountTypeToggle = () => {
    const newType = discountType === 'amount' ? 'percent' : 'amount';
    setDiscountType(newType);
    // Reset discount value when changing type
    setDiscountValue(0);
  };

  // Handle discount value change
  const handleDiscountValueChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const value = e.target.value;

    // Allow empty string for deletion
    if (value === '') {
      setDiscountValue(0);
      return;
    }

    const numValue = parseFloat(value);
    if (!isNaN(numValue) && numValue >= 0) {
      setDiscountValue(numValue);
    }
  };

  // Handle cash location selection
  const handleCashLocationSelect = (locationId: string) => {
    setSelectedCashLocation(locationId);
  };

  // Handle invoice submission
  const handleSubmit = async () => {
    const result = await submitInvoice(companyId, storeId);

    if (result.success) {
      // Success - modal will close automatically via reset()
      alert(`Invoice created successfully! Invoice ID: ${result.invoiceId}`);
    } else {
      // Error will be displayed via error state
      alert(`Failed to create invoice: ${result.error}`);
    }
  };

  // Helper functions for cash location badges
  const getLocationTypeBgColor = (type: string): string => {
    switch (type) {
      case 'cash':
        return '#E8F5E9'; // Green-50
      case 'bank':
        return '#E3F2FD'; // Blue-50
      case 'vault':
        return '#E0E0E0'; // Gray-300
      default:
        return '#F5F5F5';
    }
  };

  const getLocationTypeTextColor = (type: string): string => {
    switch (type) {
      case 'cash':
        return '#2E7D32'; // Green-700
      case 'bank':
        return '#1565C0'; // Blue-700
      case 'vault':
        return '#616161'; // Gray-700
      default:
        return '#616161';
    }
  };

  return (
    <div className={styles.modalOverlay} onClick={closePaymentModal}>
      <div className={styles.modalContent} onClick={(e) => e.stopPropagation()}>
        <div className={styles.modalHeader}>
          <h2>Complete Sale</h2>
          <button className={styles.closeBtn} onClick={closePaymentModal}>
            ✕
          </button>
        </div>

        <div className={styles.modalBody}>
          {/* Selected Products */}
          <div className={styles.section}>
            <h3 className={styles.sectionTitle}>Selected Products</h3>
            <div className={styles.productsList}>
              {cartItems.map((item) => (
                <div key={item.productId} className={styles.productItem}>
                  <div className={styles.productInfo}>
                    <span className={styles.productName}>{item.productName}</span>
                    <span className={styles.productSku}>({item.sku})</span>
                  </div>
                  <div className={styles.productDetails}>
                    <span className={styles.quantity}>Qty: {item.quantity}</span>
                    <span className={styles.price}>
                      {currencySymbol}
                      {item.totalPrice.toLocaleString()}
                    </span>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Sub-total */}
          <div className={styles.section}>
            <div className={styles.totalRow}>
              <span className={styles.label}>Sub-total:</span>
              <span className={styles.value}>
                {currencySymbol}
                {subtotal.toLocaleString()}
              </span>
            </div>
          </div>

          {/* Discount */}
          <div className={styles.section}>
            <h3 className={styles.sectionTitle}>Discount</h3>
            <div className={styles.discountSection}>
              <button
                className={`${styles.discountTypeBtn} ${
                  discountType === 'amount' ? styles.active : ''
                }`}
                onClick={handleDiscountTypeToggle}
              >
                Amount
              </button>
              <button
                className={`${styles.discountTypeBtn} ${
                  discountType === 'percent' ? styles.active : ''
                }`}
                onClick={handleDiscountTypeToggle}
              >
                Percent
              </button>
              <input
                type="number"
                className={styles.discountInput}
                value={discountValue === 0 ? '' : discountValue}
                onChange={handleDiscountValueChange}
                placeholder="0"
                min="0"
                step={discountType === 'percent' ? '1' : '0.01'}
              />
              {discountType === 'percent' && (
                <span className={styles.percentSymbol}>%</span>
              )}
            </div>
            {discountAmount > 0 && (
              <div className={styles.discountAmount}>
                Discount: -{currencySymbol}
                {discountAmount.toLocaleString()}
              </div>
            )}
          </div>

          {/* Total */}
          <div className={styles.section}>
            <div className={styles.totalRow}>
              <span className={styles.totalLabel}>Total:</span>
              <span className={styles.totalValue}>
                {currencySymbol}
                {total.toLocaleString()}
              </span>
            </div>
          </div>

          {/* Cash Location Selection */}
          <div className={styles.section}>
            <h3 className={styles.sectionTitle}>Cash Location</h3>
            {loadingLocations ? (
              <LoadingAnimation />
            ) : (
              <TossSelector
                options={cashLocations.map((location) => ({
                  value: location.id,
                  label: location.name,
                  description: location.type.toUpperCase(),
                  descriptionBgColor: getLocationTypeBgColor(location.type),
                  descriptionColor: getLocationTypeTextColor(location.type),
                }))}
                value={selectedCashLocationId}
                onChange={handleCashLocationSelect}
                placeholder="Select cash location"
                showDescriptions={true}
              />
            )}
          </div>

          {/* Currency Conversion */}
          {exchangeRates.length > 0 && (
            <div className={styles.section}>
              <h3 className={styles.sectionTitle}>Currency Conversion</h3>
              {loadingRates ? (
                <LoadingAnimation />
              ) : (
                <div className={styles.currencyButtons}>
                  {exchangeRates.map((rate) => (
                    <div key={rate.id} className={styles.currencyItem}>
                      <button className={styles.currencyBtn}>
                        <span className={styles.currencyCode}>
                          {rate.currencyCode}
                        </span>
                        <span className={styles.convertedAmount}>
                          {rate.currencySymbol}
                          {rate.convertAmount(total).toLocaleString(undefined, {
                            minimumFractionDigits: 2,
                            maximumFractionDigits: 2,
                          })}
                        </span>
                      </button>
                      <div className={styles.exchangeRate}>
                        {rate.formatRate(currencySymbol)}
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          )}

          {/* Error Display */}
          {error && (
            <div className={styles.errorMessage}>
              <span>⚠️ {error}</span>
            </div>
          )}
        </div>

        {/* Modal Footer */}
        <div className={styles.modalFooter}>
          <button
            className={styles.cancelBtn}
            onClick={closePaymentModal}
            disabled={submitting}
          >
            Cancel
          </button>
          <button
            className={styles.confirmBtn}
            onClick={handleSubmit}
            disabled={submitting || cartItems.length === 0 || !selectedCashLocationId}
          >
            {submitting ? 'Processing...' : 'Confirm'}
          </button>
        </div>
      </div>
    </div>
  );
};

export default PaymentModal;
