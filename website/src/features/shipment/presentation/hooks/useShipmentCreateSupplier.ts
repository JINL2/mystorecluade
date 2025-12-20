/**
 * useShipmentCreateSupplier Hook
 * Handles supplier selection and management for shipment creation
 */

import { useState, useEffect, useCallback, useMemo } from 'react';
import { getShipmentRepository } from '../../data/repositories/ShipmentRepositoryImpl';
import type {
  Counterparty,
  OneTimeSupplier,
  SelectionMode,
} from '../pages/ShipmentCreatePage/ShipmentCreatePage.types';

export interface SupplierOption {
  value: string;
  label: string;
  description?: string;
  descriptionBgColor?: string;
  descriptionColor?: string;
}

interface UseShipmentCreateSupplierProps {
  companyId: string | undefined;
  suppliersFromState: Counterparty[] | undefined;
  onSelectionModeChange: (mode: SelectionMode) => void;
  onClearOrderSelection: () => void;
}

export const useShipmentCreateSupplier = ({
  companyId,
  suppliersFromState,
  onSelectionModeChange,
  onClearOrderSelection,
}: UseShipmentCreateSupplierProps) => {
  const repository = useMemo(() => getShipmentRepository(), []);

  // Suppliers state
  const [suppliers, setSuppliers] = useState<Counterparty[]>(suppliersFromState || []);
  const [suppliersLoading, setSuppliersLoading] = useState(false);
  const [selectedSupplier, setSelectedSupplier] = useState<string | null>(null);

  // Supplier type toggle - 'existing' or 'onetime'
  const [supplierType, setSupplierType] = useState<'existing' | 'onetime'>('existing');
  const [oneTimeSupplier, setOneTimeSupplier] = useState<OneTimeSupplier>({
    name: '',
    phone: '',
    email: '',
    address: '',
  });

  // Convert suppliers to options format with INTERNAL/SUPPLIER badges
  const supplierOptions: SupplierOption[] = suppliers.map((supplier) => {
    const isSupplier = supplier.type === 'Suppliers';
    const badges: string[] = [];
    if (supplier.is_internal) badges.push('INTERNAL');
    if (isSupplier) badges.push('SUPPLIER');

    return {
      value: supplier.counterparty_id,
      label: supplier.name,
      description: badges.length > 0 ? badges.join(' · ') : undefined,
      descriptionBgColor: badges.length > 0 ? 'rgba(107, 114, 128, 0.15)' : undefined,
      descriptionColor: badges.length > 0 ? 'rgb(107, 114, 128)' : undefined,
    };
  });

  // Load suppliers if not passed from ShipmentPage using Repository
  useEffect(() => {
    if (suppliersFromState && suppliersFromState.length > 0) {
      return;
    }

    const loadCounterparties = async () => {
      if (!companyId) return;

      setSuppliersLoading(true);
      try {
        const result = await repository.getCounterparties(companyId);

        if (result.success && result.data) {
          setSuppliers(result.data);
        }
      } catch (err) {
        console.error('🏢 getCounterparties error:', err);
      } finally {
        setSuppliersLoading(false);
      }
    };

    loadCounterparties();
  }, [companyId, suppliersFromState, repository]);

  // Handle supplier selection in Supplier section (not filter)
  const handleSupplierSectionChange = useCallback((supplierId: string | null) => {
    setSelectedSupplier(supplierId);

    if (supplierId) {
      onSelectionModeChange('supplier');
      onClearOrderSelection();
    } else {
      onSelectionModeChange(null);
    }
  }, [onSelectionModeChange, onClearOrderSelection]);

  // Handle one-time supplier field change
  const handleOneTimeSupplierChange = useCallback(
    (field: keyof OneTimeSupplier, value: string) => {
      const newSupplier = { ...oneTimeSupplier, [field]: value };
      setOneTimeSupplier(newSupplier);

      const allFieldsEmpty =
        !newSupplier.name.trim() &&
        !newSupplier.phone.trim() &&
        !newSupplier.email.trim() &&
        !newSupplier.address.trim();

      if (allFieldsEmpty) {
        onSelectionModeChange(null);
      } else {
        onSelectionModeChange('supplier');
        onClearOrderSelection();
      }
    },
    [oneTimeSupplier, onSelectionModeChange, onClearOrderSelection]
  );

  // Handle clear supplier selection
  const handleClearSupplierSelection = useCallback(() => {
    setSelectedSupplier(null);
    setOneTimeSupplier({ name: '', phone: '', email: '', address: '' });
    onSelectionModeChange(null);
  }, [onSelectionModeChange]);

  // Handle supplier type toggle
  const handleSupplierTypeChange = useCallback((type: 'existing' | 'onetime') => {
    setSupplierType(type);
    if (type === 'existing') {
      setOneTimeSupplier({ name: '', phone: '', email: '', address: '' });
    } else {
      setSelectedSupplier(null);
      onSelectionModeChange(null);
    }
  }, [onSelectionModeChange]);

  return {
    suppliers,
    suppliersLoading,
    supplierOptions,
    selectedSupplier,
    setSelectedSupplier,
    supplierType,
    oneTimeSupplier,
    handleSupplierTypeChange,
    handleSupplierSectionChange,
    handleClearSupplierSelection,
    handleOneTimeSupplierChange,
  };
};
