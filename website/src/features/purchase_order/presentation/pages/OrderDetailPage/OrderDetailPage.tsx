/**
 * OrderDetailPage Component
 * View purchase order details with items, supplier info, and shipment status
 */

import React from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { ConfirmModal } from '@/shared/components/common/ConfirmModal';
import { useOrderDetail, formatDateTime } from '../../hooks/useOrderDetail';
import styles from './OrderDetailPage.module.css';

export const OrderDetailPage: React.FC = () => {
  const {
    orderDetail,
    isLoading,
    error,
    formatPrice,
    getStatusBadgeClass,
    handleBack,
    isCancelModalOpen,
    isCancelling,
    openCancelModal,
    closeCancelModal,
    handleCancelOrder,
  } = useOrderDetail();

  // Render loading state
  if (isLoading) {
    return (
      <>
        <Navbar activeItem="product" />
        <div className={styles.pageLayout}>
          <LoadingAnimation fullscreen size="large" />
        </div>
      </>
    );
  }

  // Render error state
  if (error || !orderDetail) {
    return (
      <>
        <Navbar activeItem="product" />
        <div className={styles.pageLayout}>
          <div className={styles.container}>
            <div className={styles.errorState}>
              <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                <circle cx="12" cy="12" r="10" />
                <line x1="12" y1="8" x2="12" y2="12" />
                <line x1="12" y1="16" x2="12.01" y2="16" />
              </svg>
              <h2>Failed to Load Order</h2>
              <p>{error || 'Order not found'}</p>
              <button className={styles.backButton} onClick={handleBack}>
                Back to Orders
              </button>
            </div>
          </div>
        </div>
      </>
    );
  }

  return (
    <>
      <Navbar activeItem="product" />
      <div className={styles.pageLayout}>
        <div className={styles.container}>
          {/* Page Header */}
          <div className={styles.header}>
            <div className={styles.headerLeft}>
              <button className={styles.backButtonIcon} onClick={handleBack}>
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <path d="M19 12H5M12 19l-7-7 7-7" />
                </svg>
              </button>
              <div>
                <h1 className={styles.title}>{orderDetail.order_number}</h1>
                <p className={styles.subtitle}>
                  Created on {formatDateTime(orderDetail.created_at)}
                </p>
              </div>
            </div>
            <div className={styles.headerRight}>
              <span className={getStatusBadgeClass(orderDetail.order_status, styles)}>
                {orderDetail.order_status}
              </span>
              <span className={getStatusBadgeClass(orderDetail.receiving_status, styles)}>
                {orderDetail.receiving_status}
              </span>
              {orderDetail.order_status !== 'cancelled' && orderDetail.order_status !== 'complete' && (
                <button className={styles.cancelOrderButton} onClick={openCancelModal}>
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <circle cx="12" cy="12" r="10" />
                    <line x1="15" y1="9" x2="9" y2="15" />
                    <line x1="9" y1="9" x2="15" y2="15" />
                  </svg>
                  Cancel Order
                </button>
              )}
            </div>
          </div>

          {/* Main Content */}
          <div className={styles.content}>
            {/* Order Info Section */}
            <div className={styles.section}>
              <h2 className={styles.sectionTitle}>Order Information</h2>
              <div className={styles.infoGrid}>
                <div className={styles.infoItem}>
                  <span className={styles.infoLabel}>Order Date</span>
                  <span className={styles.infoValue}>{formatDateTime(orderDetail.order_date)}</span>
                </div>
                <div className={styles.infoItem}>
                  <span className={styles.infoLabel}>Total Amount</span>
                  <span className={styles.infoValueHighlight}>{formatPrice(orderDetail.total_amount)}</span>
                </div>
                <div className={styles.infoItem}>
                  <span className={styles.infoLabel}>Fulfilled</span>
                  <span className={styles.infoValue}>{orderDetail.fulfilled_percentage}%</span>
                </div>
                <div className={styles.infoItem}>
                  <span className={styles.infoLabel}>Shipments</span>
                  <span className={styles.infoValue}>{orderDetail.shipment_count}</span>
                </div>
              </div>
              {orderDetail.notes && (
                <div className={styles.notesSection}>
                  <span className={styles.infoLabel}>Notes</span>
                  <p className={styles.notesText}>{orderDetail.notes}</p>
                </div>
              )}
            </div>

            {/* Supplier Section */}
            <div className={styles.section}>
              <h2 className={styles.sectionTitle}>
                Supplier Information
                {!orderDetail.is_registered_supplier && (
                  <span className={styles.oneTimeBadge}>One-time</span>
                )}
              </h2>
              <div className={styles.supplierCard}>
                <div className={styles.supplierName}>{orderDetail.supplier_name}</div>
                {orderDetail.supplier_phone && (
                  <div className={styles.supplierInfo}>
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                      <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z" />
                    </svg>
                    <span>{orderDetail.supplier_phone}</span>
                  </div>
                )}
                {orderDetail.supplier_email && (
                  <div className={styles.supplierInfo}>
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                      <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z" />
                      <polyline points="22,6 12,13 2,6" />
                    </svg>
                    <span>{orderDetail.supplier_email}</span>
                  </div>
                )}
                {orderDetail.supplier_address && (
                  <div className={styles.supplierInfo}>
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                      <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" />
                      <circle cx="12" cy="10" r="3" />
                    </svg>
                    <span>{orderDetail.supplier_address}</span>
                  </div>
                )}
              </div>
            </div>

            {/* Order Items Section */}
            <div className={styles.section}>
              <h2 className={styles.sectionTitle}>
                Order Items
                <span className={styles.itemCount}>({orderDetail.items.length} items)</span>
              </h2>
              <div className={styles.tableContainer}>
                <table className={styles.itemsTable}>
                  <thead>
                    <tr>
                      <th>Product</th>
                      <th>SKU</th>
                      <th>Unit Price</th>
                      <th>Ordered</th>
                      <th>Fulfilled</th>
                      <th>Total</th>
                    </tr>
                  </thead>
                  <tbody>
                    {orderDetail.items.map((item) => (
                      <tr key={`${item.item_id}-${item.variant_id || 'base'}`}>
                        <td className={styles.productName}>{item.display_name}</td>
                        <td className={styles.sku}>{item.sku}</td>
                        <td>{formatPrice(item.unit_price)}</td>
                        <td>{item.quantity_ordered}</td>
                        <td>
                          <span className={item.quantity_fulfilled >= item.quantity_ordered ? styles.fulfilledComplete : styles.fulfilledPartial}>
                            {item.quantity_fulfilled}
                          </span>
                        </td>
                        <td className={styles.totalAmount}>{formatPrice(item.total_amount)}</td>
                      </tr>
                    ))}
                  </tbody>
                  <tfoot>
                    <tr>
                      <td colSpan={5} className={styles.totalLabel}>Total Amount</td>
                      <td className={styles.grandTotal}>{formatPrice(orderDetail.total_amount)}</td>
                    </tr>
                  </tfoot>
                </table>
              </div>
            </div>

            {/* Shipments Section */}
            {orderDetail.has_shipments && (
              <div className={styles.section}>
                <h2 className={styles.sectionTitle}>
                  Linked Shipments
                  <span className={styles.itemCount}>({orderDetail.shipment_count})</span>
                </h2>
                <div className={styles.shipmentList}>
                  {orderDetail.shipments.map((shipment) => (
                    <div key={shipment.shipment_id} className={styles.shipmentCard}>
                      <span className={styles.shipmentNumber}>{shipment.shipment_number}</span>
                      <span className={getStatusBadgeClass(shipment.status, styles)}>{shipment.status}</span>
                    </div>
                  ))}
                </div>
              </div>
            )}

            {/* Progress Section */}
            <div className={styles.section}>
              <h2 className={styles.sectionTitle}>Fulfillment Progress</h2>
              <div className={styles.progressContainer}>
                <div className={styles.progressBar}>
                  <div
                    className={`${styles.progressFill} ${orderDetail.fulfilled_percentage >= 100 ? styles.complete : ''}`}
                    style={{ width: `${Math.min(orderDetail.fulfilled_percentage, 100)}%` }}
                  />
                </div>
                <span className={styles.progressText}>{orderDetail.fulfilled_percentage}%</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Cancel Order Confirmation Modal */}
      <ConfirmModal
        isOpen={isCancelModalOpen}
        onClose={closeCancelModal}
        onConfirm={handleCancelOrder}
        variant="error"
        title="Cancel Order"
        message="Are you sure you want to cancel this order? This action cannot be undone."
        confirmText="Cancel Order"
        cancelText="Go Back"
        confirmButtonVariant="error"
        isLoading={isCancelling}
      />
    </>
  );
};

export default OrderDetailPage;
