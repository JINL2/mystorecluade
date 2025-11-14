/**
 * RegisterForm Component
 * Presentation layer - Register form UI
 */

import React, { useState, FormEvent } from 'react';
import { TossInput } from '@/shared/components/toss/TossInput';
import { TossButton } from '@/shared/components/toss/TossButton';
import { useRegister } from '../../hooks/useRegister';
import type { RegisterFormProps } from './RegisterForm.types';
import styles from './RegisterForm.module.css';

export const RegisterForm: React.FC<RegisterFormProps> = ({
  onSuccess,
  onError,
  showLoginLink = true,
}) => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [passwordConfirmation, setPasswordConfirmation] = useState('');
  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');

  const { register, loading, error, fieldErrors } = useRegister();

  const handleSubmit = async (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    const result = await register(email, password, passwordConfirmation, firstName, lastName);

    if (result.success) {
      onSuccess?.();
    } else {
      // Build comprehensive error message
      // Priority: result.error > registerError state > fieldErrors > default message
      const errorMessage =
        result.error ||
        error ||
        Object.values(fieldErrors).join(', ') ||
        'Registration failed';

      onError?.(errorMessage);
    }
  };

  return (
    <form className={styles.form} onSubmit={handleSubmit}>
      {/* Name Fields Row */}
      <div className={styles.nameRow}>
        <TossInput
          label="First Name"
          type="text"
          name="firstName"
          value={firstName}
          onChange={(e) => setFirstName(e.target.value)}
          placeholder="First name"
          error={fieldErrors.firstName}
          required
          fullWidth
          autoComplete="given-name"
        />

        <TossInput
          label="Last Name"
          type="text"
          name="lastName"
          value={lastName}
          onChange={(e) => setLastName(e.target.value)}
          placeholder="Last name"
          error={fieldErrors.lastName}
          required
          fullWidth
          autoComplete="family-name"
        />
      </div>

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
        autoComplete="new-password"
        minLength={6}
        showPasswordToggle
      />

      {/* Confirm Password Input */}
      <TossInput
        label="Confirm Password"
        type="password"
        name="passwordConfirmation"
        value={passwordConfirmation}
        onChange={(e) => setPasswordConfirmation(e.target.value)}
        placeholder="Confirm your password"
        error={fieldErrors.passwordConfirmation}
        required
        fullWidth
        autoComplete="new-password"
        minLength={6}
        showPasswordToggle
      />

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
        {loading ? 'Creating Account...' : 'Create Account'}
      </TossButton>

      {/* Login Link */}
      {showLoginLink && (
        <div className={styles.loginLink}>
          Already have an account? <a href="/auth/login">Sign in</a>
        </div>
      )}
    </form>
  );
};

export default RegisterForm;
