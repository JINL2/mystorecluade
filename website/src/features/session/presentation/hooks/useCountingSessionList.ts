/**
 * useCountingSessionList Hook
 * Custom hook for counting session list management
 * Uses inventory_get_session_list RPC with session_type = 'counting'
 */

import { useState, useEffect, useCallback, useMemo } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAppState } from '@/app/providers/app_state_provider';
import { productReceiveDataSource } from '../../data/datasources/ProductReceiveDataSource';

// Session interface for counting tab
export interface CountingSession {
  sessionId: string;
  sessionName: string;
  sessionType: string;
  storeId: string;
  storeName: string;
  isActive: boolean;
  isFinal: boolean;
  memberCount: number;
  createdBy: string;
  createdByName: string;
  completedAt: string | null;
  createdAt: string;
}

export const useCountingSessionList = () => {
  const navigate = useNavigate();
  const { currentCompany, currentStore } = useAppState();
  const companyId = currentCompany?.company_id;
  const storeId = currentStore?.store_id;

  // Sessions state
  const [sessions, setSessions] = useState<CountingSession[]>([]);
  const [sessionsLoading, setSessionsLoading] = useState(false);
  const [totalCount, setTotalCount] = useState(0);

  // Search state
  const [searchQuery, setSearchQuery] = useState<string>('');

  // Load counting sessions
  const loadCountingSessions = useCallback(async () => {
    if (!companyId) return;

    setSessionsLoading(true);
    try {
      const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

      const result = await productReceiveDataSource.getSessionList({
        companyId,
        sessionType: 'counting',
        timezone: userTimezone,
      });

      // Map DTO to presentation format
      const mappedSessions: CountingSession[] = result.sessions.map((s) => ({
        sessionId: s.session_id,
        sessionName: s.session_name || `Counting Session`,
        sessionType: s.session_type,
        storeId: s.store_id,
        storeName: s.store_name,
        isActive: s.is_active,
        isFinal: s.is_final,
        memberCount: s.member_count || 0,
        createdBy: s.created_by,
        createdByName: s.created_by_name,
        completedAt: s.completed_at || null,
        createdAt: s.created_at,
      }));

      setSessions(mappedSessions);
      setTotalCount(result.totalCount);
    } catch (err) {
      console.error('📋 Load counting sessions error:', err);
      setSessions([]);
      setTotalCount(0);
    } finally {
      setSessionsLoading(false);
    }
  }, [companyId]);

  // Load sessions on mount
  useEffect(() => {
    loadCountingSessions();
  }, [loadCountingSessions]);

  // Handle search
  const handleSearchChange = useCallback((value: string) => {
    setSearchQuery(value);
  }, []);

  // Filter sessions by search query (client-side)
  const filteredSessions = useMemo(() => {
    if (!searchQuery.trim()) return sessions;

    const query = searchQuery.toLowerCase().trim();
    return sessions.filter(
      (s) =>
        s.sessionName.toLowerCase().includes(query) ||
        s.storeName.toLowerCase().includes(query) ||
        s.createdByName.toLowerCase().includes(query)
    );
  }, [sessions, searchQuery]);

  // Refresh sessions
  const refreshSessions = useCallback(() => {
    loadCountingSessions();
  }, [loadCountingSessions]);

  // Navigate to counting session page
  const handleSessionClick = useCallback(
    (sessionId: string) => {
      // TODO: Navigate to counting session page when implemented
      console.log('📋 Navigate to counting session:', sessionId);
      // navigate(`/product/counting/session/${sessionId}`);
    },
    [navigate]
  );

  return {
    // State
    sessions: filteredSessions,
    sessionsLoading,
    totalCount,
    searchQuery,

    // Actions
    handleSearchChange,
    handleSessionClick,
    refreshSessions,
  };
};
