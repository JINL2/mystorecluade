/**
 * InvoicePage Component
 * Invoice list and management
 * Refactored to use useInvoicePage hook (ARCHITECTURE.md: TSX ≤15KB rule)
 */

import React from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { ConfirmModal } from '@/shared/components/common/ConfirmModal/ConfirmModal';
import { LeftFilter } from '@/shared/components/common/LeftFilter';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';
import { InvoiceHeader } from './components/InvoiceHeader';
import { InvoiceTable } from './components/InvoiceTable';
import { InvoicePagination } from './components/InvoicePagination';
import { useInvoicePage } from '../../hooks/useInvoicePage';
import type { InvoicePageProps } from './InvoicePage.types';
import styles from './InvoicePage.module.css';

export const InvoicePage: React.FC<InvoicePageProps> = () => {
  const {
    // App State
    companyId,
    stores,

    // Invoice State
    invoices,
    filteredInvoices,
    loading,
    error,
    pagination,
    currentPage,
    itemsPerPage,
    selectedStoreId,
    invoiceDetail,
    detailLoading,
    refunding,

    // Local State
    localSearchQuery,
    selectedInvoices,
    expandedInvoiceId,
    refundModalOpen,
    refundProcessing,
    bulkRefundModalOpen,
    refundTargetInvoice,

    // Computed Values
    hasSelectedCancelledInvoice,
    bulkRefundTotalAmount,
    bulkRefundTotalCost,
    filterSections,

    // Message State
    messageState,
    closeMessage,

    // Actions
    setLocalSearchQuery,
    handleStoreSelect,
    toggleInvoiceSelection,
    selectAllInvoices,
    handleRowClick,
    handleBulkRefund,
    handleCloseBulkRefundModal,
    handleConfirmBulkRefund,
    handleSingleRefund,
    handleCloseRefundModal,
    handleConfirmRefund,
    changePage,
  } = useInvoicePage();

  // Show loading if no company selected yet
  if (!companyId) {
    return (
      <>
        <Navbar activeItem="product" />
        <div className={styles.pageLayout}>
          <LoadingAnimation fullscreen size="large" />
        </div>
      </>
    );
  }

  // Show loading state
  if (loading && invoices.length === 0) {
    return (
      <>
        <Navbar activeItem="product" />
        <div className={styles.pageLayout}>
          <LoadingAnimation fullscreen size="large" />
        </div>
      </>
    );
  }

  // Show error state
  if (error && invoices.length === 0) {
    return (
      <>
        <Navbar activeItem="product" />
        <div className={styles.pageLayout}>
          <div className={styles.errorContainer}>
            <h2 className={styles.errorTitle}>Failed to Load Invoices</h2>
            <p className={styles.errorMessage}>{error}</p>
          </div>
        </div>
      </>
    );
  }

  return (
    <>
      <Navbar activeItem="product" />
      <div className={styles.pageLayout}>
        {/* Left Sidebar Filter */}
        <div className={styles.sidebarWrapper}>
          <LeftFilter sections={filterSections} width={240} topOffset={64} />
        </div>

        {/* Main Content Area */}
        <div className={styles.mainContent}>
          <div className={styles.container}>
            {/* Page Header */}
            <div className={styles.header}>
              <div className={styles.headerLeft}>
                <h1 className={styles.title}>Invoices</h1>
                <p className={styles.subtitle}>Manage billing and payment records</p>
              </div>
            </div>

            {/* Store Filter Control */}
            <div className={styles.controlsContainer}>
              <StoreSelector
                stores={stores}
                selectedStoreId={selectedStoreId}
                onStoreSelect={handleStoreSelect}
                companyId={companyId}
                width="280px"
              />
            </div>

            {/* Invoice Header - Search and Actions */}
            <InvoiceHeader
              localSearchQuery={localSearchQuery}
              onSearchChange={setLocalSearchQuery}
              selectedInvoicesCount={selectedInvoices.size}
              hasSelectedCancelledInvoice={hasSelectedCancelledInvoice}
              onRefund={handleBulkRefund}
            />

            {/* Invoice Table */}
            <InvoiceTable
              invoices={filteredInvoices}
              selectedInvoices={selectedInvoices}
              localSearchQuery={localSearchQuery}
              expandedInvoiceId={expandedInvoiceId}
              invoiceDetail={invoiceDetail}
              detailLoading={detailLoading}
              refundLoading={refunding}
              onToggleSelection={toggleInvoiceSelection}
              onSelectAll={selectAllInvoices}
              onRowClick={handleRowClick}
              onRefund={handleSingleRefund}
            />

            {/* Pagination */}
            {pagination && pagination.total_pages > 1 && (
              <InvoicePagination
                pagination={pagination}
                currentPage={currentPage}
                itemsPerPage={itemsPerPage}
                onPageChange={changePage}
              />
            )}

            {/* Error/Success Message */}
            <ErrorMessage
              variant={messageState.variant}
              title={messageState.title}
              message={messageState.message}
              isOpen={messageState.isOpen}
              onClose={closeMessage}
            />
          </div>
        </div>
      </div>

      {/* Refund Confirmation Modal */}
      <ConfirmModal
        isOpen={refundModalOpen}
        onClose={handleCloseRefundModal}
        onConfirm={handleConfirmRefund}
        variant="warning"
        title="Confirm Refund"
        message={`Are you sure you want to refund invoice ${refundTargetInvoice?.invoiceNumber || ''}? This action will reverse the sale and restore inventory.`}
        confirmText="Refund"
        cancelText="Cancel"
        confirmButtonVariant="error"
        isLoading={refundProcessing}
        width="450px"
        closeOnBackdropClick={true}
      >
        {refundTargetInvoice && (
          <div style={{ padding: '16px 0', borderTop: '1px solid #E9ECEF' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '8px' }}>
              <span style={{ color: '#6C757D', fontSize: '14px' }}>Total Amount</span>
              <span style={{ fontWeight: 600, fontSize: '14px', color: '#212529' }}>
                {refundTargetInvoice.formatCurrency(refundTargetInvoice.totalAmount)}
              </span>
            </div>
            <div style={{ display: 'flex', justifyContent: 'space-between' }}>
              <span style={{ color: '#6C757D', fontSize: '14px' }}>Total Cost</span>
              <span style={{ fontWeight: 600, fontSize: '14px', color: '#212529' }}>
                {refundTargetInvoice.formatCurrency(refundTargetInvoice.totalCost)}
              </span>
            </div>
          </div>
        )}
      </ConfirmModal>

      {/* Bulk Refund Confirmation Modal */}
      <ConfirmModal
        isOpen={bulkRefundModalOpen}
        onClose={handleCloseBulkRefundModal}
        onConfirm={handleConfirmBulkRefund}
        variant="warning"
        title="Confirm Bulk Refund"
        message={`Are you sure you want to refund ${selectedInvoices.size} invoice${selectedInvoices.size > 1 ? 's' : ''}? This action will reverse the sales and restore inventory.`}
        confirmText="Refund All"
        cancelText="Cancel"
        confirmButtonVariant="error"
        isLoading={refundProcessing}
        width="450px"
        closeOnBackdropClick={true}
      >
        {selectedInvoices.size > 0 && (
          <div style={{ padding: '16px 0', borderTop: '1px solid #E9ECEF' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '8px' }}>
              <span style={{ color: '#6C757D', fontSize: '14px' }}>Selected Invoices</span>
              <span style={{ fontWeight: 600, fontSize: '14px', color: '#212529' }}>
                {selectedInvoices.size}
              </span>
            </div>
            <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '8px' }}>
              <span style={{ color: '#6C757D', fontSize: '14px' }}>Total Refund Amount</span>
              <span style={{ fontWeight: 600, fontSize: '14px', color: '#DC3545' }}>
                {invoices[0]?.formatCurrency(bulkRefundTotalAmount) || bulkRefundTotalAmount}
              </span>
            </div>
            <div style={{ display: 'flex', justifyContent: 'space-between' }}>
              <span style={{ color: '#6C757D', fontSize: '14px' }}>Total Cost</span>
              <span style={{ fontWeight: 600, fontSize: '14px', color: '#212529' }}>
                {invoices[0]?.formatCurrency(bulkRefundTotalCost) || bulkRefundTotalCost}
              </span>
            </div>
          </div>
        )}
      </ConfirmModal>

      {/* Refund Processing Overlay */}
      {refundProcessing && (
        <div
          style={{
            position: 'fixed',
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            backgroundColor: 'rgba(255, 255, 255, 0.9)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            zIndex: 9999,
          }}
        >
          <LoadingAnimation size="large" />
        </div>
      )}
    </>
  );
};

export default InvoicePage;
