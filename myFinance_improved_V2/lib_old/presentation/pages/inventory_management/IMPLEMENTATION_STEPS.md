# 🔨 Inventory Management - Step-by-Step Implementation Guide

## 📌 Quick Start Checklist

```bash
# Branch creation
git checkout -b feature/inventory-optimization

# Backup current state
cp -r inventory_management inventory_management_backup
```

---

## 📝 STEP 1: Create Business Layer Structure

### 1.1 Create Folders
```bash
cd lib/presentation/pages/inventory_management
mkdir -p business/use_cases
mkdir -p business/validators
```

### 1.2 Create `inventory_coordinator.dart`
```dart
// business/inventory_coordinator.dart
import 'package:flutter/material.dart';
import '../data/services/product_service.dart';
import '../data/services/stock_service.dart';

/// Copy pattern from cash_ending_coordinator.dart
class InventoryCoordinator {
  
  /// Load products with filters
  static Future<void> loadProducts({
    required BuildContext context,
    required String companyId,
    required String storeId,
    required Map<String, dynamic> filters,
    required Function(List<Product>, bool) onProductsLoaded,
  }) async {
    try {
      onProductsLoaded([], true); // Set loading
      final service = ProductService();
      final products = await service.getProducts(
        companyId: companyId,
        storeId: storeId,
        filters: filters,
      );
      onProductsLoaded(products, false);
    } catch (e) {
      onProductsLoaded([], false);
    }
  }
  
  /// Save product (add/edit)
  static Future<void> saveProduct({
    required Product product,
    required Function(bool, {String? errorMessage}) onComplete,
  }) async {
    // Implementation here
  }
}
```

### 1.3 Create `widget_factory.dart`
```dart
// business/widget_factory.dart
import 'package:flutter/material.dart';
import '../presentation/widgets/displays/product_card.dart';

class InventoryWidgetFactory {
  /// Create product card based on view mode
  static Widget createProductDisplay({
    required Product product,
    required ViewMode viewMode,
    required VoidCallback onTap,
  }) {
    switch (viewMode) {
      case ViewMode.grid:
        return ProductCard(product: product, onTap: onTap);
      case ViewMode.list:
        return ProductListTile(product: product, onTap: onTap);
    }
  }
}
```

---

## 📝 STEP 2: Reorganize Presentation Widgets

### 2.1 Create Widget Subcategories
```bash
cd presentation/widgets
mkdir -p common tabs forms displays sheets dialogs
```

### 2.2 Move Existing Widgets
```bash
# Move to appropriate folders
mv product_card.dart displays/
mv stock_movement_card.dart displays/
mv filter_bottom_sheet.dart sheets/
mv barcode_scanner_sheet.dart sheets/
mv inventory_stats_card.dart displays/
```

### 2.3 Create Common Widgets

#### `common/product_selector.dart`
```dart
// Based on cash_ending store_selector pattern
import 'package:flutter/material.dart';
import '../../../../../../widgets/toss/toss_dropdown.dart';

class ProductSelector extends StatelessWidget {
  final String? selectedProductId;
  final List<Product> products;
  final Function(Product?) onChanged;
  
  const ProductSelector({
    Key? key,
    this.selectedProductId,
    required this.products,
    required this.onChanged,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Copy pattern from store_selector.dart
    return TossDropdown<Product>(
      value: products.firstWhere(
        (p) => p.id == selectedProductId,
        orElse: () => null,
      ),
      items: products,
      itemBuilder: (product) => Text(product.name),
      onChanged: onChanged,
      hint: 'Select Product',
    );
  }
}
```

#### `common/stock_indicator.dart`
```dart
// New component for visual stock levels
class StockIndicator extends StatelessWidget {
  final int currentStock;
  final int reorderPoint;
  final StockStatus status;
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          _getStockIcon(),
          color: _getStockColor(),
          size: 16,
        ),
        SizedBox(width: 4),
        Text(
          '$currentStock units',
          style: TextStyle(
            color: _getStockColor(),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
```

---

## 📝 STEP 3: Create Tab Structure

### 3.1 Create Tab Files
```bash
cd presentation/widgets/tabs
touch products_tab.dart sales_tab.dart purchases_tab.dart analytics_tab.dart
```

### 3.2 Extract Tab Content from Main Page

#### `tabs/products_tab.dart`
```dart
import 'package:flutter/material.dart';
import '../common/product_selector.dart';
import '../displays/product_card.dart';

class ProductsTab extends StatefulWidget {
  final String? selectedStoreId;
  final List<Product> products;
  final Function() onAddProduct;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search and filters (from main page)
        _buildSearchFilterSection(),
        
        // Product list
        Expanded(
          child: _buildProductList(),
        ),
      ],
    );
  }
  
  Widget _buildProductList() {
    // Move product list logic here from main page
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductCard(
          product: products[index],
          onTap: () => _navigateToDetail(products[index]),
        );
      },
    );
  }
}
```

