/**
 * CountingSessionPage Component
 * Page for viewing counting session details
 * Shows items scanned with per-user breakdown
 */

import React, { useState } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { useCountingSessionDetail } from '../../hooks/useCountingSessionDetail';
import type { CountingSessionItem } from '../../hooks/useCountingSessionDetail';
import styles from './CountingSessionPage.module.css';

// Format date for display (yyyy/MM/dd)
const formatDateDisplay = (dateStr: string): string => {
  if (!dateStr) return '-';
  const date = new Date(dateStr);
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  return `${year}/${month}/${day}`;
};

// Get status badge info
const getStatusInfo = (isActive: boolean, isFinal: boolean) => {
  if (isFinal) {
    return { text: 'Complete', className: 'complete' };
  }
  if (isActive) {
    return { text: 'In Progress', className: 'process' };
  }
  return { text: 'Closed', className: 'cancelled' };
};

export const CountingSessionPage: React.FC = () => {
  const {
    sessionInfo,
    items,
    summary,
    loading,
    error,
    handleBack,
  } = useCountingSessionDetail();

  // Track expanded items to show per-user breakdown
  const [expandedItems, setExpandedItems] = useState<Set<string>>(new Set());

  // Toggle item expansion
  const toggleItemExpand = (productId: string) => {
    setExpandedItems((prev) => {
      const next = new Set(prev);
      if (next.has(productId)) {
        next.delete(productId);
      } else {
        next.add(productId);
      }
      return next;
    });
  };

  if (loading) {
    return (
      <>
        <Navbar activeItem="product" />
        <div className={styles.pageLayout}>
          <div className={styles.loadingContainer}>
            <div className={styles.spinner} />
            <p>Loading session details...</p>
          </div>
        </div>
      </>
    );
  }

  if (error) {
    return (
      <>
        <Navbar activeItem="product" />
        <div className={styles.pageLayout}>
          <div className={styles.errorContainer}>
            <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="#DC2626" strokeWidth="1.5">
              <circle cx="12" cy="12" r="10" />
              <path d="M15 9l-6 6M9 9l6 6" />
            </svg>
            <h2>Failed to load session</h2>
            <p>{error}</p>
            <button className={styles.backButton} onClick={handleBack}>
              Back to Sessions
            </button>
          </div>
        </div>
      </>
    );
  }

  const statusInfo = sessionInfo
    ? getStatusInfo(sessionInfo.isActive, sessionInfo.isFinal)
    : { text: 'Unknown', className: 'process' };

  return (
    <>
      <Navbar activeItem="product" />
      <div className={styles.pageLayout}>
        <div className={styles.container}>
          {/* Header */}
          <div className={styles.header}>
            <div className={styles.headerLeft}>
              <button className={styles.backButton} onClick={handleBack}>
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <path d="M19 12H5M12 19l-7-7 7-7" />
                </svg>
                Back
              </button>
              <div className={styles.titleSection}>
                <h1 className={styles.title}>
                  {sessionInfo?.sessionName || 'Counting Session'}
                </h1>
                <div className={styles.sessionBadge}>
                  <span className={`${styles.badgeStatus} ${styles[statusInfo.className]}`}>
                    {statusInfo.text}
                  </span>
                  {sessionInfo?.storeName && (
                    <span className={styles.storeName}>{sessionInfo.storeName}</span>
                  )}
                </div>
              </div>
            </div>
          </div>

          {/* Session Info Banner */}
          {sessionInfo && (
            <div className={styles.sessionBanner}>
              <div className={styles.sessionBannerContent}>
                <div className={styles.sessionBannerLeft}>
                  <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2" />
                    <rect x="9" y="3" width="6" height="4" rx="1" />
                    <path d="M9 12h6" />
                    <path d="M9 16h6" />
                  </svg>
                  <div className={styles.sessionBannerInfo}>
                    <span className={styles.sessionBannerLabel}>Counting Session</span>
                    <span className={styles.sessionBannerName}>{sessionInfo.sessionName}</span>
                  </div>
                </div>
                <div className={styles.sessionBannerDetails}>
                  <div className={styles.sessionBannerItem}>
                    <span className={styles.bannerItemLabel}>Created By</span>
                    <span className={styles.bannerItemValue}>{sessionInfo.createdByName}</span>
                  </div>
                  <div className={styles.sessionBannerItem}>
                    <span className={styles.bannerItemLabel}>Created At</span>
                    <span className={styles.bannerItemValue}>
                      {formatDateDisplay(sessionInfo.createdAt?.split(' ')[0] || '')}
                    </span>
                  </div>
                  <div className={styles.sessionBannerItem}>
                    <span className={styles.bannerItemLabel}>Status</span>
                    <span className={`${styles.bannerItemStatus} ${styles[statusInfo.className]}`}>
                      {statusInfo.text}
                    </span>
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* Summary Card */}
          <div className={styles.summaryCard}>
            <div className={styles.summaryRow}>
              <div className={styles.summaryItem}>
                <span className={styles.summaryLabel}>Total Products</span>
                <span className={styles.summaryValue}>{summary.totalProducts}</span>
              </div>
              <div className={styles.summaryItem}>
                <span className={styles.summaryLabel}>Total Counted</span>
                <span className={styles.summaryValueBlue}>{summary.totalQuantity}</span>
              </div>
              <div className={styles.summaryItem}>
                <span className={styles.summaryLabel}>Total Rejected</span>
                <span className={styles.summaryValueRed}>{summary.totalRejected}</span>
              </div>
            </div>
          </div>

          {/* Items Card */}
          <div className={styles.itemsCard}>
            <div className={styles.itemsHeader}>
              <h3>Counted Items</h3>
              <span className={styles.itemCount}>{items.length} products</span>
            </div>

            {items.length > 0 ? (
              <div className={styles.tableContainer}>
                <table className={styles.itemsTable}>
                  <thead>
                    <tr>
                      <th className={styles.thExpand}></th>
                      <th className={styles.thProduct}>Product</th>
                      <th className={styles.thNumber}>Counted</th>
                      <th className={styles.thNumber}>Rejected</th>
                      <th className={styles.thNumber}>Counters</th>
                    </tr>
                  </thead>
                  <tbody>
                    {items.map((item: CountingSessionItem) => (
                      <React.Fragment key={item.productId}>
                        <tr
                          className={`${styles.itemRow} ${expandedItems.has(item.productId) ? styles.expanded : ''}`}
                          onClick={() => toggleItemExpand(item.productId)}
                        >
                          <td className={styles.tdExpand}>
                            <svg
                              width="16"
                              height="16"
                              viewBox="0 0 24 24"
                              fill="none"
                              stroke="currentColor"
                              strokeWidth="2"
                              className={`${styles.expandIcon} ${expandedItems.has(item.productId) ? styles.rotated : ''}`}
                            >
                              <path d="M9 18l6-6-6-6" />
                            </svg>
                          </td>
                          <td className={styles.tdProduct}>{item.productName}</td>
                          <td className={styles.tdNumberBlue}>{item.totalQuantity}</td>
                          <td className={styles.tdNumberRed}>{item.totalRejected}</td>
                          <td className={styles.tdNumber}>{item.scannedBy.length}</td>
                        </tr>

                        {/* Expanded user breakdown */}
                        {expandedItems.has(item.productId) && (
                          <tr className={styles.expandedRow}>
                            <td colSpan={5}>
                              <div className={styles.userBreakdown}>
                                <div className={styles.userBreakdownHeader}>
                                  <span>Counted By</span>
                                </div>
                                <div className={styles.userList}>
                                  {item.scannedBy.map((user) => (
                                    <div key={user.userId} className={styles.userItem}>
                                      <div className={styles.userAvatar}>
                                        {user.userName.charAt(0).toUpperCase()}
                                      </div>
                                      <div className={styles.userInfo}>
                                        <span className={styles.userName}>{user.userName}</span>
                                        <div className={styles.userStats}>
                                          <span className={styles.userCountedLabel}>Counted:</span>
                                          <span className={styles.userCounted}>{user.quantity}</span>
                                          <span className={styles.userRejectedLabel}>Rejected:</span>
                                          <span className={styles.userRejected}>{user.quantityRejected}</span>
                                        </div>
                                      </div>
                                    </div>
                                  ))}
                                </div>
                              </div>
                            </td>
                          </tr>
                        )}
                      </React.Fragment>
                    ))}
                  </tbody>
                </table>
              </div>
            ) : (
              <div className={styles.emptyItems}>
                <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="#94A3B8" strokeWidth="1.5">
                  <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2" />
                  <rect x="9" y="3" width="6" height="4" rx="1" />
                  <path d="M9 12h6" />
                  <path d="M9 16h6" />
                </svg>
                <p>No items counted yet</p>
                <span>Items will appear here once counting begins</span>
              </div>
            )}
          </div>
        </div>
      </div>
    </>
  );
};

export default CountingSessionPage;
