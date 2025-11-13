/**
 * Counterparty State Interface
 * Defines the state shape for counterparty feature
 */

import { Counterparty, CounterpartyTypeValue } from '../../../domain/entities/Counterparty';

/**
 * Form data interface
 */
export interface CounterpartyFormData {
  name: string;
  isInternal: boolean;
  linkedCompanyId: string | null;
  type: CounterpartyTypeValue | '';
  email: string;
  phone: string;
  notes: string;
}

/**
 * Submit result interface
 */
export interface SubmitResult {
  success: boolean;
  error?: string;
}

/**
 * Counterparty state interface
 * Includes UI state, form state, and actions
 */
export interface CounterpartyState {
  // Data state
  counterparties: Counterparty[];
  loading: boolean;
  error: string | null;

  // UI state
  showModal: boolean;
  showDeleteModal: boolean;
  deleteId: string | null;

  // Form state
  formData: CounterpartyFormData;

  // Computed values
  isFormValid: boolean;
  internalCounterparties: Counterparty[];
  externalCounterparties: Counterparty[];

  // Data actions
  setCounterparties: (counterparties: Counterparty[]) => void;
  setLoading: (loading: boolean) => void;
  setError: (error: string | null) => void;

  // UI actions
  setShowModal: (show: boolean) => void;
  setShowDeleteModal: (show: boolean) => void;
  setDeleteId: (id: string | null) => void;
  openCreateModal: () => void;
  closeCreateModal: () => void;
  openDeleteModal: (id: string) => void;
  closeDeleteModal: () => void;

  // Form actions
  setFormData: (data: Partial<CounterpartyFormData>) => void;
  updateFormField: <K extends keyof CounterpartyFormData>(
    field: K,
    value: CounterpartyFormData[K]
  ) => void;
  resetForm: () => void;

  // Async actions
  loadCounterparties: (companyId: string) => Promise<void>;
  submitCounterparty: (companyId: string) => Promise<SubmitResult>;
  confirmDelete: (companyId: string) => Promise<SubmitResult>;
}
