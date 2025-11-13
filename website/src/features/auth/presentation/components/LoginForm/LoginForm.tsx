/**
 * LoginForm Component
 * Presentation layer - Login form UI
 */

import React, { useState, FormEvent } from 'react';
import { TossInput } from '@/shared/components/toss/TossInput';
import { TossButton } from '@/shared/components/toss/TossButton';
import { useLogin } from '../../hooks/useLogin';
import type { LoginFormProps } from './LoginForm.types';
import styles from './LoginForm.module.css';

export const LoginForm: React.FC<LoginFormProps> = ({
  onSuccess,
  onError,
  showRememberMe = true,
  showForgotPassword = true,
}) => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [rememberMe, setRememberMe] = useState(false);

  const { login, loading, error, fieldErrors } = useLogin();

  const handleSubmit = async (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    const result = await login(email, password, rememberMe);

    if (result.success) {
      onSuccess?.();
    } else {
      // Build comprehensive error message
      // Priority: result.error > loginError state > fieldErrors > default message
      const errorMessage =
        result.error ||
        error ||
        Object.values(fieldErrors).join(', ') ||
        'Login failed';

      onError?.(errorMessage);
    }
  };

  return (
    <form className={styles.form} onSubmit={handleSubmit}>
      {/* Email Input */}
      <TossInput
        label="Email Address"
        type="email"
        name="email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        placeholder="Enter your email address"
        error={fieldErrors.email}
        required
        fullWidth
        autoComplete="email"
        iconLeft={
          <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor">
            <path d="M2.003 5.884L10 9.882l7.997-3.998A2 2 0 0016 4H4a2 2 0 00-1.997 1.884z" />
            <path d="M18 8.118l-8 4-8-4V14a2 2 0 002 2h12a2 2 0 002-2V8.118z" />
          </svg>
        }
      />

      {/* Password Input */}
      <TossInput
        label="Password"
        type="password"
        name="password"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        placeholder="Enter your password"
        error={fieldErrors.password}
        required
        fullWidth
        autoComplete="current-password"
        minLength={6}
        showPasswordToggle
      />

      {/* Remember Me Checkbox */}
      {showRememberMe && (
        <div className={styles.checkboxGroup}>
          <label className={styles.checkboxLabel}>
            <input
              type="checkbox"
              checked={rememberMe}
              onChange={(e) => setRememberMe(e.target.checked)}
              className={styles.checkbox}
            />
            <span>Remember me (Stay logged in on this device)</span>
          </label>
        </div>
      )}

      {/* Error Message */}
      {error && <div className={styles.errorAlert}>{error}</div>}

      {/* Submit Button */}
      <TossButton
        type="submit"
        variant="primary"
        size="lg"
        fullWidth
        loading={loading}
        disabled={loading}
      >
        {loading ? 'Signing In...' : 'Sign In'}
      </TossButton>

      {/* Forgot Password Link */}
      {showForgotPassword && (
        <div className={styles.forgotPassword}>
          <a href="/auth/forgot-password">Forgot your password?</a>
        </div>
      )}
    </form>
  );
};

export default LoginForm;
