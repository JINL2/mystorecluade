/**
 * Supabase Service
 * Authentication and database connection service
 *
 * @description TypeScript implementation of Supabase client wrapper
 * @version 2.0
 */

import { createClient, SupabaseClient, Session, User } from '@supabase/supabase-js';
import type { Database } from '@/core/types/supabase.types';

// Supabase configuration from environment variables
const SUPABASE_URL = import.meta.env.VITE_SUPABASE_URL;
const SUPABASE_ANON_KEY = import.meta.env.VITE_SUPABASE_ANON_KEY;

/**
 * Supabase Service Class
 * Singleton pattern for Supabase client
 */
class SupabaseService {
  private static instance: SupabaseService;
  private client: SupabaseClient<Database>;

  private constructor() {
    if (!SUPABASE_URL || !SUPABASE_ANON_KEY) {
      throw new Error('Supabase URL and Anon Key must be provided in environment variables');
    }

    this.client = createClient<Database>(SUPABASE_URL, SUPABASE_ANON_KEY, {
      auth: {
        persistSession: true,
        autoRefreshToken: true,
        detectSessionInUrl: true,
        storage: window.localStorage,
      },
    });

    console.log('Supabase initialized successfully with persistence');
  }

  /**
   * Get singleton instance
   */
  public static getInstance(): SupabaseService {
    if (!SupabaseService.instance) {
      SupabaseService.instance = new SupabaseService();
    }
    return SupabaseService.instance;
  }

  /**
   * Get Supabase client
   */
  public getClient(): SupabaseClient<Database> {
    return this.client;
  }

  /**
   * Get auth instance
   */
  public get auth() {
    return this.client.auth;
  }

  /**
   * Get table instance
   */
  public from<T extends keyof Database['public']['Tables']>(table: T) {
    return this.client.from(table);
  }

  /**
   * Call Supabase RPC function
   */
  public async rpc<T>(functionName: string, params?: Record<string, any>): Promise<T> {
    const { data, error } = await this.client.rpc(functionName, params);
    if (error) throw error;
    return data as T;
  }
}

/**
 * Authentication Service
 */
export class AuthService {
  private supabase: SupabaseClient<Database>;

  constructor() {
    this.supabase = SupabaseService.getInstance().getClient();
  }

  /**
   * Sign in with email and password
   */
  async signIn(email: string, password: string) {
    try {
      const { data, error } = await this.supabase.auth.signInWithPassword({
        email,
        password,
      });

      if (error) throw error;

      return { success: true, user: data.user, session: data.session };
    } catch (error) {
      console.error('Login error:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error',
      };
    }
  }

  /**
   * Sign up with email and password
   */
  async signUp(email: string, password: string, additionalData: Record<string, any> = {}) {
    try {
      const { data, error } = await this.supabase.auth.signUp({
        email,
        password,
        options: {
          data: additionalData,
        },
      });

      if (error) throw error;

      return { success: true, user: data.user, session: data.session };
    } catch (error) {
      console.error('Signup error:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error',
      };
    }
  }

  /**
   * Sign out
   */
  async signOut() {
    try {
      const { error } = await this.supabase.auth.signOut();

      if (error) {
        console.warn('Supabase signout error:', error);
      }

      // Clear all local storage data
      localStorage.removeItem('user');
      localStorage.removeItem('session');
      localStorage.removeItem('companyChoosen');
      localStorage.removeItem('storeChoosen');
      sessionStorage.clear();

      return { success: true };
    } catch (error) {
      console.error('Logout error:', error);

      // Clear local data even if error occurs
      localStorage.removeItem('user');
      localStorage.removeItem('session');
      localStorage.removeItem('companyChoosen');
      localStorage.removeItem('storeChoosen');
      sessionStorage.clear();

      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error',
      };
    }
  }

  /**
   * Get current user
   */
  async getCurrentUser() {
    try {
      const {
        data: { user },
        error,
      } = await this.supabase.auth.getUser();

      if (error) throw error;

      return { success: true, user };
    } catch (error) {
      console.error('Get user error:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error',
      };
    }
  }

  /**
   * Get current session
   */
  async getCurrentSession() {
    try {
      const {
        data: { session },
        error,
      } = await this.supabase.auth.getSession();

      if (error) throw error;

      return { success: true, session };
    } catch (error) {
      console.error('Get session error:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error',
      };
    }
  }

  /**
   * Listen to auth state changes
   */
  onAuthStateChange(callback: (event: string, session: Session | null) => void) {
    return this.supabase.auth.onAuthStateChange((event, session) => {
      callback(event, session);
    });
  }

  /**
   * Reset password
   */
  async resetPassword(email: string) {
    try {
      const resetPasswordUrl = `${window.location.origin}/auth/reset-password`;

      const { error } = await this.supabase.auth.resetPasswordForEmail(email, {
        redirectTo: resetPasswordUrl,
      });

      if (error) throw error;

      return { success: true };
    } catch (error) {
      console.error('Reset password error:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error',
      };
    }
  }
}

/**
 * Database Service
 */
export class DatabaseService {
  private supabase: SupabaseClient<Database>;

  constructor() {
    this.supabase = SupabaseService.getInstance().getClient();
  }

  /**
   * Get user companies and stores
   */
  async getUserCompaniesAndStores() {
    try {
      const { data, error } = await this.supabase.rpc('get_user_companies_and_stores');

      if (error) throw error;

      return { success: true, data };
    } catch (error) {
      console.error('Get companies error:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error',
      };
    }
  }

  /**
   * Get categories with features
   */
  async getCategoriesWithFeatures(companyId: string) {
    try {
      const { data, error } = await this.supabase.rpc('get_categories_with_features', {
        p_company_id: companyId,
      });

      if (error) throw error;

      return { success: true, data };
    } catch (error) {
      console.error('Get categories error:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error',
      };
    }
  }

  /**
   * Generic query function
   */
  async query<T>(
    table: string,
    options: {
      select?: string;
      filters?: Record<string, any>;
      orderBy?: { column: string; ascending?: boolean };
      limit?: number;
    } = {}
  ) {
    try {
      let query = this.supabase.from(table).select(options.select || '*');

      // Apply filters
      if (options.filters) {
        Object.entries(options.filters).forEach(([key, value]) => {
          query = query.eq(key, value);
        });
      }

      // Apply ordering
      if (options.orderBy) {
        query = query.order(options.orderBy.column, {
          ascending: options.orderBy.ascending !== false,
        });
      }

      // Apply limit
      if (options.limit) {
        query = query.limit(options.limit);
      }

      const { data, error } = await query;

      if (error) throw error;

      return { success: true, data: data as T };
    } catch (error) {
      console.error('Query error:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error',
      };
    }
  }
}

// Export singleton instance
export const supabaseService = SupabaseService.getInstance();
export const authService = new AuthService();
export const databaseService = new DatabaseService();