---

## 📝 STEP 4: Update Main Page

### 4.1 Clean Up Main Page
```dart
// inventory_management_page.dart
import 'business/inventory_coordinator.dart';
import 'presentation/widgets/tabs/products_tab.dart';
import 'presentation/widgets/tabs/sales_tab.dart';
// ... other imports

class InventoryManagementPage extends ConsumerStatefulWidget {
  // Remove duplicate logic, keep only coordination
}

class _InventoryManagementPageState extends ConsumerState<InventoryManagementPage>
    with TickerProviderStateMixin {
  
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadInitialData();
  }
  
  void _loadInitialData() {
    // Use coordinator instead of direct service calls
    InventoryCoordinator.loadProducts(
      context: context,
      companyId: ref.read(appStateProvider).companyId,
      storeId: ref.read(appStateProvider).storeId,
      filters: {},
      onProductsLoaded: (products, isLoading) {
        setState(() {
          _products = products;
          _isLoading = isLoading;
        });
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return TossScaffold(  // Use common scaffold
      appBar: TossAppBar(   // Use common app bar
        title: Text('Inventory Management'),
        bottom: TossTabBar( // Use Toss tab bar
          controller: _tabController,
          tabs: [
            Tab(text: 'Products'),
            Tab(text: 'Sales'),
            Tab(text: 'Purchases'),
            Tab(text: 'Analytics'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ProductsTab(
            products: _products,
            selectedStoreId: selectedStoreId,
            onAddProduct: _handleAddProduct,
          ),
          SalesTab(),
          PurchasesTab(),
          AnalyticsTab(),
        ],
      ),
    );
  }
}
```

### 4.2 Delete Old Versions
```bash
# Remove v2 and backup files
rm inventory_management_page_v2.dart
rm products/add_product_page.corrupted
rm products/add_product_page.dart.backup
```

---

## 📝 STEP 5: Implement Service Layer

### 5.1 Create Service Files
```bash
cd data/services
touch product_service.dart stock_service.dart sales_service.dart
```

### 5.2 Split Inventory Service
```dart
// data/services/product_service.dart
class ProductService {
  // Extract product-related methods from inventory_service
  Future<List<Product>> getProducts({
    required String companyId,
    required String storeId,
    Map<String, dynamic>? filters,
  }) async {
    // Move implementation from inventory_service
  }
  
  Future<bool> saveProduct(Product product) async {
    // Move implementation
  }
}

// data/services/stock_service.dart  
class StockService {
  // Extract stock-related methods
  Future<bool> adjustStock({
    required String productId,
    required int adjustment,
    required String reason,
  }) async {
    // Move implementation
  }
}
```

---

## 📝 STEP 6: Enhance State Management

### 6.1 Create State Controllers
```bash
cd state/controllers
touch product_controller.dart stock_controller.dart
```

### 6.2 Implement Controllers
```dart
// state/controllers/product_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductController extends StateNotifier<ProductState> {
  ProductController() : super(ProductState.initial());
  
  void setFilter(ProductFilter filter) {
    state = state.copyWith(filter: filter);
    _reloadProducts();
  }
  
  void setSort(SortOption sort) {
    state = state.copyWith(sort: sort);
    _applySorting();
  }
}

final productControllerProvider = StateNotifierProvider<ProductController, ProductState>((ref) {
  return ProductController();
});
```

---

## 📝 STEP 7: Integrate Common Components

### 7.1 Replace Custom Implementations

#### BEFORE:
```dart
// Custom loading widget
Widget _buildLoading() {
  return Center(
    child: CircularProgressIndicator(),
  );
}
```

#### AFTER:
```dart
// Use common loading view
import '../../../../widgets/common/toss_loading_view.dart';

Widget _buildLoading() {
  return TossLoadingView();
}
```

### 7.2 Use Toss Components

#### Replace Cards:
```dart
// BEFORE
Card(
  child: content,
)

// AFTER
TossCard(
  child: content,
)
```

#### Replace Lists:
```dart
// BEFORE
ListTile(
  title: Text(product.name),
  subtitle: Text(product.sku),
)

// AFTER  
TossListTile(
  title: product.name,
  subtitle: product.sku,
)
```

---

## 📝 STEP 8: Add Core Utilities

### 8.1 Create Core Structure
```bash
mkdir -p core/constants core/utils
mv models/* core/models/
```

