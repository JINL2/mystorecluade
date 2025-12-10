/**
 * ReceivingSessionPage Component
 * Page for receiving items in a session
 * Accessed after creating or joining a receiving session
 */

import React from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { ConfirmModal } from '@/shared/components/common/ConfirmModal';
import { useReceivingSession } from '../../hooks/useReceivingSession';
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
    handleSubmitConfirm,
    handleSubmitConfirmClose,
    handleSubmitReviewClose,
    handleFinalChoiceClose,
    handleReviewQuantityChange,
    handleFinalSubmit,
    handleSubmitSession,
    dismissSaveError,
  } = useReceivingSession();

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
