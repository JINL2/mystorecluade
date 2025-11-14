/**
 * AuthInitializer Component
 * Initializes authentication state ONCE at app startup
 *
 * Following UPDATE_GUIDE.md:
 * - Presentation layer component
 * - Uses auth provider actions
 * - No business logic (delegates to provider)
 */

import { useEffect } from 'react';
import { useAuthStore } from '../providers/auth_provider';

/**
 * AuthInitializer
 * Must be rendered ONCE at app root level
 * Initializes auth state and subscribes to auth changes
 */
export const AuthInitializer: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const checkAuth = useAuthStore((state) => state.checkAuth);
  const subscribeToAuthChanges = useAuthStore((state) => state.subscribeToAuthChanges);

  useEffect(() => {
    // Check auth status on mount
    checkAuth();

    // Subscribe to auth state changes
    const { unsubscribe } = subscribeToAuthChanges();

    // Cleanup subscription on unmount
    return () => {
      unsubscribe();
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []); // Empty deps: only run once on mount

  return <>{children}</>;
};
