/**
 * useCountingSessionDetail Hook
 * Custom hook for counting session detail page
 * Uses inventory_get_session_items RPC
 */

import { useState, useEffect, useCallback } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { useAppState } from '@/app/providers/app_state_provider';
import { productReceiveDataSource } from '../../data/datasources/ProductReceiveDataSource';
import type { SessionItemDTO, SessionItemsSummaryDTO } from '../../data/datasources/ProductReceiveDataSource';

// Session info from session list
export interface CountingSessionInfo {
  sessionId: string;
  sessionName: string;
  storeName: string;
  isActive: boolean;
  isFinal: boolean;
  createdByName: string;
  createdAt: string;
}

// Presentation format for session item
export interface CountingSessionItem {
  productId: string;
  productName: string;
  totalQuantity: number;
  totalRejected: number;
  scannedBy: {
    userId: string;
    userName: string;
    quantity: number;
    quantityRejected: number;
  }[];
}

// Summary
export interface CountingSessionSummary {
  totalProducts: number;
  totalQuantity: number;
  totalRejected: number;
}

export const useCountingSessionDetail = () => {
  const { sessionId } = useParams<{ sessionId: string }>();
  const navigate = useNavigate();
  const { currentUser } = useAppState();
  const userId = currentUser?.user_id;

  // State
  const [items, setItems] = useState<CountingSessionItem[]>([]);
  const [summary, setSummary] = useState<CountingSessionSummary>({
    totalProducts: 0,
    totalQuantity: 0,
    totalRejected: 0,
  });
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Session info from localStorage (passed from list page)
  const [sessionInfo, setSessionInfo] = useState<CountingSessionInfo | null>(null);

  // Load session info from localStorage
  useEffect(() => {
    if (sessionId) {
      const storedInfo = localStorage.getItem(`counting_session_${sessionId}`);
      if (storedInfo) {
        try {
          setSessionInfo(JSON.parse(storedInfo));
        } catch {
          console.error('Failed to parse session info from localStorage');
        }
      }
    }
  }, [sessionId]);

  // Load session items
  const loadSessionItems = useCallback(async () => {
    if (!sessionId || !userId) return;

    setLoading(true);
    setError(null);

    try {
      const result = await productReceiveDataSource.getSessionItems(sessionId, userId);

      // Map DTO to presentation format
      const mappedItems: CountingSessionItem[] = result.items.map((item: SessionItemDTO) => ({
        productId: item.product_id,
        productName: item.product_name,
        totalQuantity: item.total_quantity,
        totalRejected: item.total_rejected,
        scannedBy: item.scanned_by.map((user) => ({
          userId: user.user_id,
          userName: user.user_name,
          quantity: user.quantity,
          quantityRejected: user.quantity_rejected,
        })),
      }));

      setItems(mappedItems);
      setSummary({
        totalProducts: result.summary.total_products,
        totalQuantity: result.summary.total_quantity,
        totalRejected: result.summary.total_rejected,
      });
    } catch (err) {
      console.error('📋 Load session items error:', err);
      setError(err instanceof Error ? err.message : 'Failed to load session items');
    } finally {
      setLoading(false);
    }
  }, [sessionId, userId]);

  // Load on mount
  useEffect(() => {
    loadSessionItems();
  }, [loadSessionItems]);

  // Navigate back to sessions page
  const handleBack = useCallback(() => {
    // Clear stored session info
    if (sessionId) {
      localStorage.removeItem(`counting_session_${sessionId}`);
    }
    navigate('/product/session');
  }, [navigate, sessionId]);

  // Refresh items
  const refreshItems = useCallback(() => {
    loadSessionItems();
  }, [loadSessionItems]);

  return {
    // State
    sessionId,
    sessionInfo,
    items,
    summary,
    loading,
    error,

    // Actions
    handleBack,
    refreshItems,
  };
};
