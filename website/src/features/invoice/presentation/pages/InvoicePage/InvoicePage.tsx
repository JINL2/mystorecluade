/**
 * InvoicePage Component
 * Invoice list and management
 * Refactored to use component composition (2025 Best Practice)
 */

import React, { useState, useEffect } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { useErrorMessage } from '@/shared/hooks/useErrorMessage';
import { useInvoice } from '../../hooks/useInvoice';
import { useRefundInvoice } from '../../hooks/useRefundInvoice';
import { useAppState } from '@/app/providers/app_state_provider';
import { LeftFilter } from '@/shared/components/common/LeftFilter';
import type { FilterSection } from '@/shared/components/common/LeftFilter';
import { DateTimeUtils } from '@/core/utils/datetime-utils';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';
import { InvoiceHeader } from './components/InvoiceHeader';
import { InvoiceTable } from './components/InvoiceTable';
import { InvoicePagination } from './components/InvoicePagination';
import { RefundModal } from './components/RefundModal';
import type { InvoicePageProps } from './InvoicePage.types';
import styles from './InvoicePage.module.css';

export const InvoicePage: React.FC<InvoicePageProps> = () => {
  const { currentCompany, currentUser, currentStore, setCurrentStore } = useAppState();
  const { messageState, closeMessage, showError, showSuccess } = useErrorMessage();

  // Get company ID from app state
  const companyId = currentCompany?.company_id || '';

  // Local search query state for real-time client-side filtering
  const [localSearchQuery, setLocalSearchQuery] = useState('');

  // Selection state - following inventory page pattern
  const [selectedInvoices, setSelectedInvoices] = useState<Set<string>>(new Set());

  // Expanded invoice state - following inventory page pattern
  const [expandedInvoiceId, setExpandedInvoiceId] = useState<string | null>(null);

  // Refund modal state
  const [isRefundModalOpen, setIsRefundModalOpen] = useState(false);

  // Get all state and actions from useInvoice hook (which wraps Zustand store)
  const {
    invoices,
    loading,
    error,
    pagination,
    currentPage,
    itemsPerPage,
    selectedStoreId,
    activeFilter,
    invoiceDetail,
    detailLoading,
    refunding,
    setSelectedStoreId: setInvoiceStoreId,
    changeDateRange,
    changePage,
    fetchInvoiceDetail,
    refundInvoice,
    refresh,
  } = useInvoice(companyId);

  // Get refund hook for handling refund operations
  const { refundInvoicesWithJournal } = useRefundInvoice();

  // Sync App State's currentStore to Invoice provider on mount and when currentStore changes
  useEffect(() => {
    const appStateStoreId = currentStore?.store_id || null;
    if (appStateStoreId !== selectedStoreId) {
      setInvoiceStoreId(appStateStoreId);
    }
  }, [currentStore, selectedStoreId, setInvoiceStoreId]);

  // Handle store selection - syncs App State and invoice provider
  const handleStoreSelect = (storeId: string | null) => {
    const selectedStore = stores.find((s) => s.store_id === storeId) || null;
    setCurrentStore(selectedStore); // Updates App State + localStorage
    setInvoiceStoreId(storeId); // Updates Invoice provider
  };

  // Clear selections when store changes
  useEffect(() => {
    setSelectedInvoices(new Set());
    setExpandedInvoiceId(null);
  }, [selectedStoreId]);

  // Handle refund for expanded invoice - opens modal with single invoice
  const handleRefund = (invoiceId: string) => {
    const invoice = invoices.find(inv => inv.invoiceId === invoiceId);
    if (!invoice) return;

    // Set the single invoice as selected and open modal
    setSelectedInvoices(new Set([invoiceId]));
    setIsRefundModalOpen(true);
  };

  // Get stores from current company
  const stores = currentCompany?.stores || [];

  // Client-side filtering for real-time search
  const filteredInvoices = invoices.filter((invoice) => {
    if (!localSearchQuery) return true;

    const query = localSearchQuery.toLowerCase();
    return (
      invoice.invoiceNumber.toLowerCase().includes(query) ||
      invoice.customerName.toLowerCase().includes(query) ||
      invoice.totalAmount.toString().includes(query) ||
      invoice.formatCurrency(invoice.totalAmount).toLowerCase().includes(query)
    );
  });

  // Selection handlers - following inventory page pattern
  const toggleInvoiceSelection = (invoiceId: string) => {
    const newSelection = new Set(selectedInvoices);
    if (newSelection.has(invoiceId)) {
      newSelection.delete(invoiceId);
    } else {
      newSelection.add(invoiceId);
    }
    setSelectedInvoices(newSelection);
  };

  const selectAllInvoices = () => {
    if (selectedInvoices.size === filteredInvoices.length) {
      setSelectedInvoices(new Set());
    } else {
      setSelectedInvoices(new Set(filteredInvoices.map(inv => inv.invoiceId)));
    }
  };

  // Handle row click to expand/collapse
  const handleRowClick = (invoiceId: string) => {
    const newExpandedId = expandedInvoiceId === invoiceId ? null : invoiceId;
    setExpandedInvoiceId(newExpandedId);
    if (newExpandedId) {
      fetchInvoiceDetail(newExpandedId);
    }
  };

  // Check if any selected invoice is cancelled
  const hasSelectedCancelledInvoice = Array.from(selectedInvoices).some(invoiceId => {
    const invoice = invoices.find(inv => inv.invoiceId === invoiceId);
    return invoice?.status === 'cancelled';
  });

  // Get selected invoice info for the modal
  const selectedInvoiceInfo = Array.from(selectedInvoices)
    .map(invoiceId => {
      const invoice = invoices.find(inv => inv.invoiceId === invoiceId);
      if (!invoice) return null;
      return {
        invoiceNumber: invoice.invoiceNumber,
        amount: invoice.totalAmount,
        currencySymbol: invoice.currencySymbol,
      };
    })
    .filter((info): info is { invoiceNumber: string; amount: number; currencySymbol: string } => info !== null);

  // Handle opening refund modal
  const handleOpenRefundModal = () => {
    setIsRefundModalOpen(true);
  };

  // Handle closing refund modal
  const handleCloseRefundModal = () => {
    setIsRefundModalOpen(false);
  };

  // Handle refund confirmation from modal
  const handleRefundConfirm = async (notes: string) => {
    if (!currentUser?.user_id || !companyId) {
      showError({
        title: 'Refund Failed',
        message: 'User information not available. Please log in again.'
      });
      return;
    }

    try {
      const invoiceIdsArray = Array.from(selectedInvoices);

      // Use refund hook to handle refund + journal entry creation
      const result = await refundInvoicesWithJournal({
        invoiceIds: invoiceIdsArray,
        notes,
        companyId,
        userId: currentUser.user_id,
        invoices,
      });

      setIsRefundModalOpen(false);

      // Show appropriate message based on result
      if (result.success) {
        showSuccess({
          message: `Successfully refunded ${result.totalSucceeded} invoice${result.totalSucceeded > 1 ? 's' : ''} and created ${result.journalSuccessCount} journal ${result.journalSuccessCount > 1 ? 'entries' : 'entry'}. Total amount: ${invoices[0]?.formatCurrency(result.totalAmountRefunded) || result.totalAmountRefunded}`,
          autoCloseDuration: 3000
        });
      } else if (result.totalFailed === 0 && result.journalFailCount > 0) {
        showError({
          title: 'Partial Success',
          message: `Successfully refunded ${result.totalSucceeded} invoice${result.totalSucceeded > 1 ? 's' : ''}, but ${result.journalFailCount} journal ${result.journalFailCount > 1 ? 'entries' : 'entry'} failed to create.`
        });
      } else {
        showError({
          title: 'Partial Refund',
          message: `Successfully refunded ${result.totalSucceeded} invoice${result.totalSucceeded > 1 ? 's' : ''}, but ${result.totalFailed} failed. ${result.journalSuccessCount > 0 ? `Created ${result.journalSuccessCount} journal ${result.journalSuccessCount > 1 ? 'entries' : 'entry'}.` : ''}`
        });
      }

      setSelectedInvoices(new Set());
    } catch (error) {
      setIsRefundModalOpen(false);
      showError({
        title: 'Refund Error',
        message: error instanceof Error ? error.message : 'An unexpected error occurred'
      });
    }
  };

  // Helper function to calculate date range (from DateFilterTabs logic)
  const calculateDateRange = (filter: string): { start: string; end: string } => {
    const today = new Date();
    let start: Date;
    let end: Date = new Date(today);

    switch (filter) {
      case 'all':
        start = new Date(today.getFullYear() - 10, 0, 1);
        break;
      case 'today':
        start = new Date(today);
        break;
      case 'yesterday':
        start = new Date(today);
        start.setDate(today.getDate() - 1);
        end = new Date(start);
        break;
      case 'this-week':
        start = new Date(today);
        const day = today.getDay();
        const diff = day === 0 ? -6 : 1 - day;
        start.setDate(today.getDate() + diff);
        break;
      case 'this-month':
        start = new Date(today.getFullYear(), today.getMonth(), 1);
        break;
      case 'last-month':
        start = new Date(today.getFullYear(), today.getMonth() - 1, 1);
        end = new Date(today.getFullYear(), today.getMonth(), 0);
        break;
      default:
        start = new Date(today);
    }

    return {
      start: DateTimeUtils.toDateOnly(start),
      end: DateTimeUtils.toDateOnly(end),
    };
  };

  // LeftFilter sections configuration (Date Range only - Search moved to header)
  const filterSections: FilterSection[] = [
    {
      id: 'date',
      title: 'Date Range',
      type: 'sort',
      defaultExpanded: true,
      selectedValues: activeFilter,
      options: [
        { value: 'all', label: 'All' },
        { value: 'today', label: 'Today' },
        { value: 'yesterday', label: 'Yesterday' },
        { value: 'this-week', label: 'This Week' },
        { value: 'this-month', label: 'This Month' },
        { value: 'last-month', label: 'Last Month' },
      ],
      onSelect: (value) => {
        const { start, end } = calculateDateRange(value);
        changeDateRange(value as any, start, end);
      },
    },
  ];

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
              onRefund={handleOpenRefundModal}
            />

            {/* Invoice Table */}
            <InvoiceTable
              invoices={filteredInvoices}
              selectedInvoices={selectedInvoices}
              expandedInvoiceId={expandedInvoiceId}
              invoiceDetail={invoiceDetail}
              detailLoading={detailLoading}
              refunding={refunding}
              localSearchQuery={localSearchQuery}
              onToggleSelection={toggleInvoiceSelection}
              onSelectAll={selectAllInvoices}
              onRowClick={handleRowClick}
              onRefund={handleRefund}
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

            {/* Refund Modal */}
            <RefundModal
              isOpen={isRefundModalOpen}
              selectedInvoices={selectedInvoiceInfo}
              onClose={handleCloseRefundModal}
              onConfirm={handleRefundConfirm}
              isRefunding={refunding}
            />
          </div>
        </div>
      </div>
    </>
  );
};

export default InvoicePage;
