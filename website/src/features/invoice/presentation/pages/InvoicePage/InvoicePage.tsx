/**
 * InvoicePage Component
 * Invoice list and management
 * Refactored to use Zustand provider pattern (2025 Best Practice)
 */

import React, { useEffect } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { useErrorMessage } from '@/shared/hooks/useErrorMessage';
import { useInvoice } from '../../hooks/useInvoice';
import { TossButton } from '@/shared/components/toss/TossButton';
import { useAppState } from '@/app/providers/app_state_provider';
import { DateFilterTabs } from '../../components/DateFilterTabs';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';
import type { InvoicePageProps } from './InvoicePage.types';
import styles from './InvoicePage.module.css';

export const InvoicePage: React.FC<InvoicePageProps> = () => {
  const { currentCompany } = useAppState();
  const { messageState, closeMessage, showError, showSuccess } = useErrorMessage();

  // Get company ID from app state
  const companyId = currentCompany?.company_id || '';

  // Get all state and actions from useInvoice hook (which wraps Zustand store)
  const {
    invoices,
    loading,
    error,
    pagination,
    currentPage,
    searchQuery,
    selectedStoreId,
    activeFilter,
    selectedInvoice,
    invoiceDetail,
    detailLoading,
    refunding,
    setSelectedStoreId,
    setSelectedInvoice,
    changeDateRange,
    changeSearch,
    changePage,
    fetchInvoiceDetail,
    refundInvoice,
    refresh,
    clearDetail,
  } = useInvoice(companyId);

  // Fetch detail when invoice is selected
  useEffect(() => {
    if (selectedInvoice?.invoiceId) {
      fetchInvoiceDetail(selectedInvoice.invoiceId);
    }
  }, [selectedInvoice, fetchInvoiceDetail]);

  // Clear detail when modal closes
  const handleCloseModal = () => {
    clearDetail();
  };

  // Handle refund
  const handleRefund = async () => {
    if (!selectedInvoice || !invoiceDetail) return;

    const confirmed = window.confirm(
      `Are you sure you want to refund invoice ${selectedInvoice.invoiceNumber}?\n\n` +
      `Total Amount: ${selectedInvoice.formatCurrency(invoiceDetail.amounts.total_amount)}\n\n` +
      `This action will:\n` +
      `- Reverse the payment\n` +
      `- Restore inventory quantities\n` +
      `- Mark the invoice as refunded\n\n` +
      `This action cannot be undone.`
    );

    if (!confirmed) return;

    try {
      const result = await refundInvoice(selectedInvoice.invoiceId);

      if (result.success) {
        showSuccess({
          message: result.message || 'Invoice refunded successfully',
          autoCloseDuration: 3000
        });
        handleCloseModal();
        refresh(); // Refresh invoice list
      } else {
        showError({
          title: 'Refund Failed',
          message: result.error || 'Failed to refund invoice. Please try again.'
        });
      }
    } catch (error) {
      showError({
        title: 'Refund Error',
        message: error instanceof Error ? error.message : 'An unexpected error occurred'
      });
    }
  };

  console.log('🔵 InvoicePage - render with:', {
    companyId,
    selectedStoreId,
    storesCount: currentCompany?.stores?.length || 0,
  });

  // Get stores from current company
  const stores = currentCompany?.stores || [];

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

  if (loading) {
    return (
      <>
        <Navbar activeItem="product" />
        <div className={styles.pageLayout}>
          <div className={styles.container}>
            <div className={styles.header}>
              <div className={styles.headerLeft}>
                <h1 className={styles.title}>Invoices</h1>
              </div>
            </div>
            <LoadingAnimation fullscreen size="large" />
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
          <div className={styles.container}>
            <div className={styles.header}>
              <div className={styles.headerLeft}>
                <h1 className={styles.title}>Invoices</h1>
              </div>
            </div>
            <div className={styles.errorContainer}>
              <svg className={styles.errorIcon} width="120" height="120" viewBox="0 0 120 120" fill="none" xmlns="http://www.w3.org/2000/svg">
                {/* Background Circle */}
                <circle cx="60" cy="60" r="50" fill="#FFEFED"/>

                {/* Error Symbol */}
                <circle cx="60" cy="60" r="30" fill="#FF5847"/>
                <path d="M60 45 L60 65" stroke="white" strokeWidth="4" strokeLinecap="round"/>
                <circle cx="60" cy="73" r="2.5" fill="white"/>

                {/* Document with Error */}
                <rect x="40" y="25" width="40" height="50" rx="4" fill="white" stroke="#FF5847" strokeWidth="2"/>
              </svg>
              <h2 className={styles.errorTitle}>Failed to Load Invoices</h2>
              <p className={styles.errorMessage}>{error}</p>
              <TossButton onClick={refresh} variant="primary">
                Try Again
              </TossButton>
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
        <div className={styles.container}>
        <div className={styles.header}>
          <div className={styles.headerLeft}>
            <h1 className={styles.title}>Invoices</h1>
            <p className={styles.subtitle}>Manage billing and payment records</p>
          </div>
          <div className={styles.headerActions}>
            <TossButton variant="secondary" size="md">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" style={{ marginRight: '8px' }}>
                <path d="M14,13V17H10V13H7L12,8L17,13M19.35,10.03C18.67,6.59 15.64,4 12,4C9.11,4 6.6,5.64 5.35,8.03C2.34,8.36 0,10.9 0,14A6,6 0 0,0 6,20H19A5,5 0 0,0 24,15C24,12.36 21.95,10.22 19.35,10.03Z"/>
              </svg>
              Export
            </TossButton>
            <TossButton variant="primary" size="md">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" style={{ marginRight: '8px' }}>
                <path d="M19,13H13V19H11V13H5V11H11V5H13V11H19V13Z"/>
              </svg>
              New Invoice
            </TossButton>
          </div>
        </div>

        {/* Store Filter Control */}
        <div className={styles.controlsContainer}>
          <StoreSelector
            stores={stores}
            selectedStoreId={selectedStoreId}
            onStoreSelect={setSelectedStoreId}
            companyId={companyId}
            width="280px"
          />
        </div>

        {/* Date Filter Tabs */}
        <div className={styles.dateFilterContainer}>
          <DateFilterTabs
            activeFilter={activeFilter}
            onFilterChange={changeDateRange}
          />
        </div>

        {/* Search Bar */}
        <div className={styles.searchFilterBar}>
          <div className={styles.searchInputWrapper}>
            <svg className={styles.searchIcon} viewBox="0 0 24 24" fill="currentColor">
              <path d="M9.5,3A6.5,6.5 0 0,1 16,9.5C16,11.11 15.41,12.59 14.44,13.73L14.71,14H15.5L20.5,19L19,20.5L14,15.5V14.71L13.73,14.44C12.59,15.41 11.11,16 9.5,16A6.5,6.5 0 0,1 3,9.5A6.5,6.5 0 0,1 9.5,3M9.5,5C7,5 5,7 5,9.5C5,12 7,14 9.5,14C12,14 14,12 14,9.5C14,7 12,5 9.5,5Z"/>
            </svg>
            <input
              type="text"
              className={styles.searchInput}
              placeholder="Search by invoice number, customer, or amount..."
              value={searchQuery}
              onChange={(e) => changeSearch(e.target.value)}
            />
          </div>
        </div>

      {invoices.length === 0 ? (
        <div className={styles.emptyState}>
          <svg className={styles.emptyIcon} width="120" height="120" viewBox="0 0 120 120" fill="none" xmlns="http://www.w3.org/2000/svg">
            {/* Background Circle */}
            <circle cx="60" cy="60" r="50" fill="#F0F6FF"/>

            {/* Document Stack */}
            <rect x="35" y="40" width="50" height="60" rx="4" fill="white" stroke="#0064FF" strokeWidth="2"/>
            <rect x="40" y="35" width="50" height="60" rx="4" fill="white" stroke="#0064FF" strokeWidth="2"/>

            {/* Document Lines */}
            <line x1="48" y1="45" x2="75" y2="45" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round"/>
            <line x1="48" y1="52" x2="70" y2="52" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round"/>
            <line x1="48" y1="59" x2="72" y2="59" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round"/>

            {/* Invoice Symbol (Receipt Icon) */}
            <circle cx="60" cy="75" r="12" fill="#0064FF"/>
            <path d="M56 75 L58 77 L64 71" stroke="white" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
          </svg>
          <h3 className={styles.emptyTitle}>No Invoices</h3>
          <p className={styles.emptyText}>No invoice records found for the selected period</p>
        </div>
      ) : (
        <>
          {/* Invoice Table */}
          <div className={styles.invoiceTableContainer}>
            <table className={styles.invoiceTable}>
              <thead>
                <tr>
                  <th>INVOICE #</th>
                  <th>DATE</th>
                  <th>CUSTOMER</th>
                  <th>ITEMS</th>
                  <th>PAYMENT</th>
                  <th>TOTAL</th>
                  <th>STATUS</th>
                  <th>ACTIONS</th>
                </tr>
              </thead>
              <tbody>
                {invoices.map((invoice) => (
                  <tr
                    key={invoice.invoiceId}
                    className={styles.invoiceRow}
                    onClick={() => setSelectedInvoice(invoice)}
                    style={{ cursor: 'pointer' }}
                  >
                    <td className={styles.invoiceNumber}>{invoice.invoiceNumber}</td>
                    <td className={styles.invoiceDate}>{invoice.formattedDate}</td>
                    <td className={styles.customerCell}>
                      {invoice.customerName}
                    </td>
                    <td className={styles.itemsCell}>
                      <div className={styles.itemCount}>{invoice.itemCount} items</div>
                      <div className={styles.itemQty}>Qty: {invoice.totalQuantity}</div>
                    </td>
                    <td className={styles.paymentCell}>
                      <span className={`${styles.paymentBadge} ${styles[invoice.paymentBadgeClass]}`}>
                        {invoice.paymentMethodDisplay}
                      </span>
                    </td>
                    <td className={styles.totalCell}>
                      {invoice.formatCurrency(invoice.totalAmount)}
                    </td>
                    <td className={styles.statusCell}>
                      <span className={`${styles.statusBadge} ${styles[invoice.status]}`}>
                        {invoice.statusDisplay.toUpperCase()}
                      </span>
                    </td>
                    <td className={styles.actionsCell} onClick={(e) => e.stopPropagation()}>
                      <button className={styles.actionBtn} title="View" onClick={() => setSelectedInvoice(invoice)}>
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                          <path d="M12,9A3,3 0 0,0 9,12A3,3 0 0,0 12,15A3,3 0 0,0 15,12A3,3 0 0,0 12,9M12,17A5,5 0 0,1 7,12A5,5 0 0,1 12,7A5,5 0 0,1 17,12A5,5 0 0,1 12,17M12,4.5C7,4.5 2.73,7.61 1,12C2.73,16.39 7,19.5 12,19.5C17,19.5 21.27,16.39 23,12C21.27,7.61 17,4.5 12,4.5Z"/>
                        </svg>
                      </button>
                      <button className={styles.actionBtn} title="Edit">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                          <path d="M20.71,7.04C21.1,6.65 21.1,6 20.71,5.63L18.37,3.29C18,2.9 17.35,2.9 16.96,3.29L15.12,5.12L18.87,8.87M3,17.25V21H6.75L17.81,9.93L14.06,6.18L3,17.25Z"/>
                        </svg>
                      </button>
                      <button className={styles.actionBtn} title="Print">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                          <path d="M18,3H6V7H18M19,12A1,1 0 0,1 18,11A1,1 0 0,1 19,10A1,1 0 0,1 20,11A1,1 0 0,1 19,12M16,19H8V14H16M19,8H5A3,3 0 0,0 2,11V17H6V21H18V17H22V11A3,3 0 0,0 19,8Z"/>
                        </svg>
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          {/* Pagination */}
          {pagination && pagination.total_pages > 1 && (
            <div className={styles.pagination}>
              <TossButton
                variant="secondary"
                size="sm"
                onClick={() => changePage(currentPage - 1)}
                disabled={!pagination.has_prev}
              >
                Previous
              </TossButton>
              <div className={styles.paginationInfo}>
                Page {currentPage} of {pagination.total_pages} ({pagination.total_count} total)
              </div>
              <TossButton
                variant="secondary"
                size="sm"
                onClick={() => changePage(currentPage + 1)}
                disabled={!pagination.has_next}
              >
                Next
              </TossButton>
            </div>
          )}
        </>
      )}

      {/* Invoice Detail Modal */}
      {selectedInvoice && (
        <div className={styles.modalOverlay} onClick={handleCloseModal}>
          <div className={styles.modalContent} onClick={(e) => e.stopPropagation()}>
            {/* Header */}
            <div className={styles.modalHeader}>
              <div>
                <h2 className={styles.modalTitle}>{selectedInvoice.invoiceNumber}</h2>
                <p className={styles.modalSubtitle}>{selectedInvoice.formattedDate}</p>
              </div>
              <button className={styles.modalCloseBtn} onClick={handleCloseModal}>
                <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z"/>
                </svg>
              </button>
            </div>

            {/* Content */}
            <div className={styles.modalBody}>
              {detailLoading ? (
                <LoadingAnimation fullscreen size="large" />
              ) : invoiceDetail ? (
                <>
                  {/* Quick Summary */}
                  <div className={styles.modalSummary}>
                    <div>
                      <p className={styles.summaryLabel}>Total Amount</p>
                      <p className={styles.summaryAmount}>
                        {selectedInvoice.formatCurrency(invoiceDetail.amounts.total_amount)}
                      </p>
                    </div>
                    <span className={`${styles.statusBadge} ${styles[invoiceDetail.invoice.status]}`}>
                      {invoiceDetail.invoice.status.toUpperCase()}
                    </span>
                  </div>

                  {/* Store */}
                  <div className={styles.modalSection}>
                    <div className={styles.sectionHeader}>
                      <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M12,2L2,7V17H4V22H20V17H22V7L12,2M11,18H6V17H11V18M11,15H6V14H11V15M11,12H6V11H11V12M11,9H6V8H11V9M18,18H13V17H18V18M18,15H13V14H18V15M18,12H13V11H18V12M18,9H13V8H18V9Z"/>
                      </svg>
                      <span className={styles.sectionTitle}>Store</span>
                    </div>
                    <p className={styles.sectionContent}>{invoiceDetail.invoice.store_name}</p>
                  </div>

                  {/* Customer */}
                  <div className={styles.modalSection}>
                    <div className={styles.sectionHeader}>
                      <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M12,4A4,4 0 0,1 16,8A4,4 0 0,1 12,12A4,4 0 0,1 8,8A4,4 0 0,1 12,4M12,14C16.42,14 20,15.79 20,18V20H4V18C4,15.79 7.58,14 12,14Z"/>
                      </svg>
                      <span className={styles.sectionTitle}>Customer</span>
                    </div>
                    <p className={styles.sectionContent}>{invoiceDetail.invoice.customer_name || 'Walk-in'}</p>
                  </div>

                  {/* Items Table */}
                  <div className={styles.modalSection}>
                    <div className={styles.sectionHeader}>
                      <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M17,18A2,2 0 0,1 19,20A2,2 0 0,1 17,22C15.89,22 15,21.1 15,20C15,18.89 15.89,18 17,18M1,2H4.27L5.21,4H20A1,1 0 0,1 21,5C21,5.17 20.95,5.34 20.88,5.5L17.3,11.97C16.96,12.58 16.3,13 15.55,13H8.1L7.2,14.63L7.17,14.75A0.25,0.25 0 0,0 7.42,15H19V17H7C5.89,17 5,16.1 5,15C5,14.65 5.09,14.32 5.24,14.04L6.6,11.59L3,4H1V2M7,18A2,2 0 0,1 9,20A2,2 0 0,1 7,22C5.89,22 5,21.1 5,20C5,18.89 5.89,18 7,18M16,11L18.78,6H6.14L8.5,11H16Z"/>
                      </svg>
                      <span className={styles.sectionTitle}>Items ({invoiceDetail.items.length})</span>
                    </div>
                    <div className={styles.itemsTable}>
                      <table>
                        <thead>
                          <tr>
                            <th>PRODUCT</th>
                            <th>SKU</th>
                            <th>QTY</th>
                            <th>UNIT PRICE</th>
                            <th>DISCOUNT</th>
                            <th>TOTAL</th>
                          </tr>
                        </thead>
                        <tbody>
                          {invoiceDetail.items.map((item) => (
                            <tr key={item.item_id}>
                              <td>{item.product_name}</td>
                              <td>{item.sku}</td>
                              <td>{item.quantity_sold}</td>
                              <td>{selectedInvoice.formatCurrency(item.unit_price)}</td>
                              <td>{selectedInvoice.formatCurrency(item.discount_amount)}</td>
                              <td>{selectedInvoice.formatCurrency(item.total_amount)}</td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>
                  </div>

                  {/* Payment & Amounts */}
                  <div className={styles.paymentAmountsRow}>
                    {/* Payment Information */}
                    <div className={styles.modalSection}>
                      <div className={styles.sectionHeader}>
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                          <path d="M20,8H4V6H20M20,18H4V12H20M20,4H4C2.89,4 2,4.89 2,6V18A2,2 0 0,0 4,20H20A2,2 0 0,0 22,18V6C22,4.89 21.1,4 20,4Z"/>
                        </svg>
                        <span className={styles.sectionTitle}>Payment Information</span>
                      </div>
                      <div className={styles.paymentInfo}>
                        <div className={styles.paymentRow}>
                          <span>Method:</span>
                          <span className={styles.paymentValue}>{invoiceDetail.payment.method.toUpperCase()}</span>
                        </div>
                        <div className={styles.paymentRow}>
                          <span>Status:</span>
                          <span className={`${styles.paymentBadge} ${invoiceDetail.payment.status === 'paid' ? styles.paymentPaid : styles.paymentPending}`}>
                            {invoiceDetail.payment.status.toUpperCase()}
                          </span>
                        </div>
                      </div>
                    </div>

                    {/* Amount Summary */}
                    <div className={styles.modalSection}>
                      <div className={styles.sectionHeader}>
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                          <path d="M7,15H9C9,16.08 10.37,17 12,17C13.63,17 15,16.08 15,15C15,13.9 13.96,13.5 11.76,12.97C9.64,12.44 7,11.78 7,9C7,7.21 8.47,5.69 10.5,5.18V3H13.5V5.18C15.53,5.69 17,7.21 17,9H15C15,7.92 13.63,7 12,7C10.37,7 9,7.92 9,9C9,10.1 10.04,10.5 12.24,11.03C14.36,11.56 17,12.22 17,15C17,16.79 15.53,18.31 13.5,18.82V21H10.5V18.82C8.47,18.31 7,16.79 7,15Z"/>
                        </svg>
                        <span className={styles.sectionTitle}>Amount Summary</span>
                      </div>
                      <div className={styles.amountSummary}>
                        <div className={styles.amountRow}>
                          <span>Subtotal:</span>
                          <span>{selectedInvoice.formatCurrency(invoiceDetail.amounts.subtotal)}</span>
                        </div>
                        <div className={styles.amountRow}>
                          <span>Tax:</span>
                          <span>{selectedInvoice.formatCurrency(invoiceDetail.amounts.tax_amount)}</span>
                        </div>
                        <div className={styles.amountRow}>
                          <span>Discount:</span>
                          <span>{selectedInvoice.formatCurrency(invoiceDetail.amounts.discount_amount)}</span>
                        </div>
                        <div className={`${styles.amountRow} ${styles.totalRow}`}>
                          <span>Total:</span>
                          <span>{selectedInvoice.formatCurrency(invoiceDetail.amounts.total_amount)}</span>
                        </div>
                      </div>
                    </div>
                  </div>

                  {/* Inventory Impact */}
                  {invoiceDetail.inventory_movements && invoiceDetail.inventory_movements.length > 0 && (
                    <div className={styles.modalSection}>
                      <div className={styles.sectionHeader}>
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                          <path d="M6,2V8H6V8L10,12L6,16V16H6V22H18V16H18V16L14,12L18,8V8H18V2H6M16,16.5V20H8V16.5L12,12.5L16,16.5M12,11.5L8,7.5V4H16V7.5L12,11.5Z"/>
                        </svg>
                        <span className={styles.sectionTitle}>Inventory Impact</span>
                      </div>
                      <div className={styles.inventoryTable}>
                        <table>
                          <thead>
                            <tr>
                              <th>PRODUCT</th>
                              <th>QTY CHANGE</th>
                              <th>STOCK BEFORE</th>
                              <th>STOCK AFTER</th>
                            </tr>
                          </thead>
                          <tbody>
                            {invoiceDetail.inventory_movements.map((movement, idx) => (
                              <tr key={idx}>
                                <td>{movement.product_name}</td>
                                <td className={movement.quantity_change < 0 ? styles.negative : styles.positive}>
                                  {movement.quantity_change}
                                </td>
                                <td>{movement.stock_before}</td>
                                <td>{movement.stock_after}</td>
                              </tr>
                            ))}
                          </tbody>
                        </table>
                      </div>
                    </div>
                  )}

                  {/* Refund Button */}
                  {invoiceDetail.invoice.status === 'completed' && (
                    <div className={styles.modalActions}>
                      <TossButton
                        variant="error"
                        size="md"
                        onClick={handleRefund}
                        disabled={refunding}
                        loading={refunding}
                      >
                        {refunding ? 'Refunding...' : 'Refund Invoice'}
                      </TossButton>
                    </div>
                  )}
                </>
              ) : (
                <div className={styles.errorContainer}>
                  <p>Failed to load invoice details</p>
                </div>
              )}
            </div>
          </div>
        </div>
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
    </>
  );
};

export default InvoicePage;
