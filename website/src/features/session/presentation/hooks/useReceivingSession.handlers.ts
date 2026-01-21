/**
 * useReceivingSession Handlers
 * Action handlers extracted from useReceivingSession hook
 */

import type { NavigateFunction } from 'react-router-dom';
import type { ProductReceiveRepository } from '../../data/repositories/ProductReceiveRepository';
import type { ReceivingSessionStore, ActiveSession } from '../providers/states/receiving_session_state';
import { ReceiveValidator } from '../../domain/validators/ReceiveValidator';

interface HandlerDependencies {
  sessionId: string | undefined;
  currentUser: { user_id: string } | null;
  repository: ProductReceiveRepository;
  store: ReceivingSessionStore;
  navigate: NavigateFunction;
}

/**
 * Create save handler
 */
export const createSaveHandler = ({
  sessionId,
  currentUser,
  repository,
  store,
}: Omit<HandlerDependencies, 'navigate'>) => {
  return async () => {
    if (!sessionId || !currentUser?.user_id) {
      store.setSaveError('Session or user information missing');
      return;
    }

    // Check if session is active before attempting to save
    if (store.sessionInfo && !store.sessionInfo.isActive) {
      store.setSaveError('Session is not active. Cannot save items to a closed session.');
      return;
    }

    // Convert received entries to SaveItem format for validation
    const itemsToSave = store.receivedEntries.map(entry => ({
      productId: entry.productId,
      variantId: entry.variantId || null,
      quantity: entry.quantity,
      quantityRejected: 0,
    }));

    // Use Validator for validation
    const validationResult = ReceiveValidator.validateSaveItems(itemsToSave);
    if (!validationResult.isValid) {
      store.setSaveError(validationResult.errors.join(', '));
      return;
    }

    store.setIsSaving(true);
    store.setSaveError(null);
    store.setSaveSuccess(false);

    try {
      await repository.addSessionItems(sessionId, currentUser.user_id, itemsToSave);
      store.setSaveSuccess(true);
      store.clearReceivedEntries();
      setTimeout(() => store.setSaveSuccess(false), 3000);

      // Refresh session items after successful save
      try {
        const sessionItemsResult = await repository.getSessionItems(sessionId, currentUser.user_id);
        store.setSessionItems(sessionItemsResult.items);
        store.setSessionItemsSummary(sessionItemsResult.summary);
      } catch (refreshErr) {
        console.error('Failed to refresh session items:', refreshErr);
      }
    } catch (err) {
      console.error('Save error:', err);
      store.setSaveError(err instanceof Error ? err.message : 'Failed to save items');
    } finally {
      store.setIsSaving(false);
    }
  };
};

/**
 * Create submit confirm handler
 */
export const createSubmitConfirmHandler = ({
  sessionId,
  currentUser,
  repository,
  store,
}: Omit<HandlerDependencies, 'navigate'>) => {
  return async () => {
    store.setShowSubmitConfirmModal(false);

    if (!sessionId || !currentUser?.user_id) {
      store.setSubmitError('Session or user information missing');
      return;
    }

    store.setIsLoadingSessionItems(true);
    store.setSubmitError(null);

    try {
      const result = await repository.getSessionItems(sessionId, currentUser.user_id);

      store.setSessionItems(result.items);
      store.setSessionItemsSummary(result.summary);
      store.setEditableItems(result.items.map(item => ({
        productId: item.productId,
        variantId: item.variantId ?? null,
        productName: item.productName,
        quantity: item.totalQuantity,
        quantityRejected: item.totalRejected,
      })));
      store.setShowSubmitReviewModal(true);
    } catch (err) {
      console.error('Load session items error:', err);
      store.setSubmitError(err instanceof Error ? err.message : 'Failed to load session items');
    } finally {
      store.setIsLoadingSessionItems(false);
    }
  };
};

/**
 * Create combine session select handler
 */
export const createCombineSessionSelectHandler = ({
  sessionId,
  currentUser,
  repository,
  store,
}: Omit<HandlerDependencies, 'navigate'>) => {
  return async (selectedSession: ActiveSession) => {
    if (!sessionId || !currentUser?.user_id) {
      store.setComparisonError('Session or user information missing');
      return;
    }

    store.setSelectedCombineSession(selectedSession);
    store.setShowSessionSelectModal(false);
    store.setIsLoadingComparison(true);
    store.setComparisonError(null);

    try {
      const result = await repository.compareSessions({
        sessionIdA: sessionId,
        sessionIdB: selectedSession.sessionId,
        userId: currentUser.user_id,
      });

      store.setComparisonResult(result);
      store.setShowComparisonModal(true);
    } catch (err) {
      console.error('Comparison error:', err);
      store.setComparisonError(err instanceof Error ? err.message : 'Failed to compare sessions');
    } finally {
      store.setIsLoadingComparison(false);
    }
  };
};

/**
 * Create merge sessions handler
 */
