/**
 * Inventory Metadata Entities
 * Types for inventory dropdown data from get_inventory_metadata_v2 RPC
 */

export interface Category {
  category_id: string;
  category_name: string;
  description: string;
  is_active: boolean;
  product_count: number;
  can_have_subcategory: boolean;
}

export interface Brand {
  brand_id: string;
  brand_name: string;
  description: string;
  is_active: boolean;
  product_count: number;
}

export interface ProductType {
  value: string;
  label: string;
  description: string;
  product_count: number;
}

export interface Unit {
  value: string;
  label: string;
  symbol: string;
  product_count: number;
}

export interface Currency {
  code: string;
  name: string;
  symbol: string;
}

export interface StockStatusLevel {
  level: string;
  label: string;
  color: string;
  icon: string;
}

export interface ValidationRules {
  sku_pattern: string;
  barcode_pattern: string;
  max_stock_required: boolean;
  min_price_required: boolean;
}

export interface AllowCustomValues {
  units: boolean;
  brands: boolean;
  categories: boolean;
}

export interface StoreInfo {
  store_id: string | null;
  store_code: string | null;
  store_name: string | null;
}

/**
 * Attribute option for variant attributes (v2)
 */
export interface AttributeOption {
  option_id: string;
  option_value: string;
  sort_order: number;
  is_active: boolean;
}

/**
 * Attribute with options for multi-attribute variant support (v2)
 */
export interface Attribute {
  attribute_id: string;
  attribute_name: string;
  sort_order: number;
  is_active: boolean;
  option_count: number;
  options: AttributeOption[];
}

export interface Stats {
  total_categories: number;
  total_brands: number;
  total_products: number;
  active_products: number;
  inactive_products: number;
  // v2 fields
  total_attributes: number;
  total_options: number;
}

export interface InventoryMetadata {
  company_id: string;
  categories: Category[];
  brands: Brand[];
  product_types: ProductType[];
  units: Unit[];
  attributes: Attribute[];  // v2: Attributes with options for variant support
  currency: Currency;
  stock_status_levels: StockStatusLevel[];
  validation_rules: ValidationRules;
  allow_custom_values: AllowCustomValues;
  store_info: StoreInfo;
  stats: Stats;
  last_updated: string;
}

export interface InventoryMetadataResponse {
  success: boolean;
  data: InventoryMetadata;
}
