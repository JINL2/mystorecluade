/**
 * List Slice
 * Zustand slice for shipment list state management
 */

import type { StateCreator } from 'zustand';
import type { ShipmentStore, ShipmentListState, DatePreset } from '../states/shipment_state';
import { initialListState } from '../states/shipment_state';
import type { IShipmentRepository } from '../../../domain/repositories/IShipmentRepository';

// ===== Date Utilities =====

const getDateRangeForPreset = (preset: DatePreset): { from: string; to: string } => {
  const today = new Date();
  const year = today.getFullYear();
  const month = today.getMonth();

  switch (preset) {
    case 'this_month': {
      const firstDay = new Date(year, month, 1);
      const lastDay = new Date(year, month + 1, 0);
      return {
        from: firstDay.toISOString().split('T')[0],
        to: lastDay.toISOString().split('T')[0],
      };
    }
    case 'last_month': {
      const firstDay = new Date(year, month - 1, 1);
      const lastDay = new Date(year, month, 0);
      return {
        from: firstDay.toISOString().split('T')[0],
        to: lastDay.toISOString().split('T')[0],
      };
    }
    case 'this_year': {
      const firstDay = new Date(year, 0, 1);
      const lastDay = new Date(year, 11, 31);
      return {
        from: firstDay.toISOString().split('T')[0],
        to: lastDay.toISOString().split('T')[0],
      };
    }
    default:
      return { from: '', to: '' };
  }
};

// ===== Slice Creator =====

