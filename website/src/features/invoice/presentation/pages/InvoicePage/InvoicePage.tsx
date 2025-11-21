/**
 * InvoicePage Component
 * Invoice list and management
 * Refactored to use component composition (2025 Best Practice)
 */

import React, { useState } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { useErrorMessage } from '@/shared/hooks/useErrorMessage';
import { useInvoice } from '../../hooks/useInvoice';
import { useAppState } from '@/app/providers/app_state_provider';
import { LeftFilter } from '@/shared/components/common/LeftFilter';
import type { FilterSection } from '@/shared/components/common/LeftFilter';
import { DateTimeUtils } from '@/core/utils/datetime-utils';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';
import { InvoiceHeader } from './components/InvoiceHeader';
import { InvoiceTable } from './components/InvoiceTable';
import { InvoicePagination } from './components/InvoicePagination';
import type { InvoicePageProps } from './InvoicePage.types';
import styles from './InvoicePage.module.css';

export const InvoicePage: React.FC<InvoicePageProps> = () => {
  const { currentCompany } = useAppState();
  const { messageState, closeMessage, showError, showSuccess } = useErrorMessage();

  // Get company ID from app state
  const companyId = currentCompany?.company_id || '';

  // Local search query state for real-time client-side filtering
  const [localSearchQuery, setLocalSearchQuery] = useState('');

  // Selection state - following inventory page pattern
  const [selectedInvoices, setSelectedInvoices] = useState<Set<string>>(new Set());

  // Expanded invoice state - following inventory page pattern
  const [expandedInvoiceId, setExpandedInvoiceId] = useState<string | null>(null);

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
    setSelectedStoreId,
    changeDateRange,
    changePage,
    fetchInvoiceDetail,
    refundInvoice,
    refresh,
  } = useInvoice(companyId);

  // Handle refund for expanded invoice
  const handleRefund = async (invoiceId: string) => {
    if (!invoiceDetail) return;

    const invoice = invoices.find(inv => inv.invoiceId === invoiceId);
    if (!invoice) return;

    const confirmed = window.confirm(
      `Are you sure you want to refund invoice ${invoice.invoiceNumber}?\n\n` +
      `Total Amount: ${invoice.formatCurrency(invoiceDetail.amounts.total_amount)}\n\n` +
      `This action will:\n` +
      `- Reverse the payment\n` +
      `- Restore inventory quantities\n` +
      `- Mark the invoice as refunded\n\n` +
      `This action cannot be undone.`
    );

    if (!confirmed) return;

    try {
      const result = await refundInvoice(invoiceId);

      if (result.success) {
        showSuccess({
          message: result.message || 'Invoice refunded successfully',
          autoCloseDuration: 3000
        });
        setExpandedInvoiceId(null); // Close expanded row
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
                onStoreSelect={setSelectedStoreId}
                companyId={companyId}
                width="280px"
              />
            </div>

            {/* Invoice Header - Search and Actions */}
            <InvoiceHeader
              localSearchQuery={localSearchQuery}
              onSearchChange={setLocalSearchQuery}
              selectedInvoicesCount={selectedInvoices.size}
              onRefund={() => {}}
              onNewInvoice={() => {}}
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
          </div>
        </div>
      </div>
    </>
  );
};

export default InvoicePage;
