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
      firstName: supabaseUser.user_metadata?.first_name || null,
      lastName: supabaseUser.user_metadata?.last_name || null,
      emailConfirmed: supabaseUser.email_confirmed_at !== null,
      createdAt: supabaseUser.created_at,
      lastSignIn: supabaseUser.last_sign_in_at,
      metadata: supabaseUser.user_metadata || {},
      userPhoneNumber: supabaseUser.user_metadata?.user_phone_number || null,
      profileImage: supabaseUser.user_metadata?.profile_image || null,
      preferredTimezone: supabaseUser.user_metadata?.preferred_timezone || 'Asia/Ho_Chi_Minh',
      isDeleted: false,
      updatedAt: supabaseUser.updated_at || null,
    });
  }

  /**
   * Convert users table row to Domain User Entity
   */
  static fromUsersTable(row: {
    user_id: string;
    email: string;
    first_name: string | null;
    last_name: string | null;
    email_confirmed_at?: string | null;
    created_at: string;
    last_sign_in_at?: string | null;
    user_phone_number?: string | null;
    profile_image?: string | null;
    preferred_timezone?: string;
    is_deleted?: boolean;
    updated_at?: string | null;
  }): User {
    return User.create({
      id: row.user_id,
      email: row.email,
      firstName: row.first_name,
      lastName: row.last_name,
      emailConfirmed: row.email_confirmed_at !== null,
      createdAt: row.created_at,
      lastSignIn: row.last_sign_in_at || null,
      metadata: {},
      userPhoneNumber: row.user_phone_number || null,
      profileImage: row.profile_image || null,
      preferredTimezone: row.preferred_timezone || 'Asia/Ho_Chi_Minh',
      isDeleted: row.is_deleted || false,
      updatedAt: row.updated_at || null,
    });
  }

  /**
   * Convert Domain User Entity to users table insert format
   * Following Flutter implementation: user_model.dart toInsertMap()
   */
  static toInsertMap(user: User): Record<string, any> {
    const map: Record<string, any> = {
      user_id: user.id,
      email: user.email,
      created_at: user.createdAt.toISOString(),
      updated_at: new Date().toISOString(),
    };

    if (user.firstName) map.first_name = user.firstName;
    if (user.lastName) map.last_name = user.lastName;
    if (user.userPhoneNumber) map.user_phone_number = user.userPhoneNumber;
    if (user.profileImage) map.profile_image = user.profileImage;
    if (user.preferredTimezone) map.preferred_timezone = user.preferredTimezone;

    return map;
  }

  /**
   * Convert Domain User Entity to JSON
   */
  static toJson(user: User): Record<string, any> {
    return {
      id: user.id,
      email: user.email,
      first_name: user.firstName,
      last_name: user.lastName,
      email_confirmed: user.emailConfirmed,
      created_at: user.createdAt.toISOString(),
      last_sign_in_at: user.lastSignIn?.toISOString() || null,
      metadata: user.metadata,
      user_phone_number: user.userPhoneNumber,
      profile_image: user.profileImage,
      preferred_timezone: user.preferredTimezone,
      is_deleted: user.isDeleted,
      updated_at: user.updatedAt?.toISOString() || null,
    };
  }

  /**
   * Convert Domain User Entity to update map for Supabase
   * Following Flutter implementation: user_model.dart toUpdateMap()
   * Only includes fields that can be updated
   */
  static toUpdateMap(user: User): Record<string, any> {
    const map: Record<string, any> = {
      updated_at: new Date().toISOString(),
    };

    if (user.firstName) map.first_name = user.firstName;
    if (user.lastName) map.last_name = user.lastName;
    if (user.userPhoneNumber) map.user_phone_number = user.userPhoneNumber;
    if (user.profileImage) map.profile_image = user.profileImage;
    if (user.preferredTimezone) map.preferred_timezone = user.preferredTimezone;

    return map;
  }
}
