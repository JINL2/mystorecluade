/**
 * OrderItemsTable Component
 * Displays and manages order items in a table format
 */

import React from 'react';
import type { OrderItem, Currency } from '../../pages/OrderCreatePage/OrderCreatePage.types';
import styles from './OrderItemsTable.module.css';

interface OrderItemsTableProps {
  orderItems: OrderItem[];
  currency: Currency;
  totalAmount: number;
  onQuantityChange: (index: number, value: string) => void;
  onCostChange: (index: number, cost: number) => void;
  onRemoveItem: (index: number) => void;
  formatPrice: (price: number) => string;
}

export const OrderItemsTable: React.FC<OrderItemsTableProps> = ({
  orderItems,
  currency,
  totalAmount,
  onQuantityChange,
  onCostChange,
  onRemoveItem,
  formatPrice,
}) => {
  if (orderItems.length === 0) {
    return (
      <div className={styles.emptyItems}>
        <svg className={styles.emptyIcon} width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
          <path d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" />
        </svg>
        <p>No items added yet</p>
        <span>Search for products above or use "Import Excel" to add items</span>
      </div>
    );
  }

  return (
    <div className={styles.tableContainer}>
      <table className={styles.itemsTable}>
        <thead>
          <tr>
            <th>Product Name</th>
            <th>SKU</th>
            <th>Cost</th>
            <th>Quantity</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {orderItems.map((item, index) => (
            <tr key={`${item.productId}-${item.variantId || 'base'}`}>
              <td className={styles.productName}>{item.productName}</td>
              <td className={styles.sku}>{item.sku}</td>
              <td>
                <div className={styles.costInputWrapper}>
                  <input
                    type="number"
                    className={styles.costInput}
                    value={item.cost}
                    onChange={(e) => onCostChange(index, parseFloat(e.target.value) || 0)}
                    min="0"
                    step="100"
                  />
                  <span className={styles.currencySymbol}>{currency.symbol}</span>
                </div>
              </td>
              <td>
                <input
                  type="number"
                  className={styles.quantityInputCell}
                  value={item.quantity || ''}
                  onChange={(e) => onQuantityChange(index, e.target.value)}
                  min="0"
                />
              </td>
              <td>
                <button
                  className={styles.removeButton}
                  onClick={() => onRemoveItem(index)}
                >
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <line x1="18" y1="6" x2="6" y2="18" />
                    <line x1="6" y1="6" x2="18" y2="18" />
                  </svg>
                </button>
              </td>
            </tr>
          ))}
        </tbody>
        <tfoot>
          <tr>
            <td colSpan={2} className={styles.totalLabel}>Total Amount</td>
            <td className={styles.grandTotal}>{formatPrice(totalAmount)}</td>
            <td colSpan={2}></td>
          </tr>
        </tfoot>
      </table>
    </div>
  );
};

export default OrderItemsTable;
