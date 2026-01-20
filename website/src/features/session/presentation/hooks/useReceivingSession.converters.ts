/**
 * useReceivingSession Converters
 * Helper functions to convert between domain entities and presentation formats
 */

import type {
  SearchProduct,
  SessionItem,
  SessionItemsSummary,
  Session,
} from '../../domain/entities';
import type { EditableItem, ActiveSession } from '../providers/states/receiving_session_state';
import type {
  SearchProductPresentation,
  SessionItemPresentation,
  SessionItemsSummaryPresentation,
  EditableItemPresentation,
} from './useReceivingSession.types';

/**
 * Convert domain SearchProduct to presentation format
 */
export const toPresentationSearchProduct = (p: SearchProduct): SearchProductPresentation => ({
  // 제품 정보
  product_id: p.productId,
  product_name: p.productName,
  product_sku: p.productSku,
  product_barcode: p.productBarcode,
  product_type: p.productType,
  brand_id: p.brandId,
  brand_name: p.brandName,
  category_id: p.categoryId,
  category_name: p.categoryName,
  unit: p.unit,
  image_urls: p.imageUrls,

  // 변형 정보
  variant_id: p.variantId,
  variant_name: p.variantName,
  variant_sku: p.variantSku,
  variant_barcode: p.variantBarcode,

  // 표시용
  display_name: p.displayName,
  display_sku: p.displaySku,
  display_barcode: p.displayBarcode,

  // 재고
  stock: {
    quantity_on_hand: p.stock.quantityOnHand,
    quantity_available: p.stock.quantityAvailable,
    quantity_reserved: p.stock.quantityReserved,
  },

  // 가격
  price: {
    cost: p.price.cost,
    selling: p.price.selling,
    source: p.price.source,
  },

  // 상태
  status: {
    stock_level: p.status.stockLevel,
    is_active: p.status.isActive,
  },

  // 메타
  has_variants: p.hasVariants,
  created_at: p.createdAt,
});

/**
 * Convert domain SessionItem to presentation format
 */
export const toPresentationSessionItem = (item: SessionItem): SessionItemPresentation => ({
  product_id: item.productId,
  product_name: item.productName,
  total_quantity: item.totalQuantity,
  total_rejected: item.totalRejected,
  scanned_by: item.scannedBy.map(user => ({
    user_id: user.userId,
    user_name: user.userName,
    quantity: user.quantity,
    quantity_rejected: user.quantityRejected,
  })),
});

/**
 * Convert domain SessionItemsSummary to presentation format
 */
export const toPresentationSummary = (summary: SessionItemsSummary): SessionItemsSummaryPresentation => ({
  total_products: summary.totalProducts,
  total_quantity: summary.totalQuantity,
  total_rejected: summary.totalRejected,
});

/**
 * Convert EditableItem to presentation format
 */
export const toPresentationEditableItem = (item: EditableItem): EditableItemPresentation => ({
  product_id: item.productId,
  product_name: item.productName,
  quantity: item.quantity,
  quantity_rejected: item.quantityRejected,
});

/**
 * Convert Session to ActiveSession
 */
export const toActiveSession = (s: Session): ActiveSession => ({
  sessionId: s.sessionId,
  sessionName: s.sessionName || '',
  sessionType: s.sessionType,
  storeId: s.storeId,
  storeName: s.storeName,
  isActive: s.isActive,
  isFinal: s.isFinal,
  memberCount: s.memberCount || 0,
  createdBy: s.createdBy,
  createdByName: s.createdByName,
  completedAt: null,
  createdAt: s.createdAt,
});

/**
 * Normalize presentation format to domain SearchProduct
 */
export const toDomainSearchProduct = (product: SearchProductPresentation): SearchProduct => ({
  // 제품 정보
  productId: product.product_id,
  productName: product.product_name,
  productSku: product.product_sku,
  productBarcode: product.product_barcode,
  productType: product.product_type,
  brandId: product.brand_id,
  brandName: product.brand_name,
  categoryId: product.category_id,
  categoryName: product.category_name,
  unit: product.unit,
  imageUrls: product.image_urls,

  // 변형 정보
  variantId: product.variant_id,
  variantName: product.variant_name,
  variantSku: product.variant_sku,
  variantBarcode: product.variant_barcode,

  // 표시용
  displayName: product.display_name,
  displaySku: product.display_sku,
  displayBarcode: product.display_barcode,

  // 재고
  stock: {
    quantityOnHand: product.stock.quantity_on_hand,
    quantityAvailable: product.stock.quantity_available,
    quantityReserved: product.stock.quantity_reserved,
  },

  // 가격
  price: {
    cost: product.price.cost,
    selling: product.price.selling,
    source: product.price.source,
  },

  // 상태
  status: {
    stockLevel: product.status.stock_level,
    isActive: product.status.is_active,
  },

  // 메타
  hasVariants: product.has_variants,
  createdAt: product.created_at,
});
