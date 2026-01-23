/**
 * useInvoicePage Hook
 * Custom hook for InvoicePage logic separation
 * Following ARCHITECTURE.md: TSX ≤15KB rule
 */

import { useState, useEffect, useMemo, useCallback } from 'react';
import { useErrorMessage } from '@/shared/hooks/useErrorMessage';
import { useInvoice } from './useInvoice';
import { useRefundInvoice } from './useRefundInvoice';
import { useAppState } from '@/app/providers/app_state_provider';
import { DateTimeUtils } from '@/core/utils/datetime-utils';
import type { FilterSection } from '@/shared/components/common/LeftFilter';
import type { Invoice } from '../../domain/entities/Invoice';

interface UseInvoicePageReturn {
  // App State
  companyId: string;
  stores: any[];
  currentUser: any;

  // Invoice State
  invoices: Invoice[];
  filteredInvoices: Invoice[];
  loading: boolean;
  error: string | null;
  pagination: any;
  currentPage: number;
  itemsPerPage: number;
  selectedStoreId: string | null;
  activeFilter: string;
  invoiceDetail: any;
  detailLoading: boolean;
  refunding: boolean;

  // Local State
  localSearchQuery: string;
  selectedInvoices: Set<string>;
  expandedInvoiceId: string | null;
  refundModalOpen: boolean;
  refundTargetInvoiceId: string | null;
  refundProcessing: boolean;
  bulkRefundModalOpen: boolean;
  refundTargetInvoice: Invoice | null;

  // Computed Values
  hasSelectedCancelledInvoice: boolean;
  bulkRefundTotalAmount: number;
  bulkRefundTotalCost: number;
  filterSections: FilterSection[];

  // Message State
  messageState: any;
  closeMessage: () => void;

  // Actions
  setLocalSearchQuery: (query: string) => void;
  handleStoreSelect: (storeId: string | null) => void;
  toggleInvoiceSelection: (invoiceId: string) => void;
  selectAllInvoices: () => void;
  handleRowClick: (invoiceId: string) => void;
  handleBulkRefund: () => void;
  handleCloseBulkRefundModal: () => void;
  handleConfirmBulkRefund: () => Promise<void>;
  handleSingleRefund: (invoiceId: string) => void;
  handleCloseRefundModal: () => void;
  handleConfirmRefund: () => Promise<void>;
  changePage: (page: number) => void;
}

