/**
 * PublicRoute Component
 * Route for public pages (e.g., Login)
 * Redirects to dashboard if already authenticated
 */

import React from 'react';
import { Navigate } from 'react-router-dom';
import { useAuth } from '@/shared/hooks/useAuth';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';

interface PublicRouteProps {
  children: React.ReactNode;
}

export const PublicRoute: React.FC<PublicRouteProps> = ({ children }) => {
  const { authenticated, loading } = useAuth();

  // Loading state
  if (loading) {
    return <LoadingAnimation fullscreen size="large" />;
  }

  // Already authenticated → redirect to dashboard
  if (authenticated) {
    return <Navigate to="/dashboard" replace />;
  }

  // Not authenticated → show public page
  return <>{children}</>;
};

export default PublicRoute;
