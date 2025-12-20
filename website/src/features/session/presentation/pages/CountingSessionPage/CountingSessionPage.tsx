/**
 * CountingSessionPage Component
 * Page for viewing counting session details
 * Shows items scanned with per-user breakdown
 * Now includes product search and add functionality (same as receiving)
 */

import React, { useState } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { ConfirmModal } from '@/shared/components/common/ConfirmModal';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { SelectorModal } from '@/shared/components/common/SelectorModal';
import type { SelectorOption } from '@/shared/components/common/SelectorModal/SelectorModal.types';
import { useCountingSessionDetail } from '../../hooks/useCountingSessionDetail';
import type { CountingSessionItem, SearchProduct, ReceivedEntry, ActiveSession, MatchedItem, OnlyInSessionItem } from '../../hooks/useCountingSessionDetail';
import {
  SubmitReviewModal,
  FinalChoiceModal,
} from '../ReceivingSessionPage/components';
import styles from './CountingSessionPage.module.css';

// Import styles from ReceivingSessionPage for the search/entries section
import searchStyles from '../ReceivingSessionPage/components/SearchBox.module.css';
import entriesStyles from '../ReceivingSessionPage/components/ReceivedEntries.module.css';

// Merge styles for search section
const receiveStyles = { ...searchStyles, ...entriesStyles };

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
    currentUser,
    handleBack,

    // Search state
    searchQuery,
    setSearchQuery,
    searchResults,
    isSearching,
    currency,
    searchInputRef,
    debouncedSearchQuery,

    // Received entries
    receivedEntries,

    // Save state
    isSaving,
    saveError,
    saveSuccess,

    // Submit state
    showSubmitModeModal,
    showSubmitConfirmModal,
    showSubmitReviewModal,
    showFinalChoiceModal,
    isLoadingSessionItems,
    isSubmitting,
    submitError,
    submitSuccess,

    // Session items for review
    editableItems,

    // Combine session state
    showSessionSelectModal,
    availableSessions,
    selectedCombineSession,
    showComparisonModal,
    comparisonResult,
    isLoadingComparison,
    comparisonError,

    // Merge state
    isMerging,
    mergeError,
    mergeSuccess,

    // Calculated totals
    editableTotalQuantity,
    editableTotalRejected,

    // Actions
    handleSelectProduct,
    handleSearchKeyDown,
    updateEntryQuantity,
    setEntryQuantity,
    removeEntry,
    clearSearch,
    handleSave,
    handleSubmitClick,
    handleSubmitModeSelect,
    handleSubmitModeClose,
    handleSubmitConfirm,
    handleSubmitConfirmClose,
    handleSubmitReviewClose,
    handleFinalChoiceClose,
    handleReviewQuantityChange,
    handleFinalSubmit,
    handleSubmitSession,
    dismissSaveError,

    // Combine session actions
    handleSessionSelectClose,
    handleCombineSessionSelect,
    handleComparisonClose,

    // Merge action
    handleMergeSessions,
  } = useCountingSessionDetail();

  // Submit mode options for SelectorModal
  const submitModeOptions: SelectorOption[] = [
    {
      id: 'combine_session',
      label: `Combine Session${availableSessions.length > 0 ? ` (${availableSessions.length})` : ''}`,
      variant: 'outline',
      disabled: availableSessions.length === 0,
      icon: (
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
          <path d="M16 16v4a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4" />
          <rect x="10" y="2" width="12" height="12" rx="2" />
          <path d="M14 8h4M16 6v4" />
        </svg>
      ),
    },
    {
      id: 'only_this_session',
      label: 'Only This Session',
      variant: 'primary',
      icon: (
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
          <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2" />
          <rect x="9" y="3" width="6" height="4" rx="1" />
          <path d="M9 14l2 2 4-4" />
        </svg>
      ),
    },
  ];

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

  // Check if current user is the session owner
  const canSubmit = sessionInfo?.createdBy === currentUser?.user_id;
  const isSessionActive = sessionInfo?.isActive && !sessionInfo?.isFinal;

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

      {/* Fullscreen Loading when submitting */}
      {isSubmitting && <LoadingAnimation fullscreen size="large" />}

      {/* Merge Success Toast */}
      {mergeSuccess && (
        <div className={styles.mergeSuccessToast}>
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <path d="M20 6L9 17l-5-5" />
          </svg>
          Sessions merged successfully!
        </div>
      )}

      {/* Submit Mode Selection Modal */}
      <SelectorModal
        isOpen={showSubmitModeModal}
        onClose={handleSubmitModeClose}
        onSelect={handleSubmitModeSelect}
        variant="info"
        title="Submit Session"
        message="Choose how you want to submit this counting session."
        options={submitModeOptions}
        cancelText="Cancel"
        headerIcon={
          <svg width="48" height="48" viewBox="0 0 24 24" fill="#0064FF">
            <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4" />
          </svg>
        }
      />

      {/* Submit Confirmation Modal */}
      <ConfirmModal
        isOpen={showSubmitConfirmModal}
        onClose={handleSubmitConfirmClose}
        onConfirm={handleSubmitConfirm}
        variant="warning"
        title="Submit Session"
        message="Have all other session members finished saving their items? Once submitted, the session will be finalized and no more items can be added."
        confirmText="Yes, Submit"
        cancelText="Cancel"
        confirmButtonVariant="success"
        headerBackground="#10B981"
        showConfirmIcon={false}
        width="450px"
      />

      {/* Submit Review Modal */}
      <SubmitReviewModal
        isOpen={showSubmitReviewModal}
        isLoading={isLoadingSessionItems}
        submitError={submitError}
        editableItems={editableItems}
        sessionItems={items.map(item => ({
          product_id: item.productId,
          product_name: item.productName,
          total_quantity: item.totalQuantity,
          total_rejected: item.totalRejected,
          scanned_by: item.scannedBy.map(u => ({
            user_id: u.userId,
            user_name: u.userName,
            quantity: u.quantity,
            quantity_rejected: u.quantityRejected,
          })),
        }))}
        editableTotalQuantity={editableTotalQuantity}
        editableTotalRejected={editableTotalRejected}
        onClose={handleSubmitReviewClose}
        onConfirm={handleSubmitConfirm}
        onQuantityChange={handleReviewQuantityChange}
        onFinalSubmit={handleFinalSubmit}
      />

      {/* Final Choice Modal */}
      <FinalChoiceModal
        isOpen={showFinalChoiceModal}
        isSubmitting={isSubmitting}
        submitError={submitError}
        submitSuccess={submitSuccess}
        onClose={handleFinalChoiceClose}
        onSubmit={handleSubmitSession}
      />

      {/* Session Selection Modal for Combine */}
      {showSessionSelectModal && (
        <div className={styles.modalBackdrop} onClick={handleSessionSelectClose}>
          <div className={styles.sessionSelectModal} onClick={(e) => e.stopPropagation()}>
            <div className={styles.modalHeader}>
              <h3>Select Session to Compare</h3>
              <button className={styles.modalCloseButton} onClick={handleSessionSelectClose}>
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <path d="M18 6L6 18M6 6l12 12" />
                </svg>
              </button>
            </div>
            <div className={styles.sessionSelectContent}>
              <p className={styles.sessionSelectDescription}>
                Select another active counting session to compare items with your current session.
              </p>
              {availableSessions.length === 0 ? (
                <div className={styles.noSessionsMessage}>
                  <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#94A3B8" strokeWidth="1.5">
                    <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2" />
                    <rect x="9" y="3" width="6" height="4" rx="1" />
                  </svg>
                  <p>No other active sessions available</p>
                </div>
              ) : (
                <div className={styles.sessionSelectList}>
                  {availableSessions.map((session: ActiveSession) => (
                    <button
                      key={session.sessionId}
                      className={styles.sessionSelectItem}
                      onClick={() => handleCombineSessionSelect(session)}
                    >
                      <div className={styles.sessionSelectItemLeft}>
                        <span className={styles.sessionSelectItemName}>{session.sessionName}</span>
                        <span className={styles.sessionSelectItemMeta}>
                          {session.storeName} • Created by {session.createdByName}
                        </span>
                      </div>
                      <div className={styles.sessionSelectItemRight}>
                        <span className={styles.sessionSelectItemMembers}>
                          {session.memberCount} members
                        </span>
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                          <path d="M9 18l6-6-6-6" />
                        </svg>
                      </div>
                    </button>
                  ))}
                </div>
              )}
            </div>
          </div>
        </div>
      )}

      {/* Comparison Loading */}
      {isLoadingComparison && <LoadingAnimation fullscreen size="large" />}

      {/* Comparison Modal */}
      {showComparisonModal && comparisonResult && (
        <div className={styles.modalBackdrop} onClick={handleComparisonClose}>
          <div className={styles.comparisonModal} onClick={(e) => e.stopPropagation()}>
            <div className={styles.modalHeader}>
              <h3>Session Comparison</h3>
              <button className={styles.modalCloseButton} onClick={handleComparisonClose}>
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <path d="M18 6L6 18M6 6l12 12" />
                </svg>
              </button>
            </div>
            <div className={styles.comparisonContent}>
              {/* Session Info Header */}
              <div className={styles.comparisonSessions}>
                <div className={styles.comparisonSessionInfo}>
                  <span className={styles.comparisonSessionLabel}>Current Session (A)</span>
                  <span className={styles.comparisonSessionName}>{comparisonResult.sessionA.sessionName}</span>
                  <span className={styles.comparisonSessionMeta}>
                    {comparisonResult.sessionA.totalProducts} products • {comparisonResult.sessionA.totalQuantity} items
                  </span>
                </div>
                <div className={styles.comparisonVs}>vs</div>
                <div className={styles.comparisonSessionInfo}>
                  <span className={styles.comparisonSessionLabel}>Selected Session (B)</span>
                  <span className={styles.comparisonSessionName}>{comparisonResult.sessionB.sessionName}</span>
                  <span className={styles.comparisonSessionMeta}>
                    {comparisonResult.sessionB.totalProducts} products • {comparisonResult.sessionB.totalQuantity} items
                  </span>
                </div>
              </div>

              {comparisonError && (
                <div className={styles.comparisonError}>
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <circle cx="12" cy="12" r="10" />
                    <path d="M15 9l-6 6M9 9l6 6" />
                  </svg>
                  {comparisonError}
                </div>
              )}

              {/* Two Column Comparison Layout */}
              <div className={styles.comparisonTwoColumnLayout}>
                {/* Column A - Current Session */}
                <div className={styles.comparisonColumn}>
                  <div className={`${styles.comparisonColumnHeader} ${styles.columnHeaderBlue}`}>
                    <span className={styles.columnSessionName}>{comparisonResult.sessionA.sessionName}</span>
                    <span className={styles.columnItemCount}>{comparisonResult.onlyInA.length} unique products</span>
                  </div>
                  <div className={styles.comparisonColumnContent}>
                    {comparisonResult.onlyInA.length > 0 ? (
                      <table className={styles.comparisonColumnTable}>
                        <thead>
                          <tr>
                            <th>SKU</th>
                            <th>Product</th>
                            <th className={styles.thNumber}>Qty</th>
                          </tr>
                        </thead>
                        <tbody>
                          {comparisonResult.onlyInA.map((item: OnlyInSessionItem) => (
                            <tr key={item.productId}>
                              <td className={styles.comparisonSku}>{item.sku}</td>
                              <td className={styles.comparisonProduct}>{item.productName}</td>
                              <td className={styles.comparisonNumber}>
                                <span className={styles.quantityBlue}>{item.quantity}</span>
                              </td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    ) : (
                      <div className={styles.columnEmptyState}>
                        <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#94A3B8" strokeWidth="1.5">
                          <path d="M20 6L9 17l-5-5" />
                        </svg>
                        <p>No unique products</p>
                      </div>
                    )}
                  </div>
                </div>

                {/* Column B - Selected Session */}
                <div className={styles.comparisonColumn}>
                  <div className={`${styles.comparisonColumnHeader} ${styles.columnHeaderOrange}`}>
                    <span className={styles.columnSessionName}>{comparisonResult.sessionB.sessionName}</span>
                    <span className={styles.columnItemCount}>{comparisonResult.onlyInB.length} unique products</span>
                  </div>
                  <div className={styles.comparisonColumnContent}>
                    {comparisonResult.onlyInB.length > 0 ? (
                      <table className={styles.comparisonColumnTable}>
                        <thead>
                          <tr>
                            <th>SKU</th>
                            <th>Product</th>
                            <th className={styles.thNumber}>Qty</th>
                          </tr>
                        </thead>
                        <tbody>
                          {comparisonResult.onlyInB.map((item: OnlyInSessionItem) => (
                            <tr key={item.productId}>
                              <td className={styles.comparisonSku}>{item.sku}</td>
                              <td className={styles.comparisonProduct}>{item.productName}</td>
                              <td className={styles.comparisonNumber}>
                                <span className={styles.quantityOrange}>{item.quantity}</span>
                              </td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    ) : (
                      <div className={styles.columnEmptyState}>
                        <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#94A3B8" strokeWidth="1.5">
                          <path d="M20 6L9 17l-5-5" />
                        </svg>
                        <p>No unique products</p>
                      </div>
                    )}
                  </div>
                </div>
              </div>

              {/* Matched Products Section - Collapsed by default */}
              {comparisonResult.matched.length > 0 && (
                <details className={styles.matchedProductsDetails}>
                  <summary className={styles.matchedProductsSummary}>
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                      <path d="M20 6L9 17l-5-5" />
                    </svg>
                    Matched Products ({comparisonResult.matched.length})
                    <span className={styles.matchedSummaryInfo}>
                      {comparisonResult.summary.quantitySameCount} same, {comparisonResult.summary.quantityDiffCount} different
                    </span>
                  </summary>
                  <div className={styles.comparisonTableContainer}>
                    <table className={styles.comparisonTable}>
                      <thead>
                        <tr>
                          <th>SKU</th>
                          <th>Product</th>
                          <th className={styles.thNumber}>{comparisonResult.sessionA.sessionName}</th>
                          <th className={styles.thNumber}>{comparisonResult.sessionB.sessionName}</th>
                          <th className={styles.thNumber}>Diff</th>
                          <th className={styles.thNumber}>Status</th>
                        </tr>
                      </thead>
                      <tbody>
                        {comparisonResult.matched.map((item: MatchedItem) => (
                          <tr key={item.productId} className={item.isMatch ? styles.rowMatch : styles.rowMismatch}>
                            <td className={styles.comparisonSku}>{item.sku}</td>
                            <td className={styles.comparisonProduct}>{item.productName}</td>
                            <td className={styles.comparisonNumber}>
                              <span className={styles.quantityBlue}>{item.quantityA}</span>
                            </td>
                            <td className={styles.comparisonNumber}>
                              <span className={styles.quantityOrange}>{item.quantityB}</span>
                            </td>
                            <td className={styles.comparisonNumber}>
                              {item.quantityDiff !== 0 ? (
                                <span className={item.quantityDiff > 0 ? styles.quantityDiffPositive : styles.quantityDiffNegative}>
                                  {item.quantityDiff > 0 ? '+' : ''}{item.quantityDiff}
                                </span>
                              ) : (
                                <span className={styles.quantityEmpty}>0</span>
                              )}
                            </td>
                            <td className={styles.comparisonNumber}>
                              {item.isMatch ? (
                                <span className={styles.statusMatch}>Match</span>
                              ) : (
                                <span className={styles.statusMismatch}>Diff</span>
                              )}
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </details>
              )}

              {/* Empty State */}
              {comparisonResult.matched.length === 0 &&
               comparisonResult.onlyInA.length === 0 &&
               comparisonResult.onlyInB.length === 0 && !comparisonError && (
                <div className={styles.noComparisonItems}>
                  <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#94A3B8" strokeWidth="1.5">
                    <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2" />
                    <rect x="9" y="3" width="6" height="4" rx="1" />
                  </svg>
                  <p>No items in either session</p>
                </div>
              )}
            </div>

            {/* Merge Error */}
            {mergeError && (
              <div className={styles.mergeError}>
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <circle cx="12" cy="12" r="10" />
                  <path d="M15 9l-6 6M9 9l6 6" />
                </svg>
                {mergeError}
              </div>
            )}

            <div className={styles.comparisonActions}>
              <button className={styles.closeComparisonButton} onClick={handleComparisonClose}>
                Close
              </button>
              <button
                className={`${styles.mergeButton} ${isMerging ? styles.mergeButtonLoading : ''}`}
                onClick={handleMergeSessions}
                disabled={isMerging || (comparisonResult.matched.length === 0 && comparisonResult.onlyInB.length === 0)}
              >
                {isMerging ? (
                  <>
                    <div className={styles.buttonSpinner} />
                    Merging...
                  </>
                ) : (
                  <>
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                      <path d="M8 6h13M8 12h13M8 18h13M3 6h.01M3 12h.01M3 18h.01" />
                    </svg>
                    Merge
                  </>
                )}
              </button>
            </div>
          </div>
        </div>
      )}

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

          {/* Count Product Section - Only show if session is active */}
          {isSessionActive && (
            <div className={receiveStyles.receiveSection}>
              <h3 className={receiveStyles.receiveSectionTitle}>Count Product</h3>

              <div className={receiveStyles.receiveContent}>
                {/* Left: Search and Input */}
                <div className={receiveStyles.receiveInputArea}>
                  {/* Search Box */}
                  <div className={receiveStyles.searchBox}>
                    <div className={receiveStyles.searchInputWrapper}>
                      {isSearching ? (
                        <div className={receiveStyles.searchSpinner} />
                      ) : (
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#94A3B8" strokeWidth="2">
                          <circle cx="11" cy="11" r="8" />
                          <path d="M21 21l-4.35-4.35" />
                        </svg>
                      )}
                      <input
                        ref={searchInputRef}
                        type="text"
                        className={receiveStyles.searchInput}
                        placeholder="Search by SKU, barcode, or product name..."
                        value={searchQuery}
                        onChange={(e) => setSearchQuery(e.target.value)}
                        onKeyDown={handleSearchKeyDown}
                      />
                      {searchQuery && (
                        <button
                          className={receiveStyles.clearSearchButton}
                          onClick={clearSearch}
                        >
                          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                            <path d="M18 6L6 18M6 6l12 12" />
                          </svg>
                        </button>
                      )}
                    </div>
                  </div>

                  {/* Search Results Dropdown */}
                  {searchResults.length > 0 && (
                    <div className={receiveStyles.searchResults}>
                      {searchResults.map((product: SearchProduct) => (
                        <div
                          key={product.product_id}
                          className={receiveStyles.searchResultItem}
                          onClick={() => handleSelectProduct(product)}
                        >
                          <div className={receiveStyles.searchResultImage}>
                            {product.image_urls && product.image_urls.length > 0 ? (
                              <img src={product.image_urls[0]} alt={product.product_name} />
                            ) : (
                              <div className={receiveStyles.noImage}>
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                                  <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                                  <circle cx="8.5" cy="8.5" r="1.5" />
                                  <polyline points="21 15 16 10 5 21" />
                                </svg>
                              </div>
                            )}
                          </div>
                          <div className={receiveStyles.resultInfo}>
                            <span className={receiveStyles.resultName}>{product.product_name}</span>
                            <span className={receiveStyles.resultMeta}>
                              {product.sku} • Selling price: {currency.symbol}{product.price.selling.toLocaleString()}
                            </span>
                          </div>
                        </div>
                      ))}
                    </div>
                  )}

                  {/* No results message */}
                  {searchQuery && searchResults.length === 0 && !isSearching && debouncedSearchQuery && (
                    <div className={receiveStyles.searchResults}>
                      <div className={receiveStyles.noResults}>
                        No products found for "{searchQuery}"
                      </div>
                    </div>
                  )}
                </div>

                {/* Right: Counted Entries Table */}
                <div className={receiveStyles.receivedEntriesArea}>
                  <div className={receiveStyles.entriesHeader}>
                    <h4>Counted Items</h4>
                    <span className={receiveStyles.entriesCount}>{receivedEntries.length} entries</span>
                  </div>

                  {receivedEntries.length === 0 ? (
                    <div className={receiveStyles.emptyEntries}>
                      <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#CBD5E1" strokeWidth="1.5">
                        <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2" />
                        <rect x="9" y="3" width="6" height="4" rx="1" />
                        <path d="M9 12h6M9 16h6" />
                      </svg>
                      <p>No items counted yet</p>
                      <span>Search and add products to start counting</span>
                    </div>
                  ) : (
                    <div className={receiveStyles.entriesTableContainer}>
                      <table className={receiveStyles.entriesTable}>
                        <thead>
                          <tr>
                            <th>Product</th>
                            <th>SKU</th>
                            <th>Qty</th>
                            <th></th>
                          </tr>
                        </thead>
                        <tbody>
                          {receivedEntries.map((entry: ReceivedEntry) => (
                            <tr key={entry.entry_id}>
                              <td className={receiveStyles.entryProduct}>{entry.product_name}</td>
                              <td className={receiveStyles.entrySku}>{entry.sku}</td>
                              <td className={receiveStyles.entryQty}>
                                <div className={receiveStyles.qtyControl}>
                                  <button
                                    className={receiveStyles.qtyButton}
                                    onClick={() => updateEntryQuantity(entry.entry_id, -1)}
                                  >
                                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                      <path d="M5 12h14" />
                                    </svg>
                                  </button>
                                  <input
                                    type="number"
                                    className={receiveStyles.qtyInput}
                                    value={entry.quantity}
                                    min="1"
                                    onChange={(e) => setEntryQuantity(entry.entry_id, parseInt(e.target.value) || 1)}
                                  />
                                  <button
                                    className={receiveStyles.qtyButton}
                                    onClick={() => updateEntryQuantity(entry.entry_id, 1)}
                                  >
                                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                      <path d="M12 5v14M5 12h14" />
                                    </svg>
                                  </button>
                                </div>
                              </td>
                              <td className={receiveStyles.entryActions}>
                                <button
                                  className={receiveStyles.removeEntryButton}
                                  onClick={() => removeEntry(entry.entry_id)}
                                  title="Remove item"
                                >
                                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                    <path d="M18 6L6 18M6 6l12 12" />
                                  </svg>
                                </button>
                              </td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>
                  )}
                </div>
              </div>

              {/* Save Status Messages */}
              {saveError && (
                <div className={receiveStyles.saveErrorMessage}>
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <circle cx="12" cy="12" r="10" />
                    <path d="M15 9l-6 6M9 9l6 6" />
                  </svg>
                  {saveError}
                  <button onClick={dismissSaveError} className={receiveStyles.dismissButton}>×</button>
                </div>
              )}
              {saveSuccess && (
                <div className={receiveStyles.saveSuccessMessage}>
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <path d="M20 6L9 17l-5-5" />
                  </svg>
                  Items saved successfully!
                </div>
              )}

              {/* Action Buttons */}
              <div className={receiveStyles.actionButtons}>
                <button
                  className={`${receiveStyles.saveButton} ${isSaving ? receiveStyles.saveButtonLoading : ''}`}
                  onClick={handleSave}
                  disabled={isSaving || receivedEntries.length === 0}
                >
                  {isSaving ? (
                    <>
                      <div className={receiveStyles.buttonSpinner} />
                      Saving...
                    </>
                  ) : (
                    <>
                      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                        <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z" />
                        <polyline points="17 21 17 13 7 13 7 21" />
                        <polyline points="7 3 7 8 15 8" />
                      </svg>
                      Save
                    </>
                  )}
                </button>
                <button
                  className={`${receiveStyles.submitButton} ${!canSubmit ? receiveStyles.submitButtonDisabled : ''}`}
                  onClick={handleSubmitClick}
                  disabled={!canSubmit}
                  title={!canSubmit ? 'Only the session owner can submit' : ''}
                >
                  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <path d="M22 2L11 13" />
                    <path d="M22 2l-7 20-4-9-9-4 20-7z" />
                  </svg>
                  Submit
                </button>
              </div>
            </div>
          )}
        </div>
      </div>
    </>
  );
};

export default CountingSessionPage;
