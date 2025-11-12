/**
 * ProductDataSource
 * Data source for product operations (order context)
 */

import { supabaseService } from '@/core/services/supabase_service';

export interface ProductDTO {
  product_id: string;
  product_name: string;
  sku?: string;
  barcode?: string;
  unit_of_measure?: string;
  pricing?: {
    selling_price: number;
  };
  total_stock_summary?: {
    total_quantity_on_hand: number;
  };
  status?: {
    is_active: boolean;
    is_deleted: boolean;
  };
}

export interface CompanyProductData {
  company: {
    company_name: string;
    currency: {
      code: string;
      symbol: string;
    };
  } | null;
  products: ProductDTO[];
  summary: any;
}

export class ProductDataSource {
  /**
   * Fetch products for a company using RPC
   */
  async getProductsByCompany(companyId: string): Promise<CompanyProductData> {
    const { data, error } = await supabaseService
      .getClient()
      .rpc('get_inventory_product_list_company', {
        p_company_id: companyId,
      });

    if (error) {
      console.error('Error fetching products:', error);
      throw new Error(error.message);
    }

    if (!data || !data.success) {
      throw new Error('Failed to fetch products');
    }

    return {
      company: data.data.company || null,
      products: data.data.products || [],
      summary: data.data.summary || null,
    };
  }
}
