/**
 * useCountingSessionList Hook
 * Custom hook for counting session list management
 * Uses inventory_get_session_list RPC with session_type = 'counting'
 */

import { useState, useEffect, useCallback, useMemo } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAppState } from '@/app/providers/app_state_provider';
import { productReceiveRepository } from '../../data/repositories/ProductReceiveRepositoryImpl';

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
  // v2 field
  status: SessionStatus;
}

// Session status type (from v2 RPC)
export type SessionStatus = 'pending' | 'process' | 'complete' | 'cancelled';

// Filter props interface
interface UseCountingSessionListProps {
  fromDate?: string;
  toDate?: string;
  statusFilter?: SessionStatus;
}

export const useCountingSessionList = (props?: UseCountingSessionListProps) => {
  const { fromDate, toDate, statusFilter } = props || {};
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

  // Load counting sessions (using v2 RPC with server-side filtering)
  const loadCountingSessions = useCallback(async () => {
    if (!companyId) return;

    setSessionsLoading(true);
    try {
      const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

      // Use repository instead of direct dataSource call
      const result = await productReceiveRepository.getSessionListV2({
        companyId,
        sessionType: 'counting',
        timezone: userTimezone,
        startDate: fromDate || undefined,
        endDate: toDate || undefined,
        status: statusFilter || undefined,
      });

      // Map domain entity to presentation format
      const mappedSessions: CountingSession[] = result.sessions.map((s) => ({
        sessionId: s.sessionId,
        sessionName: s.sessionName || `Counting Session`,
        sessionType: s.sessionType,
        storeId: s.storeId,
        storeName: s.storeName,
        isActive: s.isActive,
        isFinal: s.isFinal,
        memberCount: s.memberCount || 0,
        createdBy: s.createdBy,
        createdByName: s.createdByName,
        completedAt: null,
        createdAt: s.createdAt,
        // v2 field from server - use type assertion since Session entity has it
        status: ((s as unknown as { status?: SessionStatus }).status) || 'pending',
      }));

      setSessions(mappedSessions);
      setTotalCount(result.totalCount);
    } catch (err) {
      console.error('Load counting sessions error:', err);
      setSessions([]);
      setTotalCount(0);
    } finally {
      setSessionsLoading(false);
    }
  }, [companyId, fromDate, toDate, statusFilter]);

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
        return;
      }

      // Store session info in localStorage for the detail page
      if (session) {
        localStorage.setItem(
          `counting_session_${sessionId}`,
          JSON.stringify({
            sessionId: session.sessionId,
            sessionName: session.sessionName,
            storeId: session.storeId,
            storeName: session.storeName,
            isActive: session.isActive,
            isFinal: session.isFinal,
            createdBy: session.createdBy,
            createdByName: session.createdByName,
            createdAt: session.createdAt,
          })
        );

        // Store other active sessions for Combine Session feature
        const otherActiveSessions = sessions.filter(
          (s) => s.sessionId !== sessionId && s.isActive
        );
        localStorage.setItem(
          'counting_active_sessions',
          JSON.stringify(otherActiveSessions)
        );
      }

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

      // Use repository instead of direct dataSource call
      const result = await productReceiveRepository.createSession({
        companyId,
        storeId: selectedStoreId,
        userId,
        sessionType: 'counting',
        shipmentId: '', // Not required for counting sessions
        sessionName: sessionName || undefined,
        time: localTime,
        timezone: userTimezone,
      });

      // Close modal and refresh list
      handleCloseCreateModal();
      loadCountingSessions();

      // Navigate to the new session
      if (result.sessionId) {
        // Store session info for detail page
        localStorage.setItem(
          `counting_session_${result.sessionId}`,
          JSON.stringify({
            sessionId: result.sessionId,
            sessionName: sessionName || 'Counting Session',
            storeId: selectedStoreId,
            storeName: stores?.find((s: Store) => s.store_id === selectedStoreId)?.store_name || '',
            isActive: true,
            isFinal: false,
            createdBy: userId,
            createdByName: currentUser?.name || currentUser?.email || '',
            createdAt: localTime,
          })
        );
        navigate(`/product/counting/session/${result.sessionId}`);
      }
    } catch (err) {
      console.error('Create counting session error:', err);
      setCreateError(err instanceof Error ? err.message : 'Failed to create session');
    } finally {
      setIsCreating(false);
    }
  }, [
    companyId,
    userId,
    selectedStoreId,
    sessionName,
    stores,
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
