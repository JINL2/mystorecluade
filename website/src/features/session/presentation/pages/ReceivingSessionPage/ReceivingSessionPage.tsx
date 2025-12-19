/**
 * ReceivingSessionPage Component
 * Page for receiving items in a session
 * Accessed after creating or joining a receiving session
 */

import React from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { ConfirmModal } from '@/shared/components/common/ConfirmModal';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { SelectorModal } from '@/shared/components/common/SelectorModal';
import type { SelectorOption } from '@/shared/components/common/SelectorModal/SelectorModal.types';
import { useReceivingSession } from '../../hooks/useReceivingSession';
import type { ActiveSession, MatchedItem, OnlyInSessionItem } from '../../hooks/useReceivingSession';
import {
  SubmitReviewModal,
  FinalChoiceModal,
  ReceiveProductSection,
  ShipmentItemsCard,
} from './components';
import styles from './ReceivingSessionPage.module.css';

export const ReceivingSessionPage: React.FC = () => {
  const {
    // Session state
    sessionInfo,
    shipmentData,
    items,
    loading,
    error,
    currentUser,

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
    sessionItems,
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

    // Needs display modal state
    showNeedsDisplayModal,
    needsDisplayItems,
    submitResultData,

    // Calculated totals
    editableTotalQuantity,
    editableTotalRejected,
    totalShipped,
    totalReceived,
    totalAccepted,
    totalRejected,
    totalRemaining,
    progressPercentage,

    // Actions
    handleBack,
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

    // Needs display action
    handleNeedsDisplayClose,
  } = useReceivingSession();

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

  if (loading) {
    return (
      <>
        <Navbar activeItem="product" />
        <div className={styles.pageLayout}>
          <div className={styles.loadingContainer}>
            <div className={styles.spinner} />
            <p>Loading session...</p>
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
              Back to Receives
            </button>
          </div>
        </div>
      </>
    );
  }

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
        message="Choose how you want to submit this receiving session."
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
        sessionItems={sessionItems}
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
                Select another active receiving session to compare items with your current session.
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

      {/* Needs Display Modal - Show products that need to be displayed after receiving */}
      {showNeedsDisplayModal && needsDisplayItems.length > 0 && (
        <div className={styles.modalBackdrop}>
          <div className={styles.needsDisplayModal}>
            <div className={styles.needsDisplayHeader}>
              <h3>New Products Need Display</h3>
              <p className={styles.needsDisplaySubtext}>
                {needsDisplayItems.length} product{needsDisplayItems.length > 1 ? 's' : ''} had zero stock. Please display on shelf.
              </p>
            </div>
            <div className={styles.needsDisplayContent}>
              <table className={styles.needsDisplayTable}>
                <thead>
                  <tr>
                    <th>SKU</th>
                    <th>Product</th>
                    <th className={styles.thNumber}>Qty</th>
                  </tr>
                </thead>
                <tbody>
                  {needsDisplayItems.map((item) => (
                    <tr key={item.productId}>
                      <td className={styles.needsDisplaySku}>{item.sku}</td>
                      <td className={styles.needsDisplayProduct}>{item.productName}</td>
                      <td className={styles.needsDisplayQuantity}>
                        <span className={styles.quantityBadge}>{item.quantityReceived}</span>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
            {submitResultData && (
              <div className={styles.needsDisplaySummary}>
                <div className={styles.summaryItem}>
                  <span className={styles.summaryLabel}>Receiving #</span>
                  <span className={styles.summaryValue}>{submitResultData.receivingNumber}</span>
                </div>
                <div className={styles.summaryItem}>
                  <span className={styles.summaryLabel}>Items</span>
                  <span className={styles.summaryValue}>{submitResultData.itemsCount}</span>
                </div>
                <div className={styles.summaryItem}>
                  <span className={styles.summaryLabel}>Total Qty</span>
                  <span className={styles.summaryValue}>{submitResultData.totalQuantity}</span>
                </div>
              </div>
            )}
            <div className={styles.needsDisplayActions}>
              <button
                className={styles.needsDisplayConfirmButton}
                onClick={handleNeedsDisplayClose}
              >
                OK
              </button>
            </div>
          </div>
        </div>
      )}

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
                <h1 className={styles.title}>Receiving Session</h1>
                <div className={styles.sessionBadge}>
                  <span className={styles.badgeActive}>Active</span>
                  <span className={styles.storeName}>{sessionInfo?.store_name}</span>
                  {shipmentData && (
                    <span className={styles.shipmentBadge}>
                      {shipmentData.shipment_number}
                    </span>
                  )}
                </div>
              </div>
            </div>
          </div>

          {/* Shipment Info Banner */}
          {shipmentData && (
            <div className={styles.shipmentBanner}>
              <div className={styles.shipmentBannerContent}>
                <div className={styles.shipmentBannerLeft}>
                  <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
                    <polyline points="3.27 6.96 12 12.01 20.73 6.96" />
                    <line x1="12" y1="22.08" x2="12" y2="12" />
                  </svg>
                  <div className={styles.shipmentBannerInfo}>
                    <span className={styles.shipmentBannerLabel}>Shipment</span>
                    <span className={styles.shipmentBannerNumber}>{shipmentData.shipment_number}</span>
                  </div>
                </div>
                <div className={styles.shipmentBannerDetails}>
                  <div className={styles.shipmentBannerItem}>
                    <span className={styles.bannerItemLabel}>Supplier</span>
                    <span className={styles.bannerItemValue}>{shipmentData.supplier_name}</span>
                  </div>
                  <div className={styles.shipmentBannerItem}>
                    <span className={styles.bannerItemLabel}>Items</span>
                    <span className={styles.bannerItemValue}>{shipmentData.item_count}</span>
                  </div>
                  <div className={styles.shipmentBannerItem}>
                    <span className={styles.bannerItemLabel}>Status</span>
                    <span className={`${styles.bannerItemStatus} ${styles[shipmentData.status]}`}>
                      {shipmentData.status}
                    </span>
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* Items to Receive Card with Progress */}
          <ShipmentItemsCard
            items={items}
            totalShipped={totalShipped}
            totalReceived={totalReceived}
            totalAccepted={totalAccepted}
            totalRejected={totalRejected}
            totalRemaining={totalRemaining}
            progressPercentage={progressPercentage}
          />

          {/* Receive Product Section */}
          <ReceiveProductSection
            searchQuery={searchQuery}
            setSearchQuery={setSearchQuery}
            searchResults={searchResults}
            isSearching={isSearching}
            currency={currency}
            searchInputRef={searchInputRef}
            debouncedSearchQuery={debouncedSearchQuery}
            receivedEntries={receivedEntries}
            isSaving={isSaving}
            saveError={saveError}
            saveSuccess={saveSuccess}
            sessionOwnerId={sessionInfo?.created_by || ''}
            currentUserId={currentUser?.user_id || ''}
            onSearchKeyDown={handleSearchKeyDown}
            onSelectProduct={handleSelectProduct}
            onClearSearch={clearSearch}
            onUpdateQuantity={updateEntryQuantity}
            onSetQuantity={setEntryQuantity}
            onRemoveEntry={removeEntry}
            onSave={handleSave}
            onSubmitClick={handleSubmitClick}
            onDismissSaveError={dismissSaveError}
          />
        </div>
      </div>
    </>
  );
};

export default ReceivingSessionPage;
