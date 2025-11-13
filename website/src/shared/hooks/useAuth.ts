/**
 * useAuth Hook
 * Global authentication hook - Zustand wrapper
 *
 * Following 2025 Best Practice:
 * - Wraps Zustand store with optimized selectors
 * - Provides global auth state across application
 * - Subscribes to auth changes on mount
 * - No direct useState usage (delegates to Zustand)
 */

import { useEffect } from 'react';
import { useAuthStore } from '@/features/auth/presentation/providers/auth_provider';

/**
 * Global authentication hook
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
  const subscribeToAuthChanges = useAuthStore((state) => state.subscribeToAuthChanges);

  // ============================================
  // INITIALIZATION & AUTH STATE LISTENER
  // ============================================

  useEffect(() => {
    // Check auth status on mount
    checkAuth();

    // Subscribe to auth state changes
    const { unsubscribe } = subscribeToAuthChanges();

    // Cleanup subscription on unmount
    return () => {
      unsubscribe();
    };
  }, [checkAuth, subscribeToAuthChanges]);

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
