/**
 * ItemsTab Component
 * Shows list of items in the session
 */

import React from 'react';
import type { SessionHistoryItem } from '../../../../domain/entities';
import styles from '../SessionHistoryDetailPage.module.css';

interface ItemsTabProps {
  items: SessionHistoryItem[];
  searchQuery: string;
  onSearchChange: (query: string) => void;
  hasConfirmedQuantity: boolean;
  isReceivingSession: boolean;
}

// Get user display name from first and last name
const getUserDisplayName = (firstName: string, lastName: string): string => {
  return `${firstName} ${lastName}`.trim() || 'Unknown';
};

// Get scanned by display string from array of scanners
const getScannedByDisplay = (scannedBy: SessionHistoryItem['scannedBy']): string => {
  if (!scannedBy || scannedBy.length === 0) return '-';
  return scannedBy.map(s => getUserDisplayName(s.firstName, s.lastName)).join(', ');
};

export const ItemsTab: React.FC<ItemsTabProps> = ({
  items,
  searchQuery,
  onSearchChange,
  hasConfirmedQuantity,
  isReceivingSession,
}) => {
  // Filter items based on search
  const filteredItems = React.useMemo(() => {
    if (!items) return [];
    if (!searchQuery.trim()) return items;

    const query = searchQuery.toLowerCase();
    return items.filter(
      (item) =>
        item.displayName.toLowerCase().includes(query) ||
        item.productName.toLowerCase().includes(query) ||
        item.sku?.toLowerCase().includes(query)
    );
  }, [items, searchQuery]);

  return (
    <div className={styles.itemsSection}>
      <div className={styles.searchWrapper}>
        <svg className={styles.searchIcon} width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
          <circle cx="11" cy="11" r="8" />
          <path d="m21 21-4.35-4.35" />
        </svg>
        <input
          type="text"
          className={styles.searchInput}
          placeholder="Search items..."
          value={searchQuery}
          onChange={(e) => onSearchChange(e.target.value)}
        />
      </div>
      <div className={styles.tableContainer}>
        <table className={styles.dataTable}>
          <thead>
            <tr>
              <th>Product</th>
              <th>SKU</th>
              <th>Scanned Qty</th>
              {hasConfirmedQuantity && <th>Confirmed Qty</th>}
              {isReceivingSession && <th>Expected</th>}
              {isReceivingSession && <th>Difference</th>}
              <th>Scanned By</th>
            </tr>
          </thead>
          <tbody>
            {filteredItems.length > 0 ? (
              filteredItems.map((item, index) => (
                <tr key={`${item.productId}-${index}`}>
                  <td className={styles.productName}>{item.displayName}</td>
                  <td>{item.sku || '-'}</td>
                  <td className={styles.quantityCell}>{item.scannedQuantity}</td>
                  {hasConfirmedQuantity && (
                    <td className={styles.quantityCell}>{item.confirmedQuantity ?? '-'}</td>
                  )}
                  {isReceivingSession && (
                    <td className={styles.quantityCell}>{item.quantityExpected ?? '-'}</td>
                  )}
                  {isReceivingSession && (
                    <td className={`${styles.varianceCell} ${(item.quantityDifference ?? 0) < 0 ? styles.negative : (item.quantityDifference ?? 0) > 0 ? styles.positive : ''}`}>
                      {item.quantityDifference != null ? (item.quantityDifference > 0 ? `+${item.quantityDifference}` : item.quantityDifference) : '-'}
                    </td>
                  )}
                  <td>{getScannedByDisplay(item.scannedBy)}</td>
                </tr>
              ))
            ) : (
              <tr>
                <td colSpan={isReceivingSession ? 7 : (hasConfirmedQuantity ? 5 : 4)} className={styles.emptyCell}>
                  {searchQuery ? 'No items match your search' : 'No items in this session'}
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default ItemsTab;
