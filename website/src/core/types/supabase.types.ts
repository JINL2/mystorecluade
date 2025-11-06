/**
 * Supabase Database Types
 * Auto-generated types for Supabase tables and functions
 *
 * @description TypeScript types for Supabase database schema
 * @note This file should be regenerated when database schema changes
 * @command npx supabase gen types typescript --project-id [project-id] > src/core/types/supabase.types.ts
 */

export type Json = string | number | boolean | null | { [key: string]: Json | undefined } | Json[];

export interface Database {
  public: {
    Tables: {
      [key: string]: {
        Row: Record<string, any>;
        Insert: Record<string, any>;
        Update: Record<string, any>;
      };
    };
    Views: {
      [key: string]: {
        Row: Record<string, any>;
      };
    };
    Functions: {
      [key: string]: {
        Args: Record<string, any>;
        Returns: any;
      };
    };
    Enums: {
      [key: string]: string;
    };
  };
}

/**
 * TODO: Replace this placeholder with actual Supabase types
 * Run: npx supabase gen types typescript --project-id atkekzwgukdvucqntryo > src/core/types/supabase.types.ts
 */
