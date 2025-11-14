/**
 * RegisterPage Component
 * Presentation layer - Register page
 */

import React, { useEffect, useState } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { RegisterForm } from '../../components/RegisterForm';
import { TossButton } from '@/shared/components/toss/TossButton';
import { Images } from '@/core/constants/assets';
import { useAuth } from '@/shared/hooks/useAuth';
import { useAppState } from '@/app/providers/app_state_provider';
import type { RegisterPageProps } from './RegisterPage.types';
import styles from './RegisterPage.module.css';

export const RegisterPage: React.FC<RegisterPageProps> = ({ redirectUrl }) => {
  const navigate = useNavigate();
  const location = useLocation();
  const { authenticated, loading } = useAuth();
  const { loadUserData, loadCategoryFeatures } = useAppState();
  const [loadingUserData, setLoadingUserData] = useState(false);

  // Get redirect URL from location state or use provided redirectUrl or default to dashboard
  const from = location.state?.from?.pathname || redirectUrl || '/dashboard';

  // Redirect if already authenticated
  useEffect(() => {
    if (!loading && authenticated) {
      navigate(from, { replace: true });
    }
  }, [authenticated, loading, navigate, from]);

  const handleRegisterSuccess = async () => {
    try {
      // Show loading state while loading user data
      setLoadingUserData(true);

      // Load user company data and category features after registration
      await Promise.all([
        loadUserData(),
        loadCategoryFeatures()
      ]);

      // Navigate to the original requested page or dashboard
      navigate(from, { replace: true });
    } catch (error) {
      console.error('Failed to load user data:', error);
      // Navigate anyway even if user data loading fails
      navigate(from, { replace: true });
    } finally {
      setLoadingUserData(false);
    }
  };

  const handleRegisterError = (error: string) => {
    console.error('Registration error:', error);
  };

  const handleSignInClick = () => {
    navigate('/auth/login');
  };

  if (loading) {
    return (
      <div className={styles.loadingContainer}>
        <div className={styles.spinner}>Loading...</div>
      </div>
    );
  }

  // Show loading overlay while loading user data after successful registration
  if (loadingUserData) {
    return (
      <div className={styles.loadingContainer}>
        <div className={styles.spinner}>Setting up your account...</div>
        <p className={styles.loadingText}>Please wait while we create your workspace</p>
      </div>
    );
  }

  // Don't render register page if already authenticated
  if (authenticated) {
    return null;
  }

  return (
    <div className={styles.container}>
      <div className={styles.card}>
        {/* Header */}
        <div className={styles.header}>
          <div className={styles.logo}>
            <img src={Images.appIcon} alt="Store Base Logo" />
          </div>
          <h1 className={styles.title}>Create Your Account</h1>
          <p className={styles.subtitle}>Join Store Base to manage your store</p>
        </div>

        {/* Register Form */}
        <RegisterForm onSuccess={handleRegisterSuccess} onError={handleRegisterError} />

        {/* Divider */}
        <div className={styles.divider}>
          <span>Or</span>
        </div>

        {/* Sign In Option */}
        <div className={styles.actions}>
          <TossButton
            variant="outline"
            size="lg"
            fullWidth
            onClick={handleSignInClick}
          >
            Sign In to Existing Account
          </TossButton>
        </div>

        {/* Footer */}
        <div className={styles.footer}>
          <p>
            By creating an account, you agree to our{' '}
            <a href="/terms">Terms of Service</a> and{' '}
            <a href="/privacy">Privacy Policy</a>
          </p>
        </div>
      </div>
    </div>
  );
};

export default RegisterPage;
