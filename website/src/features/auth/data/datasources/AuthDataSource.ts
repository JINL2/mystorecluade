/**
 * Auth Data Source
 * Data layer - Handles Supabase Auth API calls
 */

import { supabaseService, authService } from '@/core/services/supabase.service';

export class AuthDataSource {
  /**
   * Sign in with email and password
   */
  async signIn(email: string, password: string) {
    return await authService.signIn(email, password);
  }

  /**
   * Sign up with email and password
   */
  async signUp(email: string, password: string, metadata?: Record<string, any>) {
    return await authService.signUp(email, password, metadata);
  }

  /**
   * Sign out current user
   */
  async signOut() {
    return await authService.signOut();
  }

  /**
   * Get current user
   */
  async getCurrentUser() {
    return await authService.getCurrentUser();
  }

  /**
   * Get current session
   */
  async getCurrentSession() {
    return await authService.getCurrentSession();
  }

  /**
   * Reset password for email
   */
  async resetPassword(email: string) {
    return await authService.resetPassword(email);
  }

  /**
   * Listen to auth state changes
   */
  onAuthStateChange(callback: (event: string, session: any) => void) {
    return authService.onAuthStateChange(callback);
  }
}
