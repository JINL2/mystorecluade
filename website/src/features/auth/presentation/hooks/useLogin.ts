/**
 * useLogin Hook
 * Presentation layer - Login logic
 */

import { useState } from 'react';
import { AuthRepositoryImpl } from '../../data/repositories/AuthRepositoryImpl';
import { AuthValidator } from '../../domain/validators/AuthValidator';
import type { LoginCredentials } from '../../domain/repositories/IAuthRepository';

export const useLogin = () => {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [fieldErrors, setFieldErrors] = useState<Record<string, string>>({});

  const repository = new AuthRepositoryImpl();

  const login = async (email: string, password: string, rememberMe: boolean = false) => {
    // Clear previous errors
    setError(null);
    setFieldErrors({});

    // Validate credentials
    const validationErrors = AuthValidator.validateLoginCredentials(email, password);
    if (validationErrors.length > 0) {
      const errors: Record<string, string> = {};
      validationErrors.forEach((err) => {
        errors[err.field] = err.message;
      });
      setFieldErrors(errors);
      return { success: false };
    }

    setLoading(true);

    try {
      const credentials: LoginCredentials = {
        email,
        password,
        rememberMe,
      };

      const result = await repository.signIn(credentials);

      if (!result.success) {
        setError(result.error || 'Login failed. Please try again.');
        return { success: false };
      }

      return { success: true, user: result.user };
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : 'An unexpected error occurred';
      setError(errorMessage);
      return { success: false };
    } finally {
      setLoading(false);
    }
  };

  return {
    login,
    loading,
    error,
    fieldErrors,
  };
};