### 8.2 Create Utilities
```dart
// core/utils/inventory_formatting_utils.dart
class InventoryFormattingUtils {
  static String formatQuantity(int quantity) {
    // Format with commas
    return NumberFormat('#,##0').format(quantity);
  }
  
  static String formatPrice(double price, Currency currency) {
    // Format with currency symbol
    return '${currency.symbol}${NumberFormat('#,##0.00').format(price)}';
  }
}

// core/utils/stock_calculation_utils.dart
class StockCalculationUtils {
  static double calculateInventoryValue(List<Product> products) {
    return products.fold(0.0, (sum, product) => 
      sum + (product.onHand * product.costPrice));
  }
  
  static StockStatus getStockStatus(int onHand, int reorderPoint) {
    final percentage = (onHand / reorderPoint) * 100;
    if (percentage <= 10) return StockStatus.critical;
    if (percentage <= 30) return StockStatus.low;
    if (percentage <= 80) return StockStatus.optimal;
    return StockStatus.excess;
  }
}
```

---

## 📝 STEP 9: Testing & Verification

### 9.1 Test Each Component
```dart
// Test checklist
✅ Product listing works
✅ Search functionality works
✅ Filters apply correctly
✅ Sort options work
✅ Add product works
✅ Edit product works
✅ Delete product works
✅ Stock adjustment works
✅ Sales creation works
✅ Analytics display correctly
```

### 9.2 Performance Testing
```dart
// Measure before and after
print('Widget count before: ${debugWidgetCount}');
print('Memory usage before: ${debugMemoryUsage}');

// After optimization
print('Widget count after: ${debugWidgetCount}');  // Should be ~30% less
print('Memory usage after: ${debugMemoryUsage}');  // Should be ~25% less
```

---

## 📝 STEP 10: Final Cleanup

### 10.1 Update Imports
```bash
# Find and replace old imports
find . -name "*.dart" -exec sed -i 's/old_import/new_import/g' {} \;
```

### 10.2 Remove Unused Files
```bash
# Clean up
rm -rf inventory_management_backup  # After confirming everything works
rm *.corrupted
rm *.backup
```

### 10.3 Update Documentation
```markdown
# Update README with new structure
- Document new folder structure
- Update component usage examples
- Add migration notes
```

---

## ⚡ Quick Migration Script

```bash
#!/bin/bash
# quick_migrate.sh

echo "🚀 Starting Inventory Optimization..."

# Step 1: Create structure
echo "📁 Creating folder structure..."
mkdir -p business/{use_cases,validators}
mkdir -p data/services
mkdir -p presentation/widgets/{common,tabs,forms,displays,sheets,dialogs}
mkdir -p state/controllers
mkdir -p core/{constants,models,utils}

# Step 2: Move files
echo "📦 Moving files..."
mv models/* core/models/ 2>/dev/null
mv widgets/product_card.dart presentation/widgets/displays/ 2>/dev/null
mv widgets/filter_bottom_sheet.dart presentation/widgets/sheets/ 2>/dev/null

# Step 3: Clean up
echo "🧹 Cleaning up..."
rm inventory_management_page_v2.dart 2>/dev/null
rm -f *.backup *.corrupted

echo "✅ Structure created! Now implement the business logic."
```

---

## 🎯 Daily Progress Tracker

### Day 1 ✅
- [ ] Create business layer structure
- [ ] Implement inventory_coordinator.dart
- [ ] Create widget_factory.dart

### Day 2 ✅
- [ ] Reorganize presentation/widgets
- [ ] Create common widgets
- [ ] Extract tabs from main page

### Day 3 ✅
- [ ] Update main page to use coordinator
- [ ] Delete old versions
- [ ] Integrate Toss components

### Day 4 ✅
- [ ] Split inventory_service
- [ ] Implement service patterns
- [ ] Add caching

### Day 5 ✅
- [ ] Enhance state management
- [ ] Create controllers
- [ ] Test all functionality

---

## 🚨 Common Issues & Solutions

### Issue: Import errors after reorganization
```bash
# Solution: Update all imports
find . -name "*.dart" -exec grep -l "old_path" {} \; | xargs sed -i 's|old_path|new_path|g'
```

### Issue: State not updating
```dart
// Solution: Use ref.invalidate
ref.invalidate(inventoryStateProvider);
```

### Issue: Duplicate widget keys
```dart
// Solution: Use unique keys
key: ValueKey('product_${product.id}'),
```

---

## ✅ Final Verification Checklist

- [ ] All features working as before
- [ ] No console errors
- [ ] Performance improved (measure metrics)
- [ ] Code follows LEGO architecture
- [ ] Documentation updated
- [ ] Team review completed

---

## 📞 Need Help?

- Review `INVENTORY_OPTIMIZATION_GUIDE.md` for concepts
- Check `cash_ending/` for pattern examples
- Test incrementally, don't migrate all at once
- Keep backups until fully verified

---

**Remember**: The goal is to make the app **lighter** and **more maintainable** while keeping all functionality intact!