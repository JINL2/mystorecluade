/**
 * OrderPage Component
 * Purchase Orders management with New Order and Order List tabs
 * Following 2025 Best Practice: Uses Zustand provider for state management
 */

import React, { useEffect } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { useAppState } from '@/app/providers/app_state_provider';
import { useOrder } from '../../hooks/useOrder';
import { OrderForm } from '../../components/OrderForm/OrderForm';
import { useErrorMessage } from '@/shared/hooks/useErrorMessage';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import styles from './OrderPage.module.css';

// Format number with thousand separators (integer only, following backup pattern)
const formatNumber = (value: number): string => {
  return Math.round(value).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
};

export const OrderPage: React.FC = () => {
  const { currentCompany, currentStore } = useAppState();

  // Use order hook with Zustand provider
  const {
    orders,
    activeTab,
    loading,
    error,
    setActiveTab,
    refresh,
  } = useOrder(currentCompany?.company_id || '', currentStore?.store_id || null);

  const { messageState, closeMessage, showError } = useErrorMessage();

  // Handle order loading error
  useEffect(() => {
    if (error) {
      showError({
        title: 'Failed to Load Orders',
        message: error,
        confirmText: 'Retry',
        onConfirm: () => {
          closeMessage();
          refresh();
        },
      });
    }
  }, [error, showError, closeMessage, refresh]);

  if (!currentCompany) {
    return (
      <>
        <Navbar activeItem="product" />
        <div className={styles.pageLayout}>
          <div className={styles.pageContainer}>
            <div className={styles.emptyState}>
              <p>Please select a company to view orders</p>
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
        <div className={styles.pageContainer}>
          {/* Page Header */}
          <div className={styles.pageHeader}>
            <h1 className={styles.pageTitle}>Purchase Orders</h1>
            <p className={styles.pageSubtitle}>Manage supplier orders and track deliveries</p>
          </div>

          {/* Tabs Container */}
          <div className={styles.tabsContainer}>
            {/* Tabs Navigation */}
            <div className={styles.tabsNav}>
              <button
                className={`${styles.tabItem} ${activeTab === 'new-order' ? styles.active : ''}`}
                onClick={() => setActiveTab('new-order')}
              >
                <svg
                  className={styles.tabIcon}
                  width="20"
                  height="20"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="2"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                >
                  <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                  <polyline points="14 2 14 8 20 8" />
                  <line x1="12" y1="18" x2="12" y2="12" />
                  <line x1="9" y1="15" x2="15" y2="15" />
                </svg>
                <span>New Order</span>
              </button>
              <button
                className={`${styles.tabItem} ${activeTab === 'order-list' ? styles.active : ''}`}
                onClick={() => setActiveTab('order-list')}
              >
                <svg
                  className={styles.tabIcon}
                  width="20"
                  height="20"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="2"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                >
                  <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                  <line x1="7" y1="8" x2="17" y2="8" />
                  <line x1="7" y1="12" x2="17" y2="12" />
                  <line x1="7" y1="16" x2="12" y2="16" />
                </svg>
                <span>Order List</span>
                <span className={styles.tabBadge}>{orders.length}</span>
              </button>
            </div>

            {/* New Order Tab Content */}
            {activeTab === 'new-order' && (
              <div className={styles.tabContent}>
                <OrderForm
                  onSuccess={() => {
                    refresh();
                    setActiveTab('order-list');
                  }}
                  onCancel={() => setActiveTab('order-list')}
                />
              </div>
            )}

            {/* Order List Tab Content */}
            {activeTab === 'order-list' && (
              <div className={styles.tabContent}>
                {loading ? (
                  <LoadingAnimation size="large" fullscreen />
                ) : orders.length === 0 ? (
                  <div className={styles.emptyState}>
                    <svg
                      className={styles.emptyIcon}
                      width="120"
                      height="120"
                      viewBox="0 0 120 120"
                      fill="none"
                      xmlns="http://www.w3.org/2000/svg"
                    >
                      {/* Background Circle */}
                      <circle cx="60" cy="60" r="50" fill="#F0F6FF" />

                      {/* Document Stack */}
                      <rect
                        x="35"
                        y="40"
                        width="50"
                        height="60"
                        rx="4"
                        fill="white"
                        stroke="#0064FF"
                        strokeWidth="2"
                      />
                      <rect
                        x="40"
                        y="35"
                        width="50"
                        height="60"
                        rx="4"
                        fill="white"
                        stroke="#0064FF"
                        strokeWidth="2"
                      />

                      {/* Document Lines */}
                      <line
                        x1="48"
                        y1="45"
                        x2="75"
                        y2="45"
                        stroke="#E9ECEF"
                        strokeWidth="2"
                        strokeLinecap="round"
                      />
                      <line
                        x1="48"
                        y1="52"
                        x2="70"
                        y2="52"
                        stroke="#E9ECEF"
                        strokeWidth="2"
                        strokeLinecap="round"
                      />
                      <line
                        x1="48"
                        y1="59"
                        x2="72"
                        y2="59"
                        stroke="#E9ECEF"
                        strokeWidth="2"
                        strokeLinecap="round"
                      />

                      {/* Order Symbol */}
                      <circle cx="60" cy="75" r="12" fill="#0064FF" />
                      <path
                        d="M56 75 L58 77 L64 71"
                        stroke="white"
                        strokeWidth="2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                      />
                    </svg>
                    <h3 className={styles.emptyTitle}>No Purchase Orders</h3>
                    <p className={styles.emptyDescription}>
                      You don't have any purchase orders yet
                    </p>
                  </div>
                ) : (
                  <div className={styles.tableContainer}>
                    <table className={styles.ordersTable}>
                      <thead>
                        <tr>
                          <th>
                            <input type="checkbox" />
                          </th>
                          <th>Order Number</th>
                          <th>Date</th>
                          <th>Supplier</th>
                          <th>Items</th>
                          <th>Total Amount</th>
                          <th>Receiving Status</th>
                          <th>Status</th>
                          <th>Action</th>
                        </tr>
                      </thead>
                      <tbody>
                        {orders.map((order) => {
                          const progress = order.receivingProgress;
                          return (
                            <tr key={order.orderId}>
                              <td>
                                <input type="checkbox" data-order-id={order.orderId} />
                              </td>
                              <td>
                                <span className={styles.orderNumber}>{order.orderNumber}</span>
                              </td>
                              <td>{order.formattedDate}</td>
                              <td>{order.supplierName}</td>
                              <td>
                                {order.itemCount} item{order.itemCount !== 1 ? 's' : ''}
                              </td>
                              <td className={styles.currencyAmount}>
                                {order.formatCurrency(order.totalAmount)}
                              </td>
                              <td>
                                {order.status !== 'cancelled' ? (
                                  <div className={styles.receivingProgress}>
                                    <span className={styles.progressText}>
                                      {formatNumber(progress.received)}/
                                      {formatNumber(progress.total)}
                                    </span>
                                    {progress.total > 0 && (
                                      <>
                                        <div className={styles.progressBar}>
                                          <div
                                            className={styles.progressFill}
                                            style={{ width: `${progress.percentage}%` }}
                                          />
                                        </div>
                                        <small className={styles.progressPercentage}>
                                          ({progress.percentage}%)
                                        </small>
                                      </>
                                    )}
                                  </div>
                                ) : (
                                  '-'
                                )}
                              </td>
                              <td>
                                <span
                                  className={`${styles.statusBadge} ${styles[order.status]}`}
                                >
                                  {order.statusDisplay}
                                </span>
                              </td>
                              <td>
                                <button
                                  className={styles.actionBtn}
                                  data-order-id={order.orderId}
                                >
                                  View
                                </button>
                              </td>
                            </tr>
                          );
                        })}
                      </tbody>
                    </table>
                  </div>
                )}
              </div>
            )}
          </div>
        </div>
      </div>

      {/* ErrorMessage Component */}
      <ErrorMessage
        variant={messageState.variant}
        title={messageState.title}
        message={messageState.message}
        isOpen={messageState.isOpen}
        onClose={closeMessage}
        confirmText={messageState.confirmText}
        onConfirm={messageState.onConfirm}
      />
    </>
  );
};
