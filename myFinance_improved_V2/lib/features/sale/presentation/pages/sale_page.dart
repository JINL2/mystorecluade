import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../widgets/sale_search_bar.dart';
import '../widgets/sale_category_chips.dart';
import '../widgets/sale_product_card.dart';
import '../widgets/sale_cart_dock.dart';

/// Sale Page - POS Interface for product sales
/// Following Toss Design System principles
class SalePage extends ConsumerStatefulWidget {
  const SalePage({super.key});

  @override
  ConsumerState<SalePage> createState() => _SalePageState();
}

class _SalePageState extends ConsumerState<SalePage> {
  String _selectedCategory = 'All';
  final Map<String, int> _cartQuantities = {};

  // Sample product data
  final List<SaleProduct> _products = [
    SaleProduct(
      id: '1',
      name: 'Cappuccino',
      sku: '3679GZ5678910',
      price: 4.50,
      imageUrl: 'https://images.unsplash.com/photo-1643376961805-9f0c15a358f8?w=200',
      category: 'Drinks',
    ),
    SaleProduct(
      id: '2',
      name: 'Latte',
      sku: '3679GZ5678910',
      price: 4.80,
      imageUrl: 'https://images.unsplash.com/photo-1680489809506-d8def0e1631f?w=200',
      category: 'Drinks',
    ),
    SaleProduct(
      id: '3',
      name: 'Americano',
      sku: '3679GZ5678910',
      price: 3.80,
      imageUrl: 'https://images.unsplash.com/photo-1663683462505-c12f9445d2aa?w=200',
      category: 'Drinks',
    ),
    SaleProduct(
      id: '4',
      name: 'Butter Croissant',
      sku: '3679GZ5678910',
      price: 3.20,
      imageUrl: 'https://images.unsplash.com/photo-1733754348873-feeb45df3bab?w=200',
      category: 'Pastry',
    ),
    SaleProduct(
      id: '5',
      name: 'Blueberry Muffin',
      sku: '3679GZ5678910',
      price: 3.60,
      imageUrl: 'https://images.unsplash.com/photo-1722251172860-39856cdd3bcd?w=200',
      category: 'Pastry',
    ),
    SaleProduct(
      id: '6',
      name: 'Brand Mug',
      sku: '3679GZ5678910',
      price: 12.00,
      imageUrl: 'https://images.unsplash.com/photo-1588108757639-efca27ed0f7e?w=200',
      category: 'Merchandise',
    ),
    SaleProduct(
      id: '7',
      name: 'Pumpkin Spice Latte',
      sku: '3679GZ5678910',
      price: 5.20,
      imageUrl: 'https://images.unsplash.com/photo-1764679097000-0d424e3a4e37?w=200',
      category: 'Drinks',
    ),
    SaleProduct(
      id: '8',
      name: 'House Blend Beans',
      sku: '3679G5678910',
      price: 14.00,
      imageUrl: 'https://images.unsplash.com/photo-1685270386785-af1c6c3b0a2c?w=200',
      category: 'Merchandise',
    ),
  ];

  final List<String> _categories = [
    'All',
    'Recent Search',
    'Top Sale',
    'Bags',
    'Wallets',
    'Clothes',
    'Accessories',
  ];

  int get _totalItems {
    return _cartQuantities.values.fold(0, (sum, qty) => sum + qty);
  }

  double get _subtotal {
    double total = 0;
    _cartQuantities.forEach((productId, qty) {
      final product = _products.firstWhere((p) => p.id == productId);
      total += product.price * qty;
    });
    return total;
  }

  void _updateQuantity(String productId, int quantity) {
    setState(() {
      if (quantity <= 0) {
        _cartQuantities.remove(productId);
      } else {
        _cartQuantities[productId] = quantity;
      }
    });
  }

  void _addToCart(String productId) {
    setState(() {
      _cartQuantities[productId] = (_cartQuantities[productId] ?? 0) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.background,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              // Search and Category section
              _buildSearchAndCategories(),
              // Product list
              Expanded(
                child: _buildProductList(),
              ),
            ],
          ),
          // Sticky cart dock at bottom
          if (_totalItems > 0)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SaleCartDock(
                totalItems: _totalItems,
                subtotal: _subtotal,
                onCreateInvoice: () {
                  // Handle invoice creation
                },
              ),
            ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: TossColors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: TossColors.textPrimary,
          size: 22,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: Text(
        'Sale',
        style: TossTextStyles.titleMedium.copyWith(
          color: TossColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildSearchAndCategories() {
    return Container(
      color: TossColors.background,
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.paddingMD),
      child: Column(
        children: [
          const SizedBox(height: TossSpacing.space2),
          // Search bar
          const SaleSearchBar(),
          const SizedBox(height: TossSpacing.space2),
          // Category chips
          SaleCategoryChips(
            categories: _categories,
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),
          const SizedBox(height: TossSpacing.space2),
          // Divider
          Container(
            height: 1,
            color: TossColors.border,
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return ListView.builder(
      padding: EdgeInsets.only(
        left: TossSpacing.paddingMD,
        right: TossSpacing.paddingMD,
        top: TossSpacing.space1,
        bottom: _totalItems > 0 ? 160 : TossSpacing.space6,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        final quantity = _cartQuantities[product.id] ?? 0;

        return SaleProductCard(
          product: product,
          quantity: quantity,
          onQuantityChanged: (qty) => _updateQuantity(product.id, qty),
          onAddToCart: () => _addToCart(product.id),
        );
      },
    );
  }
}

/// Product model for sale
class SaleProduct {
  final String id;
  final String name;
  final String sku;
  final double price;
  final String imageUrl;
  final String category;

  const SaleProduct({
    required this.id,
    required this.name,
    required this.sku,
    required this.price,
    required this.imageUrl,
    required this.category,
  });
}
