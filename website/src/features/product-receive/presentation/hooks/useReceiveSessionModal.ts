/**
 * useReceiveSessionModal Hook
 * Handles session creation and joining logic for ProductReceivePage
 */

import { useState, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAppState } from '@/app/providers/app_state_provider';
import { productReceiveRepository } from '../../data/repositories/ProductReceiveRepositoryImpl';
import type { Session, Shipment, ShipmentDetail } from '../pages/ProductReceivePage/ProductReceivePage.types';

interface UseReceiveSessionModalProps {
  shipmentDetail: ShipmentDetail | null;
  shipments: Shipment[];
}

export const useReceiveSessionModal = ({ shipmentDetail, shipments }: UseReceiveSessionModalProps) => {
  const navigate = useNavigate();
  const { currentCompany, currentUser } = useAppState();
  const stores = currentCompany?.stores || [];

  // Session modal state
  const [showSessionModal, setShowSessionModal] = useState(false);
  const [sessionShipmentId, setSessionShipmentId] = useState<string | null>(null);

  // Create session modal state
  const [showCreateSessionModal, setShowCreateSessionModal] = useState(false);
  const [selectedStoreId, setSelectedStoreId] = useState<string | null>(null);
  const [sessionName, setSessionName] = useState<string>('Session1');
  const [isCreatingSession, setIsCreatingSession] = useState(false);
  const [createSessionError, setCreateSessionError] = useState<string | null>(null);

  // Join session modal state
  const [showJoinSessionModal, setShowJoinSessionModal] = useState(false);
  const [existingSessions, setExistingSessions] = useState<Session[]>([]);
  const [sessionsLoading, setSessionsLoading] = useState(false);
  const [sessionsError, setSessionsError] = useState<string | null>(null);
  const [selectedSessionId, setSelectedSessionId] = useState<string | null>(null);
  const [isJoiningSession, setIsJoiningSession] = useState(false);

  // Handle Start Receive button click
  const handleStartReceive = useCallback((shipmentId: string) => {
    setSessionShipmentId(shipmentId);
    setShowSessionModal(true);
  }, []);

  // Load existing active sessions for the shipment using Repository
  const loadExistingSessions = useCallback(async () => {
    if (!currentCompany || !sessionShipmentId) return;

    setSessionsLoading(true);
    setSessionsError(null);

    try {
      const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

      console.log('📦 Loading existing sessions for shipment:', sessionShipmentId);

      const result = await productReceiveRepository.getSessionList({
        companyId: currentCompany.company_id,
        shipmentId: sessionShipmentId,
        sessionType: 'receiving',
        isActive: true,
        timezone: userTimezone,
      });

      console.log('📦 getSessionList result:', result);

      // Map domain entity to presentation format
      const mappedSessions: Session[] = result.map(s => ({
        session_id: s.sessionId,
        session_name: s.sessionName || null,
        session_type: s.sessionType as 'receiving' | 'counting',
        store_id: s.storeId,
        store_name: s.storeName,
        shipment_id: s.shipmentId || null,
        shipment_number: s.shipmentNumber || null,
        is_active: s.isActive,
        is_final: s.isFinal,
        member_count: s.memberCount || 0,
        created_by: s.createdBy,
        created_by_name: s.createdByName,
        completed_at: null,
        created_at: s.createdAt,
      }));

      setExistingSessions(mappedSessions);
    } catch (err) {
      console.error('📦 Load sessions error:', err);
      setSessionsError(err instanceof Error ? err.message : 'Failed to load sessions');
      setExistingSessions([]);
    } finally {
      setSessionsLoading(false);
    }
  }, [currentCompany, sessionShipmentId]);

  // Handle session option selection
  const handleSessionSelect = useCallback(async (optionId: string) => {
    if (optionId === 'create_session') {
      setShowSessionModal(false);
      setShowCreateSessionModal(true);
      setSelectedStoreId(null);
      setSessionName('Session1');
      setCreateSessionError(null);
    } else if (optionId === 'join_session') {
      setShowSessionModal(false);
      setShowJoinSessionModal(true);
      setSelectedSessionId(null);
      setSessionsError(null);
      await loadExistingSessions();
    }
  }, [loadExistingSessions]);

  // Handle join session using Repository
  const handleJoinSession = useCallback(async () => {
    if (!selectedSessionId || !currentUser) {
      setSessionsError('Please select a session to join');
      return;
    }

    setIsJoiningSession(true);
    setSessionsError(null);

    try {
      const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
      const now = new Date();
      const localTime = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')} ${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}:${String(now.getSeconds()).padStart(2, '0')}`;

      console.log('📦 Joining session:', { selectedSessionId, localTime, userTimezone });

      const result = await productReceiveRepository.joinSession({
        sessionId: selectedSessionId,
        userId: currentUser.user_id,
        time: localTime,
        timezone: userTimezone,
      });

      console.log('📦 joinSession result:', result);

      const selectedSession = existingSessions.find(s => s.session_id === selectedSessionId);
      const shipmentData = shipmentDetail || shipments.find(s => s.shipment_id === sessionShipmentId);
      const shipmentIdForNav = sessionShipmentId;

      setShowJoinSessionModal(false);
      setSessionShipmentId(null);
      setSelectedSessionId(null);
      setExistingSessions([]);

      navigate(`/product/receive/session/${selectedSessionId}`, {
        state: {
          sessionData: {
            ...selectedSession,
            member_id: result.memberId,
            created_by: result.createdBy,
            created_by_name: result.createdByName,
          },
          shipmentId: shipmentIdForNav,
          shipmentData: shipmentData,
          isNewSession: false,
        }
      });
    } catch (err) {
      console.error('📦 Join session error:', err);
      setSessionsError(err instanceof Error ? err.message : 'Failed to join session');
    } finally {
      setIsJoiningSession(false);
    }
  }, [selectedSessionId, currentUser, existingSessions, shipmentDetail, shipments, sessionShipmentId, navigate]);

  // Handle create session using Repository
  const handleCreateSession = useCallback(async () => {
    if (!selectedStoreId || !sessionShipmentId || !currentCompany || !currentUser) {
      setCreateSessionError('Please select a store');
      return;
    }

    setIsCreatingSession(true);
    setCreateSessionError(null);

    try {
      const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
      const now = new Date();
      const localTime = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')} ${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}:${String(now.getSeconds()).padStart(2, '0')}`;

      console.log('📦 Creating session with local time:', { localTime, userTimezone, sessionName });

      const result = await productReceiveRepository.createSession({
        companyId: currentCompany.company_id,
        storeId: selectedStoreId,
        userId: currentUser.user_id,
        sessionType: 'receiving',
        shipmentId: sessionShipmentId,
        sessionName: sessionName.trim() || undefined,
        time: localTime,
        timezone: userTimezone,
      });

      console.log('📦 createSession result:', result);

      const sessionId = result.sessionId;
      console.log('Session created:', sessionId);

      const selectedStore = stores.find(s => s.store_id === selectedStoreId);
      const shipmentData = shipmentDetail || shipments.find(s => s.shipment_id === sessionShipmentId);

      setShowCreateSessionModal(false);
      const shipmentIdForNav = sessionShipmentId;
      const storeIdForNav = selectedStoreId;
      setSessionShipmentId(null);
      setSelectedStoreId(null);

      navigate(`/product/receive/session/${sessionId}`, {
        state: {
          sessionData: {
            session_id: sessionId,
            store_name: selectedStore?.store_name || '',
            store_id: storeIdForNav,
            ...result,
          },
          shipmentId: shipmentIdForNav,
          shipmentData: shipmentData,
          isNewSession: true,
        }
      });
    } catch (err) {
      console.error('📦 Create session error:', err);
      setCreateSessionError(err instanceof Error ? err.message : 'Failed to create session');
    } finally {
      setIsCreatingSession(false);
    }
  }, [selectedStoreId, sessionShipmentId, currentCompany, currentUser, stores, shipmentDetail, shipments, navigate]);

  // Close modals
  const handleCloseSessionModal = useCallback(() => {
    setShowSessionModal(false);
    setSessionShipmentId(null);
  }, []);

  const handleCloseCreateSessionModal = useCallback(() => {
    setShowCreateSessionModal(false);
    setSessionShipmentId(null);
    setSelectedStoreId(null);
    setSessionName('Session1');
    setCreateSessionError(null);
  }, []);

  const handleCloseJoinSessionModal = useCallback(() => {
    setShowJoinSessionModal(false);
    setSessionShipmentId(null);
    setSelectedSessionId(null);
    setExistingSessions([]);
    setSessionsError(null);
  }, []);

  return {
    // Stores
    stores,
    currentUser,

    // Session modal state
    showSessionModal,
    sessionShipmentId,

    // Create session modal state
    showCreateSessionModal,
    selectedStoreId,
    setSelectedStoreId,
    sessionName,
    setSessionName,
    isCreatingSession,
    createSessionError,

    // Join session modal state
    showJoinSessionModal,
    existingSessions,
    sessionsLoading,
    sessionsError,
    selectedSessionId,
    setSelectedSessionId,
    isJoiningSession,

    // Actions
    handleStartReceive,
    handleSessionSelect,
    handleJoinSession,
    handleCreateSession,
    handleCloseSessionModal,
    handleCloseCreateSessionModal,
    handleCloseJoinSessionModal,
  };
};
