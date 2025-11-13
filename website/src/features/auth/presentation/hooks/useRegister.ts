/**
 * useRegister Hook
 * Presentation layer - Register logic wrapper
 *
 * Following ARCHITECTURE.md 2025 Best Practice:
 * - Zustand wrapper hook (no useState)
 * - All business logic in auth_provider.ts
 * - Optimized selectors to prevent unnecessary re-renders
 */

import { useAuthStore } from '../providers/auth_provider';

/**
 * Register hook
 * Wraps Zustand auth store register functionality
 *
 * @returns Register state and action
 */
export const useRegister = () => {
  // ============================================
  // OPTIMIZED SELECTORS
  // ============================================

  const registerLoading = useAuthStore((state) => state.registerLoading);
  const registerError = useAuthStore((state) => state.registerError);
  const registerFieldErrors = useAuthStore((state) => state.registerFieldErrors);
  const register = useAuthStore((state) => state.register);

  // ============================================
  // RETURN API
  // ============================================

  return {
    register,
    loading: registerLoading,
    error: registerError,
    fieldErrors: registerFieldErrors,
  };
};
