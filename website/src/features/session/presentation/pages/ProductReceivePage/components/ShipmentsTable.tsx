/**
 * ShipmentsTable Component
 * Table displaying shipments list with expandable detail rows
 */

import React from 'react';
import { formatDateDisplay } from '../../../hooks/useProductReceiveList';
import { ShipmentDetailRow } from './ShipmentDetailRow';
import type { Shipment, ShipmentDetail } from '../ProductReceivePage.types';
import styles from '../ProductReceivePage.module.css';

interface Currency {
  code: string;
  symbol: string;
  name: string;
}

interface ShipmentsTableProps {
  shipments: Shipment[];
  shipmentsLoading: boolean;
  selectedShipmentId: string | null;
  shipmentDetail: ShipmentDetail | null;
  detailLoading: boolean;
  currency: Currency;
  searchQuery: string;
  onShipmentClick: (shipmentId: string) => void;
  onStartReceive: (shipmentId: string) => void;
}

export const ShipmentsTable: React.FC<ShipmentsTableProps> = ({
  shipments,
  shipmentsLoading,
  selectedShipmentId,
  shipmentDetail,
  detailLoading,
  currency,
  searchQuery,
  onShipmentClick,
  onStartReceive,
}) => {
  return (
    <div className={styles.tableContainer}>
      <table className={styles.receivesTable}>
        <thead>
          <tr>
            <th>Shipment #</th>
            <th>Shipped Date</th>
            <th>Supplier</th>
            <th>Items</th>
            <th>Total Amount</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          {shipmentsLoading ? (
            <tr>
              <td colSpan={6}>
                <div className={styles.loadingState}>
                  <div className={styles.spinner} />
                  <p>Loading shipments...</p>
                </div>
              </td>
            </tr>
          ) : shipments.length > 0 ? (
            shipments.map((shipment) => (
              <React.Fragment key={shipment.shipment_id}>
                <tr
                  className={`${styles.shipmentRow} ${selectedShipmentId === shipment.shipment_id ? styles.selected : ''}`}
                  onClick={() => onShipmentClick(shipment.shipment_id)}
                >
                  <td>
                    <span className={styles.receiveNumber}>{shipment.shipment_number}</span>
                  </td>
                  <td>{formatDateDisplay(shipment.shipped_date?.split(' ')[0] || '')}</td>
                  <td>
                    <span className={styles.supplierName}>{shipment.supplier_name}</span>
                  </td>
                  <td>
                    <span className={styles.itemCount}>{shipment.item_count}</span>
                  </td>
                  <td>
                    <span className={styles.currencyAmount}>
                      {currency.symbol}{(shipment as { total_amount?: number }).total_amount?.toLocaleString() || '0'}
                    </span>
                  </td>
                  <td>
                    <span className={`${styles.statusBadge} ${styles[shipment.status]}`}>
                      {shipment.status}
                    </span>
                  </td>
                </tr>

                {/* Expanded Detail Row */}
                {selectedShipmentId === shipment.shipment_id && (
                  <ShipmentDetailRow
                    shipment={shipment}
                    shipmentDetail={shipmentDetail}
                    detailLoading={detailLoading}
                    onStartReceive={onStartReceive}
                  />
                )}
              </React.Fragment>
            ))
          ) : (
            <tr>
              <td colSpan={6}>
                <div className={styles.emptyState}>
                  <svg className={styles.emptyIcon} width="80" height="80" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1">
                    <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
                    <polyline points="3.27 6.96 12 12.01 20.73 6.96" />
                    <line x1="12" y1="22.08" x2="12" y2="12" />
                  </svg>
                  <p className={styles.emptyTitle}>No shipments found</p>
                  <p className={styles.emptyDescription}>
                    {searchQuery ? 'Try adjusting your search or filters' : 'No shipments to receive yet'}
                  </p>
                </div>
              </td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
  );
};
