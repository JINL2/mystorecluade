/**
 * ProtectedRoute Component
 * Route guard with authentication and authorization checks
 */

import React, { useState, useEffect, useRef } from 'react';
import { Navigate, useNavigate } from 'react-router-dom';
import { useAuth } from '@/shared/hooks/useAuth';
import { useAppState } from '@/app/providers/app_state_provider';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';

interface ProtectedRouteProps {
  children: React.ReactNode;
  requiredFeatureId?: string; // Optional: feature_id to check in permissions array
}

export const ProtectedRoute: React.FC<ProtectedRouteProps> = ({
  children,
  requiredFeatureId
}) => {
  const navigate = useNavigate();
  const { authenticated, loading } = useAuth();
  const { permissions, companies, currentCompany } = useAppState();
  const [showPermissionError, setShowPermissionError] = useState(false);
  const [shouldRedirect, setShouldRedirect] = useState(false);
  const [initialLoadComplete, setInitialLoadComplete] = useState(false);
  const [hasError, setHasError] = useState(false);
  const redirectAttempted = useRef(false);

  // Helper function to clear auth data and redirect
  const clearAndRedirect = (reason: string) => {
    if (redirectAttempted.current) return;
    redirectAttempted.current = true;

    console.warn(`${reason}, redirecting to login`);
    localStorage.removeItem('user');
    localStorage.removeItem('companyChoosen');
    localStorage.removeItem('storeChoosen');

    // Use window.location for guaranteed redirect
    window.location.href = '/login';
  };

  // Check for user without companies immediately on mount
  useEffect(() => {
    if (!loading && authenticated) {
      const storedUserStr = localStorage.getItem('user');
      if (storedUserStr) {
        try {
          const storedUserData = JSON.parse(storedUserStr);
          if (storedUserData && (!storedUserData.companies || storedUserData.companies.length === 0)) {
            clearAndRedirect('User has no companies in localStorage');
          }
        } catch (e) {
          clearAndRedirect('Failed to parse user data');
        }
      }
    }
  }, [loading, authenticated]);

  // Wait for initial data load after authentication
  useEffect(() => {
    if (authenticated && !loading) {
      // Give some time for loadUserData to complete
      const timer = setTimeout(() => {
        setInitialLoadComplete(true);
      }, 3000); // 3 second timeout for initial load (increased for slow connections)
      return () => clearTimeout(timer);
    }
  }, [authenticated, loading]);

  // Check after initial load complete
  useEffect(() => {
    if (initialLoadComplete && authenticated) {
      const storedUserStr = localStorage.getItem('user');
      let hasCompaniesInStorage = false;

      if (storedUserStr) {
        try {
          const userData = JSON.parse(storedUserStr);
          hasCompaniesInStorage = userData?.companies && userData.companies.length > 0;
        } catch (e) {
          // Parse error
        }
      }

      const hasCompaniesInState = companies && companies.length > 0;

      if (!hasCompaniesInState && !hasCompaniesInStorage) {
        clearAndRedirect('No companies found for user after timeout');
      }
    }
  }, [initialLoadComplete, authenticated, companies]);

  // Reset states when route changes
  useEffect(() => {
    setShowPermissionError(false);
    setShouldRedirect(false);
    setHasError(false);
    redirectAttempted.current = false;
  }, [requiredFeatureId]);

  // Loading state
  if (loading) {
    return <LoadingAnimation fullscreen size="large" />;
  }

  // Not authenticated → redirect to login
  if (!authenticated) {
    return <Navigate to="/login" replace />;
  }

  // Safe localStorage parsing with error handling
  let userData: any = {};
  try {
    const storedUser = localStorage.getItem('user');
    if (storedUser) {
      userData = JSON.parse(storedUser);
    }
  } catch (e) {
    // Will be handled by useEffect
    return <LoadingAnimation fullscreen size="large" />;
  }

  const hasCompaniesInState = companies && companies.length > 0;
  const hasCompaniesInStorage = userData?.companies && userData.companies.length > 0;
  const hasCompanies = hasCompaniesInState || hasCompaniesInStorage;

  // Still loading companies data - show loading while useEffect handles redirect
  if (!hasCompanies) {
    return <LoadingAnimation fullscreen size="large" />;
  }

  // Check permission if requiredFeatureId is specified
  if (requiredFeatureId) {
    // Use already parsed userData from above (no duplicate parsing)
    const selectedCompanyId = localStorage.getItem('companyChoosen');
    const selectedCompany = userData?.companies?.find(
      (c: any) => c.company_id === selectedCompanyId
    );
    const companyPermissions = selectedCompany?.role?.permissions || [];

    // Debug logging
    console.log('🔐 ProtectedRoute 권한 체크:', {
      requiredFeatureId,
      selectedCompanyId,
      companyName: selectedCompany?.company_name,
      roleName: selectedCompany?.role?.role_name,
      permissionsCount: companyPermissions.length,
      permissions: companyPermissions,
      hasFeature: companyPermissions.includes(requiredFeatureId)
    });

    // localStorage의 회사 권한을 우선 사용 (AppState 동기화 문제 해결)
    const hasAccess = companyPermissions.includes(requiredFeatureId);

    if (!hasAccess) {
      // Show error message and redirect after auto-close
      if (!showPermissionError) {
        setShowPermissionError(true);
      }

      return (
        <>
          <ErrorMessage
            variant="warning"
            title="Access Denied"
            message="You don't have permission to access this page. Please contact your administrator."
            isOpen={showPermissionError}
            onClose={() => {
              setShowPermissionError(false);
              setShouldRedirect(true);
            }}
            autoCloseDuration={3000}
          />
          {shouldRedirect && <Navigate to="/dashboard" replace />}
        </>
      );
    }
  }

  // Authenticated and authorized
  return <>{children}</>;
};

export default ProtectedRoute;
