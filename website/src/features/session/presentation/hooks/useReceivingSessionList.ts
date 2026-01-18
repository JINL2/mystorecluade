/**
 * useReceivingSessionList Hook
 * Custom hook for receiving session list management
 * Uses inventory_get_session_list RPC with session_type = 'receiving'
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

// Shipment interface for modal selection
export interface Shipment {
  shipment_id: string;
  shipment_number: string;
  supplier_name: string;
  status: string;
}

// Session interface for receiving tab
export interface ReceivingSession {
  sessionId: string;
  sessionName: string;
  sessionType: string;
  storeId: string;
  storeName: string;
  shipmentId: string | null;
  shipmentNumber: string | null;
  isActive: boolean;
  isFinal: boolean;
  memberCount: number;
  createdBy: string;
  createdByName: string;
  completedAt: string | null;
  createdAt: string;
  // v2 fields
  status: SessionStatus;
  supplierId: string | null;
  supplierName: string | null;
}

// Session status type (from v2 RPC)
export type SessionStatus = 'pending' | 'process' | 'complete' | 'cancelled';

// Filter props interface
interface UseReceivingSessionListProps {
  fromDate?: string;
  toDate?: string;
  statusFilter?: SessionStatus;
  supplierId?: string;
}

export const useReceivingSessionList = (props?: UseReceivingSessionListProps) => {
  const { fromDate, toDate, statusFilter, supplierId } = props || {};
  const navigate = useNavigate();
  const { currentCompany, currentStore, currentUser } = useAppState();
  const companyId = currentCompany?.company_id;
  const storeId = currentStore?.store_id;
  const userId = currentUser?.user_id;
  // Stores are nested inside currentCompany
  const stores = currentCompany?.stores || [];

  // Sessions state
  const [sessions, setSessions] = useState<ReceivingSession[]>([]);
  const [sessionsLoading, setSessionsLoading] = useState(false);
  const [totalCount, setTotalCount] = useState(0);

  // Search state
  const [searchQuery, setSearchQuery] = useState<string>('');

  // Create session modal state
  const [showCreateModal, setShowCreateModal] = useState(false);
  const [selectedStoreId, setSelectedStoreId] = useState<string | null>(null);
  const [selectedShipmentId, setSelectedShipmentId] = useState<string | null>(null);
  const [sessionName, setSessionName] = useState('');
  const [isCreating, setIsCreating] = useState(false);
  const [createError, setCreateError] = useState<string | null>(null);

  // Shipments for modal selection
  const [shipments, setShipments] = useState<Shipment[]>([]);
  const [shipmentsLoading, setShipmentsLoading] = useState(false);

  // Load receiving sessions (using v2 RPC with server-side filtering)
  const loadReceivingSessions = useCallback(async () => {
    if (!companyId) return;

    setSessionsLoading(true);
    try {
      const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

      // v2 RPC supports server-side filtering for date, status, and supplier
      const result = await productReceiveRepository.getSessionListV2({
        companyId,
        sessionType: 'receiving',
        timezone: userTimezone,
        startDate: fromDate || undefined,
        endDate: toDate || undefined,
        status: statusFilter || undefined,
        supplierId: supplierId || undefined,
      });

      // Map domain entity to presentation format (Repository returns camelCase)
      const mappedSessions: ReceivingSession[] = result.sessions.map((s) => ({
        sessionId: s.sessionId,
        sessionName: s.sessionName || 'Receiving Session',
        sessionType: s.sessionType,
        storeId: s.storeId,
        storeName: s.storeName,
        shipmentId: s.shipmentId || null,
        shipmentNumber: s.shipmentNumber || null,
        isActive: s.isActive,
        isFinal: s.isFinal,
        memberCount: s.memberCount || 0,
        createdBy: s.createdBy,
        createdByName: s.createdByName,
        completedAt: s.completedAt || null,
        createdAt: s.createdAt,
        // v2 fields from server
        status: (s.status as SessionStatus) || 'pending',
        supplierId: s.supplierId || null,
        supplierName: s.supplierName || null,
      }));

      setSessions(mappedSessions);
      setTotalCount(result.totalCount);
    } catch (err) {
      console.error('📦 Load receiving sessions error:', err);
      setSessions([]);
      setTotalCount(0);
    } finally {
      setSessionsLoading(false);
    }
  }, [companyId, fromDate, toDate, statusFilter, supplierId]);

  // Load shipments for modal selection
  const loadShipments = useCallback(async () => {
    if (!companyId) return;

    setShipmentsLoading(true);
    try {
      const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

      const result = await productReceiveRepository.getShipmentList({
        companyId,
        timezone: userTimezone,
      });

      // Map and filter for modal (only non-completed shipments)
      // Repository returns domain entities with camelCase properties
      const mappedShipments: Shipment[] = result.shipments
        .filter((s) => s.status !== 'completed' && s.status !== 'cancelled')
        .map((s) => ({
          shipment_id: s.shipmentId,
          shipment_number: s.shipmentNumber,
          supplier_name: s.supplierName,
          status: s.status,
        }));

      setShipments(mappedShipments);
    } catch (err) {
      console.error('📦 Load shipments error:', err);
      setShipments([]);
    } finally {
      setShipmentsLoading(false);
    }
  }, [companyId]);

  // Load sessions on mount
  useEffect(() => {
    loadReceivingSessions();
  }, [loadReceivingSessions]);

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
        s.createdByName.toLowerCase().includes(query) ||
        (s.shipmentNumber && s.shipmentNumber.toLowerCase().includes(query))
    );
  }, [sessions, searchQuery]);

  // Refresh sessions
  const refreshSessions = useCallback(() => {
    loadReceivingSessions();
  }, [loadReceivingSessions]);

  // Navigate to receiving session page (only for non-closed sessions)
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
          `receiving_session_${sessionId}`,
          JSON.stringify({
            sessionId: session.sessionId,
            sessionName: session.sessionName,
            storeId: session.storeId,
            storeName: session.storeName,
            shipmentId: session.shipmentId,
            shipmentNumber: session.shipmentNumber,
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
          'receiving_active_sessions',
          JSON.stringify(otherActiveSessions)
        );
      }

      navigate(`/product/receive/session/${sessionId}`, {
        state: {
          sessionData: session ? {
            session_id: session.sessionId,
            session_name: session.sessionName,
            store_id: session.storeId,
            store_name: session.storeName,
            shipment_id: session.shipmentId,
            shipment_number: session.shipmentNumber,
            is_active: session.isActive,
            is_final: session.isFinal,
            created_by: session.createdBy,
            created_by_name: session.createdByName,
            created_at: session.createdAt,
          } : null,
          shipmentId: session?.shipmentId,
          isNewSession: false,
        }
      });
    },
    [navigate, sessions]
  );

  // Open create modal
  const handleOpenCreateModal = useCallback(() => {
    setShowCreateModal(true);
    setSelectedStoreId(storeId || null);
    setSelectedShipmentId(null);
    setSessionName('');
    setCreateError(null);
    // Load shipments when modal opens
    loadShipments();
  }, [storeId, loadShipments]);

  // Close create modal
  const handleCloseCreateModal = useCallback(() => {
    setShowCreateModal(false);
    setSelectedStoreId(null);
    setSelectedShipmentId(null);
    setSessionName('');
    setCreateError(null);
  }, []);

  // Create receiving session
  const handleCreateSession = useCallback(async () => {
    if (!companyId || !userId || !selectedStoreId) {
      setCreateError('Missing required information');
      return;
    }

    setIsCreating(true);
    setCreateError(null);

    try {
      const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
      const now = new Date();
      const localTime = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')} ${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}:${String(now.getSeconds()).padStart(2, '0')}`;

      const result = await productReceiveRepository.createSession({
        companyId,
        storeId: selectedStoreId,
        userId,
        sessionType: 'receiving',
        shipmentId: selectedShipmentId || undefined,
        sessionName: sessionName || undefined,
        time: localTime,
        timezone: userTimezone,
      });

      // Close modal and refresh list
      handleCloseCreateModal();
      loadReceivingSessions();

      // Navigate to the new session (Repository returns camelCase sessionId)
      if (result.sessionId) {
        const selectedStore = stores?.find((s: Store) => s.store_id === selectedStoreId);
        const selectedShipment = shipments.find((s) => s.shipment_id === selectedShipmentId);

        // Store session info for detail page
        localStorage.setItem(
          `receiving_session_${result.sessionId}`,
          JSON.stringify({
            sessionId: result.sessionId,
            sessionName: sessionName || 'Receiving Session',
            storeId: selectedStoreId,
            storeName: selectedStore?.store_name || '',
            shipmentId: selectedShipmentId,
            shipmentNumber: selectedShipment?.shipment_number || null,
            isActive: true,
            isFinal: false,
            createdBy: userId,
            createdByName: currentUser?.name || currentUser?.email || '',
            createdAt: localTime,
          })
        );

        navigate(`/product/receive/session/${result.sessionId}`, {
          state: {
            sessionData: {
              session_id: result.sessionId,
              session_name: sessionName || 'Receiving Session',
              store_id: selectedStoreId,
              store_name: selectedStore?.store_name || '',
              ...result,
            },
            shipmentId: selectedShipmentId,
            isNewSession: true,
          }
        });
      }
    } catch (err) {
      console.error('📦 Create receiving session error:', err);
      setCreateError(err instanceof Error ? err.message : 'Failed to create session');
    } finally {
      setIsCreating(false);
    }
  }, [
    companyId,
    userId,
    selectedStoreId,
    selectedShipmentId,
    sessionName,
    stores,
    shipments,
    currentUser,
    handleCloseCreateModal,
    loadReceivingSessions,
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
    shipments,
    shipmentsLoading,
    selectedStoreId,
    selectedShipmentId,
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
    setSelectedShipmentId,
    setSessionName,
    handleCreateSession,
  };
};
