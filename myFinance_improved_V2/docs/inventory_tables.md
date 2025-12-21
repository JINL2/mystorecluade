# Inventory Management System Tables

## Overview
The inventory management system consists of 17 interconnected tables that handle product management, purchasing, receiving, sales, stock tracking, and FIFO costing.

## Core Inventory Tables

### 1. INVENTORY_PRODUCT_CATEGORIES
```sql
TABLE: inventory_product_categories
PURPOSE: Product categorization and hierarchy
PRIMARY_KEY: category_id (UUID)

COLUMNS:
- category_id: UUID, PK, DEFAULT: gen_random_uuid()
- company_id: UUID, NOT NULL, FK → companies.company_id
- category_name: VARCHAR(255), NOT NULL
- parent_category_id: UUID, NULL, FK → self (hierarchical)
- category_code: VARCHAR(50), NULL
- description: TEXT, NULL
- is_active: BOOLEAN, DEFAULT: true
- created_at: TIMESTAMP, DEFAULT: CURRENT_TIMESTAMP

BUSINESS_LOGIC:
- Supports hierarchical categories (parent-child)
- Company-specific categorization
```

### 2. INVENTORY_BRANDS
```sql
TABLE: inventory_brands
PURPOSE: Brand management for products
PRIMARY_KEY: brand_id (UUID)

COLUMNS:
- brand_id: UUID, PK, DEFAULT: gen_random_uuid()
- company_id: UUID, NOT NULL, FK → companies.company_id
- brand_name: VARCHAR(255), NOT NULL
- brand_code: VARCHAR(50), NULL
- is_active: BOOLEAN, DEFAULT: true
- created_at: TIMESTAMP, DEFAULT: CURRENT_TIMESTAMP
```

### 3. INVENTORY_PRODUCTS
```sql
TABLE: inventory_products
PURPOSE: Master product data
PRIMARY_KEY: product_id (UUID)

COLUMNS:
- product_id: UUID, PK, DEFAULT: gen_random_uuid()
- company_id: UUID, NOT NULL, FK → companies.company_id
- sku: VARCHAR(100), NOT NULL (Stock Keeping Unit)
- barcode: VARCHAR(100), NULL
- product_name: VARCHAR(255), NOT NULL
- product_name_en: VARCHAR(255), NULL
- category_id: UUID, NULL, FK → inventory_product_categories
- brand_id: UUID, NULL, FK → inventory_brands
- product_type: VARCHAR(20), DEFAULT: 'commodity'
  CHECK IN ('commodity','service','bundle')
- unit: VARCHAR(50), DEFAULT: 'piece'
- cost_price: NUMERIC(15,2), NULL
- selling_price: NUMERIC(15,2), NULL
- min_price: NUMERIC(15,2), NULL
- min_stock: NUMERIC(10,2), DEFAULT: 0
- max_stock: NUMERIC(10,2), NULL
- reorder_point: NUMERIC(10,2), NULL
- reorder_quantity: NUMERIC(10,2), NULL
- weight_g: INTEGER, NULL
- position: VARCHAR(100), NULL (warehouse location)
- is_active: BOOLEAN, DEFAULT: true
- is_deleted: BOOLEAN, DEFAULT: false
- created_at: TIMESTAMP, DEFAULT: CURRENT_TIMESTAMP
- updated_at: TIMESTAMP, DEFAULT: CURRENT_TIMESTAMP

UNIQUE CONSTRAINTS:
- (company_id, sku)
- (company_id, barcode) WHERE barcode IS NOT NULL
```

### 4. INVENTORY_CURRENT_STOCK
```sql
TABLE: inventory_current_stock
PURPOSE: Real-time stock levels by location
PRIMARY_KEY: stock_id (UUID)

COLUMNS:
- stock_id: UUID, PK, DEFAULT: gen_random_uuid()
- company_id: UUID, NOT NULL, FK → companies.company_id
- store_id: UUID, NULL, FK → stores.store_id
- product_id: UUID, NOT NULL, FK → inventory_products
- quantity_on_hand: NUMERIC(10,2), DEFAULT: 0
- quantity_available: NUMERIC(10,2), DEFAULT: 0
- quantity_reserved: NUMERIC(10,2), DEFAULT: 0
- average_cost: NUMERIC(15,4), NULL
- total_value: NUMERIC(15,2), NULL
- location_code: VARCHAR(50), NULL
- last_received_date: TIMESTAMP, NULL
- last_sold_date: TIMESTAMP, NULL
- last_counted_date: TIMESTAMP, NULL
- updated_at: TIMESTAMP, DEFAULT: CURRENT_TIMESTAMP

UNIQUE CONSTRAINTS:
- (company_id, store_id, product_id)

BUSINESS_LOGIC:
- quantity_available = quantity_on_hand - quantity_reserved
- total_value = quantity_on_hand * average_cost
```

