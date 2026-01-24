// Re-export product search provider from purchase_order feature
// for use in multiple features (shipment, etc.)
export '../../features/purchase_order/presentation/providers/po_providers.dart'
    show
        InventoryProductItem,
        ProductSearch,
        ProductSearchState,
        productSearchProvider;
