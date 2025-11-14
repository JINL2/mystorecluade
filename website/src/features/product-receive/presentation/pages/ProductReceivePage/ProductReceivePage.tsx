/**
 * ProductReceivePage
 * Main page for product receiving
 */

import React, { useEffect } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { useAppState } from '@/app/providers/app_state_provider';
import { useProductReceive } from '../../hooks/useProductReceive';
import { OrderSelector } from '../../components/OrderSelector';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';
import { useErrorMessage } from '@/shared/hooks/useErrorMessage';
import styles from './ProductReceivePage.module.css';

export const ProductReceivePage: React.FC = () => {
  const { currentCompany, currentStore, setCurrentStore } = useAppState();
  const { messageState, closeMessage, showError, showSuccess } = useErrorMessage();

  const {
    orders,
    selectedOrder,
    selectOrder,
    loadingOrders,
    filteredProducts,
    productSearchTerm,
    setProductSearchTerm,
    scannedItems,
    skuInput,
    handleSkuInput,
    autocompleteResults,
    showAutocomplete,
    setShowAutocomplete,
    addScannedItem,
    updateScannedQuantity,
    removeScannedItem,
    clearAllScanned,
    submitReceive,
    submitting,
    error,
  } = useProductReceive(
    currentCompany?.company_id || '',
    currentStore?.store_id || null
  );

  const handleSubmit = async () => {
    const result = await submitReceive();
    if (result.success) {
      showSuccess({
        message: 'Products received successfully!',
        autoCloseDuration: 2000,
      });
    }
  };

  // Show error message when error occurs
  useEffect(() => {
    if (error) {
      showError({
        message: error,
      });
    }
  }, [error, showError]);

  // Calculate progress
  const totalItems = selectedOrder?.totalItems || 0;
  const receivedItems = selectedOrder?.receivedItems || 0;
  const remainingItems = selectedOrder?.remainingItems || 0;
  const progressPercentage = totalItems > 0 ? Math.round((receivedItems / totalItems) * 100) : 0;

  // Debug log
  console.log('📊 Progress Debug:', {
    selectedOrder,
    totalItems,
    receivedItems,
    remainingItems,
    progressPercentage,
    orderItems: selectedOrder?.items?.length || 0
  });

  // Progress ring SVG calculations
  const radius = 28;
  const circumference = 2 * Math.PI * radius;
  const strokeDashoffset = circumference - (progressPercentage / 100) * circumference;

  if (!currentCompany) {
    return (
      <>
        <Navbar activeItem="product" />
        <div className={styles.container}>
          <div className={styles.emptyState}>
            <p>Please select a company to receive products</p>
          </div>
        </div>
      </>
    );
  }

  return (
    <>
      <Navbar activeItem="product" />
      <div className={styles.container}>
        <div className={styles.pageContent}>
          <div className={styles.header}>
            <h1 className={styles.title}>Product Receive</h1>
            <p className={styles.subtitle}>Scan and receive products from purchase orders</p>
          </div>

          <div className={styles.controls}>
            {/* Store Selector */}
            <StoreSelector
              stores={currentCompany.stores || []}
              selectedStoreId={currentStore?.store_id || null}
              onStoreSelect={(storeId) => {
                if (storeId) {
                  const store = currentCompany.stores?.find(s => s.store_id === storeId);
                  setCurrentStore(store || null);
                } else {
                  setCurrentStore(null);
                }
              }}
              showAllStoresOption={false}
            />

            {/* Order Selector */}
            <OrderSelector
              orders={orders}
              selectedOrder={selectedOrder}
              onSelectOrder={selectOrder}
              loading={loadingOrders}
            />
          </div>

          {loadingOrders ? (
            <LoadingAnimation size="large" fullscreen />
          ) : !selectedOrder ? (
            <div className={styles.placeholder}>
              <div className={styles.placeholderIcon}>
                <svg fill="currentColor" viewBox="0 0 24 24">
                  <path d="M19,3H5A2,2 0 0,0 3,5V19A2,2 0 0,0 5,21H19A2,2 0 0,0 21,19V5A2,2 0 0,0 19,3M19,19H5V5H19V19Z" />
                </svg>
              </div>
              <h3>Select a Purchase Order</h3>
              <p>Choose an order above to begin receiving products</p>
            </div>
          ) : (
            <div className={styles.content}>
              {/* Left Column: Order Details */}
              <div className={styles.orderDetailsCard}>
                <div className={styles.orderSummary}>
                  <h2 className={styles.orderTitle}>Order Progress</h2>
                  <div className={styles.progressContainer}>
                    <div className={styles.progressRing}>
                      <svg width="60" height="60">
                        <circle
                          className={styles.progressRingCircle}
                          cx="30"
                          cy="30"
                          r={radius}
                        />
                        <circle
                          className={styles.progressRingProgress}
                          cx="30"
                          cy="30"
                          r={radius}
                          strokeDasharray={circumference}
                          strokeDashoffset={strokeDashoffset}
                        />
                      </svg>
                      <div className={styles.progressRingText}>{progressPercentage}%</div>
                    </div>
                    <div className={styles.progressStats}>
                      <div className={styles.progressStat}>
                        <span className={styles.progressStatLabel}>Received</span>
                        <span className={styles.progressStatValue}>{receivedItems}</span>
                      </div>
                      <div className={styles.progressStat}>
                        <span className={styles.progressStatLabel}>Remaining</span>
                        <span className={styles.progressStatValue}>{remainingItems}</span>
                      </div>
                      <div className={styles.progressStat}>
                        <span className={styles.progressStatLabel}>Total</span>
                        <span className={styles.progressStatValue}>{totalItems}</span>
                      </div>
                    </div>
                  </div>
                </div>

                {/* Products in Order List */}
                <div className={styles.productListSection}>
                  <h3 className={styles.productListTitle}>Products in Order</h3>
                  <input
                    type="text"
                    placeholder="Search products..."
                    value={productSearchTerm}
                    onChange={(e) => setProductSearchTerm(e.target.value)}
                    className={styles.productSearch}
                  />
                  <div className={styles.productList}>
                    {filteredProducts.map((product) => {
                      const productProgress = product.quantityOrdered > 0
                        ? Math.round((product.quantityReceived / product.quantityOrdered) * 100)
                        : 0;

                      return (
                        <div key={product.productId} className={styles.productItem}>
                          <div className={styles.productItemHeader}>
                            <span className={styles.productItemName}>{product.productName}</span>
                            <span
                              className={styles.productItemProgress}
                              style={{
                                color: productProgress === 100 ? 'var(--toss-green-500)' : 'var(--text-secondary)'
                              }}
                            >
                              {product.quantityReceived}/{product.quantityOrdered}
                            </span>
                          </div>
                          <div className={styles.productItemSku}>{product.sku}</div>
                        </div>
                      );
                    })}
                  </div>
                </div>
              </div>

              {/* Right Column: Scanner + Scanned Items */}
              <div className={styles.rightColumn}>
                {/* SKU Scanner */}
                <div className={styles.scannerCard}>
                  <h2 className={styles.sectionTitle}>Scan Product</h2>
                  <div className={styles.skuInputWrapper}>
                    <input
                      type="text"
                      value={skuInput}
                      onChange={(e) => handleSkuInput(e.target.value)}
                      onFocus={() => skuInput && setShowAutocomplete(true)}
                      placeholder="Scan or type SKU / Product name"
                      className={styles.skuInput}
                      autoFocus
                    />
                    {showAutocomplete && autocompleteResults.length > 0 && (
                      <div className={styles.autocomplete}>
                        {autocompleteResults.map((product) => (
                          <div
                            key={product.productId}
                            className={styles.autocompleteItem}
                            onClick={() => {
                              addScannedItem(product);
                              setShowAutocomplete(false);
                            }}
                          >
                            <div>
                              <div className={styles.productName}>{product.productName}</div>
                              <div className={styles.productSku}>{product.sku}</div>
                            </div>
                            <div className={styles.productStock}>
                              Remaining: {product.quantityRemaining}
                            </div>
                          </div>
                        ))}
                      </div>
                    )}
                  </div>
                </div>

                {/* Scanned Items */}
                <div className={styles.scannedCard}>
                  <div className={styles.scannedHeader}>
                    <h2 className={styles.sectionTitle}>Scanned Items</h2>
                    <span className={styles.badge}>{scannedItems.length} items</span>
                  </div>

                  {scannedItems.length === 0 ? (
                    <div className={styles.emptyScanned}>No items scanned yet</div>
                  ) : (
                    <>
                      <div className={styles.scannedList}>
                        {scannedItems.map((item) => (
                          <div key={item.sku} className={styles.scannedItem}>
                            <div className={styles.itemInfo}>
                              <div className={styles.itemName}>{item.productName}</div>
                              <div className={styles.itemSku}>{item.sku}</div>
                            </div>
                            <div className={styles.itemActions}>
                              <div className={styles.quantityControls}>
                                <button
                                  onClick={() =>
                                    updateScannedQuantity(item.sku, item.count - 1)
                                  }
                                  className={styles.qtyBtn}
                                >
                                  -
                                </button>
                                <span className={styles.qty}>{item.count}</span>
                                <button
                                  onClick={() =>
                                    updateScannedQuantity(item.sku, item.count + 1)
                                  }
                                  className={styles.qtyBtn}
                                >
                                  +
                                </button>
                              </div>
                              <button
                                onClick={() => removeScannedItem(item.sku)}
                                className={styles.removeBtn}
                              >
                                ×
                              </button>
                            </div>
                          </div>
                        ))}
                      </div>

                      <div className={styles.actions}>
                        <button
                          onClick={clearAllScanned}
                          className={styles.btnSecondary}
                          disabled={submitting}
                        >
                          Clear All
                        </button>
                        <button
                          onClick={handleSubmit}
                          className={styles.btnPrimary}
                          disabled={submitting || scannedItems.length === 0}
                        >
                          {submitting ? (
                            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '8px' }}>
                              <LoadingAnimation size="small" />
                              <span>Submitting...</span>
                            </div>
                          ) : (
                            'Submit Receive'
                          )}
                        </button>
                      </div>
                    </>
                  )}
                </div>
              </div>
            </div>
          )}
        </div>
      </div>

      {/* Unified Error/Success Message */}
      <ErrorMessage
        variant={messageState.variant}
        message={messageState.message}
        title={messageState.title}
        isOpen={messageState.isOpen}
        onClose={closeMessage}
        confirmText={messageState.confirmText}
        onConfirm={messageState.onConfirm}
        autoCloseDuration={messageState.autoCloseDuration}
      />
    </>
  );
};
