/**
 * Store Provider - Zustand Store (2025 Best Practice)
 *
 * Clean Architecture Presentation Layer - State Management
 * Centralized state management for Store Setting feature
 *
 * Usage:
 * import { useStoreStore } from '../providers/store_provider';
 * const { showAddModal, setShowAddModal } = useStoreStore();
 */

import { create } from 'zustand';
import { StoreState } from './states/store_state';

export const useStoreStore = create<StoreState>((set) => ({
  // Initial state - Modal
  showAddModal: false,
  showDeleteModal: false,
  deleteStoreId: '',

  // Initial state - Form
  newName: '',
  newAddress: '',
  newPhone: '',

  // Actions - Modal
  setShowAddModal: (show) => set({ showAddModal: show }),

  setShowDeleteModal: (show) => set({ showDeleteModal: show }),

  setDeleteStoreId: (id) => set({ deleteStoreId: id }),

  // Actions - Form
  setNewName: (name) => set({ newName: name }),

  setNewAddress: (address) => set({ newAddress: address }),

  setNewPhone: (phone) => set({ newPhone: phone }),

  // Actions - Reset
  resetForm: () =>
    set({
      newName: '',
      newAddress: '',
      newPhone: '',
    }),

  closeAllModals: () =>
    set({
      showAddModal: false,
      showDeleteModal: false,
      deleteStoreId: '',
    }),
}));
