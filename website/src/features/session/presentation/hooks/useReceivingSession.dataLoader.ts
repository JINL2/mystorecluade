/**
 * useReceivingSession Data Loader
 * Session data loading logic extracted from useReceivingSession hook
 */

import type { ProductReceiveRepository } from '../../data/repositories/ProductReceiveRepository';
import type { ReceivingSessionStore } from '../providers/states/receiving_session_state';
import type { ActiveSession } from '../providers/states/receiving_session_state';
import type { ReceivingSessionLocationState } from '../pages/ReceivingSessionPage/ReceivingSessionPage.types';
import { toActiveSession } from './useReceivingSession.converters';

interface LoadSessionDataParams {
  sessionId: string;
  currentCompany: { company_id: string } | null;
  currentUser: { user_id: string } | null;
  locationState: ReceivingSessionLocationState | null;
  repository: ProductReceiveRepository;
  store: ReceivingSessionStore;
  setIsInitialized: (value: boolean) => void;
}

/**
 * Load session data from navigation state or API
 */
export const loadSessionData = async ({
  sessionId,
  currentCompany,
  currentUser,
  locationState,
  repository,
  store,
  setIsInitialized,
}: LoadSessionDataParams): Promise<void> => {
  store.setLoading(true);
  store.setError(null);

  try {
    // If we have data from navigation state, use it
    if (locationState?.sessionData) {
      const sessionData = locationState.sessionData;
      store.setSessionInfo({
        sessionId: sessionData.session_id || sessionId,
        sessionType: sessionData.session_type || 'receiving',
        storeId: sessionData.store_id || '',
        storeName: sessionData.store_name || '',
        shipmentId: locationState.shipmentId || sessionData.shipment_id || null,
        shipmentNumber: locationState.shipmentData?.shipment_number || sessionData.shipment_number || null,
        isActive: sessionData.is_active ?? true,
        isFinal: sessionData.is_final ?? false,
        createdBy: sessionData.created_by || '',
        createdByName: sessionData.created_by_name || '',
        createdAt: sessionData.created_at || new Date().toISOString(),
        memberCount: sessionData.member_count,
      });
    }

    // If we have shipment data from navigation state, use it
    if (locationState?.shipmentData) {
      const shipment = locationState.shipmentData;
      store.setShipmentData({
        shipmentId: shipment.shipment_id,
        shipmentNumber: shipment.shipment_number,
        supplierName: shipment.supplier_name,
        status: shipment.status,
        shippedDate: shipment.shipped_date,
        items: shipment.items?.map(item => ({
          itemId: item.item_id,
          productId: item.product_id,
          variantId: item.variant_id || null,
          productName: item.product_name,
          variantName: item.variant_name || null,
          displayName: item.display_name || item.product_name,
          hasVariants: item.has_variants || false,
          sku: item.sku,
          quantityShipped: item.quantity_shipped,
          quantityReceived: item.quantity_received,
          quantityAccepted: item.quantity_accepted,
          quantityRejected: item.quantity_rejected,
          quantityRemaining: item.quantity_remaining,
          unitCost: item.unit_cost,
        })) || [],
        receivingSummary: shipment.receiving_summary ? {
          totalShipped: shipment.receiving_summary.total_shipped,
          totalReceived: shipment.receiving_summary.total_received,
          totalAccepted: shipment.receiving_summary.total_accepted,
          totalRejected: shipment.receiving_summary.total_rejected,
          totalRemaining: shipment.receiving_summary.total_remaining,
          progressPercentage: shipment.receiving_summary.progress_percentage,
        } : undefined,
      });
    } else {
      // If no shipment data from navigation but shipmentId exists, fetch shipment detail
      const linkedShipmentId = locationState?.shipmentId || locationState?.sessionData?.shipment_id;
      if (linkedShipmentId && currentCompany) {
        try {
          const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
          const shipmentDetail = await repository.getShipmentDetail({
            shipmentId: linkedShipmentId,
            companyId: currentCompany.company_id,
            timezone: userTimezone,
          });

          store.setShipmentData({
            shipmentId: shipmentDetail.shipmentId,
            shipmentNumber: shipmentDetail.shipmentNumber,
            supplierName: shipmentDetail.supplierName,
            status: shipmentDetail.status,
            shippedDate: shipmentDetail.shippedDate,
            items: shipmentDetail.items?.map(item => ({
              itemId: item.itemId,
              productId: item.productId,
              variantId: item.variantId || null,
              productName: item.productName,
              variantName: item.variantName || null,
              displayName: item.displayName || item.productName,
              hasVariants: item.hasVariants || false,
              sku: item.sku,
              quantityShipped: item.quantityShipped,
              quantityReceived: item.quantityReceived,
              quantityAccepted: item.quantityAccepted,
              quantityRejected: item.quantityRejected,
              quantityRemaining: item.quantityRemaining,
              unitCost: item.unitCost,
            })) || [],
            receivingSummary: shipmentDetail.receivingSummary ? {
              totalShipped: shipmentDetail.receivingSummary.totalShipped,
              totalReceived: shipmentDetail.receivingSummary.totalReceived,
              totalAccepted: shipmentDetail.receivingSummary.totalAccepted,
              totalRejected: shipmentDetail.receivingSummary.totalRejected,
              totalRemaining: shipmentDetail.receivingSummary.totalRemaining,
              progressPercentage: shipmentDetail.receivingSummary.progressPercentage,
            } : undefined,
          });
        } catch (err) {
          console.error('Failed to load shipment detail:', err);
          // Don't fail the whole session load, just continue without shipment data
        }
      }
    }

    // If no navigation state, set default session info
    if (!locationState?.sessionData) {
      store.setSessionInfo({
        sessionId: sessionId,
        sessionType: 'receiving',
        storeId: '',
        storeName: 'Loading...',
        shipmentId: null,
        shipmentNumber: null,
        isActive: true,
        isFinal: false,
        createdBy: '',
        createdByName: '',
        createdAt: new Date().toISOString(),
      });
    }

    // Load available sessions for combine feature
    await loadAvailableSessions({
      sessionId,
      currentCompany,
      locationState,
      repository,
      store,
    });

    // Load session items (products already received in this session)
    if (currentUser?.user_id) {
      try {
        const sessionItemsResult = await repository.getSessionItems(sessionId, currentUser.user_id);
        store.setSessionItems(sessionItemsResult.items);
        store.setSessionItemsSummary(sessionItemsResult.summary);
      } catch (err) {
        console.error('Failed to load session items:', err);
        // Don't fail the session load, just continue without session items
      }
    }

    setIsInitialized(true);
  } catch (err) {
    console.error('Load session error:', err);
    store.setError(err instanceof Error ? err.message : 'Failed to load session');
  } finally {
    store.setLoading(false);
  }
};

