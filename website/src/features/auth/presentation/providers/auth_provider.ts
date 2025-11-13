/**
 * AuthProvider
 * Zustand store for auth feature state management
 *
 * Following 2025 Best Practice:
 * - Zustand for state management (no Provider hell)
 * - Async operations in store
 * - Repository pattern integration
 * - Clean separation of concerns
 * - Auth state change listener integration
 */

import { create } from 'zustand';
import { AuthState } from './states/auth_state';
import { AuthRepositoryImpl } from '../../data/repositories/AuthRepositoryImpl';
import { AuthDataSource } from '../../data/datasources/AuthDataSource';
import { UserModel } from '../../data/models/UserModel';
import { AuthValidator } from '../../domain/validators/AuthValidator';

/**
 * Create repository and datasource instances (singleton pattern)
 */
const repository = new AuthRepositoryImpl();
const dataSource = new AuthDataSource();

/**
 * Auth Store
 * Zustand store for global authentication state
 */
export const useAuthStore = create<AuthState>((set, get) => ({
  // ============================================
  // INITIAL STATE
  // ============================================
  user: null,
  loading: true,
  authenticated: false,
  error: null,
  sessionId: null,
  loginLoading: false,
  loginError: null,
  loginFieldErrors: {},
  registerLoading: false,
  registerError: null,
  registerFieldErrors: {},

  // ============================================
  // SYNCHRONOUS ACTIONS (SETTERS)
  // ============================================

  setUser: (user) => set({ user }),

  setLoading: (loading) => set({ loading }),

  setAuthenticated: (authenticated) => set({ authenticated }),

  setError: (error) => set({ error }),

  setSessionId: (sessionId) => set({ sessionId }),

  reset: () =>
    set({
      user: null,
      authenticated: false,
      error: null,
      sessionId: null,
      loginLoading: false,
      loginError: null,
      loginFieldErrors: {},
      registerLoading: false,
      registerError: null,
      registerFieldErrors: {},
    }),

  // ============================================
  // ASYNCHRONOUS ACTIONS (BUSINESS LOGIC)
  // ============================================

  /**
   * Check current authentication status
   * Fetches current user from Supabase and updates state
   */
  checkAuth: async () => {
    set({ loading: true, error: null });

    try {
      // Get current user from repository
      const currentUser = await repository.getCurrentUser();

      // Get current session
      const sessionResult = await dataSource.getCurrentSession();
      const sessionId = sessionResult.session?.access_token || null;

      // Update state
      set({
        user: currentUser,
        authenticated: currentUser !== null,
        sessionId,
        loading: false,
      });
    } catch (error) {
      console.error('Auth check error:', error);
      set({
        user: null,
        authenticated: false,
        sessionId: null,
        error: error instanceof Error ? error.message : 'Authentication check failed',
        loading: false,
      });
    }
  },

  /**
   * Sign in with email and password
   * Validates credentials, calls repository, and updates state
   * Following ARCHITECTURE.md: Async operations in store, not in hooks
   */
  login: async (email, password, rememberMe = false) => {
    // Clear previous errors
    set({
      loginLoading: true,
      loginError: null,
      loginFieldErrors: {}
    });

    try {
      // 1. Validate credentials (Domain layer validation)
      const validationErrors = AuthValidator.validateLoginCredentials(email, password);

      if (validationErrors.length > 0) {
        // Build field errors object
        const fieldErrors: Record<string, string> = {};
        validationErrors.forEach((err) => {
          fieldErrors[err.field] = err.message;
        });

        set({
          loginFieldErrors: fieldErrors,
          loginLoading: false
        });

        return { success: false, error: 'Validation failed' };
      }

      // 2. Call repository (Data layer)
      const result = await repository.signIn({
        email,
        password,
        rememberMe,
      });

      // 3. Handle result
      if (result.success && result.user) {
        // Update auth state on successful login
        const sessionResult = await dataSource.getCurrentSession();
        const sessionId = sessionResult.session?.access_token || null;

        set({
          user: result.user,
          authenticated: true,
          sessionId,
          loginLoading: false,
          loginError: null,
          loginFieldErrors: {},
        });

        return { success: true };
      } else {
        // Login failed
        set({
          loginError: result.error || 'Login failed. Please try again.',
          loginLoading: false,
        });

        return {
          success: false,
          error: result.error || 'Login failed. Please try again.'
        };
      }
    } catch (error) {
      // Unexpected error
      const errorMessage = error instanceof Error ? error.message : 'An unexpected error occurred';

      set({
        loginError: errorMessage,
        loginLoading: false,
      });

      return { success: false, error: errorMessage };
    }
  },

  /**
   * Register new user with email and password
   * Validates credentials, calls repository, and updates state
   * Following ARCHITECTURE.md: Async operations in store, not in hooks
   */
  register: async (email, password, passwordConfirmation, firstName, lastName) => {
    // Clear previous errors
    set({
      registerLoading: true,
      registerError: null,
      registerFieldErrors: {}
    });

    try {
      // 1. Validate credentials (Domain layer validation)
      const validationErrors = AuthValidator.validateSignupCredentials(
        email,
        password,
        passwordConfirmation,
        firstName,
        lastName
      );

      if (validationErrors.length > 0) {
        // Build field errors object
        const fieldErrors: Record<string, string> = {};
        validationErrors.forEach((err) => {
          fieldErrors[err.field] = err.message;
        });

        set({
          registerFieldErrors: fieldErrors,
          registerLoading: false
        });

        return { success: false, error: 'Validation failed' };
      }

      // 2. Call repository (Data layer)
      const result = await repository.signUp({
        email,
        password,
        firstName,
        lastName,
      });

      // 3. Handle result
      if (result.success && result.user) {
        // Update auth state on successful registration
        const sessionResult = await dataSource.getCurrentSession();
        const sessionId = sessionResult.session?.access_token || null;

        set({
          user: result.user,
          authenticated: true,
          sessionId,
          registerLoading: false,
          registerError: null,
          registerFieldErrors: {},
        });

        return { success: true };
      } else {
        // Registration failed
        set({
          registerError: result.error || 'Registration failed. Please try again.',
          registerLoading: false,
        });

        return {
          success: false,
          error: result.error || 'Registration failed. Please try again.'
        };
      }
    } catch (error) {
      // Unexpected error
      const errorMessage = error instanceof Error ? error.message : 'An unexpected error occurred';

      set({
        registerError: errorMessage,
        registerLoading: false,
      });

      return { success: false, error: errorMessage };
    }
  },

  /**
   * Sign out current user
   * Clears user session and resets state
   */
  signOut: async () => {
    set({ loading: true, error: null });

    try {
      const result = await repository.signOut();

      if (result.success) {
        // Reset state on successful sign out
        get().reset();
        set({ loading: false });

        return { success: true };
      } else {
        set({
          error: result.error || 'Sign out failed',
          loading: false,
        });

        return { success: false, error: result.error };
      }
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : 'Sign out failed';

      set({
        error: errorMessage,
        loading: false,
      });

      return { success: false, error: errorMessage };
    }
  },

  /**
   * Refresh authentication state
   * Re-fetches current user and updates state
   */
  refreshAuth: async () => {
    await get().checkAuth();
  },

  /**
   * Subscribe to Supabase auth state changes
   * Automatically updates state when auth events occur
   */
  subscribeToAuthChanges: () => {
    const { data: authListener } = dataSource.onAuthStateChange(async (event, session) => {
      console.log('Auth state changed:', event);

      if (event === 'SIGNED_IN' || event === 'TOKEN_REFRESHED' || event === 'USER_UPDATED') {
        // User signed in or token refreshed
        if (session?.user) {
          const user = UserModel.fromSupabase(session.user);
          set({
            user,
            authenticated: true,
            sessionId: session.access_token,
            error: null,
          });
        }
      } else if (event === 'SIGNED_OUT') {
        // User signed out
        get().reset();
      }
    });

    // Return unsubscribe function
    return {
      unsubscribe: () => {
        authListener?.subscription?.unsubscribe();
      },
    };
  },
}));

/**
 * Helper hook to get only user state (optimized selector)
 */
export const useAuthUser = () => useAuthStore((state) => state.user);

/**
 * Helper hook to get only loading state (optimized selector)
 */
export const useAuthLoading = () => useAuthStore((state) => state.loading);

/**
 * Helper hook to get only authenticated status (optimized selector)
 */
export const useAuthStatus = () => useAuthStore((state) => state.authenticated);

/**
 * Helper hook to get only error state (optimized selector)
 */
export const useAuthError = () => useAuthStore((state) => state.error);
