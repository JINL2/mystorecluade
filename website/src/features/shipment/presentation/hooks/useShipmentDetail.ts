/**
 * useShipmentDetail Hook
 * Custom hook for shipment detail page management
 */

import { useState, useEffect, useCallback } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { useAppState } from '@/app/providers/app_state_provider';
import { supabaseService } from '@/core/services/supabase_service';
import type { Currency, ShipmentDetail } from '../pages/ShipmentDetailPage/ShipmentDetailPage.types';

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

export const useShipmentDetail = () => {
  const navigate = useNavigate();
  const { shipmentId } = useParams<{ shipmentId: string }>();

  // App state
  const { currentCompany } = useAppState();
  const companyId = currentCompany?.company_id;

  // Shipment detail state
  const [shipmentDetail, setShipmentDetail] = useState<ShipmentDetail | null>(null);
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

  // Load shipment detail
  useEffect(() => {
    const loadShipmentDetail = async () => {
      if (!companyId || !shipmentId) {
        setError('Missing required parameters');
        setIsLoading(false);
        return;
      }

      setIsLoading(true);
      setError(null);

      try {
        const supabase = supabaseService.getClient();
        const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

        console.log('📦 Calling inventory_get_shipment_detail with:', {
          p_shipment_id: shipmentId,
          p_company_id: companyId,
          p_timezone: userTimezone,
        });

        const { data, error: rpcError } = await supabase.rpc('inventory_get_shipment_detail', {
          p_shipment_id: shipmentId,
          p_company_id: companyId,
          p_timezone: userTimezone,
        });

        console.log('📦 inventory_get_shipment_detail response:', { data, rpcError });

        if (rpcError) {
          throw new Error(rpcError.message);
        }

        if (data?.success && data?.data) {
          setShipmentDetail(data.data);
        } else {
          throw new Error(data?.error || 'Failed to load shipment details');
        }
      } catch (err) {
        console.error('📦 Load shipment detail error:', err);
        setError(err instanceof Error ? err.message : 'Failed to load shipment details');
      } finally {
        setIsLoading(false);
      }
    };

    loadShipmentDetail();
  }, [companyId, shipmentId]);

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
    navigate('/product/shipment');
  }, [navigate]);

  return {
    // State
    shipmentDetail,
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
