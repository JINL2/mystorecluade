/**
 * ProtectedRoute Component
 * Route guard with authentication and authorization checks
 */

import React, { useState, useEffect } from 'react';
import { Navigate } from 'react-router-dom';
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
  const { authenticated, loading } = useAuth();
  const { permissions } = useAppState();
  const [showPermissionError, setShowPermissionError] = useState(false);
  const [shouldRedirect, setShouldRedirect] = useState(false);

  // Reset states when route changes
  useEffect(() => {
    setShowPermissionError(false);
    setShouldRedirect(false);
  }, [requiredFeatureId]);

  // Loading state
  if (loading) {
    return <LoadingAnimation fullscreen size="large" />;
  }

  // Not authenticated → redirect to login
  if (!authenticated) {
    return <Navigate to="/login" replace />;
  }

  // Check permission if requiredFeatureId is specified
  if (requiredFeatureId) {
    // Debug log - 현재 선택된 회사와 그 회사의 권한 확인
    const userData = JSON.parse(localStorage.getItem('user') || '{}');
    const selectedCompanyId = localStorage.getItem('companyChoosen');
    const selectedCompany = userData?.companies?.find(
      (c: any) => c.company_id === selectedCompanyId
    );
    const companyPermissions = selectedCompany?.role?.permissions || [];

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
