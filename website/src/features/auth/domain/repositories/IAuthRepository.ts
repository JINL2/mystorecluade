/**
 * Auth Repository Interface
 * Domain layer - Repository contract
 */

import { User } from '../entities/User';

export interface LoginCredentials {
  email: string;
  password: string;
  rememberMe?: boolean;
}

export interface SignupCredentials {
  email: string;
  password: string;
  firstName: string;
  lastName: string;
  metadata?: Record<string, any>;
}

export interface AuthResult {
  success: boolean;
  user?: User;
  error?: string;
}

export interface IAuthRepository {
  /**
   * Sign in with email and password
   */
  signIn(credentials: LoginCredentials): Promise<AuthResult>;

  /**
   * Sign up with email and password
   */
  signUp(credentials: SignupCredentials): Promise<AuthResult>;

  /**
   * Sign out current user
   */
  signOut(): Promise<{ success: boolean; error?: string }>;

  /**
   * Get current authenticated user
   */
  getCurrentUser(): Promise<User | null>;

  /**
   * Check if user is authenticated
   */
  isAuthenticated(): Promise<boolean>;

  /**
   * Reset password for email
   */
  resetPassword(email: string): Promise<{ success: boolean; error?: string }>;
}
