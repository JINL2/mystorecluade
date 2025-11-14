/**
 * TrackingPage Component
 * Inventory tracking page
 */

import React, { useState } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { useAppState } from '@/app/providers/app_state_provider';
import { useTracking } from '../../hooks/useTracking';
import styles from './TrackingPage.module.css';

export const TrackingPage: React.FC = () => {
  const { currentCompany, currentStore } = useAppState();
  const { items, loading, error, refresh } = useTracking(
    currentCompany?.company_id || '',
    currentStore?.store_id || null
  );

  const [searchTerm, setSearchTerm] = useState('');

  if (!currentCompany || !currentStore) {
    return (
      <>
        <Navbar activeItem="product" />
        <div className={styles.container}>
          <div className={styles.emptyState}>
            <p>Please select a company and store to view tracking</p>
          </div>
        </div>
      </>
    );
  }

  if (loading) {
    return (
      <>
        <Navbar activeItem="product" />
        <div className={styles.container}>
          <div className={styles.loadingSpinner}>
            <div className={styles.spinner} />
          </div>
        </div>
      </>
    );
  }

  if (error) {
    return (
      <>
        <Navbar activeItem="product" />
        <div className={styles.container}>
          <div className={styles.errorState}>
            <p className={styles.errorMessage}>{error}</p>
            <button onClick={refresh} className={styles.retryButton}>
              Retry
            </button>
          </div>
        </div>
      </>
    );
  }

  const filteredItems = items.filter(
    (item) =>
      item.productName.toLowerCase().includes(searchTerm.toLowerCase()) ||
      item.sku.toLowerCase().includes(searchTerm.toLowerCase()) ||
      item.categoryName.toLowerCase().includes(searchTerm.toLowerCase()) ||
      item.brandName.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const lowStockCount = items.filter((item) => item.isLowStock).length;
  const totalValue = items.reduce((sum, item) => sum + item.totalValue, 0);

  return (
    <>
      <Navbar activeItem="product" />
      <div className={styles.container}>
      <div className={styles.pageHeader}>
        <h1 className={styles.pageTitle}>Inventory Tracking</h1>
        <p className={styles.pageSubtitle}>
          Track inventory for {currentStore.store_name}
        </p>
      </div>

      {/* Stats Cards */}
      <div className={styles.statsGrid}>
        <div className={styles.statCard}>
          <div className={styles.statIcon}>
            <svg
              width="24"
              height="24"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2"
            >
              <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
            </svg>
          </div>
          <div className={styles.statContent}>
            <div className={styles.statLabel}>Total Items</div>
            <div className={styles.statValue}>{items.length}</div>
          </div>
        </div>

        <div className={styles.statCard}>
          <div className={`${styles.statIcon} ${styles.warning}`}>
            <svg
              width="24"
              height="24"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2"
            >
              <path d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
            </svg>
          </div>
          <div className={styles.statContent}>
            <div className={styles.statLabel}>Low Stock Items</div>
            <div className={styles.statValue}>{lowStockCount}</div>
          </div>
        </div>

        <div className={styles.statCard}>
          <div className={`${styles.statIcon} ${styles.success}`}>
            <svg
              width="24"
              height="24"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2"
            >
              <path d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </div>
          <div className={styles.statContent}>
            <div className={styles.statLabel}>Total Value</div>
            <div className={styles.statValue}>
              {items[0]?.formatCurrency(totalValue) || '₩0'}
            </div>
          </div>
        </div>
      </div>

      {/* Search Bar */}
      <div className={styles.searchBar}>
        <svg
          width="20"
          height="20"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          strokeWidth="2"
          className={styles.searchIcon}
        >
          <circle cx="11" cy="11" r="8" />
          <path d="M21 21l-4.35-4.35" />
        </svg>
        <input
          type="text"
          placeholder="Search by product name, SKU, category, or brand..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className={styles.searchInput}
        />
      </div>

      {/* Tracking Table */}
      {filteredItems.length === 0 ? (
        <div className={styles.emptyState}>
          <h3 className={styles.emptyTitle}>No Items Found</h3>
          <p className={styles.emptyDescription}>
            {searchTerm ? 'Try adjusting your search criteria' : 'No tracking items available'}
          </p>
        </div>
      ) : (
        <div className={styles.tableCard}>
          <table className={styles.table}>
            <thead>
              <tr>
                <th>SKU</th>
                <th>Product Name</th>
                <th>Category</th>
                <th>Brand</th>
                <th>Current Stock</th>
                <th>Min Stock</th>
                <th>Max Stock</th>
                <th>Status</th>
                <th>Unit Price</th>
                <th>Total Value</th>
              </tr>
            </thead>
            <tbody>
              {filteredItems.map((item) => (
                <tr key={item.productId}>
                  <td className={styles.skuCell}>{item.sku}</td>
                  <td className={styles.nameCell}>{item.productName}</td>
                  <td>{item.categoryName}</td>
                  <td>{item.brandName}</td>
                  <td className={styles.numberCell}>{item.currentStock}</td>
                  <td className={styles.numberCell}>{item.minStock}</td>
                  <td className={styles.numberCell}>{item.maxStock}</td>
                  <td>
                    <span className={`${styles.statusBadge} ${styles[item.stockStatus]}`}>
                      {item.stockStatus === 'low' && 'Low Stock'}
                      {item.stockStatus === 'normal' && 'Normal'}
                      {item.stockStatus === 'over' && 'Over Stock'}
                    </span>
                  </td>
                  <td className={styles.numberCell}>{item.formatCurrency(item.unitPrice)}</td>
                  <td className={styles.numberCell}>{item.formattedTotalValue}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
    </>
  );
};
