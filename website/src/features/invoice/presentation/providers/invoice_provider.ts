/**
 * Invoice Zustand Provider
 * Centralized state management for invoice feature
 */

import { create } from 'zustand';
import type { InvoiceState } from './states/invoice_state';
import type { DateRange } from './states/types';
import { InvoiceRepositoryImpl } from '../../data/repositories/InvoiceRepositoryImpl';

// Initialize repository
const repository = new InvoiceRepositoryImpl();

// Default date range (10 years ago to today)
const getDefaultDateRange = (): DateRange => {
  const today = new Date();
  const tenYearsAgo = new Date(today.getFullYear() - 10, 0, 1);
  return {
    start: tenYearsAgo.toISOString().split('T')[0],
    end: today.toISOString().split('T')[0],
  };
};

/**
 * Invoice Zustand Store
 * Manages all invoice-related state and actions
 */
export const useInvoiceStore = create<InvoiceState>((set, get) => ({
  // ========== Initial State ==========
  invoices: [],
  selectedInvoice: null,
  invoiceDetail: null,
  loading: true,
  detailLoading: false,
  refunding: false,
  error: null,
  selectedStoreId: null, // Start with null (All Stores) - don't use localStorage
  currentPage: 1,
  itemsPerPage: 20,
  searchQuery: '',
  dateRange: getDefaultDateRange(),
  activeFilter: 'all',
  dateSortFilter: null, // null = newest (default)
  amountSortFilter: null, // null = use date sort
  pagination: null,

  // ========== Setter Actions ==========
  setInvoices: (invoices) => set({ invoices }),

  setSelectedInvoice: (invoice) => set({ selectedInvoice: invoice }),

  setInvoiceDetail: (detail) => set({ invoiceDetail: detail }),

  setSelectedStoreId: (storeId) => {
    set({ selectedStoreId: storeId, currentPage: 1 }); // Reset to first page when store changes
  },

  setActiveFilter: (filter) => set({ activeFilter: filter }),

  setLoading: (loading) => set({ loading }),

  setDetailLoading: (loading) => set({ detailLoading: loading }),

  setRefunding: (refunding) => set({ refunding }),

  setError: (error) => set({ error }),

  setPagination: (pagination) => set({ pagination }),

  // ========== Filter Actions ==========
  changeDateRange: (start, end) => {
    set({
      dateRange: { start, end },
      currentPage: 1, // Reset to first page
    });
  },

  changeSearch: (query) => {
    set({
      searchQuery: query,
      currentPage: 1, // Reset to first page
    });
  },

  changePage: (page) => {
    set({ currentPage: page });
  },

  setDateSortFilter: (filter) => {
    // When date sort is set, clear amount sort (date sort has lower priority)
    set({ dateSortFilter: filter, currentPage: 1 });
  },

  setAmountSortFilter: (filter) => {
    // Amount sort takes priority over date sort
    set({ amountSortFilter: filter, currentPage: 1 });
  },

  // ========== Async Actions ==========
  loadInvoices: async (companyId) => {
    const state = get();

    console.log('🟡 InvoiceProvider.loadInvoices - starting...', {
      companyId,
      storeId: state.selectedStoreId,
      currentPage: state.currentPage,
      searchQuery: state.searchQuery,
      dateRange: state.dateRange,
      dateSortFilter: state.dateSortFilter,
      amountSortFilter: state.amountSortFilter,
    });

    set({ loading: true, error: null });

    try {
      const result = await repository.getInvoices(
        companyId,
        state.selectedStoreId,
        state.currentPage,
        state.itemsPerPage,
        state.searchQuery || null,
        state.dateRange.start,
        state.dateRange.end,
        state.dateSortFilter,
        state.amountSortFilter
      );

      console.log('🟡 InvoiceProvider.loadInvoices - result:', result);

      if (!result.success) {
        console.log('❌ InvoiceProvider - Result not successful:', result.error);
        set({
          error: result.error || 'Failed to load invoices',
          invoices: [],
          pagination: null,
        });
        return;
      }

      console.log('🟢 InvoiceProvider - Setting invoices:', result.data?.length || 0);
      set({
        invoices: result.data || [],
        pagination: result.pagination || null,
        error: null,
      });
    } catch (err) {
      console.error('❌ InvoiceProvider.loadInvoices - error:', err);
      set({
        error: err instanceof Error ? err.message : 'An unexpected error occurred',
        invoices: [],
        pagination: null,
      });
    } finally {
      set({ loading: false });
    }
  },

  fetchInvoiceDetail: async (invoiceId) => {
    console.log('🟡 InvoiceProvider.fetchInvoiceDetail - starting...', { invoiceId });

    set({ detailLoading: true });

    try {
      const result = await repository.getInvoiceDetail(invoiceId);

      if (!result.success) {
        console.error('❌ InvoiceProvider.fetchInvoiceDetail - failed:', result.error);
        set({ invoiceDetail: null });
        return;
      }

      console.log('🟢 InvoiceProvider.fetchInvoiceDetail - success');
      set({ invoiceDetail: result.data || null });
    } catch (err) {
      console.error('❌ InvoiceProvider.fetchInvoiceDetail - error:', err);
      set({ invoiceDetail: null });
    } finally {
      set({ detailLoading: false });
    }
  },

  refundInvoice: async (invoiceId, refundReason, createdBy) => {
    console.log('🟡 InvoiceProvider.refundInvoice - starting...', { invoiceId, refundReason });

    set({ refunding: true });

    try {
      const result = await repository.refundInvoice(invoiceId, refundReason, createdBy);

      if (!result.success) {
        console.error('❌ InvoiceProvider.refundInvoice - failed:', result.error);
        return {
          success: false,
          error: result.error || 'Failed to refund invoice',
        };
      }

      console.log('🟢 InvoiceProvider.refundInvoice - success');
      return {
        success: true,
        message: result.message || 'Invoice refunded successfully',
      };
    } catch (err) {
      console.error('❌ InvoiceProvider.refundInvoice - error:', err);
      return {
        success: false,
        error: err instanceof Error ? err.message : 'An unexpected error occurred',
      };
    } finally {
      set({ refunding: false });
    }
  },

  refundInvoices: async (invoiceIds, notes, createdBy, timezone = 'Asia/Ho_Chi_Minh') => {
    console.log('🟡 InvoiceProvider.refundInvoices - starting...', { invoiceIds, notes, timezone });

    set({ refunding: true });

    try {
      const result = await repository.refundInvoices(invoiceIds, notes, createdBy, timezone);

      if (!result.success || !result.data) {
        console.error('❌ InvoiceProvider.refundInvoices - failed:', result.error);
        return {
          success: false,
          error: result.error || 'Failed to refund invoices',
        };
      }

      console.log('🟢 InvoiceProvider.refundInvoices - success', result.data);
      return {
        success: true,
        data: result.data,
      };
    } catch (err) {
      console.error('❌ InvoiceProvider.refundInvoices - error:', err);
      return {
        success: false,
        error: err instanceof Error ? err.message : 'An unexpected error occurred',
      };
    } finally {
      set({ refunding: false });
    }
  },

  refresh: async (companyId) => {
    console.log('🟡 InvoiceProvider.refresh - reloading invoices...');
    await get().loadInvoices(companyId);
  },

  // ========== Reset Actions ==========
  clearDetail: () => {
    set({
      invoiceDetail: null,
      selectedInvoice: null,
    });
  },

  reset: () => {
    set({
      invoices: [],
      selectedInvoice: null,
      invoiceDetail: null,
      loading: true,
      detailLoading: false,
      refunding: false,
      error: null,
      currentPage: 1,
      searchQuery: '',
      dateRange: getDefaultDateRange(),
      activeFilter: 'all',
      dateSortFilter: null,
      amountSortFilter: null,
      pagination: null,
    });
  },
}));
