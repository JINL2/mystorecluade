/**
 * Supabase Service
 * Authentication and database connection service
 *
 * @description TypeScript implementation of Supabase client wrapper
 * @version 2.0
 */

import { createClient, SupabaseClient, Session } from '@supabase/supabase-js';
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
    const { data, error } = await this.client.rpc(functionName as any, params as any);
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
   * Returns null if no session exists (not an error condition)
   */
  async getCurrentUser() {
    try {
      // First check if session exists to avoid error logs
      const {
        data: { session },
      } = await this.supabase.auth.getSession();

      // No session = user not logged in (normal condition, not an error)
      if (!session) {
        return { success: true, user: null };
      }

      // Session exists, get user details
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
        user: null,
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

  /**
   * Sign in with Google OAuth
   */
  async signInWithGoogle() {
    try {
      const { data, error } = await this.supabase.auth.signInWithOAuth({
        provider: 'google',
        options: {
          redirectTo: `${window.location.origin}/auth/callback`,
          queryParams: {
            access_type: 'offline',
            prompt: 'consent',
          },
        },
      });

      if (error) throw error;

      return { success: true, data };
    } catch (error) {
      console.error('Google sign-in error:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to sign in with Google',
      };
    }
  }

  /**
   * Sign in with Apple OAuth
   */
  async signInWithApple() {
    try {
      const { data, error } = await this.supabase.auth.signInWithOAuth({
        provider: 'apple',
        options: {
          redirectTo: `${window.location.origin}/auth/callback`,
        },
      });

      if (error) throw error;

      return { success: true, data };
    } catch (error) {
      console.error('Apple sign-in error:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to sign in with Apple',
      };
    }
  }
}

/**
 * Storage Service
 */
export class StorageService {
  private supabase: SupabaseClient<Database>;

  constructor() {
    this.supabase = SupabaseService.getInstance().getClient();
  }

  /**
   * Upload image to Supabase Storage
   * @param bucket - Storage bucket name (e.g., 'inventory_image')
   * @param path - File path within bucket (e.g., '{company_id}/filename.jpg')
   * @param file - File object or base64 data URL
   * @param options - Upload options
   * @returns Public URL of uploaded file
   */
  async uploadImage(
    bucket: string,
    path: string,
    file: File | string,
    options?: { upsert?: boolean }
  ): Promise<{ success: boolean; data?: string; error?: string }> {
    try {
      let fileToUpload: File | Blob;

      // Handle base64 data URL conversion
      if (typeof file === 'string') {
        const base64Response = await fetch(file);
        const blob = await base64Response.blob();
        fileToUpload = blob;
      } else {
        fileToUpload = file;
      }

      // Upload to Storage
      const { data, error } = await this.supabase.storage
        .from(bucket)
        .upload(path, fileToUpload, {
          cacheControl: '3600',
          upsert: options?.upsert ?? false,
        });

      if (error) {
        console.error('Upload error:', error);
        return {
          success: false,
          error: error.message,
        };
      }

      // Get public URL
      const {
        data: { publicUrl },
      } = this.supabase.storage.from(bucket).getPublicUrl(path);

      return {
        success: true,
        data: publicUrl,
      };
    } catch (error) {
      console.error('Upload error:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error',
      };
    }
  }

  /**
   * Delete image from Supabase Storage
   * @param bucket - Storage bucket name
   * @param path - File path within bucket
   */
  async deleteImage(bucket: string, path: string): Promise<{ success: boolean; error?: string }> {
    try {
      const { error } = await this.supabase.storage.from(bucket).remove([path]);

      if (error) {
        console.error('Delete error:', error);
        return {
          success: false,
          error: error.message,
        };
      }

      return { success: true };
    } catch (error) {
      console.error('Delete error:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error',
      };
    }
  }

  /**
   * Get public URL for a file
   * @param bucket - Storage bucket name
   * @param path - File path within bucket
   */
  getPublicUrl(bucket: string, path: string): string {
    const {
      data: { publicUrl },
    } = this.supabase.storage.from(bucket).getPublicUrl(path);

    return publicUrl;
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
      const { data, error } = await this.supabase.rpc('get_user_companies_and_stores' as any);

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
      const { data, error } = await this.supabase.rpc('get_categories_with_features' as any, {
        p_company_id: companyId,
      } as any);

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
      let query = this.supabase.from(table as any).select(options.select || '*');

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
export const storageService = new StorageService();