### 5. INVENTORY_PURCHASE_ORDERS
```sql
TABLE: inventory_purchase_orders
PURPOSE: Purchase order management
PRIMARY_KEY: order_id (UUID)

COLUMNS:
- order_id: UUID, PK, DEFAULT: gen_random_uuid()
- company_id: UUID, NOT NULL, FK → companies.company_id
- order_number: VARCHAR(50), NOT NULL, UNIQUE
- supplier_id: UUID, NULL, FK → counterparties
- order_date: DATE, NOT NULL
- expected_date: DATE, NULL
- status: VARCHAR(20), DEFAULT: 'pending'
  CHECK IN ('pending','partial','complete','cancelled')
- total_amount: NUMERIC(15,2), NULL
- notes: TEXT, NULL
- created_by: UUID, NULL, FK → users.user_id
- created_at: TIMESTAMP, DEFAULT: CURRENT_TIMESTAMP
- updated_at: TIMESTAMP, DEFAULT: CURRENT_TIMESTAMP
```

### 6. INVENTORY_PURCHASE_ORDER_ITEMS
```sql
TABLE: inventory_purchase_order_items
PURPOSE: Purchase order line items
PRIMARY_KEY: item_id (UUID)

COLUMNS:
- item_id: UUID, PK, DEFAULT: gen_random_uuid()
- order_id: UUID, NOT NULL, FK → inventory_purchase_orders
- product_id: UUID, NOT NULL, FK → inventory_products
- quantity_ordered: NUMERIC(10,2), NOT NULL
- quantity_fulfilled: NUMERIC(10,2), DEFAULT: 0
- unit_price: NUMERIC(15,4), NULL
- total_amount: NUMERIC(15,2), NULL
- created_at: TIMESTAMP, DEFAULT: CURRENT_TIMESTAMP

BUSINESS_LOGIC:
- total_amount = quantity_ordered * unit_price
- Order complete when all items: quantity_fulfilled >= quantity_ordered
```

### 7. INVENTORY_SHIPMENTS
```sql
TABLE: inventory_shipments
PURPOSE: Track inbound shipments
PRIMARY_KEY: shipment_id (UUID)

COLUMNS:
- shipment_id: UUID, PK, DEFAULT: gen_random_uuid()
- order_id: UUID, NULL, FK → inventory_purchase_orders
- tracking_number: VARCHAR(100), NULL
- supplier_id: UUID, NULL, FK → counterparties
- shipped_date: TIMESTAMP, NULL
- expected_arrival: DATE, NULL
- status: VARCHAR(20), DEFAULT: 'preparing'
  CHECK IN ('preparing','in_transit','delivered','lost')
- created_at: TIMESTAMP, DEFAULT: CURRENT_TIMESTAMP
```

### 8. INVENTORY_RECEIPTS
```sql
TABLE: inventory_receipts
PURPOSE: Goods receiving records
PRIMARY_KEY: receipt_id (UUID)

COLUMNS:
- receipt_id: UUID, PK, DEFAULT: gen_random_uuid()
- receipt_number: VARCHAR(50), NOT NULL, UNIQUE
- shipment_id: UUID, NULL, FK → inventory_shipments
- received_date: TIMESTAMP, NOT NULL
- received_by: UUID, NULL, FK → users.user_id
- notes: TEXT, NULL
- created_at: TIMESTAMP, DEFAULT: CURRENT_TIMESTAMP
```