interface LoadAvailableSessionsParams {
  sessionId: string;
  currentCompany: { company_id: string } | null;
  locationState: ReceivingSessionLocationState | null;
  repository: ProductReceiveRepository;
  store: ReceivingSessionStore;
}

/**
 * Load available sessions for combine feature
 */
const loadAvailableSessions = async ({
  sessionId,
  currentCompany,
  locationState,
  repository,
  store,
}: LoadAvailableSessionsParams): Promise<void> => {
  const storedSessions = localStorage.getItem('receiving_active_sessions');
  if (storedSessions) {
    try {
      const sessions: ActiveSession[] = JSON.parse(storedSessions);
      store.setAvailableSessions(sessions.filter(s => s.sessionId !== sessionId));
    } catch {
      console.error('Failed to parse active sessions from localStorage');
    }
  }

  // If no localStorage data and we have shipment_id, fetch from API
  const shipmentId = locationState?.shipmentId || locationState?.sessionData?.shipment_id;
  if ((!storedSessions || storedSessions === '[]') && shipmentId && currentCompany) {
    try {
      const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
      const sessionsResult = await repository.getSessionList({
        companyId: currentCompany.company_id,
        shipmentId: shipmentId,
        sessionType: 'receiving',
        isActive: true,
        timezone: userTimezone,
      });

      const otherSessions = sessionsResult
        .filter(s => s.sessionId !== sessionId && s.isActive)
        .map(toActiveSession);

      store.setAvailableSessions(otherSessions);
      localStorage.setItem('receiving_active_sessions', JSON.stringify(otherSessions));
    } catch (err) {
      console.error('Failed to load active sessions from API:', err);
    }
  }
};