export const createListSlice = (
  repository: IShipmentRepository
): StateCreator<ShipmentStore, [], [], Pick<ShipmentStore, 'list'>> => (set, get) => ({
  list: {
    ...initialListState,

    loadShipments: async (params) => {
      set((state) => ({
        list: { ...state.list, isLoading: true, error: null },
      }));

      try {
        const result = await repository.getShipmentList({
          companyId: params.companyId,
          timezone: params.timezone,
          fromDate: params.fromDate,
          toDate: params.toDate,
          statusFilter: params.statusFilter,
          supplierFilter: params.supplierFilter,
          orderFilter: params.orderFilter,
        });

        if (result.success && result.data) {
          set((state) => ({
            list: {
              ...state.list,
              shipments: result.data || [],
              totalCount: result.totalCount || 0,
              isLoading: false,
            },
          }));
        } else {
          set((state) => ({
            list: {
              ...state.list,
              shipments: [],
              totalCount: 0,
              isLoading: false,
              error: result.error || 'Failed to load shipments',
            },
          }));
        }
      } catch (err) {
        set((state) => ({
          list: {
            ...state.list,
            isLoading: false,
            error: err instanceof Error ? err.message : 'Failed to load shipments',
          },
        }));
      }
    },

    loadSuppliers: async (companyId) => {
      set((state) => ({
        list: { ...state.list, isSuppliersLoading: true },
      }));

      try {
        const result = await repository.getCounterparties(companyId);
        if (result.success && result.data) {
          set((state) => ({
            list: {
              ...state.list,
              suppliers: result.data || [],
              isSuppliersLoading: false,
            },
          }));
        } else {
          set((state) => ({
            list: { ...state.list, isSuppliersLoading: false },
          }));
        }
      } catch {
        set((state) => ({
          list: { ...state.list, isSuppliersLoading: false },
        }));
      }
    },

    loadOrders: async (companyId, timezone) => {
      set((state) => ({
        list: { ...state.list, isOrdersLoading: true },
      }));

      try {
        const result = await repository.getOrders({ companyId, timezone });
        if (result.success && result.data) {
          set((state) => ({
            list: {
              ...state.list,
              orders: result.data || [],
              isOrdersLoading: false,
            },
          }));
        } else {
          set((state) => ({
            list: { ...state.list, isOrdersLoading: false },
          }));
        }
      } catch {
        set((state) => ({
          list: { ...state.list, isOrdersLoading: false },
        }));
      }
    },

    loadCurrency: async (companyId) => {
      try {
        const result = await repository.getBaseCurrency(companyId);
        if (result) {
          set((state) => ({
            list: { ...state.list, currency: result },
          }));
        }
      } catch {
        // Keep default currency
      }
    },

    setSearchQuery: (query) => {
      set((state) => ({
        list: { ...state.list, searchQuery: query },
      }));
    },

    setDatePreset: (preset) => {
      const range = preset !== 'custom' ? getDateRangeForPreset(preset) : { from: '', to: '' };
      set((state) => ({
        list: {
          ...state.list,
          datePreset: preset,
          ...(preset !== 'custom' && {
            fromDate: range.from,
            toDate: range.to,
            showDatePicker: false,
          }),
          ...(preset === 'custom' && {
            tempFromDate: state.list.fromDate,
            tempToDate: state.list.toDate,
            showDatePicker: true,
          }),
        },
      }));
    },

    setFromDate: (date) => {
      set((state) => ({
        list: { ...state.list, fromDate: date },
      }));
    },

    setToDate: (date) => {
      set((state) => ({
        list: { ...state.list, toDate: date },
      }));
    },

    setShowDatePicker: (show) => {
      set((state) => ({
        list: { ...state.list, showDatePicker: show },
      }));
    },

    setTempFromDate: (date) => {
      set((state) => ({
        list: { ...state.list, tempFromDate: date },
      }));
    },

    setTempToDate: (date) => {
      set((state) => ({
        list: { ...state.list, tempToDate: date },
      }));
    },

    applyCustomDate: () => {
      set((state) => ({
        list: {
          ...state.list,
          fromDate: state.list.tempFromDate,
          toDate: state.list.tempToDate,
          showDatePicker: false,
        },
      }));
    },

    cancelCustomDate: () => {
      const state = get();
      if (state.list.datePreset === 'custom' && !state.list.fromDate && !state.list.toDate) {
        const range = getDateRangeForPreset('this_month');
        set((s) => ({
          list: {
            ...s.list,
            datePreset: 'this_month',
            fromDate: range.from,
            toDate: range.to,
            showDatePicker: false,
          },
        }));
      } else {
        set((s) => ({
          list: { ...s.list, showDatePicker: false },
        }));
      }
    },

    setShipmentStatusFilter: (status) => {
      set((state) => ({
        list: { ...state.list, shipmentStatusFilter: status },
      }));
    },

    toggleShipmentStatus: (status) => {
      set((state) => ({
        list: {
          ...state.list,
          shipmentStatusFilter: state.list.shipmentStatusFilter === status ? null : status,
        },
      }));
    },

    clearShipmentStatusFilter: () => {
      set((state) => ({
        list: { ...state.list, shipmentStatusFilter: null },
      }));
    },

    setSupplierFilter: (supplierId) => {
      set((state) => ({
        list: { ...state.list, supplierFilter: supplierId },
      }));
    },

    toggleSupplierFilter: (supplierId) => {
      set((state) => ({
        list: {
          ...state.list,
          supplierFilter: state.list.supplierFilter === supplierId ? null : supplierId,
        },
      }));
    },

    clearSupplierFilter: () => {
      set((state) => ({
        list: { ...state.list, supplierFilter: null },
      }));
    },

    setOrderFilter: (orderId) => {
      set((state) => ({
        list: { ...state.list, orderFilter: orderId },
      }));
    },

    toggleOrderFilter: (orderId) => {
      set((state) => ({
        list: {
          ...state.list,
          orderFilter: state.list.orderFilter === orderId ? null : orderId,
        },
      }));
    },

    clearOrderFilter: () => {
      set((state) => ({
        list: { ...state.list, orderFilter: null },
      }));
    },

    resetListState: () => {
      set(() => ({
        list: { ...initialListState },
      }));
    },
  },
});
