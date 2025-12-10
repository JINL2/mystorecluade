/**
 * useReceiveSessionModal Hook
 * Handles session creation and joining logic for ProductReceivePage
 */

import { useState, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAppState } from '@/app/providers/app_state_provider';
import { supabaseService } from '@/core/services/supabase_service';
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

  // Load existing active sessions for the shipment
  const loadExistingSessions = useCallback(async () => {
    if (!currentCompany || !sessionShipmentId) return;

    setSessionsLoading(true);
    setSessionsError(null);

    try {
      const supabase = supabaseService.getClient();
      const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

      console.log('📦 Loading existing sessions for shipment:', sessionShipmentId);

      const { data, error } = await supabase.rpc('inventory_get_session_list', {
        p_company_id: currentCompany.company_id,
        p_shipment_id: sessionShipmentId,
        p_session_type: 'receiving',
        p_is_active: true,
        p_timezone: userTimezone,
      });

      console.log('📦 inventory_get_session_list response:', { data, error });

      if (error) {
        throw new Error(error.message);
      }

      if ((data as { success?: boolean; data?: Session[]; error?: string })?.success && (data as { data?: Session[] })?.data) {
        setExistingSessions((data as { data: Session[] }).data);
      } else {
        setSessionsError((data as { error?: string })?.error || 'Failed to load sessions');
        setExistingSessions([]);
      }
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
      setCreateSessionError(null);
    } else if (optionId === 'join_session') {
      setShowSessionModal(false);
      setShowJoinSessionModal(true);
      setSelectedSessionId(null);
      setSessionsError(null);
      await loadExistingSessions();
    }
  }, [loadExistingSessions]);

  // Handle join session
  const handleJoinSession = useCallback(async () => {
    if (!selectedSessionId || !currentUser) {
      setSessionsError('Please select a session to join');
      return;
    }

    setIsJoiningSession(true);
    setSessionsError(null);

    try {
      const supabase = supabaseService.getClient();
      const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
      const now = new Date();
      const localTime = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')} ${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}:${String(now.getSeconds()).padStart(2, '0')}`;

      console.log('📦 Joining session:', { selectedSessionId, localTime, userTimezone });

      const { data, error } = await supabase.rpc('inventory_join_session', {
        p_session_id: selectedSessionId,
        p_user_id: currentUser.user_id,
        p_time: localTime,
        p_timezone: userTimezone,
      });

      console.log('📦 inventory_join_session response:', { data, error });

      if (error) {
        throw new Error(error.message);
      }

      const typedData = data as { success?: boolean; data?: { member_id?: string; created_by?: string; created_by_name?: string }; error?: string; message?: string };

      if (typedData?.success) {
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
              member_id: typedData.data?.member_id,
              created_by: typedData.data?.created_by,
              created_by_name: typedData.data?.created_by_name,
            },
            shipmentId: shipmentIdForNav,
            shipmentData: shipmentData,
            isNewSession: false,
            joinMessage: typedData.message,
          }
        });
      } else {
        setSessionsError(typedData?.error || 'Failed to join session');
      }
    } catch (err) {
      console.error('📦 Join session error:', err);
      setSessionsError(err instanceof Error ? err.message : 'Failed to join session');
    } finally {
      setIsJoiningSession(false);
    }
  }, [selectedSessionId, currentUser, existingSessions, shipmentDetail, shipments, sessionShipmentId, navigate]);

  // Handle create session
  const handleCreateSession = useCallback(async () => {
    if (!selectedStoreId || !sessionShipmentId || !currentCompany || !currentUser) {
      setCreateSessionError('Please select a store');
      return;
    }

    setIsCreatingSession(true);
    setCreateSessionError(null);

    try {
      const supabase = supabaseService.getClient();
      const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
      const now = new Date();
      const localTime = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')} ${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}:${String(now.getSeconds()).padStart(2, '0')}`;

      console.log('📦 Creating session with local time:', { localTime, userTimezone });

      const { data, error } = await supabase.rpc('inventory_create_session', {
        p_company_id: currentCompany.company_id,
        p_store_id: selectedStoreId,
        p_user_id: currentUser.user_id,
        p_session_type: 'receiving',
        p_shipment_id: sessionShipmentId,
        p_time: localTime,
        p_timezone: userTimezone,
      });

      console.log('📦 inventory_create_session response:', { data, error });

      if (error) {
        throw new Error(error.message);
      }

      const typedData = data as { success?: boolean; data?: { session_id: string; [key: string]: unknown }; error?: string };

      if (typedData?.success && typedData?.data) {
        const sessionId = typedData.data.session_id;
        const sessionData = typedData.data;
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
              ...sessionData,
              store_name: selectedStore?.store_name || '',
              store_id: storeIdForNav,
            },
            shipmentId: shipmentIdForNav,
            shipmentData: shipmentData,
            isNewSession: true,
          }
        });
      } else {
        setCreateSessionError(typedData?.error || 'Failed to create session');
      }
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
