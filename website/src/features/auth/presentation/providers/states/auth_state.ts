/**
 * Auth State Interface
 * Feature-specific state management for authentication
 * Following 2025 Best Practice - Zustand State Management Pattern
 */

import type { User } from '../../../domain/entities/User';
import type { AsyncOperationResult, LoginFieldErrors, RegisterFieldErrors } from './types';

/**
 * Auth State Interface
 * Defines the complete authentication state structure
 */
export interface AuthState {
  // ========================================
  // State Properties
  // ========================================

  /**
   * Current authenticated user
   */
  user: User | null;

  /**
   * Loading indicator for auth operations
   */
  loading: boolean;

  /**
   * Authentication status
   */
  authenticated: boolean;

  /**
   * Current error message
   */
  error: string | null;

  /**
   * Current session ID from Supabase
   */
  sessionId: string | null;

  /**
   * Login loading state
   */
  loginLoading: boolean;

  /**
   * Login error message
   */
  loginError: string | null;

  /**
   * Login field validation errors
   */
  loginFieldErrors: LoginFieldErrors;

  /**
   * Register loading state
   */
  registerLoading: boolean;

  /**
   * Register error message
   */
  registerError: string | null;

  /**
   * Register field validation errors
   */
  registerFieldErrors: RegisterFieldErrors;

  // ========================================
  // Synchronous Actions
  // ========================================

  /**
   * Set current user
   */
  setUser: (user: User | null) => void;

  /**
   * Set loading state
   */
  setLoading: (loading: boolean) => void;

  /**
   * Set authenticated status
   */
  setAuthenticated: (authenticated: boolean) => void;

  /**
   * Set error message
   */
  setError: (error: string | null) => void;

  /**
   * Set session ID
   */
  setSessionId: (sessionId: string | null) => void;

  /**
   * Reset all auth state to initial values
   */
  reset: () => void;

  // ========================================
  // Asynchronous Actions
  // ========================================

  /**
   * Check current authentication status
   * Fetches current user from Supabase and updates state
   */
  checkAuth: () => Promise<void>;

  /**
   * Sign in with email and password
   * Validates credentials and calls repository
   * Updates user state on success
   */
  login: (email: string, password: string, rememberMe?: boolean) => Promise<AsyncOperationResult>;

  /**
   * Register new user
   * Validates credentials, creates account and user profile
   * Updates user state on success
   */
  register: (
    email: string,
    password: string,
    passwordConfirmation: string,
    firstName: string,
    lastName: string
  ) => Promise<AsyncOperationResult>;

  /**
   * Sign out current user
   * Clears user session and resets state
   */
  signOut: () => Promise<AsyncOperationResult>;

  /**
   * Refresh authentication state
   * Re-fetches current user and updates state
   */
  refreshAuth: () => Promise<void>;

  // ========================================
  // Auth State Change Listener
  // ========================================

  /**
   * Subscribe to Supabase auth state changes
   * Automatically updates state when auth events occur
   */
  subscribeToAuthChanges: () => { unsubscribe: () => void };
}
