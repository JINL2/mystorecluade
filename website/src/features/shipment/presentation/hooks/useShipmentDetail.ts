/**
 * useShipmentDetail Hook
 * Custom hook for shipment detail page management
 */

import { useState, useEffect, useCallback, useMemo } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { useAppState } from '@/app/providers/app_state_provider';
import { useAuth } from '@/shared/hooks/useAuth';
import { supabaseService } from '@/core/services/supabase_service';
import { getShipmentRepository } from '../../data/repositories/ShipmentRepositoryImpl';
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
  const repository = useMemo(() => getShipmentRepository(), []);

  // App state
  const { currentCompany } = useAppState();
  const companyId = currentCompany?.company_id;
  const { user } = useAuth();

  // Shipment detail state
  const [shipmentDetail, setShipmentDetail] = useState<ShipmentDetail | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Currency state
  const [currency, setCurrency] = useState<Currency>({ symbol: '₩', code: 'KRW' });

  // Close shipment modal state
  const [isCloseModalOpen, setIsCloseModalOpen] = useState(false);
  const [isClosing, setIsClosing] = useState(false);

  // Load base currency using Repository
  useEffect(() => {
    const loadBaseCurrency = async () => {
      if (!companyId) return;

      try {
        const result = await repository.getBaseCurrency(companyId);

        if (result.success && result.data) {
          setCurrency(result.data);
        }
      } catch (err) {
        console.error('💰 getBaseCurrency error:', err);
      }
    };

    loadBaseCurrency();
  }, [companyId, repository]);

  // Load shipment detail using Repository
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
        const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

        const result = await repository.getShipmentDetail({
          shipmentId,
          companyId,
          timezone: userTimezone,
        });

        if (result.success && result.data) {
          const detailData = result.data as ShipmentDetail;

          // Debug: Log raw items data
          console.log('📦 Raw items from RPC:', detailData.items);

          if (detailData.items) {
            detailData.items = detailData.items.map((item) => {
              console.log('📦 Item before mapping:', item);
              return {
                ...item,
                quantity_received: item.quantity_received ?? 0,
                quantity_accepted: item.quantity_accepted ?? 0,
                quantity_rejected: item.quantity_rejected ?? 0,
                quantity_remaining: item.quantity_remaining ?? item.quantity_shipped,
              };
            });
          }

          console.log('📦 Final shipment detail:', detailData);
          setShipmentDetail(detailData);
        } else {
          throw new Error(result.error || 'Failed to load shipment details');
        }
      } catch (err) {
        console.error('📦 Load shipment detail error:', err);
        setError(err instanceof Error ? err.message : 'Failed to load shipment details');
      } finally {
        setIsLoading(false);
      }
    };

    loadShipmentDetail();
  }, [companyId, shipmentId, repository]);

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

  // Open close shipment modal
  const openCloseModal = useCallback(() => {
    setIsCloseModalOpen(true);
  }, []);

  // Close shipment modal
  const closeCloseModal = useCallback(() => {
    setIsCloseModalOpen(false);
  }, []);

  // Handle close shipment
  const handleCloseShipment = useCallback(async () => {
    if (!shipmentId || !companyId || !user?.id) {
      console.error('❌ Missing required parameters for close shipment');
      return;
    }

    setIsClosing(true);

    try {
      const supabase = supabaseService.getClient();
      const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

      console.log('🚫 Calling inventory_close_shipment with:', {
        p_shipment_id: shipmentId,
        p_user_id: user.id,
        p_company_id: companyId,
        p_timezone: userTimezone,
      });

      const { data, error: rpcError } = await supabase.rpc('inventory_close_shipment', {
        p_shipment_id: shipmentId,
        p_user_id: user.id,
        p_company_id: companyId,
        p_timezone: userTimezone,
      });

      console.log('🚫 inventory_close_shipment response:', { data, rpcError });

      if (rpcError) {
        throw new Error(rpcError.message);
      }

      if (data?.success) {
        // Close modal and navigate back to list
        setIsCloseModalOpen(false);
        navigate('/product/shipment');
      } else {
        throw new Error(data?.error || 'Failed to close shipment');
      }
    } catch (err) {
      console.error('🚫 Close shipment error:', err);
      alert(err instanceof Error ? err.message : 'Failed to close shipment');
    } finally {
      setIsClosing(false);
    }
  }, [shipmentId, companyId, user?.id, navigate]);

  return {
    // State
    shipmentDetail,
    isLoading,
    error,
    currency,

    // Close shipment modal state
    isCloseModalOpen,
    isClosing,

    // Utilities
    formatPrice,
    getStatusBadgeClass,
    formatDateTime,
    formatDateDisplay,

    // Navigation
    handleBack,

    // Close shipment actions
    openCloseModal,
    closeCloseModal,
    handleCloseShipment,
  };
};
