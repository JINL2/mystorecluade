/**
 * useLogin Hook
 * Presentation layer - Login logic wrapper
 *
 * Following ARCHITECTURE.md 2025 Best Practice:
 * - Zustand wrapper hook (no useState)
 * - All business logic in auth_provider.ts
 * - Optimized selectors to prevent unnecessary re-renders
 */

import { useAuthStore } from '../providers/auth_provider';

/**
 * Login hook
 * Wraps Zustand auth store login functionality
 *
 * @returns Login state and action
 */
export const useLogin = () => {
  // ============================================
  // OPTIMIZED SELECTORS
  // ============================================

  const loginLoading = useAuthStore((state) => state.loginLoading);
  const loginError = useAuthStore((state) => state.loginError);
  const loginFieldErrors = useAuthStore((state) => state.loginFieldErrors);
  const login = useAuthStore((state) => state.login);

  // ============================================
  // RETURN API
  // ============================================

  return {
    login,
    loading: loginLoading,
    error: loginError,
    fieldErrors: loginFieldErrors,
  };
};
