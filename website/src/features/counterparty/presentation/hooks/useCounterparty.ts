/**
 * useCounterparty Hook
 * Custom hook wrapper for counterparty store (2025 Best Practice)
 */

import { useMemo } from 'react';
import { useCounterpartyStore } from '../providers/counterparty_provider';

/**
 * Custom hook that provides access to counterparty state and actions
 * Uses Zustand store for state management
 */
export const useCounterparty = () => {
  // Select state (optimized selectors to prevent unnecessary re-renders)
  const counterparties = useCounterpartyStore((state) => state.counterparties);
  const loading = useCounterpartyStore((state) => state.loading);
  const error = useCounterpartyStore((state) => state.error);

  const showModal = useCounterpartyStore((state) => state.showModal);
  const showDeleteModal = useCounterpartyStore((state) => state.showDeleteModal);
  const deleteId = useCounterpartyStore((state) => state.deleteId);

  const formData = useCounterpartyStore((state) => state.formData);
  const isFormValid = useCounterpartyStore((state) => state.isFormValid);

  // Compute internal/external counterparties with useMemo to avoid re-creating arrays
  const internalCounterparties = useMemo(
    () => counterparties.filter((c) => c.isInternal),
    [counterparties]
  );
  const externalCounterparties = useMemo(
    () => counterparties.filter((c) => !c.isInternal),
    [counterparties]
  );

  // Select actions
  const setCounterparties = useCounterpartyStore((state) => state.setCounterparties);
  const setLoading = useCounterpartyStore((state) => state.setLoading);
  const setError = useCounterpartyStore((state) => state.setError);

  const setShowModal = useCounterpartyStore((state) => state.setShowModal);
  const setShowDeleteModal = useCounterpartyStore((state) => state.setShowDeleteModal);
  const setDeleteId = useCounterpartyStore((state) => state.setDeleteId);
  const openCreateModal = useCounterpartyStore((state) => state.openCreateModal);
  const closeCreateModal = useCounterpartyStore((state) => state.closeCreateModal);
  const openDeleteModal = useCounterpartyStore((state) => state.openDeleteModal);
  const closeDeleteModal = useCounterpartyStore((state) => state.closeDeleteModal);

  const setFormData = useCounterpartyStore((state) => state.setFormData);
  const updateFormField = useCounterpartyStore((state) => state.updateFormField);
  const resetForm = useCounterpartyStore((state) => state.resetForm);

  const loadCounterparties = useCounterpartyStore((state) => state.loadCounterparties);
  const submitCounterparty = useCounterpartyStore((state) => state.submitCounterparty);
  const confirmDelete = useCounterpartyStore((state) => state.confirmDelete);

  return {
    // State
    counterparties,
    loading,
    error,
    showModal,
    showDeleteModal,
    deleteId,
    formData,
    isFormValid,
    internalCounterparties,
    externalCounterparties,

    // Actions
    setCounterparties,
    setLoading,
    setError,
    setShowModal,
    setShowDeleteModal,
    setDeleteId,
    openCreateModal,
    closeCreateModal,
    openDeleteModal,
    closeDeleteModal,
    setFormData,
    updateFormField,
    resetForm,
    loadCounterparties,
    submitCounterparty,
    confirmDelete,
  };
};
