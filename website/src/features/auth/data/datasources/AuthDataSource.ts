/**
 * Auth Data Source
 * Data layer - Handles Supabase Auth API calls
 */

import { authService } from '@/core/services/supabase.service';

export class AuthDataSource {
  /**
   * Sign in with email and password
   */
  async signIn(email: string, password: string) {
    return await authService.signIn(email, password);
  }

  /**
   * Sign up with email and password
   * Creates auth user and users table profile
   * Following Flutter implementation: supabase_auth_datasource.dart signUp()
   */
  async signUp(
    email: string,
    password: string,
    firstName: string,
    lastName: string,
    metadata?: Record<string, any>
  ) {
    // Detect browser timezone (IANA format like "Asia/Ho_Chi_Minh")
    // Following Flutter implementation using flutter_timezone
    let timezone: string;
    try {
      timezone = Intl.DateTimeFormat().resolvedOptions().timeZone || 'Asia/Ho_Chi_Minh';
      // Validate IANA format (should not start with + or -)
      if (timezone.startsWith('+') || timezone.startsWith('-') || timezone.length < 3) {
        timezone = 'Asia/Ho_Chi_Minh'; // Fallback
      }
    } catch (e) {
      // Fallback to Hanoi, Vietnam if detection fails
      timezone = 'Asia/Ho_Chi_Minh';
      console.warn('⚠️ Failed to detect timezone, using default:', e);
    }

    // 1. Sign up with Supabase Auth
    const authResult = await authService.signUp(email, password, {
      first_name: firstName,
      last_name: lastName,
      full_name: `${firstName} ${lastName}`,
      preferred_timezone: timezone,
      ...metadata,
    });

    if (!authResult.user) {
      return authResult;
    }

    // 2. Create user profile in users table
    try {
      const { supabaseService } = await import('@/core/services/supabase.service');
      const now = new Date().toISOString();

      await supabaseService.from('users').upsert(
        {
          user_id: authResult.user.id,
          email: email,
          first_name: firstName,
          last_name: lastName,
          preferred_timezone: timezone,
          created_at: now,
          updated_at: now,
        },
        { onConflict: 'user_id' }
      );
    } catch (error) {
      // Following Flutter error handling pattern
      console.error('🚨 ERROR: Failed to create user profile for', authResult.user.id);
      console.error('Error:', error);
      // TODO: In production, use proper logging service (Sentry, Firebase Crashlytics)
      // TODO: Add retry queue or compensating transaction
    }

    return authResult;
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
