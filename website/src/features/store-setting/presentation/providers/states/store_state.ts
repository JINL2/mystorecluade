/**
 * StoreState - Store Feature State Interface
 *
 * Clean Architecture Presentation Layer - State Management
 * Zustand store state type definitions
 */

export interface StoreState {
  // Modal state
  showAddModal: boolean;
  showDeleteModal: boolean;
  deleteStoreId: string;

  // Form state
  newName: string;
  newAddress: string;
  newPhone: string;

  // Actions - Modal
  setShowAddModal: (show: boolean) => void;
  setShowDeleteModal: (show: boolean) => void;
  setDeleteStoreId: (id: string) => void;

  // Actions - Form
  setNewName: (name: string) => void;
  setNewAddress: (address: string) => void;
  setNewPhone: (phone: string) => void;

  // Actions - Reset
  resetForm: () => void;
  closeAllModals: () => void;
}
