/**
 * User Model (DTO)
 * Data layer - Data Transfer Object for User
 */

import { User as SupabaseUser } from '@supabase/supabase-js';
import { User } from '../../domain/entities/User';

export class UserModel {
  /**
   * Convert Supabase User to Domain User Entity
   */
  static fromSupabase(supabaseUser: SupabaseUser): User {
    return User.create({
      id: supabaseUser.id,
      email: supabaseUser.email!,
      emailConfirmed: supabaseUser.email_confirmed_at !== null,
      createdAt: supabaseUser.created_at,
      lastSignIn: supabaseUser.last_sign_in_at,
      metadata: supabaseUser.user_metadata || {},
    });
  }

  /**
   * Convert Domain User Entity to JSON
   */
  static toJson(user: User): Record<string, any> {
    return {
      id: user.id,
      email: user.email,
      email_confirmed: user.emailConfirmed,
      created_at: user.createdAt.toISOString(),
      last_sign_in_at: user.lastSignIn?.toISOString() || null,
      metadata: user.metadata,
    };
  }
}
