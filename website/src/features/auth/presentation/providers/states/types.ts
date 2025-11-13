/**
 * Shared state types for auth feature
 * Following 2025 Best Practice - Zustand State Management
 */

import type { User } from '../../../domain/entities/User';

/**
 * Result type for async operations
 */
export interface AsyncOperationResult {
  success: boolean;
  error?: string;
}

/**
 * Loading states
 */
export interface LoadingState {
  isLoading: boolean;
  isSigningIn: boolean;
  isSigningOut: boolean;
}

/**
 * Error state
 */
export interface ErrorState {
  error: string | null;
}

/**
 * Data state
 */
export interface DataState {
  user: User | null;
  authenticated: boolean;
  sessionId: string | null;
}

/**
 * Auth event types from Supabase
 */
export type AuthEvent =
  | 'SIGNED_IN'
  | 'SIGNED_OUT'
  | 'TOKEN_REFRESHED'
  | 'USER_UPDATED'
  | 'PASSWORD_RECOVERY';

/**
 * Auth state change callback
 */
export type AuthStateChangeCallback = (event: AuthEvent, user: User | null) => void;

/**
 * Login field errors
 * Used for form validation error messages
 */
export interface LoginFieldErrors {
  email?: string;
  password?: string;
}

/**
 * Register field errors
 * Used for signup form validation error messages
 */
export interface RegisterFieldErrors {
  email?: string;
  password?: string;
  passwordConfirmation?: string;
  firstName?: string;
  lastName?: string;
}
