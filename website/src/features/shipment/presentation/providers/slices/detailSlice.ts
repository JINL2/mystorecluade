/**
 * Detail Slice
 * Zustand slice for shipment detail state management
 */

import type { StateCreator } from 'zustand';
import type { ShipmentStore } from '../states/shipment_state';
import { initialDetailState } from '../states/shipment_state';
import type { IShipmentRepository } from '../../../domain/repositories/IShipmentRepository';

// ===== Slice Creator =====

export const createDetailSlice = (
  repository: IShipmentRepository
): StateCreator<ShipmentStore, [], [], Pick<ShipmentStore, 'detail'>> => (set) => ({
  detail: {
    ...initialDetailState,

    loadShipmentDetail: async (params) => {
      set((state) => ({
        detail: { ...state.detail, isLoading: true, error: null },
      }));

      try {
        const result = await repository.getShipmentDetail(params);

        if (result.success && result.data) {
          set((state) => ({
            detail: {
              ...state.detail,
              shipmentDetail: result.data || null,
              isLoading: false,
            },
          }));
        } else {
          set((state) => ({
            detail: {
              ...state.detail,
              shipmentDetail: null,
              isLoading: false,
              error: result.error || 'Failed to load shipment detail',
            },
          }));
        }
      } catch (err) {
        set((state) => ({
          detail: {
            ...state.detail,
            isLoading: false,
            error: err instanceof Error ? err.message : 'Failed to load shipment detail',
          },
        }));
      }
    },

    loadCurrency: async (companyId) => {
      try {
        const result = await repository.getBaseCurrency(companyId);
        if (result) {
          set((state) => ({
            detail: { ...state.detail, currency: result },
          }));
        }
      } catch {
        // Keep default currency
      }
    },

    resetDetailState: () => {
      set(() => ({
        detail: { ...initialDetailState },
      }));
    },
  },
});
