# Inventory Management Pages Structure

## Essential Pages List

### 1. **invoice_page.dart** 
- Display list of invoices/sales
- Show subtotals and transaction details
- Filter by date, customer, status

### 2. **add_edit_product_page.dart**
- Add new products with SKU, barcode
- Upload product images
- Set pricing, categories, brands
- Manage stock levels

### 3. **product_detail_page.dart**
- View complete product information
- Stock history and movements
- Sales analytics for product
- Edit product details

### 4. **create_sale_page.dart**
- Process new sales/invoices
- Barcode scanning for quick add
- Customer selection
- Payment processing

### 5. **inventory_count_page.dart**
- Physical stock counting interface
- Batch count multiple products
- Variance reporting
- Adjustment processing

### 6. **purchase_order_page.dart**
- Create purchase orders
- Track incoming shipments
- Receive goods
- Update stock on receipt

### 7. **product_categories_page.dart**
- Manage product categories
- Hierarchical category structure
- Category-wise analytics

### 8. **brands_management_page.dart**
- Add/edit brands
- Brand-wise product listing
- Brand performance analytics

### 9. **inventory_analytics_page.dart**
- Stock valuation reports
- Sales trends
- Low stock alerts
- Turnover analysis

## Widget Components Needed

### Core Widgets
- `invoice_tile.dart` - Display invoice summary
- `product_list_tile.dart` - Product list item
- `count_item_card.dart` - Counting interface card
- `barcode_scanner.dart` - Barcode scanning widget
- `number_pad.dart` - Custom number input
- `stock_indicator.dart` - Visual stock level

### Dialog/Sheet Widgets
- `quick_sale_sheet.dart` - Fast checkout
- `stock_adjustment_dialog.dart` - Adjust stock
- `product_search_sheet.dart` - Product finder
- `payment_method_selector.dart` - Payment options

## Navigation Routes

```dart
/inventoryManagement                    // Main dashboard
/inventoryManagement/invoices           // Invoice list
/inventoryManagement/invoice/:id        // Invoice detail
/inventoryManagement/createSale         // New sale
/inventoryManagement/products           // Product list
/inventoryManagement/product/:id        // Product detail
/inventoryManagement/addProduct         // Add product
/inventoryManagement/editProduct/:id    // Edit product
/inventoryManagement/count              // Stock count
/inventoryManagement/count/:id          // Count detail
/inventoryManagement/purchaseOrders     // PO list
/inventoryManagement/purchaseOrder/:id  // PO detail
/inventoryManagement/categories         // Categories
/inventoryManagement/brands             // Brands
/inventoryManagement/analytics          // Reports
```