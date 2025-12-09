/**
 * useOrderDetail Hook
 * Custom hook for order detail page management
 */

import { useState, useEffect, useCallback } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { useAppState } from '@/app/providers/app_state_provider';
import { supabaseService } from '@/core/services/supabase_service';
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

  // Order detail state
  const [orderDetail, setOrderDetail] = useState<OrderDetail | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Currency state
  const [currency, setCurrency] = useState<Currency>({ symbol: '₩', code: 'KRW' });

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

  return {
    // State
    orderDetail,
    isLoading,
    error,
    currency,

    // Utilities
    formatPrice,
    getStatusBadgeClass,
    formatDateTime,
    formatDateDisplay,

    // Navigation
    handleBack,
  };
};
