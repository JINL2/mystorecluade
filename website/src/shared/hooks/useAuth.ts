/**
 * useAuth Hook
 * Global authentication hook - Zustand wrapper
 *
 * Following 2025 Best Practice:
 * - Wraps Zustand store with optimized selectors
 * - Provides global auth state across application
 * - NO initialization here (done in AuthInitializer component)
 * - No direct useState usage (delegates to Zustand)
 */

import { useAuthStore } from '@/features/auth/presentation/providers/auth_provider';

/**
 * Global authentication hook
 * Does NOT initialize auth - use AuthInitializer component for that
 *
 * Usage:
 * ```typescript
 * const { user, authenticated, loading, signOut, refreshAuth } = useAuth();
 * ```
 *
 * @returns Auth state and actions
 */
export const useAuth = () => {
  // ============================================
  // OPTIMIZED SELECTORS (prevents unnecessary re-renders)
  // ============================================

  // Select only needed state properties
  const user = useAuthStore((state) => state.user);
  const loading = useAuthStore((state) => state.loading);
  const authenticated = useAuthStore((state) => state.authenticated);
  const error = useAuthStore((state) => state.error);
  const sessionId = useAuthStore((state) => state.sessionId);

  // Select actions
  const checkAuth = useAuthStore((state) => state.checkAuth);
  const signOut = useAuthStore((state) => state.signOut);
  const refreshAuth = useAuthStore((state) => state.refreshAuth);

  // ============================================
  // RETURN API
  // ============================================

  return {
    // State
    user,
    loading,
    authenticated,
    error,
    sessionId,

    // Actions
    signOut,
    refreshAuth,
    checkAuth,
  };
};
