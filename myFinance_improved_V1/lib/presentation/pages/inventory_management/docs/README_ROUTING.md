# Inventory Management Routing Configuration

## Add to app_router.dart

To integrate the inventory management system with your app's routing, add the following configuration to your `app_router.dart` file:

### 1. Import Statement
Add this import at the top of the file with other page imports:
```dart
import '../pages/inventory_management/inventory_management.dart';
```

### 2. Route Configuration
Add this route configuration inside the main GoRoute's routes array (around line 411-590):

```dart
// Inventory Management
GoRoute(
  path: 'inventoryManagement',
  builder: (context, state) => const InventoryManagementPage(),
  routes: [
    GoRoute(
      path: 'addProduct',
      builder: (context, state) => const AddEditProductPage(),
    ),
    GoRoute(
      path: 'editProduct/:productId',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final product = extra?['product'] as Product?;
        return AddEditProductPage(product: product);
      },
    ),
    GoRoute(
      path: 'product/:productId',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final product = extra?['product'] as Product;
        return ProductDetailPage(product: product);
      },
    ),
    GoRoute(
      path: 'count',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final products = extra?['products'] as List<Product>?;
        return InventoryCountPage(products: products);
      },
    ),
  ],
),
```

### 3. Navigation Usage

The inventory management system can be accessed with these routes:

- **Main Page**: `/inventoryManagement`
- **Add Product**: `/inventoryManagement/addProduct`
- **Edit Product**: `/inventoryManagement/editProduct/{productId}`
- **Product Detail**: `/inventoryManagement/product/{productId}`
- **Inventory Count**: `/inventoryManagement/count`

### 4. Navigation Examples

```dart
// Navigate to inventory management
context.safePush('/inventoryManagement');

// Navigate to add product
context.safePush('/inventoryManagement/addProduct');

// Navigate to product detail with data
context.safePush(
  '/inventoryManagement/product/${product.id}',
  extra: {'product': product},
);

// Navigate to inventory count with selected products
context.safePush(
  '/inventoryManagement/count',
  extra: {'products': selectedProducts},
);
```

### 5. Add to Quick Access (Optional)

If you want to add inventory management to the quick access section on the homepage, you'll need to add an entry in your database or configuration with:

```json
{
  "route": "inventoryManagement",
  "featureName": "Inventory Count",
  "icon": "icon_url_here",
  "description": "Manage product inventory and stock counts"
}
```

## Features

The inventory management system includes:

1. **Product Management**
   - Add/Edit/Delete products
   - SKU and barcode management
   - Category and brand classification
   - Pricing and margin calculations

2. **Inventory Tracking**
   - Real-time stock levels
   - Stock status indicators
   - Location tracking
   - Reorder point management

3. **Counting System**
   - Voucher-based counting sessions
   - Discrepancy detection
   - Batch counting with notes
   - Count history tracking

4. **Search & Filters**
   - Multi-field search
   - Stock status filtering
   - Category and brand filters
   - Price range filtering

5. **Analytics**
   - Total inventory value
   - Stock health metrics
   - Low stock alerts
   - Turnover rate calculations