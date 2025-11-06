/**
 * Auth Repository Implementation
 * Data layer - Implements IAuthRepository interface
 */

import {
  IAuthRepository,
  LoginCredentials,
  SignupCredentials,
  AuthResult,
} from '../../domain/repositories/IAuthRepository';
import { User } from '../../domain/entities/User';
import { AuthDataSource } from '../datasources/AuthDataSource';
import { UserModel } from '../models/UserModel';

export class AuthRepositoryImpl implements IAuthRepository {
  private dataSource: AuthDataSource;

  constructor() {
    this.dataSource = new AuthDataSource();
  }

  async signIn(credentials: LoginCredentials): Promise<AuthResult> {
    try {
      const result = await this.dataSource.signIn(credentials.email, credentials.password);

      if (!result.success || !result.user) {
        return {
          success: false,
          error: result.error || 'Login failed',
        };
      }

      // Store remember me preference
      if (credentials.rememberMe !== undefined) {
        localStorage.setItem('rememberMe', credentials.rememberMe ? 'true' : 'false');
      }

      const user = UserModel.fromSupabase(result.user);

      return {
        success: true,
        user,
      };
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'An unexpected error occurred',
      };
    }
  }

  async signUp(credentials: SignupCredentials): Promise<AuthResult> {
    try {
      const result = await this.dataSource.signUp(
        credentials.email,
        credentials.password,
        credentials.metadata
      );

      if (!result.success || !result.user) {
        return {
          success: false,
          error: result.error || 'Signup failed',
        };
      }

      const user = UserModel.fromSupabase(result.user);

      return {
        success: true,
        user,
      };
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'An unexpected error occurred',
      };
    }
  }

  async signOut(): Promise<{ success: boolean; error?: string }> {
    try {
      const result = await this.dataSource.signOut();
      return result;
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Sign out failed',
      };
    }
  }

  async getCurrentUser(): Promise<User | null> {
    try {
      const result = await this.dataSource.getCurrentUser();

      if (!result.success || !result.user) {
        return null;
      }

      return UserModel.fromSupabase(result.user);
    } catch (error) {
      console.error('Get current user error:', error);
      return null;
    }
  }

  async isAuthenticated(): Promise<boolean> {
    try {
      const sessionResult = await this.dataSource.getCurrentSession();
      return sessionResult.success && sessionResult.session !== null;
    } catch (error) {
      return false;
    }
  }

  async resetPassword(email: string): Promise<{ success: boolean; error?: string }> {
    try {
      const result = await this.dataSource.resetPassword(email);
      return result;
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Password reset failed',
      };
    }
  }
}
