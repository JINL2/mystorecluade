/**
 * useCountingSessionList Hook
 * Custom hook for counting session list management
 * Uses inventory_get_session_list RPC with session_type = 'counting'
 */

import { useState, useEffect, useCallback, useMemo } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAppState } from '@/app/providers/app_state_provider';
import { productReceiveDataSource } from '../../data/datasources/ProductReceiveDataSource';

// Store interface
export interface Store {
  store_id: string;
  store_name: string;
}

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
  const { currentCompany, currentStore, currentUser } = useAppState();
  const companyId = currentCompany?.company_id;
  const storeId = currentStore?.store_id;
  const userId = currentUser?.user_id;
  // Stores are nested inside currentCompany
  const stores = currentCompany?.stores || [];

  // Sessions state
  const [sessions, setSessions] = useState<CountingSession[]>([]);
  const [sessionsLoading, setSessionsLoading] = useState(false);
  const [totalCount, setTotalCount] = useState(0);

  // Search state
  const [searchQuery, setSearchQuery] = useState<string>('');

  // Create session modal state
  const [showCreateModal, setShowCreateModal] = useState(false);
  const [selectedStoreId, setSelectedStoreId] = useState<string | null>(null);
  const [sessionName, setSessionName] = useState('');
  const [isCreating, setIsCreating] = useState(false);
  const [createError, setCreateError] = useState<string | null>(null);

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

  // Navigate to counting session page (only for non-closed sessions)
  const handleSessionClick = useCallback(
    (sessionId: string) => {
      // Find the session to check if it's closed
      const session = sessions.find((s) => s.sessionId === sessionId);

      // Don't navigate if session is closed (not active and not final)
      if (session && !session.isActive && !session.isFinal) {
        console.log('📋 Session is closed, not navigating:', sessionId);
        return;
      }

      // Store session info in localStorage for the detail page
      if (session) {
        localStorage.setItem(
          `counting_session_${sessionId}`,
          JSON.stringify({
            sessionId: session.sessionId,
            sessionName: session.sessionName,
            storeName: session.storeName,
            isActive: session.isActive,
            isFinal: session.isFinal,
            createdByName: session.createdByName,
            createdAt: session.createdAt,
          })
        );
      }

      console.log('📋 Navigate to counting session:', sessionId);
      navigate(`/product/counting/session/${sessionId}`);
    },
    [navigate, sessions]
  );

  // Open create modal
  const handleOpenCreateModal = useCallback(() => {
    setShowCreateModal(true);
    setSelectedStoreId(storeId || null);
    setSessionName('');
    setCreateError(null);
  }, [storeId]);

  // Close create modal
  const handleCloseCreateModal = useCallback(() => {
    setShowCreateModal(false);
    setSelectedStoreId(null);
    setSessionName('');
    setCreateError(null);
  }, []);

  // Create counting session
  const handleCreateSession = useCallback(async () => {
    if (!companyId || !userId || !selectedStoreId) {
      setCreateError('Missing required information');
      return;
    }

    setIsCreating(true);
    setCreateError(null);

    try {
      const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
      const localTime = new Date().toISOString();

      console.log('📋 Creating counting session:', {
        companyId,
        storeId: selectedStoreId,
        userId,
        sessionType: 'counting',
        sessionName: sessionName || undefined,
      });

      const result = await productReceiveDataSource.createSession({
        companyId,
        storeId: selectedStoreId,
        userId,
        sessionType: 'counting',
        sessionName: sessionName || undefined,
        time: localTime,
        timezone: userTimezone,
      });

      console.log('📋 Counting session created:', result);

      // Close modal and refresh list
      handleCloseCreateModal();
      loadCountingSessions();

      // Navigate to the new session
      if (result.session_id) {
        // Store session info for detail page
        localStorage.setItem(
          `counting_session_${result.session_id}`,
          JSON.stringify({
            sessionId: result.session_id,
            sessionName: sessionName || 'Counting Session',
            storeName: stores?.find((s: Store) => s.store_id === selectedStoreId)?.store_name || '',
            isActive: true,
            isFinal: false,
            createdByName: currentUser?.name || currentUser?.email || '',
            createdAt: localTime,
          })
        );
        navigate(`/product/counting/session/${result.session_id}`);
      }
    } catch (err) {
      console.error('📋 Create counting session error:', err);
      setCreateError(err instanceof Error ? err.message : 'Failed to create session');
    } finally {
      setIsCreating(false);
    }
  }, [
    companyId,
    userId,
    selectedStoreId,
    sessionName,
    currentCompany,
    currentUser,
    handleCloseCreateModal,
    loadCountingSessions,
    navigate,
  ]);

  return {
    // State
    sessions: filteredSessions,
    sessionsLoading,
    totalCount,
    searchQuery,

    // Create modal state
    showCreateModal,
    stores: stores || [],
    selectedStoreId,
    sessionName,
    isCreating,
    createError,

    // Actions
    handleSearchChange,
    handleSessionClick,
    refreshSessions,

    // Create modal actions
    handleOpenCreateModal,
    handleCloseCreateModal,
    setSelectedStoreId,
    setSessionName,
    handleCreateSession,
  };
};