export const createMergeSessionsHandler = ({
  sessionId,
  currentUser,
  repository,
  store,
  navigate,
}: HandlerDependencies) => {
  return async () => {
    if (!sessionId || !currentUser?.user_id || !store.selectedCombineSession) {
      store.setMergeError('Session or user information missing');
      return;
    }

    store.setIsMerging(true);
    store.setMergeError(null);

    try {
      await repository.mergeSessions({
        targetSessionId: sessionId,
        sourceSessionId: store.selectedCombineSession.sessionId,
        userId: currentUser.user_id,
      });

      // Remove merged session from localStorage
      const storedSessions = localStorage.getItem('receiving_active_sessions');
      if (storedSessions) {
        try {
          const sessions: ActiveSession[] = JSON.parse(storedSessions);
          const updatedSessions = sessions.filter(
            s => s.sessionId !== store.selectedCombineSession?.sessionId
          );
          localStorage.setItem('receiving_active_sessions', JSON.stringify(updatedSessions));
          store.setAvailableSessions(updatedSessions.filter(s => s.sessionId !== sessionId));
        } catch {
          console.error('Failed to update active sessions in localStorage');
        }
      }

      store.setMergeSuccess(true);
      store.resetCompareState();
      navigate(0); // Page refresh

      setTimeout(() => store.setMergeSuccess(false), 3000);
    } catch (err) {
      console.error('Merge error:', err);
      store.setMergeError(err instanceof Error ? err.message : 'Failed to merge sessions');
    } finally {
      store.setIsMerging(false);
    }
  };
};

/**
 * Create submit session handler
 */
export const createSubmitSessionHandler = ({
  sessionId,
  currentUser,
  repository,
  store,
  navigate,
}: HandlerDependencies) => {
  return async (isFinal: boolean) => {
    console.log('🚀 handleSubmitSession called with isFinal:', isFinal);

    if (!sessionId || !currentUser?.user_id) {
      store.setSubmitError('Session or user information missing');
      return;
    }

    // Convert editable items to SubmitItem format
    const itemsToSubmit = store.editableItems.map(item => ({
      productId: item.productId,
      variantId: item.variantId,
      quantity: item.quantity,
      quantityRejected: item.quantityRejected,
    }));

    console.log('📦 Items to submit:', itemsToSubmit);
    console.log('📋 Session ID:', sessionId);
    console.log('👤 User ID:', currentUser.user_id);
    console.log('✅ Is Final (Complete Receiving):', isFinal);

    // Use Validator for validation
    const validationResult = ReceiveValidator.validateSubmitItems(itemsToSubmit);
    if (!validationResult.isValid) {
      store.setSubmitError(validationResult.errors.join(', '));
      return;
    }

    store.setShowFinalChoiceModal(false);
    store.setIsSubmitting(true);
    store.setSubmitError(null);

    try {
      console.log('📤 Calling repository.submitSession with isFinal:', isFinal);
      const result = await repository.submitSession(
        sessionId,
        currentUser.user_id,
        itemsToSubmit,
        isFinal
      );
      console.log('📥 Submit result:', result);

      store.setSubmitSuccess(true);

      // Check for products that need display
      const displayItems = (result.stockChanges || [])
        .filter(item => item.needsDisplay)
        .map(item => ({
          productId: item.productId,
          variantId: item.variantId || null,
          sku: item.sku,
          productName: item.productName,
          variantName: item.variantName || null,
          displayName: item.displayName || item.productName,
          quantityReceived: item.quantityReceived,
        }));

      if (displayItems.length > 0) {
        store.setNeedsDisplayItems(displayItems);
        store.setSubmitResultData({
          receivingNumber: result.receivingNumber,
          itemsCount: result.itemsCount,
          totalQuantity: result.totalQuantity,
        });
        store.setShowNeedsDisplayModal(true);
        store.setIsSubmitting(false);
      } else {
        navigate('/product/session', {
          state: {
            submitSuccess: true,
            receivingNumber: result.receivingNumber,
            itemsCount: result.itemsCount,
            totalQuantity: result.totalQuantity,
            refreshData: true,
          }
        });
      }
    } catch (err) {
      console.error('Submit session error:', err);
      store.setSubmitError(err instanceof Error ? err.message : 'Failed to submit session');
      store.setShowFinalChoiceModal(true);
      store.setIsSubmitting(false);
    }
  };
};

/**
 * Create needs display close handler
 */
export const createNeedsDisplayCloseHandler = ({
  store,
  navigate,
}: Pick<HandlerDependencies, 'store' | 'navigate'>) => {
  return () => {
    store.setShowNeedsDisplayModal(false);
    store.setNeedsDisplayItems([]);

    navigate('/product/session', {
      state: {
        submitSuccess: true,
        receivingNumber: store.submitResultData?.receivingNumber,
        itemsCount: store.submitResultData?.itemsCount,
        totalQuantity: store.submitResultData?.totalQuantity,
        refreshData: true,
      }
    });
    store.setSubmitResultData(null);
  };
};
