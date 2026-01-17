/**
 * CountingSessionPage Component
 * Page for viewing counting session details
 * Shows items scanned with per-user breakdown
 * Now includes product search and add functionality (same as receiving)
 */

import React from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { ConfirmModal } from '@/shared/components/common/ConfirmModal';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { SelectorModal } from '@/shared/components/common/SelectorModal';
import type { SelectorOption } from '@/shared/components/common/SelectorModal/SelectorModal.types';
import { useCountingSessionDetail } from '../../hooks/useCountingSessionDetail';
import {
  SubmitReviewModal,
  FinalChoiceModal,
} from '../ReceivingSessionPage/components';
import {
  SessionSelectModal,
  ComparisonModal,
  CountingSessionHeader,
  CountedItemsTable,
  CountProductSection,
} from './components';
import styles from './CountingSessionPage.module.css';

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
        editableItems={editableItems.map(item => ({
          productId: item.product_id,
          variantId: item.variant_id,
          productName: item.product_name,
          quantity: item.quantity,
          quantityRejected: item.quantity_rejected,
        }))}
        sessionItems={items.map(item => ({
          productId: item.productId,
          productName: item.productName,
          displayName: item.productName,
          sku: '',
          displaySku: '',
          hasVariants: false,
          totalQuantity: item.totalQuantity,
          totalRejected: item.totalRejected,
          scannedBy: item.scannedBy.map(u => ({
            userId: u.userId,
            userName: u.userName,
            quantity: u.quantity,
            quantityRejected: u.quantityRejected,
          })),
        }))}
        editableTotalQuantity={editableTotalQuantity}
        editableTotalRejected={editableTotalRejected}
        onClose={handleSubmitReviewClose}
        onConfirm={handleSubmitConfirm}
        onQuantityChange={(productId, field, value) => {
          // Convert camelCase field to snake_case for hook
          const snakeField = field === 'quantityRejected' ? 'quantity_rejected' : 'quantity';
          handleReviewQuantityChange(productId, snakeField as 'quantity' | 'quantity_rejected', value);
        }}
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
      <SessionSelectModal
        isOpen={showSessionSelectModal}
        sessions={availableSessions}
        onClose={handleSessionSelectClose}
        onSelect={handleCombineSessionSelect}
      />

      {/* Comparison Loading */}
      {isLoadingComparison && <LoadingAnimation fullscreen size="large" />}

      {/* Comparison Modal */}
      <ComparisonModal
        isOpen={showComparisonModal}
        comparisonResult={comparisonResult}
        comparisonError={comparisonError}
        isMerging={isMerging}
        mergeError={mergeError}
        onClose={handleComparisonClose}
        onMerge={handleMergeSessions}
      />

      <div className={styles.pageLayout}>
        <div className={styles.container}>
          {/* Header and Session Banner */}
          <CountingSessionHeader
            sessionInfo={sessionInfo}
            statusInfo={statusInfo}
            onBack={handleBack}
          />

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
            <CountedItemsTable items={items} />
          </div>

          {/* Count Product Section - Only show if session is active */}
          {isSessionActive && (
            <CountProductSection
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
              canSubmit={canSubmit}
              handleSelectProduct={handleSelectProduct}
              handleSearchKeyDown={handleSearchKeyDown}
              updateEntryQuantity={updateEntryQuantity}
              setEntryQuantity={setEntryQuantity}
              removeEntry={removeEntry}
              clearSearch={clearSearch}
              handleSave={handleSave}
              handleSubmitClick={handleSubmitClick}
              dismissSaveError={dismissSaveError}
            />
          )}
        </div>
      </div>
    </>
  );
};

export default CountingSessionPage;
