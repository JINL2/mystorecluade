/**
 * LeftFilter Component Types
 * Shared filter sidebar component for various pages
 */

export type FilterSectionType = 'sort' | 'multiselect' | 'radio' | 'toggle' | 'input' | 'custom';

export interface FilterOption {
  value: string;
  label: string;
  icon?: React.ReactNode;
  disabled?: boolean;
  description?: string;
}

export interface FilterSection {
  id: string;
  title: string;
  type: FilterSectionType;
  defaultExpanded?: boolean;
  showCount?: boolean;
  options?: FilterOption[];
  selectedValues?: Set<string> | string;
  placeholder?: string;
  emptyMessage?: string;
  onSelect?: (value: string) => void;
  onToggle?: (value: string) => void;
  onClear?: () => void;
  onInputChange?: (value: string) => void;
  customContent?: React.ReactNode;
}

export interface LeftFilterProps {
  sections: FilterSection[];
  width?: number;
  topOffset?: number;
  className?: string;
  onSectionExpandToggle?: (sectionId: string, isExpanded: boolean) => void;
}
