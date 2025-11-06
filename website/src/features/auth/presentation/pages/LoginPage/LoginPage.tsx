/**
 * LoginPage Component
 * Presentation layer - Login page
 */

import React, { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { LoginForm } from '../../components/LoginForm';
import { TossButton } from '@/shared/components/toss/TossButton';
import { Images } from '@/core/constants/assets';
import { useAuth } from '@/shared/hooks/useAuth';
import type { LoginPageProps } from './LoginPage.types';
import styles from './LoginPage.module.css';

export const LoginPage: React.FC<LoginPageProps> = ({ redirectUrl = '/dashboard' }) => {
  const navigate = useNavigate();
  const { authenticated, loading } = useAuth();

  // Redirect if already authenticated
  useEffect(() => {
    if (!loading && authenticated) {
      navigate(redirectUrl, { replace: true });
    }
  }, [authenticated, loading, navigate, redirectUrl]);

  const handleLoginSuccess = () => {
    navigate(redirectUrl, { replace: true });
  };

  const handleLoginError = (error: string) => {
    console.error('Login error:', error);
  };

  const handleSignUpClick = () => {
    navigate('/auth/register');
  };

  if (loading) {
    return (
      <div className={styles.loadingContainer}>
        <div className={styles.spinner}>Loading...</div>
      </div>
    );
  }

  // Don't render login page if already authenticated
  if (authenticated) {
    return null;
  }

  return (
    <div className={styles.container}>
      <div className={styles.card}>
        {/* Header */}
        <div className={styles.header}>
          <div className={styles.logo}>
            <img src={Images.appIconTransparent} alt="Store Base Logo" />
          </div>
          <h1 className={styles.title}>Welcome to Store Base</h1>
          <p className={styles.subtitle}>Sign in to manage your store</p>
        </div>

        {/* Login Form */}
        <LoginForm onSuccess={handleLoginSuccess} onError={handleLoginError} />

        {/* Divider */}
        <div className={styles.divider}>
          <span>Or</span>
        </div>

        {/* Sign Up Option */}
        <div className={styles.actions}>
          <TossButton
            variant="outline"
            size="lg"
            fullWidth
            onClick={handleSignUpClick}
          >
            Create New Account
          </TossButton>
        </div>

        {/* Footer */}
        <div className={styles.footer}>
          <p>
            By signing in, you agree to our{' '}
            <a href="/terms">Terms of Service</a> and{' '}
            <a href="/privacy">Privacy Policy</a>
          </p>
        </div>
      </div>
    </div>
  );
};

export default LoginPage;
