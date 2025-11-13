/**
 * Counterparty Zustand Provider
 * Central state management for counterparty feature (2025 Best Practice)
 */

import { create } from 'zustand';
import { CounterpartyState, CounterpartyFormData } from './states/counterparty_state';
import { CounterpartyRepositoryImpl } from '../../data/repositories/CounterpartyRepositoryImpl';
import { CounterpartyValidator } from '../../domain/validators/CounterpartyValidator';
import { CounterpartyTypeValue } from '../../domain/entities/Counterparty';

// Initial form data
const initialFormData: CounterpartyFormData = {
  name: '',
  isInternal: false,
  linkedCompanyId: null,
  type: '',
  email: '',
  phone: '',
  notes: '',
};

// Repository instance
const repository = new CounterpartyRepositoryImpl();

/**
 * Counterparty Store
 * Zustand store for counterparty feature state management
 */
export const useCounterpartyStore = create<CounterpartyState>((set, get) => ({
  // ==================== Initial State ====================

  // Data state
  counterparties: [],
  loading: false,
  error: null,

  // UI state
  showModal: false,
  showDeleteModal: false,
  deleteId: null,

  // Form state
  formData: { ...initialFormData },

  // ==================== Computed Values ====================
  // Note: isFormValid is computed in the component/hook using the formData

  get isFormValid() {
    const { formData } = get();
    return (
      formData.name.trim() !== '' &&
      formData.type !== '' &&
      (!formData.isInternal || formData.linkedCompanyId !== null)
    );
  },

  // Note: internalCounterparties and externalCounterparties moved to useCounterparty hook
  // using useMemo to prevent re-creating arrays on every render

  // ==================== Data Actions ====================

  setCounterparties: (counterparties) => set({ counterparties }),

  setLoading: (loading) => set({ loading }),

  setError: (error) => set({ error }),

  // ==================== UI Actions ====================

  setShowModal: (show) => set({ showModal: show }),

  setShowDeleteModal: (show) => set({ showDeleteModal: show }),

  setDeleteId: (id) => set({ deleteId: id }),

  openCreateModal: () => {
    set({ showModal: true });
  },

  closeCreateModal: () => {
    set({ showModal: false });
    get().resetForm();
  },

  openDeleteModal: (id) => {
    set({ deleteId: id, showDeleteModal: true });
  },

  closeDeleteModal: () => {
    set({ showDeleteModal: false, deleteId: null });
  },

  // ==================== Form Actions ====================

  setFormData: (data) =>
    set((state) => ({
      formData: { ...state.formData, ...data },
    })),

  updateFormField: (field, value) =>
    set((state) => ({
      formData: { ...state.formData, [field]: value },
    })),

  resetForm: () => set({ formData: { ...initialFormData } }),

  // ==================== Async Actions ====================

  /**
   * Load counterparties from repository
   */
  loadCounterparties: async (companyId: string) => {
    if (!companyId) {
      set({ counterparties: [], loading: false });
      return;
    }

    set({ loading: true, error: null });

    try {
      const result = await repository.getCounterparties(companyId);

      if (!result.success) {
        set({
          error: result.error || 'Failed to load counterparties',
          counterparties: [],
          loading: false,
        });
        return;
      }

      set({
        counterparties: result.data || [],
        loading: false,
        error: null,
      });
    } catch (err) {
      set({
        error: err instanceof Error ? err.message : 'Error occurred',
        counterparties: [],
        loading: false,
      });
    }
  },

  /**
   * Submit counterparty (create new)
   */
  submitCounterparty: async (companyId: string) => {
    const state = get();

    // 1. Check company ID
    if (!companyId) {
      return { success: false, error: 'Company ID required' };
    }

    // 2. Validate form data
    const validationErrors = CounterpartyValidator.validateCreate({
      name: state.formData.name,
      type: state.formData.type,
      isInternal: state.formData.isInternal,
      linkedCompanyId: state.formData.linkedCompanyId,
      email: state.formData.email || null,
      phone: state.formData.phone || null,
      notes: state.formData.notes || null,
    });

    if (validationErrors.length > 0) {
      return {
        success: false,
        error: validationErrors[0].message,
      };
    }

    // 3. Set loading state
    set({ loading: true, error: null });

    try {
      // 4. Call repository
      const result = await repository.createCounterparty(
        companyId,
        state.formData.name.trim(),
        state.formData.type as CounterpartyTypeValue,
        state.formData.isInternal,
        state.formData.linkedCompanyId,
        state.formData.email || null,
        state.formData.phone || null,
        state.formData.notes || null
      );

      if (!result.success) {
        set({ loading: false });
        return { success: false, error: result.error || 'Failed to create' };
      }

      // 5. Reload data and reset form
      await get().loadCounterparties(companyId);
      get().resetForm();
      get().closeCreateModal();

      return { success: true };
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : 'Error occurred';
      set({ loading: false, error: errorMessage });
      return { success: false, error: errorMessage };
    }
  },

  /**
   * Confirm delete counterparty
   */
  confirmDelete: async (companyId: string) => {
    const state = get();

    if (!state.deleteId || !companyId) {
      return { success: false, error: 'Invalid delete request' };
    }

    set({ loading: true, error: null });

    try {
      const result = await repository.deleteCounterparty(state.deleteId, companyId);

      if (!result.success) {
        set({ loading: false });
        return { success: false, error: result.error || 'Failed to delete' };
      }

      // Reload data and close modal
      await get().loadCounterparties(companyId);
      get().closeDeleteModal();

      return { success: true };
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : 'Error occurred';
      set({ loading: false, error: errorMessage });
      return { success: false, error: errorMessage };
    }
  },
}));
