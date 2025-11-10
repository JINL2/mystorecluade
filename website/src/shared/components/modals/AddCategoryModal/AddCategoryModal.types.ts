/**
 * AddCategoryModal Component Types
 */

export interface AddCategoryModalProps {
  isOpen: boolean;
  onClose: () => void;
  companyId: string;
  categories: CategoryOption[];
  onCategoryAdded?: (category: CategoryData) => void;
}

export interface CategoryData {
  category_id: string;
  category_name: string;
  parent_category_id: string | null;
  company_id: string;
  description: string | null;
  created_at: string;
  updated_at: string;
}

export interface CategoryOption {
  category_id: string;
  category_name: string;
  description?: string | null;
  parent_category_id?: string | null;
}

export interface CategoryFormData {
  categoryName: string;
  parentCategoryId: string;
}
