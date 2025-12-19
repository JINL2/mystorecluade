/**
 * AuthCallbackPage Component
 * Handles OAuth callback from Google/Apple sign-in
 */

import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAppState } from '@/app/providers/app_state_provider';
import styles from './AuthCallbackPage.module.css';

export const AuthCallbackPage: React.FC = () => {
  const navigate = useNavigate();
  const { loadUserData, loadCategoryFeatures } = useAppState();
  const [status, setStatus] = useState<'loading' | 'success' | 'error'>('loading');
  const [errorMessage, setErrorMessage] = useState<string>('');

  useEffect(() => {
    const handleCallback = async () => {
      try {
        // Check for error in URL hash or query params
        const hashParams = new URLSearchParams(window.location.hash.substring(1));
        const queryParams = new URLSearchParams(window.location.search);

        const error = hashParams.get('error') || queryParams.get('error');
        const errorDescription = hashParams.get('error_description') || queryParams.get('error_description');

        if (error) {
          console.error('OAuth error:', error, errorDescription);
          setStatus('error');
          setErrorMessage(errorDescription || 'Authentication failed');
          return;
        }

        // Supabase should have already set the session via detectSessionInUrl
        // Wait a moment for the session to be established
        await new Promise(resolve => setTimeout(resolve, 500));

        // Load user data
        setStatus('loading');
        await Promise.all([
          loadUserData(),
          loadCategoryFeatures()
        ]);

        setStatus('success');

        // Redirect to dashboard after short delay
        setTimeout(() => {
          navigate('/dashboard', { replace: true });
        }, 1000);

      } catch (err) {
        console.error('Callback handling error:', err);
        setStatus('error');
        setErrorMessage(err instanceof Error ? err.message : 'Failed to complete authentication');
      }
    };

    handleCallback();
  }, [navigate, loadUserData, loadCategoryFeatures]);

  const handleRetry = () => {
    navigate('/login', { replace: true });
  };

  return (
    <div className={styles.container}>
      <div className={styles.card}>
        {status === 'loading' && (
          <>
            <div className={styles.spinner} />
            <h2 className={styles.title}>Completing sign-in...</h2>
            <p className={styles.subtitle}>Please wait while we set up your account</p>
          </>
        )}

        {status === 'success' && (
          <>
            <div className={styles.successIcon}>
              <svg viewBox="0 0 24 24" fill="currentColor">
                <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
              </svg>
            </div>
            <h2 className={styles.title}>Welcome!</h2>
            <p className={styles.subtitle}>Redirecting to dashboard...</p>
          </>
        )}

        {status === 'error' && (
          <>
            <div className={styles.errorIcon}>
              <svg viewBox="0 0 24 24" fill="currentColor">
                <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z" />
              </svg>
            </div>
            <h2 className={styles.title}>Authentication Failed</h2>
            <p className={styles.subtitle}>{errorMessage || 'Something went wrong'}</p>
            <button className={styles.retryButton} onClick={handleRetry}>
              Back to Login
            </button>
          </>
        )}
      </div>
    </div>
  );
};

export default AuthCallbackPage;
