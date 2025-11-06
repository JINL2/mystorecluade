/**
 * useAuth Hook
 * Shared hook - Global authentication state
 */

import { useState, useEffect } from 'react';
import { AuthRepositoryImpl } from '@/features/auth/data/repositories/AuthRepositoryImpl';
import type { User } from '@/features/auth/domain/entities/User';

export const useAuth = () => {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [authenticated, setAuthenticated] = useState(false);

  const repository = new AuthRepositoryImpl();

  useEffect(() => {
    checkAuth();
  }, []);

  const checkAuth = async () => {
    try {
      const currentUser = await repository.getCurrentUser();
      setUser(currentUser);
      setAuthenticated(currentUser !== null);
    } catch (error) {
      console.error('Auth check error:', error);
      setUser(null);
      setAuthenticated(false);
    } finally {
      setLoading(false);
    }
  };

  const signOut = async () => {
    try {
      await repository.signOut();
      setUser(null);
      setAuthenticated(false);
    } catch (error) {
      console.error('Sign out error:', error);
    }
  };

  return {
    user,
    loading,
    authenticated,
    signOut,
    refreshAuth: checkAuth,
  };
};
