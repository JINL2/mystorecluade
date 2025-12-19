/**
 * LoginForm Component
 * Presentation layer - Login form UI
 */

import React, { useState, FormEvent } from 'react';
import { TossInput } from '@/shared/components/toss/TossInput';
import { TossButton } from '@/shared/components/toss/TossButton';
import { authService } from '@/core/services/supabase_service';
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
  const [isGoogleLoading, setIsGoogleLoading] = useState(false);
  const [isAppleLoading, setIsAppleLoading] = useState(false);

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

  const handleGoogleSignIn = async () => {
    setIsGoogleLoading(true);
    try {
      const result = await authService.signInWithGoogle();
      if (!result.success) {
        onError?.(result.error || 'Failed to sign in with Google');
      }
      // OAuth will redirect, so no need to call onSuccess here
    } catch (err) {
      onError?.(err instanceof Error ? err.message : 'Failed to sign in with Google');
    } finally {
      setIsGoogleLoading(false);
    }
  };

  const handleAppleSignIn = async () => {
    setIsAppleLoading(true);
    try {
      const result = await authService.signInWithApple();
      if (!result.success) {
        onError?.(result.error || 'Failed to sign in with Apple');
      }
      // OAuth will redirect, so no need to call onSuccess here
    } catch (err) {
      onError?.(err instanceof Error ? err.message : 'Failed to sign in with Apple');
    } finally {
      setIsAppleLoading(false);
    }
  };

  const isSocialLoading = isGoogleLoading || isAppleLoading;

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
        disabled={loading || isSocialLoading}
      >
        {loading ? 'Signing In...' : 'Sign In'}
      </TossButton>

      {/* Forgot Password Link */}
      {showForgotPassword && (
        <div className={styles.forgotPassword}>
          <a href="/auth/forgot-password">Forgot your password?</a>
        </div>
      )}

      {/* Social Login Section */}
      <div className={styles.socialLoginSection}>
        <div className={styles.socialDivider}>
          <span>or continue with</span>
        </div>

        {/* Google Sign In Button */}
        <button
          type="button"
          className={`${styles.socialButton} ${styles.googleButton}`}
          onClick={handleGoogleSignIn}
          disabled={loading || isSocialLoading}
        >
          {isGoogleLoading ? (
            <div className={styles.socialButtonSpinner} />
          ) : (
            <svg className={styles.socialButtonIcon} viewBox="0 0 24 24">
              <path
                fill="#4285F4"
                d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
              />
              <path
                fill="#34A853"
                d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
              />
              <path
                fill="#FBBC05"
                d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"
              />
              <path
                fill="#EA4335"
                d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"
              />
            </svg>
          )}
          <span>{isGoogleLoading ? 'Signing in...' : 'Continue with Google'}</span>
        </button>

        {/* Apple Sign In Button */}
        <button
          type="button"
          className={`${styles.socialButton} ${styles.appleButton}`}
          onClick={handleAppleSignIn}
          disabled={loading || isSocialLoading}
        >
          {isAppleLoading ? (
            <div className={styles.socialButtonSpinner} />
          ) : (
            <svg className={styles.socialButtonIcon} viewBox="0 0 24 24" fill="currentColor">
              <path d="M17.05 20.28c-.98.95-2.05.8-3.08.35-1.09-.46-2.09-.48-3.24 0-1.44.62-2.2.44-3.06-.35C2.79 15.25 3.51 7.59 9.05 7.31c1.35.07 2.29.74 3.08.8 1.18-.24 2.31-.93 3.57-.84 1.51.12 2.65.72 3.4 1.8-3.12 1.87-2.38 5.98.48 7.13-.57 1.5-1.31 2.99-2.54 4.09l.01-.01zM12.03 7.25c-.15-2.23 1.66-4.07 3.74-4.25.29 2.58-2.34 4.5-3.74 4.25z"/>
            </svg>
          )}
          <span>{isAppleLoading ? 'Signing in...' : 'Continue with Apple'}</span>
        </button>
      </div>
    </form>
  );
};

export default LoginForm;
