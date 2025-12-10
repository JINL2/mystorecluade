/**
 * ShipmentDetailPage Component
 * View shipment details with items, supplier info, and linked orders
 */

import React from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { useShipmentDetail, formatDateTime } from '../../hooks/useShipmentDetail';
import styles from './ShipmentDetailPage.module.css';

export const ShipmentDetailPage: React.FC = () => {
  const {
    shipmentDetail,
    isLoading,
    error,
    formatPrice,
    getStatusBadgeClass,
    handleBack,
  } = useShipmentDetail();

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
  if (error || !shipmentDetail) {
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
              <h2>Failed to Load Shipment</h2>
              <p>{error || 'Shipment not found'}</p>
              <button className={styles.backButton} onClick={handleBack}>
                Back to Shipments
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
                <h1 className={styles.title}>{shipmentDetail.shipment_number}</h1>
                <p className={styles.subtitle}>
                  Created on {formatDateTime(shipmentDetail.created_at)}
                </p>
              </div>
            </div>
            <div className={styles.headerRight}>
              <span className={getStatusBadgeClass(shipmentDetail.status, styles)}>
                {shipmentDetail.status}
              </span>
            </div>
          </div>

          {/* Main Content */}
          <div className={styles.content}>
            {/* Shipment Info Section */}
            <div className={styles.section}>
              <h2 className={styles.sectionTitle}>Shipment Information</h2>
              <div className={styles.infoGrid}>
                <div className={styles.infoItem}>
                  <span className={styles.infoLabel}>Shipped Date</span>
                  <span className={styles.infoValue}>{formatDateTime(shipmentDetail.shipped_date)}</span>
                </div>
                <div className={styles.infoItem}>
                  <span className={styles.infoLabel}>Total Amount</span>
                  <span className={styles.infoValueHighlight}>{formatPrice(shipmentDetail.total_amount)}</span>
                </div>
                <div className={styles.infoItem}>
                  <span className={styles.infoLabel}>Items</span>
                  <span className={styles.infoValue}>{shipmentDetail.items.length}</span>
                </div>
                <div className={styles.infoItem}>
                  <span className={styles.infoLabel}>Linked Orders</span>
                  <span className={styles.infoValue}>{shipmentDetail.order_count}</span>
                </div>
              </div>
              {shipmentDetail.tracking_number && (
                <div className={styles.trackingSection}>
                  <span className={styles.infoLabel}>Tracking Number</span>
                  <p className={styles.trackingNumber}>{shipmentDetail.tracking_number}</p>
                </div>
              )}
              {shipmentDetail.notes && (
                <div className={styles.notesSection}>
                  <span className={styles.infoLabel}>Notes</span>
                  <p className={styles.notesText}>{shipmentDetail.notes}</p>
                </div>
              )}
            </div>

            {/* Supplier Section */}
            <div className={styles.section}>
              <h2 className={styles.sectionTitle}>
                Supplier Information
                {!shipmentDetail.is_registered_supplier && (
                  <span className={styles.oneTimeBadge}>One-time</span>
                )}
              </h2>
              <div className={styles.supplierCard}>
                <div className={styles.supplierName}>{shipmentDetail.supplier_name}</div>
                {shipmentDetail.supplier_phone && (
                  <div className={styles.supplierInfo}>
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                      <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z" />
                    </svg>
                    <span>{shipmentDetail.supplier_phone}</span>
                  </div>
                )}
                {shipmentDetail.supplier_email && (
                  <div className={styles.supplierInfo}>
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                      <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z" />
                      <polyline points="22,6 12,13 2,6" />
                    </svg>
                    <span>{shipmentDetail.supplier_email}</span>
                  </div>
                )}
                {shipmentDetail.supplier_address && (
                  <div className={styles.supplierInfo}>
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                      <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" />
                      <circle cx="12" cy="10" r="3" />
                    </svg>
                    <span>{shipmentDetail.supplier_address}</span>
                  </div>
                )}
              </div>
            </div>

            {/* Shipment Items Section */}
            <div className={styles.section}>
              <h2 className={styles.sectionTitle}>
                Shipment Items
                <span className={styles.itemCount}>({shipmentDetail.items.length} items)</span>
              </h2>
              <div className={styles.tableContainer}>
                <table className={styles.itemsTable}>
                  <thead>
                    <tr>
                      <th>Product</th>
                      <th>SKU</th>
                      <th>Unit Cost</th>
                      <th>Quantity</th>
                      <th>Total</th>
                    </tr>
                  </thead>
                  <tbody>
                    {shipmentDetail.items.map((item) => (
                      <tr key={item.item_id}>
                        <td className={styles.productName}>{item.product_name}</td>
                        <td className={styles.sku}>{item.sku}</td>
                        <td>{formatPrice(item.unit_cost)}</td>
                        <td>{item.quantity_shipped}</td>
                        <td className={styles.totalAmount}>{formatPrice(item.total_amount)}</td>
                      </tr>
                    ))}
                  </tbody>
                  <tfoot>
                    <tr>
                      <td colSpan={4} className={styles.totalLabel}>Total Amount</td>
                      <td className={styles.grandTotal}>{formatPrice(shipmentDetail.total_amount)}</td>
                    </tr>
                  </tfoot>
                </table>
              </div>
            </div>

            {/* Linked Orders Section */}
            {shipmentDetail.has_orders && (
              <div className={styles.section}>
                <h2 className={styles.sectionTitle}>
                  Linked Orders
                  <span className={styles.itemCount}>({shipmentDetail.order_count})</span>
                </h2>
                <div className={styles.orderList}>
                  {shipmentDetail.orders.map((order) => (
                    <div key={order.order_id} className={styles.orderCard}>
                      <span className={styles.orderNumber}>{order.order_number}</span>
                      <span className={getStatusBadgeClass(order.status, styles)}>{order.status}</span>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </>
  );
};

export default ShipmentDetailPage;
