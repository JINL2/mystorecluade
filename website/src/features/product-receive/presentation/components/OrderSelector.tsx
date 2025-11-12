/**
 * OrderSelector Component
 */

import React, { useState, useRef, useEffect } from 'react';
import { Order } from '../../domain/entities/Order';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import styles from './OrderSelector.module.css';

interface OrderSelectorProps {
  orders: Order[];
  selectedOrder: Order | null;
  onSelectOrder: (order: Order) => void;
  loading?: boolean;
}

export const OrderSelector: React.FC<OrderSelectorProps> = ({
  orders,
  selectedOrder,
  onSelectOrder,
  loading = false,
}) => {
  const [isOpen, setIsOpen] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handleClickOutside = (e: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(e.target as Node)) {
        setIsOpen(false);
      }
    };

    document.addEventListener('click', handleClickOutside);
    return () => document.removeEventListener('click', handleClickOutside);
  }, []);

  const handleSelectOrder = (order: Order) => {
    onSelectOrder(order);
    setIsOpen(false);
  };

  if (loading) {
    return (
      <div className={styles.selector}>
        <div className={styles.button}>
          <LoadingAnimation size="small" />
          <span className={styles.label} style={{ marginLeft: '8px' }}>Loading...</span>
        </div>
      </div>
    );
  }

  if (orders.length === 0) {
    return (
      <div className={styles.selector}>
        <div className={styles.button}>
          <span className={styles.label}>No receivable orders</span>
        </div>
      </div>
    );
  }

  const buttonClass = isOpen ? `${styles.button} ${styles.open}` : styles.button;
  const optionClass = (orderId: string) => {
    const base = styles.option;
    return selectedOrder?.orderId === orderId ? `${base} ${styles.selected}` : base;
  };

  return (
    <div className={styles.selector} ref={dropdownRef}>
      <div className={buttonClass} onClick={() => setIsOpen(!isOpen)}>
        <svg className={styles.icon} fill="currentColor" viewBox="0 0 24 24">
          <path d="M19,3H5A2,2 0 0,0 3,5V19A2,2 0 0,0 5,21H19A2,2 0 0,0 21,19V5A2,2 0 0,0 19,3M19,19H5V5H19V19M17,17H7V15H17V17M17,13H7V11H17V13M17,9H7V7H17V9Z" />
        </svg>
        <span className={styles.label}>
          {selectedOrder ? selectedOrder.displayName : 'Select Order...'}
        </span>
        <svg className={styles.dropdown} fill="currentColor" viewBox="0 0 24 24">
          <path d="M7,10L12,15L17,10H7Z" />
        </svg>
      </div>

      {isOpen && (
        <div className={styles.dropdownMenu}>
          {orders.map((order) => (
            <div
              key={order.orderId}
              className={optionClass(order.orderId)}
              onClick={() => handleSelectOrder(order)}
            >
              <div className={styles.optionContent}>
                <span className={styles.optionText}>{order.displayName}</span>
                <span className={styles.optionMeta}>
                  {order.receivedItems}/{order.totalItems} received
                </span>
              </div>
              {selectedOrder?.orderId === order.orderId && (
                <svg className={styles.checkmark} fill="currentColor" viewBox="0 0 24 24">
                  <path d="M9,20.42L2.79,14.21L5.62,11.38L9,14.77L18.88,4.88L21.71,7.71L9,20.42Z" />
                </svg>
              )}
            </div>
          ))}
        </div>
      )}
    </div>
  );
};