export const useInvoicePage = (): UseInvoicePageReturn => {
  const { currentCompany, currentUser, currentStore, setCurrentStore } = useAppState();
  const { messageState, closeMessage, showError, showSuccess } = useErrorMessage();

  // Get company ID from app state
  const companyId = currentCompany?.company_id || '';
  const stores = currentCompany?.stores || [];

  // Local search query state (synced with server search)
  const [localSearchQuery, setLocalSearchQueryState] = useState('');

  // Selection state
  const [selectedInvoices, setSelectedInvoices] = useState<Set<string>>(new Set());

  // Expanded invoice state
  const [expandedInvoiceId, setExpandedInvoiceId] = useState<string | null>(null);

  // Refund modal state
  const [refundModalOpen, setRefundModalOpen] = useState(false);
  const [refundTargetInvoiceId, setRefundTargetInvoiceId] = useState<string | null>(null);
  const [refundProcessing, setRefundProcessing] = useState(false);
  const [bulkRefundModalOpen, setBulkRefundModalOpen] = useState(false);

  // Get invoice state and actions
  const {
    invoices,
    loading,
    error,
    pagination,
    currentPage,
    itemsPerPage,
    selectedStoreId,
    activeFilter,
    dateSortFilter,
    amountSortFilter,
    invoiceDetail,
    detailLoading,
    refunding,
    refundInvoices,
    setSelectedStoreId: setInvoiceStoreId,
    setDateSortFilter,
    setAmountSortFilter,
    changeDateRange,
    changeSearch,
    changePage,
    refresh,
    fetchInvoiceDetail,
  } = useInvoice(companyId);

  // Get refund hook
  const { refundInvoicesWithJournal } = useRefundInvoice(refundInvoices);

  // Sync App State's currentStore to Invoice provider
  useEffect(() => {
    const appStateStoreId = currentStore?.store_id || null;
    if (appStateStoreId !== selectedStoreId) {
      setInvoiceStoreId(appStateStoreId);
    }
  }, [currentStore, selectedStoreId, setInvoiceStoreId]);

  // Clear selections when store changes
  useEffect(() => {
    setSelectedInvoices(new Set());
  }, [selectedStoreId]);

  // Debounced server search - sync local search to server
  useEffect(() => {
    const debounceTimer = setTimeout(() => {
      changeSearch(localSearchQuery);
    }, 300); // 300ms debounce for typing

    return () => clearTimeout(debounceTimer);
  }, [localSearchQuery, changeSearch]);

  // Server-side search: invoices already filtered by RPC (get_invoice_page_v4)
  // No client-side filtering needed - RPC searches: invoice_number, customer_name,
  // payment_method, product_name, product_sku
  const filteredInvoices = invoices;

  // Wrapper for local search query setter
  const setLocalSearchQuery = useCallback((query: string) => {
    setLocalSearchQueryState(query);
  }, []);

  // Handle store selection
  const handleStoreSelect = useCallback((storeId: string | null) => {
    const selectedStore = stores.find((s: any) => s.store_id === storeId) || null;
    setCurrentStore(selectedStore);
    setInvoiceStoreId(storeId);
  }, [stores, setCurrentStore, setInvoiceStoreId]);

  // Selection handlers
  const toggleInvoiceSelection = useCallback((invoiceId: string) => {
    setSelectedInvoices(prev => {
      const newSelection = new Set(prev);
      if (newSelection.has(invoiceId)) {
        newSelection.delete(invoiceId);
      } else {
        newSelection.add(invoiceId);
      }
      return newSelection;
    });
  }, []);

  const selectAllInvoices = useCallback(() => {
    if (selectedInvoices.size === filteredInvoices.length) {
      setSelectedInvoices(new Set());
    } else {
      setSelectedInvoices(new Set(filteredInvoices.map(inv => inv.invoiceId)));
    }
  }, [selectedInvoices.size, filteredInvoices]);

  // Row click handler
  const handleRowClick = useCallback((invoiceId: string) => {
    if (expandedInvoiceId === invoiceId) {
      setExpandedInvoiceId(null);
    } else {
      setExpandedInvoiceId(invoiceId);
      fetchInvoiceDetail(invoiceId);
    }
  }, [expandedInvoiceId, fetchInvoiceDetail]);

  // Check if any selected invoice is cancelled
  const hasSelectedCancelledInvoice = useMemo(() => {
    return Array.from(selectedInvoices).some(invoiceId => {
      const invoice = invoices.find(inv => inv.invoiceId === invoiceId);
      return invoice?.status === 'cancelled';
    });
  }, [selectedInvoices, invoices]);

  // Calculate selected invoices totals
  const selectedInvoicesData = useMemo(() => {
    return Array.from(selectedInvoices)
      .map(id => invoices.find(inv => inv.invoiceId === id))
      .filter(Boolean) as Invoice[];
  }, [selectedInvoices, invoices]);

  const bulkRefundTotalAmount = useMemo(() => {
    return selectedInvoicesData.reduce((sum, inv) => sum + (inv?.totalAmount || 0), 0);
  }, [selectedInvoicesData]);

  const bulkRefundTotalCost = useMemo(() => {
    return selectedInvoicesData.reduce((sum, inv) => sum + (inv?.totalCost || 0), 0);
  }, [selectedInvoicesData]);

  // Bulk refund handlers
  const handleBulkRefund = useCallback(() => {
    if (selectedInvoices.size === 0) return;
    setBulkRefundModalOpen(true);
  }, [selectedInvoices.size]);

  const handleCloseBulkRefundModal = useCallback(() => {
    setBulkRefundModalOpen(false);
  }, []);

  const handleConfirmBulkRefund = useCallback(async () => {
    if (!currentUser?.user_id || !companyId || selectedInvoices.size === 0) return;

    handleCloseBulkRefundModal();
    setRefundProcessing(true);

    try {
      const invoiceIdsArray = Array.from(selectedInvoices);
      const result = await refundInvoicesWithJournal({
        invoiceIds: invoiceIdsArray,
        notes: 'Bulk refund',
        companyId,
        userId: currentUser.user_id,
        invoices,
      });

      if (result.success) {
        await refresh();
        showSuccess({
          message: `Successfully refunded ${result.totalSucceeded} invoice${result.totalSucceeded > 1 ? 's' : ''}. Total amount: ${invoices[0]?.formatCurrency(result.totalAmountRefunded) || result.totalAmountRefunded}`,
          autoCloseDuration: 3000
        });
        setSelectedInvoices(new Set());
      } else {
        showError({
          title: 'Refund Failed',
          message: result.error || 'Failed to refund invoices'
        });
      }
    } catch (error) {
      showError({
        title: 'Refund Error',
        message: error instanceof Error ? error.message : 'An unexpected error occurred'
      });
    } finally {
      setRefundProcessing(false);
    }
  }, [currentUser, companyId, selectedInvoices, invoices, refundInvoicesWithJournal, refresh, showSuccess, showError, handleCloseBulkRefundModal]);

  // Single refund handlers
  const handleSingleRefund = useCallback((invoiceId: string) => {
    setRefundTargetInvoiceId(invoiceId);
    setRefundModalOpen(true);
  }, []);

  const handleCloseRefundModal = useCallback(() => {
    setRefundModalOpen(false);
    setRefundTargetInvoiceId(null);
  }, []);

  const handleConfirmRefund = useCallback(async () => {
    if (!currentUser?.user_id || !companyId || !refundTargetInvoiceId) return;

    handleCloseRefundModal();
    setRefundProcessing(true);

    try {
      const result = await refundInvoicesWithJournal({
        invoiceIds: [refundTargetInvoiceId],
        notes: 'Single refund',
        companyId,
        userId: currentUser.user_id,
        invoices,
      });

      if (result.success) {
        const refundedInvoice = invoices.find(inv => inv.invoiceId === refundTargetInvoiceId);
        await refresh();
        showSuccess({
          message: `Successfully refunded invoice. Amount: ${refundedInvoice?.formatCurrency(result.totalAmountRefunded) || result.totalAmountRefunded}`,
          autoCloseDuration: 3000
        });
        setExpandedInvoiceId(null);
      } else {
        showError({
          title: 'Refund Failed',
          message: result.error || 'Failed to refund invoice'
        });
      }
    } catch (error) {
      showError({
        title: 'Refund Error',
        message: error instanceof Error ? error.message : 'An unexpected error occurred'
      });
    } finally {
      setRefundProcessing(false);
    }
  }, [currentUser, companyId, refundTargetInvoiceId, invoices, refundInvoicesWithJournal, refresh, showSuccess, showError, handleCloseRefundModal]);

  // Get target invoice for modal
  const refundTargetInvoice = useMemo(() => {
    return refundTargetInvoiceId
      ? invoices.find(inv => inv.invoiceId === refundTargetInvoiceId) || null
      : null;
  }, [refundTargetInvoiceId, invoices]);

  // Calculate date range helper
  const calculateDateRange = useCallback((filter: string): { start: string; end: string } => {
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
  }, []);

  // Filter sections configuration
  const filterSections: FilterSection[] = useMemo(() => [
    {
      id: 'date',
      title: 'Date Range',
      type: 'sort' as const,
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
      onSelect: (value: string) => {
        const { start, end } = calculateDateRange(value);
        changeDateRange(value as any, start, end);
      },
    },
    {
      id: 'date-sort',
      title: 'Date Sort',
      type: 'sort' as const,
      defaultExpanded: true,
      selectedValues: dateSortFilter || 'newest',
      options: [
        { value: 'newest', label: 'Newest First' },
        { value: 'oldest', label: 'Oldest First' },
      ],
      onSelect: (value: string) => {
        // Clear amount sort when date sort is selected
        setAmountSortFilter(null);
        setDateSortFilter(value as 'newest' | 'oldest');
      },
    },
    {
      id: 'amount-sort',
      title: 'Amount Sort',
      type: 'sort' as const,
      defaultExpanded: true,
      selectedValues: amountSortFilter || '',
      options: [
        { value: 'high', label: 'Highest First' },
        { value: 'low', label: 'Lowest First' },
      ],
      onSelect: (value: string) => {
        // Toggle off if same value selected, otherwise set new value
        if (amountSortFilter === value) {
          setAmountSortFilter(null);
        } else {
          setAmountSortFilter(value as 'high' | 'low');
        }
      },
    },
  ], [activeFilter, dateSortFilter, amountSortFilter, calculateDateRange, changeDateRange, setDateSortFilter, setAmountSortFilter]);

  return {
    // App State
    companyId,
    stores,
    currentUser,

    // Invoice State
    invoices,
    filteredInvoices,
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

    // Local State
    localSearchQuery,
    selectedInvoices,
    expandedInvoiceId,
    refundModalOpen,
    refundTargetInvoiceId,
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
  };
};