### 9. INVENTORY_SALES
```sql
TABLE: inventory_sales
PURPOSE: Sales transaction management
PRIMARY_KEY: sale_id (UUID)

COLUMNS:
- sale_id: UUID, PK, DEFAULT: gen_random_uuid()
- company_id: UUID, NOT NULL, FK → companies.company_id
- store_id: UUID, NULL, FK → stores.store_id
- invoice_number: VARCHAR(50), NOT NULL, UNIQUE
- customer_id: UUID, NULL, FK → counterparties
- sale_date: TIMESTAMP, NOT NULL
- payment_method: VARCHAR(50), NULL
- subtotal: NUMERIC(15,2), NULL
- tax_amount: NUMERIC(15,2), DEFAULT: 0
- discount_amount: NUMERIC(15,2), DEFAULT: 0
- total_amount: NUMERIC(15,2), NULL
- status: VARCHAR(20), DEFAULT: 'draft'
  CHECK IN ('draft','completed','cancelled')
- created_by: UUID, NULL, FK → users.user_id
- created_at: TIMESTAMP, DEFAULT: CURRENT_TIMESTAMP

BUSINESS_LOGIC:
- total_amount = subtotal + tax_amount - discount_amount
```

### 10. INVENTORY_SALE_ITEMS
```sql
TABLE: inventory_sale_items
PURPOSE: Sales transaction line items
PRIMARY_KEY: item_id (UUID)

COLUMNS:
- item_id: UUID, PK, DEFAULT: gen_random_uuid()
- sale_id: UUID, NOT NULL, FK → inventory_sales
- product_id: UUID, NOT NULL, FK → inventory_products
- quantity: NUMERIC(10,2), NOT NULL
- unit_price: NUMERIC(15,4), NOT NULL
- discount_percent: NUMERIC(5,2), DEFAULT: 0
- tax_percent: NUMERIC(5,2), DEFAULT: 0
- line_total: NUMERIC(15,2), NOT NULL
- created_at: TIMESTAMP, DEFAULT: CURRENT_TIMESTAMP

BUSINESS_LOGIC:
- line_total = quantity * unit_price * (1 - discount_percent/100) * (1 + tax_percent/100)
```

### 11. INVENTORY_COUNTS
```sql
TABLE: inventory_counts
PURPOSE: Physical inventory counting
PRIMARY_KEY: count_id (UUID)

COLUMNS:
- count_id: UUID, PK, DEFAULT: gen_random_uuid()
- company_id: UUID, NOT NULL, FK → companies.company_id
- store_id: UUID, NULL, FK → stores.store_id
- count_number: VARCHAR(50), NOT NULL, UNIQUE
- count_date: DATE, NOT NULL
- count_type: VARCHAR(20), DEFAULT: 'cycle'
  CHECK IN ('full','cycle','spot')
- status: VARCHAR(20), DEFAULT: 'in_progress'
  CHECK IN ('in_progress','completed','approved','cancelled')
- created_by: UUID, NULL, FK → users.user_id
- approved_by: UUID, NULL, FK → users.user_id
- notes: TEXT, NULL
- created_at: TIMESTAMP, DEFAULT: CURRENT_TIMESTAMP
```

### 12. INVENTORY_COUNT_ITEMS
```sql
TABLE: inventory_count_items
PURPOSE: Physical count details
PRIMARY_KEY: item_id (UUID)

COLUMNS:
- item_id: UUID, PK, DEFAULT: gen_random_uuid()
- count_id: UUID, NOT NULL, FK → inventory_counts
- product_id: UUID, NOT NULL, FK → inventory_products
- system_quantity: NUMERIC(10,2), NULL
- actual_quantity: NUMERIC(10,2), NULL
- difference: NUMERIC(10,2), GENERATED AS (actual_quantity - system_quantity)
- adjustment_reason: VARCHAR(255), NULL
- created_at: TIMESTAMP, DEFAULT: CURRENT_TIMESTAMP
```

