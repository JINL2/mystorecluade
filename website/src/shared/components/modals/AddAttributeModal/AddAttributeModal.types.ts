/**
 * AddAttributeModal Component Types
 */

export interface AddAttributeModalProps {
  isOpen: boolean;
  onClose: () => void;
  companyId: string;
  onAttributeAdded?: () => void;
}

export interface AttributeOption {
  option_value: string;
  sort_order: number;
}

export interface AttributeFormData {
  attributeName: string;
  options: AttributeOption[];
}

export interface AttributeResponse {
  success: boolean;
  attribute_id?: string;
  attribute_name?: string;
  options_created?: number;
  options?: Array<{
    option_id: string;
    option_value: string;
    sort_order: number;
  }>;
  error?: string;
  message?: string;
}
