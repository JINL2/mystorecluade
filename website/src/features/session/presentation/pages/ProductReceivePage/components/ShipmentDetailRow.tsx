/**
 * ShipmentDetailRow Component
 * Expanded detail row showing receiving progress and items for a shipment
 */

import React from 'react';
import type { Shipment, ShipmentDetail } from '../ProductReceivePage.types';
import styles from '../ProductReceivePage.module.css';

interface ShipmentDetailRowProps {
  shipment: Shipment;
  shipmentDetail: ShipmentDetail | null;
  detailLoading: boolean;
  onStartReceive: (shipmentId: string) => void;
}

/**
 * Render progress bar with color based on percentage
 */
const renderProgressBar = (percentage: number) => {
  const getProgressColor = () => {
    if (percentage === 100) return '#2E7D32'; // Green
    if (percentage >= 50) return '#0064FF'; // Blue
    return '#FF8A00'; // Orange
  };

  return (
    <div className={styles.progressBarContainer}>
      <div className={styles.progressBarBackground}>
        <div
          className={styles.progressBarFill}
          style={{
            width: `${percentage}%`,
            backgroundColor: getProgressColor(),
          }}
        />
      </div>
      <span className={styles.progressPercentage}>{percentage.toFixed(0)}%</span>
    </div>
  );
};

export const ShipmentDetailRow: React.FC<ShipmentDetailRowProps> = ({
  shipment,
  shipmentDetail,
  detailLoading,
  onStartReceive,
}) => {
  return (
    <tr className={styles.detailRow}>
      <td colSpan={6}>
        {detailLoading ? (
          <div className={styles.detailLoading}>
            <div className={styles.spinnerSmall} />
            <span>Loading receiving details...</span>
          </div>
        ) : shipmentDetail ? (
          <div className={styles.detailContent}>
            {/* Action Row with Start Receive Button */}
            <div className={styles.detailActionRow}>
              <div className={styles.detailActionLeft}>
                {/* Left side - can add info here if needed */}
              </div>
              <div className={styles.detailActionRight}>
                <button
                  className={`${styles.startReceiveButton} ${shipmentDetail.status === 'complete' ? styles.disabled : ''}`}
                  onClick={(e) => {
                    e.stopPropagation();
                    onStartReceive(shipment.shipment_id);
                  }}
                  disabled={shipmentDetail.status === 'complete'}
                >
                  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
                    <polyline points="3.27 6.96 12 12.01 20.73 6.96" />
                    <line x1="12" y1="22.08" x2="12" y2="12" />
                  </svg>
                  {shipmentDetail.status === 'complete' ? 'Receiving Complete' : 'Start Receive'}
                </button>
              </div>
            </div>

            {/* Receiving Summary */}
            <div className={styles.receivingSummary}>
              <h4 className={styles.detailSectionTitle}>Receiving Progress</h4>
              <div className={styles.summaryStats}>
                <div className={styles.statItem}>
                  <span className={styles.statLabel}>Total Shipped</span>
                  <span className={styles.statValue}>{shipmentDetail.receiving_summary.total_shipped}</span>
                </div>
                <div className={styles.statItem}>
                  <span className={styles.statLabel}>Received</span>
                  <span className={styles.statValue}>{shipmentDetail.receiving_summary.total_received}</span>
                </div>
                <div className={styles.statItem}>
                  <span className={styles.statLabel}>Accepted</span>
                  <span className={styles.statValueGreen}>{shipmentDetail.receiving_summary.total_accepted}</span>
                </div>
                <div className={styles.statItem}>
                  <span className={styles.statLabel}>Rejected</span>
                  <span className={styles.statValueRed}>{shipmentDetail.receiving_summary.total_rejected}</span>
                </div>
                <div className={styles.statItem}>
                  <span className={styles.statLabel}>Remaining</span>
                  <span className={styles.statValueOrange}>{shipmentDetail.receiving_summary.total_remaining}</span>
                </div>
                <div className={styles.statItemProgress}>
                  <span className={styles.statLabel}>Progress</span>
                  {renderProgressBar(shipmentDetail.receiving_summary.progress_percentage)}
                </div>
              </div>
            </div>

            {/* Items Detail */}
            <div className={styles.itemsDetail}>
              <h4 className={styles.detailSectionTitle}>Items Detail</h4>
              <table className={styles.itemsTable}>
                <thead>
                  <tr>
                    <th>Product</th>
                    <th>SKU</th>
                    <th>Shipped</th>
                    <th>Received</th>
                    <th>Accepted</th>
                    <th>Rejected</th>
                    <th>Remaining</th>
                  </tr>
                </thead>
                <tbody>
                  {shipmentDetail.items.map((item) => (
                    <tr key={item.item_id}>
                      <td className={styles.productName}>{item.product_name}</td>
                      <td className={styles.sku}>{item.sku}</td>
                      <td>{item.quantity_shipped}</td>
                      <td>{item.quantity_received}</td>
                      <td className={styles.acceptedQty}>{item.quantity_accepted}</td>
                      <td className={styles.rejectedQty}>{item.quantity_rejected}</td>
                      <td className={styles.remainingQty}>{item.quantity_remaining}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        ) : (
          <div className={styles.detailError}>
            Failed to load shipment details
          </div>
        )}
      </td>
    </tr>
  );
};