### 13. INVENTORY_FLOW
```sql
TABLE: inventory_flow
PURPOSE: Complete inventory movement tracking
PRIMARY_KEY: flow_id (UUID)

COLUMNS:
- flow_id: UUID, PK, DEFAULT: gen_random_uuid()
- company_id: UUID, NOT NULL, FK → companies.company_id
- store_id: UUID, NULL, FK → stores.store_id
- product_id: UUID, NOT NULL, FK → inventory_products
- flow_type: VARCHAR(20), NULL
  CHECK IN ('order','ship','receive','sale','count','adjust','return_in','return_out','transfer')
- flow_direction: VARCHAR(10), NULL
  CHECK IN ('in','out','pending')
- quantity_change: NUMERIC(10,2), NOT NULL
- stock_before: NUMERIC(10,2), NULL
- stock_after: NUMERIC(10,2), NULL
- reference_type: VARCHAR(50), NULL
- reference_id: UUID, NULL
- unit_cost: NUMERIC(15,4), NULL
- total_value: NUMERIC(15,2), NULL
- notes: TEXT, NULL
- event_date: TIMESTAMP, DEFAULT: CURRENT_TIMESTAMP
- created_by: UUID, NULL, FK → users.user_id
- created_at: TIMESTAMP, DEFAULT: CURRENT_TIMESTAMP

BUSINESS_LOGIC:
- stock_after = stock_before + quantity_change
- Maintains complete audit trail of all inventory movements
```

### 14. INVENTORY_FIFO_LAYERS
```sql
TABLE: inventory_fifo_layers
PURPOSE: FIFO costing layers for inventory valuation
PRIMARY_KEY: layer_id (UUID)

COLUMNS:
- layer_id: UUID, PK, DEFAULT: gen_random_uuid()
- product_id: UUID, NOT NULL, FK → inventory_products
- receipt_id: UUID, NULL, FK → inventory_receipts
- quantity_original: NUMERIC(10,2), NOT NULL
- quantity_remaining: NUMERIC(10,2), NOT NULL
- unit_cost: NUMERIC(15,4), NOT NULL
- layer_date: TIMESTAMP, NOT NULL
- is_depleted: BOOLEAN, DEFAULT: false
- created_at: TIMESTAMP, DEFAULT: CURRENT_TIMESTAMP

BUSINESS_LOGIC:
- New receipts create new layers
- Sales deplete oldest layers first (FIFO)
- is_depleted = true when quantity_remaining = 0
```

## Inventory Business Processes

### Purchase Order Workflow
```sql
1. Create Purchase Order → status = 'pending'
2. Create Shipment → link to order
3. Receive Goods → create receipt
4. Update Order Items → quantity_fulfilled
5. Complete Order → status = 'complete'
```

### Stock Movement Flow
```sql
-- Every inventory transaction creates a flow record
INSERT INTO inventory_flow (
  company_id, store_id, product_id,
  flow_type, flow_direction, quantity_change,
  stock_before, stock_after, reference_type, reference_id
)

-- Update current stock
UPDATE inventory_current_stock
SET quantity_on_hand = quantity_on_hand + quantity_change,
    updated_at = NOW()
```

### FIFO Cost Calculation
```sql
-- Get weighted average cost from FIFO layers
SELECT 
  product_id,
  SUM(quantity_remaining * unit_cost) / SUM(quantity_remaining) as avg_cost
FROM inventory_fifo_layers
WHERE product_id = :product_id
  AND is_depleted = false
GROUP BY product_id
```

## Key Inventory Queries

### Stock Valuation Report
```sql
SELECT 
  p.sku,
  p.product_name,
  cs.quantity_on_hand,
  cs.average_cost,
  cs.total_value
FROM inventory_current_stock cs
JOIN inventory_products p ON cs.product_id = p.product_id
WHERE cs.company_id = :company_id
  AND cs.store_id = :store_id
ORDER BY cs.total_value DESC
```

### Low Stock Alert
```sql
SELECT 
  p.sku,
  p.product_name,
  cs.quantity_available,
  p.reorder_point,
  p.reorder_quantity
FROM inventory_current_stock cs
JOIN inventory_products p ON cs.product_id = p.product_id
WHERE cs.quantity_available <= p.reorder_point
  AND p.is_active = true
```

### Purchase Order Status
```sql
SELECT 
  po.order_number,
  po.status,
  COUNT(poi.item_id) as total_items,
  SUM(CASE WHEN poi.quantity_fulfilled >= poi.quantity_ordered 
       THEN 1 ELSE 0 END) as fulfilled_items
FROM inventory_purchase_orders po
JOIN inventory_purchase_order_items poi ON po.order_id = poi.order_id
GROUP BY po.order_id, po.order_number, po.status
```
