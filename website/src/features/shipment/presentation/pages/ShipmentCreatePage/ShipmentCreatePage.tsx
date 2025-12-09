/**
 * ShipmentCreatePage Component
 * Create new shipment with items from existing orders
 */

import React from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { TossSelector } from '@/shared/components/selectors/TossSelector';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { useShipmentCreate } from '../../hooks/useShipmentCreate';
import styles from './ShipmentCreatePage.module.css';

export const ShipmentCreatePage: React.FC = () => {
  const {
    currency,
    formatPrice,
    suppliersLoading,
    supplierOptions,
    selectedSupplier,
    handleSupplierChange,
    ordersLoading,
    orderOptions,
    selectedOrder,
    handleOrderChange,
    orderItems,
    orderItemsLoading,
    shipmentItems,
    totalAmount,
    handleAddItem,
    handleAddAllItems,
    handleRemoveItem,
    handleQuantityChange,
    shippedDate,
    setShippedDate,
    trackingNumber,
    setTrackingNumber,
    note,
    setNote,
    isSaving,
    saveResult,
    handleSave,
    handleSaveResultClose,
    isSaveDisabled,
    handleCancel,
  } = useShipmentCreate();

  return (
    <>
      <Navbar activeItem="product" />
      <div className={styles.pageLayout}>
        <div className={styles.container}>
          {/* Page Header */}
          <div className={styles.header}>
            <div className={styles.headerLeft}>
              <button className={styles.backButton} onClick={handleCancel}>
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <path d="M19 12H5M12 19l-7-7 7-7" />
                </svg>
              </button>
              <div>
                <h1 className={styles.title}>Create Shipment</h1>
                <p className={styles.subtitle}>Add items from existing orders to create a shipment</p>
              </div>
            </div>
          </div>

          {/* Main Content */}
          <div className={styles.content}>
            {/* Supplier & Order Selection Section */}
            <div className={styles.section}>
              <h2 className={styles.sectionTitle}>
                <span className={styles.sectionNumber}>1</span>
                Select Supplier & Order
              </h2>
              <div className={styles.sectionContent}>
                <div className={styles.selectionRow}>
                  <div className={styles.selectGroup}>
                    <label className={styles.label}>
                      Supplier <span className={styles.required}>*</span>
                    </label>
                    <TossSelector
                      placeholder={suppliersLoading ? 'Loading suppliers...' : 'Select a supplier'}
                      value={selectedSupplier ?? undefined}
                      options={supplierOptions}
                      onChange={(value) => handleSupplierChange(value || null)}
                      searchable
                      fullWidth
                      disabled={suppliersLoading}
                    />
                  </div>
                  <div className={styles.selectGroup}>
                    <label className={styles.label}>Order</label>
                    <TossSelector
                      placeholder={
                        !selectedSupplier
                          ? 'Select supplier first'
                          : ordersLoading
                            ? 'Loading orders...'
                            : 'Select an order'
                      }
                      value={selectedOrder ?? undefined}
                      options={orderOptions}
                      onChange={(value) => handleOrderChange(value || null)}
                      searchable
                      fullWidth
                      disabled={!selectedSupplier || ordersLoading}
                    />
                  </div>
                </div>

                {/* Order Items List */}
                {selectedOrder && (
                  <div className={styles.orderItemsSection}>
                    <div className={styles.orderItemsHeader}>
                      <h3 className={styles.orderItemsTitle}>Available Items</h3>
                      {orderItems.length > 0 && (
                        <button className={styles.addAllButton} onClick={handleAddAllItems}>
                          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                            <line x1="12" y1="5" x2="12" y2="19" />
                            <line x1="5" y1="12" x2="19" y2="12" />
                          </svg>
                          Add All
                        </button>
                      )}
                    </div>

                    {orderItemsLoading ? (
                      <div className={styles.loadingState}>
                        <div className={styles.spinner} />
                        <p>Loading items...</p>
                      </div>
                    ) : orderItems.length === 0 ? (
                      <div className={styles.emptyState}>
                        <p>No items available for shipment</p>
                      </div>
                    ) : (
                      <div className={styles.orderItemsList}>
                        {orderItems.map((item) => {
                          const isAdded = shipmentItems.some((si) => si.orderItemId === item.order_item_id);
                          return (
                            <div key={item.order_item_id} className={styles.orderItemRow}>
                              <div className={styles.orderItemInfo}>
                                <span className={styles.orderItemName}>{item.product_name}</span>
                                <span className={styles.orderItemSku}>{item.sku}</span>
                              </div>
                              <div className={styles.orderItemQty}>
                                <span>Remaining: {item.remaining_quantity}</span>
                              </div>
                              <button
                                className={`${styles.addItemButton} ${isAdded ? styles.added : ''}`}
                                onClick={() => handleAddItem(item)}
                                disabled={isAdded}
                              >
                                {isAdded ? 'Added' : 'Add'}
                              </button>
                            </div>
                          );
                        })}
                      </div>
                    )}
                  </div>
                )}
              </div>
            </div>

            {/* Shipment Items Section */}
            <div className={styles.section}>
              <h2 className={styles.sectionTitle}>
                <span className={styles.sectionNumber}>2</span>
                Shipment Items
              </h2>
              <div className={styles.sectionContent}>
                {shipmentItems.length === 0 ? (
                  <div className={styles.emptyState}>
                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                      <rect x="1" y="3" width="15" height="13" rx="2" />
                      <path d="M16 8h4l3 3v5a2 2 0 0 1-2 2h-5" />
                      <circle cx="5.5" cy="18.5" r="2.5" />
                      <circle cx="18.5" cy="18.5" r="2.5" />
                    </svg>
                    <p>No items added yet</p>
                    <span>Select an order and add items to create a shipment</span>
                  </div>
                ) : (
                  <>
                    <div className={styles.itemsTable}>
                      <div className={styles.tableHeader}>
                        <div className={styles.colProduct}>Product</div>
                        <div className={styles.colOrder}>Order #</div>
                        <div className={styles.colQuantity}>Quantity</div>
                        <div className={styles.colPrice}>Unit Price</div>
                        <div className={styles.colTotal}>Total</div>
                        <div className={styles.colAction}></div>
                      </div>
                      <div className={styles.tableBody}>
                        {shipmentItems.map((item) => (
                          <div key={item.orderItemId} className={styles.tableRow}>
                            <div className={styles.colProduct}>
                              <span className={styles.productName}>{item.productName}</span>
                              <span className={styles.productSku}>{item.sku}</span>
                            </div>
                            <div className={styles.colOrder}>{item.orderNumber}</div>
                            <div className={styles.colQuantity}>
                              <input
                                type="number"
                                className={styles.quantityInput}
                                value={item.quantity}
                                min={1}
                                max={item.maxQuantity}
                                onChange={(e) =>
                                  handleQuantityChange(item.orderItemId, parseInt(e.target.value) || 1)
                                }
                              />
                              <span className={styles.maxQty}>/ {item.maxQuantity}</span>
                            </div>
                            <div className={styles.colPrice}>{formatPrice(item.unitPrice)}</div>
                            <div className={styles.colTotal}>
                              {formatPrice(item.quantity * item.unitPrice)}
                            </div>
                            <div className={styles.colAction}>
                              <button
                                className={styles.removeButton}
                                onClick={() => handleRemoveItem(item.orderItemId)}
                              >
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                  <path d="M18 6L6 18M6 6l12 12" />
                                </svg>
                              </button>
                            </div>
                          </div>
                        ))}
                      </div>
                    </div>

                    <div className={styles.totalSection}>
                      <div className={styles.totalRow}>
                        <span>Total Items:</span>
                        <span>{shipmentItems.reduce((sum, item) => sum + item.quantity, 0)}</span>
                      </div>
                      <div className={styles.totalRow}>
                        <span>Total Amount:</span>
                        <span className={styles.totalAmount}>{formatPrice(totalAmount)}</span>
                      </div>
                    </div>
                  </>
                )}
              </div>
            </div>

            {/* Shipment Details Section */}
            <div className={styles.section}>
              <h2 className={styles.sectionTitle}>
                <span className={styles.sectionNumber}>3</span>
                Shipment Details
              </h2>
              <div className={styles.sectionContent}>
                <div className={styles.detailsRow}>
                  <div className={styles.formGroup}>
                    <label className={styles.label}>
                      Shipped Date <span className={styles.required}>*</span>
                    </label>
                    <input
                      type="date"
                      className={styles.input}
                      value={shippedDate}
                      onChange={(e) => setShippedDate(e.target.value)}
                    />
                  </div>
                  <div className={styles.formGroup}>
                    <label className={styles.label}>Tracking Number</label>
                    <input
                      type="text"
                      className={styles.input}
                      placeholder="Enter tracking number (optional)"
                      value={trackingNumber}
                      onChange={(e) => setTrackingNumber(e.target.value)}
                    />
                  </div>
                </div>
                <div className={styles.formGroup}>
                  <label className={styles.label}>Notes</label>
                  <textarea
                    className={styles.noteTextarea}
                    placeholder="Add any notes for this shipment..."
                    value={note}
                    onChange={(e) => setNote(e.target.value)}
                    rows={3}
                  />
                </div>
              </div>
            </div>

            {/* Footer Actions */}
            <div className={styles.footerActions}>
              <button className={styles.cancelButton} onClick={handleCancel} disabled={isSaving}>
                Cancel
              </button>
              <button
                className={styles.saveButton}
                onClick={handleSave}
                disabled={isSaveDisabled}
              >
                Create Shipment
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Fullscreen Loading Animation */}
      {isSaving && <LoadingAnimation fullscreen size="large" />}

      {/* Save Result Message */}
      <ErrorMessage
        variant={saveResult.success ? 'success' : 'error'}
        title={saveResult.success ? 'Shipment Created' : 'Error'}
        message={saveResult.message}
        isOpen={saveResult.show}
        onClose={handleSaveResultClose}
        confirmText="OK"
      />
    </>
  );
};

export default ShipmentCreatePage;
