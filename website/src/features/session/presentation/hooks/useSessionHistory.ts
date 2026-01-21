/**
 * useSessionHistory Hook
 * Fetches and manages session history data
 */

import { useState, useEffect, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAppState } from '@/app/providers/app_state_provider';
import { productReceiveRepository } from '../../data/repositories/ProductReceiveRepositoryImpl';
import type { SessionHistoryEntry, SessionHistoryParams } from '../../domain/entities';

interface UseSessionHistoryOptions {
  sessionType?: 'counting' | 'receiving' | null;
  isActive?: boolean;
  startDate?: string | null;
  endDate?: string | null;
  limit?: number;
  search?: string | null; // Server-side search (session_name, product_name, SKU, product_id)
}

interface UseSessionHistoryReturn {
  // Data
  sessions: SessionHistoryEntry[];
  totalCount: number;
  hasMore: boolean;

  // Loading states
  isLoading: boolean;
  isLoadingMore: boolean;
  error: string | null;

  // Pagination
  page: number;
  loadMore: () => void;
  refresh: () => void;

  // Navigation
  handleSessionClick: (session: SessionHistoryEntry) => void;

  // Filters
  sessionTypeFilter: 'counting' | 'receiving' | null;
  setSessionTypeFilter: (type: 'counting' | 'receiving' | null) => void;

  // Search
  searchQuery: string;
  setSearchQuery: (query: string) => void;
}

const PAGE_SIZE = 20;

export const useSessionHistory = (options: UseSessionHistoryOptions = {}): UseSessionHistoryReturn => {
  const navigate = useNavigate();
  const { currentCompany, currentStore } = useAppState();

  // State
  const [sessions, setSessions] = useState<SessionHistoryEntry[]>([]);
  const [totalCount, setTotalCount] = useState(0);
  const [hasMore, setHasMore] = useState(false);
  const [isLoading, setIsLoading] = useState(true);
  const [isLoadingMore, setIsLoadingMore] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [page, setPage] = useState(0);
  const [sessionTypeFilter, setSessionTypeFilter] = useState<'counting' | 'receiving' | null>(
    options.sessionType ?? null
  );
  const [searchQuery, setSearchQuery] = useState(options.search ?? '');
  const [debouncedSearch, setDebouncedSearch] = useState(options.search ?? '');

  // Debounce search query (300ms delay)
  useEffect(() => {
    const timer = setTimeout(() => {
      setDebouncedSearch(searchQuery);
    }, 300);

    return () => clearTimeout(timer);
  }, [searchQuery]);

  // Fetch session history
  const fetchSessionHistory = useCallback(async (
    offset: number = 0,
    append: boolean = false
  ) => {
    if (!currentCompany?.company_id) {
      setError('No company selected');
      setIsLoading(false);
      return;
    }

    try {
      if (append) {
        setIsLoadingMore(true);
      } else {
        setIsLoading(true);
      }
      setError(null);

      // For history, we want closed sessions (is_active = false)
      const isActive = options.isActive;

      const params: SessionHistoryParams = {
        companyId: currentCompany.company_id,
        // Don't filter by store for now to get all sessions across stores
        // storeId: currentStore.store_id,
        sessionType: sessionTypeFilter,
        isActive, // undefined = all sessions, false = closed sessions only
        startDate: options.startDate || null,
        endDate: options.endDate || null,
        timezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
        limit: options.limit ?? PAGE_SIZE,
        offset,
        search: debouncedSearch || null, // Server-side search
      };

      const result = await productReceiveRepository.getSessionHistory(params);

      // Debug: Log session history data to check time fields
      console.log('📜 [useSessionHistory] Session History Data:', {
        totalCount: result.pagination.total,
        sessionsCount: result.sessions.length,
        firstSession: result.sessions[0] ? {
          sessionId: result.sessions[0].sessionId,
          sessionName: result.sessions[0].sessionName,
          createdAt: result.sessions[0].createdAt,
          completedAt: result.sessions[0].completedAt,
          durationMinutes: result.sessions[0].durationMinutes,
        } : null,
      });

      if (append) {
        setSessions((prev) => [...prev, ...result.sessions]);
      } else {
        setSessions(result.sessions);
      }
      setTotalCount(result.pagination.total);
      setHasMore(result.pagination.hasMore);
    } catch (err) {
      console.error('Failed to fetch session history:', err);
      setError(err instanceof Error ? err.message : 'Failed to load session history');
    } finally {
      setIsLoading(false);
      setIsLoadingMore(false);
    }
  }, [
    currentCompany?.company_id,
    // Removed currentStore dependency - getting all sessions across stores
    sessionTypeFilter,
    options.isActive,
    options.startDate,
    options.endDate,
    options.limit,
    debouncedSearch,
  ]);

  // Initial fetch and refetch when filters change
  useEffect(() => {
    setPage(0);
    fetchSessionHistory(0, false);
  }, [fetchSessionHistory]);

  // Load more handler
  const loadMore = useCallback(() => {
    if (isLoadingMore || !hasMore) return;
    const nextPage = page + 1;
    setPage(nextPage);
    fetchSessionHistory(nextPage * PAGE_SIZE, true);
  }, [isLoadingMore, hasMore, page, fetchSessionHistory]);

  // Refresh handler
  const refresh = useCallback(() => {
    setPage(0);
    fetchSessionHistory(0, false);
  }, [fetchSessionHistory]);

  // Navigate to session detail
  const handleSessionClick = useCallback((session: SessionHistoryEntry) => {
    // Debug: Log session data when clicking
    console.log('🔍 [handleSessionClick] Session Detail Data:', {
      sessionId: session.sessionId,
      sessionName: session.sessionName,
      createdAt: session.createdAt,
      completedAt: session.completedAt,
      durationMinutes: session.durationMinutes,
      isActive: session.isActive,
      isFinal: session.isFinal,
    });

    navigate(`/session/history/${session.sessionId}`, {
      state: { session },
    });
  }, [navigate]);

  return {
    sessions,
    totalCount,
    hasMore,
    isLoading,
    isLoadingMore,
    error,
    page,
    loadMore,
    refresh,
    handleSessionClick,
    sessionTypeFilter,
    setSessionTypeFilter,
    searchQuery,
    setSearchQuery,
  };
};

export default useSessionHistory;
