/**
 * useOrderDetail Hook
 * Custom hook for order detail page management
 */

import { useState, useEffect, useCallback } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { useAppState } from '@/app/providers/app_state_provider';
import { supabaseService } from '@/core/services/supabase_service';
import { useAuth } from '@/shared/hooks/useAuth';
import type { Currency, OrderDetail } from '../pages/OrderDetailPage/OrderDetailPage.types';

// Format date for display (yyyy/MM/dd)
export const formatDateDisplay = (dateStr: string): string => {
  if (!dateStr) return '';
  const date = new Date(dateStr);
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  return `${year}/${month}/${day}`;
};

// Format date with time
export const formatDateTime = (dateStr: string): string => {
  if (!dateStr) return '';
  const parts = dateStr.split(' ');
  if (parts.length >= 2) {
    const datePart = parts[0];
    const timePart = parts[1].substring(0, 5); // HH:MM
    return `${formatDateDisplay(datePart)} ${timePart}`;
  }
  return formatDateDisplay(dateStr);
};

export const useOrderDetail = () => {
  const navigate = useNavigate();
  const { orderId } = useParams<{ orderId: string }>();

  // App state
  const { currentCompany } = useAppState();
  const companyId = currentCompany?.company_id;
  const { user } = useAuth();

  // Order detail state
  const [orderDetail, setOrderDetail] = useState<OrderDetail | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Currency state
  const [currency, setCurrency] = useState<Currency>({ symbol: '₩', code: 'KRW' });

  // Cancel order modal state
  const [isCancelModalOpen, setIsCancelModalOpen] = useState(false);
  const [isCancelling, setIsCancelling] = useState(false);

  // Load base currency
  useEffect(() => {
    const loadBaseCurrency = async () => {
      if (!companyId) return;

      try {
        const supabase = supabaseService.getClient();
        const { data, error } = await supabase.rpc('get_base_currency', {
          p_company_id: companyId,
        });

        if (!error && data?.base_currency) {
          setCurrency({
            symbol: data.base_currency.symbol || '₩',
            code: data.base_currency.currency_code || 'KRW',
          });
        }
      } catch (err) {
        console.error('💰 get_base_currency error:', err);
      }
    };

    loadBaseCurrency();
  }, [companyId]);

  // Load order detail
  useEffect(() => {
    const loadOrderDetail = async () => {
      if (!companyId || !orderId) {
        setError('Missing required parameters');
        setIsLoading(false);
        return;
      }

      setIsLoading(true);
      setError(null);

      try {
        const supabase = supabaseService.getClient();
        const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

        console.log('📦 Calling inventory_get_order_detail with:', {
          p_order_id: orderId,
          p_company_id: companyId,
          p_timezone: userTimezone,
        });

        const { data, error: rpcError } = await supabase.rpc('inventory_get_order_detail', {
          p_order_id: orderId,
          p_company_id: companyId,
          p_timezone: userTimezone,
        });

        console.log('📦 inventory_get_order_detail response:', { data, rpcError });

        if (rpcError) {
          throw new Error(rpcError.message);
        }

        if (data?.success && data?.data) {
          setOrderDetail(data.data);
        } else {
          throw new Error(data?.error || 'Failed to load order details');
        }
      } catch (err) {
        console.error('📦 Load order detail error:', err);
        setError(err instanceof Error ? err.message : 'Failed to load order details');
      } finally {
        setIsLoading(false);
      }
    };

    loadOrderDetail();
  }, [companyId, orderId]);

  // Format price with currency
  const formatPrice = useCallback(
    (price: number) => {
      return `${currency.symbol}${price.toLocaleString()}`;
    },
    [currency.symbol]
  );

  // Get status badge class
  const getStatusBadgeClass = useCallback((status: string, styles: Record<string, string>) => {
    return `${styles.statusBadge} ${styles[status] || ''}`;
  }, []);

  // Handle back navigation
  const handleBack = useCallback(() => {
    navigate('/product/order');
  }, [navigate]);

  // Open cancel order modal
  const openCancelModal = useCallback(() => {
    setIsCancelModalOpen(true);
  }, []);

  // Close cancel order modal
  const closeCancelModal = useCallback(() => {
    setIsCancelModalOpen(false);
  }, []);

  // Handle cancel order
  const handleCancelOrder = useCallback(async () => {
    if (!orderId || !companyId || !user?.id) {
      console.error('❌ Missing required parameters for cancel order');
      return;
    }

    setIsCancelling(true);

    try {
      const supabase = supabaseService.getClient();
      const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

      console.log('🚫 Calling inventory_close_order with:', {
        p_order_id: orderId,
        p_user_id: user.id,
        p_company_id: companyId,
        p_timezone: userTimezone,
      });

      const { data, error: rpcError } = await supabase.rpc('inventory_close_order', {
        p_order_id: orderId,
        p_user_id: user.id,
        p_company_id: companyId,
        p_timezone: userTimezone,
      });

      console.log('🚫 inventory_close_order response:', { data, rpcError });

      if (rpcError) {
        throw new Error(rpcError.message);
      }

      if (data?.success) {
        // Close modal and navigate back to list
        setIsCancelModalOpen(false);
        navigate('/product/order');
      } else {
        throw new Error(data?.error || 'Failed to cancel order');
      }
    } catch (err) {
      console.error('🚫 Cancel order error:', err);
      alert(err instanceof Error ? err.message : 'Failed to cancel order');
    } finally {
      setIsCancelling(false);
    }
  }, [orderId, companyId, user?.id, navigate]);

  return {
    // State
    orderDetail,
    isLoading,
    error,
    currency,

    // Cancel order modal state
    isCancelModalOpen,
    isCancelling,

    // Utilities
    formatPrice,
    getStatusBadgeClass,
    formatDateTime,
    formatDateDisplay,

    // Navigation
    handleBack,

    // Cancel order actions
    openCancelModal,
    closeCancelModal,
    handleCancelOrder,
  };
};
