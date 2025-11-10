/**
 * AddBrandModal Component Types
 */

export interface AddBrandModalProps {
  isOpen: boolean;
  onClose: () => void;
  companyId: string;
  onBrandAdded?: (brand: BrandData) => void;
}

export interface BrandData {
  brand_id: string;
  brand_name: string;
  brand_code: string | null;
  company_id: string;
  created_at: string;
  updated_at: string;
}

export interface BrandFormData {
  brandName: string;
  brandCode: string;
}
